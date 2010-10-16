Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0JPCX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0JPCW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:22:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: andi@firstfloor.org, robert.richter@amd.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/5] x86, NMI: Remove do_nmi_callback logic
Date: Fri, 15 Oct 2010 22:22:18 -0400
Message-Id: <1287195738-3136-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

do_nmi_callback related logic is removed, because it is useless, just
adds code complexity.

unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
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
-- 
1.7.2.3

