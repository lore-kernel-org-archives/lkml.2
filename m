Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2ECJDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:03:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:49997 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab2ECJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:03:05 -0400
Message-Id: <20120503085035.528129988@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch V2 26/31] tile: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=tile-use-generic-init-task.patch
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
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig            |    1 
 arch/tile/kernel/Makefile    |    2 -
 arch/tile/kernel/init_task.c |   59 -------------------------------------------
 arch/tile/kernel/setup.c     |   16 +++++++++++
 4 files changed, 18 insertions(+), 60 deletions(-)

Index: tip/arch/tile/Kconfig
===================================================================
--- tip.orig/arch/tile/Kconfig
+++ tip/arch/tile/Kconfig
@@ -13,6 +13,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_GENERIC_INIT_TASK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
Index: tip/arch/tile/kernel/Makefile
===================================================================
--- tip.orig/arch/tile/kernel/Makefile
+++ tip/arch/tile/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 extra-y := vmlinux.lds head_$(BITS).o
-obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
+obj-y := backtrace.o entry.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
 	setup.o signal.o single_step.o stack.o sys.o sysfs.o time.o traps.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
Index: tip/arch/tile/kernel/init_task.c
===================================================================
--- tip.orig/arch/tile/kernel/init_task.c
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/module.h>
-#include <linux/start_kernel.h>
-#include <linux/uaccess.h>
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
-
-/*
- * per-CPU stack and boot info.
- */
-DEFINE_PER_CPU(unsigned long, boot_sp) =
-	(unsigned long)init_stack + THREAD_SIZE;
-
-#ifdef CONFIG_SMP
-DEFINE_PER_CPU(unsigned long, boot_pc) = (unsigned long)start_kernel;
-#else
-/*
- * The variable must be __initdata since it references __init code.
- * With CONFIG_SMP it is per-cpu data, which is exempt from validation.
- */
-unsigned long __initdata boot_pc = (unsigned long)start_kernel;
-#endif
Index: tip/arch/tile/kernel/setup.c
===================================================================
--- tip.orig/arch/tile/kernel/setup.c
+++ tip/arch/tile/kernel/setup.c
@@ -61,6 +61,22 @@ unsigned long __initdata node_free_pfn[M
 
 static unsigned long __initdata node_percpu[MAX_NUMNODES];
 
+/*
+ * per-CPU stack and boot info.
+ */
+DEFINE_PER_CPU(unsigned long, boot_sp) =
+	(unsigned long)init_stack + THREAD_SIZE;
+
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU(unsigned long, boot_pc) = (unsigned long)start_kernel;
+#else
+/*
+ * The variable must be __initdata since it references __init code.
+ * With CONFIG_SMP it is per-cpu data, which is exempt from validation.
+ */
+unsigned long __initdata boot_pc = (unsigned long)start_kernel;
+#endif
+
 #ifdef CONFIG_HIGHMEM
 /* Page frame index of end of lowmem on each controller. */
 unsigned long __cpuinitdata node_lowmem_end_pfn[MAX_NUMNODES];


