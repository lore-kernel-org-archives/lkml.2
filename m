Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1CKJyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:54:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:38693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1CKJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:54:10 -0500
Date: Fri, 11 Mar 2011 09:53:37 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, tglx@linutronix.de, henne@nachtwindheim.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, henne@nachtwindheim.de,
        mingo@elte.hu
In-Reply-To: <1299826956-8607-2-git-send-email-henne@nachtwindheim.de>
References: <1299826956-8607-2-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Clean up apic.c and apic.h
Message-ID: <tip-25874a299ef8037df03ce4ada570bc4e42f9748f@git.kernel.org>
Git-Commit-ID: 25874a299ef8037df03ce4ada570bc4e42f9748f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:53:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25874a299ef8037df03ce4ada570bc4e42f9748f
Gitweb:     http://git.kernel.org/tip/25874a299ef8037df03ce4ada570bc4e42f9748f
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Fri, 11 Mar 2011 08:02:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Mar 2011 08:13:59 +0100

x86: Clean up apic.c and apic.h

This patch moves some functions and variables into init
sections, makes a function static and removes some lines of
cruft.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <1299826956-8607-2-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h |    4 --
 arch/x86/kernel/apic/apic.c |   65 ++++++++++++++----------------------------
 2 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4afe512..5b7d513 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -220,7 +220,6 @@ extern void enable_IR_x2apic(void);
 
 extern int get_physical_broadcast(void);
 
-extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -228,7 +227,6 @@ extern void disconnect_bsp_APIC(int virt_wire_setup);
 extern void disable_local_APIC(void);
 extern void lapic_shutdown(void);
 extern int verify_local_APIC(void);
-extern void cache_APIC_registers(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
@@ -239,7 +237,6 @@ void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
-extern void enable_NMI_through_LVT0(void);
 extern int apic_force_enable(unsigned long addr);
 
 /*
@@ -261,7 +258,6 @@ static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
-static inline void apic_disable(void) { }
 # define setup_boot_APIC_clock x86_init_noop
 # define setup_secondary_APIC_clock x86_init_noop
 #endif /* !CONFIG_X86_LOCAL_APIC */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4f43312..ffbf7c2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -84,7 +84,7 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
  *
  * +1=force-enable
  */
-static int force_enable_local_apic;
+static int force_enable_local_apic __initdata;
 /*
  * APIC command line parameters
  */
@@ -154,7 +154,7 @@ early_param("nox2apic", setup_nox2apic);
 unsigned long mp_lapic_addr;
 int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer __initdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -178,29 +178,8 @@ static struct resource lapic_resource = {
 
 static unsigned int calibration_result;
 
-static int lapic_next_event(unsigned long delta,
-			    struct clock_event_device *evt);
-static void lapic_timer_setup(enum clock_event_mode mode,
-			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(const struct cpumask *mask);
 static void apic_pm_activate(void);
 
-/*
- * The local apic timer can be used for any function which is CPU local.
- */
-static struct clock_event_device lapic_clockevent = {
-	.name		= "lapic",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
-			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
-	.shift		= 32,
-	.set_mode	= lapic_timer_setup,
-	.set_next_event	= lapic_next_event,
-	.broadcast	= lapic_timer_broadcast,
-	.rating		= 100,
-	.irq		= -1,
-};
-static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
-
 static unsigned long apic_phys;
 
 /*
@@ -239,7 +218,7 @@ static int modern_apic(void)
  * right after this call apic become NOOP driven
  * so apic->write/read doesn't do anything
  */
-void apic_disable(void)
+static void __init apic_disable(void)
 {
 	pr_info("APIC: switched to apic NOOP\n");
 	apic = &apic_noop;
@@ -283,23 +262,6 @@ u64 native_apic_icr_read(void)
 	return icr1 | ((u64)icr2 << 32);
 }
 
-/**
- * enable_NMI_through_LVT0 - enable NMI through local vector table 0
- */
-void __cpuinit enable_NMI_through_LVT0(void)
-{
-	unsigned int v;
-
-	/* unmask and set to NMI */
-	v = APIC_DM_NMI;
-
-	/* Level triggered for 82489DX (32bit mode) */
-	if (!lapic_is_integrated())
-		v |= APIC_LVT_LEVEL_TRIGGER;
-
-	apic_write(APIC_LVT0, v);
-}
-
 #ifdef CONFIG_X86_32
 /**
  * get_physical_broadcast - Get number of physical broadcast IDs
@@ -509,6 +471,23 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
 #endif
 }
 
+
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+
 /*
  * Setup the local APIC timer for this CPU. Copy the initialized values
  * of the boot CPU and register the clock event in the framework.
@@ -1538,7 +1517,7 @@ static int __init detect_init_APIC(void)
 }
 #else
 
-static int apic_verify(void)
+static int __init apic_verify(void)
 {
 	u32 features, h, l;
 
@@ -1563,7 +1542,7 @@ static int apic_verify(void)
 	return 0;
 }
 
-int apic_force_enable(unsigned long addr)
+int __init apic_force_enable(unsigned long addr)
 {
 	u32 h, l;
 
