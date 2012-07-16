Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2GPUeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:34:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2GPUd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:33:58 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v5 2/4] kvm: KVM_EOIFD, an eventfd for EOIs
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Mon, 16 Jul 2012 14:33:55 -0600
Message-ID: <20120716203353.1752.19127.stgit@bling.home>
In-Reply-To: <20120716202711.1752.71007.stgit@bling.home>
References: <20120716202711.1752.71007.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new ioctl enables an eventfd to be triggered when an EOI is
written for a specified irqchip pin.  The first user of this will
be external device assignment through VFIO, using a level irqfd
for asserting a PCI INTx interrupt and this interface for de-assert
and notification once the interrupt is serviced.

Here we make use of the reference counting of the _irq_source
object allowing us to share it with an irqfd and cleanup regardless
of the release order.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   22 +++
 arch/x86/kvm/x86.c                |    2 
 include/linux/kvm.h               |   15 ++
 include/linux/kvm_host.h          |   13 ++
 virt/kvm/eventfd.c                |  239 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c               |   11 ++
 6 files changed, 300 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index c7267d5..9761f78 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1988,6 +1988,28 @@ to independently assert level interrupts.  The KVM_IRQFD_FLAG_LEVEL
 is only necessary on setup, teardown is identical to that above.
 KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
 
+4.77 KVM_EOIFD
+
+Capability: KVM_CAP_EOIFD
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_eoifd (in)
+Returns: 0 on success, -1 on error
+
+KVM_EOIFD allows userspace to receive interrupt EOI notification
+through an eventfd.  kvm_eoifd.fd specifies the eventfd used for
+notification.  KVM_EOIFD_FLAG_DEASSIGN is used to de-assign an eoifd
+once assigned.  KVM_EOIFD also requires additional bits set in
+kvm_eoifd.flags to bind to the proper interrupt line.  The
+KVM_EOIFD_FLAG_LEVEL_IRQFD indicates that kvm_eoifd.irqfd is provided
+and is an irqfd for a level triggered interrupt (configured from
+KVM_IRQFD using KVM_IRQFD_FLAG_LEVEL).  The EOI notification is bound
+to the same GSI and irqchip input as the irqfd.  Both kvm_eoifd.irqfd
+and KVM_EOIFD_FLAG_LEVEL_IRQFD must be specified both on assignment
+and de-assignment of KVM_EOIFD.  A level irqfd may only be bound to
+a single eoifd.  KVM_CAP_EOIFD_LEVEL_IRQFD indicates support of
+KVM_EOIFD_FLAG_LEVEL_IRQFD.
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80bed07..cc47e31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2149,6 +2149,8 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_IRQFD_LEVEL:
+	case KVM_CAP_EOIFD:
+	case KVM_CAP_EOIFD_LEVEL_IRQFD:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b2e6e4f..5ca887d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -619,6 +619,8 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
 #define KVM_CAP_IRQFD_LEVEL 81
+#define KVM_CAP_EOIFD 82
+#define KVM_CAP_EOIFD_LEVEL_IRQFD 83
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -694,6 +696,17 @@ struct kvm_irqfd {
 	__u8  pad[20];
 };
 
+#define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
+/* Available with KVM_CAP_EOIFD_LEVEL_IRQFD */
+#define KVM_EOIFD_FLAG_LEVEL_IRQFD (1 << 1)
+
+struct kvm_eoifd {
+	__u32 fd;
+	__u32 flags;
+	__u32 irqfd;
+	__u8 pad[20];
+};
+
 struct kvm_clock_data {
 	__u64 clock;
 	__u32 flags;
@@ -834,6 +847,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
 /* Available with KVM_CAP_PPC_ALLOC_HTAB */
 #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
+/* Available with KVM_CAP_EOIFD */
+#define KVM_EOIFD                 _IOW(KVMIO,  0xa8, struct kvm_eoifd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae3b426..a7661c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -285,6 +285,10 @@ struct kvm {
 		struct list_head  items;
 	} irqfds;
 	struct list_head ioeventfds;
+	struct {
+		struct mutex lock;
+		struct list_head items;
+	} eoifds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -828,6 +832,8 @@ int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
 void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
