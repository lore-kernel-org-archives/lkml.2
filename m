Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0G1O30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:29:26 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:57210 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab0G1O3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:29:24 -0400
Date: Wed, 28 Jul 2010 00:37:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: x86@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, venki@google.com
Subject: [RFC PATCH 2/2] x86: Prefer TSC Deadline Timer over LAPIC timer
In-reply-to: <alpine.LFD.2.00.1007280033370.28038@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1007280035480.28038@localhost.localdomain>
References: <alpine.LFD.2.00.1007280033370.28038@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The LOCAL APIC on new processors has a mode where
its underlying hardware timer can now be accessed
via the non-serializing IA32_TSC_DEADLINE_MSR in TSC tick units.

If this mode is present, prefer it over the
traditional LAPIC timer mode.  KERN_DEBUG dmesg
will print "TSC deadline timer enabled" when TDT is used.

Bootparam "tdt_off" is available to revert to LAPIC timer mode.

This patch is based on original work by Venkatesh Pallipadi.

cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    3 ++
 arch/x86/kernel/apic/apic.c         |   44 ++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b2407d..73ec308 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2596,6 +2596,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tdfx=		[HW,DRM]
 
+	tdt_off		[APIC,X86]
+			Disable TSC Deadline Timer, default back to LAPIC timer.
+
 	test_suspend=	[SUSPEND]
 			Specify "mem" (for Suspend-to-RAM) or "standby" (for
 			standby suspend) as the system sleep state to briefly
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a96489e..64069ae 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -53,6 +53,15 @@
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
 
+#define APIC_TIMER_MODE_ONESHOT		(0 << 17)
+#define APIC_TIMER_MODE_PERIODIC	(1 << 17)
+#define APIC_TIMER_MODE_TSC_DEADLINE	(2 << 17)
+#define APIC_TIMER_MODE_MASK		(3 << 17)
+
+static unsigned long tsc_per_apic_clock;
+static int tdt_enabled;
+static int tdt_disable;
+
 unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
@@ -355,6 +364,14 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
+	if (oneshot && !tdt_disable &&
+	    boot_cpu_has(X86_FEATURE_TSC_DEADLINE)) {
+		printk_once(KERN_DEBUG "TSC deadline timer enabled\n");
+		tdt_enabled = 1;
+		lvtt_value &= (~APIC_TIMER_MODE_MASK);
+		lvtt_value |= APIC_TIMER_MODE_TSC_DEADLINE;
+	}
+
 	apic_write(APIC_LVTT, lvtt_value);
 
 	/*
@@ -409,7 +426,20 @@ EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt)
 {
-	apic_write(APIC_TMICT, delta);
+	if (tdt_enabled) {
+		u64 tsc;
+		u64 delta_tsc;
+
+		delta_tsc = delta * tsc_per_apic_clock;
+		/* Just a safety check, should never get used */
+		if (delta_tsc < 2000000)
+			delta_tsc = 2000000;
+
+		rdtscll(tsc);
+		wrmsrl(MSR_IA32_TSC_DEADLINE, tsc + delta_tsc);
+	} else {
+		apic_write(APIC_TMICT, delta);
+	}
 	return 0;
 }
 
@@ -627,6 +657,11 @@ static int __init calibrate_APIC_clock(void)
 
 	deltatsc = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
 
+	tsc_per_apic_clock = (lapic_cal_tsc2 - lapic_cal_tsc1) /
+				(lapic_cal_t1 - lapic_cal_t2);
+	apic_printk(APIC_VERBOSE, "TSCs per APIC clocktick %lu\n",
+		tsc_per_apic_clock);
+
 	/* we trust the PM based calibration if possible */
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
 					&delta, &deltatsc);
@@ -2314,6 +2349,13 @@ static int __init apic_set_verbosity(char *arg)
 }
 early_param("apic", apic_set_verbosity);
 
+static int __init tdt_off(char *str)
+{
+	tdt_disable = 1;
+	return 1;
+}
+__setup("tdt_off", tdt_off);
+
 static int __init lapic_insert_resource(void)
 {
 	if (!apic_phys)
-- 
1.7.2


