Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0EQTao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:30:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:18571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab0EQTag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="622386316"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/2] x86/mrst: add more timer config options
Date: Mon, 17 May 2010 12:23:03 -0700
Message-Id: <1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always-on local APIC timer (ARAT) has been introduced to Medfield, along
with the platform APB timers we have more timer configuration options
between Moorestown and Medfield.

This patch adds run-time detection of avaiable timer features so that
we can treat Medfield as a variant of Moorestown and set up the optimal
timer options for each platform. i.e.

Medfield: per cpu always-on local APIC timer
Moorestown: per cpu APB timer

Manual override is possible via cmdline option x86_mrst_timer.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/apb_timer.h |    2 +-
 arch/x86/include/asm/mrst.h      |    1 +
 arch/x86/kernel/apb_timer.c      |   18 ++++++-----
 arch/x86/kernel/mrst.c           |   64 ++++++++++++++++++++++++++++++++-----
 4 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index c74a2ee..4127fd1 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -55,7 +55,7 @@ extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
 extern unsigned int boot_cpu_id;
-extern int disable_apbt_percpu;
+extern int mrst_timer_options;
 
 extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
 extern void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr);
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index a25eff3..f683603 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -12,6 +12,7 @@
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
 extern int mrst_identify_cpu(void);
+extern int mrst_timer_options __cpuinitdata;
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 /**
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index a353475..08dfbf8 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -43,10 +43,11 @@
 
 #include <asm/fixmap.h>
 #include <asm/apb_timer.h>
+#include <asm/mrst.h>
 
 #define APBT_MASK			CLOCKSOURCE_MASK(32)
 #define APBT_SHIFT			22
-#define APBT_CLOCKEVENT_RATING		150
+#define APBT_CLOCKEVENT_RATING		110
 #define APBT_CLOCKSOURCE_RATING		250
 #define APBT_MIN_DELTA_USEC		200
 
@@ -83,8 +84,6 @@ struct apbt_dev {
 	char name[10];
 };
 
-int disable_apbt_percpu __cpuinitdata;
-
 static DEFINE_PER_CPU(struct apbt_dev, cpu_apbt_dev);
 
 #ifdef CONFIG_SMP
@@ -204,9 +203,9 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 		return -EINVAL;
 
 	if (strcmp("apbt_only", arg) == 0)
-		disable_apbt_percpu = 0;
+		mrst_timer_options = MRST_TIMER_APBT_ONLY;
 	else if (strcmp("lapic_and_apbt", arg) == 0)
-		disable_apbt_percpu = 1;
+		mrst_timer_options = MRST_TIMER_LAPIC_APBT;
 	else {
 		pr_warning("X86 MRST timer option %s not recognised"
 			   " use x86_mrst_timer=apbt_only or lapic_and_apbt\n",
@@ -335,7 +334,7 @@ static int __init apbt_clockevent_register(void)
 	adev->num = smp_processor_id();
 	memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
-	if (disable_apbt_percpu) {
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
 		apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
 		global_clock_event = &adev->evt;
 		printk(KERN_DEBUG "%s clockevent registered as global\n",
@@ -429,7 +428,8 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu || !apb_timer_block_enabled)
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT ||
+		!apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
@@ -450,6 +450,8 @@ static void apbt_set_mode(enum clock_event_mode mode,
 	int timer_num;
 	struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
 
+	BUG_ON(!apbt_virt_address);
+
 	timer_num = adev->num;
 	pr_debug("%s CPU %d timer %d mode=%d\n",
 		 __func__, first_cpu(*evt->cpumask), timer_num, mode);
@@ -676,7 +678,7 @@ void __init apbt_time_init(void)
 	}
 #ifdef CONFIG_SMP
 	/* kernel cmdline disable apb timer, so we will use lapic timers */
-	if (disable_apbt_percpu) {
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
 		printk(KERN_INFO "apbt: disabled per cpu timer\n");
 		return;
 	}
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index f1ccabd..87c5c7d 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,6 +25,29 @@
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
 int sfi_mtimer_num;
@@ -167,16 +190,25 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
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
+	switch (mrst_timer_options) {
+	case MRST_TIMER_APBT_ONLY:
+		return apbt_setup_secondary_clock();
+	case MRST_TIMER_LAPIC_APBT:
+		pr_info("using lapic timers for secondary clock\n");
 		return setup_secondary_APIC_clock();
-	apbt_setup_secondary_clock();
+	default:
+		/**
+		 * Default behavior is to use always-on lapic timer if available
+		 * (Medfield). Or, choose apbt timer (Moorestown).
+		 */
+		if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT))
+			setup_secondary_APIC_clock();
+		else
+			apbt_setup_secondary_clock();
+		return;
+	}
 }
 
 static unsigned long __init mrst_calibrate_tsc(void)
@@ -195,6 +227,11 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	/* if cpu is penwell, lapic timer will be used by default */
+	if ((mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL) &&
+		(mrst_timer_options == MRST_TIMER_DEFAULT))
+		return;
+
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
@@ -211,9 +248,18 @@ void __init mrst_rtc_init(void)
  */
 static void __init mrst_setup_boot_clock(void)
 {
-	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
-	if (disable_apbt_percpu)
+	switch (mrst_timer_options) {
+	case MRST_TIMER_APBT_ONLY:
+		break;
+	case MRST_TIMER_LAPIC_APBT:
 		setup_boot_APIC_clock();
+		break;
+	default:
+		/* check if this is Penwell */
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARAT))
+			setup_boot_APIC_clock();
+		break;
+	}
 };
 
 int mrst_identify_cpu(void)
-- 
1.6.3.3

