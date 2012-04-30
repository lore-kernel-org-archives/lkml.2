Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2D3UXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:23:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:35708 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab2D3UPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:15:54 -0400
Message-Id: <20120430194845.737060696@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:15:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [patch 03/29] arm: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
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
Cc: Russell King <linux@arm.linux.org.uk>
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


