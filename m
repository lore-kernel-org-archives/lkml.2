Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162274Ab2CSQ7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:59:38 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:56529 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162202Ab2CSQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:59:35 -0400
Date: Mon, 19 Mar 2012 17:59:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] MCE changes for v3.4
Message-ID: <20120319165931.GA13524@gmail.com>
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

   HEAD: ea281a9ebaba3287130dbe15bb0aad6f798bb06b Merge tag 'mce-for-tip' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/mce


out-of-topic modifications in x86-mce-for-linus:
------------------------------------------------
drivers/base/memory.c              # cd42f4a: HWPOISON: Clean up memory_failure
include/linux/mm.h                 # 7329bbe: HWPOISON: Add code to handle "act
                                   # cd42f4a: HWPOISON: Clean up memory_failure
mm/hwpoison-inject.c               # cd42f4a: HWPOISON: Clean up memory_failure
mm/madvise.c                       # cd42f4a: HWPOISON: Clean up memory_failure
mm/memory-failure.c                # 7329bbe: HWPOISON: Add code to handle "act
                                   # cd42f4a: HWPOISON: Clean up memory_failure

 Thanks,

	Ingo

------------------>
Greg Kroah-Hartman (1):
      x86/mce: Convert static array of pointers to per-cpu variables

Naoya Horiguchi (1):
      x86/mce: Fix return value of mce_chrdev_read() when erst is disabled

Tony Luck (7):
      HWPOISON: Clean up memory_failure() vs. __memory_failure()
      HWPOISON: Add code to handle "action required" errors.
      x86/mce: Create helper function to save addr/misc when needed
      x86/mce: Add mechanism to safely save information in MCE handler
      x86/mce: Handle "action required" errors
      x86/mce: Recognise machine check bank signature for data path error
      x86/mce: Replace hard coded hex constants with symbolic defines


 arch/x86/include/asm/mce.h                |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   26 ++++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  193 ++++++++++++++++++++---------
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |    9 +-
 drivers/base/memory.c                     |    2 +-
 include/linux/mm.h                        |    4 +-
 mm/hwpoison-inject.c                      |    4 +-
 mm/madvise.c                              |    2 +-
 mm/memory-failure.c                       |   96 ++++++++-------
 9 files changed, 221 insertions(+), 117 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6aefb14..441520e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-extern struct device *mce_device[CONFIG_NR_CPUS];
