Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0LIX2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:28:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab0LIX2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:28:30 -0500
Date: Thu, 9 Dec 2010 23:28:10 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, gorcunov@gmail.com, ying.huang@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, gorcunov@gmail.com, ying.huang@intel.com,
        tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1291068437-5331-3-git-send-email-dzickus@redhat.com>
References: <1291068437-5331-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Add back unknown_nmi_panic and nmi_watchdog sysctls
Message-ID: <tip-5dc3055879b8f659f62abb7c3d1eaa4d02e36d65@git.kernel.org>
Git-Commit-ID: 5dc3055879b8f659f62abb7c3d1eaa4d02e36d65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 23:28:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dc3055879b8f659f62abb7c3d1eaa4d02e36d65
Gitweb:     http://git.kernel.org/tip/5dc3055879b8f659f62abb7c3d1eaa4d02e36d65
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 29 Nov 2010 17:07:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Dec 2010 00:01:06 +0100

x86, NMI: Add back unknown_nmi_panic and nmi_watchdog sysctls

Originally adapted from Huang Ying's patch which moved the
unknown_nmi_panic to the traps.c file.  Because the old nmi
watchdog was deleted before this change happened, the
unknown_nmi_panic sysctl was lost.  This re-adds it.

Also, the nmi_watchdog sysctl was re-implemented and its
documentation updated accordingly.

Patch-inspired-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: fweisbec@gmail.com
LKML-Reference: <1291068437-5331-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |   10 +---------
 arch/x86/kernel/apic/hw_nmi.c       |    3 ---
 arch/x86/kernel/traps.c             |   16 +++++++++++-----
 kernel/sysctl.c                     |   16 ++++++++++++++++
 kernel/sysctl_binary.c              |    1 -
 kernel/watchdog.c                   |    2 ++
 6 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cdd2a6e..5e55e46 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1579,20 +1579,12 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][num]
-			Valid num: 0,1,2
+			Valid num: 0
 			0 - turn nmi_watchdog off
-			1 - use the IO-APIC timer for the NMI watchdog
-			2 - use the local APIC for the NMI watchdog using
-			a performance counter. Note: This will use one
-			performance counter and the local APIC's performance
-			vector.
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs.
 			This is useful when you use a panic=... timeout and
 			need the box quickly up again.
-			Instead of 1 and 2 it is possible to use the following
-			symbolic names: lapic and ioapic
-			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
 
 	netpoll.carrier_timeout=
 			[NET] Specifies amount of time (in seconds) that
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 2e94eb4..c558e11 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -99,6 +99,3 @@ static int __init register_trigger_all_cpu_backtrace(void)
 }
 early_initcall(register_trigger_all_cpu_backtrace);
 #endif
-
-/* STUB calls to mimic old nmi_watchdog behaviour */
-int unknown_nmi_panic;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f02c179..bb6f041 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+int unknown_nmi_panic;
+
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -300,6 +302,13 @@ gp_in_kernel:
 	die("general protection fault", regs, error_code);
 }
 
+static int __init setup_unknown_nmi_panic(char *str)
+{
+	unknown_nmi_panic = 1;
+	return 1;
+}
+__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
+
 static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs *regs)
 {
@@ -371,7 +380,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 			reason, smp_processor_id());
 
 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
-	if (panic_on_unrecovered_nmi)
+	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
@@ -397,11 +406,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
 							== NOTIFY_STOP)
 			return;
-
-			unknown_nmi_error(reason, regs);
-#else
-		unknown_nmi_error(reason, regs);
 #endif
+		unknown_nmi_error(reason, regs);
 
 		return;
 	}
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cbd97da..4640441 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -745,6 +745,22 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname       = "nmi_watchdog",
+		.data           = &watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_dowatchdog_enabled,
+	},
+#endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
+	{
+		.procname       = "unknown_nmi_panic",
+		.data           = &unknown_nmi_panic,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 #endif
 #if defined(CONFIG_X86)
 	{
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..4b2545a 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -136,7 +136,6 @@ static const struct bin_table bin_kern_table[] = {
 	{ CTL_INT,	KERN_IA64_UNALIGNED,		"ignore-unaligned-usertrap" },
 	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
 	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
-	{ CTL_INT,	KERN_NMI_WATCHDOG,		"nmi_watchdog" },
 	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
 	{}
 };
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index cad4e42..eb17e14 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -57,6 +57,8 @@ static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
+	else if (!strncmp(str, "0", 1))
+		no_watchdog = 1;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
