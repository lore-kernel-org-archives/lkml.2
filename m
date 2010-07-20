Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0GTEVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:21:21 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:46434 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab0GTEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:21:19 -0400
Subject: Re: [PATCH] add a arch specific delay calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
In-Reply-To: <1279586465.1339.21.camel@ank32.eng.vmware.com>
References: <1279586465.1339.21.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 19 Jul 2010 21:21:19 -0700
Message-Id: <1279599679.18204.17.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 17:41 -0700, Alok Kataria wrote:
> Hi, 
> 
> This patch adds a hook for architectures to specify their own delay calibration
> routine. VMware platform uses it to calculate the lpj value from the tsc_khz &
> HZ value for all the processors.
> 
> Please note that this is a partial revert of -
> 	commit 3da757daf86e498872855f0b5e101f763ba79499
> 	x86: use cpu_khz for loops_per_jiffy calculation
> 
> where I added the lpj_fine variable to generic code, so that we can do this
> lpj calibration trick just for the BP. It was considered wrong to apply this
> trick for the AP's since on physical systems we can have cases where the AP
> is brought up at a lower freq than the maximum possible for power reasons.
> On VMware's platform we have VCPU's always running at the same
> clockspeed as the TSC frequency so we can extend this for all cpus.
> 
> Please note that, though the original approach of doing this for just the BP
> was safe to get around the "IO-APIC + timer doesn't work" on VMware, we still
> need the AP's to have the correct lpj values for the timeouts to work correctly
> on our platform for all vcpus.
> 
> Please consider this for the x86 tree, applies on the tip.

I assumed that this lpj_fine thing was relevant only for VMware, but
this might be useful for native or other virtualized platforms too. So
as not to regress from the existing behavior, I have reworked this patch
so that we use this hook for x86 platform too. And when on VMware we
replace it with the VMware specific routine.

Please take a look and consider this patch instead of the first one.

Thanks,
Alok

--

We use the lpj_fine value to setup loops_per_jiffy just for the BP,
since on physical systems we can have cases where the AP is brought up
at a lower frequency than the maximum possible, for power reasons.
Though, on VMware's platform we have all the VCPU's always running at
the same clockspeed as the TSC frequency, so we can use the lpj_fine
value for all cpus.

This patch adds a hook for architectures to specify their own delay
calibration routine, x86 defines this by returning the lpj_fine value
for BP and zero for all others. When on VMware we override this with our
routine which always returns lpj_fine irrespective of which CPU you
running on.

Patch applies on x86-tip tree.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2010-07-19 19:57:36.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2010-07-19 20:34:36.000000000 -0700
@@ -23,6 +23,7 @@
 
 #include <linux/dmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
@@ -65,15 +66,27 @@ static unsigned long vmware_get_tsc_khz(
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
--- linux-x86-tree.git.orig/include/linux/delay.h	2010-07-19 19:57:36.000000000 -0700
+++ linux-x86-tree.git/include/linux/delay.h	2010-07-19 19:58:48.000000000 -0700
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
--- linux-x86-tree.git.orig/init/calibrate.c	2010-07-19 19:57:36.000000000 -0700
+++ linux-x86-tree.git/init/calibrate.c	2010-07-19 20:25:36.000000000 -0700
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
@@ -112,16 +113,12 @@ static unsigned long __cpuinit calibrate
  * This is the number of bits of precision for the loops_per_jiffy.  Each
  * bit takes on average 1.5/HZ seconds.  This (like the original) is a little
  * better than 1%
- * For the boot cpu we can skip the delay calibration and assign it a value
- * calculated based on the timer frequency.
- * For the rest of the CPUs we cannot assume that the timer frequency is same as
- * the cpu frequency, hence do the calibration for those.
  */
 #define LPS_PREC 8
 
 void __cpuinit calibrate_delay(void)
 {
-	unsigned long ticks, loopbit;
+	unsigned long ticks, loopbit, lpj;
 	int lps_precision = LPS_PREC;
 	static bool printed;
 
@@ -130,10 +127,11 @@ void __cpuinit calibrate_delay(void)
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
-	} else if ((!printed) && lpj_fine) {
-		loops_per_jiffy = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+	} else if (arch_calibrate_delay && (lpj = arch_calibrate_delay())) {
+		loops_per_jiffy = lpj;
+		if (!printed)
+			pr_info("Calibrating delay using arch specific "
+				"calibration routine.. ");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
Index: linux-x86-tree.git/arch/x86/include/asm/tsc.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/tsc.h	2010-07-19 16:37:33.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/tsc.h	2010-07-19 19:58:48.000000000 -0700
@@ -16,6 +16,7 @@ typedef unsigned long long cycles_t;
 
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
+extern unsigned long lpj_fine;
 
 extern void disable_TSC(void);
 
Index: linux-x86-tree.git/arch/x86/kernel/tsc.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/tsc.c	2010-07-19 19:57:36.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/tsc.c	2010-07-19 21:16:05.000000000 -0700
@@ -26,6 +26,8 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int __read_mostly tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
+unsigned long __read_mostly lpj_fine;
+
 /*
  * TSC can be unstable due to cpufreq or due to unsynced TSCs
  */
@@ -911,6 +913,20 @@ static unsigned long __init calibrate_cp
 static inline unsigned long calibrate_cpu(void) { return cpu_khz; }
 #endif
 
+/*
+ * For the boot cpu we can skip the delay calibration and assign it a value
+ * calculated based on the timer frequency.
+ * For the rest of the CPUs we cannot assume that the timer frequency is same as
+ * the cpu frequency, hence do the calibration for those.
+ */
+unsigned long x86_calibrate_delay(void)
+{
+	if (!smp_processor_id())
+		return lpj_fine;
+	else
+		return 0;
+}
+
 void __init tsc_init(void)
 {
 	u64 lpj;
@@ -955,6 +971,8 @@ void __init tsc_init(void)
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
+	if (!arch_calibrate_delay)
+		arch_calibrate_delay = x86_calibrate_delay;
 
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */


