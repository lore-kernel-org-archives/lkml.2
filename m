Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0LOWVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:21:08 -0500
Received: from claw.goop.org ([74.207.240.146]:47902 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/9] vmalloc: use apply_to_page_range_batch() for vunmap_page_range()
Date: Wed, 15 Dec 2010 14:19:51 -0800
Message-Id: <48e58c3147aa3548db2a99e3eee854a7bf9e4696.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need to open-code it when there's helpful utility function
to do the job.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
---
 mm/vmalloc.c |   53 +++++++++--------------------------------------------
 1 files changed, 9 insertions(+), 44 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 67ce748..5c5ad6a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -33,59 +33,24 @@
 
 /*** Page table manipulation functions ***/
 
-static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
+static int vunmap_pte(pte_t *pte, unsigned count,
+		      unsigned long addr, void *data)
 {
-	pte_t *pte;
-
-	pte = pte_offset_kernel(pmd, addr);
-	do {
+	while (count--) {
 		pte_t ptent = *pte;
-		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
-		pte_clear(&init_mm, addr, pte);
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-}
-
-static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
-{
-	pmd_t *pmd;
-	unsigned long next;
 
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		vunmap_pte_range(pmd, addr, next);
-	} while (pmd++, addr = next, addr != end);
-}
+		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 
-static void vunmap_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end)
-{
-	pud_t *pud;
-	unsigned long next;
+		pte_clear(&init_mm, addr, pte++);
+		addr += PAGE_SIZE;
+	}
 
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		vunmap_pmd_range(pud, addr, next);
-	} while (pud++, addr = next, addr != end);
+	return 0;
 }
 
 static void vunmap_page_range(unsigned long addr, unsigned long end)
 {
-	pgd_t *pgd;
-	unsigned long next;
-
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		vunmap_pud_range(pgd, addr, next);
-	} while (pgd++, addr = next, addr != end);
+	apply_to_page_range_batch(&init_mm, addr, end - addr, vunmap_pte, NULL);
 }
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-- 
1.7.3.3

