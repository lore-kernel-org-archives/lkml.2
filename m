Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2ECJFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:05:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:49961 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2ECJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:59 -0400
Message-Id: <20120503085035.271439530@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch V2 22/31] s390: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=s390-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig            |    1 +
 arch/s390/Makefile           |    1 -
 arch/s390/kernel/Makefile    |    2 +-
 arch/s390/kernel/init_task.c |   38 --------------------------------------
 4 files changed, 2 insertions(+), 40 deletions(-)

Index: tip/arch/s390/Kconfig
===================================================================
--- tip.orig/arch/s390/Kconfig
+++ tip/arch/s390/Kconfig
@@ -123,6 +123,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
Index: tip/arch/s390/Makefile
===================================================================
--- tip.orig/arch/s390/Makefile
+++ tip/arch/s390/Makefile
@@ -91,7 +91,6 @@ OBJCOPYFLAGS	:= -O binary
 
 head-y		:= arch/s390/kernel/head.o
 head-y		+= arch/s390/kernel/$(if $(CONFIG_64BIT),head64.o,head31.o)
-head-y		+= arch/s390/kernel/init_task.o
 
 # See arch/s390/Kbuild for content of core part of the kernel
 core-y		+= arch/s390/
Index: tip/arch/s390/kernel/Makefile
===================================================================
--- tip.orig/arch/s390/kernel/Makefile
+++ tip/arch/s390/kernel/Makefile
@@ -28,7 +28,7 @@ obj-y	:=  bitmap.o traps.o time.o proces
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
 
-extra-y				+= head.o init_task.o vmlinux.lds
+extra-y				+= head.o vmlinux.lds
 extra-y				+= $(if $(CONFIG_64BIT),head64.o,head31.o)
 
 obj-$(CONFIG_MODULES)		+= s390_ksyms.o module.o
Index: tip/arch/s390/kernel/init_task.c
===================================================================
--- tip.orig/arch/s390/kernel/init_task.c
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