+DECLARE_PER_CPU(struct device *, mce_device);
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 7395d5f..0c82091 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -54,7 +54,14 @@ static struct severity {
 #define  MASK(x, y)	.mask = x, .result = y
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
+#define	MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
 #define MCACOD 0xffff
+/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
+#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
+#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
+#define MCACOD_DATA	0x0134	/* Data Load */
+#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
 
 	MCESEV(
 		NO, "Invalid",
@@ -102,11 +109,24 @@ static struct severity {
 		SER, BITCLR(MCI_STATUS_S)
 		),
 
-	/* AR add known MCACODs here */
 	MCESEV(
 		PANIC, "Action required with lost events",
 		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
 		),
+
+	/* known AR MCACODs: */
+#ifdef	CONFIG_MEMORY_FAILURE
+	MCESEV(
+		KEEP, "HT thread notices Action required: data load error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
+		MCGMASK(MCG_STATUS_EIPV, 0)
+		),
+	MCESEV(
+		AR, "Action required: data load error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
+		USER
+		),
+#endif
 	MCESEV(
 		PANIC, "Action required: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
@@ -115,11 +135,11 @@ static struct severity {
 	/* known AO MCACODs: */
 	MCESEV(
 		AO, "Action optional: memory scrubbing error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD_SCRUBMSK, MCI_UC_S|MCACOD_SCRUB)
 		),
 	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|MCACOD_L3WB)
 		),
 	MCESEV(
 		SOME, "Action optional: unknown MCACOD",
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2..c614bd4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -540,6 +540,27 @@ static void mce_report_event(struct pt_regs *regs)
 	irq_work_queue(&__get_cpu_var(mce_irq_work));
 }
 
+/*
+ * Read ADDR and MISC registers.
+ */
+static void mce_read_aux(struct mce *m, int i)
+{
+	if (m->status & MCI_STATUS_MISCV)
+		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
+	if (m->status & MCI_STATUS_ADDRV) {
+		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+
+		/*
+		 * Mask the reported address by the reported granularity.
+		 */
+		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
+			u8 shift = MCI_MISC_ADDR_LSB(m->misc);
+			m->addr >>= shift;
+			m->addr <<= shift;
+		}
+	}
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -590,10 +611,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -917,6 +935,49 @@ static void mce_clear_state(unsigned long *toclear)
 }
 
 /*
+ * Need to save faulting physical address associated with a process
+ * in the machine check handler some place where we can grab it back
+ * later in mce_notify_process()
+ */
+#define	MCE_INFO_MAX	16
+
+struct mce_info {
+	atomic_t		inuse;
+	struct task_struct	*t;
+	__u64			paddr;
+} mce_info[MCE_INFO_MAX];
+
+static void mce_save_info(__u64 addr)
+{
+	struct mce_info *mi;
+
+	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++) {
+		if (atomic_cmpxchg(&mi->inuse, 0, 1) == 0) {
+			mi->t = current;
+			mi->paddr = addr;
+			return;
+		}
+	}
+
+	mce_panic("Too many concurrent recoverable errors", NULL, NULL);
+}
+
+static struct mce_info *mce_find_info(void)
+{
+	struct mce_info *mi;
+
+	for (mi = mce_info; mi < &mce_info[MCE_INFO_MAX]; mi++)
+		if (atomic_read(&mi->inuse) && mi->t == current)
+			return mi;
+	return NULL;
+}
+
+static void mce_clear_info(struct mce_info *mi)
+{
+	atomic_set(&mi->inuse, 0);
+}
+
+/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
@@ -969,7 +1030,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	barrier();
 
 	/*
-	 * When no restart IP must always kill or panic.
+	 * When no restart IP might need to kill or panic.
+	 * Assume the worst for now, but if we find the
+	 * severity is MCE_AR_SEVERITY we have other options.
 	 */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		kill_it = 1;
@@ -1023,16 +1086,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			continue;
 		}
 
-		/*
-		 * Kill on action required.
-		 */
-		if (severity == MCE_AR_SEVERITY)
-			kill_it = 1;
-
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		/*
 		 * Action optional error. Queue address for later processing.
@@ -1052,6 +1106,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
+	/* mce_clear_state will clear *final, save locally for use later */
+	m = *final;
+
 	if (!no_way_out)
 		mce_clear_state(toclear);
 
@@ -1063,27 +1120,22 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		no_way_out = worst >= MCE_PANIC_SEVERITY;
 
 	/*
-	 * If we have decided that we just CAN'T continue, and the user
-	 * has not set tolerant to an insane level, give up and die.
-	 *
-	 * This is mainly used in the case when the system doesn't
-	 * support MCE broadcasting or it has been disabled.
-	 */
-	if (no_way_out && tolerant < 3)
-		mce_panic("Fatal machine check on current CPU", final, msg);
-
-	/*
-	 * If the error seems to be unrecoverable, something should be
-	 * done.  Try to kill as little as possible.  If we can kill just
-	 * one task, do that.  If the user has set the tolerance very
-	 * high, don't try to do anything at all.
+	 * At insane "tolerant" levels we take no action. Otherwise
+	 * we only die if we have no other choice. For less serious
+	 * issues we try to recover, or limit damage to the current
+	 * process.
 	 */
-
-	if (kill_it && tolerant < 3)
-		force_sig(SIGBUS, current);
-
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	if (tolerant < 3) {
+		if (no_way_out)
+			mce_panic("Fatal machine check on current CPU", &m, msg);
+		if (worst == MCE_AR_SEVERITY) {
+			/* schedule action before return to userland */
+			mce_save_info(m.addr);
+			set_thread_flag(TIF_MCE_NOTIFY);
+		} else if (kill_it) {
+			force_sig(SIGBUS, current);
+		}
+	}
 
 	if (worst > 0)
 		mce_report_event(regs);
