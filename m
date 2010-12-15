Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0LOB7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:59:02 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39522 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755493Ab0LOB6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:58:51 -0500
Message-Id: <20101215015849.051095242@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.10
Date: Tue, 14 Dec 2010 19:58:42 -0600
From: Robin@sgi.com, "Holt <holt"@sgi.com
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC 2/2] Make x86 calibrate_delay run in parallel.
References: <20101215015840.390204279@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=x86_64_parellelize_jiffy_calibration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
Andi Kleen suggested we rework the calibrate_delay calls to run in
parallel.  With that code in place, a test boot of the same machine took
61 seconds to bring the cups up.  I am not sure how we beat the lpj=
case, but it did outperform.

One thing to note is the total BogoMIPS value is also consistently higher.
I am wondering if this is an effect with the cores being in performance
mode.  I did notice that the parallel calibrate_delay calls did cause the
fans on the machine to ramp up to full speed where the normal sequential
calls did not cause them to budge at all.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>

---

Some before and after logs:

2 socket, 8 cores per socket, no hyperthreads:
Before:
[    0.816215] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.463913] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    2.202919] Brought up 16 CPUs
[    2.206325] Total of 16 processors activated (72523.23 BogoMIPS).
# grep bogomips /proc/cpuinfo 
bogomips	: 4532.81
bogomips	: 4532.65
bogomips	: 4532.64
bogomips	: 4532.64
bogomips	: 4532.65
bogomips	: 4532.64
bogomips	: 4532.64
bogomips	: 4532.64
bogomips	: 4532.72
bogomips	: 4532.74
bogomips	: 4532.72
bogomips	: 4532.73
bogomips	: 4532.74
bogomips	: 4532.74
bogomips	: 4532.74
bogomips	: 4532.73


After:
[    0.747991] UV: Map MMR_HI 0xf7e00000000 - 0xf7e04000000
[    0.753913] UV: Map MMIOH_HI 0xf8000000000 - 0xf8100000000
[    0.760314] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    0.990706] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    1.253240] Brought up 16 CPUs
[    1.315378] Total of 16 processors activated (127783.49 BogoMIPS).
# grep bogomips /proc/cpuinfo 
bogomips	: 4533.49
bogomips	: 7890.05
bogomips	: 9699.67
bogomips	: 10047.13
bogomips	: 8276.11
bogomips	: 8236.85
bogomips	: 10062.50
bogomips	: 11421.44
bogomips	: 7920.28
bogomips	: 7883.65
bogomips	: 9700.00
bogomips	: 9949.31
bogomips	: 6448.05
bogomips	: 6443.88
bogomips	: 4738.22
bogomips	: 4532.79

2 socket, 8 cores per socket, hyperthreaded:
Before:
[    0.538499] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.323403] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    2.221987] Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
[    3.120388] Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31 Ok.
[    4.018423] Brought up 32 CPUs
[    4.021833] Total of 32 processors activated (145083.20 BogoMIPS).
After:
[    0.771327] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.001745] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    1.264354] Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
[    1.528090] Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31 Ok.
[    1.790866] Brought up 32 CPUs
[    1.852380] Total of 32 processors activated (279493.75 BogoMIPS).


2 socket, 6 cores per socket, no hyperthreads:
Before:
[    0.773336] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
[    1.233990] Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 Ok.
[    1.784768] Brought up 12 CPUs
[    1.788170] Total of 12 processors activated (63991.86 BogoMIPS).

After:
[    0.721474] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
[    0.885791] Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 Ok.
[    1.082249] Brought up 12 CPUs
[    1.144426] Total of 12 processors activated (104214.24 BogoMIPS).


256 socket, 8 cores per socket, hyperthreaded:
Before:
[   95.105108] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[   95.768866] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
...
[  410.597682] Booting Node 254, Processors  #4080 #4081 #4082 #4083 #4084 #4085 #4086 #4087 Ok.
[  411.231708] Booting Node 255, Processors  #4088 #4089 #4090 #4091 #4092 #4093 #4094 #4095 Ok.
[  411.859404] Brought up 4096 CPUs
[  411.861354] Total of 4096 processors activated (18569762.97 BogoMIPS).

