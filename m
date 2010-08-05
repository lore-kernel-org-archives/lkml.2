Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab0HEUi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:38:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760604Ab0HEUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:43 -0400
Date: Thu, 5 Aug 2010 20:38:05 GMT
Message-Id: <201008052038.o75Kc55v022116@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/mrst for 2.6.36
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mrst-for-linus

H. Peter Anvin (2):
      x86, mrst: make mrst_identify_cpu() an inline returning enum
      x86, mrst: make mrst_timer_options an enum

Jacob Pan (3):
      x86: detect scattered cpuid features earlier
      x86, mrst: add cpu type detection
      x86, mrst: add more timer config options

 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/mrst.h      |   26 +++++++++
 arch/x86/kernel/apb_timer.c      |   37 +++----------
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/mrst.c           |  105 +++++++++++++++++++++++++++++--------
 5 files changed, 117 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index c74a2ee..a69b1ac 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -55,7 +55,6 @@ extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
 extern unsigned int boot_cpu_id;
-extern int disable_apbt_percpu;
 
 extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint);
 extern void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr);
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 451d30e..1635074 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -13,6 +13,32 @@
 extern int pci_mrst_init(void);
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
+/*
+ * Medfield is the follow-up of Moorestown, it combines two chip solution into
+ * one. Other than that it also added always-on and constant tsc and lapic
+ * timers. Medfield is the platform name, and the chip name is called Penwell
+ * we treat Medfield/Penwell as a variant of Moorestown. Penwell can be
+ * identified via MSRs.
+ */
+enum mrst_cpu_type {
+	MRST_CPU_CHIP_LINCROFT = 1,
+	MRST_CPU_CHIP_PENWELL,
+};
+
+extern enum mrst_cpu_type __mrst_cpu_chip;
+static enum mrst_cpu_type mrst_identify_cpu(void)
+{
+	return __mrst_cpu_chip;
+}
+
+enum mrst_timer_options {
+	MRST_TIMER_DEFAULT,
+	MRST_TIMER_APBT_ONLY,
+	MRST_TIMER_LAPIC_APBT,
+};
+
+extern enum mrst_timer_options mrst_timer_options;
+
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index a353475..8dd7780 100644
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
@@ -195,29 +194,6 @@ static struct clock_event_device apbt_clockevent = {
 };
 
 /*
- * if user does not want to use per CPU apb timer, just give it a lower rating
- * than local apic timer and skip the late per cpu timer init.
- */
-static inline int __init setup_x86_mrst_timer(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (strcmp("apbt_only", arg) == 0)
-		disable_apbt_percpu = 0;
-	else if (strcmp("lapic_and_apbt", arg) == 0)
-		disable_apbt_percpu = 1;
-	else {
-		pr_warning("X86 MRST timer option %s not recognised"
-			   " use x86_mrst_timer=apbt_only or lapic_and_apbt\n",
-			   arg);
-		return -EINVAL;
-	}
-	return 0;
-}
-__setup("x86_mrst_timer=", setup_x86_mrst_timer);
-
-/*
  * start count down from 0xffff_ffff. this is done by toggling the enable bit
  * then load initial load count to ~0.
  */
@@ -335,7 +311,7 @@ static int __init apbt_clockevent_register(void)
 	adev->num = smp_processor_id();
 	memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
