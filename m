Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2F0FJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab2F0FJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:09:50 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 26 Jun 2012 23:09:46 -0600
Message-ID: <20120627050937.23698.68442.stgit@bling.home>
In-Reply-To: <20120627044758.23698.249.stgit@bling.home>
References: <20120627044758.23698.249.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to inject an interrupt from an external source using an
irqfd, we need to allocate a new irq_source_id.  This allows us to
assert and (later) de-assert an interrupt line independently from
users of KVM_IRQ_LINE and avoid lost interrupts.

We also add what may appear like a bit of excessive infrastructure
around an object for storing this irq_source_id.  However, notice
that we only provide a way to assert the interrupt here.  A follow-on
interface will make use of the same irq_source_id to allow de-assert.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |    5 ++
 arch/x86/kvm/x86.c                |    1 
 include/linux/kvm.h               |    3 +
 virt/kvm/eventfd.c                |   95 +++++++++++++++++++++++++++++++++++--
 4 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ea9edce..b216709 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1981,6 +1981,11 @@ the guest using the specified gsi pin.  The irqfd is removed using
 the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
 and kvm_irqfd.gsi.
 
+With KVM_IRQFD_FLAG_LEVEL KVM_IRQFD allocates a new IRQ source ID for
+the requested irqfd.  This is necessary to share level triggered
+interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
+with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
+KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
 
 5. The kvm_run structure
 ------------------------
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a01a424..80bed07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2148,6 +2148,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+	case KVM_CAP_IRQFD_LEVEL:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2ce09aa..b2e6e4f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#define KVM_CAP_IRQFD_LEVEL 81
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -683,6 +684,8 @@ struct kvm_xen_hvm_config {
 #endif
 
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+/* Available with KVM_CAP_IRQFD_LEVEL */
+#define KVM_IRQFD_FLAG_LEVEL (1 << 1)
 
 struct kvm_irqfd {
 	__u32 fd;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 7d7e2aa..18cc284 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -36,6 +36,64 @@
 #include "iodev.h"
 
 /*
+ * An irq_source_id can be created from KVM_IRQFD for level interrupt
+ * injections and shared with other interfaces for EOI or de-assert.
+ * Create an object with reference counting to make it easy to use.
+ */
+struct _irq_source {
+	int id;
+	struct kvm *kvm;
+	struct kref kref;
+};
+
+static void release_irq_source(struct kref *kref)
+{
+	struct _irq_source *source;
+
+	source = container_of(kref, struct _irq_source, kref);
+
+	kvm_free_irq_source_id(source->kvm, source->id);
+	kfree(source);
+}
+
+static void put_irq_source(struct _irq_source *source)
+{
+	if (source)
+		kref_put(&source->kref, release_irq_source);
+}
+
+static struct _irq_source *__attribute__ ((used)) /* white lie for now */
+get_irq_source(struct _irq_source *source)
+{
+	if (source)
+		kref_get(&source->kref);
+
+	return source;
+}
+
+static struct _irq_source *new_irq_source(struct kvm *kvm)
+{
+	struct _irq_source *source;
+	int id;
+
+	source = kzalloc(sizeof(*source), GFP_KERNEL);
+	if (!source)
+		return ERR_PTR(-ENOMEM);
+
+	id = kvm_request_irq_source_id(kvm);
+	if (id < 0) {
+		kfree(source);
+		return ERR_PTR(id);
+	}
+
+	kref_init(&source->kref);
+	source->kvm = kvm;
+	source->id = id;
+
+	return source;
+}
+
+/*
  * --------------------------------------------------------------------
  * irqfd: Allows an fd to be used to inject an interrupt to the guest
  *
@@ -52,6 +110,7 @@ struct _irqfd {
 	/* Used for level IRQ fast-path */
 	int gsi;
 	struct work_struct inject;
+	struct _irq_source *source;
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
@@ -62,7 +121,7 @@ struct _irqfd {
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
-irqfd_inject(struct work_struct *work)
+irqfd_inject_edge(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
@@ -71,6 +130,14 @@ irqfd_inject(struct work_struct *work)
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
+static void
+irqfd_inject_level(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -96,6 +163,9 @@ irqfd_shutdown(struct work_struct *work)
 	 * It is now safe to release the object's resources
 	 */
 	eventfd_ctx_put(irqfd->eventfd);
+
+	put_irq_source(irqfd->source);
+
 	kfree(irqfd);
 }
 
@@ -214,7 +284,19 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	irqfd->kvm = kvm;
 	irqfd->gsi = args->gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
+
+	if (args->flags & KVM_IRQFD_FLAG_LEVEL) {
+		irqfd->source = new_irq_source(kvm);
+		if (IS_ERR(irqfd->source)) {
+			ret = PTR_ERR(irqfd->source);
+			irqfd->source = NULL;
+			goto fail;
+		}
+
+		INIT_WORK(&irqfd->inject, irqfd_inject_level);
+	} else
+		INIT_WORK(&irqfd->inject, irqfd_inject_edge);
+
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(args->fd);
@@ -279,9 +361,10 @@ fail:
 	if (eventfd && !IS_ERR(eventfd))
 		eventfd_ctx_put(eventfd);
 
-	if (!IS_ERR(file))
+	if (file && !IS_ERR(file))
 		fput(file);
 
+	put_irq_source(irqfd->source);
 	kfree(irqfd);
 	return ret;
 }
@@ -302,6 +385,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct _irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd;
+	bool is_level = (args->flags & KVM_IRQFD_FLAG_LEVEL) != 0;
 
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
@@ -310,7 +394,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
+		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi &&
+		    is_level == (irqfd->source != NULL)) {
 			/*
 			 * This rcu_assign_pointer is needed for when
 			 * another thread calls kvm_irq_routing_update before
@@ -340,7 +425,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
+	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_LEVEL))
 		return -EINVAL;
 
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)

