Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0I0A5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:57:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:7774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab0I0A5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121791"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Date: Mon, 27 Sep 2010 08:57:06 +0800
Message-Id: <1285549026-5008-7-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_nmi_callback related logic is removed, because it is useless, just
adds code complexity.

unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/nmi.h    |   10 +++++++++-
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/apic/nmi.c    |   29 +----------------------------
 arch/x86/kernel/traps.c       |   16 ++++++++++------
 4 files changed, 20 insertions(+), 36 deletions(-)

--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -30,9 +30,17 @@ extern void setup_apic_nmi_watchdog(void
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
@@ -483,23 +482,6 @@ static void disable_ioapic_nmi_watchdog(
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
@@ -540,15 +522,6 @@ int proc_nmi_enabled(struct ctl_table *t
 
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
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -84,6 +84,7 @@ EXPORT_SYMBOL_GPL(used_vectors);
 static int ignore_nmis;
 
 int unknown_nmi_for_hwerr;
+int unknown_nmi_panic;
 
 /*
  * Prevent NMI reason port (0x61) being accessed simultaneously, can
@@ -308,6 +309,13 @@ gp_in_kernel:
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
@@ -385,7 +393,7 @@ unknown_nmi_error(unsigned char reason,
 			reason, smp_processor_id());
 
 	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
-	if (panic_on_unrecovered_nmi)
+	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
@@ -432,12 +440,8 @@ static notrace __kprobes void default_do
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
-#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
-	if (nmi_watchdog_tick(regs, reason))
-		return;
-	if (do_nmi_callback(regs, smp_processor_id()))
+	if (nmi_watchdog_tick(regs))
 		return;
-#endif
 
 	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
 	    == NOTIFY_STOP)
