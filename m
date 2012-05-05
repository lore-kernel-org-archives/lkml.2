Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2EES6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:58:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2EES6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:58:52 -0400
Date: Sat, 5 May 2012 11:58:40 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-ab5fc1ffb97e670226166f31e61a2cdc51dd2edc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de
In-Reply-To: <20120503085034.816195285@linutronix.de>
References: <20120503085034.816195285@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m68k: Use generic init_task
Git-Commit-ID: ab5fc1ffb97e670226166f31e61a2cdc51dd2edc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:58:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab5fc1ffb97e670226166f31e61a2cdc51dd2edc
Gitweb:     http://git.kernel.org/tip/ab5fc1ffb97e670226166f31e61a2cdc51dd2edc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:54 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:23 +0200

m68k: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/20120503085034.816195285@linutronix.de
---
 arch/m68k/Kconfig            |    1 +
 arch/m68k/kernel/Makefile    |    2 +-
 arch/m68k/kernel/init_task.c |   35 -----------------------------------
 3 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index d318c60..1891127 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
+	select HAVE_GENERIC_INIT_TASK
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index 40d29a78..5c7070e 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -13,7 +13,7 @@ extra-$(CONFIG_SUN3X)	:= head.o
 extra-$(CONFIG_SUN3)	:= sun3-head.o
 extra-y			+= vmlinux.lds
 
-obj-y	:= entry.o init_task.o irq.o m68k_ksyms.o module.o process.o ptrace.o
+obj-y	:= entry.o irq.o m68k_ksyms.o module.o process.o ptrace.o
 obj-y	+= setup.o signal.o sys_m68k.o syscalltable.o time.o traps.o
 
 obj-$(CONFIG_MMU_MOTOROLA) += ints.o vectors.o
diff --git a/arch/m68k/kernel/init_task.c b/arch/m68k/kernel/init_task.c
deleted file mode 100644
index c744cfc..0000000
--- a/arch/m68k/kernel/init_task.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- *  linux/arch/m68knommu/kernel/init_task.c
- */
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
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD size aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
