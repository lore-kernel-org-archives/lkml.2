Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2EETAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:00:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2EETAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:00:31 -0400
Date: Sat, 5 May 2012 12:00:19 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-957b369c3d35d73e1d0c3e9d21db791e58984cbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20120503085034.941344764@linutronix.de>
References: <20120503085034.941344764@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mips: Use generic init_task
Git-Commit-ID: 957b369c3d35d73e1d0c3e9d21db791e58984cbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:00:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  957b369c3d35d73e1d0c3e9d21db791e58984cbb
Gitweb:     http://git.kernel.org/tip/957b369c3d35d73e1d0c3e9d21db791e58984cbb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:24 +0200

mips: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Make the linker script align the task on THREAD_SIZE and not on
PAGE_SIZE, as PAGE_SIZE might be smaller than THREAD_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20120503085034.941344764@linutronix.de
---
 arch/mips/Kconfig              |    1 +
 arch/mips/Makefile             |    2 +-
 arch/mips/kernel/Makefile      |    2 +-
 arch/mips/kernel/init_task.c   |   35 -----------------------------------
 arch/mips/kernel/vmlinux.lds.S |    2 +-
 5 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 186fc8c..d6c7890 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -30,6 +30,7 @@ config MIPS
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 menu "Machine selection"
 
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 4fedf5a..76017c2 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -235,7 +235,7 @@ endif
 
 OBJCOPYFLAGS		+= --remove-section=.reginfo
 
-head-y := arch/mips/kernel/head.o arch/mips/kernel/init_task.o
+head-y := arch/mips/kernel/head.o
 
 libs-y			+= arch/mips/lib/
 
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 0c6877e..fdaf65e 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/MIPS kernel.
 #
 
-extra-y		:= head.o init_task.o vmlinux.lds
+extra-y		:= head.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
diff --git a/arch/mips/kernel/init_task.c b/arch/mips/kernel/init_task.c
deleted file mode 100644
index 5f9a762..0000000
--- a/arch/mips/kernel/init_task.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <linux/mm.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/thread_info.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by making sure
- * the linker maps this in the .text segment right after head.S,
- * and making head.S ensure the proper alignment.
- *
- * The things we do for performance..
- */
-union thread_union init_thread_union __init_task_data
-	__attribute__((__aligned__(THREAD_SIZE))) =
-		{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 924da5e..e6772f2 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@ SECTIONS
 	.data : {	/* Data */
 		. = . + DATAOFFSET;		/* for CONFIG_MAPPED_KERNEL */
 
-		INIT_TASK_DATA(PAGE_SIZE)
+		INIT_TASK_DATA(THREAD_SIZE)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		READ_MOSTLY_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
