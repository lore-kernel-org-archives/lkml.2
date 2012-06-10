Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2FJOgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:36:47 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57792 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2FJOgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:36:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Replace m68k-specific _[se]bss by generic __bss_{start,stop}
Date: Sun, 10 Jun 2012 16:36:37 +0200
Message-Id: <1339338998-24629-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BSS_SECTION() provides the __bss_{start,stop} symbols, so there's no need
to wrap our own _[se]bss around it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Prerequisite: mtd/uclinux: Use generic __bss_stop instead of _ebss

 arch/m68k/include/asm/sections.h      |    2 --
 arch/m68k/kernel/setup_no.c           |    4 ++--
 arch/m68k/kernel/vmlinux-nommu.lds    |    2 --
 arch/m68k/kernel/vmlinux-std.lds      |    2 --
 arch/m68k/kernel/vmlinux-sun3.lds     |    2 --
 arch/m68k/mm/init_mm.c                |    2 +-
 arch/m68k/mm/init_no.c                |    2 +-
 arch/m68k/platform/68328/head-de2.S   |    8 ++++----
 arch/m68k/platform/68328/head-pilot.S |   10 +++++-----
 arch/m68k/platform/68328/head-ram.S   |    4 ++--
 arch/m68k/platform/68328/head-rom.S   |    6 +++---
 arch/m68k/platform/68360/head-ram.S   |    6 +++---
 arch/m68k/platform/68360/head-rom.S   |    8 ++++----
 arch/m68k/platform/coldfire/head.S    |   10 +++++-----
 14 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/m68k/include/asm/sections.h b/arch/m68k/include/asm/sections.h
index 5277e52..d64967e 100644
--- a/arch/m68k/include/asm/sections.h
+++ b/arch/m68k/include/asm/sections.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/sections.h>
 
-extern char _sbss[], _ebss[];
-
 #endif /* _ASM_M68K_SECTIONS_H */
diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index 8a624ec..71fb299 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -219,9 +219,9 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	pr_debug("KERNEL -> TEXT=0x%p-0x%p DATA=0x%p-0x%p BSS=0x%p-0x%p\n",
-		 _stext, _etext, _sdata, _edata, _sbss, _ebss);
+		 _stext, _etext, _sdata, _edata, __bss_start, __bss_stop);
 	pr_debug("MEMORY -> ROMFS=0x%p-0x%06lx MEM=0x%06lx-0x%06lx\n ",
-		 _ebss, memory_start, memory_start, memory_end);
+		 __bss_stop, memory_start, memory_start, memory_end);
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
diff --git a/arch/m68k/kernel/vmlinux-nommu.lds b/arch/m68k/kernel/vmlinux-nommu.lds
index 40e02d9..06a763f 100644
--- a/arch/m68k/kernel/vmlinux-nommu.lds
+++ b/arch/m68k/kernel/vmlinux-nommu.lds
@@ -78,9 +78,7 @@ SECTIONS {
 		__init_end = .;
 	}
 
-	_sbss = .;
 	BSS_SECTION(0, 0, 0)
-	_ebss = .;
 
 	_end = .;
 
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 63407c8..d099359 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -31,9 +31,7 @@ SECTIONS
 
   RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE)
 
-  _sbss = .;
   BSS_SECTION(0, 0, 0)
-  _ebss = .;
 
   _edata = .;			/* End of data section */
 
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index ad0f46d..8080469 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -44,9 +44,7 @@ __init_begin = .;
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 
-  _sbss = .;
   BSS_SECTION(0, 0, 0)
-  _ebss = .;
 
   _end = . ;
 
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
index f77f258..282f9de 100644
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -104,7 +104,7 @@ void __init print_memmap(void)
 		MLK_ROUNDUP(__init_begin, __init_end),
 		MLK_ROUNDUP(_stext, _etext),
 		MLK_ROUNDUP(_sdata, _edata),
-		MLK_ROUNDUP(_sbss, _ebss));
+		MLK_ROUNDUP(__bss_start, __bss_stop));
 }
 
 void __init mem_init(void)
diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
index 345ec0d..688e366 100644
--- a/arch/m68k/mm/init_no.c
+++ b/arch/m68k/mm/init_no.c
@@ -91,7 +91,7 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 
 	codek = (_etext - _stext) >> 10;
