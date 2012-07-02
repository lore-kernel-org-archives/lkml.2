Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab2GBI7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:59:07 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41464 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab2GBI7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:59:03 -0400
Date: Mon, 2 Jul 2012 17:58:48 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 7/8] KVM: MMU: Push trace_kvm_age_page() into
 kvm_age_rmapp()
Message-Id: <20120702175848.b8aa25f7.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restricts the tracing to page aging and makes it possible to
optimize kvm_handle_hva_range() further in the following patch.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bf8d50e..3082199 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1193,8 +1193,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 					       unsigned long data))
 {
 	int j;
-	int ret;
-	int retval = 0;
+	int ret = 0;
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 
@@ -1217,8 +1216,6 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
 
 		for (; gfn < gfn_end; ++gfn) {
-			ret = 0;
-
 			for (j = PT_PAGE_TABLE_LEVEL;
 			     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
 				unsigned long *rmapp;
@@ -1226,14 +1223,10 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 				rmapp = __gfn_to_rmap(gfn, j, memslot);
 				ret |= handler(kvm, rmapp, memslot, data);
 			}
-			trace_kvm_age_page(memslot->userspace_addr +
-					(gfn - memslot->base_gfn) * PAGE_SIZE,
-					memslot, ret);
-			retval |= ret;
 		}
 	}
 
-	return retval;
+	return ret;
 }
 
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
@@ -1275,8 +1268,10 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	 * This has some overhead, but not as much as the cost of swapping
 	 * out actively used pages or breaking up actively used hugepages.
 	 */
-	if (!shadow_accessed_mask)
-		return kvm_unmap_rmapp(kvm, rmapp, slot, data);
+	if (!shadow_accessed_mask) {
+		young = kvm_unmap_rmapp(kvm, rmapp, slot, data);
+		goto out;
+	}
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
@@ -1288,7 +1283,9 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 				 (unsigned long *)sptep);
 		}
 	}
-
+out:
+	/* @data has hva passed to kvm_age_hva(). */
+	trace_kvm_age_page(data, slot, young);
 	return young;
 }
 
@@ -1337,7 +1334,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 int kvm_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_age_rmapp);
+	return kvm_handle_hva(kvm, hva, hva, kvm_age_rmapp);
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
-- 
1.7.5.4

