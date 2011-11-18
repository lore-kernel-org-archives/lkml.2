Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1KRTXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:23:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:42006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1KRTXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:23:36 -0500
Date: Fri, 18 Nov 2011 20:23:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 fixes for 3.2
Message-ID: <alpine.LFD.2.02.1111182021370.4902@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus


out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
drivers/char/random.c              # 0d2f096: random: Fix handing of arch_get_r

Thanks,

	tglx

------------------>
Dirk Brandewie (1):
      x86/mrst: Add support for Penwell clock calibration

Feng Tang (1):
      x86/platform: Add a wallclock_init func to x86_platforms ops

Jacob Pan (3):
      x86/apic: Do not clear nr_irqs_gsi if no legacy irqs
      x86/apic: Allow use of lapic timer early calibration result
      x86/mrst: Avoid reporting wrong nmi status

Mathias Nyman (1):
      x86, ioapic: Only print ioapic debug information for IRQs belonging to an ioapic chip

Rabin Vincent (1):
      x86: Call stop_machine_text_poke() on all CPUs

Tony Luck (2):
      x86/mce: Make mce_chrdev_ops 'static const'
      random: Fix handing of arch_get_random_long in get_random_bytes()


 arch/x86/include/asm/apic.h             |    1 +
 arch/x86/include/asm/mach_traps.h       |    2 +-
 arch/x86/include/asm/mce.h              |    5 +++-
 arch/x86/include/asm/mrst.h             |    7 +++++
 arch/x86/include/asm/x86_init.h         |    3 ++
 arch/x86/kernel/alternative.c           |    2 +-
 arch/x86/kernel/apic/apic.c             |   33 +++++++++++++++++-----
 arch/x86/kernel/apic/io_apic.c          |    9 ++++--
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c        |   25 +++++++++++++++--
 arch/x86/kernel/nmi.c                   |    3 +-
 arch/x86/kernel/setup.c                 |    2 +
 arch/x86/kernel/x86_init.c              |    4 +++
 arch/x86/platform/mrst/mrst.c           |   46 +++++++++++++++++++++++++++---
 drivers/char/random.c                   |    2 +-
 15 files changed, 122 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9b7273c..1a6c09a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -49,6 +49,7 @@ extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int disable_apic;
+extern unsigned int lapic_timer_frequency;
 
 #ifdef CONFIG_SMP
 extern void __inquire_remote_apic(int apicid);
diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
index 72a8b52..a01e7ec7 100644
--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -17,7 +17,7 @@
 #define NMI_REASON_CLEAR_IOCHK	0x08
 #define NMI_REASON_CLEAR_MASK	0x0f
 
-static inline unsigned char get_nmi_reason(void)
+static inline unsigned char default_get_nmi_reason(void)
 {
 	return inb(NMI_REASON_PORT);
 }
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c9321f3..0e8ae57 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -201,7 +201,10 @@ int mce_notify_irq(void);
 void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
