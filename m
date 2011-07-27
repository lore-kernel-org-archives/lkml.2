Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1G0N5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:57:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55058 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1G0N5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:57:32 -0400
Date: Wed, 27 Jul 2011 08:57:31 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Reduce clock calibration time during slave cpu startup
Message-ID: <20110727135730.GA17717@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the startup time for slave cpus.

This patch adds hooks for an arch-specific function for clock calibration.
These hooks are used on x86. They assume all cores in a physical socket
run at the same core speed. If a newly started cpu has the same phys_proc_id
as a core already active, use the already-calculated value of loops_per_jiffy.

This patch reduces the time required to start slave cpus on a 4096 cpu
system from:
	465 sec  OLD
	 62 sec NEW

This reduces boot time on a 4096p system by almost 7 minutes.  Nice...


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
Note: patch assumes that all multi-core x86 processor sockets have the same
clock frequency for all cores. AFAIK, this is true & will continue
to be true for a long time. Have I overlooked anything???

Not sure who takes the patch. It's mostly x86 code but it does affect
generic code.


 arch/x86/kernel/smpboot.c |   31 ++++++++++++++++++++++++++-----
 init/calibrate.c          |   16 ++++++++++++++++
 2 files changed, 42 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2011-07-26 08:01:11.611979781 -0500
+++ linux/arch/x86/kernel/smpboot.c	2011-07-27 08:38:04.832002562 -0500
@@ -207,23 +207,29 @@ static void __cpuinit smp_callin(void)
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
 	setup_vector_irq(smp_processor_id());
+
+	/*
+	 * Save our processor parameters. Note: this information
+	 * is needed for clock calibration.
+	 */
+	smp_store_cpu_info(cpuid);
+
 	/*
 	 * Get our bogomips.
+	 * Update loops_per_jiffy in cpu_data. Previous call to
+	 * smp_store_cpu_info() stored a value that is close but not as
+	 * accurate as the value just calculated.
 	 *
 	 * Need to enable IRQs because it can take longer and then
 	 * the NMI watchdog might kill us.
 	 */
 	local_irq_enable();
 	calibrate_delay();
+	cpu_data(cpuid).loops_per_jiffy = loops_per_jiffy;
 	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
-	 * Save our processor parameters
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
@@ -239,6 +245,21 @@ static void __cpuinit smp_callin(void)
 }
 
 /*
+ * Check if another cpu is in the same socket and has already been calibrated.
+ * If found, use the previous value. This assumes all cores in the same physical
+ * socket have the same core frequency.
+ */
+unsigned long __cpuinit calibrate_delay_is_known(void)
+{
+	int i, cpu = smp_processor_id();
+
+	for_each_online_cpu(i)
+		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
+			return cpu_data(i).loops_per_jiffy;
+	return 0;
+}
+
+/*
  * Activate a secondary processor.
  */
 notrace static void __cpuinit start_secondary(void *unused)
Index: linux/init/calibrate.c
===================================================================
--- linux.orig/init/calibrate.c	2011-07-26 08:01:15.571979739 -0500
+++ linux/init/calibrate.c	2011-07-27 08:39:35.691983745 -0500
@@ -243,6 +243,20 @@ recalibrate:
 	return lpj;
 }
 
+/*
+ * Check if cpu calibration delay is already known. For example,
+ * some processors with multi-core sockets may have all sockets
+ * use the same core frequency. It is not necessary to calibrate
+ * each core.
+ *
+ * Architectures should override this function if a faster calibration
+ * method is available.
+ */
+unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
+{
+	return 0;
+}
+
 void __cpuinit calibrate_delay(void)
 {
 	unsigned long lpj;
@@ -257,6 +271,8 @@ void __cpuinit calibrate_delay(void)
 		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
+	} else if ((lpj = calibrate_delay_is_known())) {
+		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
