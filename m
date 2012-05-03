Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2ECJJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:09:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:49905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2ECJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:53 -0400
Message-Id: <20120503085034.350246420@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Subject: [patch V2 08/31] blackfin: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=blackfin-use-generic-init-task.patch
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
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig            |    1 +
 arch/blackfin/Makefile           |    2 --
 arch/blackfin/kernel/Makefile    |    2 +-
 arch/blackfin/kernel/init_task.c |   32 --------------------------------
 4 files changed, 2 insertions(+), 35 deletions(-)

Index: tip/arch/blackfin/Kconfig
===================================================================
--- tip.orig/arch/blackfin/Kconfig
+++ tip/arch/blackfin/Kconfig
@@ -38,6 +38,7 @@ config BLACKFIN
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config GENERIC_CSUM
 	def_bool y
Index: tip/arch/blackfin/Makefile
===================================================================
--- tip.orig/arch/blackfin/Makefile
+++ tip/arch/blackfin/Makefile
@@ -107,8 +107,6 @@ KBUILD_AFLAGS += -mcpu=$(CPU_REV)
 CHECKFLAGS_SILICON = $(shell echo "" | $(CPP) $(KBUILD_CFLAGS) -dD - 2>/dev/null | awk '$$2 == "__SILICON_REVISION__" { print $$3 }')
 CHECKFLAGS += -D__SILICON_REVISION__=$(CHECKFLAGS_SILICON) -D__bfin__
 
-head-y   := arch/$(ARCH)/kernel/init_task.o
-
 core-y   += arch/$(ARCH)/kernel/ arch/$(ARCH)/mm/ arch/$(ARCH)/mach-common/
 
 # If we have a machine-specific directory, then include it in the build.
Index: tip/arch/blackfin/kernel/Makefile
===================================================================
--- tip.orig/arch/blackfin/kernel/Makefile
+++ tip/arch/blackfin/kernel/Makefile
@@ -2,7 +2,7 @@
 # arch/blackfin/kernel/Makefile
 #
 
-extra-y := init_task.o vmlinux.lds
+extra-y := vmlinux.lds
 
 obj-y := \
 	entry.o process.o bfin_ksyms.o ptrace.o setup.o signal.o \
Index: tip/arch/blackfin/kernel/init_task.c
===================================================================
--- tip.orig/arch/blackfin/kernel/init_task.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright 2004-2009 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later
- */
-
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/fs.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry.
- */
-union thread_union init_thread_union
-    __init_task_data = {
-INIT_THREAD_INFO(init_task)};


