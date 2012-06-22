Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2FVWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045Ab2FVWQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:16:25 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Fri, 22 Jun 2012 16:16:17 -0600
Message-ID: <20120622221559.9858.59593.stgit@bling.home>
In-Reply-To: <20120622220040.9858.43665.stgit@bling.home>
References: <20120622220040.9858.43665.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM_IRQFD currently only supports edge triggered interrupts,
asserting then immediately deasserting an interrupt.  There are a
couple ways we can emulate level triggered interrupts using
discrete events depending on the usage model we expect from drivers.
This patch implements a level emulation model useful for external
assigned device drivers, like VFIO.  The irqfd is used to assert
the interrupt.  When the guest issues an EOI for the interrupt, the
level is automatically deasserted and the irqfd user is notified via
an eventfd.  This is therefore the LEVEL_EOI extension to KVM_IRQFD.
To do this, we need to allocate a new irq source ID for the interrupt
so we don't get interference from userspace.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |   15 ++++++
 arch/x86/kvm/x86.c                |    1 
 include/linux/kvm.h               |    6 ++
 virt/kvm/eventfd.c                |   94 ++++++++++++++++++++++++++++++++++---
 4 files changed, 107 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 9b4cb2b..2f8a0aa 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1982,6 +1982,21 @@ when the eventfd is triggered.  Specifying KVM_IRQFD_FLAG_DEASSIGN
 removes the previously set irqfd matching both kvm_irqfd.fd and
 kvm_irqfd.gsi.
 
