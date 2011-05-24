Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab1EXVnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:43:31 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34669 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932831Ab1EXVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:42 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 04/18] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*
Date: Tue, 24 May 2011 22:39:10 +0100
Message-Id: <1306273164-18217-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:45.0568 (UTC) FILETIME=[194C5200:01CC1A5B]
X-MC-Unique: 111052422394000701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLhZLg005098

PGDIR_SHIFT and PMD_SHIFT for the classic 2-level page table format have
the same value (21). This patch converts the PGDIR_* uses in the kernel
to the PMD_* equivalent so that LPAE builds can reuse the same code.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/module.c  |    2 +-
 arch/arm/mm/dma-mapping.c |    6 +++---
 arch/arm/mm/mmu.c         |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index fee7c36..116016d 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -33,7 +33,7 @@
  * recompiling the whole kernel when CONFIG_XIP_KERNEL is turned on/off.
  */
 #undef MODULES_VADDR
-#define MODULES_VADDR	(((unsigned long)_etext + ~PGDIR_MASK) & PGDIR_MASK)
+#define MODULES_VADDR	(((unsigned long)_etext + ~PMD_MASK) & PMD_MASK)
 #endif
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 82a093c..334e9af 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -121,8 +121,8 @@ static void __dma_free_buffer(struct page *page, size_t size)
 #endif
 
 #define CONSISTENT_OFFSET(x)	(((unsigned long)(x) - CONSISTENT_BASE) >> PAGE_SHIFT)
-#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PGDIR_SHIFT)
-#define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PGDIR_SHIFT)
+#define CONSISTENT_PTE_INDEX(x) (((unsigned long)(x) - CONSISTENT_BASE) >> PMD_SHIFT)
+#define NUM_CONSISTENT_PTES (CONSISTENT_DMA_SIZE >> PMD_SHIFT)
 
 /*
  * These are the page tables (2MB each) covering uncached, DMA consistent allocations
@@ -181,7 +181,7 @@ static int __init consistent_init(void)
 		}
 
 		consistent_pte[i++] = pte;
-		base += (1 << PGDIR_SHIFT);
+		base += (1 << PMD_SHIFT);
 	} while (base < CONSISTENT_END);
 
 	return ret;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9d8f0c8..a69f8e4 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -865,14 +865,14 @@ static inline void prepare_page_table(void)
 	/*
 	 * Clear out all the mappings below the kernel image.
 	 */
-	for (addr = 0; addr < MODULES_VADDR; addr += PGDIR_SIZE)
+	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 #ifdef CONFIG_XIP_KERNEL
 	/* The XIP kernel is mapped in the module area -- skip over it */
-	addr = ((unsigned long)_etext + PGDIR_SIZE - 1) & PGDIR_MASK;
+	addr = ((unsigned long)_etext + PMD_SIZE - 1) & PMD_MASK;
 #endif
-	for ( ; addr < PAGE_OFFSET; addr += PGDIR_SIZE)
+	for ( ; addr < PAGE_OFFSET; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
@@ -887,7 +887,7 @@ static inline void prepare_page_table(void)
 	 * memory bank, up to the end of the vmalloc region.
 	 */
 	for (addr = __phys_to_virt(end);
-	     addr < VMALLOC_END; addr += PGDIR_SIZE)
+	     addr < VMALLOC_END; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 }
 
@@ -928,7 +928,7 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	 */
 	vectors_page = early_alloc(PAGE_SIZE);
 
-	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
+	for (addr = VMALLOC_END; addr; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
 	/*

