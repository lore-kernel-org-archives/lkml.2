Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2EESv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:51:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2EESvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:51:24 -0400
Date: Sat, 5 May 2012 11:51:08 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-5290dc292915aaed6ae71ec3db5d4aa3285e7d51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20120503085034.221811388@linutronix.de>
References: <20120503085034.221811388@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arm: Use generic init_task
Git-Commit-ID: 5290dc292915aaed6ae71ec3db5d4aa3285e7d51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:51:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5290dc292915aaed6ae71ec3db5d4aa3285e7d51
Gitweb:     http://git.kernel.org/tip/5290dc292915aaed6ae71ec3db5d4aa3285e7d51
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:22 +0200

arm: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Russell King <linux@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20120503085034.221811388@linutronix.de
---
 arch/arm/Kconfig            |    1 +
 arch/arm/Makefile           |    2 +-
 arch/arm/kernel/Makefile    |    2 +-
 arch/arm/kernel/init_task.c |   37 -------------------------------------
 4 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cb253ce..8b36535 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -35,6 +35,7 @@ config ARM
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 047a207..cf94509 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -119,7 +119,7 @@ KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_THUMB2) $(arch-y) $(tune-y) -include asm/
 CHECKFLAGS	+= -D__arm__
 
 #Default value
-head-y		:= arch/arm/kernel/head$(MMUEXT).o arch/arm/kernel/init_task.o
+head-y		:= arch/arm/kernel/head$(MMUEXT).o
 textofs-y	:= 0x00008000
 textofs-$(CONFIG_ARCH_CLPS711X) := 0x00028000
 # We don't want the htc bootloader to corrupt kernel during resume
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 7b787d6..369985e 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -81,4 +81,4 @@ head-y			:= head$(MMUEXT).o
 obj-$(CONFIG_DEBUG_LL)	+= debug.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
-extra-y := $(head-y) init_task.o vmlinux.lds
+extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/init_task.c b/arch/arm/kernel/init_task.c
deleted file mode 100644
index e7cbb50..0000000
--- a/arch/arm/kernel/init_task.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- *  linux/arch/arm/kernel/init_task.c
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/uaccess.h>
-
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
