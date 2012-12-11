Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2LKLUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:20:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2LKLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:20:09 -0500
Date: Tue, 11 Dec 2012 12:20:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/timers changes for v3.8
Message-ID: <20121211112004.GA26926@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-timers-for-linus

   HEAD: 5074b85bdd3a464efe7b6de2ec163f4c07696a20 x86: hpet: Fix inverted return value check in arch_setup_hpet_msi()

This tree includes HPET fixes and also implements a 
calibration-free, TSC match driven APIC timer interrupt mode: 
"TSC deadline mode" supported in SandyBridge and later CPUs.

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86: hpet: Fix masking of MSI interrupts
      x86: hpet: Fix inverted return value check in arch_setup_hpet_msi()

Suresh Siddha (1):
      x86: apic: Use tsc deadline for oneshot when available


 Documentation/kernel-parameters.txt |  4 ++
 arch/x86/include/asm/msr-index.h    |  2 +
 arch/x86/kernel/apic/apic.c         | 73 +++++++++++++++++++++++++++----------
 arch/x86/kernel/apic/io_apic.c      |  5 ++-
 arch/x86/kernel/hpet.c              |  4 +-
 5 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..4aa9ca0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1304,6 +1304,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
+	lapic=		[x86,APIC] "notscdeadline" Do not use TSC deadline
+			value for LAPIC timer one-shot implementation. Default
+			back to the programmable timer unit in the LAPIC.
+
 	lapic_timer_c2_ok	[X86,APIC] trust the local apic timer
 			in C2 power state.
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7f0edce..e400cdb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -337,6 +337,8 @@
 #define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
 #define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
 
+#define MSR_IA32_TSC_DEADLINE		0x000006E0
+
 /* P4/Xeon+ specific */
 #define MSR_IA32_MCG_EAX		0x00000180
 #define MSR_IA32_MCG_EBX		0x00000181
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b17416e..b994cc8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -90,21 +90,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
  */
 DEFINE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid, BAD_APICID);
 
-/*
- * Knob to control our willingness to enable the local APIC.
- *
- * +1=force-enable
- */
-static int force_enable_local_apic __initdata;
-/*
- * APIC command line parameters
- */
-static int __init parse_lapic(char *arg)
-{
-	force_enable_local_apic = 1;
-	return 0;
-}
-early_param("lapic", parse_lapic);
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
 
@@ -133,6 +118,25 @@ static inline void imcr_apic_to_pic(void)
 }
 #endif
 
+/*
+ * Knob to control our willingness to enable the local APIC.
+ *
+ * +1=force-enable
+ */
+static int force_enable_local_apic __initdata;
+/*
+ * APIC command line parameters
+ */
+static int __init parse_lapic(char *arg)
+{
+	if (config_enabled(CONFIG_X86_32) && !arg)
+		force_enable_local_apic = 1;
+	else if (!strncmp(arg, "notscdeadline", 13))
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
+	return 0;
+}
+early_param("lapic", parse_lapic);
+
 #ifdef CONFIG_X86_64
 static int apic_calibrate_pmtmr __initdata;
 static __init int setup_apicpmtimer(char *s)
@@ -315,6 +319,7 @@ int lapic_get_maxlvt(void)
 
 /* Clock divisor */
 #define APIC_DIVISOR 16
+#define TSC_DIVISOR  32
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -333,6 +338,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	lvtt_value = LOCAL_TIMER_VECTOR;
 	if (!oneshot)
 		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	else if (boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER))
+		lvtt_value |= APIC_LVT_TIMER_TSCDEADLINE;
+
 	if (!lapic_is_integrated())
 		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);
 
@@ -341,6 +349,11 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 
 	apic_write(APIC_LVTT, lvtt_value);
 
+	if (lvtt_value & APIC_LVT_TIMER_TSCDEADLINE) {
+		printk_once(KERN_DEBUG "TSC deadline timer enabled\n");
+		return;
+	}
+
 	/*
 	 * Divide PICLK by 16
 	 */
@@ -453,6 +466,16 @@ static int lapic_next_event(unsigned long delta,
 	return 0;
 }
 
+static int lapic_next_deadline(unsigned long delta,
+			       struct clock_event_device *evt)
+{
+	u64 tsc;
+
+	rdtscll(tsc);
+	wrmsrl(MSR_IA32_TSC_DEADLINE, tsc + (((u64) delta) * TSC_DIVISOR));
+	return 0;
+}
+
 /*
  * Setup the lapic timer in periodic or oneshot mode
  */
@@ -533,7 +556,15 @@ static void __cpuinit setup_APIC_timer(void)
 	memcpy(levt, &lapic_clockevent, sizeof(*levt));
 	levt->cpumask = cpumask_of(smp_processor_id());
 
-	clockevents_register_device(levt);
+	if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
+		levt->features &= ~(CLOCK_EVT_FEAT_PERIODIC |
+				    CLOCK_EVT_FEAT_DUMMY);
+		levt->set_next_event = lapic_next_deadline;
+		clockevents_config_and_register(levt,
+						(tsc_khz / TSC_DIVISOR) * 1000,
+						0xF, ~0UL);
+	} else
+		clockevents_register_device(levt);
 }
 
 /*
@@ -661,7 +692,9 @@ static int __init calibrate_APIC_clock(void)
 	 * in the clockevent structure and return.
 	 */
 
-	if (lapic_timer_frequency) {
+	if (boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
+		return 0;
+	} else if (lapic_timer_frequency) {
 		apic_printk(APIC_VERBOSE, "lapic timer already calibrated %d\n",
 				lapic_timer_frequency);
 		lapic_clockevent.mult = div_sc(lapic_timer_frequency/APIC_DIVISOR,
@@ -674,6 +707,9 @@ static int __init calibrate_APIC_clock(void)
 		return 0;
 	}
 
+	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+		    "calibrating APIC timer ...\n");
+
 	local_irq_disable();
 
 	/* Replace the global interrupt handler */
@@ -811,9 +847,6 @@ void __init setup_boot_APIC_clock(void)
 		return;
 	}
 
-	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
-		    "calibrating APIC timer ...\n");
-
 	if (calibrate_APIC_clock()) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..b134f0b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3317,8 +3317,9 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	int ret;
 
 	if (irq_remapping_enabled) {
-		if (!setup_hpet_msi_remapped(irq, id))
-			return -1;
+		ret = setup_hpet_msi_remapped(irq, id);
+		if (ret)
+			return ret;
 	}
 
 	ret = msi_compose_msg(NULL, irq, &msg, id);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 1460a5d..e28670f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *data)
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data)
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
