Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2D3USZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:18:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:35787 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab2D3UQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:04 -0400
Message-Id: <20120430194846.924135890@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 22/29] sh: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=sh-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig            |    1 +
 arch/sh/Makefile           |    2 +-
 arch/sh/kernel/Makefile    |    2 +-
 arch/sh/kernel/init_task.c |   30 ------------------------------
 4 files changed, 3 insertions(+), 32 deletions(-)

Index: tip/arch/sh/Kconfig
===================================================================
--- tip.orig/arch/sh/Kconfig
+++ tip/arch/sh/Kconfig
@@ -29,6 +29,7 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: tip/arch/sh/Makefile
===================================================================
--- tip.orig/arch/sh/Makefile
+++ tip/arch/sh/Makefile
@@ -124,7 +124,7 @@ endif
 
 export ld-bfd BITS
 
-head-y	:= arch/sh/kernel/init_task.o arch/sh/kernel/head_$(BITS).o
+head-y	:= arch/sh/kernel/head_$(BITS).o
 
 core-y				+= arch/sh/kernel/ arch/sh/mm/ arch/sh/boards/
 core-$(CONFIG_SH_FPU_EMU)	+= arch/sh/math-emu/
Index: tip/arch/sh/kernel/Makefile
===================================================================
--- tip.orig/arch/sh/kernel/Makefile
+++ tip/arch/sh/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/SuperH kernel.
 #
 
-extra-y	:= head_$(BITS).o init_task.o vmlinux.lds
+extra-y	:= head_$(BITS).o vmlinux.lds
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
Index: tip/arch/sh/kernel/init_task.c
===================================================================
--- tip.orig/arch/sh/kernel/init_task.c
+++ /dev/null
@@ -1,30 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/fs.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct pt_regs fake_swapper_regs;
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);


