Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0EGRrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:40 -0400
Received: from mga10.intel.com ([192.55.52.92]:2733 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757280Ab0EGRri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418399"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>, Alek Du <alek.du@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 4/8] x86/mrst: change clock selection logic to support medfield
Date: Fri,  7 May 2010 10:41:44 -0700
Message-Id: <1273254108-3234-5-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@intel.com>

Penwell has added always on lapic timers and tsc, we want to treat
it as a variant of moorestown so that one binary kernel can boot on both.
this patch added clock selction logic so that platform code can set up the
optimal configuration for both moorestown and medfield.

This patch will also mark Penwell TSC reliable, thus no need for
watchdog clocksource to monitor it.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |   30 +++++++++++
 arch/x86/kernel/mrst.c      |  119 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 137 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..3054407 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,7 +11,37 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
+extern unsigned int calibration_result;
+
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
+extern int mrst_timer_options __cpuinitdata;
+extern int mrst_identify_cpu(void);
+
+/**
+ * Medfield is the follow-up of Moorestown, it combines two chip solution into
+ * one. Other than that it also added always-on and constant tsc and lapic
+ * timers. Medfield is the platform name, and the chip name is called Penwell
+ * we treat Medfield/Penwell as a variant of Moorestown. Penwell can be
+ * identified via MSRs.
+ */
+
+
+#define MRST_CPU_CHIP_LINCROFT	1
+#define MRST_CPU_CHIP_PENWELL	2
+
+#define PENWELL_FAMILY		0x20670
+
+/**
+ * Penwell uses spread spectrum clock, so the freq number is not exactly
+ * as reported by MSR.
+ */
+#define PENWELL_FSB_FREQ_83SKU         83200
+#define PENWELL_FSB_FREQ_100SKU        99840
+
+#define MRST_TIMER_DEFAULT	0
+#define MRST_TIMER_APBT_ONLY	1
+#define MRST_TIMER_LAPIC_APBT	2
+
 
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0aad867..9e14e7f 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,8 +25,32 @@
 #include <asm/i8259.h>
 #include <asm/apb_timer.h>
 
+/**
+ * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
+ * cmdline option x86_mrst_timer can be used to override the configuration
+ * to prefer one or the other.
+ * at runtime, there are basically three timer configurations:
+ * 1. per cpu apbt clock only
+ * 2. per cpu always-on lapic clocks only, this is Penwell/Medfield only
+ * 3. per cpu lapic clock (C3STOP) and one apbt clock, with broadcast.
+ *
+ * by default (without cmdline option), platform code first detects cpu type
+ * to see if we are on lincroft or penwell, then set up both lapic or apbt
+ * clocks accordingly.
+ * i.e. by default, medfield uses configuration #2, moorestown uses #1.
+ * config #3 is supported but not recommended on medfield.
+ *
+ * rating and feature summary:
+ * lapic (with C3STOP) --------- 100
+ * apbt (always-on) ------------ 110
+ * lapic (always-on,ARAT) ------ 150
+ */
+
+int mrst_timer_options __cpuinitdata;
+
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+static u32 mrst_cpu_chip;
 int sfi_mtimer_num;
 
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
@@ -167,15 +191,16 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	return 0;
 }
 
-/*
- * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
- * APBT but cmdline option can also override it.
- */
 static void __cpuinit mrst_setup_secondary_clock(void)
 {
-	/* restore default lapic clock if disabled by cmdline */
-	if (disable_apbt_percpu)
-		return setup_secondary_APIC_clock();
+	if ((mrst_timer_options == MRST_TIMER_APBT_ONLY))
+		return apbt_setup_secondary_clock();
+	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)
+		||  (mrst_timer_options == MRST_TIMER_LAPIC_APBT)) {
+		pr_info("using lapic timers for secondary clock\n");
+		setup_secondary_APIC_clock();
+		return;
+	}
 	apbt_setup_secondary_clock();
 }
 
@@ -183,9 +208,45 @@ static unsigned long __init mrst_calibrate_tsc(void)
 {
 	unsigned long flags, fast_calibrate;
 
-	local_irq_save(flags);
-	fast_calibrate = apbt_quick_calibrate();
-	local_irq_restore(flags);
+	if (mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) {
+		u32 lo, hi, ratio, fsb;
+
+		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+		pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
+		ratio = (hi >> 8) & 0x1f;
+		pr_debug("ratio is %d\n", ratio);
+		if (!ratio) {
+			pr_err("read a zero ratio, should be incorrect!\n");
+			pr_err("force tsc ratio to 16 ...\n");
+			ratio = 16;
+		}
+		rdmsr(MSR_FSB_FREQ, lo, hi);
+		if ((lo & 0x7) == 0x7)
+			fsb = PENWELL_FSB_FREQ_83SKU;
+		else
+			fsb = PENWELL_FSB_FREQ_100SKU;
+		fast_calibrate = ratio * fsb;
+		pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
+		calibration_result = fsb * 1000 / HZ;
+		/* mark tsc clocksource as reliable */
+		set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+	} else {
+		/**
+		 * TODO: calibrate lapic timer with apbt, if we use apbt only,
+		 * there is no need to calibrate lapic timer, since they are
+		 * not used.
+		 * if we use lapic timers and apbt, the default calibration
+		 * should work, since we have the global clockevent setup.
+		 * but it would be more efficient if we combine the lapic timer
+		 * with tsc calibration.
+		 */
+		local_irq_save(flags);
+		fast_calibrate = apbt_quick_calibrate();
+		local_irq_restore(flags);
+	}
+
+	pr_info("tsc lapic calibration results %lu %d\n",
+			fast_calibrate, calibration_result);
 
 	if (fast_calibrate)
 		return fast_calibrate;
@@ -195,6 +256,11 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	/* if cpu is penwell, lapic timer will be used by default */
+	if ((mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) &&
+		(mrst_timer_options == MRST_TIMER_DEFAULT))
+		return;
+
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
@@ -211,11 +277,38 @@ void __init mrst_rtc_init(void)
  */
 static void __init mrst_setup_boot_clock(void)
 {
-	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
-	if (disable_apbt_percpu)
+	if (mrst_timer_options == MRST_TIMER_APBT_ONLY)
+		return;
+	if ((mrst_timer_options == MRST_TIMER_LAPIC_APBT)
+		|| (mrst_cpu_chip == MRST_CPU_CHIP_PENWELL))
 		setup_boot_APIC_clock();
 };
 
+enum cpuid_regs {
+	CR_EAX = 0,
+	CR_ECX,
+	CR_EDX,
+	CR_EBX
+};
+
+int mrst_identify_cpu(void)
+{
+	u32 regs[4];
+
+	cpuid(1, &regs[CR_EAX], &regs[CR_EBX], &regs[CR_ECX], &regs[CR_EDX]);
+	if ((regs[CR_EAX] & PENWELL_FAMILY) == PENWELL_FAMILY)
+		mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
+	else
+		mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+
+	pr_debug("cpuid result %x\n", regs[CR_EAX]);
+	pr_info("Moorestown CPU %s identified\n",
+		(mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
+		"Lincroft" : "Penwell");
+
+	return mrst_cpu_chip;
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -237,4 +330,6 @@ void __init x86_mrst_early_setup(void)
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
 	legacy_pic = &null_legacy_pic;
+
+	mrst_identify_cpu();
 }
-- 
1.6.3.3

