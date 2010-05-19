Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0ESVwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:52:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0ESVwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:52:34 -0400
Date: Wed, 19 May 2010 21:52:17 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: add more timer config options
Message-ID: <tip-a875c01944f0d750eeb1ef3133feceb13f13c4b3@git.kernel.org>
Git-Commit-ID: a875c01944f0d750eeb1ef3133feceb13f13c4b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 21:52:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a875c01944f0d750eeb1ef3133feceb13f13c4b3
Gitweb:     http://git.kernel.org/tip/a875c01944f0d750eeb1ef3133feceb13f13c4b3
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Wed, 19 May 2010 12:01:25 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 May 2010 13:45:39 -0700

x86, mrst: add more timer config options

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
LKML-Reference: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/mrst.h      |    1 +
 arch/x86/kernel/apb_timer.c      |   37 +++------------
 arch/x86/kernel/mrst.c           |   88 +++++++++++++++++++++++++++-----------
 4 files changed, 72 insertions(+), 55 deletions(-)

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
index dc5c850..67ad315 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -12,6 +12,7 @@
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
 extern int mrst_identify_cpu(void);
+extern int mrst_timer_options __cpuinitdata;
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 /*
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
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index ceaebeb..636b53b 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,6 +25,29 @@
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
+int mrst_timer_options __cpuinitdata;
+
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 static int mrst_cpu_chip;
@@ -169,18 +192,6 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
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
@@ -197,6 +208,21 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
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
@@ -207,17 +233,6 @@ void __init mrst_rtc_init(void)
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
 }
 
-/*
- * if we use per cpu apb timer, the bootclock already setup. if we use lapic
- * timer and one apbt timer for broadcast, we need to set up lapic boot clock.
- */
-static void __init mrst_setup_boot_clock(void)
-{
-	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
-	if (disable_apbt_percpu)
-		setup_boot_APIC_clock();
-};
-
 int mrst_identify_cpu(void)
 {
 	return mrst_cpu_chip;
@@ -250,13 +265,13 @@ void __init x86_mrst_early_setup(void)
 	x86_init.resources.reserve_resources = x86_init_noop;
 
 	x86_init.timers.timer_init = mrst_time_init;
-	x86_init.timers.setup_percpu_clockev = mrst_setup_boot_clock;
+	x86_init.timers.setup_percpu_clockev = x86_init_noop;
 
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 
 	x86_init.oem.arch_setup = mrst_arch_setup;
 
-	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
+	x86_cpuinit.setup_percpu_clockev = apbt_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
 	x86_init.pci.init = pci_mrst_init;
@@ -269,3 +284,26 @@ void __init x86_mrst_early_setup(void)
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