@@ -1094,34 +1146,57 @@ out:
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
-/* dummy to break dependency. actual code is in mm/memory-failure.c */
-void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
+#ifndef CONFIG_MEMORY_FAILURE
+int memory_failure(unsigned long pfn, int vector, int flags)
 {
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+	/* mce_severity() should not hand us an ACTION_REQUIRED error */
+	BUG_ON(flags & MF_ACTION_REQUIRED);
+	printk(KERN_ERR "Uncorrected memory error in page 0x%lx ignored\n"
+		"Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling\n", pfn);
+
+	return 0;
 }
+#endif
 
 /*
- * Called after mce notification in process context. This code
- * is allowed to sleep. Call the high level VM handler to process
- * any corrupted pages.
- * Assume that the work queue code only calls this one at a time
- * per CPU.
- * Note we don't disable preemption, so this code might run on the wrong
- * CPU. In this case the event is picked up by the scheduled work queue.
- * This is merely a fast path to expedite processing in some common
- * cases.
+ * Called in process context that interrupted by MCE and marked with
+ * TIF_MCE_NOTIFY, just before returning to erroneous userland.
+ * This code is allowed to sleep.
+ * Attempt possible recovery such as calling the high level VM handler to
+ * process any corrupted pages, and kill/signal current process if required.
+ * Action required errors are handled here.
  */
 void mce_notify_process(void)
 {
 	unsigned long pfn;
-	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR);
+	struct mce_info *mi = mce_find_info();
+
+	if (!mi)
+		mce_panic("Lost physical address for unconsumed uncorrectable error", NULL, NULL);
+	pfn = mi->paddr >> PAGE_SHIFT;
+
+	clear_thread_flag(TIF_MCE_NOTIFY);
+
+	pr_err("Uncorrected hardware memory error in user-access at %llx",
+		 mi->paddr);
+	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0) {
+		pr_err("Memory error not recovered");
+		force_sig(SIGBUS, current);
+	}
+	mce_clear_info(mi);
 }
 
+/*
+ * Action optional processing happens here (picking up
+ * from the list of faulting pages that do_machine_check()
+ * placed into the "ring").
+ */
 static void mce_process_work(struct work_struct *dummy)
 {
-	mce_notify_process();
+	unsigned long pfn;
+
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
 #ifdef CONFIG_X86_MCE_INTEL
@@ -1211,8 +1286,6 @@ int mce_notify_irq(void)
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
 
-	clear_thread_flag(TIF_MCE_NOTIFY);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
@@ -1541,6 +1614,12 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	/* Error or no more MCE record */
 	if (rc <= 0) {
 		mce_apei_read_done = 1;
+		/*
+		 * When ERST is disabled, mce_chrdev_read() should return
+		 * "no record" instead of "no device."
+		 */
+		if (rc == -ENODEV)
+			return 0;
 		return rc;
 	}
 	rc = -EFAULT;
@@ -1859,7 +1938,7 @@ static struct bus_type mce_subsys = {
 	.dev_name	= "machinecheck",
 };
 
-struct device *mce_device[CONFIG_NR_CPUS];
+DEFINE_PER_CPU(struct device *, mce_device);
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -2038,7 +2117,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 			goto error2;
 	}
 	cpumask_set_cpu(cpu, mce_device_initialized);
-	mce_device[cpu] = dev;
+	per_cpu(mce_device, cpu) = dev;
 
 	return 0;
 error2:
