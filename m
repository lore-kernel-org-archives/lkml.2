Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2AEO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:59:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab2AEO7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:59:23 -0500
Date: Thu, 5 Jan 2012 15:57:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mce changes for v3.3
Message-ID: <20120105145715.GA7414@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mce-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mce-for-linus


out-of-topic modifications in x86-mce-for-linus:
------------------------------------------------
drivers/edac/i7core_edac.c         # 3653ada: x86, mce: Add wrappers for regist
drivers/edac/mce_amd.c             # 3653ada: x86, mce: Add wrappers for regist
drivers/edac/sb_edac.c             # 3653ada: x86, mce: Add wrappers for regist

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, mce: Add wrappers for registering on the decode chain
      x86, MCE: Drain mcelog buffer

Chen Gong (1):
      x86: add IRQ context simulation in module mce-inject

Fenghua Yu (1):
      x86, mce, therm_throt: Don't report power limit and package level thermal throttle events in mcelog


 arch/x86/include/asm/mce.h               |   12 +++--
 arch/x86/kernel/cpu/mcheck/mce-inject.c  |   34 ++++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce.c         |   64 ++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   29 +++----------
 drivers/edac/i7core_edac.c               |    4 +-
 drivers/edac/mce_amd.c                   |    4 +-
 drivers/edac/sb_edac.c                   |    6 +--
 7 files changed, 107 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0e8ae57..6add827 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -50,10 +50,11 @@
 #define MCJ_CTX_MASK		3
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
 #define MCJ_CTX_RANDOM		0    /* inject context: random */
