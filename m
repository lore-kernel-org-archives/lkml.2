Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992640Ab2KBKdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:33:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2KBKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:33:09 -0400
Date: Fri, 2 Nov 2012 03:32:48 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-279f1461432ccdec0b98c0bcbe0a8e2c0f6fdda5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1350941878.6017.31.camel@sbsiddha-desk.sc.intel.com>
References: <1350941878.6017.31.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86: apic:
  Use tsc deadline for oneshot when available
Git-Commit-ID: 279f1461432ccdec0b98c0bcbe0a8e2c0f6fdda5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Nov 2012 03:32:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  279f1461432ccdec0b98c0bcbe0a8e2c0f6fdda5
Gitweb:     http://git.kernel.org/tip/279f1461432ccdec0b98c0bcbe0a8e2c0f6fdda5
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 22 Oct 2012 14:37:58 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 2 Nov 2012 11:23:37 +0100

x86: apic: Use tsc deadline for oneshot when available

If the TSC deadline mode is supported, LAPIC timer one-shot mode can be
implemented using IA32_TSC_DEADLINE MSR. An interrupt will be generated
when the TSC value equals or exceeds the value in the IA32_TSC_DEADLINE
MSR.

This enables us to skip the APIC calibration during boot. Also, in
xapic mode, this enables us to skip the uncached apic access to re-arm
the APIC timer.

As this timer ticks at the high frequency TSC rate, we use the
TSC_DIVISOR (32) to work with the 32-bit restrictions in the
clockevent API's to avoid 64-bit divides etc (frequency is u32 and
"unsigned long" in the set_next_event(), max_delta limits the next
event to 32-bit for 32-bit kernel).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: venki@google.com
Cc: len.brown@intel.com
Link: http://lkml.kernel.org/r/1350941878.6017.31.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    4 ++
 arch/x86/include/asm/msr-index.h    |    2 +
 arch/x86/kernel/apic/apic.c         |   73 +++++++++++++++++++++++++---------
 3 files changed, 59 insertions(+), 20 deletions(-)

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
