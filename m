Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1CMShX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 14:37:23 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:38583 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab1CMShV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 14:37:21 -0400
Message-ID: <4D7D0ED6.2050504@free.fr>
Date: Sun, 13 Mar 2011 19:37:10 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] x86 : Add NX protection for kernel data on 64 bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpu hotplug code read data in head_64.S (phys_base) before enabling NX, so when
we enable NX on data, an triple fault happen because a reserved bit is set.
It was fixed by allocating dedicated page table for ident mapping in trampoline.
Now data can be protected by NX.

The Low kernel Mapping is also set to NX.

Finaly we preserve large page mapping by applying nx in free_init_pages only 
when we switch to NX mode

mapping now look like :
---[ Low Kernel Mapping ]---
0xffff880000000000-0xffff880000200000           2M     RW             GLB NX pte
0xffff880000200000-0xffff880001000000          14M     RW         PSE GLB NX pmd
0xffff880001000000-0xffff880001200000           2M     ro         PSE GLB NX pmd
0xffff880001200000-0xffff8800012ae000         696K     ro             GLB NX pte
0xffff8800012ae000-0xffff880001400000        1352K     RW             GLB NX pte
0xffff880001400000-0xffff880001503000        1036K     ro             GLB NX pte
0xffff880001503000-0xffff880001600000        1012K     RW             GLB NX pte
0xffff880001600000-0xffff880007e00000         104M     RW         PSE GLB NX pmd
0xffff880007e00000-0xffff880007ffd000        2036K     RW             GLB NX pte
0xffff880007ffd000-0xffff880008000000          12K                           pte
0xffff880008000000-0xffff880040000000         896M                           pmd
0xffff880040000000-0xffff888000000000         511G                           pud
0xffff888000000000-0xffffc90000000000       66048G                           pgd
---[ vmalloc() Area ]---
[...]
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff81400000           4M     ro         PSE GLB x  pmd
0xffffffff81400000-0xffffffff81600000           2M     ro         PSE GLB NX pmd
0xffffffff81600000-0xffffffff81800000           2M     RW         PSE GLB NX pmd
0xffffffff81800000-0xffffffffa0000000         488M                           pmd
---[ Modules ]---

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Test-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/head_64.S       |   15 +++++++++++++++
 arch/x86/kernel/trampoline_64.S |    4 ++--
 arch/x86/mm/init.c              |    6 ++++--
 arch/x86/mm/init_64.c           |    6 +++++-
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e11e394..e261354 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -140,6 +140,9 @@ ident_complete:
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 
+	addq	%rbp, trampoline_level3_ident_pgt + 0(%rip)
+	addq	%rbp, trampoline_level3_ident_pgt + (L3_START_KERNEL*8)(%rip)
+
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
 	 * filled with 0x90 (nop)
@@ -395,6 +398,18 @@ NEXT_PAGE(level2_kernel_pgt)
 NEXT_PAGE(level2_spare_pgt)
 	.fill   512, 8, 0
 
+NEXT_PAGE(trampoline_level3_ident_pgt)
+	.quad	trampoline_level2_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill	L3_START_KERNEL-1,8,0
+	.quad	trampoline_level2_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.fill	511-L3_START_KERNEL,8,0
+
+
+NEXT_PAGE(trampoline_level2_ident_pgt)
+	/* Since I easily can, map the first 1G.
+	 * Don't set NX because code runs from these pages.
+	 */
+	PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)
 #undef PMDS
 #undef NEXT_PAGE
 
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 09ff517..8723e47 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -164,8 +164,8 @@ trampoline_stack:
 	.org 0x1000
 trampoline_stack_end:
 ENTRY(trampoline_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.quad	trampoline_level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
 	.fill	510,8,0
-	.quad	level3_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
+	.quad	trampoline_level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
 
 ENTRY(trampoline_end)
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..98dd5fa 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -338,8 +338,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	 * we are going to free part of that, we need to make that
 	 * writeable and non-executable first.
 	 */
-	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
-	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	if (kernel_set_to_readonly) {
+		set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
+		set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	}
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a08a62c..5265335 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -778,6 +778,7 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
@@ -788,11 +789,14 @@ void mark_rodata_ro(void)
 
 	kernel_set_to_readonly = 1;
 
+	/* make low level mapping NX */
+	set_memory_nx(PAGE_OFFSET, (PMD_PAGE_SIZE*PTRS_PER_PMD) >> PAGE_SHIFT);
+
 	/*
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
-- 
1.7.4.1