After:
[   68.491186] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[   68.724012] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
...
[  127.713750] Booting Node 254, Processors  #4080 #4081 #4082 #4083 #4084 #4085 #4086 #4087 Ok.
[  127.842004] Booting Node 255, Processors  #4088 #4089 #4090 #4091 #4092 #4093 #4094 #4095 Ok.
[  127.969171] Brought up 4096 CPUs
[  128.030130] Total of 4096 processors activated (19160610.04 BogoMIPS).

 arch/x86/include/asm/cpumask.h |    1 
 arch/x86/kernel/cpu/common.c   |    2 +
 arch/x86/kernel/smpboot.c      |   33 ++++++++++++++++++++++---------
 3 files changed, 27 insertions(+), 9 deletions(-)

Index: parallelize_calibrate_delay/arch/x86/include/asm/cpumask.h
===================================================================
--- parallelize_calibrate_delay.orig/arch/x86/include/asm/cpumask.h	2010-12-14 18:49:25.414805459 -0600
+++ parallelize_calibrate_delay/arch/x86/include/asm/cpumask.h	2010-12-14 18:50:53.558972740 -0600
@@ -6,6 +6,7 @@
 extern cpumask_var_t cpu_callin_mask;
 extern cpumask_var_t cpu_callout_mask;
 extern cpumask_var_t cpu_initialized_mask;
+extern cpumask_var_t cpu_calibrating_jiffies_mask;
 extern cpumask_var_t cpu_sibling_setup_mask;
 
 extern void setup_cpu_local_masks(void);
Index: parallelize_calibrate_delay/arch/x86/kernel/cpu/common.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/x86/kernel/cpu/common.c	2010-12-14 18:49:25.414805459 -0600
+++ parallelize_calibrate_delay/arch/x86/kernel/cpu/common.c	2010-12-14 18:50:53.575016358 -0600
@@ -45,6 +45,7 @@
 cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_callin_mask;
+cpumask_var_t cpu_calibrating_jiffies_mask;
 
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
@@ -55,6 +56,7 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
 	alloc_bootmem_cpumask_var(&cpu_callout_mask);
+	alloc_bootmem_cpumask_var(&cpu_calibrating_jiffies_mask);
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
Index: parallelize_calibrate_delay/arch/x86/kernel/smpboot.c
===================================================================
--- parallelize_calibrate_delay.orig/arch/x86/kernel/smpboot.c	2010-12-14 18:50:53.439014660 -0600
+++ parallelize_calibrate_delay/arch/x86/kernel/smpboot.c	2010-12-14 18:50:53.623015192 -0600
@@ -52,6 +52,7 @@
 #include <linux/gfp.h>
 
 #include <asm/acpi.h>
+#include <asm/cpumask.h>
 #include <asm/desc.h>
 #include <asm/nmi.h>
 #include <asm/irq.h>
@@ -265,15 +266,7 @@ static void __cpuinit smp_callin(void)
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
 	setup_vector_irq(smp_processor_id());
-	/*
-	 * Get our bogomips.
-	 *
-	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
-	 */
-	local_irq_enable();
-	loops_per_jiffy = calibrate_delay(loops_per_jiffy);
-	local_irq_disable();
+
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
@@ -294,6 +287,8 @@ static void __cpuinit smp_callin(void)
  */
 notrace static void __cpuinit start_secondary(void *unused)
 {
+	struct cpuinfo_x86 *c;
+
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
 	 * fragile that we want to limit the things done here to the
@@ -327,6 +322,12 @@ notrace static void __cpuinit start_seco
 	wmb();
 
 	/*
+	 * Indicate we are still calibrating jiffies.  Do not sum bogomips
+	 * yet.
+	 */
+	cpumask_set_cpu(smp_processor_id(), cpu_calibrating_jiffies_mask);
+
+	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
 	 * IPI recipients, and the time when the determination is made
@@ -349,6 +350,15 @@ notrace static void __cpuinit start_seco
 	/* enable local interrupts */
 	local_irq_enable();
 
+ 	c = &cpu_data(smp_processor_id());
+	/*
+	 * Get our bogomips.
+	 */
+	local_irq_enable();
+	c->loops_per_jiffy = calibrate_delay(loops_per_jiffy);
+	cpumask_clear_cpu(smp_processor_id(), cpu_calibrating_jiffies_mask);
+	smp_mb__after_clear_bit();
+
 	/* to prevent fake stack check failure in clock setup */
 	boot_init_stack_canary();
 
@@ -1190,6 +1200,11 @@ void __init native_smp_prepare_boot_cpu(
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
 {
+	while (cpumask_weight(cpu_calibrating_jiffies_mask)) {
+		cpu_relax();
+		touch_nmi_watchdog();
+	}
+
 	pr_debug("Boot done.\n");
 
 	impress_friends();