+With KVM_CAP_IRQFD_LEVEL_EOI KVM_IRQFD is able to support a level
+triggered interrupt model where the irqchip pin (kvm_irqfd.gsi) is
+asserted from the kvm_irqfd.fd eventfd and remain asserted until the
+guest issues an EOI for the irqchip pin.  The level interrupt is
+then de-asserted and the caller is notified via the eventfd specified
+by kvm_irqfd.fd2.  Note that users of this interface are responsible
+for re-asserting the interrupt if their device still requires service
+after receiving the EOI notification.  Additionally, users must not
+re-assert an interrupt until after receiving an EOI.  When available,
+this feature is enabled using the KVM_IRQFD_FLAG_LEVEL_EOI flag.
+De-assigning an irqfd setup using this flag should include both
+KVM_IRQFD_FLAG_DEASSIGN and KVM_IRQFD_FLAG_LEVEL_EOI and will be
+matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
+De-assigning automatically de-asserts the interrupt line setup through
+this interface.
 
 5. The kvm_run structure
 ------------------------
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a01a424..20a51fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2148,6 +2148,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+	case KVM_CAP_IRQFD_LEVEL_EOI:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..a916186 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#define KVM_CAP_IRQFD_LEVEL_EOI 81
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -683,12 +684,15 @@ struct kvm_xen_hvm_config {
 #endif
 
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+/* Available with KVM_CAP_IRQFD_LEVEL_EOI */
+#define KVM_IRQFD_FLAG_LEVEL_EOI (1 << 1)
 
 struct kvm_irqfd {
 	__u32 fd;
 	__u32 gsi;
 	__u32 flags;
-	__u8  pad[20];
+	__u32 fd2;
+	__u8 pad[16];
 };
 
 struct kvm_clock_data {
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c307c24..2bc7275 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -49,9 +49,13 @@ struct _irqfd {
 	wait_queue_t wait;
 	/* Update side is protected by irqfds.lock */
 	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
-	/* Used for level IRQ fast-path */
+	/* Used for IRQ fast-path */
 	int gsi;
 	struct work_struct inject;
+	/* Used for level EOI path */
+	int irq_source_id;
+	struct eventfd_ctx *eoi_eventfd;
+	struct kvm_irq_ack_notifier notifier;
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
@@ -62,7 +66,7 @@ struct _irqfd {
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
-irqfd_inject(struct work_struct *work)
+irqfd_inject_edge(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
@@ -71,6 +75,23 @@ irqfd_inject(struct work_struct *work)
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
+static void
+irqfd_inject_level(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	kvm_set_irq(irqfd->kvm, irqfd->irq_source_id, irqfd->gsi, 1);
+}
+
+static void
+irqfd_ack_level(struct kvm_irq_ack_notifier *notifier)
+{
+	struct _irqfd *irqfd  = container_of(notifier, struct _irqfd, notifier);
+
+	kvm_set_irq(irqfd->kvm, irqfd->irq_source_id, irqfd->gsi, 0);
+	eventfd_signal(irqfd->eoi_eventfd, 1);
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -96,6 +117,14 @@ irqfd_shutdown(struct work_struct *work)
 	 * It is now safe to release the object's resources
 	 */
 	eventfd_ctx_put(irqfd->eventfd);
+
+	if (irqfd->eoi_eventfd) {
+		kvm_unregister_irq_ack_notifier(irqfd->kvm, &irqfd->notifier);
+		eventfd_ctx_put(irqfd->eoi_eventfd);
+		kvm_set_irq(irqfd->kvm, irqfd->irq_source_id, irqfd->gsi, 0);
+		kvm_free_irq_source_id(irqfd->kvm, irqfd->irq_source_id);
+	}
+
 	kfree(irqfd);
 }
 
@@ -203,8 +232,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	struct kvm_irq_routing_table *irq_rt;
 	struct _irqfd *irqfd, *tmp;
 	struct file *file = NULL;
-	struct eventfd_ctx *eventfd = NULL;
-	int ret;
+	struct eventfd_ctx *eventfd = NULL, *eoi_eventfd = NULL;
+	int ret, irq_source_id = -1;
 	unsigned int events;
 
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
@@ -214,7 +243,30 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	irqfd->kvm = kvm;
 	irqfd->gsi = args->gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
+
+	if (args->flags & KVM_IRQFD_FLAG_LEVEL_EOI) {
+		irq_source_id = kvm_request_irq_source_id(kvm);
+		if (irq_source_id < 0) {
+			ret = irq_source_id;
+			goto fail;
+		}
+
+		eoi_eventfd = eventfd_ctx_fdget(args->fd2);
+		if (IS_ERR(eoi_eventfd)) {
+			ret = PTR_ERR(eoi_eventfd);
+			goto fail;
+		}
+
+		irqfd->irq_source_id = irq_source_id;
+		irqfd->eoi_eventfd = eoi_eventfd;
+		irqfd->notifier.gsi = args->gsi;
+		irqfd->notifier.irq_acked = irqfd_ack_level;
+		kvm_register_irq_ack_notifier(kvm, &irqfd->notifier);
+
+		INIT_WORK(&irqfd->inject, irqfd_inject_level);
+	} else
+		INIT_WORK(&irqfd->inject, irqfd_inject_edge);
+
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(args->fd);
@@ -231,6 +283,11 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 	irqfd->eventfd = eventfd;
 
+	if (eventfd == eoi_eventfd) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd
@@ -242,7 +299,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 
 	ret = 0;
 	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd != tmp->eventfd)
+		if (irqfd->eventfd != tmp->eventfd &&
+		    irqfd->eventfd != tmp->eoi_eventfd)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
@@ -282,6 +340,14 @@ fail:
 	if (!IS_ERR(file))
 		fput(file);
 
+	if (eoi_eventfd && !IS_ERR(eoi_eventfd)) {
+		kvm_unregister_irq_ack_notifier(kvm, &irqfd->notifier);
+		eventfd_ctx_put(eoi_eventfd);
+	}
+
+	if (irq_source_id >= 0)
+		kvm_free_irq_source_id(kvm, irq_source_id);
+
 	kfree(irqfd);
 	return ret;
 }
@@ -301,16 +367,26 @@ static int
 kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct _irqfd *irqfd, *tmp;
-	struct eventfd_ctx *eventfd;
+	struct eventfd_ctx *eventfd, *eoi_eventfd = NULL;
 
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
+	if (args->flags & KVM_IRQFD_FLAG_LEVEL_EOI) {
+		eoi_eventfd = eventfd_ctx_fdget(args->fd2);
+		if (IS_ERR(eoi_eventfd)) {
+			eventfd_ctx_put(eventfd);
+			return PTR_ERR(eoi_eventfd);
+		}
+	}
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
+		if (irqfd->eventfd == eventfd &&
+		    irqfd->gsi == args->gsi &&
+		    irqfd->eoi_eventfd == eoi_eventfd) {
 			/*
 			 * This rcu_assign_pointer is needed for when
 			 * another thread calls kvm_irq_routing_update before
@@ -326,6 +402,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 	eventfd_ctx_put(eventfd);
+	if (eoi_eventfd)
+		eventfd_ctx_put(eoi_eventfd);
 
 	/*
 	 * Block until we know all outstanding shutdown jobs have completed

