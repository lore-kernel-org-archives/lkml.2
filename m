Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0JaUim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 16:38:42 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:53430 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0JaUij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 16:38:39 -0400
Date: Sun, 31 Oct 2010 21:38:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Creasey <sammy@sammy.net>, Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH/RFC] m68k/sun3: Kill pte_unmap() warnings
Message-ID: <alpine.DEB.2.00.1010312135110.22279@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which one is preferable?

-------------------------------------------------------------------------------
Since commit 31c911329e048b715a1dfeaaf617be9430fd7f4e ("mm: check the argument
of kunmap on architectures without highmem"), we get lots of warnings like

arch/m68k/kernel/sys_m68k.c:508: warning: passing argument 1 of ¡kunmap¢ from incompatible pointer type

As m68k doesn't support highmem anyway, open code the calls to kmap() and
kunmap() (the latter is a no-op) to kill the warnings.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/sun3_pgtable.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
index cf5fad9..f55aa04 100644
--- a/arch/m68k/include/asm/sun3_pgtable.h
+++ b/arch/m68k/include/asm/sun3_pgtable.h
@@ -217,9 +217,8 @@ static inline pte_t pgoff_to_pte(unsigned off)
 /* Find an entry in the third-level pagetable. */
 #define pte_index(address) ((address >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 #define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
-/* FIXME: should we bother with kmap() here? */
-#define pte_offset_map(pmd, address) ((pte_t *)kmap(pmd_page(*pmd)) + pte_index(address))
-#define pte_unmap(pte) kunmap(pte)
+#define pte_offset_map(pmd, address) ((pte_t *)page_address(pmd_page(*pmd)) + pte_index(address))
+#define pte_unmap(pte) do { } while (0)
 
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
-- 
1.7.0.4
-------------------------------------------------------------------------------
Since commit 31c911329e048b715a1dfeaaf617be9430fd7f4e ("mm: check the argument
of kunmap on architectures without highmem"), we get lots of warnings like

arch/m68k/kernel/sys_m68k.c:508: warning: passing argument 1 of ¡kunmap¢ from incompatible pointer type

M68k doesn't support highmem, so kunmap() is a no-op anyway, but replace the
calls to k{,un}map() by calls to k{,un}map_atomic() to kill the warnings.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/sun3_pgtable.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
index cf5fad9..637dda4 100644
--- a/arch/m68k/include/asm/sun3_pgtable.h
+++ b/arch/m68k/include/asm/sun3_pgtable.h
@@ -218,8 +218,8 @@ static inline pte_t pgoff_to_pte(unsigned off)
 #define pte_index(address) ((address >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 #define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
 /* FIXME: should we bother with kmap() here? */
-#define pte_offset_map(pmd, address) ((pte_t *)kmap(pmd_page(*pmd)) + pte_index(address))
-#define pte_unmap(pte) kunmap(pte)
+#define pte_offset_map(pmd, address) ((pte_t *)kmap_atomic(pmd_page(*pmd)) + pte_index(address))
+#define pte_unmap(pte) kunmap_atomic(pte)
 
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
