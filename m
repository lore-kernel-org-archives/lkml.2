Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2IUQzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2IUQzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:55:07 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Fix virqfd release race
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 10:55:06 -0600
Message-ID: <20120921165447.31205.6788.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfoi-pci supports a mechanism like KVM's irqfd for unmasking an
interrupt through an eventfd.  There are two ways to shutdown this
interface: 1) close the eventfd, 2) ioctl (such as disabling the
interrupt).  Both of these do the release through a workqueue,
which can result in a segfault if two jobs get queued for the same
virqfd.

Fix this by protecting the pointer to these virqfds by a spinlock.
The vfio pci device will therefore no longer have a reference to it
once the release job is queued under lock.  On the ioctl side, we
still flush the workqueue to ensure that any outstanding releases
are completed.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci_intrs.c |   76 +++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 211a492..d8dedc7 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -76,9 +76,24 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 			schedule_work(&virqfd->inject);
 	}
 
-	if (flags & POLLHUP)
-		/* The eventfd is closing, detach from VFIO */
-		virqfd_deactivate(virqfd);
+	if (flags & POLLHUP) {
+		unsigned long flags;
+		spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
+
+		/*
+		 * The eventfd is closing, if the virqfd has not yet been
+		 * queued for release, as determined by testing whether the
+		 * vdev pointer to it is still valid, queue it now.  As
+		 * with kvm irqfds, we know we won't race against the virqfd
+		 * going away because we hold wqh->lock to get here.
+		 */
+		if (*(virqfd->pvirqfd) == virqfd) {
+			*(virqfd->pvirqfd) = NULL;
+			virqfd_deactivate(virqfd);
+		}
+
+		spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
+	}
 
 	return 0;
 }
@@ -93,7 +108,6 @@ static void virqfd_ptable_queue_proc(struct file *file,
 static void virqfd_shutdown(struct work_struct *work)
 {
 	struct virqfd *virqfd = container_of(work, struct virqfd, shutdown);
-	struct virqfd **pvirqfd = virqfd->pvirqfd;
 	u64 cnt;
 
 	eventfd_ctx_remove_wait_queue(virqfd->eventfd, &virqfd->wait, &cnt);
@@ -101,7 +115,6 @@ static void virqfd_shutdown(struct work_struct *work)
 	eventfd_ctx_put(virqfd->eventfd);
 
 	kfree(virqfd);
-	*pvirqfd = NULL;
 }
 
 static void virqfd_inject(struct work_struct *work)
@@ -122,15 +135,11 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	int ret = 0;
 	unsigned int events;
 
-	if (*pvirqfd)
-		return -EBUSY;
-
 	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
 	if (!virqfd)
 		return -ENOMEM;
 
 	virqfd->pvirqfd = pvirqfd;
-	*pvirqfd = virqfd;
 	virqfd->vdev = vdev;
 	virqfd->handler = handler;
 	virqfd->thread = thread;
@@ -154,6 +163,23 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	virqfd->eventfd = ctx;
 
 	/*
+	 * virqfds can be released by closing the eventfd or directly
+	 * through ioctl.  These are both done through a workqueue, so
+	 * we update the pointer to the virqfd under lock to avoid
+	 * pushing multiple jobs to release the same virqfd.
+	 */
+	spin_lock_irq(&vdev->irqlock);
+
+	if (*pvirqfd) {
+		spin_unlock_irq(&vdev->irqlock);
+		ret = -EBUSY;
+		goto fail;
+	}
+	*pvirqfd = virqfd;
+
+	spin_unlock_irq(&vdev->irqlock);
+
+	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd.
 	 */
@@ -187,19 +213,29 @@ fail:
 		fput(file);
 
 	kfree(virqfd);
-	*pvirqfd = NULL;
 
 	return ret;
 }
 
-static void virqfd_disable(struct virqfd *virqfd)
+static void virqfd_disable(struct vfio_pci_device *vdev,
+			   struct virqfd **pvirqfd)
 {
-	if (!virqfd)
-		return;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->irqlock, flags);
+
+	if (*pvirqfd) {
+		virqfd_deactivate(*pvirqfd);
+		*pvirqfd = NULL;
+	}
 
-	virqfd_deactivate(virqfd);
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
-	/* Block until we know all outstanding shutdown jobs have completed. */
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed.
+	 * Even if we don't queue the job, flush the wq to be sure it's
+	 * been released.
+	 */
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
 
@@ -392,8 +428,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
 	vfio_intx_set_signal(vdev, -1);
-	virqfd_disable(vdev->ctx[0].unmask);
-	virqfd_disable(vdev->ctx[0].mask);
+	virqfd_disable(vdev, &vdev->ctx[0].unmask);
+	virqfd_disable(vdev, &vdev->ctx[0].mask);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
@@ -539,8 +575,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		virqfd_disable(vdev->ctx[i].unmask);
-		virqfd_disable(vdev->ctx[i].mask);
+		virqfd_disable(vdev, &vdev->ctx[i].unmask);
+		virqfd_disable(vdev, &vdev->ctx[i].mask);
 	}
 
 	if (msix) {
@@ -577,7 +613,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 					     vfio_send_intx_eventfd, NULL,
 					     &vdev->ctx[0].unmask, fd);
 
-		virqfd_disable(vdev->ctx[0].unmask);
+		virqfd_disable(vdev, &vdev->ctx[0].unmask);
 	}
 
 	return 0;

