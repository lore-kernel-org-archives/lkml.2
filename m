Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2EETGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:06:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2EETGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:06:21 -0400
Date: Sat, 5 May 2012 12:06:07 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-41fe22f6553d1384fbef20b195b8c61ed6e768a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20120503085035.398257169@linutronix.de>
References: <20120503085035.398257169@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sh: Use generic init_task
Git-Commit-ID: 41fe22f6553d1384fbef20b195b8c61ed6e768a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:06:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41fe22f6553d1384fbef20b195b8c61ed6e768a1
Gitweb:     http://git.kernel.org/tip/41fe22f6553d1384fbef20b195b8c61ed6e768a1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:59 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:25 +0200

sh: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120503085035.398257169@linutronix.de

---
 arch/sh/Kconfig            |    1 +
 arch/sh/Makefile           |    2 +-
 arch/sh/kernel/Makefile    |    2 +-
 arch/sh/kernel/init_task.c |   30 ------------------------------
 4 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 244cfd0..a0cd70b 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -29,6 +29,7 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 3fc0f41..e14a676 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -124,7 +124,7 @@ endif
 
 export ld-bfd BITS
 
-head-y	:= arch/sh/kernel/init_task.o arch/sh/kernel/head_$(BITS).o
+head-y	:= arch/sh/kernel/head_$(BITS).o
 
 core-y				+= arch/sh/kernel/ arch/sh/mm/ arch/sh/boards/
 core-$(CONFIG_SH_FPU_EMU)	+= arch/sh/math-emu/
diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index 77f7ae1..88571ff 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/SuperH kernel.
 #
 
-extra-y	:= head_$(BITS).o init_task.o vmlinux.lds
+extra-y	:= head_$(BITS).o vmlinux.lds
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
diff --git a/arch/sh/kernel/init_task.c b/arch/sh/kernel/init_task.c
deleted file mode 100644
index 11f2ea5..0000000
--- a/arch/sh/kernel/init_task.c
+++ /dev/null
@@ -1,30 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/fs.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct pt_regs fake_swapper_regs;
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
