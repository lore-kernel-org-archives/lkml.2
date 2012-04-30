Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2D3URV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:17:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:35811 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2D3UQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:06 -0400
Message-Id: <20120430194847.232480749@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org
Subject: [patch 27/29] x86: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=x86-use-common-init-task.patch
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
Cc: x86@kernel.org
---
 arch/x86/Kconfig            |    1 +
 arch/x86/Makefile           |    1 -
 arch/x86/kernel/Makefile    |    2 +-
 arch/x86/kernel/init_task.c |   42 ------------------------------------------
 arch/x86/kernel/process.c   |    9 +++++++++
 5 files changed, 11 insertions(+), 44 deletions(-)

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: tip/arch/x86/Makefile
===================================================================
--- tip.orig/arch/x86/Makefile
+++ tip/arch/x86/Makefile
@@ -146,7 +146,6 @@ archheaders:
 head-y := arch/x86/kernel/head_$(BITS).o
 head-y += arch/x86/kernel/head$(BITS).o
 head-y += arch/x86/kernel/head.o
-head-y += arch/x86/kernel/init_task.o
 
 libs-y  += arch/x86/lib/
 
Index: tip/arch/x86/kernel/Makefile
===================================================================
--- tip.orig/arch/x86/kernel/Makefile
+++ tip/arch/x86/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinux.lds
+extra-y                := head_$(BITS).o head$(BITS).o head.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
Index: tip/arch/x86/kernel/init_task.c
===================================================================
--- tip.orig/arch/x86/kernel/init_task.c
+++ /dev/null
@@ -1,42 +0,0 @@
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
-#include <asm/desc.h>
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
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
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
- * per-CPU TSS segments. Threads are completely 'soft' on Linux,
- * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data..cacheline_aligned
- * section. Since TSS's are completely CPU-local, we want them
- * on exact cacheline boundaries, to eliminate cacheline ping-pong.
- */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
-
Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -27,6 +27,15 @@
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
 
+/*
+ * per-CPU TSS segments. Threads are completely 'soft' on Linux,
+ * no more per-task TSS's. The TSS size is kept cacheline-aligned
+ * so they are allowed to end up in the .data..cacheline_aligned
+ * section. Since TSS's are completely CPU-local, we want them
+ * on exact cacheline boundaries, to eliminate cacheline ping-pong.
+ */
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
+
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU(unsigned char, is_idle);
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);


