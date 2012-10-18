Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2JRKMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:12:50 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13407
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab2JRKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:12:48 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zzzz1ce5h1202h1d1ah1cabh1d2ahzz8275bhz2ei87h2a8h668h839hd24he5bh107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddhff4m129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <akpm@linux-foundation.org>
CC: <aarcange@redhat.com>, <xiaoguangrong@linux.vnet.ibm.com>,
        <hughd@google.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <kirill.shutemov@linux.intel.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 1/4] thp: clean up __collapse_huge_page_isolate
Date: Thu, 18 Oct 2012 18:12:17 +0800
Message-ID: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are duplicated place using release_pte_pages().
And release_all_pte_pages() can also be removed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 mm/huge_memory.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a863af2..462d6ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1700,64 +1700,49 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte)
 	}
 }
 
-static void release_all_pte_pages(pte_t *pte)
-{
-	release_pte_pages(pte, pte + HPAGE_PMD_NR);
-}
-
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte)
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, isolated = 0, none = 0;
+	int referenced = 0, isolated = 1, none = 0;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
-			else {
-				release_pte_pages(pte, _pte);
+			else
 				goto out;
-			}
 		}
-		if (!pte_present(pteval) || !pte_write(pteval)) {
-			release_pte_pages(pte, _pte);
+		if (!pte_present(pteval) || !pte_write(pteval))
 			goto out;
-		}
 		page = vm_normal_page(vma, address, pteval);
-		if (unlikely(!page)) {
-			release_pte_pages(pte, _pte);
+		if (unlikely(!page))
 			goto out;
-		}
+
 		VM_BUG_ON(PageCompound(page));
 		BUG_ON(!PageAnon(page));
 		VM_BUG_ON(!PageSwapBacked(page));
 
 		/* cannot use mapcount: can't collapse if there's a gup pin */
-		if (page_count(page) != 1) {
-			release_pte_pages(pte, _pte);
+		if (page_count(page) != 1)
 			goto out;
-		}
 		/*
 		 * We can do it before isolate_lru_page because the
 		 * page can't be freed from under us. NOTE: PG_lock
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
 		 */
-		if (!trylock_page(page)) {
-			release_pte_pages(pte, _pte);
+		if (!trylock_page(page))
 			goto out;
-		}
 		/*
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
 		if (isolate_lru_page(page)) {
 			unlock_page(page);
-			release_pte_pages(pte, _pte);
 			goto out;
 		}
 		/* 0 stands for page_is_file_cache(page) == false */
@@ -1770,11 +1755,11 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (unlikely(!referenced))
-		release_all_pte_pages(pte);
-	else
-		isolated = 1;
+	if (unlikely(!referenced)) {
 out:
+		release_pte_pages(pte, _pte);
+		isolated = 0;
+	}
 	return isolated;
 }
 
-- 
1.7.9.5


