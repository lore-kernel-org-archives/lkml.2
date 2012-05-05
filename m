Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2EETEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:04:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2EETEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:04:40 -0400
Date: Sat, 5 May 2012 12:04:27 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-edd813bb35227f19e9d7f808165c0c4e95e03149@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20120503085035.271439530@linutronix.de>
References: <20120503085035.271439530@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] s390: Use generic init_task
Git-Commit-ID: edd813bb35227f19e9d7f808165c0c4e95e03149
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:04:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edd813bb35227f19e9d7f808165c0c4e95e03149
Gitweb:     http://git.kernel.org/tip/edd813bb35227f19e9d7f808165c0c4e95e03149
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:25 +0200

s390: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Link: http://lkml.kernel.org/r/20120503085035.271439530@linutronix.de
---
 arch/s390/Kconfig            |    1 +
 arch/s390/Makefile           |    1 -
 arch/s390/kernel/Makefile    |    2 +-
 arch/s390/kernel/init_task.c |   38 --------------------------------------
 4 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 15cab3e..6c0eb21 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -123,6 +123,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 0ad2f1e..49e76e8 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -91,7 +91,6 @@ OBJCOPYFLAGS	:= -O binary
 
 head-y		:= arch/s390/kernel/head.o
 head-y		+= arch/s390/kernel/$(if $(CONFIG_64BIT),head64.o,head31.o)
-head-y		+= arch/s390/kernel/init_task.o
 
 # See arch/s390/Kbuild for content of core part of the kernel
 core-y		+= arch/s390/
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 884b18a..9733b3f 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -28,7 +28,7 @@ obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o vtime.o \
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
 
-extra-y				+= head.o init_task.o vmlinux.lds
+extra-y				+= head.o vmlinux.lds
 extra-y				+= $(if $(CONFIG_64BIT),head64.o,head31.o)
 
 obj-$(CONFIG_MODULES)		+= s390_ksyms.o module.o
diff --git a/arch/s390/kernel/init_task.c b/arch/s390/kernel/init_task.c
deleted file mode 100644
index 4d1c9fb..0000000
--- a/arch/s390/kernel/init_task.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- *  arch/s390/kernel/init_task.c
- *
- *  S390 version
- *
- *  Derived from "arch/i386/kernel/init_task.c"
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
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
-
-EXPORT_SYMBOL(init_task);