@@ -2055,7 +2134,7 @@ error:
 
 static __cpuinit void mce_device_remove(unsigned int cpu)
 {
-	struct device *dev = mce_device[cpu];
+	struct device *dev = per_cpu(mce_device, cpu);
 	int i;
 
 	if (!cpumask_test_cpu(cpu, mce_device_initialized))
@@ -2069,7 +2148,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 
 	device_unregister(dev);
 	cpumask_clear_cpu(cpu, mce_device_initialized);
-	mce_device[cpu] = NULL;
+	per_cpu(mce_device, cpu) = NULL;
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index e4eeaaf..99b5717 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -523,7 +523,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	struct device *dev = mce_device[cpu];
+	struct device *dev = per_cpu(mce_device, cpu);
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -587,7 +587,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		dev = mce_device[i];
+		dev = per_cpu(mce_device, i);
 		if (dev)
 			err = sysfs_create_link(&dev->kobj,b->kobj, name);
 		if (err)
@@ -667,7 +667,8 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&mce_device[cpu]->kobj, name);
+		dev = per_cpu(mce_device, cpu);
+		sysfs_remove_link(&dev->kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -679,7 +680,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		dev = mce_device[i];
+		dev = per_cpu(mce_device, i);
 		if (dev)
 			sysfs_remove_link(&dev->kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 9e60dbe..7dda4f7 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -466,7 +466,7 @@ store_hard_offline_page(struct device *dev,
 	if (strict_strtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = __memory_failure(pfn, 0, 0);
+	ret = memory_failure(pfn, 0, 0);
 	return ret ? ret : count;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..3dc8f6b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1598,9 +1598,9 @@ void vmemmap_populate_print_last(void);
 
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
+	MF_ACTION_REQUIRED = 1 << 1,
 };
-extern void memory_failure(unsigned long pfn, int trapno);
-extern int __memory_failure(unsigned long pfn, int trapno, int flags);
+extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index c7fc7fd..cc448bb 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -45,7 +45,7 @@ static int hwpoison_inject(void *data, u64 val)
 	 * do a racy check with elevated page count, to make sure PG_hwpoison
 	 * will only be set for the targeted owner (or on a free page).
 	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
-	 * __memory_failure() will redo the check reliably inside page lock.
+	 * memory_failure() will redo the check reliably inside page lock.
 	 */
 	lock_page(hpage);
 	err = hwpoison_filter(hpage);
@@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u64 val)
 
 inject:
 	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
-	return __memory_failure(pfn, 18, MF_COUNT_INCREASED);
+	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
diff --git a/mm/madvise.c b/mm/madvise.c
index 74bf193..f5ab745 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -251,7 +251,7 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
-		__memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
+		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
 	}
 	return ret;
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 56080ea..0f6033b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -187,33 +187,40 @@ int hwpoison_filter(struct page *p)
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
- * Send all the processes who have the page mapped an ``action optional''
- * signal.
+ * Send all the processes who have the page mapped a signal.
+ * ``action optional'' if they are not immediately affected by the error
+ * ``action required'' if error happened in current execution context
  */
-static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
-			unsigned long pfn, struct page *page)
+static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
+			unsigned long pfn, struct page *page, int flags)
 {
 	struct siginfo si;
 	int ret;
 
 	printk(KERN_ERR
-		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
+		"MCE %#lx: Killing %s:%d due to hardware memory corruption\n",
 		pfn, t->comm, t->pid);
 	si.si_signo = SIGBUS;
 	si.si_errno = 0;
-	si.si_code = BUS_MCEERR_AO;
 	si.si_addr = (void *)addr;
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
 	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
-	/*
-	 * Don't use force here, it's convenient if the signal
-	 * can be temporarily blocked.
-	 * This could cause a loop when the user sets SIGBUS
-	 * to SIG_IGN, but hopefully no one will do that?
-	 */
-	ret = send_sig_info(SIGBUS, &si, t);  /* synchronous? */
+
+	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+		si.si_code = BUS_MCEERR_AR;
+		ret = force_sig_info(SIGBUS, &si, t);
+	} else {
+		/*
+		 * Don't use force here, it's convenient if the signal
+		 * can be temporarily blocked.
+		 * This could cause a loop when the user sets SIGBUS
+		 * to SIG_IGN, but hopefully no one will do that?
+		 */
+		si.si_code = BUS_MCEERR_AO;
+		ret = send_sig_info(SIGBUS, &si, t);  /* synchronous? */
+	}
 	if (ret < 0)
 		printk(KERN_INFO "MCE: Error sending signal to %s:%d: %d\n",
 		       t->comm, t->pid, ret);
