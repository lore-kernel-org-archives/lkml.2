Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0LOWUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:20:16 -0500
Received: from claw.goop.org ([74.207.240.146]:47865 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0LOWUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:11 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/9] ioremap: use apply_to_page_range_batch() for ioremap_page_range()
Date: Wed, 15 Dec 2010 14:19:49 -0800
Message-Id: <7a08704e275e6dd0b0513c47e881d2d6fff30ef3.1292450600.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 lib/ioremap.c |   85 +++++++++++++++------------------------------------------
 1 files changed, 22 insertions(+), 63 deletions(-)

diff --git a/lib/ioremap.c b/lib/ioremap.c
index 5730ecd..c049047 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -12,81 +12,40 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+struct ioremap_data
 {
-	pte_t *pte;
+	phys_addr_t phys_addr;
+	pgprot_t prot;
+};
+
+static int ioremap_pte_range(pte_t *pte, unsigned count,
+			     unsigned long addr, void *v)
+{
+	struct ioremap_data *data = v;
 	u64 pfn;
 
-	pfn = phys_addr >> PAGE_SHIFT;
-	pte = pte_alloc_kernel(pmd, addr);
-	if (!pte)
-		return -ENOMEM;
-	do {
-		BUG_ON(!pte_none(*pte));
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
+	pfn = data->phys_addr >> PAGE_SHIFT;
+	data->phys_addr += count * PAGE_SIZE;
 
-static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
-{
-	pmd_t *pmd;
-	unsigned long next;
+	while (count--) {
+		BUG_ON(!pte_none(*pte));
 
-	phys_addr -= addr;
-	pmd = pmd_alloc(&init_mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+		set_pte_at(&init_mm, addr, pte++, pfn_pte(pfn++, data->prot));
 
-static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
-{
-	pud_t *pud;
-	unsigned long next;
+		addr += PAGE_SIZE;
+	}
 
-	phys_addr -= addr;
-	pud = pud_alloc(&init_mm, pgd, addr);
-	if (!pud)
-		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (ioremap_pmd_range(pud, addr, next, phys_addr + addr, prot))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
-int ioremap_page_range(unsigned long addr,
-		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+int ioremap_page_range(unsigned long addr, unsigned long end,
+		       phys_addr_t phys_addr, pgprot_t prot)
 {
-	pgd_t *pgd;
-	unsigned long start;
-	unsigned long next;
-	int err;
-
-	BUG_ON(addr >= end);
-
-	start = addr;
-	phys_addr -= addr;
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = ioremap_pud_range(pgd, addr, next, phys_addr+addr, prot);
-		if (err)
-			break;
-	} while (pgd++, addr = next, addr != end);
+	struct ioremap_data data = { .phys_addr = phys_addr, .prot = prot };
+	int err = apply_to_page_range_batch(&init_mm, addr, end - addr,
+					    ioremap_pte_range, &data);
 
-	flush_cache_vmap(start, end);
+	flush_cache_vmap(addr, end);
 
 	return err;
 }
-- 
1.7.3.3

