Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2EESzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:55:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2EESz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:55:29 -0400
Date: Sat, 5 May 2012 11:55:18 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-cb0fcba283a98f8438ca69b76b0dcb92cce5a951@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120503085034.546687215@linutronix.de>
References: <20120503085034.546687215@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] frv: Use generic init_task
Git-Commit-ID: cb0fcba283a98f8438ca69b76b0dcb92cce5a951
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:55:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb0fcba283a98f8438ca69b76b0dcb92cce5a951
Gitweb:     http://git.kernel.org/tip/cb0fcba283a98f8438ca69b76b0dcb92cce5a951
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:23 +0200

frv: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085034.546687215@linutronix.de
---
 arch/frv/Kconfig            |    1 +
 arch/frv/Makefile           |    2 +-
 arch/frv/kernel/Makefile    |    2 +-
 arch/frv/kernel/init_task.c |   32 --------------------------------
 4 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index a685910..ed6dbd2 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -9,6 +9,7 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
+	select HAVE_GENERIC_INIT_TASK
 
 config ZONE_DMA
 	bool
diff --git a/arch/frv/Makefile b/arch/frv/Makefile
index 7ff8457..4d1b1e9 100644
--- a/arch/frv/Makefile
+++ b/arch/frv/Makefile
@@ -81,7 +81,7 @@ ifdef CONFIG_DEBUG_INFO
 KBUILD_AFLAGS	+= -Wa,--gdwarf2
 endif
 
-head-y		:= arch/frv/kernel/head.o arch/frv/kernel/init_task.o
+head-y		:= arch/frv/kernel/head.o
 
 core-y		+= arch/frv/kernel/ arch/frv/mm/
 libs-y		+= arch/frv/lib/
diff --git a/arch/frv/kernel/Makefile b/arch/frv/kernel/Makefile
index c36f70b..ad4087b 100644
--- a/arch/frv/kernel/Makefile
+++ b/arch/frv/kernel/Makefile
@@ -5,7 +5,7 @@
 heads-y				:= head-uc-fr401.o head-uc-fr451.o head-uc-fr555.o
 heads-$(CONFIG_MMU)		:= head-mmu-fr451.o
 
-extra-y:= head.o init_task.o vmlinux.lds
+extra-y:= head.o vmlinux.lds
 
 obj-y := $(heads-y) entry.o entry-table.o break.o switch_to.o kernel_thread.o \
 	 kernel_execve.o process.o traps.o ptrace.o signal.o dma.o \
diff --git a/arch/frv/kernel/init_task.c b/arch/frv/kernel/init_task.c
deleted file mode 100644
index 3c3e0b3..0000000
--- a/arch/frv/kernel/init_task.c
+++ /dev/null
@@ -1,32 +0,0 @@
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
