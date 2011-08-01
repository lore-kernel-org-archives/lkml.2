Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1HASpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:45:49 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60062 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab1HASpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:45:45 -0400
Date: Mon, 1 Aug 2011 13:45:42 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: davej@redhat.com, yinghan@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
	startup
Message-ID: <20110801184542.GA3939@sgi.com>
References: <20110727135730.GA17717@sgi.com> <20110727140523.GA24206@redhat.com> <20110727141527.GA8453@sgi.com> <20110727155200.GA25381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727155200.GA25381@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reduce the startup time for slave cpus.

This patch adds hooks for an arch-specific function for clock calibration.
These hooks are used on x86. If a newly started cpu has the same phys_proc_id
as a core already active, use the already-calculated value of loops_per_jiffy.

The new code is used only on processor sockets that use the TSC for
delay loops and have X86_FEATURE_CONSTANT_TSC.


This patch reduces the time required to start slave cpus on a 4096 cpu system
from:
	465 sec  OLD
	 62 sec NEW

This reduces boot time on a 4096p system by almost 7 minutes.  Nice...


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
V2 - remove assumption that all cores in a socket have the same core frequency.
     the patch is enabled only if delay() uses the TSC & socket is CONSTANT_TSC.

Also see https://lkml.org/lkml/2010/12/14/511 for a previous discussion
for similar improvement. This patch gives almost equivalent performance
and is less intrusive.


 arch/x86/kernel/smpboot.c |   16 +++++++++++-----
 arch/x86/kernel/tsc.c     |   18 ++++++++++++++++++
 init/calibrate.c          |   16 ++++++++++++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2011-07-26 08:01:11.611979781 -0500
+++ linux/arch/x86/kernel/smpboot.c	2011-08-01 13:25:42.544605719 -0500
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
--- linux.orig/arch/x86/kernel/tsc.c	2011-08-01 12:45:06.000000000 -0500
+++ linux/arch/x86/kernel/tsc.c	2011-08-01 13:26:20.244043188 -0500
@@ -995,3 +995,21 @@ void __init tsc_init(void)
 	check_system_tsc_reliable();
 }
 
+/*
+ * Check if another cpu is in the same socket and has already been calibrated.
+ * If found, use the previous value. This assumes all cores in the same physical
+ * socket have the same core frequency.
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
