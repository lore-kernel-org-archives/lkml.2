Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2D3UTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:19:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:35765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab2D3UQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:01 -0400
Message-Id: <20120430194846.596835207@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [patch 17/29] openrisc: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=openrisc-use-generic-init-task.patch
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
Cc: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/Kconfig            |    1 
 arch/openrisc/Makefile           |    2 -
 arch/openrisc/kernel/Makefile    |    2 -
 arch/openrisc/kernel/init_task.c |   42 ---------------------------------------
 4 files changed, 3 insertions(+), 44 deletions(-)

Index: tip/arch/openrisc/Kconfig
===================================================================
--- tip.orig/arch/openrisc/Kconfig
+++ tip/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	def_bool y
Index: tip/arch/openrisc/Makefile
===================================================================
--- tip.orig/arch/openrisc/Makefile
+++ tip/arch/openrisc/Makefile
@@ -38,7 +38,7 @@ else
 	KBUILD_CFLAGS += $(call cc-option,-msoft-div)
 endif
 
-head-y 		:= arch/openrisc/kernel/head.o arch/openrisc/kernel/init_task.o
+head-y 		:= arch/openrisc/kernel/head.o
 
 core-y		+= arch/openrisc/lib/ \
 		   arch/openrisc/kernel/ \
Index: tip/arch/openrisc/kernel/Makefile
===================================================================
--- tip.orig/arch/openrisc/kernel/Makefile
+++ tip/arch/openrisc/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y	:= head.o vmlinux.lds init_task.o
+extra-y	:= head.o vmlinux.lds
 
 obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
 	   traps.o time.o irq.o entry.o ptrace.o signal.o sys_or32.o \
Index: tip/arch/openrisc/kernel/init_task.c
===================================================================
--- tip.orig/arch/openrisc/kernel/init_task.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * OpenRISC init_task.c
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * Modifications for the OpenRISC architecture:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- */
-
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/export.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD_SIZE aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union __init_task_data = {
-	INIT_THREAD_INFO(init_task)
-};
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);


