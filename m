Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2EETHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:07:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2EETHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:07:11 -0400
Date: Sat, 5 May 2012 12:06:58 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-3f149aa226e39e7f29ca7bb22f8e5bf304206a8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120503085035.463573011@linutronix.de>
References: <20120503085035.463573011@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sparc: Use generic init_task
Git-Commit-ID: 3f149aa226e39e7f29ca7bb22f8e5bf304206a8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:07:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f149aa226e39e7f29ca7bb22f8e5bf304206a8f
Gitweb:     http://git.kernel.org/tip/3f149aa226e39e7f29ca7bb22f8e5bf304206a8f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:59 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:25 +0200

sparc: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/20120503085035.463573011@linutronix.de

---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/Makefile           |    1 -
 arch/sparc/kernel/Makefile    |    1 -
 arch/sparc/kernel/init_task.c |   22 ----------------------
 4 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e417f35..99aad7c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -31,6 +31,7 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index eddcfb3..cf39aaf 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -62,7 +62,6 @@ endif
 endif
 
 head-y                 := arch/sparc/kernel/head_$(BITS).o
-head-y                 += arch/sparc/kernel/init_task.o
 
 core-y                 += arch/sparc/kernel/
 core-y                 += arch/sparc/mm/ arch/sparc/math-emu/
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index cb85458..9c74bdc 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -6,7 +6,6 @@ asflags-y := -ansi
 ccflags-y := -Werror
 
 extra-y     := head_$(BITS).o
-extra-y     += init_task.o
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
diff --git a/arch/sparc/kernel/init_task.c b/arch/sparc/kernel/init_task.c
deleted file mode 100644
index 35f141a..0000000
--- a/arch/sparc/kernel/init_task.c
+++ /dev/null
@@ -1,22 +0,0 @@
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-/* .text section in head.S is aligned at 8k boundary and this gets linked
- * right after that so that the init_thread_union is aligned properly as well.
- * If this is not aligned on a 8k boundary, then you should change code
- * in etrap.S which assumes it.
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
