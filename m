Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1GVO5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:57:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab1GVO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:57:44 -0400
Date: Fri, 22 Jul 2011 16:56:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL] x86/mce changes for v3.1
Message-ID: <20110722145643.GA18046@elte.hu>
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

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

 Thanks,

	Ingo

------------------>
Hidetoshi Seto (11):
      x86, mce, severity: Make formatting a bit more readable
      x86, mce, severity: Cleanup severity table
      x86, mce, severity: Clean up trivial coding style problems
      x86, mce: Replace MCE_SELF_VECTOR by irq_work
      x86, mce: Replace MCM_ with MCI_MISC_
      x86, mce: Introduce mce_gather_info()
      x86, mce: Check the result of ancient_init()
      x86, mce: Cleanup mce_create()/remove_device()
      x86, mce: Cleanup mce_read()
      x86, mce: Use mce_chrdev_ prefix to group functions
      x86, mce: Use mce_sysdev_ prefix to group functions

Tony Luck (1):
      x86, mce, severity: Fix two severities table signatures


 arch/x86/include/asm/entry_arch.h         |    4 -
 arch/x86/include/asm/hw_irq.h             |    1 -
 arch/x86/include/asm/irq_vectors.h        |    5 -
 arch/x86/include/asm/mce.h                |   19 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  152 ++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c          |  288 ++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |   10 +-
 arch/x86/kernel/entry_64.S                |    5 -
 arch/x86/kernel/irqinit.c                 |    3 -
 9 files changed, 251 insertions(+), 236 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 1cd6d26..0baa628 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -53,8 +53,4 @@ BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE
-BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
-#endif
-
 #endif
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..13f5504 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -34,7 +34,6 @@ extern void irq_work_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
-extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..6665026 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -109,11 +109,6 @@
 
 #define UV_BAU_MESSAGE			0xf5
 
-/*
- * Self IPI vector for machine checks
- */
-#define MCE_SELF_VECTOR			0xf4
-
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 021979a..716b48a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -8,6 +8,7 @@
  * Machine Check support for x86
  */
 
+/* MCG_CAP register defines */
 #define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
 #define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
 #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
@@ -17,10 +18,12 @@
 #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
 #define MCG_SER_P	 	(1ULL<<24)   /* MCA recovery/new status bits */
 
+/* MCG_STATUS register defines */
 #define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
 #define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
 
+/* MCi_STATUS register defines */
 #define MCI_STATUS_VAL   (1ULL<<63)  /* valid error */
 #define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
 #define MCI_STATUS_UC    (1ULL<<61)  /* uncorrected error */
