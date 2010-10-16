Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0JPQhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:37:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:53247 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0JPQhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:37:48 -0400
Date: Sat, 16 Oct 2010 16:37:31 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1287195738-3136-6-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-6-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Remove do_nmi_callback logic
Message-ID: <tip-c218868fcc8f80c34bead7e887003b79faa89c48@git.kernel.org>
Git-Commit-ID: c218868fcc8f80c34bead7e887003b79faa89c48
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:37:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c218868fcc8f80c34bead7e887003b79faa89c48
Gitweb:     http://git.kernel.org/tip/c218868fcc8f80c34bead7e887003b79faa89c48
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 15 Oct 2010 22:22:18 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 15:01:28 +0200

x86, NMI: Remove do_nmi_callback logic

do_nmi_callback related logic is removed, because it is useless,
just adds code complexity.

unknown_nmi_panic sysctl is reserved to keep kernel ABI
unchanged.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: robert.richter@amd.com
Cc: peterz@infradead.org
LKML-Reference: <1287195738-3136-6-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/nmi.h    |   10 +++++++++-
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/apic/nmi.c    |   29 +----------------------------
 arch/x86/kernel/traps.c       |   17 +++++++++++------
 4 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 932f0f8..d5a5793 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -30,9 +30,17 @@ extern void setup_apic_nmi_watchdog(void *);
 extern void stop_apic_nmi_watchdog(void *);
 extern void disable_timer_nmi_watchdog(void);
 extern void enable_timer_nmi_watchdog(void);
-extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
 extern void cpu_nmi_set_wd_enabled(void);
 
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
+extern int nmi_watchdog_tick(struct pt_regs *regs);
+#else
+static inline int nmi_watchdog_tick(struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
 #define NMI_NONE	0
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..e66b16d 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -100,7 +100,6 @@ void acpi_nmi_disable(void) { return; }
 #endif
 atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
-int unknown_nmi_panic;
 void cpu_nmi_set_wd_enabled(void) { return; }
 void stop_apic_nmi_watchdog(void *unused) { return; }
 void setup_apic_nmi_watchdog(void *unused) { return; }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index a43f71c..f407b6b 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -37,7 +37,6 @@
 
 #include <asm/mach_traps.h>
 
-int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
 /* For reliability, we're prepared to waste bits here. */
@@ -389,7 +388,7 @@ void touch_nmi_watchdog(void)
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
 notrace __kprobes int
-nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
+nmi_watchdog_tick(struct pt_regs *regs)
 {
 	/*
 	 * Since current_thread_info()-> is always on the stack, and we
@@ -483,23 +482,6 @@ static void disable_ioapic_nmi_watchdog(void)
 	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
 }
 
-static int __init setup_unknown_nmi_panic(char *str)
-{
-	unknown_nmi_panic = 1;
-	return 1;
-}
-__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
-
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
-{
-	unsigned char reason = get_nmi_reason();
-	char buf[64];
-
-	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(buf, regs, 1); /* Always panic here */
-	return 0;
-}
-
 /*
  * proc handler for /proc/sys/kernel/nmi
  */
@@ -540,15 +522,6 @@ int proc_nmi_enabled(struct ctl_table *table, int write,
 
 #endif /* CONFIG_SYSCTL */
 
-int do_nmi_callback(struct pt_regs *regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index accb2f4..9ef8e15 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+int unknown_nmi_panic;
+
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
  * only be used in NMI handler.
@@ -306,6 +308,13 @@ gp_in_kernel:
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
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
@@ -380,7 +389,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 		 reason, smp_processor_id());
 
 	pr_emerg("Do you have a strange power saving mode enabled?\n");
-	if (panic_on_unrecovered_nmi)
+	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
@@ -431,12 +440,8 @@ unlock_return:
 	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
-#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
-	if (nmi_watchdog_tick(regs, reason))
-		return;
-	if (do_nmi_callback(regs, cpu))
+	if (nmi_watchdog_tick(regs))
 		return;
-#endif
 
 	unknown_nmi_error(reason, regs);
 }
