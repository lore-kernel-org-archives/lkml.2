Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab0FFBfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 21:35:34 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40454 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768Ab0FFBfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 21:35:33 -0400
Date: Sun, 6 Jun 2010 02:35:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
       simon.kagstrom@netinsight.net, David.Woodhouse@intel.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH v4] printk: fix delayed messages from CPU hotplug events
Message-ID: <20100606013505.GB6169@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:   Kevin Cernekee <cernekee@gmail.com>

printk: fix delayed messages from CPU hotplug events

When a secondary CPU is being brought up, it is not uncommon for
printk() to be invoked when cpu_online(smp_processor_id()) == 0.  The
case that I witnessed personally was on MIPS:

http://lkml.org/lkml/2010/5/30/4

If (can_use_console() == 0), printk() will spool its output to log_buf
and it will be visible in "dmesg", but that output will NOT be echoed to
the console until somebody calls release_console_sem() from a CPU that
is online.  Therefore, the boot time messages from the new CPU can get
stuck in "limbo" for a long time, and might suddenly appear on the
screen when a completely unrelated event (e.g. "eth0: link is down")
occurs.

This patch modifies the console code so that any pending messages are
automatically flushed out to the console whenever a CPU hotplug
operation completes successfully or aborts.

The issue was seen on 2.6.34.

[Ralf: Cleanup patch posted by akpm merged into the patch]

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
To: <mingo@elte.hu>
To: <akpm@linux-foundation.org>
To: <simon.kagstrom@netinsight.net>
To: <David.Woodhouse@intel.com>
To: <lethal@linux-sh.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-mips@linux-mips.org>
Patchwork: http://patchwork.linux-mips.org/patch/1355/
Reviewed-by: Paul Mundt <lethal@linux-sh.org>
Patchwork: http://patchwork.linux-mips.org/patch/1356/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 kernel/printk.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

Index: linux-queue/kernel/printk.c
===================================================================
--- linux-queue.orig/kernel/printk.c
+++ linux-queue/kernel/printk.c
@@ -37,6 +37,8 @@
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
 
 #include <asm/uaccess.h>
 
@@ -985,6 +987,29 @@ void resume_console(void)
 }
 
 /**
+ * console_cpu_notify - print deferred console messages after CPU hotplug
+ * @self: notifier struct
+ * @action: CPU hotplug event
+ * @hcpu: unused
+ *
+ * If printk() is called from a CPU that is not online yet, the messages
+ * will be spooled but will not show up on the console.  This function is
+ * called when a new CPU comes online (or fails to come up), and ensures
+ * that any such output gets printed.
+ */
+static int __cpuinit console_cpu_notify(struct notifier_block *self,
+	unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_UP_CANCELED:
+		acquire_console_sem();
+		release_console_sem();
+	}
+	return NOTIFY_OK;
+}
+
+/**
  * acquire_console_sem - lock the console system for exclusive use.
  *
  * Acquires a semaphore which guarantees that the caller has
@@ -1371,7 +1396,7 @@ int unregister_console(struct console *c
 }
 EXPORT_SYMBOL(unregister_console);
 
-static int __init disable_boot_consoles(void)
+static int __init printk_late_init(void)
 {
 	struct console *con;
 
@@ -1382,9 +1407,10 @@ static int __init disable_boot_consoles(
 			unregister_console(con);
 		}
 	}
+	hotcpu_notifier(console_cpu_notify, 0);
 	return 0;
 }
-late_initcall(disable_boot_consoles);
+late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