+int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args);
+void kvm_eoifd_release(struct kvm *kvm);
 
 #else
 
@@ -853,6 +859,13 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	return -ENOSYS;
 }
 
+static inline int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
+{
+	return -ENOSYS;
+}
+
+static inline void kvm_eoifd_release(struct kvm *kvm) {}
+
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index ecdbfea..1f9412a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -65,8 +65,7 @@ static void _irq_source_put(struct _irq_source *source)
 		kref_put(&source->kref, _irq_source_release);
 }
 
-static struct _irq_source *__attribute__ ((used)) /* white lie for now */
-_irq_source_get(struct _irq_source *source)
+static struct _irq_source *_irq_source_get(struct _irq_source *source)
 {
 	if (source)
 		kref_get(&source->kref);
@@ -123,6 +122,39 @@ struct _irqfd {
 	struct work_struct shutdown;
 };
 
+static struct _irqfd *_irqfd_fdget_lock(struct kvm *kvm, int fd)
+{
+	struct eventfd_ctx *eventfd;
+	struct _irqfd *tmp, *irqfd = NULL;
+
+	eventfd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(eventfd))
+		return (struct _irqfd *)eventfd;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
+		if (tmp->eventfd == eventfd) {
+			irqfd = tmp;
+			break;
+		}
+	}
+
+	if (!irqfd) {
+		spin_unlock_irq(&kvm->irqfds.lock);
+		eventfd_ctx_put(eventfd);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return irqfd;
+}
+
+static void _irqfd_put_unlock(struct _irqfd *irqfd)
+{
+	eventfd_ctx_put(irqfd->eventfd);
+	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
+}
+
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
@@ -398,6 +430,8 @@ kvm_eventfd_init(struct kvm *kvm)
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
 	INIT_LIST_HEAD(&kvm->ioeventfds);
