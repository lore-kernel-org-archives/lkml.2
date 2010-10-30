Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab0J3RAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 13:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab0J3RAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 13:00:01 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5/5] vfio: Add a new ioctl to support EOI via eventfd
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:59:59 -0600
Message-ID: <20101030165954.885.15406.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
References: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This creates a new ioctl to register an eventfd to trigger an EOI.
When used for device assignment with KVM, this means we can directly
connect the EOI eventfd out of KVM into VFIO, completely bypassing
userspace.  This is identical to the irqfd mechanism in KVM, which is
where most of this code originated.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_intrs.c |  172 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c  |    8 ++
 include/linux/vfio.h      |    9 ++
 3 files changed, 189 insertions(+), 0 deletions(-)

diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
index 4d5a7f8..604082c 100644
--- a/drivers/vfio/vfio_intrs.c
+++ b/drivers/vfio/vfio_intrs.c
@@ -36,6 +36,10 @@
 #include <linux/eventfd.h>
 #include <linux/pci.h>
 #include <linux/mmu_notifier.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include <linux/vfio.h>
 
@@ -121,6 +125,174 @@ int vfio_irq_eoi(struct vfio_dev *vdev)
 	return 0;
 }
 
+struct eoi_eventfd {
+	struct vfio_dev		*vdev;
+	struct eventfd_ctx	*eventfd;
+	poll_table		pt;
+	wait_queue_t		wait;
+	struct work_struct	inject;
+	struct work_struct	shutdown;
+};
+
+static struct workqueue_struct *eoi_cleanup_wq;
+
+static void inject_eoi(struct work_struct *work)
+{
+	struct eoi_eventfd *ev_eoi = container_of(work, struct eoi_eventfd,
+						  inject);
+	vfio_irq_eoi(ev_eoi->vdev);
+}
+
+static void shutdown_eoi(struct work_struct *work)
+{
+	u64 cnt;
+	struct eoi_eventfd *ev_eoi = container_of(work, struct eoi_eventfd,
+						  shutdown);
+	struct vfio_dev *vdev = ev_eoi->vdev;
+
+	eventfd_ctx_remove_wait_queue(ev_eoi->eventfd, &ev_eoi->wait, &cnt);
+	flush_work(&ev_eoi->inject);
+	eventfd_ctx_put(ev_eoi->eventfd);
+	kfree(vdev->ev_eoi);
+	vdev->ev_eoi = NULL;
+}
+
+static void deactivate_eoi(struct eoi_eventfd *ev_eoi)
+{
+	queue_work(eoi_cleanup_wq, &ev_eoi->shutdown);
+}
+
+static int wakeup_eoi(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct eoi_eventfd *ev_eoi = container_of(wait, struct eoi_eventfd,
+						  wait);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLIN)
+		/* An event has been signaled, inject an interrupt */
+		schedule_work(&ev_eoi->inject);
+
+	if (flags & POLLHUP)
+		/* The eventfd is closing, detach from VFIO */
+		deactivate_eoi(ev_eoi);
+
+	return 0;
+}
+
+static void
+eoi_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct eoi_eventfd *ev_eoi = container_of(pt, struct eoi_eventfd, pt);
+	add_wait_queue(wqh, &ev_eoi->wait);
+}
+
+static int vfio_irq_eoi_eventfd_enable(struct vfio_dev *vdev, int fd)
+{
+	struct file *file = NULL;
+	struct eventfd_ctx *eventfd = NULL;
+	struct eoi_eventfd *ev_eoi;
+	int ret = 0;
+	unsigned int events;
+
+	if (vdev->ev_eoi)
+		return -EBUSY;
+
+	ev_eoi = kzalloc(sizeof(struct eoi_eventfd), GFP_KERNEL);
+	if (!ev_eoi)
+		return -ENOMEM;
+
+	vdev->ev_eoi = ev_eoi;
+	ev_eoi->vdev = vdev;
+
+	INIT_WORK(&ev_eoi->inject, inject_eoi);
+	INIT_WORK(&ev_eoi->shutdown, shutdown_eoi);
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	ev_eoi->eventfd = eventfd;
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd
+	 */
+	init_waitqueue_func_entry(&ev_eoi->wait, wakeup_eoi);
+	init_poll_funcptr(&ev_eoi->pt, eoi_ptable_queue_proc);
+
+	events = file->f_op->poll(file, &ev_eoi->pt);
+
+	/*
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered, and trigger it as if we didn't miss it.
+	 */
+	if (events & POLLIN)
+		schedule_work(&ev_eoi->inject);
+
+	/*
+	 * do not drop the file until the irqfd is fully initialized, otherwise
+	 * we might race against the POLLHUP
+	 */
+	fput(file);
+
+	return 0;
+
+fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+
+	if (!IS_ERR(file))
+		fput(file);
+
+	return ret;
+}
+
+static int vfio_irq_eoi_eventfd_disable(struct vfio_dev *vdev, int fd)
+{
+	if (!vdev->ev_eoi)
+		return -ENODEV;
+
+	deactivate_eoi(vdev->ev_eoi);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * so that we guarantee there will not be any more interrupts on this
+	 * gsi once this deassign function returns.
+	 */
+	flush_workqueue(eoi_cleanup_wq);
+
+	return 0;
+}
+
+int vfio_irq_eoi_eventfd(struct vfio_dev *vdev, int fd)
+{
+	if (fd < 0)
+		return vfio_irq_eoi_eventfd_disable(vdev, fd);
+	return vfio_irq_eoi_eventfd_enable(vdev, fd);
+}
+
+int __init vfio_eoi_module_init(void)
+{
+	eoi_cleanup_wq = create_singlethread_workqueue("vfio-eoi-cleanup");
+	if (!eoi_cleanup_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void __exit vfio_eoi_module_exit(void)
+{
+	destroy_workqueue(eoi_cleanup_wq);
+}
+
 /*
  * MSI and MSI-X Interrupt handler.
  * Just signal an event
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index cf2e671..3cd3cb8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -469,6 +469,12 @@ static long vfio_unl_ioctl(struct file *filep,
 		ret = vfio_irq_eoi(vdev);
 		break;
 
+	case VFIO_IRQ_EOI_EVENTFD:
+		if (copy_from_user(&fd, uarg, sizeof fd))
+			return -EFAULT;
+		ret = vfio_irq_eoi_eventfd(vdev, fd);
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -774,6 +780,7 @@ static int __init init(void)
 	vfio_class_init();
 	vfio_nl_init();
 	register_pm_notifier(&vfio_pm_nb);
+	vfio_eoi_module_init();
 	return pci_register_driver(&driver);
 }
 
@@ -782,6 +789,7 @@ static void __exit cleanup(void)
 	if (vfio_major >= 0)
 		unregister_chrdev(vfio_major, "vfio");
 	pci_unregister_driver(&driver);
+	vfio_eoi_module_exit();
 	unregister_pm_notifier(&vfio_pm_nb);
 	unregister_pm_notifier(&vfio_pm_nb);
 	vfio_nl_exit();
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f7e51ff..c26f3b3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -43,6 +43,7 @@ struct vfio_nl_client {
 };
 
 struct perm_bits;
+struct eoi_eventfd;
 struct vfio_dev {
 	struct device	*dev;
 	struct pci_dev	*pdev;
@@ -79,6 +80,7 @@ struct vfio_dev {
 	struct perm_bits	*msi_perm;
 	bool		pci_2_3;
 	bool		irq_disabled;
+	struct eoi_eventfd	*ev_eoi;
 };
 
 struct vfio_listener {
@@ -158,6 +160,9 @@ void vfio_error_resume(struct pci_dev *);
 
 irqreturn_t vfio_interrupt(int, void *);
 int vfio_irq_eoi(struct vfio_dev *);
+int vfio_irq_eoi_eventfd(struct vfio_dev *, int);
+int vfio_eoi_module_init(void);
+void vfio_eoi_module_exit(void);
 
 #endif	/* __KERNEL__ */
 
@@ -203,6 +208,10 @@ struct vfio_dma_map {
 
 /* Re-enable INTx */
 #define	VFIO_IRQ_EOI		_IO(';', 109)
+
+/* Re-enable INTx via eventfd */
+#define	VFIO_IRQ_EOI_EVENTFD	_IOW(';', 110, int)
+
 /*
  * Reads, writes, and mmaps determine which PCI BAR (or config space)
  * from the high level bits of the file offset

