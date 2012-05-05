Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2EETIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:08:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2EETIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:08:00 -0400
Date: Sat, 5 May 2012 12:07:47 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-293ef7b8288da79112276ddd53902aff75ce7494@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
In-Reply-To: <20120503085035.528129988@linutronix.de>
References: <20120503085035.528129988@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] tile: Use generic init_task
Git-Commit-ID: 293ef7b8288da79112276ddd53902aff75ce7494
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:07:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  293ef7b8288da79112276ddd53902aff75ce7494
Gitweb:     http://git.kernel.org/tip/293ef7b8288da79112276ddd53902aff75ce7494
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:59 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:26 +0200

tile: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20120503085035.528129988@linutronix.de
---
 arch/tile/Kconfig            |    1 +
 arch/tile/kernel/Makefile    |    2 +-
 arch/tile/kernel/init_task.c |   59 ------------------------------------------
 arch/tile/kernel/setup.c     |   16 +++++++++++
 4 files changed, 18 insertions(+), 60 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 96033e2..4fa3ff5 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -13,6 +13,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_GENERIC_INIT_TASK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index b4dbc05..0d826fa 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 extra-y := vmlinux.lds head_$(BITS).o
-obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
+obj-y := backtrace.o entry.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
 	setup.o signal.o single_step.o stack.o sys.o sysfs.o time.o traps.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
diff --git a/arch/tile/kernel/init_task.c b/arch/tile/kernel/init_task.c
deleted file mode 100644
index 928b318..0000000
--- a/arch/tile/kernel/init_task.c
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
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index bff23f4..98d80eb 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -61,6 +61,22 @@ unsigned long __initdata node_free_pfn[MAX_NUMNODES];
 
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
