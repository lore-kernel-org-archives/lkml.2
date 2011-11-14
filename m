Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1KNUCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:02:38 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35156 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1KNUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:02:36 -0500
Subject: [PATCH] ARM: drop support for the ARM1020E processor
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 21:02:22 +0100
Message-ID: <1321300942.20271.139.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for ARM1020E processor support (CPU_ARM1020E) depends
on 'n' since (at least) v2.6.12-rc2. Depending on 'n' is an uncommon way
to disable an entry, since that dependency will never be met.

According to the comment above this entry it "needs validating". It's
not entirely clear what that means. Effectively ARM1020E has been
disabled for over six years. This entry, and the code that requires it,
can be dropped now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=arm menuconfig before and after applying this
patch. In neither case could ARM1020E support be selected. git grepped
for any occurrences of ARM1020E after removing all this, but couldn't
find any. There does not seem to be stuff that can be removed because
this is removed.

1) Further testing, if needed, would require building (and running)
related stuff. But I don't think I own related hardware. I also haven't
got the needed toolchain(s) at hand.

 arch/arm/include/asm/glue-proc.h |    9 -
 arch/arm/mm/Kconfig              |   15 +-
 arch/arm/mm/Makefile             |    1 -
 arch/arm/mm/proc-arm1020e.S      |  486 --------------------------------------
 4 files changed, 1 insertions(+), 510 deletions(-)
 delete mode 100644 arch/arm/mm/proc-arm1020e.S

diff --git a/arch/arm/include/asm/glue-proc.h b/arch/arm/include/asm/glue-proc.h
index e2be7f1..25a511b 100644
--- a/arch/arm/include/asm/glue-proc.h
+++ b/arch/arm/include/asm/glue-proc.h
@@ -167,15 +167,6 @@
 # endif
 #endif
 
-#ifdef CONFIG_CPU_ARM1020E
-# ifdef CPU_NAME
-#  undef  MULTI_CPU
-#  define MULTI_CPU
-# else
-#  define CPU_NAME cpu_arm1020e
-# endif
-#endif
-
 #ifdef CONFIG_CPU_ARM1022
 # ifdef CPU_NAME
 #  undef  MULTI_CPU
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 67f75a0..9319a95 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -250,19 +250,6 @@ config CPU_ARM1020
 	  Say Y if you want support for the ARM1020 processor.
 	  Otherwise, say N.
 
-# ARM1020E - needs validating
-config CPU_ARM1020E
-	bool "Support ARM1020E processor" if ARCH_INTEGRATOR
-	select CPU_32v5
-	select CPU_ABRT_EV4T
-	select CPU_PABRT_LEGACY
-	select CPU_CACHE_V4WT
-	select CPU_CACHE_VIVT
-	select CPU_CP15_MMU
-	select CPU_COPY_V4WB if MMU
-	select CPU_TLB_V4WBI if MMU
-	depends on n
-
 # ARM1022E
 config CPU_ARM1022
 	bool "Support ARM1022E processor" if ARCH_INTEGRATOR
@@ -631,7 +618,7 @@ comment "Processor Features"
 
 config ARM_THUMB
 	bool "Support Thumb user binaries"
-	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_V6 || CPU_V6K || CPU_V7 || CPU_FEROCEON
+	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_V6 || CPU_V6K || CPU_V7 || CPU_FEROCEON
 	default y
 	help
 	  Say Y if you want to include kernel support for running user space
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index bca7e61..f065856 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -80,7 +80,6 @@ obj-$(CONFIG_CPU_ARM940T)	+= proc-arm940.o
 obj-$(CONFIG_CPU_ARM946E)	+= proc-arm946.o
 obj-$(CONFIG_CPU_FA526)		+= proc-fa526.o
 obj-$(CONFIG_CPU_ARM1020)	+= proc-arm1020.o
-obj-$(CONFIG_CPU_ARM1020E)	+= proc-arm1020e.o
 obj-$(CONFIG_CPU_ARM1022)	+= proc-arm1022.o
 obj-$(CONFIG_CPU_ARM1026)	+= proc-arm1026.o
 obj-$(CONFIG_CPU_SA110)		+= proc-sa110.o
