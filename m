Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2EES6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:58:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2EES6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:58:35 -0400
Date: Sat, 5 May 2012 11:57:50 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-7433c5cf4f69e0b9e648bfb59d65ffe39220e86c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        takata@linux-m32r.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, takata@linux-m32r.org
In-Reply-To: <20120503085034.756332161@linutronix.de>
References: <20120503085034.756332161@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] m32r: Use generic init_task
Git-Commit-ID: 7433c5cf4f69e0b9e648bfb59d65ffe39220e86c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:57:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7433c5cf4f69e0b9e648bfb59d65ffe39220e86c
Gitweb:     http://git.kernel.org/tip/7433c5cf4f69e0b9e648bfb59d65ffe39220e86c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:54 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:23 +0200

m32r: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Link: http://lkml.kernel.org/r/20120503085034.756332161@linutronix.de
---
 arch/m32r/Kconfig            |    1 +
 arch/m32r/Makefile           |    2 +-
 arch/m32r/kernel/Makefile    |    2 +-
 arch/m32r/kernel/init_task.c |   34 ----------------------------------
 4 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ef80a65..8b8bd7f 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -11,6 +11,7 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config SBUS
 	bool
diff --git a/arch/m32r/Makefile b/arch/m32r/Makefile
index 8ff5ba0..def8dd0 100644
--- a/arch/m32r/Makefile
+++ b/arch/m32r/Makefile
@@ -31,7 +31,7 @@ KBUILD_AFLAGS += $(aflags-y)
 
 CHECKFLAGS	+= -D__m32r__ -D__BIG_ENDIAN__=1
 
-head-y	:= arch/m32r/kernel/head.o arch/m32r/kernel/init_task.o
+head-y	:= arch/m32r/kernel/head.o
 
 LIBGCC	:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
diff --git a/arch/m32r/kernel/Makefile b/arch/m32r/kernel/Makefile
index b1a4b60..0c09dad 100644
--- a/arch/m32r/kernel/Makefile
+++ b/arch/m32r/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux/M32R kernel.
 #
 
-extra-y	:= head.o init_task.o vmlinux.lds
+extra-y	:= head.o vmlinux.lds
 
 obj-y	:= process.o entry.o traps.o align.o irq.o setup.o time.o \
 	m32r_ksyms.o sys_m32r.o signal.o ptrace.o
diff --git a/arch/m32r/kernel/init_task.c b/arch/m32r/kernel/init_task.c
deleted file mode 100644
index 6c42d5f..0000000
--- a/arch/m32r/kernel/init_task.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/* orig : i386 init_task.c */
-
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
-
