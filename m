Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2EETIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:08:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2EETIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:08:49 -0400
Date: Sat, 5 May 2012 12:08:37 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-d0b691dffaee89a4c9e1890694d0c77201d7a9b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, gxt@mprc.pku.edu.cn
In-Reply-To: <20120503085035.669622065@linutronix.de>
References: <20120503085035.669622065@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] unicore32: Use generic init_task
Git-Commit-ID: d0b691dffaee89a4c9e1890694d0c77201d7a9b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:08:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0b691dffaee89a4c9e1890694d0c77201d7a9b1
Gitweb:     http://git.kernel.org/tip/d0b691dffaee89a4c9e1890694d0c77201d7a9b1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:03:00 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:26 +0200

unicore32: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Link: http://lkml.kernel.org/r/20120503085035.669622065@linutronix.de
---
 arch/unicore32/Kconfig            |    1 +
 arch/unicore32/Makefile           |    1 -
 arch/unicore32/kernel/Makefile    |    2 +-
 arch/unicore32/kernel/init_task.c |   44 -------------------------------------
 4 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..e24ca398 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -13,6 +13,7 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
index 6af4bc4..b6f5c4c 100644
--- a/arch/unicore32/Makefile
+++ b/arch/unicore32/Makefile
@@ -33,7 +33,6 @@ endif
 CHECKFLAGS		+= -D__unicore32__
 
 head-y			:= arch/unicore32/kernel/head.o
-head-y			+= arch/unicore32/kernel/init_task.o
 
 core-y			+= arch/unicore32/kernel/
 core-y			+= arch/unicore32/mm/
diff --git a/arch/unicore32/kernel/Makefile b/arch/unicore32/kernel/Makefile
index aeb0f18..3240101 100644
--- a/arch/unicore32/kernel/Makefile
+++ b/arch/unicore32/kernel/Makefile
@@ -29,4 +29,4 @@ obj-$(CONFIG_PUV3_NB0916)	+= puv3-nb0916.o
 head-y				:= head.o
 obj-$(CONFIG_DEBUG_LL)		+= debug.o
 
-extra-y				:= $(head-y) init_task.o vmlinux.lds
+extra-y				:= $(head-y) vmlinux.lds
diff --git a/arch/unicore32/kernel/init_task.c b/arch/unicore32/kernel/init_task.c
deleted file mode 100644
index a35a1e5..0000000
--- a/arch/unicore32/kernel/init_task.c
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * linux/arch/unicore32/kernel/init_task.c
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
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
-union thread_union init_thread_union __init_task_data = {
-	INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
