Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1BPGfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:30 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43447 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1BPGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:01 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, jacob.jun.pan@intel.com,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6] x86: Convert untested clocksources to clocksource_register_hz/khz
Date: Tue, 15 Feb 2011 22:34:47 -0800
Message-Id: <1297838092-22989-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the remaining x86 clocksources to use
clocksource_register_hz/khz. I was not able to test them, so
any extra assistance to make sure time functions properly with
the clocksources changeed here would be appreciated!

CC: jacob.jun.pan@intel.com
CC: Glauber Costa <glommer@redhat.com>
CC: Dimitri Sivanich <sivanich@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Chris McDermott <lcm@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/x86/kernel/apb_timer.c    |   10 +---------
 arch/x86/kernel/i8253.c        |    6 +-----
 arch/x86/kernel/kvmclock.c     |    6 +-----
 arch/x86/lguest/boot.c         |    4 +---
 arch/x86/platform/uv/uv_time.c |    6 +-----
 arch/x86/xen/time.c            |    6 +-----
 drivers/clocksource/cyclone.c  |   10 ++--------
 7 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 51ef31a..29ebf5a 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -177,7 +177,6 @@ static struct clocksource clocksource_apbt = {
 	.rating		= APBT_CLOCKSOURCE_RATING,
 	.read		= apbt_read_clocksource,
 	.mask		= APBT_MASK,
-	.shift		= APBT_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= apbt_restart_clocksource,
 };
@@ -595,14 +594,7 @@ static int apbt_clocksource_register(void)
 	if (t1 == apbt_read_clocksource(&clocksource_apbt))
 		panic("APBT counter not counting. APBT disabled\n");
 
-	/*
-	 * initialize and register APBT clocksource
-	 * convert that to ns/clock cycle
-	 * mult = (ns/c) * 2^APBT_SHIFT
-	 */
-	clocksource_apbt.mult = div_sc(MSEC_PER_SEC,
-				       (unsigned long) apbt_freq, APBT_SHIFT);
-	clocksource_register(&clocksource_apbt);
+	clocksource_register_khz(&clocksource_apbt, (u32)apbt_freq*1000);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 2dfd315..212fe65 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -188,8 +188,6 @@ static struct clocksource pit_cs = {
 	.rating		= 110,
 	.read		= pit_read,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.mult		= 0,
-	.shift		= 20,
 };
 
 static int __init init_pit_clocksource(void)
@@ -205,9 +203,7 @@ static int __init init_pit_clocksource(void)
 	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
-
-	return clocksource_register(&pit_cs);
+	return clocksource_register_hz(&pit_cs, CLOCK_TICK_RATE);
 }
 arch_initcall(init_pit_clocksource);
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f98d3ea..6389a6b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -26,8 +26,6 @@
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
 
-#define KVM_SCALE 22
-
 static int kvmclock = 1;
 static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
 static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
@@ -120,8 +118,6 @@ static struct clocksource kvm_clock = {
 	.read = kvm_clock_get_cycles,
 	.rating = 400,
 	.mask = CLOCKSOURCE_MASK(64),
-	.mult = 1 << KVM_SCALE,
-	.shift = KVM_SCALE,
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -203,7 +199,7 @@ void __init kvmclock_init(void)
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
 	kvm_get_preset_lpj();
-	clocksource_register(&kvm_clock);
+	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.paravirt_enabled = 1;
 	pv_info.name = "KVM";
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index eba687f0..5b96fd9 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -913,8 +913,6 @@ static struct clocksource lguest_clock = {
 	.rating		= 200,
 	.read		= lguest_clock_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1 << 22,
-	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -997,7 +995,7 @@ static void lguest_time_init(void)
 	/* Set up the timer interrupt (0) to go to our simple timer routine */
 	set_irq_handler(0, lguest_time_irq);
 
-	clocksource_register(&lguest_clock);
+	clocksource_register_hz(&lguest_clock, NSEC_PER_SEC);
 
 	/* We can't set cpumask in the initializer: damn C limitations!  Set it
 	 * here and register our timer device. */
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 9daf5d1..0eb9018 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -40,7 +40,6 @@ static struct clocksource clocksource_uv = {
 	.rating		= 400,
 	.read		= uv_read_rtc,
 	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
-	.shift		= 10,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -372,14 +371,11 @@ static __init int uv_rtc_setup_clock(void)
 	if (!is_uv_system())
 		return -ENODEV;
 
-	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
-				clocksource_uv.shift);
-
 	/* If single blade, prefer tsc */
 	if (uv_num_possible_blades() == 1)
 		clocksource_uv.rating = 250;
 
-	rc = clocksource_register(&clocksource_uv);
+	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
 	else
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 067759e..04e1159 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -26,8 +26,6 @@
 
 #include "xen-ops.h"
 
-#define XEN_SHIFT 22
-
 /* Xen may fire a timer up to this many ns early */
 #define TIMER_SLOP	100000
 #define NS_PER_TICK	(1000000000LL / HZ)
@@ -211,8 +209,6 @@ static struct clocksource xen_clocksource __read_mostly = {
 	.rating = 400,
 	.read = xen_clocksource_get_cycles,
 	.mask = ~0,
-	.mult = 1<<XEN_SHIFT,		/* time directly in nanoseconds */
-	.shift = XEN_SHIFT,
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -446,7 +442,7 @@ static __init void xen_time_init(void)
 	int cpu = smp_processor_id();
 	struct timespec tp;
 
-	clocksource_register(&xen_clocksource);
+	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
 		/* Successfully turned off 100Hz tick, so we have the
diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
index 64e528e..72f811f 100644
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -29,8 +29,6 @@ static struct clocksource clocksource_cyclone = {
 	.rating		= 250,
 	.read		= read_cyclone,
 	.mask		= CYCLONE_TIMER_MASK,
-	.mult		= 10,
-	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -108,12 +106,8 @@ static int __init init_cyclone_clocksource(void)
 	}
 	cyclone_ptr = cyclone_timer;
 
-	/* sort out mult/shift values: */
-	clocksource_cyclone.shift = 22;
-	clocksource_cyclone.mult = clocksource_hz2mult(CYCLONE_TIMER_FREQ,
-						clocksource_cyclone.shift);
-
-	return clocksource_register(&clocksource_cyclone);
+	return clocksource_register_hz(&clocksource_cyclone,
+					CYCLONE_TIMER_FREQ);
 }
 
 arch_initcall(init_cyclone_clocksource);
-- 
1.7.3.2.146.gca209

