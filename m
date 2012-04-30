Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2D3URW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:17:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:35806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab2D3UQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:06 -0400
Message-Id: <20120430194847.171921818@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [patch 26/29] unicore32: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=unicore-use-generic-init-task.patch
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
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig            |    1 
 arch/unicore32/Makefile           |    1 
 arch/unicore32/kernel/Makefile    |    2 -
 arch/unicore32/kernel/init_task.c |   44 --------------------------------------
 4 files changed, 2 insertions(+), 46 deletions(-)

Index: tip/arch/unicore32/Kconfig
===================================================================
--- tip.orig/arch/unicore32/Kconfig
+++ tip/arch/unicore32/Kconfig
@@ -13,6 +13,7 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
Index: tip/arch/unicore32/Makefile
===================================================================
--- tip.orig/arch/unicore32/Makefile
+++ tip/arch/unicore32/Makefile
@@ -33,7 +33,6 @@ endif
 CHECKFLAGS		+= -D__unicore32__
 
 head-y			:= arch/unicore32/kernel/head.o
-head-y			+= arch/unicore32/kernel/init_task.o
 
 core-y			+= arch/unicore32/kernel/
 core-y			+= arch/unicore32/mm/
Index: tip/arch/unicore32/kernel/Makefile
===================================================================
--- tip.orig/arch/unicore32/kernel/Makefile
+++ tip/arch/unicore32/kernel/Makefile
@@ -29,4 +29,4 @@ obj-$(CONFIG_PUV3_NB0916)	+= puv3-nb0916
 head-y				:= head.o
 obj-$(CONFIG_DEBUG_LL)		+= debug.o
 
-extra-y				:= $(head-y) init_task.o vmlinux.lds
+extra-y				:= $(head-y) vmlinux.lds
Index: tip/arch/unicore32/kernel/init_task.c
===================================================================
--- tip.orig/arch/unicore32/kernel/init_task.c
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * linux/arch/unicore32/kernel/init_task.c
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
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
-union thread_union init_thread_union __init_task_data = {
-	INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);


