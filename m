Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2EETK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:10:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab2EETK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:10:27 -0400
Date: Sat, 5 May 2012 12:10:18 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-45046892ef89c1e0caad66a03c8c1e14ad478d23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120503085035.739963562@linutronix.de>
References: <20120503085035.739963562@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] x86: Use generic init_task
Git-Commit-ID: 45046892ef89c1e0caad66a03c8c1e14ad478d23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:10:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45046892ef89c1e0caad66a03c8c1e14ad478d23
Gitweb:     http://git.kernel.org/tip/45046892ef89c1e0caad66a03c8c1e14ad478d23
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:03:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:26 +0200

x86: Use generic init_task

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120503085035.739963562@linutronix.de
Cc: x86@kernel.org
---
 arch/x86/Kconfig            |    1 +
 arch/x86/Makefile           |    1 -
 arch/x86/kernel/Makefile    |    2 +-
 arch/x86/kernel/init_task.c |   42 ------------------------------------------
 arch/x86/kernel/process.c   |    9 +++++++++
 5 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 046bf4b..2246959 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41a7237..3e48b26 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -146,7 +146,6 @@ archheaders:
 head-y := arch/x86/kernel/head_$(BITS).o
 head-y += arch/x86/kernel/head$(BITS).o
 head-y += arch/x86/kernel/head.o
-head-y += arch/x86/kernel/init_task.o
 
 libs-y  += arch/x86/lib/
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..56ebd1f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinux.lds
+extra-y                := head_$(BITS).o head$(BITS).o head.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
deleted file mode 100644
index 43e9ccf..0000000
--- a/arch/x86/kernel/init_task.c
+++ /dev/null
@@ -1,42 +0,0 @@
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
-#include <asm/desc.h>
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
-
-/*
- * per-CPU TSS segments. Threads are completely 'soft' on Linux,
- * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data..cacheline_aligned
- * section. Since TSS's are completely CPU-local, we want them
- * on exact cacheline boundaries, to eliminate cacheline ping-pong.
- */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
-
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..8aa532f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -27,6 +27,15 @@
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
 
+/*
+ * per-CPU TSS segments. Threads are completely 'soft' on Linux,
+ * no more per-task TSS's. The TSS size is kept cacheline-aligned
+ * so they are allowed to end up in the .data..cacheline_aligned
+ * section. Since TSS's are completely CPU-local, we want them
+ * on exact cacheline boundaries, to eliminate cacheline ping-pong.
+ */
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
+
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU(unsigned char, is_idle);
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