-	if (disable_apbt_percpu) {
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
 		apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
 		global_clock_event = &adev->evt;
 		printk(KERN_DEBUG "%s clockevent registered as global\n",
@@ -429,7 +405,8 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu || !apb_timer_block_enabled)
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT ||
+		!apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
@@ -450,6 +427,8 @@ static void apbt_set_mode(enum clock_event_mode mode,
 	int timer_num;
 	struct apbt_dev *adev = EVT_TO_APBT_DEV(evt);
 
+	BUG_ON(!apbt_virt_address);
+
 	timer_num = adev->num;
 	pr_debug("%s CPU %d timer %d mode=%d\n",
 		 __func__, first_cpu(*evt->cpumask), timer_num, mode);
@@ -676,7 +655,7 @@ void __init apbt_time_init(void)
 	}
 #ifdef CONFIG_SMP
 	/* kernel cmdline disable apb timer, so we will use lapic timers */
-	if (disable_apbt_percpu) {
+	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
 		printk(KERN_INFO "apbt: disabled per cpu timer\n");
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 68e4a6f..c4c864a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -576,6 +576,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	init_scattered_cpuid_features(c);
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
@@ -731,7 +732,6 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	init_scattered_cpuid_features(c);
 	detect_nopl(c);
 }
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 5915e0b..79ae681 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,8 +25,34 @@
 #include <asm/i8259.h>
 #include <asm/apb_timer.h>
 
+/*
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
+__cpuinitdata enum mrst_timer_options mrst_timer_options;
+
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
+enum mrst_cpu_type __mrst_cpu_chip;
+EXPORT_SYMBOL_GPL(__mrst_cpu_chip);
+
 int sfi_mtimer_num;
 
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
@@ -167,18 +193,6 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	return 0;
 }
 
-/*
- * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
- * APBT but cmdline option can also override it.
- */
-static void __cpuinit mrst_setup_secondary_clock(void)
-{
-	/* restore default lapic clock if disabled by cmdline */
-	if (disable_apbt_percpu)
-		return setup_secondary_APIC_clock();
-	apbt_setup_secondary_clock();
-}
-
 static unsigned long __init mrst_calibrate_tsc(void)
 {
 	unsigned long flags, fast_calibrate;
@@ -195,6 +209,21 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	switch (mrst_timer_options) {
+	case MRST_TIMER_APBT_ONLY:
+		break;
+	case MRST_TIMER_LAPIC_APBT:
+		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
+		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
+		break;
+	default:
+		if (!boot_cpu_has(X86_FEATURE_ARAT))
+			break;
+		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
+		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
+		return;
+	}
+	/* we need at least one APB timer */
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
@@ -205,16 +234,21 @@ void __init mrst_rtc_init(void)
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
 }
 
-/*
- * if we use per cpu apb timer, the bootclock already setup. if we use lapic
- * timer and one apbt timer for broadcast, we need to set up lapic boot clock.
- */
-static void __init mrst_setup_boot_clock(void)
+void __cpuinit mrst_arch_setup(void)
 {
-	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
-	if (disable_apbt_percpu)
-		setup_boot_APIC_clock();
-};
+	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
+		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
+	else if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x26)
+		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	else {
+		pr_err("Unknown Moorestown CPU (%d:%d), default to Lincroft\n",
+			boot_cpu_data.x86, boot_cpu_data.x86_model);
+		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+	}
+	pr_debug("Moorestown CPU %s identified\n",
+		(__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
+		"Lincroft" : "Penwell");
+}
 
 /* MID systems don't have i8042 controller */
 static int mrst_i8042_detect(void)
@@ -232,11 +266,13 @@ void __init x86_mrst_early_setup(void)
 	x86_init.resources.reserve_resources = x86_init_noop;
 
 	x86_init.timers.timer_init = mrst_time_init;
-	x86_init.timers.setup_percpu_clockev = mrst_setup_boot_clock;
+	x86_init.timers.setup_percpu_clockev = x86_init_noop;
 
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 
-	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
+	x86_init.oem.arch_setup = mrst_arch_setup;
+
+	x86_cpuinit.setup_percpu_clockev = apbt_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
 	x86_platform.i8042_detect = mrst_i8042_detect;
@@ -250,3 +286,26 @@ void __init x86_mrst_early_setup(void)
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 
 }
+
+/*
+ * if user does not want to use per CPU apb timer, just give it a lower rating
+ * than local apic timer and skip the late per cpu timer init.
+ */
+static inline int __init setup_x86_mrst_timer(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp("apbt_only", arg) == 0)
+		mrst_timer_options = MRST_TIMER_APBT_ONLY;
+	else if (strcmp("lapic_and_apbt", arg) == 0)
+		mrst_timer_options = MRST_TIMER_LAPIC_APBT;
+	else {
+		pr_warning("X86 MRST timer option %s not recognised"
+			   " use x86_mrst_timer=apbt_only or lapic_and_apbt\n",
+			   arg);
+		return -EINVAL;
+	}
+	return 0;
+}
+__setup("x86_mrst_timer=", setup_x86_mrst_timer);