-extern struct file_operations mce_chrdev_ops;
+
+extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
+				    const char __user *ubuf,
+				    size_t usize, loff_t *off));
 
 /*
  * Exception handler
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 719f00b..e628312 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -44,6 +44,13 @@ enum mrst_timer_options {
 
 extern enum mrst_timer_options mrst_timer_options;
 
+/*
+ * Penwell uses spread spectrum clock, so the freq number is not exactly
+ * the same as reported by MSR based on SDM.
+ */
+#define PENWELL_FSB_FREQ_83SKU         83200
+#define PENWELL_FSB_FREQ_100SKU        99840
+
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d3d8590..1971e65 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -152,6 +152,7 @@ struct x86_cpuinit_ops {
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
+ * @wallclock_init:		init the wallclock device
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
@@ -160,11 +161,13 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
+	void (*wallclock_init)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	unsigned char (*get_nmi_reason)(void);
 	int (*i8042_detect)(void);
 };
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c638228..1f84794 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -738,5 +738,5 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a2fd72e..f98d84c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -186,7 +186,7 @@ static struct resource lapic_resource = {
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-static unsigned int calibration_result;
+unsigned int lapic_timer_frequency = 0;
 
 static void apic_pm_activate(void);
 
@@ -454,7 +454,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		__setup_APIC_LVTT(calibration_result,
+		__setup_APIC_LVTT(lapic_timer_frequency,
 				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
@@ -638,6 +638,25 @@ static int __init calibrate_APIC_clock(void)
 	long delta, deltatsc;
 	int pm_referenced = 0;
 
+	/**
+	 * check if lapic timer has already been calibrated by platform
+	 * specific routine, such as tsc calibration code. if so, we just fill
+	 * in the clockevent structure and return.
+	 */
+
+	if (lapic_timer_frequency) {
+		apic_printk(APIC_VERBOSE, "lapic timer already calibrated %d\n",
+				lapic_timer_frequency);
+		lapic_clockevent.mult = div_sc(lapic_timer_frequency/APIC_DIVISOR,
+					TICK_NSEC, lapic_clockevent.shift);
+		lapic_clockevent.max_delta_ns =
+			clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+		lapic_clockevent.min_delta_ns =
+			clockevent_delta2ns(0xF, &lapic_clockevent);
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		return 0;
+	}
+
 	local_irq_disable();
 
 	/* Replace the global interrupt handler */
@@ -679,12 +698,12 @@ static int __init calibrate_APIC_clock(void)
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
+	lapic_timer_frequency = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
 	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
 	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
 	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
-		    calibration_result);
+		    lapic_timer_frequency);
 
 	if (cpu_has_tsc) {
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
@@ -695,13 +714,13 @@ static int __init calibrate_APIC_clock(void)
 
 	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
 		    "%u.%04u MHz.\n",
-		    calibration_result / (1000000 / HZ),
-		    calibration_result % (1000000 / HZ));
+		    lapic_timer_frequency / (1000000 / HZ),
+		    lapic_timer_frequency % (1000000 / HZ));
 
 	/*
 	 * Do a sanity check on the APIC calibration result
 	 */
-	if (calibration_result < (1000000 / HZ)) {
+	if (lapic_timer_frequency < (1000000 / HZ)) {
 		local_irq_enable();
 		pr_warning("APIC frequency too slow, disabling apic timer\n");
 		return -1;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3c31fa9..6d939d7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -193,10 +193,8 @@ int __init arch_early_irq_init(void)
 	struct irq_cfg *cfg;
 	int count, node, i;
 
-	if (!legacy_pic->nr_legacy_irqs) {
-		nr_irqs_gsi = 0;
+	if (!legacy_pic->nr_legacy_irqs)
 		io_apic_irqs = ~0UL;
-	}
 
 	for (i = 0; i < nr_ioapics; i++) {
 		ioapics[i].saved_registers =
@@ -1696,6 +1694,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 	int ioapic_idx;
 	struct irq_cfg *cfg;
 	unsigned int irq;
+	struct irq_chip *chip;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
@@ -1716,6 +1715,10 @@ __apicdebuginit(void) print_IO_APICs(void)
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
+		chip = irq_get_chip(irq);
+		if (chip != &ioapic_chip)
+			continue;
+
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 6199232..319882e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -208,7 +208,7 @@ static int inject_init(void)
 	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
-	mce_chrdev_ops.write = mce_write;
+	register_mce_write_callback(mce_write);
 	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0,
 				"mce_notify");
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 362056a..2af127d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1634,16 +1634,35 @@ static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
 	}
 }
 
