Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0LOWUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:20:20 -0500
Received: from claw.goop.org ([74.207.240.146]:47885 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0LOWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 6/9] vmalloc: use apply_to_page_range_batch() for vmap_page_range_noflush()
Date: Wed, 15 Dec 2010 14:19:52 -0800
Message-Id: <24592fddc8f945442fd429a2288611d0924b2a69.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need to open-code it when there's a helpful utility
function.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
---
 mm/vmalloc.c |   92 ++++++++++++++++++---------------------------------------
 1 files changed, 29 insertions(+), 63 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5c5ad6a..0e845bb 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -53,63 +53,34 @@ static void vunmap_page_range(unsigned long addr, unsigned long end)
 	apply_to_page_range_batch(&init_mm, addr, end - addr, vunmap_pte, NULL);
 }
 
-static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+struct vmap_data
 {
-	pte_t *pte;
+	struct page **pages;
+	unsigned index;
+	pgprot_t prot;
+};
 
-	/*
-	 * nr is a running index into the array which helps higher level
-	 * callers keep track of where we're up to.
-	 */
+static int vmap_pte(pte_t *pte, unsigned count,
+		    unsigned long addr, void *data)
+{
+	struct vmap_data *vmap = data;
 
-	pte = pte_alloc_kernel(pmd, addr);
-	if (!pte)
-		return -ENOMEM;
-	do {
-		struct page *page = pages[*nr];
+	while (count--) {
+		struct page *page = vmap->pages[vmap->index];
 
 		if (WARN_ON(!pte_none(*pte)))
 			return -EBUSY;
+
 		if (WARN_ON(!page))
 			return -ENOMEM;
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
 
-static int vmap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pmd_t *pmd;
-	unsigned long next;
-
-	pmd = pmd_alloc(&init_mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (vmap_pte_range(pmd, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+		set_pte_at(&init_mm, addr, pte, mk_pte(page, vmap->prot));
 
-static int vmap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pud_t *pud;
-	unsigned long next;
+		pte++;
+		addr += PAGE_SIZE;
+		vmap->index++;
+	}
 
-	pud = pud_alloc(&init_mm, pgd, addr);
-	if (!pud)
-		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
@@ -122,22 +93,17 @@ static int vmap_pud_range(pgd_t *pgd, unsigned long addr,
 static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages)
 {
-	pgd_t *pgd;
-	unsigned long next;
-	unsigned long addr = start;
-	int err = 0;
-	int nr = 0;
-
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
-		if (err)
-			return err;
-	} while (pgd++, addr = next, addr != end);
-
-	return nr;
+	int err;
+	struct vmap_data vmap = {
+		.pages = pages,
+		.index = 0,
+		.prot = prot
+	};
+	
+	err = apply_to_page_range_batch(&init_mm, start, end - start,
+					vmap_pte, &vmap);
+	
+	return err ? err : vmap.index;
 }
 
 static int vmap_page_range(unsigned long start, unsigned long end,
-- 
1.7.3.3