-	datak = (_ebss - _sdata) >> 10;
+	datak = (__bss_stop - _sdata) >> 10;
 	initk = (__init_begin - __init_end) >> 10;
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
diff --git a/arch/m68k/platform/68328/head-de2.S b/arch/m68k/platform/68328/head-de2.S
index f632fdc..537d324 100644
--- a/arch/m68k/platform/68328/head-de2.S
+++ b/arch/m68k/platform/68328/head-de2.S
@@ -60,8 +60,8 @@ _start:
  *	Move ROM filesystem above bss :-)
  */
 
-	moveal	#_sbss, %a0			/* romfs at the start of bss */
-	moveal	#_ebss, %a1			/* Set up destination  */
+	moveal	#__bss_start, %a0		/* romfs at the start of bss */
+	moveal	#__bss_stop, %a1		/* Set up destination  */
 	movel	%a0, %a2			/* Copy of bss start */
 
 	movel	8(%a0), %d1			/* Get size of ROMFS */
@@ -84,8 +84,8 @@ _start:
  * Initialize BSS segment to 0
  */
 
-	lea	_sbss, %a0
-	lea	_ebss, %a1
+	lea	__bss_start, %a0
+	lea	__bss_stop, %a1
 
 	/* Copy 0 to %a0 until %a0 == %a1 */
 2:	cmpal	%a0, %a1
diff --git a/arch/m68k/platform/68328/head-pilot.S b/arch/m68k/platform/68328/head-pilot.S
index 2ebfd64..45a9dad 100644
--- a/arch/m68k/platform/68328/head-pilot.S
+++ b/arch/m68k/platform/68328/head-pilot.S
@@ -110,7 +110,7 @@ L0:
 	movel	#CONFIG_VECTORBASE, %d7
 	addl	#16, %d7
 	moveal	%d7, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_stop, %a1
 	lea	%a1@(512), %a2
 
 	DBG_PUTC('C')
@@ -138,8 +138,8 @@ LD1:
 
 	DBG_PUTC('E')
 
-	moveal	#_sbss, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_start, %a0
+	moveal	#__bss_stop, %a1
 
 	/* Copy 0 to %a0 until %a0 == %a1 */
 L1:
@@ -150,7 +150,7 @@ L1:
 	DBG_PUTC('F')
 
 	/* Copy command line from end of bss to command line */
-	moveal	#_ebss, %a0
+	moveal	#__bss_stop, %a0
 	moveal	#command_line, %a1
 	lea	%a1@(512), %a2
 
@@ -165,7 +165,7 @@ L3:
 
 	movel	#_sdata, %d0	
 	movel	%d0, _rambase	
-	movel	#_ebss,	%d0
+	movel	#__bss_stop, %d0
 	movel	%d0, _ramstart
 
 	movel	%a4, %d0
diff --git a/arch/m68k/platform/68328/head-ram.S b/arch/m68k/platform/68328/head-ram.S
index 7f1aeea..5189ef9 100644
--- a/arch/m68k/platform/68328/head-ram.S
+++ b/arch/m68k/platform/68328/head-ram.S
@@ -76,8 +76,8 @@ pclp3:
 	beq	pclp3
 #endif /* DEBUG */
 	moveal	#0x007ffff0, %ssp
-	moveal	#_sbss, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_start, %a0
+	moveal	#__bss_stop, %a1
 
 	/* Copy 0 to %a0 until %a0 >= %a1 */
 L1:
diff --git a/arch/m68k/platform/68328/head-rom.S b/arch/m68k/platform/68328/head-rom.S
index a5ff96d..3dff98b 100644
--- a/arch/m68k/platform/68328/head-rom.S
+++ b/arch/m68k/platform/68328/head-rom.S
@@ -59,8 +59,8 @@ _stext:	movew	#0x2700,%sr
 	cmpal	%a1, %a2
 	bhi	1b
 
-	moveal	#_sbss, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_start, %a0
+	moveal	#__bss_stop, %a1
 	/* Copy 0 to %a0 until %a0 == %a1 */
 	
 1:
@@ -70,7 +70,7 @@ _stext:	movew	#0x2700,%sr
 
         movel   #_sdata, %d0    
         movel   %d0, _rambase        
