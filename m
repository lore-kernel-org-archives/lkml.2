Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112Ab2DMKNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:13:20 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51343 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934716Ab2DMKNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:13:18 -0400
Message-ID: <4F87FC36.20307@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:13:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 08/16] KVM: MMU: store more bits in rmap
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-5140-0000-0000-0000010FAD00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, only one bit (bit 0) is used in rmap, this patch
export more bits from rmap, during spte add/remove, only bit 0 is
touched and other bits are keeped

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |  138 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 85 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4e91e94..53e92de 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -796,13 +796,24 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	return level - 1;
 }

+#define PTE_LIST_DESC		(0x1ull)
+#define PTE_LIST_FLAG_MASK	(0x3ull)
+
+static void
+pte_list_decode(const unsigned long *pte_list, unsigned long *map,
+		unsigned long *flags)
+{
+	*map = *pte_list & (~PTE_LIST_FLAG_MASK);
+	*flags = *pte_list & PTE_LIST_FLAG_MASK;
+}
+
 /*
  * Pte mapping structures:
  *
- * If pte_list bit zero is zero, then pte_list point to the spte.
+ * If PTE_LIST_DESC bit is zero, then pte_list point to the spte.
  *
- * If pte_list bit zero is one, (then pte_list & ~1) points to a struct
- * pte_list_desc containing more mappings.
+ * If PTE_LIST_DESC bit is one, (then pte_list & ~PTE_LIST_FLAG_MASK) points
+ * to a struct pte_list_desc containing more mappings.
  *
  * Returns the number of pte entries before the spte was added or zero if
  * the spte was not added.
@@ -812,39 +823,52 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			unsigned long *pte_list)
 {
 	struct pte_list_desc *desc;
+	unsigned long map, flags;
 	int i, count = 0;

-	if (!*pte_list) {
+	pte_list_decode(pte_list, &map, &flags);
+
+	if (!map) {
 		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
-		*pte_list = (unsigned long)spte;
-	} else if (!(*pte_list & 1)) {
+		WARN_ON(flags & PTE_LIST_DESC);
+		*pte_list = (unsigned long)spte | flags;
+
+		 return 0;
+	}
+
+	if (!(flags & PTE_LIST_DESC)) {
 		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_pte_list_desc(vcpu);
-		desc->sptes[0] = (u64 *)*pte_list;
+		desc->sptes[0] = (u64 *)map;
 		desc->sptes[1] = spte;
-		*pte_list = (unsigned long)desc | 1;
-		++count;
-	} else {
-		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
-			desc = desc->more;
-			count += PTE_LIST_EXT;
-		}
-		if (desc->sptes[PTE_LIST_EXT-1]) {
-			desc->more = mmu_alloc_pte_list_desc(vcpu);
-			desc = desc->more;
-		}
-		for (i = 0; desc->sptes[i]; ++i)
-			++count;
-		desc->sptes[i] = spte;
+		*pte_list = (unsigned long)desc | flags | PTE_LIST_DESC;
+
+		return 1;
+	}
+
+	rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
+	desc = (struct pte_list_desc *)map;
+	while (desc->sptes[PTE_LIST_EXT - 1] && desc->more) {
+		desc = desc->more;
+		count += PTE_LIST_EXT;
 	}
+
+	if (desc->sptes[PTE_LIST_EXT - 1]) {
+		desc->more = mmu_alloc_pte_list_desc(vcpu);
+		desc = desc->more;
+	}
+
+	for (i = 0; desc->sptes[i]; ++i)
+		++count;
+	desc->sptes[i] = spte;
+
 	return count;
 }

 static void
 pte_list_desc_remove_entry(unsigned long *pte_list, struct pte_list_desc *desc,
-			   int i, struct pte_list_desc *prev_desc)
+			   int i, struct pte_list_desc *prev_desc,
+			   unsigned long flags)
 {
 	int j;

@@ -855,12 +879,13 @@ pte_list_desc_remove_entry(unsigned long *pte_list, struct pte_list_desc *desc,
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		*pte_list = (unsigned long)desc->sptes[0];
+		*pte_list = (unsigned long)desc->sptes[0] |
+					(flags & (~PTE_LIST_DESC)) ;
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
-			*pte_list = (unsigned long)desc->more | 1;
+			*pte_list = (unsigned long)desc->more | flags;
 	mmu_free_pte_list_desc(desc);
 }

@@ -868,36 +893,42 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
 {
 	struct pte_list_desc *desc;
 	struct pte_list_desc *prev_desc;
+	unsigned long map, flags;
 	int i;

-	if (!*pte_list) {
+	pte_list_decode(pte_list, &map, &flags);
+
+	if (!map) {
 		printk(KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
 		BUG();
-	} else if (!(*pte_list & 1)) {
+		return;
+	}
+
+	if (!(flags & PTE_LIST_DESC)) {
 		rmap_printk("pte_list_remove:  %p 1->0\n", spte);
-		if ((u64 *)*pte_list != spte) {
+		if ((u64 *)map != spte) {
 			printk(KERN_ERR "pte_list_remove:  %p 1->BUG\n", spte);
 			BUG();
 		}
-		*pte_list = 0;
-	} else {
-		rmap_printk("pte_list_remove:  %p many->many\n", spte);
-		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
-		prev_desc = NULL;
-		while (desc) {
-			for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
-				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(pte_list,
-							       desc, i,
-							       prev_desc);
-					return;
-				}
-			prev_desc = desc;
-			desc = desc->more;
-		}
-		pr_err("pte_list_remove: %p many->many\n", spte);
-		BUG();
+		*pte_list = flags;
+		return;
+	}
+
+	rmap_printk("pte_list_remove:  %p many->many\n", spte);
+	desc = (struct pte_list_desc *)map;
+	prev_desc = NULL;
+	while (desc) {
+		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
+			if (desc->sptes[i] == spte) {
+				pte_list_desc_remove_entry(pte_list,
+						desc, i, prev_desc, flags);
+				return;
+			}
+		prev_desc = desc;
+		desc = desc->more;
 	}
+	pr_err("pte_list_remove: %p many->many\n", spte);
+	BUG();
 }

 /*
@@ -932,21 +963,22 @@ static void pte_list_walk_check_restart(struct spte_iterator *iter, u64 *spte)

 static u64 *pte_list_first(struct spte_iterator *iter)
 {
-	unsigned long pte_list = *iter->pte_list;
+	unsigned long map, flags;
 	u64 *sptep;

-	if (!pte_list)
+	pte_list_decode(iter->pte_list, &map, &flags);
+
+	if (!map)
 		return NULL;

-	if (!(pte_list & 1)) {
+	if (!(flags & PTE_LIST_DESC)) {
 		iter->desc = NULL;
 		iter->pos = 0;
-		sptep = (u64 *)pte_list;
-
+		sptep = (u64 *)map;
 		goto exit;
 	}

-	iter->desc = (struct pte_list_desc *)(pte_list & ~1ul);
+	iter->desc = (struct pte_list_desc *)map;
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];

-- 
1.7.7.6

