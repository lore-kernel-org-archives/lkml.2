Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab2FUIwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:52:06 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38944 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab2FUIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:52:02 -0400
Date: Thu, 21 Jun 2012 17:51:49 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 5/6] KVM: Separate rmap_pde from kvm_lpage_info->write_count
Message-Id: <20120621175149.5124d760.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to loop over rmap_pde arrays in the same way as
we do over rmap so that we can optimize kvm_handle_hva_range() easily in
the following patch.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |    6 +++---
 arch/x86/kvm/x86.c              |   11 +++++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d6ad50d..54c2378 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -487,11 +487,11 @@ struct kvm_vcpu_arch {
 };
 
 struct kvm_lpage_info {
-	unsigned long rmap_pde;
 	int write_count;
 };
 
 struct kvm_arch_memory_slot {
+	unsigned long *rmap_pde[KVM_NR_PAGE_SIZES - 1];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0659376..306711a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -931,13 +931,13 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
 static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
 				    struct kvm_memory_slot *slot)
 {
-	struct kvm_lpage_info *linfo;
+	unsigned long idx;
 
 	if (likely(level == PT_PAGE_TABLE_LEVEL))
 		return &slot->rmap[gfn - slot->base_gfn];
 
-	linfo = lpage_info_slot(gfn, slot, level);
-	return &linfo->rmap_pde;
+	idx = gfn_to_index(gfn, slot->base_gfn, level);
+	return &slot->arch.rmap_pde[level - PT_DIRECTORY_LEVEL][idx];
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ed5983..e2f41d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6303,6 +6303,10 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i) {
+		if (!dont || free->arch.rmap_pde[i] != dont->arch.rmap_pde[i]) {
+			kvm_kvfree(free->arch.rmap_pde[i]);
+			free->arch.rmap_pde[i] = NULL;
+		}
 		if (!dont || free->arch.lpage_info[i] != dont->arch.lpage_info[i]) {
 			kvm_kvfree(free->arch.lpage_info[i]);
 			free->arch.lpage_info[i] = NULL;
@@ -6322,6 +6326,11 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
+		slot->arch.rmap_pde[i] =
+			kvm_kvzalloc(lpages * sizeof(*slot->arch.rmap_pde[i]));
+		if (!slot->arch.rmap_pde[i])
+			goto out_free;
+
 		slot->arch.lpage_info[i] =
 			kvm_kvzalloc(lpages * sizeof(*slot->arch.lpage_info[i]));
 		if (!slot->arch.lpage_info[i])
@@ -6350,7 +6359,9 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
 
 out_free:
 	for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i) {
+		kvm_kvfree(slot->arch.rmap_pde[i]);
 		kvm_kvfree(slot->arch.lpage_info[i]);
+		slot->arch.rmap_pde[i] = NULL;
 		slot->arch.lpage_info[i] = NULL;
 	}
 	return -ENOMEM;
-- 
1.7.5.4