@@ -31,12 +34,14 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 
-/* MISC register defines */
-#define MCM_ADDR_SEGOFF  0	/* segment offset */
-#define MCM_ADDR_LINEAR  1	/* linear address */
-#define MCM_ADDR_PHYS	 2	/* physical address */
-#define MCM_ADDR_MEM	 3	/* memory address */
-#define MCM_ADDR_GENERIC 7	/* generic */
+/* MCi_MISC register defines */
+#define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
+#define MCI_MISC_ADDR_MODE(m)	(((m) >> 6) & 7)
+#define  MCI_MISC_ADDR_SEGOFF	0	/* segment offset */
+#define  MCI_MISC_ADDR_LINEAR	1	/* linear address */
+#define  MCI_MISC_ADDR_PHYS	2	/* physical address */
+#define  MCI_MISC_ADDR_MEM	3	/* memory address */
+#define  MCI_MISC_ADDR_GENERIC	7	/* generic */
 
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		(1ULL << 30)
@@ -144,7 +149,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-DECLARE_PER_CPU(struct sys_device, mce_dev);
+DECLARE_PER_CPU(struct sys_device, mce_sysdev);
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 1e8d66c..7395d5f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -43,61 +43,105 @@ static struct severity {
 	unsigned char covered;
 	char *msg;
 } severities[] = {
-#define KERNEL .context = IN_KERNEL
-#define USER .context = IN_USER
-#define SER .ser = SER_REQUIRED
-#define NOSER .ser = NO_SER
-#define SEV(s) .sev = MCE_ ## s ## _SEVERITY
-#define BITCLR(x, s, m, r...) { .mask = x, .result = 0, SEV(s), .msg = m, ## r }
-#define BITSET(x, s, m, r...) { .mask = x, .result = x, SEV(s), .msg = m, ## r }
-#define MCGMASK(x, res, s, m, r...) \
-	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
-#define MASK(x, y, s, m, r...) \
-	{ .mask = x, .result = y, SEV(s), .msg = m, ## r }
+#define MCESEV(s, m, c...) { .sev = MCE_ ## s ## _SEVERITY, .msg = m, ## c }
+#define  KERNEL		.context = IN_KERNEL
+#define  USER		.context = IN_USER
+#define  SER		.ser = SER_REQUIRED
+#define  NOSER		.ser = NO_SER
+#define  BITCLR(x)	.mask = x, .result = 0
+#define  BITSET(x)	.mask = x, .result = x
+#define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
+#define  MASK(x, y)	.mask = x, .result = y
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define MCACOD 0xffff
 
-	BITCLR(MCI_STATUS_VAL, NO, "Invalid"),
-	BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
-	BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
+	MCESEV(
+		NO, "Invalid",
+		BITCLR(MCI_STATUS_VAL)
+		),
+	MCESEV(
+		NO, "Not enabled",
+		BITCLR(MCI_STATUS_EN)
+		),
+	MCESEV(
+		PANIC, "Processor context corrupt",
+		BITSET(MCI_STATUS_PCC)
+		),
 	/* When MCIP is not set something is very confused */
-	MCGMASK(MCG_STATUS_MCIP, 0, PANIC, "MCIP not set in MCA handler"),
+	MCESEV(
+		PANIC, "MCIP not set in MCA handler",
+		MCGMASK(MCG_STATUS_MCIP, 0)
+		),
 	/* Neither return not error IP -- no chance to recover -> PANIC */
-	MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0, PANIC,
-		"Neither restart nor error IP"),
-	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
-		KERNEL),
-	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", NOSER),
-	MASK(MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN, MCI_STATUS_UC, SOME,
-	     "Spurious not enabled", SER),
+	MCESEV(
+		PANIC, "Neither restart nor error IP",
+		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
+		),
+	MCESEV(
+		PANIC, "In kernel and no restart IP",
+		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
+		),
+	MCESEV(
+		KEEP, "Corrected error",
+		NOSER, BITCLR(MCI_STATUS_UC)
+		),
 
 	/* ignore OVER for UCNA */
-	MASK(MCI_UC_SAR, MCI_STATUS_UC, KEEP,
-	     "Uncorrected no action required", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR, PANIC,
-	     "Illegal combination (UCNA with AR=1)", SER),
-	MASK(MCI_STATUS_S, 0, KEEP, "Non signalled machine check", SER),
+	MCESEV(
+		KEEP, "Uncorrected no action required",
+		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
+		),
+	MCESEV(
+		PANIC, "Illegal combination (UCNA with AR=1)",
+		SER,
+		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR)
+		),
+	MCESEV(
+		KEEP, "Non signalled machine check",
+		SER, BITCLR(MCI_STATUS_S)
+		),
 
 	/* AR add known MCACODs here */
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
-	     "Action required with lost events", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_SAR, PANIC,
-	     "Action required; unknown MCACOD", SER),
+	MCESEV(
+		PANIC, "Action required with lost events",
+		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
+		),
+	MCESEV(
+		PANIC, "Action required: unknown MCACOD",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
+		),
 
 	/* known AO MCACODs: */
