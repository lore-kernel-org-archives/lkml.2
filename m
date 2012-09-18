Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2IRDQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2IRDQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:16:29 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 21:16:28 -0600
Message-ID: <20120918031626.12021.90083.stgit@bling.home>
In-Reply-To: <20120918031156.12021.27838.stgit@bling.home>
References: <20120918031156.12021.27838.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To emulate level triggered interrupts, add a resample option to
KVM_IRQFD.  When specified, a new resamplefd is provided that notifies
the user when the irqchip has been resampled by the VM.  This may, for
instance, indicate an EOI.  Also in this mode, injection of an
interrupt through an irqfd only asserts the interrupt.  On resampling,
the interrupt is automatically de-asserted prior to user notification.
This enables level triggered interrupts to be injected and re-enabled
from vfio with no userspace intervention.

All resampling irqfds can make use of a single irq source ID, so we
reserve a new one for this interface.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   13 +++
 arch/x86/kvm/x86.c                |    4 +
 include/linux/kvm.h               |   12 ++-
 include/linux/kvm_host.h          |    4 +
 virt/kvm/eventfd.c                |  175 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/irq_comm.c               |    6 +
 virt/kvm/kvm_main.c               |    2 
 7 files changed, 210 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index bf33aaa..d30af74 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1946,6 +1946,19 @@ the guest using the specified gsi pin.  The irqfd is removed using
 the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
 and kvm_irqfd.gsi.
 
