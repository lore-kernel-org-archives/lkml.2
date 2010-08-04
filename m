Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0HDPYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:24:39 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49170 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0HDPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:24:38 -0400
Date: Wed, 4 Aug 2010 16:23:42 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-mips@linux-mips.org
Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Message-ID: <20100804152342.GC21004@linux-mips.org>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
 <20100802154434.5615bcf9.akpm@linux-foundation.org>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
 <20100803165926.2e37d355.akpm@linux-foundation.org>
 <20100804033034.GA15098@linux-sh.org>
 <20100804135145.GA21004@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804135145.GA21004@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh's patch was lacking akpm's cleanup patch.  So I created the
following from all contributions.

  Ralf

>From 040f52ce2a3cab374bfed036ccd8ecf4b1fb7add Mon Sep 17 00:00:00 2001
From: Kevin Cernekee <cernekee@gmail.com>
Date: Thu, 3 Jun 2010 22:11:25 -0700
Subject: [PATCH] printk: fix delayed messages from CPU hotplug events

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

Original patch by Kevin Cernekee with cleanups by akpm and additional fixes
by Santosh Shilimkar.  This patch superseeds
https://patchwork.linux-mips.org/patch/1357/.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
To: <mingo@elte.hu>
To: <akpm@linux-foundation.org>
To: <simon.kagstrom@netinsight.net>
To: <David.Woodhouse@intel.com>
To: <lethal@linux-sh.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-mips@linux-mips.org>
Reviewed-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Patchwork: https://patchwork.linux-mips.org/patch/1533/
LKML-Reference: <ede63b5a20af951c755736f035d1e787772d7c28@localhost>
LKML-Reference: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..4ab0164 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -37,6 +37,8 @@
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
 
 #include <asm/uaccess.h>
 
@@ -985,6 +987,32 @@ void resume_console(void)
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
+	case CPU_DEAD:
+	case CPU_DYING:
+	case CPU_DOWN_FAILED:
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
@@ -1371,7 +1399,7 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
-static int __init disable_boot_consoles(void)
+static int __init printk_late_init(void)
 {
 	struct console *con;
 
@@ -1382,9 +1410,10 @@ static int __init disable_boot_consoles(void)
 			unregister_console(con);
 		}
 	}
+	hotcpu_notifier(console_cpu_notify, 0);
 	return 0;
 }
-late_initcall(disable_boot_consoles);
+late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
