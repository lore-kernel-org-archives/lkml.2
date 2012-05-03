Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2ECJKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:10:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:49897 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2ECJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:52 -0400
Message-Id: <20120503085034.221811388@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [patch V2 06/31] arm: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=arm-use-generic-init-task.patch
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
Acked-by: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig            |    1 +
 arch/arm/Makefile           |    2 +-
 arch/arm/kernel/Makefile    |    2 +-
 arch/arm/kernel/init_task.c |   37 -------------------------------------
 4 files changed, 3 insertions(+), 39 deletions(-)

Index: tip/arch/arm/Kconfig
===================================================================
--- tip.orig/arch/arm/Kconfig
+++ tip/arch/arm/Kconfig
@@ -35,6 +35,7 @@ config ARM
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: tip/arch/arm/Makefile
===================================================================
--- tip.orig/arch/arm/Makefile
+++ tip/arch/arm/Makefile
@@ -119,7 +119,7 @@ KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_T
 CHECKFLAGS	+= -D__arm__
 
 #Default value
-head-y		:= arch/arm/kernel/head$(MMUEXT).o arch/arm/kernel/init_task.o
+head-y		:= arch/arm/kernel/head$(MMUEXT).o
 textofs-y	:= 0x00008000
 textofs-$(CONFIG_ARCH_CLPS711X) := 0x00028000
 # We don't want the htc bootloader to corrupt kernel during resume
Index: tip/arch/arm/kernel/Makefile
===================================================================
--- tip.orig/arch/arm/kernel/Makefile
+++ tip/arch/arm/kernel/Makefile
@@ -81,4 +81,4 @@ head-y			:= head$(MMUEXT).o
 obj-$(CONFIG_DEBUG_LL)	+= debug.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
-extra-y := $(head-y) init_task.o vmlinux.lds
+extra-y := $(head-y) vmlinux.lds
Index: tip/arch/arm/kernel/init_task.c
===================================================================
--- tip.orig/arch/arm/kernel/init_task.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- *  linux/arch/arm/kernel/init_task.c
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/uaccess.h>
-
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


