Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657Ab2CAKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:25:57 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34920 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869Ab2CAKZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:25:56 -0500
Date: Thu, 1 Mar 2012 19:32:16 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-Id: <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped such mappings when we enabled dirty logging and we will never
create new ones until we stop the logging.

For this we introduce a new function which can be used to write protect
a range of PT level pages: although we do not need to care about a range
of pages at this point, the following patch will need this feature to
optimize the write protection of many pages.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/include/asm/kvm_host.h |    5 ++-
 arch/x86/kvm/mmu.c              |   40 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c              |    8 ++----
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74c9edf..935cbcc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -712,8 +712,9 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
-int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
-			       struct kvm_memory_slot *slot);
+void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 67857bd..be8a529 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1037,27 +1037,47 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
 	return write_protected;
 }
 
-int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
-			       struct kvm_memory_slot *slot)
+/**
+ * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+ * @kvm: kvm instance
+ * @slot: slot to protect
+ * @gfn_offset: start of the BITS_PER_LONG pages we care about
+ * @mask: indicates which pages we should protect
+ *
+ * Used when we do not need to care about huge page mappings: e.g. during dirty
+ * logging we do not have any such mappings.
+ */
+void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     gfn_t gfn_offset, unsigned long mask)
 {
 	unsigned long *rmapp;
-	int i, write_protected = 0;
 
-	for (i = PT_PAGE_TABLE_LEVEL;
-	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
-		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
-	}
+	while (mask) {
+		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
 
-	return write_protected;
+		/* clear the first set bit */
+		mask &= mask - 1;
+	}
 }
 
 static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
+	unsigned long *rmapp;
+	int i;
+	int write_protected = 0;
 
 	slot = gfn_to_memslot(kvm, gfn);
-	return kvm_mmu_rmap_write_protect(kvm, gfn, slot);
+
+	for (i = PT_PAGE_TABLE_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		rmapp = __gfn_to_rmap(gfn, i, slot);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i);
+	}
+
+	return write_protected;
 }
 
 static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9d99e5..3bc1922 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3069,13 +3069,11 @@ static void write_protect_slot(struct kvm *kvm,
 
 	/* Not many dirty pages compared to # of shadow pages. */
 	if (nr_dirty_pages < kvm->arch.n_used_mmu_pages) {
-		unsigned long gfn_offset;
+		gfn_t offset;
 
-		for_each_set_bit(gfn_offset, dirty_bitmap, memslot->npages) {
-			unsigned long gfn = memslot->base_gfn + gfn_offset;
+		for_each_set_bit(offset, dirty_bitmap, memslot->npages)
+			kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, 1);
 
-			kvm_mmu_rmap_write_protect(kvm, gfn, memslot);
-		}
 		kvm_flush_remote_tlbs(kvm);
 	} else
 		kvm_mmu_slot_remove_write_access(kvm, memslot->id);
-- 
1.7.5.4

