Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2FJOjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:39:13 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57753 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2FJOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:39:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] h8300: Fix use of extinct _sbss and _ebss
Date: Sun, 10 Jun 2012 16:39:06 +0200
Message-Id: <1339339147-24743-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays it should use __bss_start and __bss_stop

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/kernel/setup.c |    6 +++---
 arch/h8300/mm/init.c      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index 68d6510..050f136 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -54,7 +54,7 @@ unsigned long memory_end;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
+extern int _stext, _etext, _sdata, _edata, __bss_start, __bss_stop, _end;
 extern int _ramstart, _ramend;
 extern char _target_name[];
 extern void h8300_gpio_init(void);
@@ -137,10 +137,10 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
 		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
 		(int) &_sdata, (int) &_edata,
-		(int) &_sbss, (int) &_ebss);
+		(int) &__bss_start, (int) &__bss_stop);
 	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
 		"STACK=0x%06x-0x%06x\n",
-	       (int) &_ebss, (int) memory_start,
+	       (int) &__bss_stop, (int) memory_start,
 		(int) memory_start, (int) memory_end,
 		(int) memory_end, (int) &_ramend);
 #endif
diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 973369c..ee4c9db 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -123,7 +123,7 @@ void __init mem_init(void)
 	int codek = 0, datak = 0, initk = 0;
 	/* DAVIDM look at setup memory map generically with reserved area */
 	unsigned long tmp;
-	extern char _etext, _stext, _sdata, _ebss, __init_begin, __init_end;
+	extern char _etext, _stext, _sdata, __bss_stop, __init_begin, __init_end;
 	extern unsigned long  _ramend, _ramstart;
 	unsigned long len = &_ramend - &_ramstart;
 	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
@@ -143,7 +143,7 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 
 	codek = (&_etext - &_stext) >> 10;
-	datak = (&_ebss - &_sdata) >> 10;
+	datak = (&__bss_stop - &_sdata) >> 10;
 	initk = (&__init_begin - &__init_end) >> 10;
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
-- 
1.7.0.4

