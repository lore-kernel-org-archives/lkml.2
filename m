Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0HRRlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:41:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:49900 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab0HRRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:41:44 -0400
Subject: [PATCH] x86, apic: Add apic calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 18 Aug 2010 10:41:44 -0700
Message-Id: <1282153304.15158.39.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function pointer calibrate_apic to x86_platform_ops. On native this
does the usual apic calibration. On VMware's platform we override it with a
routine which gets that information from the hypervisor.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: H. Peter Anvin <hpa@zytor.com>

Index: linux-x86-tree.git/arch/x86/include/asm/apic.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/apic.h	2010-08-17 15:29:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/apic.h	2010-08-17 15:32:11.000000000 -0700
@@ -238,6 +238,7 @@ extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern void enable_NMI_through_LVT0(void);
+extern unsigned int native_calibrate_apic(void);
 
 /*
  * On 32bit this is mach-xxx local
Index: linux-x86-tree.git/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/x86_init.h	2010-08-17 15:29:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/x86_init.h	2010-08-18 10:20:21.000000000 -0700
@@ -143,6 +143,7 @@ struct x86_cpuinit_ops {
  * @is_untracked_pat_range	exclude from PAT logic
  * @nmi_init			enable NMI on cpus
  * @i8042_detect		pre-detect if i8042 controller exists
+ * @calibrate_apic:		calibrate APIC bus freq
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -152,6 +153,7 @@ struct x86_platform_ops {
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
 	int (*i8042_detect)(void);
+	unsigned int (*calibrate_apic)(void);
 };
 
 extern struct x86_init_ops x86_init;
Index: linux-x86-tree.git/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/apic/apic.c	2010-08-17 15:29:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/apic/apic.c	2010-08-18 10:20:55.000000000 -0700
@@ -176,7 +176,7 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-static unsigned int calibration_result;
+static unsigned int apic_calibration_res;
 
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
@@ -431,7 +431,7 @@ static void lapic_timer_setup(enum clock
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		__setup_APIC_LVTT(calibration_result,
+		__setup_APIC_LVTT(apic_calibration_res,
 				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
@@ -590,13 +590,46 @@ calibrate_by_pmtimer(long deltapm, long 
 	return 0;
 }
 
+static void __init initialize_lapic_clkevt(long delta)
+{
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+}
+
 static int __init calibrate_APIC_clock(void)
 {
+	apic_calibration_res = x86_platform.calibrate_apic();
+	if (apic_calibration_res) {
+		struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+		long delta;
+
+		if (lapic_clockevent.mult)
+			return 0;
+
+		delta = (apic_calibration_res * LAPIC_CAL_LOOPS) / APIC_DIVISOR;
+		initialize_lapic_clkevt(delta);
+		levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
+		return 0;
+	} else {
+		pr_warning("Unable to calibrate APIC frequency, "
+			   "disabling apic timer\n");
+		return -1;
+	}
+}
+
+unsigned int __init native_calibrate_apic(void)
+{
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
 	long delta, deltatsc;
 	int pm_referenced = 0;
+	unsigned int calibration_result;
 
 	local_irq_disable();
 
@@ -631,14 +664,7 @@ static int __init calibrate_APIC_clock(v
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
 					&delta, &deltatsc);
 
-	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
-				       lapic_clockevent.shift);
-	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
-	lapic_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &lapic_clockevent);
-
+	initialize_lapic_clkevt(delta);
 	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
 	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
@@ -664,7 +690,7 @@ static int __init calibrate_APIC_clock(v
 	if (calibration_result < (1000000 / HZ)) {
 		local_irq_enable();
 		pr_warning("APIC frequency too slow, disabling apic timer\n");
-		return -1;
+		return 0;
 	}
 
 	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
@@ -706,10 +732,10 @@ static int __init calibrate_APIC_clock(v
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		pr_warning("APIC timer disabled due to verification failure\n");
-			return -1;
+			return 0;
 	}
 
-	return 0;
+	return calibration_result;
 }
 
 /*
Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2010-08-17 15:29:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2010-08-18 10:20:21.000000000 -0700
@@ -72,17 +72,33 @@ static unsigned long vmware_get_tsc_khz(
 	return tsc_hz;
 }
 
+static unsigned int vmware_calibrate_apic(void)
+{
+	unsigned int calibration_result;
+	uint32_t eax, ebx, ecx, edx;
+
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+	BUG_ON(!ecx);
+	calibration_result = ecx / HZ;
+
+	printk(KERN_INFO "APIC bus freq read from hypervisor : %u.%03u MHz\n",
+			 calibration_result / (1000000 / HZ),
+			 calibration_result % (1000000 / HZ));
+	return calibration_result;
+}
+
 static void __init vmware_platform_setup(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
 
-	if (ebx != UINT_MAX)
+	if (ebx != UINT_MAX) {
 		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
-	else
+		x86_platform.calibrate_apic = vmware_calibrate_apic;
+	} else
 		printk(KERN_WARNING
-		       "Failed to get TSC freq from the hypervisor\n");
+		       "Failed to setup VMware hypervisor platform\n");
 }
 
 /*
Index: linux-x86-tree.git/arch/x86/kernel/x86_init.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/x86_init.c	2010-08-17 15:29:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/x86_init.c	2010-08-17 16:44:20.000000000 -0700
@@ -95,7 +95,8 @@ struct x86_platform_ops x86_platform = {
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
-	.i8042_detect			= default_i8042_detect
+	.i8042_detect			= default_i8042_detect,
+	.calibrate_apic			= native_calibrate_apic
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);


