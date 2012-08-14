Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2HNSIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:08:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43490 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2HNSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:08:09 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] MIPS: Align swapper_pg_dir to 64K for better TLB Refill code.
Date: Tue, 14 Aug 2012 11:08:01 -0700
Message-Id: <1344967681-13179-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
References: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We can save an instruction in the TLB Refill path for kernel mappings
by aligning swapper_pg_dir on a 64K boundary.  The address of
swapper_pg_dir can be generated with a single LUI instead of
LUI/{D}ADDUI.

The alignment of __init_end is bumped up to 64K so there are no holes
between it and swapper_pg_dir, which is placed at the very beginning
of .bss.

The alignment of invalid_pmd_table and invalid_pte_table can be
relaxed to PAGE_SIZE.  We do this by using __page_aligned_bss, which
has the added benefit of eliminating alignment holes in .bss.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/vmlinux.lds.S |   21 +++++++++++++++++++--
 arch/mips/mm/init.c            |   17 +++++++++--------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index df243a6..007ccbe 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -1,6 +1,13 @@
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
+
+/*
+ * Put .bss..swapper_pg_dir as the first thing in .bss. This will
+ * ensure that it has .bss alignment (64K).
+ */
+#define BSS_FIRST_SECTIONS *(.bss..swapper_pg_dir)
+
 #include <asm-generic/vmlinux.lds.h>
 
 #undef mips
@@ -119,11 +126,21 @@ SECTIONS
 	}
 
 	PERCPU_SECTION(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
-	. = ALIGN(PAGE_SIZE);
+	/*
+	 * Align to 64K in attempt to eliminate holes before the
+	 * .bss..swapper_pg_dir section at the start of .bss.  This
+	 * also satisfies PAGE_SIZE alignment as the largest page size
+	 * allowed is 64K.
+	 */
+	. = ALIGN(0x10000);
 	__init_end = .;
 	/* freed after init ends here */
 
-	BSS_SECTION(0, 0, 0)
+	/*
+	 * Force .bss to 64K alignment so that .bss..swapper_pg_dir
+	 * gets that alignment.  .sbss should be empty, so there will be
+	 * no holes after __init_end. */
+	BSS_SECTION(0, 0x10000, 0)
 
 	_end = . ;
 
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 1a85ba9..be9acb2 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -469,19 +469,20 @@ void __init_refok free_initmem(void)
 #ifndef CONFIG_MIPS_PGD_C0_CONTEXT
 unsigned long pgd_current[NR_CPUS];
 #endif
-/*
- * On 64-bit we've got three-level pagetables with a slightly
- * different layout ...
- */
-#define __page_aligned(order) __attribute__((__aligned__(PAGE_SIZE<<order)))
 
 /*
  * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and PGD_ORDER
  * are constants.  So we use the variants from asm-offset.h until that gcc
  * will officially be retired.
+ *
+ * Align swapper_pg_dir in to 64K, allows its address to be loaded
+ * with a single LUI instruction in the TLB handlers.  If we used
+ * __aligned(64K), its size would get rounded up to the alignment
+ * size, and waste space.  So we place it in its own section and align
+ * it in the linker script.
  */
-pgd_t swapper_pg_dir[_PTRS_PER_PGD] __page_aligned(_PGD_ORDER);
+pgd_t swapper_pg_dir[_PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
 #ifndef __PAGETABLE_PMD_FOLDED
-pmd_t invalid_pmd_table[PTRS_PER_PMD] __page_aligned(PMD_ORDER);
+pmd_t invalid_pmd_table[PTRS_PER_PMD] __page_aligned_bss;
 #endif
-pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
-- 
1.7.2.3

