Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab2FUIw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:52:56 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38971 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2FUIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:52:53 -0400
Date: Thu, 21 Jun 2012 17:52:38 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in
 kvm_handle_hva_range()
Message-Id: <20120621175238.705e6188.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we invalidate a THP page, we call the handler with the same
rmap_pde argument 512 times in the following loop:

  for each guest page in the range
    for each level
      unmap using rmap

This patch avoids these extra handler calls by changing the loop order
like this:

  for each level
    for each rmap in the range
      unmap using rmap

With the preceding patches in the patch series, this made THP page
invalidation more than 5 times faster on our x86 host: the host became
more responsive during swapping the guest's memory as a result.

Note: in the new code we could not use trace_kvm_age_page(), so we just
dropped the point from kvm_handle_hva_range().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 306711a..462becb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1192,16 +1192,15 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 					       unsigned long data))
 {
 	int j;
-	int ret;
-	int retval = 0;
+	int ret = 0;
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots) {
-		gfn_t gfn;
 		unsigned long hva_start, hva_end;
+		gfn_t gfn_start, gfn_end;
 
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
@@ -1209,25 +1208,27 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 		if (hva_start >= hva_end)
 			continue;
 
-		for (gfn = hva_to_gfn_memslot(hva_start, memslot);
-		     gfn < hva_to_gfn_memslot(hva_end, memslot); gfn++) {
-			ret = 0;
+		gfn_start = hva_to_gfn_memslot(hva_start, memslot);
+		gfn_end = hva_to_gfn_memslot(hva_end, memslot);
 
-			for (j = PT_PAGE_TABLE_LEVEL;
-			     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
-				unsigned long *rmapp;
+		for (j = PT_PAGE_TABLE_LEVEL;
+		     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
+			unsigned long idx, idx_end;
+			unsigned long *rmapp;
 
-				rmapp = __gfn_to_rmap(gfn, j, memslot);
-				ret |= handler(kvm, rmapp, data);
-			}
-			trace_kvm_age_page(memslot->userspace_addr +
-					(gfn - memslot->base_gfn) * PAGE_SIZE,
-					memslot, ret);
-			retval |= ret;
+			idx = gfn_to_index(gfn_start, memslot->base_gfn, j);
+			idx_end = gfn_to_index(gfn_end, memslot->base_gfn, j);
+
+			rmapp = __gfn_to_rmap(gfn_start, j, memslot);
+
+			/* Handle the first one even if idx == idx_end. */
+			do {
+				ret |= handler(kvm, rmapp++, data);
+			} while (++idx < idx_end);
 		}
 	}
 
-	return retval;
+	return ret;
 }
 
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-- 
1.7.5.4

