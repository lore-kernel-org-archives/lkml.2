Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab2EESxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:53:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2EESxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:53:06 -0400
Date: Sat, 5 May 2012 11:52:48 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-6e3e84499a84cd37fd72f1d920aa8ac7f3502cd4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vapier@gentoo.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, tglx@linutronix.de
In-Reply-To: <20120503085034.350246420@linutronix.de>
References: <20120503085034.350246420@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] blackfin: Use generic init_task
Git-Commit-ID: 6e3e84499a84cd37fd72f1d920aa8ac7f3502cd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:52:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e3e84499a84cd37fd72f1d920aa8ac7f3502cd4
Gitweb:     http://git.kernel.org/tip/6e3e84499a84cd37fd72f1d920aa8ac7f3502cd4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:22 +0200

blackfin: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/20120503085034.350246420@linutronix.de
---
 arch/blackfin/Kconfig            |    1 +
 arch/blackfin/Makefile           |    2 --
 arch/blackfin/kernel/Makefile    |    2 +-
 arch/blackfin/kernel/init_task.c |   32 --------------------------------
 4 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 779b9c8..8570d6e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -38,6 +38,7 @@ config BLACKFIN
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 46f42b2..2909496 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -107,8 +107,6 @@ KBUILD_AFLAGS += -mcpu=$(CPU_REV)
 CHECKFLAGS_SILICON = $(shell echo "" | $(CPP) $(KBUILD_CFLAGS) -dD - 2>/dev/null | awk '$$2 == "__SILICON_REVISION__" { print $$3 }')
 CHECKFLAGS += -D__SILICON_REVISION__=$(CHECKFLAGS_SILICON) -D__bfin__
 
-head-y   := arch/$(ARCH)/kernel/init_task.o
-
 core-y   += arch/$(ARCH)/kernel/ arch/$(ARCH)/mm/ arch/$(ARCH)/mach-common/
 
 # If we have a machine-specific directory, then include it in the build.
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 9a0d6d7..08e6625 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -2,7 +2,7 @@
 # arch/blackfin/kernel/Makefile
 #
 
-extra-y := init_task.o vmlinux.lds
+extra-y := vmlinux.lds
 
 obj-y := \
 	entry.o process.o bfin_ksyms.o ptrace.o setup.o signal.o \
diff --git a/arch/blackfin/kernel/init_task.c b/arch/blackfin/kernel/init_task.c
deleted file mode 100644
index d3970e8..0000000
--- a/arch/blackfin/kernel/init_task.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright 2004-2009 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later
- */
-
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/fs.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry.
- */
-union thread_union init_thread_union
-    __init_task_data = {
-INIT_THREAD_INFO(init_task)};
