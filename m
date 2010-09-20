Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0ITX76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:59:58 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:11510 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab0ITX75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:59:57 -0400
Subject: Re: [PATCH] x86,apic: V2 Add apic calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1285025650.9954.43.camel@ank32.eng.vmware.com>
References: <1285017425.9954.10.camel@ank32.eng.vmware.com>
	 <alpine.LFD.2.00.1009202343440.2416@localhost6.localdomain6>
	 <1285025650.9954.43.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 20 Sep 2010 16:59:56 -0700
Message-Id: <1285027196.9954.45.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2010-09-20 at 16:34 -0700, Alok Kataria wrote:

> Below is the preparatory change, will followup with the 2nd patch which
> introduces the actual hook.

Below is the 2nd patch.
--
Add apic timer calibration hook.

From: Alok N Kataria <akataria@vmware.com>

Add a new function ptr calibrate_apic_clock to x86_init_timers structure.
On native this does the usual apic calibration. On VMware's platform we
override it with a routine which gets that information from the hypervisor.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/include/asm/apic.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/apic.h	2010-09-20 16:05:58.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/apic.h	2010-09-20 16:36:42.000000000 -0700
@@ -17,6 +17,10 @@
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
+/* Clock divisor */
+#define APIC_DIVISOR	16
+#define LAPIC_CAL_LOOPS	(HZ/10)
+
 /*
  * Debugging macros
  */
@@ -238,6 +242,8 @@ extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern void enable_NMI_through_LVT0(void);
+extern int native_calibrate_apic_clock(void);
+extern int initialize_lapic_timer(long delta, unsigned int calibration_result);
 
 /*
  * On 32bit this is mach-xxx local
Index: linux-x86-tree.git/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-x86-tree.git.orig/arch/x86/include/asm/x86_init.h	2010-09-20 16:06:11.000000000 -0700
+++ linux-x86-tree.git/arch/x86/include/asm/x86_init.h	2010-09-20 16:54:08.000000000 -0700
@@ -83,11 +83,13 @@ struct x86_init_paging {
  *				boot cpu
  * @tsc_pre_init:		platform function called before TSC init
  * @timer_init:			initialize the platform timer (default PIT/HPET)
+ * @calibrate_apic_clock:	calibrate APIC clock freq (ticks per HZ)
  */
 struct x86_init_timers {
 	void (*setup_percpu_clockev)(void);
 	void (*tsc_pre_init)(void);
 	void (*timer_init)(void);
+	int (*calibrate_apic_clock)(void);
 };
 
 /**
Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2010-09-20 16:05:30.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2010-09-20 16:40:35.000000000 -0700
@@ -26,6 +26,7 @@
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
+#include <asm/apic.h>
 
 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
@@ -72,17 +73,40 @@ static unsigned long vmware_get_tsc_khz(
 	return tsc_hz;
 }
 
+static int __init vmware_calibrate_apic_clock(void)
+{
+	unsigned int calibration_result;
+	uint32_t eax, ebx, ecx, edx;
+	int err;
+	long delta;
+	unsigned long flags;
+
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+	BUG_ON(!ecx);
+	calibration_result = ecx / HZ;
+
+	printk(KERN_INFO "APIC bus freq read from hypervisor\n");
+
+	delta  = (calibration_result * LAPIC_CAL_LOOPS) / APIC_DIVISOR;
+	local_irq_save(flags);
+	err = initialize_lapic_timer(delta, calibration_result);
+	local_irq_restore(flags);
+
+	return err;
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
+		x86_init.timers.calibrate_apic_clock = vmware_calibrate_apic_clock;
+	} else
 		printk(KERN_WARNING
-		       "Failed to get TSC freq from the hypervisor\n");
+		       "Failed to setup VMware hypervisor platform\n");
 }
 
 /*
Index: linux-x86-tree.git/arch/x86/kernel/x86_init.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/x86_init.c	2010-09-20 16:05:07.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/x86_init.c	2010-09-20 16:41:21.000000000 -0700
@@ -68,6 +68,7 @@ struct x86_init_ops x86_init __initdata 
 		.setup_percpu_clockev	= setup_boot_APIC_clock,
 		.tsc_pre_init		= x86_init_noop,
 		.timer_init		= hpet_time_init,
+		.calibrate_apic_clock	= native_calibrate_apic_clock
 	},
 
 	.iommu = {
Index: linux-x86-tree.git/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/apic/apic.c	2010-09-20 16:10:13.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/apic/apic.c	2010-09-20 16:42:12.000000000 -0700
@@ -326,13 +326,6 @@ int lapic_get_maxlvt(void)
 }
 
 /*
- * Local APIC timer
- */
-
-/* Clock divisor */
-#define APIC_DIVISOR 16
-
-/*
  * This function sets up the local APIC timer, with a timeout of
  * 'clocks' APIC bus clock. During calibration we actually call
  * this function twice on the boot CPU, once with a bogus timeout
@@ -500,8 +493,6 @@ static void __cpuinit setup_APIC_timer(v
  * back to normal later in the boot process).
  */
 
-#define LAPIC_CAL_LOOPS		(HZ/10)
-
 static __initdata int lapic_cal_loops = -1;
 static __initdata long lapic_cal_t1, lapic_cal_t2;
 static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;


