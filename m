Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1AFK2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:28:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1AFK2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:28:39 -0500
Date: Thu, 6 Jan 2011 11:28:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/hwmon changes for v2.6.38
Message-ID: <20110106102828.GA24878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-hwmon-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-hwmon-for-linus

 Thanks,

	Ingo

------------------>
R, Durgadoss (1):
      x86, hwmon: Add core threshold notification to therm_throt.c


 arch/x86/include/asm/mce.h               |    3 ++
 arch/x86/include/asm/msr-index.h         |   12 +++++++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   40 ++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c62c13c..eb16e94 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -223,6 +223,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_log_therm_throt_event(__u64 status);
 
+/* Interrupt Handler for core thermal thresholds */
+extern int (*platform_thermal_notify)(__u64 msr_val);
+
 #ifdef CONFIG_X86_THERMAL_VECTOR
 extern void mcheck_intel_therm_init(void);
 #else
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6b89f5e..622c80b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -253,6 +253,18 @@
 #define PACKAGE_THERM_INT_LOW_ENABLE		(1 << 1)
 #define PACKAGE_THERM_INT_PLN_ENABLE		(1 << 24)
 
+/* Thermal Thresholds Support */
+#define THERM_INT_THRESHOLD0_ENABLE    (1 << 15)
+#define THERM_SHIFT_THRESHOLD0        8
+#define THERM_MASK_THRESHOLD0          (0x7f << THERM_SHIFT_THRESHOLD0)
+#define THERM_INT_THRESHOLD1_ENABLE    (1 << 23)
+#define THERM_SHIFT_THRESHOLD1        16
+#define THERM_MASK_THRESHOLD1          (0x7f << THERM_SHIFT_THRESHOLD1)
+#define THERM_STATUS_THRESHOLD0        (1 << 6)
+#define THERM_LOG_THRESHOLD0           (1 << 7)
+#define THERM_STATUS_THRESHOLD1        (1 << 8)
+#define THERM_LOG_THRESHOLD1           (1 << 9)
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 4b68326..e12246f 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -53,8 +53,13 @@ struct thermal_state {
 	struct _thermal_state core_power_limit;
 	struct _thermal_state package_throttle;
 	struct _thermal_state package_power_limit;
+	struct _thermal_state core_thresh0;
+	struct _thermal_state core_thresh1;
 };
 
+/* Callback to handle core threshold interrupts */
+int (*platform_thermal_notify)(__u64 msr_val);
+
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
 static atomic_t therm_throt_en	= ATOMIC_INIT(0);
@@ -200,6 +205,22 @@ static int therm_throt_process(bool new_event, int event, int level)
 	return 0;
 }
 
+static int thresh_event_valid(int event)
+{
+	struct _thermal_state *state;
+	unsigned int this_cpu = smp_processor_id();
+	struct thermal_state *pstate = &per_cpu(thermal_state, this_cpu);
+	u64 now = get_jiffies_64();
+
+	state = (event == 0) ? &pstate->core_thresh0 : &pstate->core_thresh1;
+
+	if (time_before64(now, state->next_check))
+		return 0;
+
+	state->next_check = now + CHECK_INTERVAL;
+	return 1;
+}
+
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
@@ -313,6 +334,22 @@ device_initcall(thermal_throttle_init_device);
 #define PACKAGE_THROTTLED	((__u64)2 << 62)
 #define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
 
+static void notify_thresholds(__u64 msr_val)
+{
+	/* check whether the interrupt handler is defined;
+	 * otherwise simply return
+	 */
+	if (!platform_thermal_notify)
+		return;
+
+	/* lower threshold reached */
+	if ((msr_val & THERM_LOG_THRESHOLD0) &&	thresh_event_valid(0))
+		platform_thermal_notify(msr_val);
+	/* higher threshold reached */
+	if ((msr_val & THERM_LOG_THRESHOLD1) && thresh_event_valid(1))
+		platform_thermal_notify(msr_val);
+}
+
 /* Thermal transition interrupt handler */
 static void intel_thermal_interrupt(void)
 {
@@ -321,6 +358,9 @@ static void intel_thermal_interrupt(void)
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 
+	/* Check for violation of core thermal thresholds*/
+	notify_thresholds(msr_val);
+
 	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
 				THERMAL_THROTTLING_EVENT,
 				CORE_LEVEL) != 0)
