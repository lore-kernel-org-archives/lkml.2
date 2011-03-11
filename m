Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1CKHCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:02:53 -0500
Received: from server103.greatnet.de ([83.133.97.6]:39663 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1CKHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:02:45 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv4 2/2] x86: cleanup apic.h and apic.h
Date: Fri, 11 Mar 2011 08:02:36 +0100
Message-Id: <1299826956-8607-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299826956-8607-1-git-send-email-henne@nachtwindheim.de>
References: <1299826956-8607-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some functions and variables into init sections,
makes a function static and removes some lines of cruft.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h |    4 --
 arch/x86/kernel/apic/apic.c |   65 ++++++++++++++----------------------------
 2 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index dbd558c..a279d98 100644
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
index 6c464a3..966673f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -93,7 +93,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
  *
  * +1=force-enable
  */
-static int force_enable_local_apic;
+static int force_enable_local_apic __initdata;
 /*
  * APIC command line parameters
  */
@@ -163,7 +163,7 @@ early_param("nox2apic", setup_nox2apic);
 unsigned long mp_lapic_addr;
 int disable_apic;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer __initdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -187,29 +187,8 @@ static struct resource lapic_resource = {
 
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
@@ -248,7 +227,7 @@ static int modern_apic(void)
  * right after this call apic become NOOP driven
  * so apic->write/read doesn't do anything
  */
-void apic_disable(void)
+static void __init apic_disable(void)
 {
 	pr_info("APIC: switched to apic NOOP\n");
 	apic = &apic_noop;
@@ -292,23 +271,6 @@ u64 native_apic_icr_read(void)
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
@@ -518,6 +480,23 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
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
@@ -1560,7 +1539,7 @@ static int __init detect_init_APIC(void)
 }
 #else
 
-static int apic_verify(void)
+static int __init apic_verify(void)
 {
 	u32 features, h, l;
 
@@ -1585,7 +1564,7 @@ static int apic_verify(void)
 	return 0;
 }
 
-int apic_force_enable(unsigned long addr)
+int __init apic_force_enable(unsigned long addr)
 {
 	u32 h, l;
 
-- 
1.7.4.1

