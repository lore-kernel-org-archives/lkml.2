Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0KLOod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:44:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KLOob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:44:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/6] x86, NMI: Remove do_nmi_callback logic
Date: Fri, 12 Nov 2010 09:43:53 -0500
Message-Id: <1289573033-2889-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_nmi_callback related logic is removed, because it is useless, just
adds code complexity.

unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>

Conflicts:

	arch/x86/kernel/traps.c
---
 arch/x86/include/asm/nmi.h    |   10 +++++++++-
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/apic/nmi.c    |   29 +----------------------------
 arch/x86/kernel/traps.c       |   17 +++++++++++------
 4 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index cfb6156..f4b6b26 100644
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
index fabe4fe..5c4f952 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -99,7 +99,6 @@ void acpi_nmi_disable(void) { return; }
 #endif
 atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
-int unknown_nmi_panic;
 void cpu_nmi_set_wd_enabled(void) { return; }
 void stop_apic_nmi_watchdog(void *unused) { return; }
 void setup_apic_nmi_watchdog(void *unused) { return; }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index c90041c..27b9421 100644
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
index ed40ad6..ce8b94d 100644
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
@@ -421,12 +430,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
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

