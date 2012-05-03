Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2ECJHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:07:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:49940 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2ECJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:56 -0400
Message-Id: <20120503085034.941344764@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Subject: [patch V2 17/31] mips: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=mips-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Make the linker script align the task on THREAD_SIZE and not on
PAGE_SIZE, as PAGE_SIZE might be smaller than THREAD_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/Kconfig              |    1 +
 arch/mips/Makefile             |    2 +-
 arch/mips/kernel/Makefile      |    2 +-
 arch/mips/kernel/init_task.c   |   35 -----------------------------------
 arch/mips/kernel/vmlinux.lds.S |    2 +-
 5 files changed, 4 insertions(+), 38 deletions(-)

Index: tip/arch/mips/Kconfig
===================================================================
--- tip.orig/arch/mips/Kconfig
+++ tip/arch/mips/Kconfig
@@ -30,6 +30,7 @@ config MIPS
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 menu "Machine selection"
 
Index: tip/arch/mips/Makefile
===================================================================
--- tip.orig/arch/mips/Makefile
+++ tip/arch/mips/Makefile
@@ -235,7 +235,7 @@ endif
 
 OBJCOPYFLAGS		+= --remove-section=.reginfo
 
-head-y := arch/mips/kernel/head.o arch/mips/kernel/init_task.o
+head-y := arch/mips/kernel/head.o
 
 libs-y			+= arch/mips/lib/
 
Index: tip/arch/mips/kernel/Makefile
===================================================================
--- tip.orig/arch/mips/kernel/Makefile
+++ tip/arch/mips/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/MIPS kernel.
 #
 
-extra-y		:= head.o init_task.o vmlinux.lds
+extra-y		:= head.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
Index: tip/arch/mips/kernel/init_task.c
===================================================================
--- tip.orig/arch/mips/kernel/init_task.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <linux/mm.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/thread_info.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by making sure
- * the linker maps this in the .text segment right after head.S,
- * and making head.S ensure the proper alignment.
- *
- * The things we do for performance..
- */
-union thread_union init_thread_union __init_task_data
-	__attribute__((__aligned__(THREAD_SIZE))) =
-		{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
Index: tip/arch/mips/kernel/vmlinux.lds.S
===================================================================
--- tip.orig/arch/mips/kernel/vmlinux.lds.S
+++ tip/arch/mips/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@ SECTIONS
 	.data : {	/* Data */
 		. = . + DATAOFFSET;		/* for CONFIG_MAPPED_KERNEL */
 
-		INIT_TASK_DATA(PAGE_SIZE)
+		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)


