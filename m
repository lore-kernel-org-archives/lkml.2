Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2EETJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:09:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2EETJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:09:43 -0400
Date: Sat, 5 May 2012 12:09:28 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-5b408241e99bd3f670122d4e6142b69cc6c24098@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de
In-Reply-To: <20120503085035.592937512@linutronix.de>
References: <20120503085035.592937512@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] um: Use generic init_task
Git-Commit-ID: 5b408241e99bd3f670122d4e6142b69cc6c24098
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:09:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b408241e99bd3f670122d4e6142b69cc6c24098
Gitweb:     http://git.kernel.org/tip/5b408241e99bd3f670122d4e6142b69cc6c24098
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:03:00 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:26 +0200

um: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/20120503085035.592937512@linutronix.de

---
 arch/um/Kconfig.common     |    1 +
 arch/um/kernel/Makefile    |    2 +-
 arch/um/kernel/init_task.c |   38 --------------------------------------
 arch/um/kernel/um_arch.c   |    5 +++++
 4 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 20a49ba..f03473c 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
+	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	bool
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 65a1c3d..babe218 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -10,7 +10,7 @@ CPPFLAGS_vmlinux.lds := -DSTART=$(LDS_START)		\
 extra-y := vmlinux.lds
 clean-files :=
 
-obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
+obj-y = config.o exec.o exitcode.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
 	um_arch.o umid.o skas/
diff --git a/arch/um/kernel/init_task.c b/arch/um/kernel/init_task.c
deleted file mode 100644
index ddc9698..0000000
--- a/arch/um/kernel/init_task.c
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
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index ba00eae..4db8770 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
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