@@ -338,8 +345,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
-			  int fail, struct page *page, unsigned long pfn)
+static void kill_procs(struct list_head *to_kill, int doit, int trapno,
+			  int fail, struct page *page, unsigned long pfn,
+			  int flags)
 {
 	struct to_kill *tk, *next;
 
@@ -363,8 +371,8 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 			 * check for that, but we need to tell the
 			 * process anyways.
 			 */
-			else if (kill_proc_ao(tk->tsk, tk->addr, trapno,
-					      pfn, page) < 0)
+			else if (kill_proc(tk->tsk, tk->addr, trapno,
+					      pfn, page, flags) < 0)
 				printk(KERN_ERR
 		"MCE %#lx: Cannot send advisory machine check signal to %s:%d\n",
 					pfn, tk->tsk->comm, tk->tsk->pid);
@@ -844,7 +852,7 @@ static int page_action(struct page_state *ps, struct page *p,
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
 static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int trapno)
+				  int trapno, int flags)
 {
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
@@ -962,8 +970,8 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
-		      ret != SWAP_SUCCESS, p, pfn);
+	kill_procs(&tokill, !!PageDirty(ppage), trapno,
+		      ret != SWAP_SUCCESS, p, pfn, flags);
 
 	return ret;
 }
@@ -984,7 +992,25 @@ static void clear_page_hwpoison_huge_page(struct page *hpage)
 		ClearPageHWPoison(hpage + i);
 }
 
-int __memory_failure(unsigned long pfn, int trapno, int flags)
+/**
+ * memory_failure - Handle memory failure of a page.
+ * @pfn: Page Number of the corrupted page
+ * @trapno: Trap number reported in the signal to user space.
+ * @flags: fine tune action taken
+ *
+ * This function is called by the low level machine check code
+ * of an architecture when it detects hardware memory corruption
+ * of a page. It tries its best to recover, which includes
+ * dropping pages, killing processes etc.
+ *
+ * The function is primarily of use for corruptions that
+ * happen outside the current execution context (e.g. when
+ * detected by a background scrubber)
+ *
+ * Must run in process context (e.g. a work queue) with interrupts
+ * enabled and no spinlocks hold.
+ */
+int memory_failure(unsigned long pfn, int trapno, int flags)
 {
 	struct page_state *ps;
 	struct page *p;
@@ -1130,7 +1156,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
-	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
+	if (hwpoison_user_mappings(p, pfn, trapno, flags) != SWAP_SUCCESS) {
 		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
 		res = -EBUSY;
 		goto out;
@@ -1156,29 +1182,7 @@ out:
 	unlock_page(hpage);
 	return res;
 }
-EXPORT_SYMBOL_GPL(__memory_failure);
-
-/**
- * memory_failure - Handle memory failure of a page.
- * @pfn: Page Number of the corrupted page
- * @trapno: Trap number reported in the signal to user space.
- *
- * This function is called by the low level machine check code
- * of an architecture when it detects hardware memory corruption
- * of a page. It tries its best to recover, which includes
- * dropping pages, killing processes etc.
- *
- * The function is primarily of use for corruptions that
- * happen outside the current execution context (e.g. when
- * detected by a background scrubber)
- *
- * Must run in process context (e.g. a work queue) with interrupts
- * enabled and no spinlocks hold.
- */
-void memory_failure(unsigned long pfn, int trapno)
-{
-	__memory_failure(pfn, trapno, 0);
-}
+EXPORT_SYMBOL_GPL(memory_failure);
 
 #define MEMORY_FAILURE_FIFO_ORDER	4
 #define MEMORY_FAILURE_FIFO_SIZE	(1 << MEMORY_FAILURE_FIFO_ORDER)
@@ -1251,7 +1255,7 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		__memory_failure(entry.pfn, entry.trapno, entry.flags);
+		memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }
 
