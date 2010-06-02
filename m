Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0FBJrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:47:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:34722 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0FBJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SJdw4f4DHVzkUs206cKqXE2ffNyew2pcPNFshjPuVcXF2O69xJydxxWWxen4aXp33J
         XWQpvyEfE6Uv/gQubN7Xbz6+q4l5DOtV/xupPcMlai52oIcIOcDBn/Ns8J77wHMouEqM
         5Oqxkz98HJ2FslGKIo3jnZpnTyzHoJR1MaH+Y=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 4/5] x86: Add new callback for unhandled NMIs
Date: Wed,  2 Jun 2010 09:39:18 +0200
Message-Id: <1275464359-1566-5-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new NMI callback, controlled via sysctl variable
`unknown_nmi_dump_log'. When kernel is in dump capture mode, and user
presses NMI button on chassis or sends such event via control console,
callback extracts and prints kernel log and CPU registers from
captured vmcore, and also prints state of running kernel.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 arch/x86/include/asm/nmi.h |    1 +
 arch/x86/kernel/apic/nmi.c |   27 +++++++++++++++++++++++++++
 include/linux/sysctl.h     |    1 +
 kernel/sysctl.c            |    7 +++++++
 kernel/sysctl_binary.c     |    1 +
 5 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 93da9c3..5ca20cf 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -42,6 +42,7 @@ struct ctl_table;
 extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
+extern int unknown_nmi_dump_log;
 
 void arch_trigger_all_cpu_backtrace(void);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 1edaf15..22a2688 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -37,7 +37,10 @@
 
 #include <asm/mach_traps.h>
 
+#include <linux/crash_dump.h>
+
 int unknown_nmi_panic;
+int unknown_nmi_dump_log;
 int nmi_watchdog_enabled;
 
 /* For reliability, we're prepared to waste bits here. */
@@ -507,6 +510,28 @@ static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
 	return 0;
 }
 
+static int __init setup_unknown_nmi_dump_log(char *str)
+{
+	unknown_nmi_dump_log = 1;
+	return 1;
+}
+__setup("unknown_nmi_dump_log", setup_unknown_nmi_dump_log);
+
+static int unknown_nmi_dump_log_callback(struct pt_regs *regs, int cpu)
+{
+	printk(KERN_WARNING "NMI received for unknown reason %02x\n",
+	       get_nmi_reason());
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		dump_old_log();
+		printk(KERN_INFO "--- kdump kernel state begins here---\n");
+		show_state();
+		printk(KERN_INFO "--- kdump kernel state ends here---\n");
+	}
+#endif
+	return 0;
+}
+
 /*
  * proc handler for /proc/sys/kernel/nmi
  */
@@ -552,6 +577,8 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
 #ifdef CONFIG_SYSCTL
 	if (unknown_nmi_panic)
 		return unknown_nmi_panic_callback(regs, cpu);
+	if (unknown_nmi_dump_log)
+		return unknown_nmi_dump_log_callback(regs, cpu);
 #endif
 	return 0;
 }
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 7bb5cb6..7d2489d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -153,6 +153,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_UNKNOWN_NMI_DUMP_LOG=77, /* int: unknown nmi dump log flag */
 };
 
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 997080f..03cc3c5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -719,6 +719,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = proc_dointvec,
 	},
 	{
+		.procname       = "unknown_nmi_dump_log",
+		.data           = &unknown_nmi_dump_log,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	{
 		.procname       = "nmi_watchdog",
 		.data           = &nmi_watchdog_enabled,
 		.maxlen         = sizeof (int),
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..e59d0b1 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -128,6 +128,7 @@ static const struct bin_table bin_kern_table[] = {
 	{ CTL_INT,	KERN_SPARC_SCONS_PWROFF,	"scons-poweroff" },
 	/* KERN_HZ_TIMER "hz_timer" no longer used */
 	{ CTL_INT,	KERN_UNKNOWN_NMI_PANIC,		"unknown_nmi_panic" },
+	{ CTL_INT,	KERN_UNKNOWN_NMI_DUMP_LOG,	"unknown_nmi_dump_log" },
 	{ CTL_INT,	KERN_BOOTLOADER_TYPE,		"bootloader_type" },
 	{ CTL_INT,	KERN_RANDOMIZE,			"randomize_va_space" },
 
-- 
1.7.1

