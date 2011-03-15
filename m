Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1CPViR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:38:17 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52510 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755584Ab1CPViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:38:10 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chris Zankel <chris@zankel.net>
Cc: tglx@linutronix.de, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/2] xtensa/mm: remove pgtable.c
Date: Tue, 15 Mar 2011 22:49:32 +0100
Message-Id: <1300225773-3548-2-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1300225773-3548-1-git-send-email-sebastian@breakpoint.cc>
References: <1300225773-3548-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is not referenced by any Makefile. pte_alloc_one_kernel() and
pte_alloc_one() is implemented in arch/xtensa/include/asm/pgalloc.h.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/xtensa/mm/pgtable.c |   72 ----------------------------------------------
 1 files changed, 0 insertions(+), 72 deletions(-)
 delete mode 100644 arch/xtensa/mm/pgtable.c

diff --git a/arch/xtensa/mm/pgtable.c b/arch/xtensa/mm/pgtable.c
deleted file mode 100644
index 6979927..0000000
--- a/arch/xtensa/mm/pgtable.c
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * arch/xtensa/mm/pgtable.c
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- *
- * Chris Zankel <chris@zankel.net>
- */
-
-#if (DCACHE_SIZE > PAGE_SIZE)
-
-pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	pte_t *pte = NULL, *p;
-	int color = ADDR_COLOR(address);
-	int i;
-
-	p = (pte_t*) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, COLOR_ORDER);
-
-	if (likely(p)) {
-		split_page(virt_to_page(p), COLOR_ORDER);
-
-		for (i = 0; i < COLOR_SIZE; i++) {
-			if (ADDR_COLOR(p) == color)
-				pte = p;
-			else
-				free_page(p);
-			p += PTRS_PER_PTE;
-		}
-		clear_page(pte);
-	}
-	return pte;
-}
-
-#ifdef PROFILING
-
-int mask;
-int hit;
-int flush;
-
-#endif
-
-struct page* pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct page *page = NULL, *p;
-	int color = ADDR_COLOR(address);
-
-	p = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
-
-	if (likely(p)) {
-		split_page(p, COLOR_ORDER);
-
-		for (i = 0; i < PAGE_ORDER; i++) {
-			if (PADDR_COLOR(page_address(p)) == color)
-				page = p;
-			else
-				__free_page(p);
-			p++;
-		}
-		clear_highpage(page);
-	}
-
-	return page;
-}
-
-#endif
-
-
-
-- 
1.7.4.1