-/* Modified in mce-inject.c, so not static or const */
-struct file_operations mce_chrdev_ops = {
+static ssize_t (*mce_write)(struct file *filp, const char __user *ubuf,
+			    size_t usize, loff_t *off);
+
+void register_mce_write_callback(ssize_t (*fn)(struct file *filp,
+			     const char __user *ubuf,
+			     size_t usize, loff_t *off))
+{
+	mce_write = fn;
+}
+EXPORT_SYMBOL_GPL(register_mce_write_callback);
+
+ssize_t mce_chrdev_write(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off)
+{
+	if (mce_write)
+		return mce_write(filp, ubuf, usize, off);
+	else
+		return -EINVAL;
+}
+
+static const struct file_operations mce_chrdev_ops = {
 	.open			= mce_chrdev_open,
 	.release		= mce_chrdev_release,
 	.read			= mce_chrdev_read,
+	.write			= mce_chrdev_write,
 	.poll			= mce_chrdev_poll,
 	.unlocked_ioctl		= mce_chrdev_ioctl,
 	.llseek			= no_llseek,
 };
-EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
 static struct miscdevice mce_chrdev_device = {
 	MISC_MCELOG_MINOR,
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index b9c8628..e88f37b 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -29,6 +29,7 @@
 #include <asm/traps.h>
 #include <asm/mach_traps.h>
 #include <asm/nmi.h>
+#include <asm/x86_init.h>
 
 #define NMI_MAX_NAMELEN	16
 struct nmiaction {
@@ -348,7 +349,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
 	raw_spin_lock(&nmi_reason_lock);
-	reason = get_nmi_reason();
+	reason = x86_platform.get_nmi_reason();
 
 	if (reason & NMI_REASON_MASK) {
 		if (reason & NMI_REASON_SERR)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index afaf384..cf0ef98 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1045,6 +1045,8 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.timers.wallclock_init();
 
+	x86_platform.wallclock_init();
+
 	mcheck_init();
 
 	arch_init_ideal_nops();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 6f164bd..c1d6cd5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -21,12 +21,14 @@
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
+#include <asm/mach_traps.h>
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
+void wallclock_init_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -97,11 +99,13 @@ static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
+	.wallclock_init			= wallclock_init_noop,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
+	.get_nmi_reason			= default_get_nmi_reason,
 	.i8042_detect			= default_i8042_detect
 };
 
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 6ed7afd..9b9ee29 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -187,11 +187,34 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 static unsigned long __init mrst_calibrate_tsc(void)
 {
 	unsigned long flags, fast_calibrate;
-
-	local_irq_save(flags);
-	fast_calibrate = apbt_quick_calibrate();
-	local_irq_restore(flags);
-
+	if (__mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) {
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
+		lapic_timer_frequency = fsb * 1000 / HZ;
+		/* mark tsc clocksource as reliable */
+		set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+	} else {
+		local_irq_save(flags);
+		fast_calibrate = apbt_quick_calibrate();
+		local_irq_restore(flags);
+	}
+	
 	if (fast_calibrate)
 		return fast_calibrate;
 
@@ -254,6 +277,17 @@ static void mrst_reboot(void)
 }
 
 /*
+ * Moorestown does not have external NMI source nor port 0x61 to report
+ * NMI status. The possible NMI sources are from pmu as a result of NMI
+ * watchdog or lock debug. Reading io port 0x61 results in 0xff which
+ * misled NMI handler.
+ */
+static unsigned char mrst_get_nmi_reason(void)
+{
+	return 0;
+}
+
+/*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
  */
@@ -274,6 +308,8 @@ void __init x86_mrst_early_setup(void)
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
 	x86_platform.i8042_detect = mrst_i8042_detect;
 	x86_init.timers.wallclock_init = mrst_rtc_init;
+	x86_platform.get_nmi_reason = mrst_get_nmi_reason;
+
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 63e19ba..6035ab8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -941,7 +941,7 @@ void get_random_bytes(void *buf, int nbytes)
 		if (!arch_get_random_long(&v))
 			break;
 		
-		memcpy(buf, &v, chunk);
+		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
 	}
