Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2LMSee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:34:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58020 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2LMSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:34:32 -0500
Date: Thu, 13 Dec 2012 19:34:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [GIT PULL, v2] x86/ras changes for v3.8
Message-ID: <20121213183424.GA20454@gmail.com>
References: <20121211111314.GA26721@gmail.com>
 <CA+55aFzPgNd70zmqAoRt3s_A3buOR66jCwHODPC7o_j40G2VXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPgNd70zmqAoRt3s_A3buOR66jCwHODPC7o_j40G2VXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 11, 2012 at 3:13 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > Linus,
> >
> > Please pull the latest x86-ras-for-linus git tree from:
> 
> This is missing the diffstat. Wazzup?

Sorry about that, pilot error ...

Find the updated pull request below.

	Ingo

-------------->

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   HEAD: 003db633d6f2d3649ea18652a3c55ad17d4f0e47 Merge tag 'mca_cfg' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/ras

Rework all config variables used throughout the MCA code and 
collect them together into a mca_config struct. This keeps them 
tightly and neatly packed together instead of spilled all over 
the place.

Then, convert those which are used as booleans into real 
booleans and save some space. These bits are exposed via 
/sys/devices/system/machinecheck/machinecheck*/.

out-of-topic modifications in x86-ras-for-linus:
------------------------------------------------
drivers/base/core.c                # 9187239: drivers/base: Add a DEVICE_BOOL_A
include/linux/device.h             # 9187239: drivers/base: Add a DEVICE_BOOL_A

 Thanks,

	Ingo

------------------>
Borislav Petkov (5):
      drivers/base: Add a DEVICE_BOOL_ATTR macro
      x86, MCA: Convert dont_log_ce, banks and tolerant
      x86, MCA: Convert rip_msr, mce_bootlog, monarch_timeout
      x86, MCA: Convert the next three variables batch
      x86, MCA: Finish mca_config conversion


 arch/x86/include/asm/mce.h                |  21 ++-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   2 -
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c          | 209 +++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   8 +-
 arch/x86/lguest/boot.c                    |   2 +-
 drivers/base/core.c                       |  21 +++
 include/linux/device.h                    |   7 +
 8 files changed, 159 insertions(+), 115 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 54d73b1..d90c2fc 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -119,6 +119,23 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BASE      (MCE_EXTENDED_BANK + 1)
 
 #ifdef __KERNEL__
+
+struct mca_config {
+	bool dont_log_ce;
+	bool cmci_disabled;
+	bool ignore_ce;
+	bool disabled;
+	bool ser;
+	bool bios_cmci_threshold;
+	u8 banks;
+	s8 bootlog;
+	int tolerant;
+	int monarch_timeout;
+	int panic_timeout;
+	u32 rip_msr;
+};
+
+extern struct mca_config mca_cfg;
 extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
@@ -126,7 +143,6 @@ extern void mce_unregister_decode_chain(struct notifier_block *nb);
 #include <linux/init.h>
 #include <linux/atomic.h>
 
-extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_MCE
@@ -159,9 +175,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #define MAX_NR_BANKS 32
 
 #ifdef CONFIG_X86_MCE_INTEL
