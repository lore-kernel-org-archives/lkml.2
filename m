Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab2FUIu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:50:57 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38918 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab2FUIuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:50:54 -0400
Date: Thu, 21 Jun 2012 17:50:37 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 3/6] KVM: MMU: Make kvm_handle_hva() handle range of
 addresses
Message-Id: <20120621175037.1f95a5cc.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When guest's memory is backed by THP pages, MMU notifier needs to call
kvm_unmap_hva(), which in turn leads to kvm_handle_hva(), in a loop to
invalidate a range of pages which constitute one huge page:

  for each page
    for each memslot
      if page is in memslot
        unmap using rmap

This means although every page in that range is expected to be found in
the same memslot, we are forced to check unrelated memslots many times.
If the guest has more memslots, the situation will become worse.

Furthermore, if the range does not include any pages in the guest's
memory, the loop over the pages will just consume extra time.

This patch, together with the following patches, solves this problem by
introducing kvm_handle_hva_range() which makes the loop look like this:

  for each memslot
    for each page in memslot
      unmap using rmap

In this new processing, the actual work is converted to a loop over rmap
which is much more cache friendly than before.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Alexander Graf <agraf@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   31 +++++++++++++++++++++-------
 arch/x86/kvm/mmu.c                  |   37 +++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 3703755..aec8046 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -756,9 +756,12 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	goto out_put;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
-					 unsigned long gfn))
+static int kvm_handle_hva_range(struct kvm *kvm,
+				unsigned long start,
+				unsigned long end,
+				int (*handler)(struct kvm *kvm,
+					       unsigned long *rmapp,
+					       unsigned long gfn))
 {
 	int ret;
 	int retval = 0;
@@ -767,12 +770,17 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
-		unsigned long start = memslot->userspace_addr;
-		unsigned long end;
+		gfn_t gfn;
+		unsigned long hva_start, hva_end;
 
-		end = start + (memslot->npages << PAGE_SHIFT);
-		if (hva >= start && hva < end) {
-			gfn_t gfn = hva_to_gfn_memslot(hva, memslot);
+		hva_start = max(start, memslot->userspace_addr);
+		hva_end = min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+		if (hva_start >= hva_end)
+			continue;
+
+		for (gfn = hva_to_gfn_memslot(hva_start, memslot);
+		     gfn < hva_to_gfn_memslot(hva_end, memslot); gfn++) {
 			gfn_t gfn_offset = gfn - memslot->base_gfn;
 
 			ret = handler(kvm, &memslot->rmap[gfn_offset], gfn);
@@ -783,6 +791,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	return retval;
 }
 
+static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
+			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
+					 unsigned long gfn))
+{
+	return kvm_handle_hva_range(kvm, hva, hva + PAGE_SIZE, handler);
+}
+
 static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			   unsigned long gfn)
 {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b898bec..f995b8a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1183,10 +1183,13 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	return 0;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  unsigned long data,
-			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
-					 unsigned long data))
+static int kvm_handle_hva_range(struct kvm *kvm,
+				unsigned long start,
+				unsigned long end,
+				unsigned long data,
+				int (*handler)(struct kvm *kvm,
+					       unsigned long *rmapp,
+					       unsigned long data))
 {
 	int j;
 	int ret;
@@ -1197,13 +1200,17 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots) {
-		unsigned long start = memslot->userspace_addr;
-		unsigned long end;
+		gfn_t gfn;
+		unsigned long hva_start, hva_end;
 
-		end = start + (memslot->npages << PAGE_SHIFT);
-		if (hva >= start && hva < end) {
-			gfn_t gfn = hva_to_gfn_memslot(hva, memslot);
+		hva_start = max(start, memslot->userspace_addr);
+		hva_end = min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+		if (hva_start >= hva_end)
+			continue;
 
+		for (gfn = hva_to_gfn_memslot(hva_start, memslot);
+		     gfn < hva_to_gfn_memslot(hva_end, memslot); gfn++) {
 			ret = 0;
 
 			for (j = PT_PAGE_TABLE_LEVEL;
@@ -1213,7 +1220,9 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 				rmapp = __gfn_to_rmap(gfn, j, memslot);
 				ret |= handler(kvm, rmapp, data);
 			}
-			trace_kvm_age_page(hva, memslot, ret);
+			trace_kvm_age_page(memslot->userspace_addr +
+					(gfn - memslot->base_gfn) * PAGE_SIZE,
+					memslot, ret);
 			retval |= ret;
 		}
 	}
@@ -1221,6 +1230,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	return retval;
 }
 
+static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
+			  unsigned long data,
+			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
+					 unsigned long data))
+{
+	return kvm_handle_hva_range(kvm, hva, hva + PAGE_SIZE, data, handler);
+}
+
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
 	return kvm_handle_hva(kvm, hva, 0, kvm_unmap_rmapp);
-- 
1.7.5.4