-	MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0, AO,
-	     "Action optional: memory scrubbing error", SER),
-	MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a, AO,
-	     "Action optional: last level cache writeback error", SER),
-
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S, SOME,
-	     "Action optional unknown MCACOD", SER),
-	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER, SOME,
-	     "Action optional with lost events", SER),
-	BITSET(MCI_STATUS_UC|MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
-	BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
-	BITSET(0, SOME, "No match")	/* always matches. keep at end */
+	MCESEV(
+		AO, "Action optional: memory scrubbing error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
+		),
+	MCESEV(
+		AO, "Action optional: last level cache writeback error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
+		),
+	MCESEV(
+		SOME, "Action optional: unknown MCACOD",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S)
+		),
+	MCESEV(
+		SOME, "Action optional with lost events",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_S)
+		),
+
+	MCESEV(
+		PANIC, "Overflowed uncorrected",
+		BITSET(MCI_STATUS_OVER|MCI_STATUS_UC)
+		),
+	MCESEV(
+		UC, "Uncorrected",
+		BITSET(MCI_STATUS_UC)
+		),
+	MCESEV(
+		SOME, "No match",
+		BITSET(0)
+		)	/* always matches. keep at end */
 };
 
 /*
@@ -112,15 +156,15 @@ static int error_context(struct mce *m)
 	return IN_KERNEL;
 }
 
-int mce_severity(struct mce *a, int tolerant, char **msg)
+int mce_severity(struct mce *m, int tolerant, char **msg)
 {
-	enum context ctx = error_context(a);
+	enum context ctx = error_context(m);
 	struct severity *s;
 
 	for (s = severities;; s++) {
-		if ((a->status & s->mask) != s->result)
+		if ((m->status & s->mask) != s->result)
 			continue;
-		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
+		if ((m->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
 		if (s->ser == SER_REQUIRED && !mce_ser)
 			continue;
@@ -197,15 +241,15 @@ static const struct file_operations severities_coverage_fops = {
 
 static int __init severities_debugfs_init(void)
 {
-	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
+	struct dentry *dmce, *fsev;
 
 	dmce = mce_get_debugfs_dir();
-	if (dmce == NULL)
+	if (!dmce)
 		goto err_out;
-	fseverities_coverage = debugfs_create_file("severities-coverage",
-						   0444, dmce, NULL,
-						   &severities_coverage_fops);
-	if (fseverities_coverage == NULL)
+
+	fsev = debugfs_create_file("severities-coverage", 0444, dmce, NULL,
+				   &severities_coverage_fops);
+	if (!fsev)
 		goto err_out;
 
 	return 0;
@@ -214,4 +258,4 @@ err_out:
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
-#endif
+#endif /* CONFIG_DEBUG_FS */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ff1ae9b..08363b0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -10,7 +10,6 @@
 #include <linux/thread_info.h>
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
-#include <linux/interrupt.h>
 #include <linux/ratelimit.h>
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
@@ -38,23 +37,20 @@
 #include <linux/mm.h>
 #include <linux/debugfs.h>
 #include <linux/edac_mce.h>
+#include <linux/irq_work.h>
 
 #include <asm/processor.h>
-#include <asm/hw_irq.h>
-#include <asm/apic.h>
-#include <asm/idle.h>
-#include <asm/ipi.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
 #include "mce-internal.h"
 
-static DEFINE_MUTEX(mce_read_mutex);
+static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
 	rcu_dereference_index_check((p), \
 			      rcu_read_lock_sched_held() || \
-			      lockdep_is_held(&mce_read_mutex))
+			      lockdep_is_held(&mce_chrdev_read_mutex))
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
@@ -94,7 +90,8 @@ static unsigned long		mce_need_notify;
 static char			mce_helper[128];
 static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
