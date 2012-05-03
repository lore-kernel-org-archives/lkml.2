Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2ECJDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:03:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:49917 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab2ECJCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:54 -0400
Message-Id: <20120503085034.546687215@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch V2 11/31] frv: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=frv-use-generic-idle-task.patch
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
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/Kconfig            |    1 +
 arch/frv/Makefile           |    2 +-
 arch/frv/kernel/Makefile    |    2 +-
 arch/frv/kernel/init_task.c |   32 --------------------------------
 4 files changed, 3 insertions(+), 34 deletions(-)

Index: tip/arch/frv/Kconfig
===================================================================
--- tip.orig/arch/frv/Kconfig
+++ tip/arch/frv/Kconfig
@@ -10,6 +10,7 @@ config FRV
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
 	select ARCH_THREAD_INFO_ALLOCATOR
+	select HAVE_GENERIC_INIT_TASK
 
 config ZONE_DMA
 	bool
Index: tip/arch/frv/Makefile
===================================================================
--- tip.orig/arch/frv/Makefile
+++ tip/arch/frv/Makefile
@@ -81,7 +81,7 @@ ifdef CONFIG_DEBUG_INFO
 KBUILD_AFLAGS	+= -Wa,--gdwarf2
 endif
 
-head-y		:= arch/frv/kernel/head.o arch/frv/kernel/init_task.o
+head-y		:= arch/frv/kernel/head.o
 
 core-y		+= arch/frv/kernel/ arch/frv/mm/
 libs-y		+= arch/frv/lib/
Index: tip/arch/frv/kernel/Makefile
===================================================================
--- tip.orig/arch/frv/kernel/Makefile
+++ tip/arch/frv/kernel/Makefile
@@ -5,7 +5,7 @@
 heads-y				:= head-uc-fr401.o head-uc-fr451.o head-uc-fr555.o
 heads-$(CONFIG_MMU)		:= head-mmu-fr451.o
 
-extra-y:= head.o init_task.o vmlinux.lds
+extra-y:= head.o vmlinux.lds
 
 obj-y := $(heads-y) entry.o entry-table.o break.o switch_to.o kernel_thread.o \
 	 kernel_execve.o process.o traps.o ptrace.o signal.o dma.o \
Index: tip/arch/frv/kernel/init_task.c
===================================================================
--- tip.orig/arch/frv/kernel/init_task.c
+++ /dev/null
@@ -1,32 +0,0 @@
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
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD_SIZE aligned due to the
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


