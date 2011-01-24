Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1AXWWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:22:48 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:43915 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1AXWWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:22:47 -0500
Message-ID: <4D3DFBB0.90402@free.fr>
Date: Mon, 24 Jan 2011 23:22:40 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
        linux-security-module@vger.kernel.org
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
References: <1290410581.2405.24.camel@minggr.sh.intel.com>	 <1290431008.2072.119.camel@laptop>	<1290443379.4cea9a73cd9ce@imp.free.fr>	 <1290443758.2072.318.camel@laptop>	<20101122164247.GC21836@basil.fritz.box>	 <20101123235527.54293b59@mat-laptop>  <20101126183144.300a71a4@mat-laptop>	 <1291093230.2405.191.camel@minggr.sh.intel.com>	 <1291116438.32004.649.camel@laptop> <1291162504.2405.216.camel@minggr.sh.intel.com> <4D3C7C36.903@free.fr>
In-Reply-To: <4D3C7C36.903@free.fr>
Content-Type: multipart/mixed;
 boundary="------------040900090307050208080104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040900090307050208080104
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

matthieu castet a écrit :
> Lin Ming a écrit :
>> On Tue, 2010-11-30 at 19:27 +0800, Peter Zijlstra wrote:
>>> On Tue, 2010-11-30 at 13:00 +0800, Lin Ming wrote:
>>>> echo 0 > /sys/devices/system/cpu/cpu1/online;
>>>> echo 1 > /sys/devices/system/cpu/cpu1/online;
>>>>
>>>> then machine just reboots...
>>>>
> I tried to do the same thing on qemu, and the same behavior happened (ie 
> reboot when resuming cpu1).
> 
> After enabling qemu log, I found that a triple fault was happening at 
> the beginning of secondary_startup_64
> when doing "addq phys_base(%rip), %rax".
> 
> Why ?
> I suppose because we access data set to NX, but we don't have enabled 
> yet NX in the msr. So the cpu crash due to "reserved bit check".
> 
> If we enable NX before reading data, there is no more crash (patch 
> attached).
> 
> Now I am not sure this is the correct fix. I think the problem is that 
> trampoline using kernel page table
> is very dangerous. The kernel can have modified them atfer booting !
> May be all the paging stuff should have been done in head_64.S. A first 
> one with identity mapping, and the second one for
> the real kernel stuff.
> 
Lin, could you try this patch on your x64 machine.


Thanks

Matthieu

--------------040900090307050208080104
Content-Type: text/x-diff;
 name="0001-x86-Add-NX-protection-for-kernel-data-on-64-bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-Add-NX-protection-for-kernel-data-on-64-bit.patch"

>From c6d0a62d47be9956abb9d3e1b7c952eaa7e0df7e Mon Sep 17 00:00:00 2001
From: Matthieu CASTET <castet.matthieu@free.fr>
Date: Mon, 24 Jan 2011 23:12:45 +0100
Subject: [PATCH] x86 : Add NX protection for kernel data on 64 bit

This fix the cpu hotplug support, by allocating dedicated page table
for ident mapping in trampoline.
This is need because kernel set NX flag in level3_ident_pgt and
level3_kernel_pgt, and made it unusable from trampoline.

We also set the Low kernel Mapping to NX.

Finaly we apply nx in free_init_pages only when we switch to NX mode in order
to preserve large page mapping.

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
---
 arch/x86/kernel/head_64.S       |   18 ++++++++++++++++++
 arch/x86/kernel/trampoline_64.S |    4 ++--
 arch/x86/mm/init.c              |    6 ++++--
 arch/x86/mm/init_64.c           |    6 +++++-
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 239046b..47f56dc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -139,6 +139,9 @@ ident_complete:
 #ifdef CONFIG_X86_TRAMPOLINE
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
+
+	addq	%rbp, trampoline_level3_ident_pgt + 0(%rip)
+	addq	%rbp, trampoline_level3_ident_pgt + (L3_START_KERNEL*8)(%rip)
 #endif
 
 	/* Due to ENTRY(), sometimes the empty space gets filled with
@@ -396,6 +399,21 @@ NEXT_PAGE(level2_kernel_pgt)
 NEXT_PAGE(level2_spare_pgt)
 	.fill   512, 8, 0
 
+#ifdef CONFIG_X86_TRAMPOLINE
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
+#endif
+
 #undef PMDS
 #undef NEXT_PAGE
 
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 075d130..a408935 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -160,8 +160,8 @@ trampoline_stack:
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
index 947f42a..58d173b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -366,8 +366,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
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
index 71a5929..3840ecf 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -788,6 +788,7 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
@@ -798,11 +799,14 @@ void mark_rodata_ro(void)
 
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
1.7.2.3


--------------040900090307050208080104--
