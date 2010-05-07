Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0EGRrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:2733 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757375Ab0EGRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418405"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 5/8] x86/apbt: support more timer configurations on mrst
Date: Fri,  7 May 2010 10:41:45 -0700
Message-Id: <1273254108-3234-6-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@intel.com>

With the addition of Medfield as a follow-up of Moorestown, more timer
configurations are available to the kernel. This patch allows the
optimal default configuration to be chosen and overwritten by cmdline
as well.
i.e. For Moorestown, percpu APB timers are default. For Medfield local
always-on local APIC timers are default (w/o any platform timers).

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/apb_timer.h |    2 +-
 arch/x86/kernel/apb_timer.c      |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

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
-- 
1.6.3.3

