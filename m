Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab0JVT3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:29:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:10393 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758593Ab0JVT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:29:14 -0400
Subject: [PATCH 1/2] x86, apic: cleanup for APIC timer calibration hook
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 22 Oct 2010 12:29:14 -0700
Message-Id: <1287775754.27008.58.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory change to add apic timer calibration hook.

From: Alok N Kataria <akataria@vmware.com>

This change moves some APIC timer calibration code to a seperate function
to facilitate adding a apic clock calibration hook. This change has no
functional effect on the calibration routine.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/apic/apic.c	2010-10-21 13:55:08.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/apic/apic.c	2010-10-22 11:47:47.000000000 -0700
@@ -177,7 +177,7 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-static unsigned int calibration_result;
+static unsigned int apic_calibration_res;
 
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
@@ -481,7 +481,7 @@ static void lapic_timer_setup(enum clock
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		__setup_APIC_LVTT(calibration_result,
+		__setup_APIC_LVTT(apic_calibration_res,
 				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
@@ -640,6 +640,43 @@ calibrate_by_pmtimer(long deltapm, long 
 	return 0;
 }
 
+int __init initialize_lapic_timer(long delta, unsigned int calibration_result)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+	apic_calibration_res = calibration_result;
+
+	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
+	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+		    calibration_result);
+
+	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
+		    "%u.%04u MHz.\n",
+		    calibration_result / (1000000 / HZ),
+		    calibration_result % (1000000 / HZ));
+
+	/*
+	 * Do a sanity check on the APIC calibration result
+	 */
+	if (calibration_result < (1000000 / HZ)) {
+		pr_warning("APIC frequency too slow, disabling apic timer\n");
+		return -1;
+	}
+
+	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
+	return 0;
+}
+
+/* Calibrates the APIC clock and initializes the local APIC timer */
 static int __init calibrate_APIC_clock(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
@@ -647,6 +684,7 @@ static int __init calibrate_APIC_clock(v
 	unsigned long deltaj;
 	long delta, deltatsc;
 	int pm_referenced = 0;
+	unsigned int calibration_result;
 
 	local_irq_disable();
 
@@ -681,20 +719,12 @@ static int __init calibrate_APIC_clock(v
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
 	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
-	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
-	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
-	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
-		    calibration_result);
+	if (initialize_lapic_timer(delta, calibration_result)) {
+		local_irq_enable();
+		return -1;
+	}
 
 	if (cpu_has_tsc) {
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
@@ -703,22 +733,6 @@ static int __init calibrate_APIC_clock(v
 			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}
 
-	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
-		    "%u.%04u MHz.\n",
-		    calibration_result / (1000000 / HZ),
-		    calibration_result % (1000000 / HZ));
-
-	/*
-	 * Do a sanity check on the APIC calibration result
-	 */
-	if (calibration_result < (1000000 / HZ)) {
-		local_irq_enable();
-		pr_warning("APIC frequency too slow, disabling apic timer\n");
-		return -1;
-	}
-
-	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
-
 	/*
 	 * PM timer calibration failed or not turned on
 	 * so lets try APIC timer based calibration
@@ -756,7 +770,7 @@ static int __init calibrate_APIC_clock(v
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		pr_warning("APIC timer disabled due to verification failure\n");
-			return -1;
+		return -1;
 	}
 
 	return 0;