-extern int mce_cmci_disabled;
-extern int mce_ignore_ce;
-extern int mce_bios_cmci_threshold;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 6a05c1d..5b7d4fa 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -24,8 +24,6 @@ struct mce_bank {
 int mce_severity(struct mce *a, int tolerant, char **msg);
 struct dentry *mce_get_debugfs_dir(void);
 
-extern int mce_ser;
-
 extern struct mce_bank *mce_banks;
 
 #ifdef CONFIG_X86_MCE_INTEL
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 1301762..beb1f16 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -193,9 +193,9 @@ int mce_severity(struct mce *m, int tolerant, char **msg)
 			continue;
 		if ((m->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
-		if (s->ser == SER_REQUIRED && !mce_ser)
+		if (s->ser == SER_REQUIRED && !mca_cfg.ser)
 			continue;
-		if (s->ser == NO_SER && mce_ser)
+		if (s->ser == NO_SER && mca_cfg.ser)
 			continue;
 		if (s->context && ctx != s->context)
 			continue;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 46cbf86..80dbda8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -58,34 +58,26 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
-int mce_disabled __read_mostly;
-
 #define SPINUNIT 100	/* 100ns */
 
 atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
-/*
- * Tolerant levels:
- *   0: always panic on uncorrected errors, log corrected errors
- *   1: panic or SIGBUS on uncorrected errors, log corrected errors
- *   2: SIGBUS or log uncorrected errors (if possible), log corrected errors
- *   3: never panic or SIGBUS, log all errors (for testing only)
- */
-static int			tolerant		__read_mostly = 1;
-static int			banks			__read_mostly;
-static int			rip_msr			__read_mostly;
-static int			mce_bootlog		__read_mostly = -1;
-static int			monarch_timeout		__read_mostly = -1;
-static int			mce_panic_timeout	__read_mostly;
-static int			mce_dont_log_ce		__read_mostly;
-int				mce_cmci_disabled	__read_mostly;
-int				mce_ignore_ce		__read_mostly;
-int				mce_ser			__read_mostly;
-int				mce_bios_cmci_threshold	__read_mostly;
-
-struct mce_bank                *mce_banks		__read_mostly;
+struct mce_bank *mce_banks __read_mostly;
+
+struct mca_config mca_cfg __read_mostly = {
+	.bootlog  = -1,
+	/*
+	 * Tolerant levels:
+	 * 0: always panic on uncorrected errors, log corrected errors
+	 * 1: panic or SIGBUS on uncorrected errors, log corrected errors
+	 * 2: SIGBUS or log uncorrected errors (if possible), log corr. errors
+	 * 3: never panic or SIGBUS, log all errors (for testing only)
+	 */
+	.tolerant = 1,
+	.monarch_timeout = -1
+};
 
 /* User mode helper program triggered by machine check event */
 static unsigned long		mce_need_notify;
@@ -302,7 +294,7 @@ static void wait_for_panic(void)
 	while (timeout-- > 0)
 		udelay(1);
 	if (panic_timeout == 0)
-		panic_timeout = mce_panic_timeout;
+		panic_timeout = mca_cfg.panic_timeout;
 	panic("Panicing machine check CPU died");
 }
 
@@ -360,7 +352,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
 		if (panic_timeout == 0)
-			panic_timeout = mce_panic_timeout;
+			panic_timeout = mca_cfg.panic_timeout;
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
@@ -372,7 +364,7 @@ static int msr_to_offset(u32 msr)
 {
 	unsigned bank = __this_cpu_read(injectm.bank);
 
-	if (msr == rip_msr)
+	if (msr == mca_cfg.rip_msr)
 		return offsetof(struct mce, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
 		return offsetof(struct mce, status);
@@ -451,8 +443,8 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 				m->cs |= 3;
 		}
 		/* Use accurate RIP reporting if available. */
-		if (rip_msr)
-			m->ip = mce_rdmsrl(rip_msr);
+		if (mca_cfg.rip_msr)
+			m->ip = mce_rdmsrl(mca_cfg.rip_msr);
 	}
 }
 
@@ -513,7 +505,7 @@ static int mce_ring_add(unsigned long pfn)
 
 int mce_available(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.disabled)
 		return 0;
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
@@ -565,7 +557,7 @@ static void mce_read_aux(struct mce *m, int i)
 		/*
 		 * Mask the reported address by the reported granularity.
 		 */
-		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
+		if (mca_cfg.ser && (m->status & MCI_STATUS_MISCV)) {
 			u8 shift = MCI_MISC_ADDR_LSB(m->misc);
 			m->addr >>= shift;
 			m->addr <<= shift;
@@ -599,7 +591,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	mce_gather_info(&m, NULL);
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
 
@@ -620,7 +612,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * TBD do the same check for MCI_STATUS_EN here?
 		 */
 		if (!(flags & MCP_UC) &&
-		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
+		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
 		mce_read_aux(&m, i);
@@ -631,7 +623,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
+		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
 			mce_log(&m);
 
 		/*
@@ -658,14 +650,14 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 {
 	int i, ret = 0;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
 		if (m->status & MCI_STATUS_VAL) {
 			__set_bit(i, validp);
 			if (quirk_no_way_out)
 				quirk_no_way_out(i, m, regs);
 		}
-		if (mce_severity(m, tolerant, msg) >= MCE_PANIC_SEVERITY)
+		if (mce_severity(m, mca_cfg.tolerant, msg) >= MCE_PANIC_SEVERITY)
 			ret = 1;
 	}
 	return ret;
@@ -696,11 +688,11 @@ static int mce_timed_out(u64 *t)
 	rmb();
 	if (atomic_read(&mce_paniced))
 		wait_for_panic();
-	if (!monarch_timeout)
+	if (!mca_cfg.monarch_timeout)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
 		/* CHECKME: Make panic default for 1 too? */
-		if (tolerant < 1)
+		if (mca_cfg.tolerant < 1)
 			mce_panic("Timeout synchronizing machine check over CPUs",
 				  NULL, NULL);
 		cpu_missing = 1;
@@ -750,7 +742,8 @@ static void mce_reign(void)
 	 * Grade the severity of the errors of all the CPUs.
 	 */
 	for_each_possible_cpu(cpu) {
-		int severity = mce_severity(&per_cpu(mces_seen, cpu), tolerant,
+		int severity = mce_severity(&per_cpu(mces_seen, cpu),
+					    mca_cfg.tolerant,
 					    &nmsg);
 		if (severity > global_worst) {
 			msg = nmsg;
@@ -764,7 +757,7 @@ static void mce_reign(void)
 	 * This dumps all the mces in the log buffer and stops the
 	 * other CPUs.
 	 */
-	if (m && global_worst >= MCE_PANIC_SEVERITY && tolerant < 3)
+	if (m && global_worst >= MCE_PANIC_SEVERITY && mca_cfg.tolerant < 3)
 		mce_panic("Fatal Machine check", m, msg);
 
 	/*
@@ -777,7 +770,7 @@ static void mce_reign(void)
 	 * No machine check event found. Must be some external
 	 * source or one CPU is hung. Panic.
 	 */
-	if (global_worst <= MCE_KEEP_SEVERITY && tolerant < 3)
+	if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
 		mce_panic("Machine check from unknown source", NULL, NULL);
 
 	/*
@@ -801,7 +794,7 @@ static int mce_start(int *no_way_out)
 {
 	int order;
 	int cpus = num_online_cpus();
-	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
 
 	if (!timeout)
 		return -1;
@@ -865,7 +858,7 @@ static int mce_start(int *no_way_out)
 static int mce_end(int order)
 {
 	int ret = -1;
-	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
 
 	if (!timeout)
 		goto reset;
@@ -946,7 +939,7 @@ static void mce_clear_state(unsigned long *toclear)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		if (test_bit(i, toclear))
 			mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
@@ -1011,6 +1004,7 @@ static void mce_clear_info(struct mce_info *mi)
  */
 void do_machine_check(struct pt_regs *regs, long error_code)
 {
+	struct mca_config *cfg = &mca_cfg;
 	struct mce m, *final;
 	int i;
 	int worst = 0;
@@ -1022,7 +1016,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	int order;
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
-	 * MCE.  If tolerant is cranked up, we'll try anyway.
+	 * MCE.  If mca_cfg.tolerant is cranked up, we'll try anyway.
 	 */
 	int no_way_out = 0;
 	/*
@@ -1038,7 +1032,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	this_cpu_inc(mce_exception_count);
 
-	if (!banks)
+	if (!cfg->banks)
 		goto out;
 
 	mce_gather_info(&m, regs);
@@ -1065,7 +1059,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * because the first one to see it will clear it.
 	 */
 	order = mce_start(&no_way_out);
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < cfg->banks; i++) {
 		__clear_bit(i, toclear);
 		if (!test_bit(i, valid_banks))
 			continue;
@@ -1084,7 +1078,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * Non uncorrected or non signaled errors are handled by
 		 * machine_check_poll. Leave them alone, unless this panics.
 		 */
-		if (!(m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
+		if (!(m.status & (cfg->ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
 			!no_way_out)
 			continue;
 
@@ -1093,7 +1087,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
-		severity = mce_severity(&m, tolerant, NULL);
+		severity = mce_severity(&m, cfg->tolerant, NULL);
 
 		/*
 		 * When machine check was for corrected handler don't touch,
@@ -1117,7 +1111,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * When the ring overflows we just ignore the AO error.
 		 * RED-PEN add some logging mechanism when
 		 * usable_address or mce_add_ring fails.
-		 * RED-PEN don't ignore overflow for tolerant == 0
+		 * RED-PEN don't ignore overflow for mca_cfg.tolerant == 0
 		 */
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
@@ -1149,7 +1143,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * issues we try to recover, or limit damage to the current
 	 * process.
 	 */
-	if (tolerant < 3) {
+	if (cfg->tolerant < 3) {
 		if (no_way_out)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
@@ -1377,11 +1371,13 @@ EXPORT_SYMBOL_GPL(mce_notify_irq);
 static int __cpuinit __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
+	u8 num_banks = mca_cfg.banks;
 
-	mce_banks = kzalloc(banks * sizeof(struct mce_bank), GFP_KERNEL);
+	mce_banks = kzalloc(num_banks * sizeof(struct mce_bank), GFP_KERNEL);
 	if (!mce_banks)
 		return -ENOMEM;
-	for (i = 0; i < banks; i++) {
+
+	for (i = 0; i < num_banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		b->ctl = -1ULL;
@@ -1401,7 +1397,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	if (!banks)
+	if (!mca_cfg.banks)
 		pr_info("CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
@@ -1411,8 +1407,9 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	}
 
 	/* Don't support asymmetric configurations today */
-	WARN_ON(banks != 0 && b != banks);
-	banks = b;
+	WARN_ON(mca_cfg.banks != 0 && b != mca_cfg.banks);
+	mca_cfg.banks = b;
+
 	if (!mce_banks) {
 		int err = __mcheck_cpu_mce_banks_init();
 
@@ -1422,25 +1419,29 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 
 	/* Use accurate RIP reporting if available. */
 	if ((cap & MCG_EXT_P) && MCG_EXT_CNT(cap) >= 9)
-		rip_msr = MSR_IA32_MCG_EIP;
+		mca_cfg.rip_msr = MSR_IA32_MCG_EIP;
 
 	if (cap & MCG_SER_P)
-		mce_ser = 1;
+		mca_cfg.ser = true;
 
 	return 0;
 }
 
 static void __mcheck_cpu_init_generic(void)
 {
+	enum mcp_flags m_fl = 0;
 	mce_banks_t all_banks;
 	u64 cap;
 	int i;
 
+	if (!mca_cfg.bootlog)
+		m_fl = MCP_DONTLOG;
+
 	/*
 	 * Log the machine checks left over from the previous reset.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
-	machine_check_poll(MCP_UC|(!mce_bootlog ? MCP_DONTLOG : 0), &all_banks);
+	machine_check_poll(MCP_UC | m_fl, &all_banks);
 
 	set_in_cr4(X86_CR4_MCE);
 
@@ -1448,7 +1449,7 @@ static void __mcheck_cpu_init_generic(void)
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (!b->init)
@@ -1489,6 +1490,8 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 /* Add per CPU specific workarounds here */
 static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
+	struct mca_config *cfg = &mca_cfg;
+
 	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
 		pr_info("unknown CPU type - not enabling MCE support\n");
 		return -EOPNOTSUPP;
@@ -1496,7 +1499,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if (c->x86 == 15 && banks > 4) {
+		if (c->x86 == 15 && cfg->banks > 4) {
 			/*
 			 * disable GART TBL walk error reporting, which
 			 * trips off incorrectly with the IOMMU & 3ware
@@ -1504,18 +1507,18 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 			 */
 			clear_bit(10, (unsigned long *)&mce_banks[4].ctl);
 		}
-		if (c->x86 <= 17 && mce_bootlog < 0) {
+		if (c->x86 <= 17 && cfg->bootlog < 0) {
 			/*
 			 * Lots of broken BIOS around that don't clear them
 			 * by default and leave crap in there. Don't log:
 			 */
-			mce_bootlog = 0;
+			cfg->bootlog = 0;
 		}
 		/*
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6 && banks > 0)
+		 if (c->x86 == 6 && cfg->banks > 0)
 			mce_banks[0].ctl = 0;
 
 		 /*
@@ -1566,7 +1569,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 * valid event later, merely don't write CTL0.
 		 */
 
-		if (c->x86 == 6 && c->x86_model < 0x1A && banks > 0)
+		if (c->x86 == 6 && c->x86_model < 0x1A && cfg->banks > 0)
 			mce_banks[0].init = 0;
 
 		/*
@@ -1574,23 +1577,23 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 * synchronization with a one second timeout.
 		 */
 		if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
-			monarch_timeout < 0)
-			monarch_timeout = USEC_PER_SEC;
+			cfg->monarch_timeout < 0)
+			cfg->monarch_timeout = USEC_PER_SEC;
 
 		/*
 		 * There are also broken BIOSes on some Pentium M and
 		 * earlier systems:
 		 */
-		if (c->x86 == 6 && c->x86_model <= 13 && mce_bootlog < 0)
-			mce_bootlog = 0;
+		if (c->x86 == 6 && c->x86_model <= 13 && cfg->bootlog < 0)
+			cfg->bootlog = 0;
 
 		if (c->x86 == 6 && c->x86_model == 45)
 			quirk_no_way_out = quirk_sandybridge_ifu;
 	}
-	if (monarch_timeout < 0)
-		monarch_timeout = 0;
-	if (mce_bootlog != 0)
-		mce_panic_timeout = 30;
+	if (cfg->monarch_timeout < 0)
+		cfg->monarch_timeout = 0;
+	if (cfg->bootlog != 0)
+		cfg->panic_timeout = 30;
 
 	return 0;
 }
@@ -1635,7 +1638,7 @@ static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 
 	__this_cpu_write(mce_next_interval, iv);
 
-	if (mce_ignore_ce || !iv)
+	if (mca_cfg.ignore_ce || !iv)
 		return;
 
 	t->expires = round_jiffies(jiffies + iv);
@@ -1668,7 +1671,7 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
  */
 void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.disabled)
 		return;
 
 	if (__mcheck_cpu_ancient_init(c))
@@ -1678,7 +1681,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 		return;
 
 	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
-		mce_disabled = 1;
+		mca_cfg.disabled = true;
 		return;
 	}
 
@@ -1951,6 +1954,8 @@ static struct miscdevice mce_chrdev_device = {
  */
 static int __init mcheck_enable(char *str)
 {
+	struct mca_config *cfg = &mca_cfg;
+
 	if (*str == 0) {
 		enable_p5_mce();
 		return 1;
@@ -1958,22 +1963,22 @@ static int __init mcheck_enable(char *str)
 	if (*str == '=')
 		str++;
 	if (!strcmp(str, "off"))
-		mce_disabled = 1;
+		cfg->disabled = true;
 	else if (!strcmp(str, "no_cmci"))
-		mce_cmci_disabled = 1;
+		cfg->cmci_disabled = true;
 	else if (!strcmp(str, "dont_log_ce"))
-		mce_dont_log_ce = 1;
+		cfg->dont_log_ce = true;
 	else if (!strcmp(str, "ignore_ce"))
-		mce_ignore_ce = 1;
+		cfg->ignore_ce = true;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
-		mce_bootlog = (str[0] == 'b');
+		cfg->bootlog = (str[0] == 'b');
 	else if (!strcmp(str, "bios_cmci_threshold"))
-		mce_bios_cmci_threshold = 1;
+		cfg->bios_cmci_threshold = true;
 	else if (isdigit(str[0])) {
-		get_option(&str, &tolerant);
+		get_option(&str, &(cfg->tolerant));
 		if (*str == ',') {
 			++str;
-			get_option(&str, &monarch_timeout);
+			get_option(&str, &(cfg->monarch_timeout));
 		}
 	} else {
 		pr_info("mce argument %s ignored. Please use /sys\n", str);
@@ -2002,7 +2007,7 @@ static int mce_disable_error_reporting(void)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2142,15 +2147,15 @@ static ssize_t set_ignore_ce(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_ignore_ce ^ !!new) {
+	if (mca_cfg.ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
 			mce_timer_delete_all();
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_ignore_ce = 1;
+			mca_cfg.ignore_ce = true;
 		} else {
 			/* enable ce features */
-			mce_ignore_ce = 0;
+			mca_cfg.ignore_ce = false;
 			on_each_cpu(mce_enable_ce, (void *)1, 1);
 		}
 	}
@@ -2166,14 +2171,14 @@ static ssize_t set_cmci_disabled(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_cmci_disabled ^ !!new) {
+	if (mca_cfg.cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_cmci_disabled = 1;
+			mca_cfg.cmci_disabled = true;
 		} else {
 			/* enable cmci */
-			mce_cmci_disabled = 0;
+			mca_cfg.cmci_disabled = false;
 			on_each_cpu(mce_enable_ce, NULL, 1);
 		}
 	}
@@ -2190,9 +2195,9 @@ static ssize_t store_int_with_restart(struct device *s,
 }
 
 static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
-static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
-static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
-static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static DEVICE_INT_ATTR(tolerant, 0644, mca_cfg.tolerant);
+static DEVICE_INT_ATTR(monarch_timeout, 0644, mca_cfg.monarch_timeout);
+static DEVICE_BOOL_ATTR(dont_log_ce, 0644, mca_cfg.dont_log_ce);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
@@ -2200,13 +2205,13 @@ static struct dev_ext_attribute dev_attr_check_interval = {
 };
 
 static struct dev_ext_attribute dev_attr_ignore_ce = {
-	__ATTR(ignore_ce, 0644, device_show_int, set_ignore_ce),
-	&mce_ignore_ce
+	__ATTR(ignore_ce, 0644, device_show_bool, set_ignore_ce),
+	&mca_cfg.ignore_ce
 };
 
 static struct dev_ext_attribute dev_attr_cmci_disabled = {
-	__ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
-	&mce_cmci_disabled
+	__ATTR(cmci_disabled, 0644, device_show_bool, set_cmci_disabled),
+	&mca_cfg.cmci_disabled
 };
 
 static struct device_attribute *mce_device_attrs[] = {
@@ -2253,7 +2258,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 		if (err)
 			goto error;
 	}
-	for (j = 0; j < banks; j++) {
+	for (j = 0; j < mca_cfg.banks; j++) {
 		err = device_create_file(dev, &mce_banks[j].attr);
 		if (err)
 			goto error2;
@@ -2285,7 +2290,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 	for (i = 0; mce_device_attrs[i]; i++)
 		device_remove_file(dev, mce_device_attrs[i]);
 
-	for (i = 0; i < banks; i++)
+	for (i = 0; i < mca_cfg.banks; i++)
 		device_remove_file(dev, &mce_banks[i].attr);
 
 	device_unregister(dev);
@@ -2304,7 +2309,7 @@ static void __cpuinit mce_disable_cpu(void *h)
 
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2322,7 +2327,7 @@ static void __cpuinit mce_reenable_cpu(void *h)
 
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2375,7 +2380,7 @@ static __init void mce_init_banks(void)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 		struct device_attribute *a = &b->attr;
 
@@ -2426,7 +2431,7 @@ device_initcall_sync(mcheck_init_device);
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_disabled = 1;
+	mca_cfg.disabled = true;
 	return 1;
 }
 __setup("nomce", mcheck_disable);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 5f88abf..79b2b6b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -53,7 +53,7 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
-	if (mce_cmci_disabled || mce_ignore_ce)
+	if (mca_cfg.cmci_disabled || mca_cfg.ignore_ce)
 		return 0;
 
 	/*
@@ -200,7 +200,7 @@ static void cmci_discover(int banks)
 			continue;
 		}
 
-		if (!mce_bios_cmci_threshold) {
+		if (!mca_cfg.bios_cmci_threshold) {
 			val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
 			val |= CMCI_THRESHOLD;
 		} else if (!(val & MCI_CTL2_CMCI_THRESHOLD_MASK)) {
@@ -227,7 +227,7 @@ static void cmci_discover(int banks)
 			 * set the thresholds properly or does not work with
 			 * this boot option. Note down now and report later.
 			 */
-			if (mce_bios_cmci_threshold && bios_zero_thresh &&
+			if (mca_cfg.bios_cmci_threshold && bios_zero_thresh &&
 					(val & MCI_CTL2_CMCI_THRESHOLD_MASK))
 				bios_wrong_thresh = 1;
 		} else {
@@ -235,7 +235,7 @@ static void cmci_discover(int banks)
 		}
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
-	if (mce_bios_cmci_threshold && bios_wrong_thresh) {
+	if (mca_cfg.bios_cmci_threshold && bios_wrong_thresh) {
 		pr_info_once(
 			"bios_cmci_threshold: Some banks do not have valid thresholds set\n");
 		pr_info_once(
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 642d880..df4176c 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1412,7 +1412,7 @@ __init void lguest_init(void)
 
 	/* We don't have features.  We have puppies!  Puppies! */
 #ifdef CONFIG_X86_MCE
-	mce_disabled = 1;
+	mca_cfg.disabled = true;
 #endif
 #ifdef CONFIG_ACPI
 	acpi_disabled = 1;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c..c8ae1f6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -171,6 +171,27 @@ ssize_t device_show_int(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_show_int);
 
+ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t size)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+
+	if (strtobool(buf, ea->var) < 0)
+		return -EINVAL;
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(device_store_bool);
+
+ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", *(bool *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(device_show_bool);
+
 /**
  *	device_release - free device structure.
  *	@kobj:	device's kobject.
diff --git a/include/linux/device.h b/include/linux/device.h
index 86ef6ab..50c85a2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -496,6 +496,10 @@ ssize_t device_show_int(struct device *dev, struct device_attribute *attr,
 			char *buf);
 ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
+			char *buf);
+ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
 
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
@@ -505,6 +509,9 @@ ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
+#define DEVICE_BOOL_ATTR(_name, _mode, _var) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, _mode, device_show_bool, device_store_bool), &(_var) }
 #define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
