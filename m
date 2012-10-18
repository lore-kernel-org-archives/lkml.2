Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2JRKMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:12:53 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:45672 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab2JRKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:12:50 -0400
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
Subject: [PATCH 2/4] thp: introduce hugepage_get_pmd()
Date: Thu, 18 Oct 2012 18:12:18 +0800
Message-ID: <1350555140-11030-2-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce hugepage_get_pmd() to simple code.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 mm/huge_memory.c |   68 ++++++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 41 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 462d6ea..e575b29 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1115,6 +1115,25 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	return ret;
 }
 
+static pmd_t *hugepage_get_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd = NULL;
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, address);
+out:
+	return pmd;
+}
+
 /*
  * Returns 1 if a given pmd maps a stable (not under splitting) thp.
  * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
@@ -1145,22 +1164,14 @@ pmd_t *page_check_address_pmd(struct page *page,
 			      unsigned long address,
 			      enum page_check_address_pmd_flag flag)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd, *ret = NULL;
 
 	if (address & ~HPAGE_PMD_MASK)
 		goto out;
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		goto out;
 	if (pmd_page(*pmd) != page)
@@ -1908,8 +1919,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
 				   int node)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
@@ -1955,16 +1964,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out;
 	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
-		goto out;
-
-	pmd = pmd_offset(pud, address);
-	/* pmd can't go away or become huge under us */
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
@@ -2048,8 +2050,6 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 			       unsigned long address,
 			       struct page **hpage)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int ret = 0, referenced = 0, none = 0;
@@ -2060,15 +2060,9 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
@@ -2363,21 +2357,13 @@ void __split_huge_page_pmd(struct mm_struct *mm, pmd_t *pmd)
 static void split_huge_page_address(struct mm_struct *mm,
 				    unsigned long address)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 
 	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		return;
-
-	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return;
 	/*
-- 
1.7.9.5


