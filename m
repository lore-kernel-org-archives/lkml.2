Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2EETBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:01:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2EETBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:01:20 -0400
Date: Sat, 5 May 2012 12:01:09 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-fe285f523bc13185da6d4c740655b2c27c75cf13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120503085035.011270394@linutronix.de>
References: <20120503085035.011270394@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mn10300: Use generic init_task
Git-Commit-ID: fe285f523bc13185da6d4c740655b2c27c75cf13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:01:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe285f523bc13185da6d4c740655b2c27c75cf13
Gitweb:     http://git.kernel.org/tip/fe285f523bc13185da6d4c740655b2c27c75cf13
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:24 +0200

mn10300: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085035.011270394@linutronix.de
---
 arch/mn10300/Kconfig            |    1 +
 arch/mn10300/Makefile           |    2 +-
 arch/mn10300/kernel/Makefile    |    2 +-
 arch/mn10300/kernel/init_task.c |   39 ---------------------------------------
 4 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 3aa3de0..d28b6eb 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -6,6 +6,7 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select HAVE_GENERIC_INIT_TASK
 
 config AM33_2
 	def_bool n
diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index 7120282..33188b6 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -51,7 +51,7 @@ UNIT		:= asb2364
 endif
 
 
-head-y		:= arch/mn10300/kernel/head.o arch/mn10300/kernel/init_task.o
+head-y		:= arch/mn10300/kernel/head.o
 
 core-y		+= arch/mn10300/kernel/ arch/mn10300/mm/
 
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index 47ed30f..d067491 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the MN10300-specific core kernel code
 #
-extra-y := head.o init_task.o vmlinux.lds
+extra-y := head.o vmlinux.lds
 
 fpu-obj-y := fpu-nofpu.o fpu-nofpu-low.o
 fpu-obj-$(CONFIG_FPU) := fpu.o fpu-low.o
diff --git a/arch/mn10300/kernel/init_task.c b/arch/mn10300/kernel/init_task.c
deleted file mode 100644
index a481b04..0000000
--- a/arch/mn10300/kernel/init_task.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/* MN10300 Initial task definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
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
-EXPORT_SYMBOL(init_task);
