Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2JAOKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:10:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38897 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2JAOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:10:04 -0400
Date: Mon, 1 Oct 2012 16:09:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] x86/mce changes for v3.7
Message-ID: <20121001140958.GA24640@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mce-for-linus

   HEAD: 39ba5010d349109e53eaf9819bebe3f501bb5edf Merge tag 'please-pull-naveen' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/mce

Various MCE robustness enhancements.

One of the changes adds CMCI (Corrected Machine Check Interrupt) 
poll mode on Intel Nehalem+ CPUs, which mode is automatically 
entered when the rate of messages is too high - and exited once 
the storm is over.

An MCE events storm will roughly look like this:

 [ 5342.740616] mce: [Hardware Error]: Machine check events logged
 [ 5342.746501] mce: [Hardware Error]: Machine check events logged
 [ 5342.757971] CMCI storm detected: switching to poll mode
 [ 5372.674957] CMCI storm subsided: switching to interrupt mode

This should make such events more survivable.

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, mce: Enable MCA support by default
      x86, MCE: Remove unused defines

Chen Gong (1):
      x86/mce: Add CMCI poll mode

Naveen N. Rao (1):
      x86/mce: Provide boot argument to honour bios-set CMCI threshold

Thomas Gleixner (4):
      x86: mce: Disable preemption when calling raise_local()
      x86: mce: Serialize mce injection
      x86: mce: Split timer init
      x86: mce: Remove the frozen cases in the hotplug code

Tony Luck (1):
      x86/mce: Make cmci_discover() quiet


 Documentation/x86/x86_64/boot-options.txt |   7 ++
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/mce.h                |  13 +--
 arch/x86/kernel/cpu/mcheck/mce-inject.c   |   8 ++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  12 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |  94 ++++++++++++-----
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 168 ++++++++++++++++++++++++++----
 7 files changed, 244 insertions(+), 59 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index c54b4f5..de38429 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -50,6 +50,13 @@ Machine check
 		monarchtimeout:
 		Sets the time in us to wait for other CPUs on machine checks. 0
 		to disable.
+   mce=bios_cmci_threshold
+		Don't overwrite the bios-set CMCI threshold. This boot option
+		prevents Linux from overwriting the CMCI threshold set by the
+		bios. Without this option, Linux always sets the CMCI
+		threshold to 1. Enabling this may make memory predictive failure
+		analysis less effective if the bios sets thresholds for memory
+		errors since we will not see details for all errors.
 
    nomce (for compatibility with i386): same as mce=off
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..3d2d2ef 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -871,6 +871,7 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check / overheating reporting"
+	default y
 	---help---
 	  Machine Check support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, data corruption).
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a3ac52b..54d73b1 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -116,19 +116,9 @@ struct mce_log {
 /* Software defined banks */
 #define MCE_EXTENDED_BANK	128
 #define MCE_THERMAL_BANK	MCE_EXTENDED_BANK + 0
-
-#define K8_MCE_THRESHOLD_BASE      (MCE_EXTENDED_BANK + 1)      /* MCE_AMD */
-#define K8_MCE_THRESHOLD_BANK_0    (MCE_THRESHOLD_BASE + 0 * 9)
-#define K8_MCE_THRESHOLD_BANK_1    (MCE_THRESHOLD_BASE + 1 * 9)
-#define K8_MCE_THRESHOLD_BANK_2    (MCE_THRESHOLD_BASE + 2 * 9)
-#define K8_MCE_THRESHOLD_BANK_3    (MCE_THRESHOLD_BASE + 3 * 9)
-#define K8_MCE_THRESHOLD_BANK_4    (MCE_THRESHOLD_BASE + 4 * 9)
-#define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
-#define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
-
+#define K8_MCE_THRESHOLD_BASE      (MCE_EXTENDED_BANK + 1)
 
 #ifdef __KERNEL__
-
 extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
@@ -171,6 +161,7 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #ifdef CONFIG_X86_MCE_INTEL
 extern int mce_cmci_disabled;
 extern int mce_ignore_ce;
+extern int mce_bios_cmci_threshold;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index fc4beb3..ddc72f8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -78,6 +78,7 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 }
 
 static cpumask_var_t mce_inject_cpumask;
+static DEFINE_MUTEX(mce_inject_mutex);
 
 static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
@@ -194,7 +195,11 @@ static void raise_mce(struct mce *m)
 		put_online_cpus();
 	} else
 #endif
+	{
+		preempt_disable();
 		raise_local();
+		preempt_enable();
+	}
 }
 
 /* Error injection interface */
@@ -225,7 +230,10 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	 * so do it a jiffie or two later everywhere.
 	 */
 	schedule_timeout(2);
+
+	mutex_lock(&mce_inject_mutex);
 	raise_mce(&m);
+	mutex_unlock(&mce_inject_mutex);
 	return usize;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index ed44c8a..6a05c1d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -28,6 +28,18 @@ extern int mce_ser;
 
 extern struct mce_bank *mce_banks;
 
