Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab1IORjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:39:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35717 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934211Ab1IORjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:39:17 -0400
Date: Thu, 15 Sep 2011 12:39:15 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH, resend] x66 - Reduce clock calibration time during slave
	cpu startup
Message-ID: <20110915173915.GA13657@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reduce the startup time for slave cpus.

This patch adds hooks for an arch-specific function for clock calibration.

These hooks are used on x86. If a newly started cpu has the same phys_proc_id
as a core already active, uses the TSC for the delay loop and has a CONSTANT_TSC,
use the already-calculated value of loops_per_jiffy.

This patch reduces the time required to start slave cpus on a 4096 cpu system
from:
	465 sec  OLD
	 62 sec NEW

This reduces boot time on a 4096p system by almost 7 minutes.  Nice...


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
V2 - remove assumption that all cores in a socket have the same core frequency.
     the patch is enabled only if delay() uses the TSC & socket is CONSTANT_TSC.

V3 - Update comments & patch description. No code changes.

Resend - no feedback from last posting. Not sure if this is acceptible or what needs
to be done next. Pointers appreciated.



Also see https://lkml.org/lkml/2010/12/14/511 for a previous discussion
for similar improvement. This patch gives almost equivalent performance
and is less intrusive.


 arch/x86/kernel/smpboot.c |   16 +++++++++++-----
 arch/x86/kernel/tsc.c     |   19 +++++++++++++++++++
 init/calibrate.c          |   15 +++++++++++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2011-08-05 08:24:19.492148934 -0500
+++ linux/arch/x86/kernel/smpboot.c	2011-08-08 15:21:47.919979997 -0500
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
Index: linux/arch/x86/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc.c	2011-08-05 08:24:19.492148934 -0500
+++ linux/arch/x86/kernel/tsc.c	2011-08-08 15:31:43.236111159 -0500
@@ -995,3 +995,22 @@ void __init tsc_init(void)
 	check_system_tsc_reliable();
 }
 
+/*
+ * If we have a constant TSC and are using the TSC for the delay loop,
+ * we can skip clock calibration if another cpu in the same socket has already
+ * been calibrated. This assumes that CONSTANT_TSC applies to all
+ * cpus in the socket - this should be a safe assumption.
+ */
+unsigned long __cpuinit calibrate_delay_is_known(void)
+{
+	int i, cpu = smp_processor_id();
+
+	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
+		return 0;
+
+	for_each_online_cpu(i)
+		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
+			return cpu_data(i).loops_per_jiffy;
+	return 0;
+}
+
Index: linux/init/calibrate.c
===================================================================
--- linux.orig/init/calibrate.c	2011-08-05 08:24:19.492148934 -0500
+++ linux/init/calibrate.c	2011-08-08 15:33:17.003985763 -0500
@@ -246,6 +246,19 @@ recalibrate:
 
 static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
+/*
+ * Check if cpu calibration delay is already known. For example,
+ * some processors with multi-core sockets may have all cores
+ * with the same calibration delay.
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
@@ -265,6 +278,8 @@ void __cpuinit calibrate_delay(void)
 		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
+	} else if ((lpj = calibrate_delay_is_known())) {
+		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
