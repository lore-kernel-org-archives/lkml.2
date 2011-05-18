Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1ERVds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:33:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:54580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1ERVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:44 -0400
Message-Id: <20110518210136.646482357@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 7/7] x86: hpet: Cleanup the clockevents init and register code
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline; filename=x86-hept-convert.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to recalculate the frequency and the conversion factors over
and over. Calculate the frequency once and use the new config/register
interface and let the core code do the math.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c |   71 ++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 56 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hpet.c
+++ linux-2.6-tip/arch/x86/kernel/hpet.c
@@ -217,7 +217,7 @@ static void hpet_reserve_platform_timers
 /*
  * Common hpet info
  */
-static unsigned long hpet_period;
+static unsigned long hpet_freq;
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt);
@@ -232,7 +232,6 @@ static struct clock_event_device hpet_cl
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= hpet_legacy_set_mode,
 	.set_next_event = hpet_legacy_next_event,
-	.shift		= 32,
 	.irq		= 0,
 	.rating		= 50,
 };
@@ -290,28 +289,12 @@ static void hpet_legacy_clockevent_regis
 	hpet_enable_legacy_int();
 
 	/*
-	 * The mult factor is defined as (include/linux/clockchips.h)
-	 *  mult/2^shift = cyc/ns (in contrast to ns/cyc in clocksource.h)
-	 * hpet_period is in units of femtoseconds (per cycle), so
-	 *  mult/2^shift = cyc/ns = 10^6/hpet_period
-	 *  mult = (10^6 * 2^shift)/hpet_period
-	 *  mult = (FSEC_PER_NSEC << hpet_clockevent.shift)/hpet_period
-	 */
-	hpet_clockevent.mult = div_sc((unsigned long) FSEC_PER_NSEC,
-				      hpet_period, hpet_clockevent.shift);
-	/* Calculate the min / max delta */
-	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
-							   &hpet_clockevent);
-	/* Setup minimum reprogramming delta. */
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(HPET_MIN_PROG_DELTA,
-							   &hpet_clockevent);
-
-	/*
 	 * Start hpet with the boot cpu mask and make it
 	 * global after the IO_APIC has been initialized.
 	 */
 	hpet_clockevent.cpumask = cpumask_of(smp_processor_id());
-	clockevents_register_device(&hpet_clockevent);
+	clockevents_config_and_register(&hpet_clockevent, hpet_freq,
+					HPET_MIN_PROG_DELTA, 0x7FFFFFFF);
 	global_clock_event = &hpet_clockevent;
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
@@ -549,7 +532,6 @@ static int hpet_setup_irq(struct hpet_de
 static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 {
 	struct clock_event_device *evt = &hdev->evt;
-	uint64_t hpet_freq;
 
 	WARN_ON(cpu != smp_processor_id());
 	if (!(hdev->flags & HPET_DEV_VALID))
@@ -571,24 +553,9 @@ static void init_one_hpet_msi_clockevent
 
 	evt->set_mode = hpet_msi_set_mode;
 	evt->set_next_event = hpet_msi_next_event;
-	evt->shift = 32;
-
-	/*
-	 * The period is a femto seconds value. We need to calculate the
-	 * scaled math multiplication factor for nanosecond to hpet tick
-	 * conversion.
-	 */
-	hpet_freq = FSEC_PER_SEC;
-	do_div(hpet_freq, hpet_period);
-	evt->mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, evt->shift);
-	/* Calculate the max delta */
-	evt->max_delta_ns = clockevent_delta2ns(0x7FFFFFFF, evt);
-	/* 5 usec minimum reprogramming delta. */
-	evt->min_delta_ns = 5000;
-
 	evt->cpumask = cpumask_of(hdev->cpu);
-	clockevents_register_device(evt);
+
+	clockevents_config_and_register(evt, hpet_freq, 5000, 0x7FFFFFFF);
 }
 
 #ifdef CONFIG_HPET
@@ -792,7 +759,6 @@ static struct clocksource clocksource_hp
 static int hpet_clocksource_register(void)
 {
 	u64 start, now;
-	u64 hpet_freq;
 	cycle_t t1;
 
 	/* Start the counter */
@@ -819,24 +785,7 @@ static int hpet_clocksource_register(voi
 		return -ENODEV;
 	}
 
-	/*
-	 * The definition of mult is (include/linux/clocksource.h)
-	 * mult/2^shift = ns/cyc and hpet_period is in units of fsec/cyc
-	 * so we first need to convert hpet_period to ns/cyc units:
-	 *  mult/2^shift = ns/cyc = hpet_period/10^6
-	 *  mult = (hpet_period * 2^shift)/10^6
-	 *  mult = (hpet_period << shift)/FSEC_PER_NSEC
-	 */
-
-	/* Need to convert hpet_period (fsec/cyc) to cyc/sec:
-	 *
-	 * cyc/sec = FSEC_PER_SEC/hpet_period(fsec/cyc)
-	 * cyc/sec = (FSEC_PER_NSEC * NSEC_PER_SEC)/hpet_period
-	 */
-	hpet_freq = FSEC_PER_SEC;
-	do_div(hpet_freq, hpet_period);
 	clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq);
-
 	return 0;
 }
 
@@ -845,7 +794,9 @@ static int hpet_clocksource_register(voi
  */
 int __init hpet_enable(void)
 {
+	unsigned long hpet_period;
 	unsigned int id;
+	u64 freq;
 	int i;
 
 	if (!is_hpet_capable())
@@ -884,6 +835,14 @@ int __init hpet_enable(void)
 		goto out_nohpet;
 
 	/*
+	 * The period is a femto seconds value. Convert it to a
+	 * frequency.
+	 */
+	freq = FSEC_PER_SEC;
+	do_div(freq, hpet_period);
+	hpet_freq = freq;
+
+	/*
 	 * Read the HPET ID register to retrieve the IRQ routing
 	 * information and the number of channels
 	 */