+#ifdef CONFIG_X86_MCE_INTEL
+unsigned long mce_intel_adjust_timer(unsigned long interval);
+void mce_intel_cmci_poll(void);
+void mce_intel_hcpu_update(unsigned long cpu);
+#else
+# define mce_intel_adjust_timer mce_adjust_timer_default
+static inline void mce_intel_cmci_poll(void) { }
+static inline void mce_intel_hcpu_update(unsigned long cpu) { }
+#endif
+
+void mce_timer_kick(unsigned long interval);
+
 #ifdef CONFIG_ACPI_APEI
 int apei_write_mce(struct mce *m);
 ssize_t apei_read_mce(struct mce *m, u64 *record_id);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 292d025..29e87d3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -83,6 +83,7 @@ static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
+int				mce_bios_cmci_threshold	__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
 
@@ -1266,6 +1267,14 @@ static unsigned long check_interval = 5 * 60; /* 5 minutes */
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
@@ -1276,6 +1285,7 @@ static void mce_timer_fn(unsigned long data)
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
+		mce_intel_cmci_poll();
 	}
 
 	/*
@@ -1283,14 +1293,38 @@ static void mce_timer_fn(unsigned long data)
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
@@ -1585,6 +1619,7 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		mce_intel_feature_init(c);
+		mce_adjust_timer = mce_intel_adjust_timer;
 		break;
 	case X86_VENDOR_AMD:
 		mce_amd_feature_init(c);
@@ -1594,23 +1629,28 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __mcheck_cpu_init_timer(void)
+static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
-	unsigned long iv = check_interval * HZ;
+	unsigned long iv = mce_adjust_timer(check_interval * HZ);
 
-	setup_timer(t, mce_timer_fn, smp_processor_id());
+	__this_cpu_write(mce_next_interval, iv);
 
-	if (mce_ignore_ce)
+	if (mce_ignore_ce || !iv)
 		return;
 
-	__this_cpu_write(mce_next_interval, iv);
-	if (!iv)
-		return;
 	t->expires = round_jiffies(jiffies + iv);
 	add_timer_on(t, smp_processor_id());
 }
 
+static void __mcheck_cpu_init_timer(void)
+{
+	struct timer_list *t = &__get_cpu_var(mce_timer);
+	unsigned int cpu = smp_processor_id();
+
+	setup_timer(t, mce_timer_fn, cpu);
+	mce_start_timer(cpu, t);
+}
+
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 {
@@ -1907,6 +1947,7 @@ static struct miscdevice mce_chrdev_device = {
  *	check, or 0 to not wait
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=bios_cmci_threshold Don't program the CMCI threshold
  */
 static int __init mcheck_enable(char *str)
 {
@@ -1926,6 +1967,8 @@ static int __init mcheck_enable(char *str)
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
+	else if (!strcmp(str, "bios_cmci_threshold"))
+		mce_bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &tolerant);
 		if (*str == ',') {
@@ -2166,6 +2209,11 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
+static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
+	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
+	&mce_bios_cmci_threshold
+};
+
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2174,6 +2222,7 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
+	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
@@ -2294,38 +2343,33 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned int cpu = (unsigned long)hcpu;
 	struct timer_list *t = &per_cpu(mce_timer, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		mce_device_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		mce_device_remove(cpu);
+		mce_intel_hcpu_update(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		del_timer_sync(t);
 		break;
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		if (!mce_ignore_ce && check_interval) {
-			t->expires = round_jiffies(jiffies +
-					per_cpu(mce_next_interval, cpu));
-			add_timer_on(t, cpu);
-		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mce_start_timer(cpu, t);
 		break;
-	case CPU_POST_DEAD:
+	}
+
+	if (action == CPU_POST_DEAD) {
 		/* intentionally ignoring frozen here */
 		cmci_rediscover(cpu);
-		break;
 	}
+
 	return NOTIFY_OK;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 38e49bc..5f88abf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -15,6 +15,8 @@
 #include <asm/msr.h>
 #include <asm/mce.h>
 
+#include "mce-internal.h"
+
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
  * the CPU to raise an interrupt when a corrected machine check happened.
@@ -30,7 +32,22 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
  */
 static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 
-#define CMCI_THRESHOLD 1
+#define CMCI_THRESHOLD		1
+#define CMCI_POLL_INTERVAL	(30 * HZ)
+#define CMCI_STORM_INTERVAL	(1 * HZ)
+#define CMCI_STORM_THRESHOLD	15
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
@@ -53,6 +70,93 @@ static int cmci_supported(int *banks)
 	return !!(cap & MCG_CMCI_P);
 }
 
+void mce_intel_cmci_poll(void)
+{
+	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
+		return;
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+}
+
+void mce_intel_hcpu_update(unsigned long cpu)
+{
+	if (per_cpu(cmci_storm_state, cpu) == CMCI_STORM_ACTIVE)
+		atomic_dec(&cmci_storm_on_cpus);
+
+	per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
+}
+
+unsigned long mce_intel_adjust_timer(unsigned long interval)
+{
+	int r;
+
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
+		r = atomic_sub_return(1, &cmci_storm_on_cpus);
+		if (r == 0)
+			pr_notice("CMCI storm subsided: switching to interrupt mode\n");
+		/* FALLTHROUGH */
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
+		 * We have shiny weather. Let the poll do whatever it
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
+	int r;
+
+	if (__this_cpu_read(cmci_storm_state) != CMCI_STORM_NONE)
+		return true;
+
+	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
+		cnt++;
+	} else {
+		cnt = 1;
+		__this_cpu_write(cmci_time_stamp, now);
+	}
+	__this_cpu_write(cmci_storm_cnt, cnt);
+
+	if (cnt <= CMCI_STORM_THRESHOLD)
+		return false;
+
+	cmci_clear();
+	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
+	r = atomic_add_return(1, &cmci_storm_on_cpus);
+	mce_timer_kick(CMCI_POLL_INTERVAL);
+
+	if (r == 1)
+		pr_notice("CMCI storm detected: switching to poll mode\n");
+	return true;
+}
+
 /*
  * The interrupt handler. This is called on every event.
  * Just call the poller directly to log any events.
@@ -61,33 +165,28 @@ static int cmci_supported(int *banks)
  */
 static void intel_threshold_interrupt(void)
 {
+	if (cmci_storm_detect())
+		return;
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
 	mce_notify_irq();
 }
 
-static void print_update(char *type, int *hdr, int num)
-{
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
-}
-
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
  * on this CPU. Use the algorithm recommended in the SDM to discover shared
  * banks.
  */
-static void cmci_discover(int banks, int boot)
+static void cmci_discover(int banks)
 {
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
 	unsigned long flags;
-	int hdr = 0;
 	int i;
+	int bios_wrong_thresh = 0;
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
+		int bios_zero_thresh = 0;
 
 		if (test_bit(i, owned))
 			continue;
@@ -96,29 +195,52 @@ static void cmci_discover(int banks, int boot)
 
 		/* Already owned by someone else? */
 		if (val & MCI_CTL2_CMCI_EN) {
-			if (test_and_clear_bit(i, owned) && !boot)
-				print_update("SHD", &hdr, i);
+			clear_bit(i, owned);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
 
-		val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
-		val |= MCI_CTL2_CMCI_EN | CMCI_THRESHOLD;
+		if (!mce_bios_cmci_threshold) {
+			val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
+			val |= CMCI_THRESHOLD;
+		} else if (!(val & MCI_CTL2_CMCI_THRESHOLD_MASK)) {
+			/*
+			 * If bios_cmci_threshold boot option was specified
+			 * but the threshold is zero, we'll try to initialize
+			 * it to 1.
+			 */
+			bios_zero_thresh = 1;
+			val |= CMCI_THRESHOLD;
+		}
+
+		val |= MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & MCI_CTL2_CMCI_EN) {
-			if (!test_and_set_bit(i, owned) && !boot)
-				print_update("CMCI", &hdr, i);
+			set_bit(i, owned);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			/*
+			 * We are able to set thresholds for some banks that
+			 * had a threshold of 0. This means the BIOS has not
+			 * set the thresholds properly or does not work with
+			 * this boot option. Note down now and report later.
+			 */
+			if (mce_bios_cmci_threshold && bios_zero_thresh &&
+					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
+				bios_wrong_thresh = 1;
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
-	if (hdr)
-		printk(KERN_CONT "\n");
+	if (mce_bios_cmci_threshold && bios_wrong_thresh) {
+		pr_info_once(
+			"bios_cmci_threshold: Some banks do not have valid thresholds set\n");
+		pr_info_once(
+			"bios_cmci_threshold: Make sure your BIOS supports this boot option\n");
+	}
 }
 
 /*
@@ -156,7 +278,7 @@ void cmci_clear(void)
 			continue;
 		/* Disable CMCI */
 		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
-		val &= ~(MCI_CTL2_CMCI_EN|MCI_CTL2_CMCI_THRESHOLD_MASK);
+		val &= ~MCI_CTL2_CMCI_EN;
 		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
@@ -186,7 +308,7 @@ void cmci_rediscover(int dying)
 			continue;
 		/* Recheck banks in case CPUs don't all have the same */
 		if (cmci_supported(&banks))
-			cmci_discover(banks, 0);
+			cmci_discover(banks);
 	}
 
 	set_cpus_allowed_ptr(current, old);
@@ -200,7 +322,7 @@ void cmci_reenable(void)
 {
 	int banks;
 	if (cmci_supported(&banks))
-		cmci_discover(banks, 0);
+		cmci_discover(banks);
 }
 
 static void intel_init_cmci(void)
@@ -211,7 +333,7 @@ static void intel_init_cmci(void)
 		return;
 
 	mce_threshold_vector = intel_threshold_interrupt;
-	cmci_discover(banks, 1);
+	cmci_discover(banks);
 	/*
 	 * For CPU #0 this runs with still disabled APIC, but that's
 	 * ok because only the vector is set up. We still do another
