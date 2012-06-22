Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711Ab2FVWRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:17:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab2FVWQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:16:59 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4/4][RFC] kvm: eoi_eventfd
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Fri, 22 Jun 2012 16:16:53 -0600
Message-ID: <20120622221626.9858.33817.stgit@bling.home>
In-Reply-To: <20120622220040.9858.43665.stgit@bling.home>
References: <20120622220040.9858.43665.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we're probably also going to need something like this.
When running in non-accelerated qemu, we're going to have to
create some kind of EOI notifier for drivers.  VFIO can make
additional improvements when running on KVM so it will probably
make use of the KVM_IRQFD_LEVEL_EOI interface, but we don't
want to have a generic EOI notifier in qemu that just stops
working when kvm-ioapic is enabled.  This is just a simple way
to register an eventfd using the existing KVM ack notifier.
I tried combining the ack notifier of the LEVEL_EOI interface
into this one, but it didn't work out well.  The code complexity
goes up a lot.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   14 ++++++
 arch/x86/kvm/x86.c                |    1 
 include/linux/kvm.h               |   12 +++++
 include/linux/kvm_host.h          |    7 +++
 virt/kvm/eventfd.c                |   89 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c               |    9 ++++
 6 files changed, 132 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 2f8a0aa..69b1747 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1998,6 +1998,20 @@ matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
 De-assigning automatically de-asserts the interrupt line setup through
 this interface.
 
+4.77 KVM_EOI_EVENTFD
+
+Capability: KVM_CAP_EOI_EVENTFD
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_eoi_eventfd (in)
+Returns: 0 on success, -1 on error
+
+This interface allows userspace to be notified through an eventfd for
+EOI writes to the in-kernel irqchip.  kvm_eoi_eventfd.fd specifies
+the eventfd to signal on EOI to kvm_eoi_eventfd.gsi.  To disable,
+use KVM_EOI_EVENTFD_FLAG_DEASSIGN and specify both the original fd
+and gsi.
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20a51fe..00118b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2149,6 +2149,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_IRQFD_LEVEL_EOI:
+	case KVM_CAP_EOI_EVENTFD:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a916186..a8a7fa3 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -619,6 +619,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
 #define KVM_CAP_IRQFD_LEVEL_EOI 81
+#define KVM_CAP_EOI_EVENTFD 82
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -755,6 +756,15 @@ struct kvm_msi {
 	__u8  pad[16];
 };
 
+#define KVM_EOI_EVENTFD_FLAG_DEASSIGN (1 << 0)
+
+struct kvm_eoi_eventfd {
+	__u32 fd;
+	__u32 gsi;
+	__u32 flags;
+	__u8 pad[20];
+};
+
 /*
  * ioctls for VM fds
  */
@@ -908,6 +918,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
 /* VM is being stopped by host */
 #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
+/* Available with KVM_CAP_EOI_EVENTFD */
+#define KVM_EOI_EVENTFD           _IOW(KVMIO,  0xae, struct kvm_eoi_eventfd)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae3b426..97fbe21 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -285,6 +285,7 @@ struct kvm {
 		struct list_head  items;
 	} irqfds;
 	struct list_head ioeventfds;
+	struct list_head eoi_eventfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -828,6 +829,7 @@ int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
 void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
+int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi_eventfd *args);
 
 #else
 
@@ -853,6 +855,11 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	return -ENOSYS;
 }
 
+static inline int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi_eventfd *args)
+{
+	return -ENOSYS;
+}
+
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2bc7275..a01e377 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -358,6 +358,7 @@ kvm_eventfd_init(struct kvm *kvm)
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
 	INIT_LIST_HEAD(&kvm->ioeventfds);
+	INIT_LIST_HEAD(&kvm->eoi_eventfds);
 }
 
 /*
@@ -733,3 +734,91 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 	return kvm_assign_ioeventfd(kvm, args);
 }
+
+/*
+ * --------------------------------------------------------------------
+ *  eoi_eventfd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
+ *
+ *  userspace can register GSIs with an eventfd for receiving
+ *  notification when an EOI occurs.
+ * --------------------------------------------------------------------
+ */
+
+struct _eoi_eventfd {
+	struct kvm *kvm;
+	struct eventfd_ctx *eventfd;
+	struct kvm_irq_ack_notifier notifier;
+	struct list_head list;
+};
+
+static void kvm_eoi_eventfd_acked(struct kvm_irq_ack_notifier *notifier)
+{
+	struct _eoi_eventfd *eoifd;
+
+	eoifd = container_of(notifier, struct _eoi_eventfd, notifier);
+
+	eventfd_signal(eoifd->eventfd, 1);
+}
+
+static int kvm_assign_eoi_eventfd(struct kvm *kvm, struct kvm_eoi_eventfd *args)
+{
+	struct eventfd_ctx *eventfd;
+	struct _eoi_eventfd *eoifd;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
+	if (!eoifd) {
+		eventfd_ctx_put(eventfd);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&eoifd->list);
+	eoifd->kvm = kvm;
+	eoifd->eventfd = eventfd;
+	eoifd->notifier.gsi = args->gsi;
+	eoifd->notifier.irq_acked = kvm_eoi_eventfd_acked;
+
+	list_add_tail(&eoifd->list, &kvm->eoi_eventfds);
+	kvm_register_irq_ack_notifier(kvm, &eoifd->notifier);
+
+	return 0;
+}
+static int kvm_deassign_eoi_eventfd(struct kvm *kvm,
+				   struct kvm_eoi_eventfd *args)
+{
+	struct eventfd_ctx *eventfd;
+	struct _eoi_eventfd *eoifd, *tmp;
+	int ret = -ENOENT;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	list_for_each_entry_safe(eoifd, tmp, &kvm->eoi_eventfds, list) {
+		if (eoifd->eventfd != eventfd ||
+		    eoifd->notifier.gsi != args->gsi)
+			continue;
+
+		kvm_unregister_irq_ack_notifier(kvm, &eoifd->notifier);
+		eventfd_ctx_put(eoifd->eventfd);
+		list_del(&eoifd->list);
+		kfree(eoifd);
+		ret = 0;
+		break;
+	}
+
+	eventfd_ctx_put(eventfd);
+
+	return ret;
+}
+
+int kvm_eoi_eventfd(struct kvm *kvm, struct kvm_eoi_eventfd *args)
+{
+	if (args->flags & KVM_EOI_EVENTFD_FLAG_DEASSIGN)
+		return kvm_deassign_eoi_eventfd(kvm, args);
+
+	return kvm_assign_eoi_eventfd(kvm, args);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4ad14cc..20508c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2093,6 +2093,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_EOI_EVENTFD: {
+		struct kvm_eoi_eventfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_eoi_eventfd(kvm, &data);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 		if (r == -ENOTTY)

