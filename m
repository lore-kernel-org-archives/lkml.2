Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2HJWhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760386Ab2HJWhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:37:42 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v8 4/6] kvm: Add assert-only option to KVM_IRQFD
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Aug 2012 16:37:41 -0600
Message-ID: <20120810223738.809.23098.stgit@bling.home>
In-Reply-To: <20120810223633.809.44188.stgit@bling.home>
References: <20120810223633.809.44188.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows specifying that an irqfd is used only to assert the
specified gsi, whereas standard behavior is to follow the assertion
with a deassertion.  This will later allow a level interrupt to be
asserted via eventfd and later de-asserted by other means.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |    6 ++++++
 arch/x86/kvm/x86.c                |    1 +
 include/linux/kvm.h               |    3 +++
 virt/kvm/eventfd.c                |    8 ++++++--
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 46f4b4d..17cd599 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1951,6 +1951,12 @@ KVM_IRQFD_FLAG_IRQ_SOURCE_ID which can be used to specify an IRQ
 source ID (see KVM_IRQ_SOURCE_ID) to be used for the guest interrupt.
 This flag has no effect on deassignment.
 
+When KVM_CAP_IRQFD_ASSERT_ONLY is available, KVM_IRQFD supports the
+KVM_IRQFD_FLAG_ASSERT_ONLY which specifies that an interrupt injected
+via the eventfd is only asserted.  The default behavior is to assert
+then deassert the specified gsi when the eventfd is triggered.  This
+flag has no effect on deassignment.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 946c5bd..19680ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2175,6 +2175,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_IRQFD_IRQ_SOURCE_ID:
+	case KVM_CAP_IRQFD_ASSERT_ONLY:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index deda8a9..19b1235 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -620,6 +620,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_ALLOC_HTAB 80
 #define KVM_CAP_NR_IRQ_SOURCE_ID 81
 #define KVM_CAP_IRQFD_IRQ_SOURCE_ID 82
+#define KVM_CAP_IRQFD_ASSERT_ONLY 83
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -687,6 +688,8 @@ struct kvm_xen_hvm_config {
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /* Available with KVM_CAP_IRQFD_IRQ_SOURCE_ID */
 #define KVM_IRQFD_FLAG_IRQ_SOURCE_ID (1 << 1)
+/* Available with KVM_CAP_IRQFD_ASSERT_ONLY */
+#define KVM_IRQFD_FLAG_ASSERT_ONLY (1 << 2)
 
 struct kvm_irqfd {
 	__u32 fd;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 30150f1..df41038 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -52,6 +52,7 @@ struct _irqfd {
 	/* Used for level IRQ fast-path */
 	int gsi;
 	int irq_source_id;
+	bool assert_only;
 	struct work_struct inject;
 	/* Used for setup/shutdown */
 	struct eventfd_ctx *eventfd;
@@ -69,7 +70,8 @@ irqfd_inject(struct work_struct *work)
 	struct kvm *kvm = irqfd->kvm;
 
 	kvm_set_irq(kvm, irqfd->irq_source_id, irqfd->gsi, 1);
-	kvm_set_irq(kvm, irqfd->irq_source_id, irqfd->gsi, 0);
+	if (!irqfd->assert_only)
+		kvm_set_irq(kvm, irqfd->irq_source_id, irqfd->gsi, 0);
 }
 
 /*
@@ -218,6 +220,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		irqfd->irq_source_id = args->irq_source_id;
 	else
 		irqfd->irq_source_id = KVM_USERSPACE_IRQ_SOURCE_ID;
+	irqfd->assert_only = args->flags & KVM_IRQFD_FLAG_ASSERT_ONLY;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
@@ -346,7 +349,8 @@ int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN |
-			    KVM_IRQFD_FLAG_IRQ_SOURCE_ID))
+			    KVM_IRQFD_FLAG_IRQ_SOURCE_ID |
+			    KVM_IRQFD_FLAG_ASSERT_ONLY))
 		return -EINVAL;
 
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)

