Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2GBI7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:59:55 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41473 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab2GBI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:59:49 -0400
Date: Mon, 2 Jul 2012 17:59:33 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 8/8] KVM: MMU: Avoid handling same rmap_pde in
 kvm_handle_hva_range()
Message-Id: <20120702175933.58a4960c.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120702175239.5fec56b3.yoshikawa.takuya@oss.ntt.co.jp>
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

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3082199..d07b4ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1201,7 +1201,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 
 	kvm_for_each_memslot(memslot, slots) {
 		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
+		gfn_t gfn_start, gfn_end;
 
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
@@ -1210,19 +1210,27 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 			continue;
 		/*
 		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn, gfn+1, ..., gfn_end-1}.
+		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
 		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
+		gfn_start = hva_to_gfn_memslot(hva_start, memslot);
 		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
 
-		for (; gfn < gfn_end; ++gfn) {
-			for (j = PT_PAGE_TABLE_LEVEL;
-			     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
-				unsigned long *rmapp;
+		for (j = PT_PAGE_TABLE_LEVEL;
+		     j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
+			unsigned long idx, idx_end;
+			unsigned long *rmapp;
 
-				rmapp = __gfn_to_rmap(gfn, j, memslot);
-				ret |= handler(kvm, rmapp, memslot, data);
-			}
+			/*
+			 * {idx(page_j) | page_j intersects with
+			 *  [hva_start, hva_end)} = {idx, idx+1, ..., idx_end}.
+			 */
+			idx = gfn_to_index(gfn_start, memslot->base_gfn, j);
+			idx_end = gfn_to_index(gfn_end - 1, memslot->base_gfn, j);
+
+			rmapp = __gfn_to_rmap(gfn_start, j, memslot);
+
+			for (; idx <= idx_end; ++idx)
+				ret |= handler(kvm, rmapp++, memslot, data);
 		}
 	}
 
-- 
1.7.5.4

