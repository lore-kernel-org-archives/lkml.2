Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0KWTeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:34:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0KWTet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:34:49 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: fweisbec@gmail.com, gorcunov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>, yinghai@kernel.org,
        Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 1/3] x86, NMI: Remove do_nmi_callback logic
Date: Tue, 23 Nov 2010 14:32:03 -0500
Message-Id: <1290540725-2911-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

do_nmi_callback related logic is removed, because it is useless, just
adds code complexity.

unknown_nmi_panic sysctl is reserved to keep kernel ABI unchanged.

[ I made a bunch of tweaks to deal with the this being a standalone
  patch instead of later in a series -dcz ]

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/apic/nmi.c    |   27 ---------------------------
 arch/x86/kernel/traps.c       |   16 +++++++++++-----
 3 files changed, 11 insertions(+), 33 deletions(-)

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
index c90041c..7bab143 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -37,7 +37,6 @@
 
 #include <asm/mach_traps.h>
 
-int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
 /* For reliability, we're prepared to waste bits here. */
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
index cb838ca..53ea71f 100644
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
@@ -405,12 +414,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, cpu))
 #endif /* !CONFIG_LOCKUP_DETECTOR */
-			unknown_nmi_error(reason, regs);
-#else
-		unknown_nmi_error(reason, regs);
 #endif
+		unknown_nmi_error(reason, regs);
 
 		return;
 	}
-- 
1.7.3.2

