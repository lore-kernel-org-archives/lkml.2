Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab0J2OwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab0J2OwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:52:23 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: Create an eventfd mechanism for EOIs to get to userspace
To: linux-kernel@vger.kernel.org, avi@redhat.com
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mst@redhat.com,
        chrisw@redhat.com
Date: Fri, 29 Oct 2010 08:52:21 -0600
Message-ID: <20101029145126.26039.16101.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support VFIO based device assignment, we need to be able to get
an EOI out of the KVM irqchip.  This introduces a mechanism to do
that by registering an eventfd to be signaled when the IRQ is ACKed.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm.h      |   13 ++++++
 include/linux/kvm_host.h |    6 +++
 virt/kvm/eventfd.c       |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |    8 ++++
 4 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..92d5b27 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_EOI_EVENTFD 60
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -620,6 +621,16 @@ struct kvm_clock_data {
 	__u32 pad[9];
 };
 
+#define KVM_EOI_EVENTFD_FLAG_DEASSIGN (1 << 0)
+#define KVM_EOI_EVENTFD_FLAG_DEASSERT (1 << 1)
+
+struct kvm_eoi {
+	__u32 fd;
+	__u32 gsi;
+	__u32 flags;
+	__u8  pad[20];
+};
+
 /*
  * ioctls for VM fds
  */
@@ -677,6 +688,8 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
+/* Available with KVM_CAP_EOI_EVENTFD */
+#define KVM_EOI_EVENTFD           _IOW(KVMIO,  0xa2, struct kvm_eoi)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ee4314e..5d50a7e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -227,6 +227,7 @@ struct kvm {
 		struct list_head  items;
 	} irqfds;
 	struct list_head ioeventfds;
+	struct list_head eoi_eventfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -643,6 +644,7 @@ void kvm_eventfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
+int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi *eoi);
 
 #else
 
@@ -658,6 +660,10 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	return -ENOSYS;
 }
 
+static inline int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi *eoi)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c1f1e3c..3dbfb21 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -253,6 +253,7 @@ kvm_eventfd_init(struct kvm *kvm)
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
 	INIT_LIST_HEAD(&kvm->ioeventfds);
+	INIT_LIST_HEAD(&kvm->eoi_eventfds);
 }
 
 /*
@@ -586,3 +587,97 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 	return kvm_assign_ioeventfd(kvm, args);
 }
+
+/*
+ * --------------------------------------------------------------------
+ *  eoi_eventfd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
+ *
+ *  userspace can register GSIs with an eventfd for receiving notification
+ *  when an EOI occurs.
+ * --------------------------------------------------------------------
+ */
+
+struct _eoi_eventfd {
+	struct list_head            list;
+	struct kvm                  *kvm;
+	struct eventfd_ctx          *eventfd;
+	bool                        deassert;
+	struct kvm_irq_ack_notifier notifier;
+};
+
+static void kvm_eoi_eventfd_acked(struct kvm_irq_ack_notifier *notifier)
+{
+	struct _eoi_eventfd *p;
+
+	p = container_of(notifier, struct _eoi_eventfd, notifier);
+
+	if (p->deassert)
+		kvm_set_irq(p->kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
+			    notifier->gsi, 0);
+
+	eventfd_signal(p->eventfd, 1);
+}
+
+static int kvm_assign_eoi_eventfd(struct kvm *kvm, struct kvm_eoi *eoi)
+{
+	struct eventfd_ctx *eventfd;
+	struct _eoi_eventfd *p;
+
+	eventfd = eventfd_ctx_fdget(eoi->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		eventfd_ctx_put(eventfd);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&p->list);
+	p->kvm = kvm;
+	p->eventfd = eventfd;
+	p->deassert = !!(eoi->flags & KVM_EOI_EVENTFD_FLAG_DEASSERT);
+
+	p->notifier.gsi = eoi->gsi;
+	p->notifier.irq_acked = kvm_eoi_eventfd_acked;
+
+	list_add_tail(&p->list, &kvm->eoi_eventfds);
+	kvm_register_irq_ack_notifier(kvm, &p->notifier);
+
+	return 0;
+}
+
+static int kvm_deassign_eoi_eventfd(struct kvm *kvm, struct kvm_eoi *eoi)
+{
+	struct eventfd_ctx *eventfd;
+	struct _eoi_eventfd *p, *tmp;
+	int ret = -ENOENT;
+
+	eventfd = eventfd_ctx_fdget(eoi->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	list_for_each_entry_safe(p, tmp, &kvm->eoi_eventfds, list) {
+		if (p->eventfd != eventfd || p->notifier.gsi != eoi->gsi)
+			continue;
+
+		kvm_unregister_irq_ack_notifier(kvm, &p->notifier);
+		eventfd_ctx_put(p->eventfd);
+		list_del(&p->list);
+		kfree(p);
+		ret = 0;
+		break;
+	}
+
+	eventfd_ctx_put(eventfd);
+
+	return ret;
+}
+
+int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi *eoi)
+{
+	if (eoi->flags & KVM_EOI_EVENTFD_FLAG_DEASSIGN)
+		return kvm_deassign_eoi_eventfd(kvm, eoi);
+
+	return kvm_assign_eoi_eventfd(kvm, eoi);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88d869e..7ca6f13 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1807,6 +1807,14 @@ static long kvm_vm_ioctl(struct file *filp,
 		mutex_unlock(&kvm->lock);
 		break;
 #endif
+	case KVM_EOI_EVENTFD: {
+		struct kvm_eoi eoi;
+		r = -EFAULT;
+		if (copy_from_user(&eoi, argp, sizeof eoi))
+			goto out;
+		r = kvm_eoi_eventfd(kvm, &eoi);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 		if (r == -ENOTTY)

