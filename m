Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab2FJOkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:40:06 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57753 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2FJOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:40:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/3] xtensa: Replace xtensa-specific _f{data,text} by _s{data,text}
Date: Sun, 10 Jun 2012 16:39:56 +0200
Message-Id: <1339339198-24789-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a2d063ac216c1618bfc2b4d40b7176adffa63511 ("extable,
core_kernel_data(): Make sure all archs define _sdata") missed xtensa.
Xtensa does have a start of data marker, but calls it _fdata, causing

    kernel/built-in.o:(.text+0x964): undefined reference to `_sdata'

_stext was already defined, but it was duplicated by _fdata.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 +--
 arch/xtensa/mm/init.c            |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 88ecea3..ee2e208 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -83,7 +83,6 @@ SECTIONS
 
   _text = .;
   _stext = .;
-  _ftext = .;
 
   .text :
   {
@@ -112,7 +111,7 @@ SECTIONS
   EXCEPTION_TABLE(16)
   /* Data section */
 
-  _fdata = .;
+  _sdata = .;
   RW_DATA_SECTION(XCHAL_ICACHE_LINESIZE, PAGE_SIZE, THREAD_SIZE)
   _edata = .;
 
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index ba150e5..c82af58 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -29,7 +29,7 @@
 
 /* References to section boundaries */
 
-extern char _ftext, _etext, _fdata, _edata, _rodata_end;
+extern char _stext, _etext, _sdata, _edata, _rodata_end;
 extern char __init_begin, __init_end;
 
 /*
@@ -197,8 +197,8 @@ void __init mem_init(void)
 			reservedpages++;
 	}
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_ftext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_fdata;
+	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
+	datasize =  (unsigned long) &_edata - (unsigned long) &_sdata;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
-- 
1.7.0.4

