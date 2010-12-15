Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0LOB6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:58:52 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39516 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755384Ab0LOB6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:58:50 -0500
Message-Id: <20101215015848.904300574@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.10
Date: Tue, 14 Dec 2010 19:58:41 -0600
From: Robin@sgi.com, "Holt <holt"@sgi.com
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC 1/2] Pass loops_per_jiffy in and out of calibrate_delay().
References: <20101215015840.390204279@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=pass_loops_per_jiffy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In order for x86_64 to do the per_cpu loops_per_jiffy calibration in
parallel, we need to make calibrate_delay() no longer depend upon and
modify the global value.


Signed-off-by: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>

---

 arch/alpha/kernel/smp.c         |    2 +-
 arch/arm/kernel/smp.c           |    2 +-
 arch/arm/mach-omap2/clock.c     |    2 +-
 arch/blackfin/mach-common/smp.c |    2 +-
 arch/ia64/kernel/smpboot.c      |    2 +-
 arch/m32r/kernel/smpboot.c      |    2 +-
 arch/mips/kernel/smp.c          |    2 +-
 arch/mn10300/kernel/smp.c       |    3 ++-
 arch/sh/kernel/smp.c            |    2 +-
 arch/sparc/kernel/leon_smp.c    |    2 +-
 arch/sparc/kernel/sun4d_smp.c   |    2 +-
 arch/sparc/kernel/sun4m_smp.c   |    2 +-
 arch/x86/kernel/cpu/cyrix.c     |    2 +-
 arch/x86/kernel/smpboot.c       |    2 +-
 include/linux/delay.h           |    2 +-
 init/calibrate.c                |    7 ++++---
 init/main.c                     |    2 +-
 17 files changed, 21 insertions(+), 19 deletions(-)

Index: parallelize_calibrate_delay/arch/alpha/kernel/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/alpha/kernel/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/alpha/kernel/smp.c	2010-12-14 19:03:15.714271892 -0600
@@ -156,7 +156,7 @@ smp_callin(void)
 	   calibrate_delay. */
 	wait_boot_cpu_to_stop(cpuid);
 	mb();
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 
 	smp_store_cpu_info(cpuid);
 	/* Allow master to continue only after we written loops_per_jiffy.  */
Index: parallelize_calibrate_delay/arch/arm/kernel/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/arm/kernel/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/arm/kernel/smp.c	2010-12-14 19:03:15.742253845 -0600
@@ -338,7 +338,7 @@ asmlinkage void __cpuinit secondary_star
 	 */
 	percpu_timer_setup();
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 
 	smp_store_cpu_info(cpu);
 
Index: parallelize_calibrate_delay/arch/arm/mach-omap2/clock.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/arm/mach-omap2/clock.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/arm/mach-omap2/clock.c	2010-12-14 19:03:15.758258926 -0600
@@ -441,7 +441,7 @@ int __init omap2_clk_switch_mpurate_at_b
 		return -EINVAL;
 	}
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	recalculate_root_clocks();
 
 	clk_put(mpurate_ck);
Index: parallelize_calibrate_delay/arch/blackfin/mach-common/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/blackfin/mach-common/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/blackfin/mach-common/smp.c	2010-12-14 19:03:15.802314977 -0600
@@ -433,7 +433,7 @@ void __cpuinit secondary_start_kernel(vo
 	 * IRQs need to be enabled here - D-cache can be invalidated
 	 * in timer irq handler, so core B can read correct jiffies.
 	 */
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 
 	cpu_idle();
 }
Index: parallelize_calibrate_delay/arch/ia64/kernel/smpboot.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/ia64/kernel/smpboot.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/ia64/kernel/smpboot.c	2010-12-14 19:03:15.850311884 -0600
@@ -445,7 +445,7 @@ smp_callin (void)
 	    last_cpuinfo->family != this_cpuinfo->family ||
 	    last_cpuinfo->archrev != this_cpuinfo->archrev ||
 	    last_cpuinfo->model != this_cpuinfo->model)
-		calibrate_delay();
+		loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	local_cpu_data->loops_per_jiffy = loops_per_jiffy;
 
 	/*
Index: parallelize_calibrate_delay/arch/m32r/kernel/smpboot.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/m32r/kernel/smpboot.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/m32r/kernel/smpboot.c	2010-12-14 19:03:15.890375853 -0600
@@ -498,7 +498,7 @@ static void __init smp_online(void)
 	local_irq_enable();
 
 	/* Get our bogomips. */
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 
 	/* Save our processor parameters */
  	smp_store_cpu_info(cpu_id);
Index: parallelize_calibrate_delay/arch/mips/kernel/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/mips/kernel/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/mips/kernel/smp.c	2010-12-14 19:03:15.942375401 -0600
@@ -115,7 +115,7 @@ asmlinkage __cpuinit void start_secondar
 	 * to an option instead of something based on .cputype
 	 */
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	preempt_disable();
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
Index: parallelize_calibrate_delay/arch/mn10300/kernel/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/mn10300/kernel/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/mn10300/kernel/smp.c	2010-12-14 19:03:16.010251766 -0600
@@ -827,7 +827,8 @@ static void __init smp_callin(void)
 	}
 
 #ifdef CONFIG_CALIBRATE_DELAY