-static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
+static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
+
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
@@ -373,6 +370,31 @@ static void mce_wrmsrl(u32 msr, u64 v)
 }
 
 /*
+ * Collect all global (w.r.t. this processor) status about this machine
+ * check into our "mce" struct so that we can use it later to assess
+ * the severity of the problem as we read per-bank specific details.
+ */
+static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
+{
+	mce_setup(m);
+
+	m->mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
+	if (regs) {
+		/*
+		 * Get the address of the instruction at the time of
+		 * the machine check error.
+		 */
+		if (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV)) {
+			m->ip = regs->ip;
+			m->cs = regs->cs;
+		}
+		/* Use accurate RIP reporting if available. */
+		if (rip_msr)
+			m->ip = mce_rdmsrl(rip_msr);
+	}
+}
+
+/*
  * Simple lockless ring to communicate PFNs from the exception handler with the
  * process context work function. This is vastly simplified because there's
  * only a single reader and a single writer.
@@ -443,40 +465,13 @@ static void mce_schedule_work(void)
 	}
 }
 
-/*
- * Get the address of the instruction at the time of the machine check
- * error.
- */
-static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
-{
-
-	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV))) {
-		m->ip = regs->ip;
-		m->cs = regs->cs;
-	} else {
-		m->ip = 0;
-		m->cs = 0;
-	}
-	if (rip_msr)
-		m->ip = mce_rdmsrl(rip_msr);
-}
+DEFINE_PER_CPU(struct irq_work, mce_irq_work);
 
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Called after interrupts have been reenabled again
- * when a MCE happened during an interrupts off region
- * in the kernel.
- */
-asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+static void mce_irq_work_cb(struct irq_work *entry)
 {
-	ack_APIC_irq();
-	exit_idle();
-	irq_enter();
 	mce_notify_irq();
 	mce_schedule_work();
-	irq_exit();
 }
-#endif
 
 static void mce_report_event(struct pt_regs *regs)
 {
@@ -492,29 +487,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-#ifdef CONFIG_X86_LOCAL_APIC
-	/*
-	 * Without APIC do not notify. The event will be picked
-	 * up eventually.
-	 */
-	if (!cpu_has_apic)
-		return;
-
-	/*
-	 * When interrupts are disabled we cannot use
-	 * kernel services safely. Trigger an self interrupt
-	 * through the APIC to instead do the notification
-	 * after interrupts are reenabled again.
-	 */
-	apic->send_IPI_self(MCE_SELF_VECTOR);
-
-	/*
-	 * Wait for idle afterwards again so that we don't leave the
-	 * APIC in a non idle state because the normal APIC writes
-	 * cannot exclude us.
-	 */
-	apic_wait_icr_idle();
-#endif
+	irq_work_queue(&__get_cpu_var(mce_irq_work));
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
@@ -541,9 +514,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	percpu_inc(mce_poll_count);
 
-	mce_setup(&m);
+	mce_gather_info(&m, NULL);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
@@ -879,9 +851,9 @@ static int mce_usable_address(struct mce *m)
 {
 	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
 		return 0;
-	if ((m->misc & 0x3f) > PAGE_SHIFT)
+	if (MCI_MISC_ADDR_LSB(m->misc) > PAGE_SHIFT)
 		return 0;
-	if (((m->misc >> 6) & 7) != MCM_ADDR_PHYS)
+	if (MCI_MISC_ADDR_MODE(m->misc) != MCI_MISC_ADDR_PHYS)
 		return 0;
 	return 1;
 }
@@ -942,9 +914,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	mce_setup(&m);
+	mce_gather_info(&m, regs);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
@@ -1028,7 +999,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
@@ -1190,7 +1160,8 @@ int mce_notify_irq(void)
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		wake_up_interruptible(&mce_wait);
+		/* wake processes polling /dev/mcelog */
+		wake_up_interruptible(&mce_chrdev_wait);
 
 		/*
 		 * There is no risk of missing notifications because
@@ -1363,18 +1334,23 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
+static int __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
-		return;
+		return 0;
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
+		return 1;
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
+		return 1;
 		break;
 	}
+
+	return 0;
 }
 
 static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
@@ -1428,7 +1404,8 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (mce_disabled)
 		return;
 
-	__mcheck_cpu_ancient_init(c);
+	if (__mcheck_cpu_ancient_init(c))
+		return;
 
 	if (!mce_available(c))
 		return;
@@ -1444,44 +1421,45 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-
+	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
 }
 
 /*
- * Character device to read and clear the MCE log.
+ * mce_chrdev: Character device /dev/mcelog to read and clear the MCE log.
  */
 
-static DEFINE_SPINLOCK(mce_state_lock);
-static int		open_count;		/* #times opened */
-static int		open_exclu;		/* already open exclusive? */
+static DEFINE_SPINLOCK(mce_chrdev_state_lock);
+static int mce_chrdev_open_count;	/* #times opened */
+static int mce_chrdev_open_exclu;	/* already open exclusive? */
 
-static int mce_open(struct inode *inode, struct file *file)
+static int mce_chrdev_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&mce_state_lock);
+	spin_lock(&mce_chrdev_state_lock);
 
