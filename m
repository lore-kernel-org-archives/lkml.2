Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2FFVxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:53:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:52300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048Ab2FFVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:53:26 -0400
Message-Id: <20120606215116.757323156@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:53:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 5/5] x86: mce: Add cmci poll mode
References: <20120606214941.104735929@linutronix.de>
Content-Disposition: inline; filename=x86-mce-cmci-poll-mode.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still waits for explanation :)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   10 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |   46 +++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   88 +++++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 7 deletions(-)

Index: tip/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ tip/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -28,6 +28,16 @@ extern int mce_ser;
 
 extern struct mce_bank *mce_banks;
 
+#ifdef CONFIG_X86_MCE_INTEL
+unsigned long mce_intel_adjust_timer(unsigned long interval);
+void mce_intel_cmci_poll(void);
+#else
+# define mce_intel_adjust_timer mce_adjust_timer_default
+static inline void mce_intel_cmci_poll(void) { }
+#endif
+
+void mce_timer_kick(unsigned long interval);
+
 #ifdef CONFIG_ACPI_APEI
 int apei_write_mce(struct mce *m);
 ssize_t apei_read_mce(struct mce *m, u64 *record_id);
Index: tip/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1256,6 +1256,14 @@ static unsigned long check_interval = 5 
 static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
+static unsigned long mce_adjust_timer_default(unsigned long interval)
+{
+	return interval;
+}
+
+static unsigned long (*mce_adjust_timer)(unsigned long interval) =
+	mce_adjust_timer_default;
+
 static void mce_timer_fn(unsigned long data)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
@@ -1266,6 +1274,7 @@ static void mce_timer_fn(unsigned long d
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
+		mce_intel_cmci_poll();
 	}
 
 	/*
@@ -1273,14 +1282,38 @@ static void mce_timer_fn(unsigned long d
 	 * polling interval, otherwise increase the polling interval.
 	 */
 	iv = __this_cpu_read(mce_next_interval);
-	if (mce_notify_irq())
+	if (mce_notify_irq()) {
 		iv = max(iv / 2, (unsigned long) HZ/100);
-	else
+	} else {
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
+		iv = mce_adjust_timer(iv);
+	}
 	__this_cpu_write(mce_next_interval, iv);
+	/* Might have become 0 after CMCI storm subsided */
+	if (iv) {
+		t->expires = jiffies + iv;
+		add_timer_on(t, smp_processor_id());
+	}
+}
 
-	t->expires = jiffies + iv;
-	add_timer_on(t, smp_processor_id());
+/*
+ * Ensure that the timer is firing in @interval from now.
+ */
+void mce_timer_kick(unsigned long interval)
+{
+	struct timer_list *t = &__get_cpu_var(mce_timer);
+	unsigned long when = jiffies + interval;
+	unsigned long iv = __this_cpu_read(mce_next_interval);
+
+	if (timer_pending(t)) {
+		if (time_before(when, t->expires))
+			mod_timer_pinned(t, when);
+	} else {
+		t->expires = round_jiffies(when);
+		add_timer_on(t, smp_processor_id());
+	}
+	if (interval < iv)
+		__this_cpu_write(mce_next_interval, interval);
 }
 
 /* Must not be called in IRQ context where del_timer_sync() can deadlock */
@@ -1545,6 +1578,7 @@ static void __mcheck_cpu_init_vendor(str
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		mce_intel_feature_init(c);
+		mce_adjust_timer = mce_intel_adjust_timer;
 		break;
 	case X86_VENDOR_AMD:
 		mce_amd_feature_init(c);
@@ -1556,7 +1590,7 @@ static void __mcheck_cpu_init_vendor(str
 
 static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 {
-	unsigned long iv = check_interval * HZ;
+	unsigned long iv = mce_adjust_timer(check_interval * HZ);
 
 	__this_cpu_write(mce_next_interval, iv);
 
@@ -2272,8 +2306,8 @@ mce_cpu_callback(struct notifier_block *
 		mce_device_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		del_timer_sync(t);
 		break;
 	case CPU_DOWN_FAILED:
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
Index: tip/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -15,6 +15,8 @@
 #include <asm/msr.h>
 #include <asm/mce.h>
 
+#include "mce-internal.h"
+
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
  * the CPU to raise an interrupt when a corrected machine check happened.
@@ -30,7 +32,22 @@ static DEFINE_PER_CPU(mce_banks_t, mce_b
  */
 static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 
-#define CMCI_THRESHOLD 1
+#define CMCI_THRESHOLD		1
+#define CMCI_POLL_INTERVAL	(30 * HZ)
+#define CMCI_STORM_INTERVAL	(1 * HZ)
+#define CMCI_STORM_TRESHOLD	5
+
+static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
+static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
+static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
+
+enum {
+	CMCI_STORM_NONE,
+	CMCI_STORM_ACTIVE,
+	CMCI_STORM_SUBSIDED,
+};
+
+static atomic_t cmci_storm_on_cpus;
 
 static int cmci_supported(int *banks)
 {
@@ -53,6 +70,73 @@ static int cmci_supported(int *banks)
 	return !!(cap & MCG_CMCI_P);
 }
 
+void mce_intel_cmci_poll(void)
+{
+	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
+		return;
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+}
+
+unsigned long mce_intel_adjust_timer(unsigned long interval)
+{
+	if (interval < CMCI_POLL_INTERVAL)
+		return interval;
+
+	switch (__this_cpu_read(cmci_storm_state)) {
+	case CMCI_STORM_ACTIVE:
+		/*
+		 * We switch back to interrupt mode once the poll timer has
+		 * silenced itself. That means no events recorded and the
+		 * timer interval is back to our poll interval.
+		 */
+		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
+		atomic_dec(&cmci_storm_on_cpus);
+
+	case CMCI_STORM_SUBSIDED:
+		/*
+		 * We wait for all cpus to go back to SUBSIDED
+		 * state. When that happens we switch back to
+		 * interrupt mode.
+		 */
+		if (!atomic_read(&cmci_storm_on_cpus)) {
+			__this_cpu_write(cmci_storm_state, CMCI_STORM_NONE);
+			cmci_reenable();
+			cmci_recheck();
+		}
+		return CMCI_POLL_INTERVAL;
+	default:
+		/*
+		 * We have shiny wheather, let the poll do whatever it
+		 * thinks.
+		 */
+		return interval;
+	}
+}
+
+static bool cmci_storm_detect(void)
+{
+	unsigned int cnt = __this_cpu_read(cmci_storm_cnt);
+	unsigned long ts = __this_cpu_read(cmci_time_stamp);
+	unsigned long now = jiffies;
+
+	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
+		cnt++;
+	} else {
+		cnt = 1;
+		__this_cpu_write(cmci_time_stamp, now);
+	}
+	__this_cpu_write(cmci_storm_cnt, cnt);
+
+	if (cnt <= CMCI_STORM_TRESHOLD)
+		return false;
+
+	cmci_clear();
+	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
+	atomic_inc(&cmci_storm_on_cpus);
+	mce_timer_kick(CMCI_POLL_INTERVAL);
+	return true;
+}
+
 /*
  * The interrupt handler. This is called on every event.
  * Just call the poller directly to log any events.
@@ -61,6 +145,8 @@ static int cmci_supported(int *banks)
  */
 static void intel_threshold_interrupt(void)
 {
+	if (cmci_storm_detect())
+		return;
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
 	mce_notify_irq();
 }