+With KVM_CAP_IRQFD_RESAMPLE, KVM_IRQFD supports a de-assert and notify
+mechanism allowing emulation of level-triggered, irqfd-based
+interrupts.  When KVM_IRQFD_FLAG_RESAMPLE is set the user must pass an
+additional eventfd in the kvm_irqfd.resamplefd field.  When operating
+in resample mode, injection of an interrupt through kvm_irq.fd asserts
+the specified gsi in the irqchip.  When the irqchip is resampled, such
+as from an EOI, the gsi is de-asserted and the user is notifed via
+kvm_irqfd.resamplefd.  It is the user's respnosibility to re-inject
+the interrupt if the device making use of it still requires service.
+Note that closing the resamplefd is not sufficient to disable the
+irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
+and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2966c84..56f9002 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2177,6 +2177,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -6268,6 +6269,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
+	/* Reserve bit 1 of irq_sources_bitmap for irqfd-resampler */
+	set_bit(KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
+		&kvm->arch.irq_sources_bitmap);
 
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..a01a3d5 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#define KVM_CAP_IRQFD_RESAMPLE 81
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -683,12 +684,21 @@ struct kvm_xen_hvm_config {
 #endif
 
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+/*
+ * Available with KVM_CAP_IRQFD_RESAMPLE
+ *
+ * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
+ * the irqfd to operate in resampling mode for level triggered interrupt
+ * emlation.  See Documentation/virtual/kvm/api.txt.
+ */
+#define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
 struct kvm_irqfd {
 	__u32 fd;
 	__u32 gsi;
 	__u32 flags;
-	__u8  pad[20];
+	__u32 resamplefd;
+	__u8  pad[16];
 };
 
 struct kvm_clock_data {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 84f6950..d7bc79c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -70,7 +70,8 @@
 #define KVM_REQ_PMU               16
 #define KVM_REQ_PMI               17
 
-#define KVM_USERSPACE_IRQ_SOURCE_ID	0
+#define KVM_USERSPACE_IRQ_SOURCE_ID		0
+#define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
 
 struct kvm;
 struct kvm_vcpu;
@@ -283,6 +284,7 @@ struct kvm {
 	struct {
 		spinlock_t        lock;
 		struct list_head  items;
+		struct list_head  resamplers;
 	} irqfds;
 	struct list_head ioeventfds;
 #endif
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 7d7e2aa..822f50a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -43,6 +43,31 @@
  * --------------------------------------------------------------------
  */
 
+/*
+ * Resamper irqfds are a special variety of irqfds used to emulate
+ * level triggered interrupts.  The interrupt is asserted on eventfd
+ * trigger.  On acknowledgement through the irq ack notifier, the
+ * interrupt is de-asserted and userspace is notified through the
+ * resamplefd.  All resamplers on the same gsi are de-asserted
+ * together, so we don't need to track the state of each individual
+ * user.  We can also therefore share the same irq source ID.
+ */
+struct _irqfd_resampler {
+	struct kvm *kvm;
+	/*
+	 * List of resampling irqfds sharing this gsi.
+	 * RCU list modified under kvm->irqfds.lock
+	 */
+	struct list_head irqfds;
+	/* The irq ack notifier for this gsi */
+	struct kvm_irq_ack_notifier notifier;
+	/*
+	 * Entry in list of kvm->irqfd.resamplers for shutdown cleanup.
+	 * Accessed and modified under kvm->irqfds.lock
+	 */
+	struct list_head list;
+};
+
 struct _irqfd {
 	/* Used for MSI fast-path */
 	struct kvm *kvm;
@@ -52,6 +77,12 @@ struct _irqfd {
 	/* Used for level IRQ fast-path */
 	int gsi;
 	struct work_struct inject;
+	/* Eventfd notified on resample (resampler-only) */
+	struct eventfd_ctx *resamplefd;
+	/* Entry in list of irqfds for a resampler (resampler-only) */
+	struct list_head resampler_list;
+	/* The resampler used by this irqfd (resampler-only) */
+	struct _irqfd_resampler *resampler;
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
@@ -71,6 +102,39 @@ irqfd_inject(struct work_struct *work)
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
+static void
+irqfd_resampler_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	kvm_set_irq(irqfd->kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
+		    irqfd->gsi, 1);
+}
+
+/*
+ * Since resampler irqfds share an IRQ source ID, we de-assert once
+ * then notify all of the resampler irqfds using this GSI.  We can't
+ * do multiple de-asserts or we risk racing with incoming re-asserts.
+ */
+static void
+irqfd_resampler_notify(struct kvm_irq_ack_notifier *kian)
+{
+	struct _irqfd_resampler *resampler;
+	struct _irqfd *irqfd;
+
+	resampler = container_of(kian, struct _irqfd_resampler, notifier);
+
+	rcu_read_lock();
+
+	kvm_set_irq(resampler->kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
+		    resampler->notifier.gsi, 0);
+
+	list_for_each_entry_rcu(irqfd, &resampler->irqfds, resampler_list)
+		eventfd_signal(irqfd->resamplefd, 1);
+
+	rcu_read_unlock();
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -92,6 +156,43 @@ irqfd_shutdown(struct work_struct *work)
 	 */
 	flush_work_sync(&irqfd->inject);
 
+	if (irqfd->resampler) {
+		struct _irqfd_resampler *resampler = irqfd->resampler;
+		struct kvm *kvm = resampler->kvm;
+
+		mutex_lock(&kvm->irq_lock);
+		spin_lock_irq(&irqfd->kvm->irqfds.lock);
+
+		list_del_rcu(&irqfd->resampler_list);
+
+		/*
+		 * On removal of the last irqfd in the resampler list,
+		 * remove the resampler and unregister the irq ack
+		 * notifier.  It's possible to race the ack of the final
+		 * injection here, so manually de-assert the gsi to avoid
+		 * leaving an unmanaged, asserted interrupt line.
+		 */
+		if (list_empty(&resampler->irqfds)) {
+			list_del(&resampler->list);
+			__kvm_unregister_irq_ack_notifier(kvm,
+							  &resampler->notifier);
+			kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
+				    resampler->notifier.gsi, 0);
+			kfree(resampler);
+		}
+
+		spin_unlock_irq(&irqfd->kvm->irqfds.lock);
+		mutex_unlock(&kvm->irq_lock);
+
+		/*
+		 * Both list_del_rcu & __kvm_unregister_irq_ack_notifier
+		 * require an rcu grace period/
+		 */
+		synchronize_rcu();
+
+		eventfd_ctx_put(irqfd->resamplefd);
+	}
+
 	/*
 	 * It is now safe to release the object's resources
 	 */
@@ -202,8 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct kvm_irq_routing_table *irq_rt;
 	struct _irqfd *irqfd, *tmp;
+	struct _irqfd_resampler *resampler = NULL;
 	struct file *file = NULL;
-	struct eventfd_ctx *eventfd = NULL;
+	struct eventfd_ctx *eventfd = NULL, *resamplefd = NULL;
 	int ret;
 	unsigned int events;
 
@@ -214,7 +316,40 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	irqfd->kvm = kvm;
 	irqfd->gsi = args->gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
+	INIT_LIST_HEAD(&irqfd->resampler_list);
+
+	if (args->flags & KVM_IRQFD_FLAG_RESAMPLE) {
+		resamplefd = eventfd_ctx_fdget(args->resamplefd);
+		if (IS_ERR(resamplefd)) {
+			ret = PTR_ERR(resamplefd);
+			goto fail;
+		}
+
+		irqfd->resamplefd = resamplefd;
+
+		/*
+		 * We may be able to share an existing resampler, but we
+		 * won't know that until we search under spinlock.  Setup
+		 * one here to avoid an atomic allocation later.
+		 */
+		resampler = kzalloc(sizeof(*resampler), GFP_KERNEL);
+		if (!resampler) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		resampler->kvm = kvm;
+		INIT_LIST_HEAD(&resampler->irqfds);
+		resampler->notifier.gsi = irqfd->gsi;
+		resampler->notifier.irq_acked = irqfd_resampler_notify;
+		INIT_LIST_HEAD(&resampler->list);
+
+		irqfd->resampler = resampler;
+
+		INIT_WORK(&irqfd->inject, irqfd_resampler_inject);
+	} else
+		INIT_WORK(&irqfd->inject, irqfd_inject);
+
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(args->fd);
@@ -238,6 +373,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
 
+	mutex_lock(&kvm->irq_lock);
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -247,9 +383,36 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
 		spin_unlock_irq(&kvm->irqfds.lock);
+		mutex_unlock(&kvm->irq_lock);
 		goto fail;
 	}
 
+	if (resampler) {
+		struct _irqfd_resampler *resampler_tmp;
+
+		/*
+		 * Re-use a resampler if it's already registered on the
+		 * gsi we need.  Free the one we created above if found,
+		 * otherwise add to the list and setup the irq ack notifier.
+		 */
+		list_for_each_entry(resampler_tmp,
+				    &kvm->irqfds.resamplers, list) {
+			if (resampler_tmp->notifier.gsi == irqfd->gsi) {
+				irqfd->resampler = resampler_tmp;
+				break;
+			}
+		}
+
+		if (irqfd->resampler == resampler) {
+			list_add(&resampler->list, &kvm->irqfds.resamplers);
+			__kvm_register_irq_ack_notifier(kvm,
+							&resampler->notifier);
+		} else
+			kfree(resampler);
+
+		list_add_rcu(&irqfd->resampler_list, &irqfd->resampler->irqfds);
+	}
+
 	irq_rt = rcu_dereference_protected(kvm->irq_routing,
 					   lockdep_is_held(&kvm->irqfds.lock));
 	irqfd_update(kvm, irqfd, irq_rt);
@@ -266,6 +429,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		schedule_work(&irqfd->inject);
 
 	spin_unlock_irq(&kvm->irqfds.lock);
+	mutex_unlock(&kvm->irq_lock);
 
 	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise
@@ -276,12 +440,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return 0;
 
 fail:
+	if (resamplefd && !IS_ERR(resamplefd))
+		eventfd_ctx_put(resamplefd);
+
 	if (eventfd && !IS_ERR(eventfd))
 		eventfd_ctx_put(eventfd);
 
 	if (!IS_ERR(file))
 		fput(file);
 
+	kfree(resampler);
 	kfree(irqfd);
 	return ret;
 }
@@ -291,6 +459,7 @@ kvm_eventfd_init(struct kvm *kvm)
 {
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
+	INIT_LIST_HEAD(&kvm->irqfds.resamplers);
 	INIT_LIST_HEAD(&kvm->ioeventfds);
 }
 
@@ -340,7 +509,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
+	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_RESAMPLE))
 		return -EINVAL;
 
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index dd0cbf6..5d29c0b 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -237,6 +237,9 @@ int kvm_request_irq_source_id(struct kvm *kvm)
 	}
 
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+#ifdef CONFIG_X86
+	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
+#endif
 	set_bit(irq_source_id, bitmap);
 unlock:
 	mutex_unlock(&kvm->irq_lock);
@@ -247,6 +250,9 @@ unlock:
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 {
 	ASSERT(irq_source_id != KVM_USERSPACE_IRQ_SOURCE_ID);
+#ifdef CONFIG_X86
+	ASSERT(irq_source_id != KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID);
+#endif
 
 	mutex_lock(&kvm->irq_lock);
 	if (irq_source_id < 0 ||
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d617f69..3f3fe0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -67,7 +67,7 @@ MODULE_LICENSE("GPL");
 /*
  * Ordering of locks:
  *
- * 		kvm->lock --> kvm->slots_lock --> kvm->irq_lock
+ *	kvm->lock --> kvm->slots_lock --> kvm->irq_lock --> kvm->irqfds.lock
  */
 
 DEFINE_RAW_SPINLOCK(kvm_lock);

