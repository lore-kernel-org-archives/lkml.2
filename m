Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967212Ab0GTAlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:41:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40335 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab0GTAlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:41:05 -0400
Subject: [PATCH] add a arch specific delay calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 19 Jul 2010 17:41:05 -0700
Message-Id: <1279586465.1339.21.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This patch adds a hook for architectures to specify their own delay calibration
routine. VMware platform uses it to calculate the lpj value from the tsc_khz &
HZ value for all the processors.

Please note that this is a partial revert of -
	commit 3da757daf86e498872855f0b5e101f763ba79499
	x86: use cpu_khz for loops_per_jiffy calculation

where I added the lpj_fine variable to generic code, so that we can do this
lpj calibration trick just for the BP. It was considered wrong to apply this
trick for the AP's since on physical systems we can have cases where the AP
is brought up at a lower freq than the maximum possible for power reasons.
On VMware's platform we have VCPU's always running at the same
clockspeed as the TSC frequency so we can extend this for all cpus.

Please note that, though the original approach of doing this for just the BP
was safe to get around the "IO-APIC + timer doesn't work" on VMware, we still
need the AP's to have the correct lpj values for the timeouts to work correctly
on our platform for all vcpus.

Please consider this for the x86 tree, applies on the tip.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2010-07-08 13:53:33.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2010-07-19 16:47:53.000000000 -0700
@@ -23,6 +23,7 @@
 
 #include <linux/dmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
@@ -42,6 +43,8 @@
 			"2"(VMWARE_HYPERVISOR_PORT), "3"(UINT_MAX) :	\
 			"memory");
 
+static unsigned long lpj_fine;
+
 static inline int __vmware_platform(void)
 {
 	uint32_t eax, ebx, ecx, edx;
@@ -51,7 +54,7 @@ static inline int __vmware_platform(void
 
 static unsigned long vmware_get_tsc_khz(void)
 {
-	uint64_t tsc_hz;
+	uint64_t tsc_hz, lpj;
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
@@ -62,18 +65,35 @@ static unsigned long vmware_get_tsc_khz(
 	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
 			 (unsigned long) tsc_hz / 1000,
 			 (unsigned long) tsc_hz % 1000);
+
+	lpj = ((u64)tsc_hz * 1000);
+	do_div(lpj, HZ);
+	lpj_fine = lpj;
+
 	return tsc_hz;
 }
 
+/*
+ * We can skip the delay calibration and assign it a value calculated based on
+ * the timer frequency. On VMware's platform all the cpu's run at the same
+ * frequency as the timer frequency, so use this value for all the processors.
+ */
+static unsigned long vmware_calibrate_delay(void)
+{
+	BUG_ON(!lpj_fine);
+	return lpj_fine;
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
+		arch_calibrate_delay = vmware_calibrate_delay;
+	} else
 		printk(KERN_WARNING
 		       "Failed to get TSC freq from the hypervisor\n");
 }
Index: linux-x86-tree.git/include/linux/delay.h
===================================================================
--- linux-x86-tree.git.orig/include/linux/delay.h	2008-06-26 15:29:48.000000000 -0700
+++ linux-x86-tree.git/include/linux/delay.h	2010-07-19 16:31:21.000000000 -0700
@@ -41,7 +41,7 @@ static inline void ndelay(unsigned long 
 #define ndelay(x) ndelay(x)
 #endif
 
-extern unsigned long lpj_fine;
+extern unsigned long (*arch_calibrate_delay)(void);
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
Index: linux-x86-tree.git/init/calibrate.c
===================================================================
--- linux-x86-tree.git.orig/init/calibrate.c	2010-02-07 16:38:44.000000000 -0800
+++ linux-x86-tree.git/init/calibrate.c	2010-07-19 17:00:04.000000000 -0700
@@ -10,8 +10,9 @@
 #include <linux/timex.h>
 #include <linux/smp.h>
 
-unsigned long lpj_fine;
 unsigned long preset_lpj;
+unsigned long (*arch_calibrate_delay)(void);
+
 static int __init lpj_setup(char *str)
 {
 	preset_lpj = simple_strtoul(str,NULL,0);
@@ -130,10 +131,11 @@ void __cpuinit calibrate_delay(void)
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
-	} else if ((!printed) && lpj_fine) {
-		loops_per_jiffy = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+	} else if (arch_calibrate_delay) {
+		loops_per_jiffy = arch_calibrate_delay();
+		if (!printed)
+			pr_info("Calibrating delay using platform "
+				"specific routine.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
Index: linux-x86-tree.git/arch/x86/kernel/tsc.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/tsc.c	2010-07-19 16:30:35.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/tsc.c	2010-07-19 16:46:51.000000000 -0700
@@ -913,7 +913,6 @@ static inline unsigned long calibrate_cp
 
 void __init tsc_init(void)
 {
-	u64 lpj;
 	int cpu;
 
 	x86_init.timers.tsc_pre_init();
@@ -952,10 +951,6 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
-	lpj = ((u64)tsc_khz * 1000);
-	do_div(lpj, HZ);
-	lpj_fine = lpj;
-
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);


