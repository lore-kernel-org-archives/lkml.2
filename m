Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2FJOjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:39:14 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57765 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2FJOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:39:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] h8300: Use the declarations provided by <asm/sections.h>
Date: Sun, 10 Jun 2012 16:39:07 +0200
Message-Id: <1339339147-24743-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339339147-24743-1-git-send-email-geert@linux-m68k.org>
References: <1339339147-24743-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Include <asm/sections.h>,
  - Remove the (different) extern declarations,
  - Remove the no longer needed address-of ('&') operators,
  - Remove the superfluous casts, use proper printk formatting instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/kernel/setup.c |   23 ++++++++++-------------
 arch/h8300/mm/init.c      |   17 ++++++++---------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index 050f136..d0b1607 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 
 #if defined(__H8300H__)
 #define CPU "H8/300H"
@@ -54,7 +55,6 @@ unsigned long memory_end;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-extern int _stext, _etext, _sdata, _edata, __bss_start, __bss_stop, _end;
 extern int _ramstart, _ramend;
 extern char _target_name[];
 extern void h8300_gpio_init(void);
@@ -119,9 +119,9 @@ void __init setup_arch(char **cmdline_p)
 	    memory_end = CONFIG_BLKDEV_RESERVE_ADDRESS; 
 #endif
 
-	init_mm.start_code = (unsigned long) &_stext;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
 	init_mm.brk = (unsigned long) 0; 
 
 #if (defined(CONFIG_H8300H_SIM) || defined(CONFIG_H8S_SIM)) && defined(CONFIG_GDB_MAGICPRINT)
@@ -134,15 +134,12 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "H8/300 series support by Yoshinori Sato <ysato@users.sourceforge.jp>\n");
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
-		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
-		(int) &_sdata, (int) &_edata,
-		(int) &__bss_start, (int) &__bss_stop);
-	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
-		"STACK=0x%06x-0x%06x\n",
-	       (int) &__bss_stop, (int) memory_start,
-		(int) memory_start, (int) memory_end,
-		(int) memory_end, (int) &_ramend);
+	printk(KERN_DEBUG "KERNEL -> TEXT=0x%p-0x%p DATA=0x%p-0x%p "
+		"BSS=0x%p-0x%p\n", _stext, _etext, _sdata, _edata, __bss_start,
+		__bss_stop);
+	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%p-0x%06lx MEM=0x%06lx-0x%06lx "
+		"STACK=0x%06lx-0x%p\n", __bss_stop, memory_start, memory_start,
+		memory_end, memory_end, &_ramend);
 #endif
 
 #ifdef CONFIG_DEFAULT_CMDLINE
diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index ee4c9db..981e250 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -36,6 +36,7 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 
 #undef DEBUG
 
@@ -123,7 +124,6 @@ void __init mem_init(void)
 	int codek = 0, datak = 0, initk = 0;
 	/* DAVIDM look at setup memory map generically with reserved area */
 	unsigned long tmp;
-	extern char _etext, _stext, _sdata, __bss_stop, __init_begin, __init_end;
 	extern unsigned long  _ramend, _ramstart;
 	unsigned long len = &_ramend - &_ramstart;
 	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
@@ -142,9 +142,9 @@ void __init mem_init(void)
 	/* this will put all memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
-	codek = (&_etext - &_stext) >> 10;
-	datak = (&__bss_stop - &_sdata) >> 10;
-	initk = (&__init_begin - &__init_end) >> 10;
+	codek = (_etext - _stext) >> 10;
+	datak = (__bss_stop - _sdata) >> 10;
+	initk = (__init_begin - __init_end) >> 10;
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
 	printk(KERN_INFO "Memory available: %luk/%luk RAM, %luk/%luk ROM (%dk kernel code, %dk data)\n",
@@ -178,22 +178,21 @@ free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
 	unsigned long addr;
-	extern char __init_begin, __init_end;
 /*
  *	the following code should be cool even if these sections
  *	are not page aligned.
  */
-	addr = PAGE_ALIGN((unsigned long)(&__init_begin));
+	addr = PAGE_ALIGN((unsigned long)(__init_begin));
 	/* next to check that the page we free is not a partial page */
-	for (; addr + PAGE_SIZE < (unsigned long)(&__init_end); addr +=PAGE_SIZE) {
+	for (; addr + PAGE_SIZE < (unsigned long)__init_end; addr +=PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		free_page(addr);
 		totalram_pages++;
 	}
 	printk(KERN_INFO "Freeing unused kernel memory: %ldk freed (0x%x - 0x%x)\n",
-			(addr - PAGE_ALIGN((long) &__init_begin)) >> 10,
-			(int)(PAGE_ALIGN((unsigned long)(&__init_begin))),
+			(addr - PAGE_ALIGN((long) __init_begin)) >> 10,
+			(int)(PAGE_ALIGN((unsigned long)__init_begin)),
 			(int)(addr - PAGE_SIZE));
 #endif
 }
-- 
1.7.0.4