-#define MCJ_CTX_PROCESS		1    /* inject context: process */
-#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
-#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
-#define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCJ_CTX_PROCESS		0x1  /* inject context: process */
+#define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
+#define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
+#define MCJ_EXCEPTION		0x8  /* raise as exception */
+#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
 
 /* Fields are zero when not available */
 struct mce {
@@ -120,7 +121,8 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
-extern struct atomic_notifier_head x86_mce_decoder_chain;
+extern void mce_register_decode_chain(struct notifier_block *nb);
+extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 #include <linux/percpu.h>
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 319882e..fc4beb3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/notifier.h>
 #include <linux/kdebug.h>
@@ -92,6 +93,18 @@ static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
+static void mce_irq_ipi(void *info)
+{
+	int cpu = smp_processor_id();
+	struct mce *m = &__get_cpu_var(injectm);
+
+	if (cpumask_test_cpu(cpu, mce_inject_cpumask) &&
+			m->inject_flags & MCJ_EXCEPTION) {
+		cpumask_clear_cpu(cpu, mce_inject_cpumask);
+		raise_exception(m, NULL);
+	}
+}
+
 /* Inject mce on current CPU */
 static int raise_local(void)
 {
@@ -139,9 +152,10 @@ static void raise_mce(struct mce *m)
 		return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (m->inject_flags & MCJ_NMI_BROADCAST) {
+	if (m->inject_flags & (MCJ_IRQ_BRAODCAST | MCJ_NMI_BROADCAST)) {
 		unsigned long start;
 		int cpu;
+
 		get_online_cpus();
 		cpumask_copy(mce_inject_cpumask, cpu_online_mask);
 		cpumask_clear_cpu(get_cpu(), mce_inject_cpumask);
@@ -151,13 +165,25 @@ static void raise_mce(struct mce *m)
 			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
 				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
-		if (!cpumask_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
+		if (!cpumask_empty(mce_inject_cpumask)) {
+			if (m->inject_flags & MCJ_IRQ_BRAODCAST) {
+				/*
+				 * don't wait because mce_irq_ipi is necessary
+				 * to be sync with following raise_local
+				 */
+				preempt_disable();
+				smp_call_function_many(mce_inject_cpumask,
+					mce_irq_ipi, NULL, 0);
+				preempt_enable();
+			} else if (m->inject_flags & MCJ_NMI_BROADCAST)
+				apic->send_IPI_mask(mce_inject_cpumask,
+						NMI_VECTOR);
+		}
 		start = jiffies;
 		while (!cpumask_empty(mce_inject_cpumask)) {
 			if (!time_before(jiffies, start + 2*HZ)) {
 				printk(KERN_ERR
-				"Timeout waiting for mce inject NMI %lx\n",
+				"Timeout waiting for mce inject %lx\n",
 					*cpumask_bits(mce_inject_cpumask));
 				break;
 			}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..5be2464 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,13 +95,6 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-/*
- * CPU/chipset specific EDAC code can register a notifier call here to print
- * MCE errors in a human-readable form.
- */
-ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
-EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
-
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
@@ -109,6 +102,12 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+/*
+ * CPU/chipset specific EDAC code can register a notifier call here to print
+ * MCE errors in a human-readable form.
+ */
+ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
+
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
 {
@@ -190,6 +189,57 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+static void drain_mcelog_buffer(void)
+{
+	unsigned int next, i, prev = 0;
+
+	next = rcu_dereference_check_mce(mcelog.next);
+
+	do {
+		struct mce *m;
+
+		/* drain what was logged during boot */
+		for (i = prev; i < next; i++) {
+			unsigned long start = jiffies;
+			unsigned retries = 1;
+
+			m = &mcelog.entry[i];
+
+			while (!m->finished) {
+				if (time_after_eq(jiffies, start + 2*retries))
+					retries++;
+
+				cpu_relax();
+
+				if (!m->finished && retries >= 4) {
+					pr_err("MCE: skipping error being logged currently!\n");
+					break;
+				}
+			}
+			smp_rmb();
+			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+		}
+
+		memset(mcelog.entry + prev, 0, (next - prev) * sizeof(*m));
+		prev = next;
+		next = cmpxchg(&mcelog.next, prev, 0);
+	} while (next != prev);
+}
+
+
+void mce_register_decode_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
+	drain_mcelog_buffer();
+}
+EXPORT_SYMBOL_GPL(mce_register_decode_chain);
+
+void mce_unregister_decode_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
+
 static void print_mce(struct mce *m)
 {
 	int ret = 0;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 787e06c..ce04b58 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -323,17 +323,6 @@ device_initcall(thermal_throttle_init_device);
 
 #endif /* CONFIG_SYSFS */
 
-/*
- * Set up the most two significant bit to notify mce log that this thermal
- * event type.
- * This is a temp solution. May be changed in the future with mce log
- * infrasture.
- */
-#define CORE_THROTTLED		(0)
-#define CORE_POWER_LIMIT	((__u64)1 << 62)
-#define PACKAGE_THROTTLED	((__u64)2 << 62)
-#define PACKAGE_POWER_LIMIT	((__u64)3 << 62)
-
 static void notify_thresholds(__u64 msr_val)
 {
 	/* check whether the interrupt handler is defined;
@@ -363,27 +352,23 @@ static void intel_thermal_interrupt(void)
 	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
 				THERMAL_THROTTLING_EVENT,
 				CORE_LEVEL) != 0)
-		mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
+		mce_log_therm_throt_event(msr_val);
 
 	if (this_cpu_has(X86_FEATURE_PLN))
-		if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
+		therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					CORE_LEVEL) != 0)
-			mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
+					CORE_LEVEL);
 
 	if (this_cpu_has(X86_FEATURE_PTS)) {
 		rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
-		if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
+		therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
 					THERMAL_THROTTLING_EVENT,
-					PACKAGE_LEVEL) != 0)
-			mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
+					PACKAGE_LEVEL);
 		if (this_cpu_has(X86_FEATURE_PLN))
-			if (therm_throt_process(msr_val &
+			therm_throt_process(msr_val &
 					PACKAGE_THERM_STATUS_POWER_LIMIT,
 					POWER_LIMIT_EVENT,
-					PACKAGE_LEVEL) != 0)
-				mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
-							  | msr_val);
+					PACKAGE_LEVEL);
 	}
 }
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..8568d9b 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -2234,7 +2234,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	if (pvt->enable_scrub)
 		disable_sdram_scrub_setting(mci);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &i7_mce_dec);
+	mce_unregister_decode_chain(&i7_mce_dec);
 
 	/* Disable EDAC polling */
 	i7core_pci_ctl_release(pvt);
@@ -2336,7 +2336,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	/* DCLK for scrub rate setting */
 	pvt->dclk_freq = get_dclk_freq();
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &i7_mce_dec);
+	mce_register_decode_chain(&i7_mce_dec);
 
 	return 0;
 
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index d0864d9..bd926ea 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -884,7 +884,7 @@ static int __init mce_amd_init(void)
 
 	pr_info("MCE: In-kernel MCE decoding enabled.\n");
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	mce_register_decode_chain(&amd_mce_dec_nb);
 
 	return 0;
 }
@@ -893,7 +893,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+	mce_unregister_decode_chain(&amd_mce_dec_nb);
 	kfree(fam_ops);
 }
 
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 7a402bf..965bc0c 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1661,8 +1661,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
-					 &sbridge_mce_dec);
+	mce_unregister_decode_chain(&sbridge_mce_dec);
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
@@ -1731,8 +1730,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 		goto fail0;
 	}
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain,
-				       &sbridge_mce_dec);
+	mce_register_decode_chain(&sbridge_mce_dec);
 	return 0;
 
 fail0:
