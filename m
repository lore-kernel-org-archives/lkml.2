Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2GMTlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab2GMTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:41:21 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v4 3/3] kvm: Add a GSI specification for KVM_EOIFD
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Fri, 13 Jul 2012 13:41:13 -0600
Message-ID: <20120713194111.5474.48341.stgit@bling.home>
In-Reply-To: <20120713192625.5474.60777.stgit@bling.home>
References: <20120713192625.5474.60777.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR COMMIT - Here's what it would look like to add a GSI
flavor for KVM_EOIFD later.  I expect we're going to need this
to support generic EOI notifiers in qemu when irqchip is enabled.
No API doc included here yet.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm.h |    8 +++++++-
 virt/kvm/eventfd.c  |   17 +++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5ca887d..18d87fc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -621,6 +621,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IRQFD_LEVEL 81
 #define KVM_CAP_EOIFD 82
 #define KVM_CAP_EOIFD_LEVEL_IRQFD 83
+#define KVM_CAP_EOIFD_GSI 84
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -699,11 +700,16 @@ struct kvm_irqfd {
 #define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
 /* Available with KVM_CAP_EOIFD_LEVEL_IRQFD */
 #define KVM_EOIFD_FLAG_LEVEL_IRQFD (1 << 1)
+/* Available with KVM_CAP_EOIFD_GSI */
+#define KVM_EOIFD_FLAG_GSI (1 << 2)
 
 struct kvm_eoifd {
 	__u32 fd;
 	__u32 flags;
-	__u32 irqfd;
+	union {
+		__u32 irqfd;
+		__u32 gsi;
+	};
 	__u8 pad[20];
 };
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2fae198..b6d9c1c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -826,6 +826,11 @@ static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
 
 	eoifd = container_of(notifier, struct _eoifd, notifier);
 
+	if (!eoifd->level_irqfd) {
+		eventfd_signal(eoifd->eventfd, 1);
+		return;
+	}
+
 	/*
 	 * Ack notifier is per GSI, which may be shared with others.
 	 * Only de-assert and send EOI if our source ID is asserted.
@@ -876,6 +881,8 @@ static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
 			ret = -EINVAL;
 			goto fail;
 		}
+	} else if (args->flags & KVM_EOIFD_FLAG_GSI) {
+		gsi = args->gsi;
 	} else {
 		ret = -EINVAL;
 		goto fail;
@@ -934,6 +941,7 @@ static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
 {
 	struct eventfd_ctx *eventfd = NULL, *level_irqfd = NULL;
 	struct _eoifd *eoifd;
+	unsigned gsi = ~0;
 	int ret = -ENOENT;
 
 	eventfd = eventfd_ctx_fdget(args->fd);
@@ -948,6 +956,8 @@ static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
 			ret = PTR_ERR(level_irqfd);
 			goto fail;
 		}
+	} else if (args->flags & KVM_EOIFD_FLAG_GSI) {
+		gsi = args->gsi;
 	} else {
 		ret = -EINVAL;
 		goto fail;
@@ -957,7 +967,9 @@ static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
 
 	list_for_each_entry(eoifd, &kvm->eoifds.items, list) {
 		if (eoifd->eventfd == eventfd &&
-		    eoifd->level_irqfd == level_irqfd) {
+		    ((level_irqfd && eoifd->level_irqfd == level_irqfd) ||
+		     (!level_irqfd && !eoifd->level_irqfd &&
+		      eoifd->notifier.gsi == gsi))) {
 			eoifd_destroy(kvm, eoifd);
 			ret = 0;
 			break;
@@ -978,7 +990,8 @@ fail:
 int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
 {
 	if (args->flags & ~(KVM_EOIFD_FLAG_DEASSIGN |
-			    KVM_EOIFD_FLAG_LEVEL_IRQFD))
+			    KVM_EOIFD_FLAG_LEVEL_IRQFD |
+			    KVM_EOIFD_FLAG_GSI))
 		return -EINVAL;
 
 	if (args->flags & KVM_EOIFD_FLAG_DEASSIGN)

