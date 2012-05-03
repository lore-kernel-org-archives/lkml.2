Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ECJDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:03:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:49999 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab2ECJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:03:05 -0400
Message-Id: <20120503085034.092585287@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Jonas Bonn <jonas@southpole.se>, Mark Salter <msalter@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Matt Turner <mattst88@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
        Ralf Baechle <ralf@linux-mips.org>, Richard Kuo <rkuo@codeaurora.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [patch V2 04/31] init_task: Create generic init_task instance
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=init-task-move-common-code-to-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All archs define init_task in the same way (except ia64, but there is
no particular reason why ia64 cannot use the common version). Create a
generic instance so all archs can be converted over.

The config switch is temporary and will be removed when all archs are
converted over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: x86@kernel.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/Kconfig          |    3 +++
 init/Makefile         |    1 +
 init/init_task.c      |   24 ++++++++++++++++++++++++
 kernel/sched/Makefile |    2 --
 4 files changed, 28 insertions(+), 2 deletions(-)

Index: tip/arch/Kconfig
===================================================================
--- tip.orig/arch/Kconfig
+++ tip/arch/Kconfig
@@ -148,6 +148,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config HAVE_GENERIC_INIT_TASK
+       bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
Index: tip/init/Makefile
===================================================================
--- tip.orig/init/Makefile
+++ tip/init/Makefile
@@ -9,6 +9,7 @@ else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
+obj-$(CONFIG_HAVE_GENERIC_INIT_TASK) += init_task.o
 
 mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
Index: tip/init/init_task.c
===================================================================
--- /dev/null
+++ tip/init/init_task.c
@@ -0,0 +1,24 @@
+#include <linux/init_task.h>
+#include <linux/module.h>
+#include <linux/mqueue.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+
+/* Initial task structure */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
+
+/*
+ * Initial thread structure. Alignment of this is handled by a special
+ * linker map entry.
+ */
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
Index: tip/kernel/sched/Makefile
===================================================================
--- tip.orig/kernel/sched/Makefile
+++ tip/kernel/sched/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
-
-


