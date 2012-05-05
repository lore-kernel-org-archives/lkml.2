Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2EETCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:02:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab2EETCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:02:15 -0400
Date: Sat, 5 May 2012 12:01:59 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-cf5e6def83fabdf10a05dc5a5981eda1672cb79c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jonas@southpole.se, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jonas@southpole.se
In-Reply-To: <20120503085035.083343435@linutronix.de>
References: <20120503085035.083343435@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] openrisc: Use generic init_task
Git-Commit-ID: cf5e6def83fabdf10a05dc5a5981eda1672cb79c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:02:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf5e6def83fabdf10a05dc5a5981eda1672cb79c
Gitweb:     http://git.kernel.org/tip/cf5e6def83fabdf10a05dc5a5981eda1672cb79c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:24 +0200

openrisc: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonas Bonn <jonas@southpole.se>
Link: http://lkml.kernel.org/r/20120503085035.083343435@linutronix.de
---
 arch/openrisc/Kconfig            |    1 +
 arch/openrisc/Makefile           |    2 +-
 arch/openrisc/kernel/Makefile    |    2 +-
 arch/openrisc/kernel/init_task.c |   42 --------------------------------------
 4 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index a478719..6d92193 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	def_bool y
diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
index 158ae4c..966886c 100644
--- a/arch/openrisc/Makefile
+++ b/arch/openrisc/Makefile
@@ -38,7 +38,7 @@ else
 	KBUILD_CFLAGS += $(call cc-option,-msoft-div)
 endif
 
-head-y 		:= arch/openrisc/kernel/head.o arch/openrisc/kernel/init_task.o
+head-y 		:= arch/openrisc/kernel/head.o
 
 core-y		+= arch/openrisc/lib/ \
 		   arch/openrisc/kernel/ \
diff --git a/arch/openrisc/kernel/Makefile b/arch/openrisc/kernel/Makefile
index 9a4c270..e1ee0fa 100644
--- a/arch/openrisc/kernel/Makefile
+++ b/arch/openrisc/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y	:= head.o vmlinux.lds init_task.o
+extra-y	:= head.o vmlinux.lds
 
 obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
 	   traps.o time.o irq.o entry.o ptrace.o signal.o sys_or32.o \
diff --git a/arch/openrisc/kernel/init_task.c b/arch/openrisc/kernel/init_task.c
deleted file mode 100644
index ca53408..0000000
--- a/arch/openrisc/kernel/init_task.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * OpenRISC init_task.c
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * Modifications for the OpenRISC architecture:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- *
- *      This program is free software; you can redistribute it and/or
- *      modify it under the terms of the GNU General Public License
- *      as published by the Free Software Foundation; either version
- *      2 of the License, or (at your option) any later version.
- */
-
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-#include <linux/export.h>
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
