Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab2GCTV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab2GCTVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:21:24 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 1/2] kvm: Extend irqfd to support level interrupts
To: avi@redhat.com, mst@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 03 Jul 2012 13:21:21 -0600
Message-ID: <20120703192118.6735.92504.stgit@bling.home>
In-Reply-To: <20120703191106.6735.78272.stgit@bling.home>
References: <20120703191106.6735.78272.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to inject a level interrupt from an external source using an
irqfd, we need to allocate a new irq_source_id.  This allows us to
assert and (later) de-assert an interrupt line independently from
users of KVM_IRQ_LINE and avoid lost interrupts.

We also add what may appear like a bit of excessive infrastructure
around an object for storing this irq_source_id.  However, notice
that we only provide a way to assert the interrupt here.  A follow-on
interface will make use of the same irq_source_id to allow de-assert.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |    6 ++
 arch/x86/kvm/x86.c                |    1 
 include/linux/kvm.h               |    3 +
 virt/kvm/eventfd.c                |  103 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 100acde..c7267d5 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1981,6 +1981,12 @@ the guest using the specified gsi pin.  The irqfd is removed using
 the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
 and kvm_irqfd.gsi.
 
+The KVM_IRQFD_FLAG_LEVEL flag indicates the gsi input is for a level
+triggered interrupt.  In this case a new irqchip input is allocated
+which is logically OR'd with other inputs allowing multiple sources
+to independently assert level interrupts.  The KVM_IRQFD_FLAG_LEVEL
+is only necessary on setup, teardown is identical to that above.
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
index 7d7e2aa..92aa5ba 100644
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
+	int id; /* the IRQ source ID */
+	struct kvm *kvm;
+	struct kref kref;
+};
+
+static void _irq_source_release(struct kref *kref)
+{
+	struct _irq_source *source;
+
+	source = container_of(kref, struct _irq_source, kref);
+
+	kvm_free_irq_source_id(source->kvm, source->id);
+	kfree(source);
+}
+
+static void _irq_source_put(struct _irq_source *source)
+{
+	if (source)
+		kref_put(&source->kref, _irq_source_release);
+}
+
+static struct _irq_source *__attribute__ ((used)) /* white lie for now */
+_irq_source_get(struct _irq_source *source)
+{
+	if (source)
+		kref_get(&source->kref);
+
+	return source;
+}
+
+static struct _irq_source *_irq_source_alloc(struct kvm *kvm)
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
@@ -52,6 +110,8 @@ struct _irqfd {
 	/* Used for level IRQ fast-path */
 	int gsi;
 	struct work_struct inject;
+	/* IRQ source ID for level triggered irqfds */
+	struct _irq_source *source;
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
 	struct list_head list;
@@ -62,7 +122,7 @@ struct _irqfd {
 static struct workqueue_struct *irqfd_cleanup_wq;
 
 static void
-irqfd_inject(struct work_struct *work)
+irqfd_inject_edge(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
@@ -71,6 +131,22 @@ irqfd_inject(struct work_struct *work)
 	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
 }
 
+static void
+irqfd_inject_level(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	/*
+	 * We can safely ignore the return value here.  If masked, the irr
+	 * bit is still set and will eventually be serviced.  This interface
+	 * does not guarantee immediate injection.  If coalesced, an eoi
+	 * will be coming where we can de-assert and re-inject if necessary.
+	 * NB, if you need to know if an interrupt was coalesced, this
+	 * interface is not for you.
+	 */
+	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -96,6 +172,9 @@ irqfd_shutdown(struct work_struct *work)
 	 * It is now safe to release the object's resources
 	 */
 	eventfd_ctx_put(irqfd->eventfd);
+
+	_irq_source_put(irqfd->source);
+
 	kfree(irqfd);
 }
 
@@ -202,6 +281,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct kvm_irq_routing_table *irq_rt;
 	struct _irqfd *irqfd, *tmp;
+	struct _irq_source *source = NULL;
 	struct file *file = NULL;
 	struct eventfd_ctx *eventfd = NULL;
 	int ret;
@@ -214,7 +294,19 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	irqfd->kvm = kvm;
 	irqfd->gsi = args->gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->inject, irqfd_inject);
+
+	if (args->flags & KVM_IRQFD_FLAG_LEVEL) {
+		source = _irq_source_alloc(kvm);
+		if (IS_ERR(source)) {
+			ret = PTR_ERR(source);
+			goto fail;
+		}
+
+		irqfd->source = source;
+		INIT_WORK(&irqfd->inject, irqfd_inject_level);
+	} else
+		INIT_WORK(&irqfd->inject, irqfd_inject_edge);
+
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(args->fd);
@@ -276,10 +368,13 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return 0;
 
 fail:
+	if (source && !IS_ERR(source))
+		_irq_source_put(source);
+
 	if (eventfd && !IS_ERR(eventfd))
 		eventfd_ctx_put(eventfd);
 
-	if (!IS_ERR(file))
+	if (file && !IS_ERR(file))
 		fput(file);
 
 	kfree(irqfd);
@@ -340,7 +435,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
+	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_LEVEL))
 		return -EINVAL;
 
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)