diff --git a/arch/arm/mm/proc-arm1020e.S b/arch/arm/mm/proc-arm1020e.S
deleted file mode 100644
index 4251421..0000000
--- a/arch/arm/mm/proc-arm1020e.S
+++ /dev/null
@@ -1,486 +0,0 @@
-/*
- *  linux/arch/arm/mm/proc-arm1020e.S: MMU functions for ARM1020
- *
- *  Copyright (C) 2000 ARM Limited
- *  Copyright (C) 2000 Deep Blue Solutions Ltd.
- *  hacked for non-paged-MM by Hyok S. Choi, 2003.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- *
- * These are the low level assembler for performing cache and TLB
- * functions on the arm1020e.
- *
- *  CONFIG_CPU_ARM1020_CPU_IDLE -> nohlt
- */
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/assembler.h>
-#include <asm/asm-offsets.h>
-#include <asm/hwcap.h>
-#include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
-#include <asm/ptrace.h>
-
-#include "proc-macros.S"
-
-/*
- * This is the maximum size of an area which will be invalidated
- * using the single invalidate entry instructions.  Anything larger
- * than this, and we go for the whole cache.
- *
- * This value should be chosen such that we choose the cheapest
- * alternative.
- */
-#define MAX_AREA_SIZE	32768
-
-/*
- * The size of one data cache line.
- */
-#define CACHE_DLINESIZE	32
-
-/*
- * The number of data cache segments.
- */
-#define CACHE_DSEGMENTS	16
-
-/*
- * The number of lines in a cache segment.
- */
-#define CACHE_DENTRIES	64
-
-/*
- * This is the size at which it becomes more efficient to
- * clean the whole cache, rather than using the individual
- * cache line maintenance instructions.
- */
-#define CACHE_DLIMIT	32768
-
-	.text
-/*
- * cpu_arm1020e_proc_init()
- */
-ENTRY(cpu_arm1020e_proc_init)
-	mov	pc, lr
-
-/*
- * cpu_arm1020e_proc_fin()
- */
-ENTRY(cpu_arm1020e_proc_fin)
-	mrc	p15, 0, r0, c1, c0, 0		@ ctrl register
-	bic	r0, r0, #0x1000 		@ ...i............
-	bic	r0, r0, #0x000e 		@ ............wca.
-	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
-
-/*
- * cpu_arm1020e_reset(loc)
- *
- * Perform a soft reset of the system.	Put the CPU into the
- * same state as it would be if it had been reset, and branch
- * to what would be the reset vector.
- *
- * loc: location to jump to for soft reset
- */
-	.align	5
-ENTRY(cpu_arm1020e_reset)
-	mov	ip, #0
-	mcr	p15, 0, ip, c7, c7, 0		@ invalidate I,D caches
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-#ifdef CONFIG_MMU
-	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
-#endif
-	mrc	p15, 0, ip, c1, c0, 0		@ ctrl register
-	bic	ip, ip, #0x000f 		@ ............wcam
-	bic	ip, ip, #0x1100 		@ ...i...s........
-	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
-
-/*
- * cpu_arm1020e_do_idle()
- */
-	.align	5
-ENTRY(cpu_arm1020e_do_idle)
-	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
-
-/* ================================= CACHE ================================ */
-
-	.align	5
-
-/*
- *	flush_icache_all()
- *
- *	Unconditionally clean and invalidate the entire icache.
- */
-ENTRY(arm1020e_flush_icache_all)
-#ifndef CONFIG_CPU_ICACHE_DISABLE
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-#endif
-	mov	pc, lr
-ENDPROC(arm1020e_flush_icache_all)
-
-/*
- *	flush_user_cache_all()
- *
- *	Invalidate all cache entries in a particular address
- *	space.
- */
-ENTRY(arm1020e_flush_user_cache_all)
-	/* FALLTHROUGH */
-/*
- *	flush_kern_cache_all()
- *
- *	Clean and invalidate the entire cache.
- */
-ENTRY(arm1020e_flush_kern_cache_all)
-	mov	r2, #VM_EXEC
-	mov	ip, #0
-__flush_whole_cache:
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	r1, #(CACHE_DSEGMENTS - 1) << 5	@ 16 segments
-1:	orr	r3, r1, #(CACHE_DENTRIES - 1) << 26 @ 64 entries
-2:	mcr	p15, 0, r3, c7, c14, 2		@ clean+invalidate D index
-	subs	r3, r3, #1 << 26
-	bcs	2b				@ entries 63 to 0
-	subs	r1, r1, #1 << 5
-	bcs	1b				@ segments 15 to 0
-#endif
-	tst	r2, #VM_EXEC
-#ifndef CONFIG_CPU_ICACHE_DISABLE
-	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
-#endif
-	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	flush_user_cache_range(start, end, flags)
- *
- *	Invalidate a range of cache entries in the specified
- *	address space.
- *
- *	- start	- start address (inclusive)
- *	- end	- end address (exclusive)
- *	- flags	- vm_flags for this space
- */
-ENTRY(arm1020e_flush_user_cache_range)
-	mov	ip, #0
-	sub	r3, r1, r0			@ calculate total size
-	cmp	r3, #CACHE_DLIMIT
-	bhs	__flush_whole_cache
-
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-#endif
-	tst	r2, #VM_EXEC
-#ifndef CONFIG_CPU_ICACHE_DISABLE
-	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
-#endif
-	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	coherent_kern_range(start, end)
- *
- *	Ensure coherency between the Icache and the Dcache in the
- *	region described by start.  If you have non-snooping
- *	Harvard caches, you need to implement this function.
- *
- *	- start	- virtual start address
- *	- end	- virtual end address
- */
-ENTRY(arm1020e_coherent_kern_range)
-	/* FALLTHROUGH */
-/*
- *	coherent_user_range(start, end)
- *
- *	Ensure coherency between the Icache and the Dcache in the
- *	region described by start.  If you have non-snooping
- *	Harvard caches, you need to implement this function.
- *
- *	- start	- virtual start address
- *	- end	- virtual end address
- */
-ENTRY(arm1020e_coherent_user_range)
-	mov	ip, #0
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-#endif
-#ifndef CONFIG_CPU_ICACHE_DISABLE
-	mcr	p15, 0, r0, c7, c5, 1		@ invalidate I entry
-#endif
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	flush_kern_dcache_area(void *addr, size_t size)
- *
- *	Ensure no D cache aliasing occurs, either with itself or
- *	the I cache
- *
- *	- addr	- kernel address
- *	- size	- region size
- */
-ENTRY(arm1020e_flush_kern_dcache_area)
-	mov	ip, #0
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	add	r1, r0, r1
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-#endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	dma_inv_range(start, end)
- *
- *	Invalidate (discard) the specified virtual address range.
- *	May not write back any entries.  If 'start' or 'end'
- *	are not cache line aligned, those lines must be written
- *	back.
- *
- *	- start	- virtual start address
- *	- end	- virtual end address
- *
- * (same as v4wb)
- */
-arm1020e_dma_inv_range:
-	mov	ip, #0
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	tst	r0, #CACHE_DLINESIZE - 1
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r0, c7, c10, 1		@ clean D entry
-	tst	r1, #CACHE_DLINESIZE - 1
-	mcrne	p15, 0, r1, c7, c10, 1		@ clean D entry
-1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-#endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	dma_clean_range(start, end)
- *
- *	Clean the specified virtual address range.
- *
- *	- start	- virtual start address
- *	- end	- virtual end address
- *
- * (same as v4wb)
- */
-arm1020e_dma_clean_range:
-	mov	ip, #0
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-#endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	dma_flush_range(start, end)
- *
- *	Clean and invalidate the specified virtual address range.
- *
- *	- start	- virtual start address
- *	- end	- virtual end address
- */
-ENTRY(arm1020e_dma_flush_range)
-	mov	ip, #0
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	bic	r0, r0, #CACHE_DLINESIZE - 1
-1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	cmp	r0, r1
-	blo	1b
-#endif
-	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
-
-/*
- *	dma_map_area(start, size, dir)
- *	- start	- kernel virtual start address
- *	- size	- size of region
- *	- dir	- DMA direction
- */
-ENTRY(arm1020e_dma_map_area)
-	add	r1, r1, r0
-	cmp	r2, #DMA_TO_DEVICE
-	beq	arm1020e_dma_clean_range
-	bcs	arm1020e_dma_inv_range
-	b	arm1020e_dma_flush_range
-ENDPROC(arm1020e_dma_map_area)
-
-/*
- *	dma_unmap_area(start, size, dir)
- *	- start	- kernel virtual start address
- *	- size	- size of region
- *	- dir	- DMA direction
- */
-ENTRY(arm1020e_dma_unmap_area)
-	mov	pc, lr
-ENDPROC(arm1020e_dma_unmap_area)
-
-	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
-	define_cache_functions arm1020e
-
-	.align	5
-ENTRY(cpu_arm1020e_dcache_clean_area)
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	mov	ip, #0
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-	add	r0, r0, #CACHE_DLINESIZE
-	subs	r1, r1, #CACHE_DLINESIZE
-	bhi	1b
-#endif
-	mov	pc, lr
-
-/* =============================== PageTable ============================== */
-
-/*
- * cpu_arm1020e_switch_mm(pgd)
- *
- * Set the translation base pointer to be as described by pgd.
- *
- * pgd: new page tables
- */
-	.align	5
-ENTRY(cpu_arm1020e_switch_mm)
-#ifdef CONFIG_MMU
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	mcr	p15, 0, r3, c7, c10, 4
-	mov	r1, #0xF			@ 16 segments
-1:	mov	r3, #0x3F			@ 64 entries
-2:	mov	ip, r3, LSL #26 		@ shift up entry
-	orr	ip, ip, r1, LSL #5		@ shift in/up index
-	mcr	p15, 0, ip, c7, c14, 2		@ Clean & Inval DCache entry
-	mov	ip, #0
-	subs	r3, r3, #1
-	cmp	r3, #0
-	bge	2b				@ entries 3F to 0
-	subs	r1, r1, #1
-	cmp	r1, #0
-	bge	1b				@ segments 15 to 0
-
-#endif
-	mov	r1, #0
-#ifndef CONFIG_CPU_ICACHE_DISABLE
-	mcr	p15, 0, r1, c7, c5, 0		@ invalidate I cache
-#endif
-	mcr	p15, 0, r1, c7, c10, 4		@ drain WB
-	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
-	mcr	p15, 0, r1, c8, c7, 0		@ invalidate I & D TLBs
-#endif
-	mov	pc, lr
-        
-/*
- * cpu_arm1020e_set_pte(ptep, pte)
- *
- * Set a PTE and flush it out
- */
-	.align	5
-ENTRY(cpu_arm1020e_set_pte_ext)
-#ifdef CONFIG_MMU
-	armv3_set_pte_ext
-	mov	r0, r0
-#ifndef CONFIG_CPU_DCACHE_DISABLE
-	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
-#endif
-#endif /* CONFIG_MMU */
-	mov	pc, lr
-
-	__CPUINIT
-
-	.type	__arm1020e_setup, #function
-__arm1020e_setup:
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c7		@ invalidate I,D caches on v4
-	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer on v4
-#ifdef CONFIG_MMU
-	mcr	p15, 0, r0, c8, c7		@ invalidate I,D TLBs on v4
-#endif
-	adr	r5, arm1020e_crval
-	ldmia	r5, {r5, r6}
-	mrc	p15, 0, r0, c1, c0		@ get control register v4
-	bic	r0, r0, r5
-	orr	r0, r0, r6
-#ifdef CONFIG_CPU_CACHE_ROUND_ROBIN
-	orr	r0, r0, #0x4000 		@ .R.. .... .... ....
-#endif
-	mov	pc, lr
-	.size	__arm1020e_setup, . - __arm1020e_setup
-
-	/*
-	 *  R
-	 * .RVI ZFRS BLDP WCAM
-	 * .011 1001 ..11 0101
-	 */
-	.type	arm1020e_crval, #object
-arm1020e_crval:
-	crval	clear=0x00007f3f, mmuset=0x00003935, ucset=0x00001930
-
-	__INITDATA
-	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
-	define_processor_functions arm1020e, dabort=v4t_early_abort, pabort=legacy_pabort
-
-	.section ".rodata"
-
-	string	cpu_arch_name, "armv5te"
-	string	cpu_elf_name, "v5"
-	string	cpu_arm1020e_name, "ARM1020E"
-
-	.align
-
-	.section ".proc.info.init", #alloc, #execinstr
-
-	.type	__arm1020e_proc_info,#object
-__arm1020e_proc_info:
-	.long	0x4105a200			@ ARM 1020TE (Architecture v5TE)
-	.long	0xff0ffff0
-	.long   PMD_TYPE_SECT | \
-		PMD_BIT4 | \
-		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
-	.long   PMD_TYPE_SECT | \
-		PMD_BIT4 | \
-		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
-	b	__arm1020e_setup
-	.long	cpu_arch_name
-	.long	cpu_elf_name
-	.long	HWCAP_SWP | HWCAP_HALF | HWCAP_THUMB | HWCAP_EDSP
-	.long	cpu_arm1020e_name
-	.long	arm1020e_processor_functions
-	.long	v4wbi_tlb_fns
-	.long	v4wb_user_fns
-	.long	arm1020e_cache_fns
-	.size	__arm1020e_proc_info, . - __arm1020e_proc_info
-- 
1.7.4.4



