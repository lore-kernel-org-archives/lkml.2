Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2D3URw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:17:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:35802 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab2D3UQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:05 -0400
Message-Id: <20120430194847.111422607@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [patch 25/29] um: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=um-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common     |    1 +
 arch/um/kernel/Makefile    |    2 +-
 arch/um/kernel/init_task.c |   38 --------------------------------------
 arch/um/kernel/um_arch.c   |    5 +++++
 4 files changed, 7 insertions(+), 39 deletions(-)

Index: tip/arch/um/Kconfig.common
===================================================================
--- tip.orig/arch/um/Kconfig.common
+++ tip/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
+	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	bool
Index: tip/arch/um/kernel/Makefile
===================================================================
--- tip.orig/arch/um/kernel/Makefile
+++ tip/arch/um/kernel/Makefile
@@ -10,7 +10,7 @@ CPPFLAGS_vmlinux.lds := -DSTART=$(LDS_ST
 extra-y := vmlinux.lds
 clean-files :=
 
-obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
+obj-y = config.o exec.o exitcode.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
 	um_arch.o umid.o skas/
Index: tip/arch/um/kernel/init_task.c
===================================================================
--- tip.orig/arch/um/kernel/init_task.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,intel.linux}.com)
- * Licensed under the GPL
- */
-
-#include "linux/sched.h"
-#include "linux/init_task.h"
-#include "linux/fs.h"
-#include "linux/module.h"
-#include "linux/mqueue.h"
-#include "asm/uaccess.h"
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
-union thread_union cpu0_irqstack
-	__attribute__((__section__(".data..init_irqstack"))) =
-		{ INIT_THREAD_INFO(init_task) };
Index: tip/arch/um/kernel/um_arch.c
===================================================================
--- tip.orig/arch/um/kernel/um_arch.c
+++ tip/arch/um/kernel/um_arch.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/utsname.h>
+#include <linux/sched.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
@@ -47,6 +48,10 @@ struct cpuinfo_um boot_cpu_data = {
 	.ipi_pipe		= { -1, -1 }
 };
 
+union thread_union cpu0_irqstack
+	__attribute__((__section__(".data..init_irqstack"))) =
+		{ INIT_THREAD_INFO(init_task) };
+
 unsigned long thread_saved_pc(struct task_struct *task)
 {
 	/* FIXME: Need to look up userspace_pid by cpu */


