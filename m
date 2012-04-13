Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082Ab2DMKKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:10:54 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60681 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935044Ab2DMKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:10:51 -0400
Message-ID: <4F87FBA5.3060203@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:10:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 03/16] KVM: MMU: properly assert spte on rmap walking path
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041301-3568-0000-0000-00000187BBF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only test present bit is not enough since mmio spte is also set this
bit, use is_shadow_present_pte() instead of it

Also move the BUG_ONs to the common function to cleanup the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index aee13c6..91518b6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -993,17 +993,25 @@ struct rmap_iterator {
  */
 static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
 {
+	u64 *sptep;
+
 	if (!rmap)
 		return NULL;

 	if (!(rmap & 1)) {
 		iter->desc = NULL;
-		return (u64 *)rmap;
+		sptep = (u64 *)rmap;
+
+		goto exit;
 	}

 	iter->desc = (struct pte_list_desc *)(rmap & ~1ul);
 	iter->pos = 0;
-	return iter->desc->sptes[iter->pos];
+	sptep = iter->desc->sptes[iter->pos];
+
+exit:
+	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
+	return sptep;
 }

 /*
@@ -1013,14 +1021,14 @@ static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
  */
 static u64 *rmap_get_next(struct rmap_iterator *iter)
 {
+	u64 *sptep = NULL;
+
 	if (iter->desc) {
 		if (iter->pos < PTE_LIST_EXT - 1) {
-			u64 *sptep;
-
 			++iter->pos;
 			sptep = iter->desc->sptes[iter->pos];
 			if (sptep)
-				return sptep;
+				goto exit;
 		}

 		iter->desc = iter->desc->more;
@@ -1028,11 +1036,14 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 		if (iter->desc) {
 			iter->pos = 0;
 			/* desc->sptes[0] cannot be NULL */
-			return iter->desc->sptes[iter->pos];
+			sptep = iter->desc->sptes[iter->pos];
+			goto exit;
 		}
 	}

-	return NULL;
+exit:
+	WARN_ON(sptep && !is_shadow_present_pte(*sptep));
+	return sptep;
 }

 static void drop_spte(struct kvm *kvm, u64 *sptep)
@@ -1048,7 +1059,6 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
 	int write_protected = 0;

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

 		if (!is_writable_pte(*sptep)) {
@@ -1123,7 +1133,6 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	int need_tlb_flush = 0;

 	while ((sptep = rmap_get_first(*rmapp, &iter))) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", sptep, *sptep);

 		drop_spte(kvm, sptep);
@@ -1147,7 +1156,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	new_pfn = pte_pfn(*ptep);

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
-		BUG_ON(!is_shadow_present_pte(*sptep));
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);

 		need_flush = 1;
@@ -1242,14 +1250,11 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		return kvm_unmap_rmapp(kvm, rmapp, data);

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-
+	     sptep = rmap_get_next(&iter))
 		if (*sptep & PT_ACCESSED_MASK) {
 			young = 1;
 			clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
 		}
-	}

 	return young;
 }
@@ -1270,14 +1275,11 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 		goto out;

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
-	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-
+	     sptep = rmap_get_next(&iter))
 		if (*sptep & PT_ACCESSED_MASK) {
 			young = 1;
 			break;
 		}
-	}
 out:
 	return young;
 }
-- 
1.7.7.6