-        movel   #_ebss, %d0
+        movel   #__bss_stop, %d0
         movel   %d0, _ramstart
 	movel	#RAMEND-CONFIG_MEMORY_RESERVE*0x100000, %d0
 	movel	%d0, _ramend
diff --git a/arch/m68k/platform/68360/head-ram.S b/arch/m68k/platform/68360/head-ram.S
index 8eb94fb..acd2131 100644
--- a/arch/m68k/platform/68360/head-ram.S
+++ b/arch/m68k/platform/68360/head-ram.S
@@ -219,8 +219,8 @@ LD1:
 	cmp.l	#_edata, %a1
 	blt     LD1
 
-	moveal	#_sbss, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_start, %a0
+	moveal	#__bss_stop, %a1
 
 	/* Copy 0 to %a0 until %a0 == %a1 */
 L1:
@@ -234,7 +234,7 @@ load_quicc:
 store_ram_size:
 	/* Set ram size information */
 	move.l	#_sdata, _rambase
-	move.l	#_ebss, _ramstart
+	move.l	#__bss_stop, _ramstart
 	move.l	#RAMEND, %d0
 	sub.l	#0x1000, %d0			/* Reserve 4K for stack space.*/
 	move.l	%d0, _ramend			/* Different from RAMEND.*/
diff --git a/arch/m68k/platform/68360/head-rom.S b/arch/m68k/platform/68360/head-rom.S
index 97510e5..dfc756d 100644
--- a/arch/m68k/platform/68360/head-rom.S
+++ b/arch/m68k/platform/68360/head-rom.S
@@ -13,7 +13,7 @@
  */
 
 .global _stext
-.global _sbss
+.global __bss_start
 .global _start
 
 .global _rambase
@@ -229,8 +229,8 @@ LD1:
 	cmp.l	#_edata, %a1
 	blt	LD1
 
-	moveal	#_sbss, %a0
-	moveal	#_ebss, %a1
+	moveal	#__bss_start, %a0
+	moveal	#__bss_stop, %a1
 
 	/* Copy 0 to %a0 until %a0 == %a1 */
 L1:
@@ -244,7 +244,7 @@ load_quicc:
 store_ram_size:
 	/* Set ram size information */
 	move.l	#_sdata, _rambase
-	move.l	#_ebss, _ramstart
+	move.l	#__bss_stop, _ramstart
 	move.l	#RAMEND, %d0
 	sub.l	#0x1000, %d0			/* Reserve 4K for stack space.*/
 	move.l	%d0, _ramend			/* Different from RAMEND.*/
diff --git a/arch/m68k/platform/coldfire/head.S b/arch/m68k/platform/coldfire/head.S
index c3db70e..7e16562 100644
--- a/arch/m68k/platform/coldfire/head.S
+++ b/arch/m68k/platform/coldfire/head.S
@@ -230,8 +230,8 @@ _vstart:
 	/*
 	 *	Move ROM filesystem above bss :-)
 	 */
-	lea	_sbss,%a0			/* get start of bss */
-	lea	_ebss,%a1			/* set up destination  */
+	lea	__bss_start,%a0			/* get start of bss */
+	lea	__bss_stop,%a1			/* set up destination  */
 	movel	%a0,%a2				/* copy of bss start */
 
 	movel	8(%a0),%d0			/* get size of ROMFS */
@@ -249,7 +249,7 @@ _copy_romfs:
 	bne	_copy_romfs
 
 #else /* CONFIG_ROMFS_FS */
-	lea	_ebss,%a1
+	lea	__bss_stop,%a1
 	movel	%a1,_ramstart
 #endif /* CONFIG_ROMFS_FS */
 
@@ -257,8 +257,8 @@ _copy_romfs:
 	/*
 	 *	Zero out the bss region.
 	 */
-	lea	_sbss,%a0			/* get start of bss */
-	lea	_ebss,%a1			/* get end of bss */
+	lea	__bss_start,%a0			/* get start of bss */
+	lea	__bss_stop,%a1			/* get end of bss */
 	clrl	%d0				/* set value */
 _clear_bss:
 	movel	%d0,(%a0)+			/* clear each word */
-- 
1.7.0.4