-	calibrate_delay();		/* Get our bogomips */
+	/* Get our bogomips */
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 #endif
 
 	/* Save our processor parameters */
Index: parallelize_calibrate_delay/arch/sh/kernel/smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/sh/kernel/smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/sh/kernel/smp.c	2010-12-14 19:03:16.062800992 -0600
@@ -200,7 +200,7 @@ asmlinkage void __cpuinit start_secondar
 
 	/* Enable local timers */
 	local_timer_setup(cpu);
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 
 	smp_store_cpu_info(cpu);
 
Index: parallelize_calibrate_delay/arch/sparc/kernel/leon_smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/sparc/kernel/leon_smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/sparc/kernel/leon_smp.c	2010-12-14 19:03:16.122794054 -0600
@@ -74,7 +74,7 @@ void __cpuinit leon_callin(void)
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	smp_store_cpu_info(cpuid);
 
 	local_flush_cache_all();
Index: parallelize_calibrate_delay/arch/sparc/kernel/sun4d_smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/sparc/kernel/sun4d_smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/sparc/kernel/sun4d_smp.c	2010-12-14 19:03:16.226765981 -0600
@@ -109,7 +109,7 @@ void __cpuinit smp4d_callin(void)
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	smp_store_cpu_info(cpuid);
 	local_flush_cache_all();
 	local_flush_tlb_all();
Index: parallelize_calibrate_delay/arch/sparc/kernel/sun4m_smp.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/sparc/kernel/sun4m_smp.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/sparc/kernel/sun4m_smp.c	2010-12-14 19:03:16.270721019 -0600
@@ -78,7 +78,7 @@ void __cpuinit smp4m_callin(void)
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	smp_store_cpu_info(cpuid);
 
 	local_flush_cache_all();
Index: parallelize_calibrate_delay/arch/x86/kernel/cpu/cyrix.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/x86/kernel/cpu/cyrix.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/x86/kernel/cpu/cyrix.c	2010-12-14 19:03:16.350756091 -0600
@@ -105,7 +105,7 @@ static void __cpuinit check_cx686_slop(s
 
 		if (ccr5 & 2) { /* possible wrong calibration done */
 			printk(KERN_INFO "Recalibrating delay loop with SLOP bit reset\n");
-			calibrate_delay();
+			loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 			c->loops_per_jiffy = loops_per_jiffy;
 		}
 	}
Index: parallelize_calibrate_delay/arch/x86/kernel/smpboot.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/x86/kernel/smpboot.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/arch/x86/kernel/smpboot.c	2010-12-14 19:03:16.378379088 -0600
@@ -272,7 +272,7 @@ static void __cpuinit smp_callin(void)
 	 * the NMI watchdog might kill us.
 	 */
 	local_irq_enable();
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
Index: parallelize_calibrate_delay/include/linux/delay.h
===================================================================
--- parallelize_calibrate_delay.orig/include/linux/delay.h	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/include/linux/delay.h	2010-12-14 19:03:16.430247301 -0600
@@ -42,7 +42,7 @@ static inline void ndelay(unsigned long
 #endif
 
 extern unsigned long lpj_fine;
-void calibrate_delay(void);
+unsigned long calibrate_delay(unsigned long);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
 void usleep_range(unsigned long min, unsigned long max);
Index: parallelize_calibrate_delay/init/calibrate.c
===================================================================
--- parallelize_calibrate_delay.orig/init/calibrate.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/init/calibrate.c	2010-12-14 19:20:53.582472607 -0600
@@ -119,11 +119,12 @@ static unsigned long __cpuinit calibrate
  */
 #define LPS_PREC 8
 
-void __cpuinit calibrate_delay(void)
+unsigned long __cpuinit calibrate_delay(unsigned long loops_per_jiffy)
 {
 	unsigned long ticks, loopbit;
 	int lps_precision = LPS_PREC;
-	static bool printed;
+	static atomic_t n_called = ATOMIC_INIT(0);
+	bool printed = atomic_inc_return(&n_called) != 1;
 
 	if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
@@ -178,5 +179,5 @@ void __cpuinit calibrate_delay(void)
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 
-	printed = true;
+	return loops_per_jiffy;
 }
Index: parallelize_calibrate_delay/init/main.c
===================================================================
--- parallelize_calibrate_delay.orig/init/main.c	2010-12-14 19:03:15.578220745 -0600
+++ parallelize_calibrate_delay/init/main.c	2010-12-14 19:03:16.570396588 -0600
@@ -664,7 +664,7 @@ asmlinkage void __init start_kernel(void
 	if (late_time_init)
 		late_time_init();
 	sched_clock_init();
-	calibrate_delay();
+	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
 	pidmap_init();
 	anon_vma_init();
 #ifdef CONFIG_X86