-	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
-		spin_unlock(&mce_state_lock);
+	if (mce_chrdev_open_exclu ||
+	    (mce_chrdev_open_count && (file->f_flags & O_EXCL))) {
+		spin_unlock(&mce_chrdev_state_lock);
 
 		return -EBUSY;
 	}
 
 	if (file->f_flags & O_EXCL)
-		open_exclu = 1;
-	open_count++;
+		mce_chrdev_open_exclu = 1;
+	mce_chrdev_open_count++;
 
-	spin_unlock(&mce_state_lock);
+	spin_unlock(&mce_chrdev_state_lock);
 
 	return nonseekable_open(inode, file);
 }
 
-static int mce_release(struct inode *inode, struct file *file)
+static int mce_chrdev_release(struct inode *inode, struct file *file)
 {
-	spin_lock(&mce_state_lock);
+	spin_lock(&mce_chrdev_state_lock);
 
-	open_count--;
-	open_exclu = 0;
+	mce_chrdev_open_count--;
+	mce_chrdev_open_exclu = 0;
 
-	spin_unlock(&mce_state_lock);
+	spin_unlock(&mce_chrdev_state_lock);
 
 	return 0;
 }
@@ -1530,8 +1508,8 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	return 0;
 }
 
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
+static ssize_t mce_chrdev_read(struct file *filp, char __user *ubuf,
+				size_t usize, loff_t *off)
 {
 	char __user *buf = ubuf;
 	unsigned long *cpu_tsc;
@@ -1542,7 +1520,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	if (!cpu_tsc)
 		return -ENOMEM;
 
-	mutex_lock(&mce_read_mutex);
+	mutex_lock(&mce_chrdev_read_mutex);
 
 	if (!mce_apei_read_done) {
 		err = __mce_read_apei(&buf, usize);
@@ -1562,19 +1540,18 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	do {
 		for (i = prev; i < next; i++) {
 			unsigned long start = jiffies;
+			struct mce *m = &mcelog.entry[i];
 
-			while (!mcelog.entry[i].finished) {
+			while (!m->finished) {
 				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
-					       sizeof(struct mce));
+					memset(m, 0, sizeof(*m));
 					goto timeout;
 				}
 				cpu_relax();
 			}
 			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
-			buf += sizeof(struct mce);
+			err |= copy_to_user(buf, m, sizeof(*m));
+			buf += sizeof(*m);
 timeout:
 			;
 		}
@@ -1594,13 +1571,13 @@ timeout:
 	on_each_cpu(collect_tscs, cpu_tsc, 1);
 
 	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
+		struct mce *m = &mcelog.entry[i];
+
+		if (m->finished && m->tsc < cpu_tsc[m->cpu]) {
+			err |= copy_to_user(buf, m, sizeof(*m));
 			smp_rmb();
-			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
+			buf += sizeof(*m);
+			memset(m, 0, sizeof(*m));
 		}
 	}
 
@@ -1608,15 +1585,15 @@ timeout:
 		err = -EFAULT;
 
 out:
-	mutex_unlock(&mce_read_mutex);
+	mutex_unlock(&mce_chrdev_read_mutex);
 	kfree(cpu_tsc);
 
 	return err ? err : buf - ubuf;
 }
 
