Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2GBI6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:58:15 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:46847 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2GBI6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:58:13 -0400
Date: Mon, 2 Jul 2012 17:57:59 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 6/8] KVM: MMU: Add memslot parameter to hva handlers
Message-Id: <20120702175759.dfc178a2.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to push trace_kvm_age_page() into kvm_age_rmapp() in the
following patch.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f2c408a..bf8d50e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1124,7 +1124,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 }
 
 static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			   unsigned long data)
+			   struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1142,7 +1142,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 }
 
 static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			     unsigned long data)
+			     struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1189,6 +1189,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 				unsigned long data,
 				int (*handler)(struct kvm *kvm,
 					       unsigned long *rmapp,
+					       struct kvm_memory_slot *slot,
 					       unsigned long data))
 {
 	int j;
@@ -1223,7 +1224,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 				unsigned long *rmapp;
 
 				rmapp = __gfn_to_rmap(gfn, j, memslot);
-				ret |= handler(kvm, rmapp, data);
+				ret |= handler(kvm, rmapp, memslot, data);
 			}
 			trace_kvm_age_page(memslot->userspace_addr +
 					(gfn - memslot->base_gfn) * PAGE_SIZE,
@@ -1238,6 +1239,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  unsigned long data,
 			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
+					 struct kvm_memory_slot *slot,
 					 unsigned long data))
 {
 	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
@@ -1259,7 +1261,7 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 }
 
 static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			 unsigned long data)
+			 struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
 	struct rmap_iterator uninitialized_var(iter);
@@ -1274,7 +1276,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	 * out actively used pages or breaking up actively used hugepages.
 	 */
 	if (!shadow_accessed_mask)
-		return kvm_unmap_rmapp(kvm, rmapp, data);
+		return kvm_unmap_rmapp(kvm, rmapp, slot, data);
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
@@ -1291,7 +1293,7 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 }
 
 static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
-			      unsigned long data)
+			      struct kvm_memory_slot *slot, unsigned long data)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1329,7 +1331,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmapp, 0);
+	kvm_unmap_rmapp(vcpu->kvm, rmapp, NULL, 0);
 	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
-- 
1.7.5.4

