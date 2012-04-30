Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2D3UVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:21:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:35747 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab2D3UP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:15:59 -0400
Message-Id: <20120430194846.289226985@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:15:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 12/29] m32r: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=m32r-use-generic-init-task.patch
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
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/Kconfig            |    1 +
 arch/m32r/Makefile           |    2 +-
 arch/m32r/kernel/Makefile    |    2 +-
 arch/m32r/kernel/init_task.c |   34 ----------------------------------
 4 files changed, 3 insertions(+), 36 deletions(-)

Index: tip/arch/m32r/Kconfig
===================================================================
--- tip.orig/arch/m32r/Kconfig
+++ tip/arch/m32r/Kconfig
@@ -11,6 +11,7 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config SBUS
 	bool
Index: tip/arch/m32r/Makefile
===================================================================
--- tip.orig/arch/m32r/Makefile
+++ tip/arch/m32r/Makefile
@@ -31,7 +31,7 @@ KBUILD_AFLAGS += $(aflags-y)
 
 CHECKFLAGS	+= -D__m32r__ -D__BIG_ENDIAN__=1
 
-head-y	:= arch/m32r/kernel/head.o arch/m32r/kernel/init_task.o
+head-y	:= arch/m32r/kernel/head.o
 
 LIBGCC	:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
Index: tip/arch/m32r/kernel/Makefile
===================================================================
--- tip.orig/arch/m32r/kernel/Makefile
+++ tip/arch/m32r/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/M32R kernel.
 #
 
-extra-y	:= head.o init_task.o vmlinux.lds
+extra-y	:= head.o vmlinux.lds
 
 obj-y	:= process.o entry.o traps.o align.o irq.o setup.o time.o \
 	m32r_ksyms.o sys_m32r.o signal.o ptrace.o
Index: tip/arch/m32r/kernel/init_task.c
===================================================================
--- tip.orig/arch/m32r/kernel/init_task.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/* orig : i386 init_task.c */
-
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
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
-


