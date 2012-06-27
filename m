Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2F0FK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2F0FKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:10:22 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 6/6] kvm: Level IRQ de-assert for KVM_IRQFD
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 26 Jun 2012 23:10:20 -0600
Message-ID: <20120627051013.23698.91132.stgit@bling.home>
In-Reply-To: <20120627044758.23698.249.stgit@bling.home>
References: <20120627044758.23698.249.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an alternate level irqfd de-assert mode that's potentially
useful for emulated drivers.  It's included here to show how easy it
is to implement with the new level irqfd and eoifd support.  It's
possible this mode might also prove interesting for device-assignment
where we inject via level irqfd, receive an EOI (w/o de-assert), and
use the level de-assert irqfd here.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 Documentation/virtual/kvm/api.txt |    8 ++++++++
 include/linux/kvm.h               |    6 +++++-
 virt/kvm/eventfd.c                |   28 ++++++++++++++++++++++++++--
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 87a2558..b356937 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1987,6 +1987,14 @@ interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
 with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
 KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
 
+The KVM_IRQFD_FLAG_LEVEL_DEASSERT flag creates an irqfd similar to
+KVM_IRQFD_FLAG_LEVEL, except the irqfd de-asserts the irqchip pin
+rather than asserts it.  The level irqfd must first be created as
+aboved and passed to this ioctl in kvm_irqfd.irqfd.  This ensures
+the de-assert irqfd uses the same IRQ source ID as the assert irqfd.
+This flag should also be specified on de-assign.  This feature is
+present when KVM_CAP_IRQFD_LEVEL_DEASSERT is available.
+
 4.77 KVM_EOIFD
 
 Capability: KVM_CAP_EOIFD
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7567e7d..0bbfd47 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -620,6 +620,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_ALLOC_HTAB 80
 #define KVM_CAP_IRQFD_LEVEL 81
 #define KVM_CAP_EOIFD 82
+#define KVM_CAP_IRQFD_LEVEL_DEASSERT 83
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -687,12 +688,15 @@ struct kvm_xen_hvm_config {
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /* Available with KVM_CAP_IRQFD_LEVEL */
 #define KVM_IRQFD_FLAG_LEVEL (1 << 1)
+/* Available with KVM_CAP_IRQFD_LEVEL_DEASSERT */
+#define KVM_IRQFD_FLAG_LEVEL_DEASSERT (1 << 2)
 
 struct kvm_irqfd {
 	__u32 fd;
 	__u32 gsi;
 	__u32 flags;
-	__u8  pad[20];
+	__u32 irqfd;
+	__u8  pad[16];
 };
 
 #define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 02ca50f..50ace0e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -172,6 +172,14 @@ irqfd_inject_level(struct work_struct *work)
 	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
 }
 
+static void
+irqfd_inject_level_deassert(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 0);
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
@@ -320,6 +328,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	INIT_LIST_HEAD(&irqfd->list);
 
 	if (args->flags & KVM_IRQFD_FLAG_LEVEL) {
+		if (args->flags & KVM_IRQFD_FLAG_LEVEL_DEASSERT)
+			return -EINVAL; /* mutually exclusive */
+
 		irqfd->source = new_irq_source(kvm);
 		if (IS_ERR(irqfd->source)) {
 			ret = PTR_ERR(irqfd->source);
@@ -328,6 +339,16 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		}
 
 		INIT_WORK(&irqfd->inject, irqfd_inject_level);
+
+	} else if (args->flags & KVM_IRQFD_FLAG_LEVEL_DEASSERT) {
+		irqfd->source = get_irq_source_from_irqfd(kvm, args->irqfd);
+		if (IS_ERR(irqfd->source)) {
+			ret = PTR_ERR(irqfd->source);
+			irqfd->source = NULL;
+			goto fail;
+		}
+
+		INIT_WORK(&irqfd->inject, irqfd_inject_level_deassert);
 	} else
 		INIT_WORK(&irqfd->inject, irqfd_inject_edge);
 
@@ -421,7 +442,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct _irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd;
-	bool is_level = (args->flags & KVM_IRQFD_FLAG_LEVEL) != 0;
+	bool is_level = (args->flags & (KVM_IRQFD_FLAG_LEVEL |
+					KVM_IRQFD_FLAG_LEVEL_DEASSERT)) != 0;
 
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
@@ -461,7 +483,9 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_LEVEL))
+	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN |
+			    KVM_IRQFD_FLAG_LEVEL |
+			    KVM_IRQFD_FLAG_LEVEL_DEASSERT))
 		return -EINVAL;
 
 	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)