-static unsigned int mce_poll(struct file *file, poll_table *wait)
+static unsigned int mce_chrdev_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &mce_wait, wait);
+	poll_wait(file, &mce_chrdev_wait, wait);
 	if (rcu_access_index(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	if (!mce_apei_read_done && apei_check_mce())
@@ -1624,7 +1601,8 @@ static unsigned int mce_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
+				unsigned long arg)
 {
 	int __user *p = (int __user *)arg;
 
@@ -1652,16 +1630,16 @@ static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 
 /* Modified in mce-inject.c, so not static or const */
 struct file_operations mce_chrdev_ops = {
-	.open			= mce_open,
-	.release		= mce_release,
-	.read			= mce_read,
-	.poll			= mce_poll,
-	.unlocked_ioctl		= mce_ioctl,
-	.llseek		= no_llseek,
+	.open			= mce_chrdev_open,
+	.release		= mce_chrdev_release,
+	.read			= mce_chrdev_read,
+	.poll			= mce_chrdev_poll,
+	.unlocked_ioctl		= mce_chrdev_ioctl,
+	.llseek			= no_llseek,
 };
 EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
-static struct miscdevice mce_log_device = {
+static struct miscdevice mce_chrdev_device = {
 	MISC_MCELOG_MINOR,
 	"mcelog",
 	&mce_chrdev_ops,
@@ -1719,7 +1697,7 @@ int __init mcheck_init(void)
 }
 
 /*
- * Sysfs support
+ * mce_syscore: PM support
  */
 
 /*
@@ -1739,12 +1717,12 @@ static int mce_disable_error_reporting(void)
 	return 0;
 }
 
-static int mce_suspend(void)
+static int mce_syscore_suspend(void)
 {
 	return mce_disable_error_reporting();
 }
 
-static void mce_shutdown(void)
+static void mce_syscore_shutdown(void)
 {
 	mce_disable_error_reporting();
 }
@@ -1754,18 +1732,22 @@ static void mce_shutdown(void)
  * Only one CPU is active at this time, the others get re-added later using
  * CPU hotplug:
  */
-static void mce_resume(void)
+static void mce_syscore_resume(void)
 {
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(__this_cpu_ptr(&cpu_info));
 }
 
 static struct syscore_ops mce_syscore_ops = {
-	.suspend	= mce_suspend,
-	.shutdown	= mce_shutdown,
-	.resume		= mce_resume,
+	.suspend	= mce_syscore_suspend,
+	.shutdown	= mce_syscore_shutdown,
+	.resume		= mce_syscore_resume,
 };
 
+/*
+ * mce_sysdev: Sysfs support
+ */
+
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
@@ -1801,11 +1783,11 @@ static void mce_enable_ce(void *all)
 		__mcheck_cpu_init_timer();
 }
 
-static struct sysdev_class mce_sysclass = {
+static struct sysdev_class mce_sysdev_class = {
 	.name		= "machinecheck",
 };
 
-DEFINE_PER_CPU(struct sys_device, mce_dev);
+DEFINE_PER_CPU(struct sys_device, mce_sysdev);
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -1934,7 +1916,7 @@ static struct sysdev_ext_attribute attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct sysdev_attribute *mce_attrs[] = {
+static struct sysdev_attribute *mce_sysdev_attrs[] = {
 	&attr_tolerant.attr,
 	&attr_check_interval.attr,
 	&attr_trigger,
@@ -1945,66 +1927,67 @@ static struct sysdev_attribute *mce_attrs[] = {
 	NULL
 };
 
-static cpumask_var_t mce_dev_initialized;
+static cpumask_var_t mce_sysdev_initialized;
 
 /* Per cpu sysdev init. All of the cpus still share the same ctrl bank: */
-static __cpuinit int mce_create_device(unsigned int cpu)
+static __cpuinit int mce_sysdev_create(unsigned int cpu)
 {
+	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
 	int err;
 	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	memset(&per_cpu(mce_dev, cpu).kobj, 0, sizeof(struct kobject));
-	per_cpu(mce_dev, cpu).id	= cpu;
-	per_cpu(mce_dev, cpu).cls	= &mce_sysclass;
+	memset(&sysdev->kobj, 0, sizeof(struct kobject));
+	sysdev->id  = cpu;
+	sysdev->cls = &mce_sysdev_class;
 
-	err = sysdev_register(&per_cpu(mce_dev, cpu));
+	err = sysdev_register(sysdev);
 	if (err)
 		return err;
 
-	for (i = 0; mce_attrs[i]; i++) {
-		err = sysdev_create_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+	for (i = 0; mce_sysdev_attrs[i]; i++) {
+		err = sysdev_create_file(sysdev, mce_sysdev_attrs[i]);
 		if (err)
 			goto error;
 	}
 	for (j = 0; j < banks; j++) {
-		err = sysdev_create_file(&per_cpu(mce_dev, cpu),
-					&mce_banks[j].attr);
+		err = sysdev_create_file(sysdev, &mce_banks[j].attr);
 		if (err)
 			goto error2;
 	}
-	cpumask_set_cpu(cpu, mce_dev_initialized);
+	cpumask_set_cpu(cpu, mce_sysdev_initialized);
 
 	return 0;
 error2:
 	while (--j >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
+		sysdev_remove_file(sysdev, &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
 
-	sysdev_unregister(&per_cpu(mce_dev, cpu));
+	sysdev_unregister(sysdev);
 
 	return err;
 }
 
-static __cpuinit void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_sysdev_remove(unsigned int cpu)
 {
+	struct sys_device *sysdev = &per_cpu(mce_sysdev, cpu);
 	int i;
 
-	if (!cpumask_test_cpu(cpu, mce_dev_initialized))
+	if (!cpumask_test_cpu(cpu, mce_sysdev_initialized))
 		return;
 
-	for (i = 0; mce_attrs[i]; i++)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+	for (i = 0; mce_sysdev_attrs[i]; i++)
+		sysdev_remove_file(sysdev, mce_sysdev_attrs[i]);
 
 	for (i = 0; i < banks; i++)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
+		sysdev_remove_file(sysdev, &mce_banks[i].attr);
 
-	sysdev_unregister(&per_cpu(mce_dev, cpu));
-	cpumask_clear_cpu(cpu, mce_dev_initialized);
+	sysdev_unregister(sysdev);
+	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
@@ -2054,7 +2037,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+		mce_sysdev_create(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
 		break;
@@ -2062,7 +2045,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD_FROZEN:
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
-		mce_remove_device(cpu);
+		mce_sysdev_remove(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -2116,27 +2099,28 @@ static __init int mcheck_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
 
 	mce_init_banks();
 
-	err = sysdev_class_register(&mce_sysclass);
+	err = sysdev_class_register(&mce_sysdev_class);
 	if (err)
 		return err;
 
 	for_each_online_cpu(i) {
-		err = mce_create_device(i);
+		err = mce_sysdev_create(i);
 		if (err)
 			return err;
 	}
 
 	register_syscore_ops(&mce_syscore_ops);
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+
+	/* register character device /dev/mcelog */
+	misc_register(&mce_chrdev_device);
 
 	return err;
 }
-
 device_initcall(mcheck_init_device);
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index bb0adad..f547421 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -548,7 +548,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (!b)
 			goto out;
 
-		err = sysfs_create_link(&per_cpu(mce_dev, cpu).kobj,
+		err = sysfs_create_link(&per_cpu(mce_sysdev, cpu).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -571,7 +571,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out;
 	}
 
-	b->kobj = kobject_create_and_add(name, &per_cpu(mce_dev, cpu).kobj);
+	b->kobj = kobject_create_and_add(name, &per_cpu(mce_sysdev, cpu).kobj);
 	if (!b->kobj)
 		goto out_free;
 
@@ -591,7 +591,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		err = sysfs_create_link(&per_cpu(mce_dev, i).kobj,
+		err = sysfs_create_link(&per_cpu(mce_sysdev, i).kobj,
 					b->kobj, name);
 		if (err)
 			goto out;
@@ -669,7 +669,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&per_cpu(mce_dev, cpu).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_sysdev, cpu).kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -681,7 +681,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		sysfs_remove_link(&per_cpu(mce_dev, i).kobj, name);
+		sysfs_remove_link(&per_cpu(mce_sysdev, i).kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
 	}
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..9fa6546 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -991,11 +991,6 @@ apicinterrupt THRESHOLD_APIC_VECTOR \
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
-#ifdef CONFIG_X86_MCE
-apicinterrupt MCE_SELF_VECTOR \
-	mce_self_interrupt smp_mce_self_interrupt
-#endif
-
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..f09d4bb 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -272,9 +272,6 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
-#endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
