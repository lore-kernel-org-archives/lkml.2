Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2FOLdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:33:16 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:53991 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2FOLdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:33:14 -0400
Date: Fri, 15 Jun 2012 20:32:30 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of
 addresses
Message-Id: <20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
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

  for each guest page
    for each memslot
      if page is in memslot
        unmap using rmap

This means although every page in that range is expected to be found in
the same memslot, we are forced to check unrelated memslots many times.
If the guest has more memslots, the situation will become worse.

This patch, together with the following patch, solves this problem by
introducing kvm_handle_hva_range() which makes the loop look like this:

  for each memslot
    for each guest page in memslot
      unmap using rmap

In this new processing, the actual work is converted to the loop over
rmap array which is much more cache friendly than before.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Alexander Graf <agraf@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   25 +++++++++++++++++++------
 arch/x86/kvm/mmu.c                  |   32 ++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 53716dd..97465ba 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -756,9 +756,12 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	goto out_put;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
-					 unsigned long gfn))
+static int kvm_handle_hva_range(struct kvm *kvm,
+				unsigned long start_hva,
+				unsigned long end_hva,
+				int (*handler)(struct kvm *kvm,
+					       unsigned long *rmapp,
+					       unsigned long gfn))
 {
 	int ret;
 	int retval = 0;
@@ -767,10 +770,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
-		gfn_t gfn = hva_to_gfn(hva, memslot);
+		gfn_t gfn = hva_to_gfn(start_hva, memslot);
+		gfn_t end_gfn = hva_to_gfn(end_hva, memslot);
 
-		if (gfn >= memslot->base_gfn &&
-		    gfn < memslot->base_gfn + memslot->npages) {
+		gfn = max(gfn, memslot->base_gfn);
+		end_gfn = min(end_gfn, memslot->base_gfn + memslot->npages);
+
+		for (; gfn < end_gfn; gfn++) {
 			gfn_t gfn_offset = gfn - memslot->base_gfn;
 
 			ret = handler(kvm, &memslot->rmap[gfn_offset], gfn);
@@ -781,6 +787,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
index ba57b3b..3629f9b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1185,10 +1185,13 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	return 0;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  unsigned long data,
-			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
-					 unsigned long data))
+static int kvm_handle_hva_range(struct kvm *kvm,
+				unsigned long start_hva,
+				unsigned long end_hva,
+				unsigned long data,
+				int (*handler)(struct kvm *kvm,
+					       unsigned long *rmapp,
+					       unsigned long data))
 {
 	int j;
 	int ret;
@@ -1199,10 +1202,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots) {
-		gfn_t gfn = hva_to_gfn(hva, memslot);
+		gfn_t gfn = hva_to_gfn(start_hva, memslot);
+		gfn_t end_gfn = hva_to_gfn(end_hva, memslot);
+
+		gfn = max(gfn, memslot->base_gfn);
+		end_gfn = min(end_gfn, memslot->base_gfn + memslot->npages);
 
-		if (gfn >= memslot->base_gfn &&
-		    gfn < memslot->base_gfn + memslot->npages) {
+		for (; gfn < end_gfn; gfn++) {
 			ret = 0;
 
 			for (j = PT_PAGE_TABLE_LEVEL;
@@ -1212,7 +1218,9 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
@@ -1220,6 +1228,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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