+	mutex_init(&kvm->eoifds.lock);
+	INIT_LIST_HEAD(&kvm->eoifds.items);
 }
 
 /*
@@ -764,3 +798,204 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 	return kvm_assign_ioeventfd(kvm, args);
 }
+
+/*
+ * --------------------------------------------------------------------
+ *  eoifd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
+ *
+ *  userspace can register with an eventfd for receiving
+ *  notification when an EOI occurs.
+ * --------------------------------------------------------------------
+ */
+
+struct _eoifd {
+	/* eventfd triggered on EOI */
+	struct eventfd_ctx *eventfd;
+	/* irq source ID de-asserted on EOI */
+	struct _irq_source *source;
+	struct kvm *kvm;
+	struct kvm_irq_ack_notifier notifier;
+	/* reference to irqfd eventfd for de-assign matching */
+	struct eventfd_ctx *level_irqfd;
+	struct list_head list;
+};
+
+static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
+{
+	struct _eoifd *eoifd;
+
+	eoifd = container_of(notifier, struct _eoifd, notifier);
+
+	/*
+	 * Ack notifier is per GSI, which may be shared with others.
+	 * Only de-assert and send EOI if our source ID is asserted.
+	 * User needs to re-assert if device still requires service.
+	 */
+	spin_lock(&eoifd->source->lock);
+	if (eoifd->source->level_asserted) {
+		kvm_set_irq(eoifd->kvm,
+			    eoifd->source->id, eoifd->notifier.gsi, 0);
+		eoifd->source->level_asserted = false;
+		eventfd_signal(eoifd->eventfd, 1);
+	}
+	spin_unlock(&eoifd->source->lock);
+}
+
+static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
+{
+	struct eventfd_ctx *level_irqfd = NULL, *eventfd = NULL;
+	struct _eoifd *eoifd = NULL, *tmp;
+	struct _irq_source *source = NULL;
+	unsigned gsi;
+	int ret;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
+	if (!eoifd) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
+		struct _irqfd *irqfd = _irqfd_fdget_lock(kvm, args->irqfd);
+		if (IS_ERR(irqfd)) {
+			ret = PTR_ERR(irqfd);
+			goto fail;
+		}
+
+		gsi = irqfd->gsi;
+		level_irqfd = eventfd_ctx_get(irqfd->eventfd);
+		source = _irq_source_get(irqfd->source);
+		_irqfd_put_unlock(irqfd);
+		if (!source) {
+			ret = -EINVAL;
+			goto fail;
+		}
+	} else {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	INIT_LIST_HEAD(&eoifd->list);
+	eoifd->kvm = kvm;
+	eoifd->eventfd = eventfd;
+	eoifd->source = source;
+	eoifd->level_irqfd = level_irqfd;
+	eoifd->notifier.gsi = gsi;
+	eoifd->notifier.irq_acked = eoifd_event;
+
+	mutex_lock(&kvm->eoifds.lock);
+
+	/*
+	 * Enforce a one-to-one relationship between irqfd and eoifd so
+	 * that this interface can't be used to consume all kernel memory.
+	 * NB. single eventfd can still be used by multiple eoifds.
+	 */
+	list_for_each_entry(tmp, &kvm->eoifds.items, list) {
+		if (tmp->level_irqfd == eoifd->level_irqfd) {
+			mutex_unlock(&kvm->eoifds.lock);
+			ret = -EBUSY;
+			goto fail;
+		}
+	}
+
+	list_add_tail(&eoifd->list, &kvm->eoifds.items);
+	kvm_register_irq_ack_notifier(kvm, &eoifd->notifier);
+
+	mutex_unlock(&kvm->eoifds.lock);
+
+	return 0;
+
+fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+	kfree(eoifd);
+	if (level_irqfd)
+		eventfd_ctx_put(level_irqfd);
+	_irq_source_put(source);
+	return ret;
+}
+
+static void eoifd_destroy(struct kvm *kvm, struct _eoifd *eoifd)
+{
+	list_del(&eoifd->list);
+	kvm_unregister_irq_ack_notifier(kvm, &eoifd->notifier);
+	_irq_source_put(eoifd->source);
+	eventfd_ctx_put(eoifd->eventfd);
+	eventfd_ctx_put(eoifd->level_irqfd);
+	kfree(eoifd);
+}
+
+void kvm_eoifd_release(struct kvm *kvm)
+{
+	struct _eoifd *tmp, *eoifd;
+
+	mutex_lock(&kvm->eoifds.lock);
+
+	list_for_each_entry_safe(eoifd, tmp, &kvm->eoifds.items, list)
+		eoifd_destroy(kvm, eoifd);
+
+	mutex_unlock(&kvm->eoifds.lock);
+}
+
+static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
+{
+	struct eventfd_ctx *eventfd = NULL, *level_irqfd = NULL;
+	struct _eoifd *eoifd;
+	int ret = -ENOENT;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
+		level_irqfd = eventfd_ctx_fdget(args->irqfd);
+		if (IS_ERR(level_irqfd)) {
+			ret = PTR_ERR(level_irqfd);
+			goto fail;
+		}
+	} else {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	mutex_lock(&kvm->eoifds.lock);
+
+	list_for_each_entry(eoifd, &kvm->eoifds.items, list) {
+		if (eoifd->eventfd == eventfd &&
+		    eoifd->level_irqfd == level_irqfd) {
+			eoifd_destroy(kvm, eoifd);
+			ret = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&kvm->eoifds.lock);
+
+fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+	if (level_irqfd && !IS_ERR(level_irqfd))
+		eventfd_ctx_put(level_irqfd);
+
+	return ret;
+}
+
+int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
+{
+	if (args->flags & ~(KVM_EOIFD_FLAG_DEASSIGN |
+			    KVM_EOIFD_FLAG_LEVEL_IRQFD))
+		return -EINVAL;
+
+	if (args->flags & KVM_EOIFD_FLAG_DEASSIGN)
+		return kvm_deassign_eoifd(kvm, args);
+
+	return kvm_assign_eoifd(kvm, args);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4ad14cc..5b41df1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -620,6 +620,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 
 	kvm_irqfd_release(kvm);
 
+	kvm_eoifd_release(kvm);
+
 	kvm_put_kvm(kvm);
 	return 0;
 }
@@ -2093,6 +2095,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_EOIFD: {
+		struct kvm_eoifd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_eoifd(kvm, &data);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 		if (r == -ENOTTY)

