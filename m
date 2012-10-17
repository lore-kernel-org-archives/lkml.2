Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2JQLOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:14:35 -0400
Received: from mail.x86-64.org ([217.9.48.20]:49964 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab2JQLOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:14:00 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/5] x86, MCA: Convert dont_log_ce, banks and tolerant
Date: Wed, 17 Oct 2012 13:13:52 +0200
Message-Id: <1350472435-29307-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350472435-29307-1-git-send-email-bp@amd64.org>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move those MCA configuration variables into struct mca_config and adjust
the places they're used accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |  7 +++
 arch/x86/kernel/cpu/mcheck/mce.c | 97 ++++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 54d73b1f00a0..e4060de88476 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -119,6 +119,13 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BASE      (MCE_EXTENDED_BANK + 1)
 
 #ifdef __KERNEL__
+
+struct mca_config {
+	bool dont_log_ce;
+	u8 banks;
+	int tolerant;
+};
+
 extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3b2843..9673629d14d7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -66,20 +66,10 @@ atomic_t mce_entry;
 
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
 static int			rip_msr			__read_mostly;
 static int			mce_bootlog		__read_mostly = -1;
 static int			monarch_timeout		__read_mostly = -1;
 static int			mce_panic_timeout	__read_mostly;
-static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
@@ -87,6 +77,17 @@ int				mce_bios_cmci_threshold	__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
 
+struct mca_config mca_cfg __read_mostly = {
+	/*
+	 * Tolerant levels:
+	 * 0: always panic on uncorrected errors, log corrected errors
+	 * 1: panic or SIGBUS on uncorrected errors, log corrected errors
+	 * 2: SIGBUS or log uncorrected errors (if possible), log corr. errors
+	 * 3: never panic or SIGBUS, log all errors (for testing only)
+	 */
+	.tolerant = 1
+};
+
 /* User mode helper program triggered by machine check event */
 static unsigned long		mce_need_notify;
 static char			mce_helper[128];
@@ -599,7 +600,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	mce_gather_info(&m, NULL);
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
 
@@ -631,7 +632,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
+		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
 			mce_log(&m);
 
 		/*
@@ -658,14 +659,14 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
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
@@ -700,7 +701,7 @@ static int mce_timed_out(u64 *t)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
 		/* CHECKME: Make panic default for 1 too? */
-		if (tolerant < 1)
+		if (mca_cfg.tolerant < 1)
 			mce_panic("Timeout synchronizing machine check over CPUs",
 				  NULL, NULL);
 		cpu_missing = 1;
@@ -750,7 +751,8 @@ static void mce_reign(void)
 	 * Grade the severity of the errors of all the CPUs.
 	 */
 	for_each_possible_cpu(cpu) {
-		int severity = mce_severity(&per_cpu(mces_seen, cpu), tolerant,
+		int severity = mce_severity(&per_cpu(mces_seen, cpu),
+					    mca_cfg.tolerant,
 					    &nmsg);
 		if (severity > global_worst) {
 			msg = nmsg;
@@ -764,7 +766,7 @@ static void mce_reign(void)
 	 * This dumps all the mces in the log buffer and stops the
 	 * other CPUs.
 	 */
-	if (m && global_worst >= MCE_PANIC_SEVERITY && tolerant < 3)
+	if (m && global_worst >= MCE_PANIC_SEVERITY && mca_cfg.tolerant < 3)
 		mce_panic("Fatal Machine check", m, msg);
 
 	/*
@@ -777,7 +779,7 @@ static void mce_reign(void)
 	 * No machine check event found. Must be some external
 	 * source or one CPU is hung. Panic.
 	 */
-	if (global_worst <= MCE_KEEP_SEVERITY && tolerant < 3)
+	if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
 		mce_panic("Machine check from unknown source", NULL, NULL);
 
 	/*
@@ -946,7 +948,7 @@ static void mce_clear_state(unsigned long *toclear)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		if (test_bit(i, toclear))
 			mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
@@ -1022,7 +1024,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	int order;
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
-	 * MCE.  If tolerant is cranked up, we'll try anyway.
+	 * MCE.  If mca_cfg.tolerant is cranked up, we'll try anyway.
 	 */
 	int no_way_out = 0;
 	/*
@@ -1038,7 +1040,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	this_cpu_inc(mce_exception_count);
 
-	if (!banks)
+	if (!mca_cfg.banks)
 		goto out;
 
 	mce_gather_info(&m, regs);
@@ -1065,7 +1067,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * because the first one to see it will clear it.
 	 */
 	order = mce_start(&no_way_out);
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		__clear_bit(i, toclear);
 		if (!test_bit(i, valid_banks))
 			continue;
@@ -1093,7 +1095,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
-		severity = mce_severity(&m, tolerant, NULL);
+		severity = mce_severity(&m, mca_cfg.tolerant, NULL);
 
 		/*
 		 * When machine check was for corrected handler don't touch,
@@ -1117,7 +1119,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * When the ring overflows we just ignore the AO error.
 		 * RED-PEN add some logging mechanism when
 		 * usable_address or mce_add_ring fails.
-		 * RED-PEN don't ignore overflow for tolerant == 0
+		 * RED-PEN don't ignore overflow for mca_cfg.tolerant == 0
 		 */
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
@@ -1149,7 +1151,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * issues we try to recover, or limit damage to the current
 	 * process.
 	 */
-	if (tolerant < 3) {
+	if (mca_cfg.tolerant < 3) {
 		if (no_way_out)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
@@ -1377,11 +1379,13 @@ EXPORT_SYMBOL_GPL(mce_notify_irq);
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
@@ -1401,7 +1405,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	if (!banks)
+	if (!mca_cfg.banks)
 		pr_info("CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
@@ -1411,8 +1415,9 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	}
 
 	/* Don't support asymmetric configurations today */
-	WARN_ON(banks != 0 && b != banks);
-	banks = b;
+	WARN_ON(mca_cfg.banks != 0 && b != mca_cfg.banks);
+	mca_cfg.banks = b;
+
 	if (!mce_banks) {
 		int err = __mcheck_cpu_mce_banks_init();
 
@@ -1448,7 +1453,7 @@ static void __mcheck_cpu_init_generic(void)
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (!b->init)
@@ -1489,6 +1494,8 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 /* Add per CPU specific workarounds here */
 static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
+	struct mca_config *cfg = &mca_cfg;
+
 	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
 		pr_info("unknown CPU type - not enabling MCE support\n");
 		return -EOPNOTSUPP;
@@ -1496,7 +1503,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if (c->x86 == 15 && banks > 4) {
+		if (c->x86 == 15 && cfg->banks > 4) {
 			/*
 			 * disable GART TBL walk error reporting, which
 			 * trips off incorrectly with the IOMMU & 3ware
@@ -1515,7 +1522,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6 && banks > 0)
+		 if (c->x86 == 6 && cfg->banks > 0)
 			mce_banks[0].ctl = 0;
 
 		 /*
@@ -1566,7 +1573,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 * valid event later, merely don't write CTL0.
 		 */
 
-		if (c->x86 == 6 && c->x86_model < 0x1A && banks > 0)
+		if (c->x86 == 6 && c->x86_model < 0x1A && cfg->banks > 0)
 			mce_banks[0].init = 0;
 
 		/*
@@ -1951,6 +1958,8 @@ static struct miscdevice mce_chrdev_device = {
  */
 static int __init mcheck_enable(char *str)
 {
+	struct mca_config *cfg = &mca_cfg;
+
 	if (*str == 0) {
 		enable_p5_mce();
 		return 1;
@@ -1962,7 +1971,7 @@ static int __init mcheck_enable(char *str)
 	else if (!strcmp(str, "no_cmci"))
 		mce_cmci_disabled = 1;
 	else if (!strcmp(str, "dont_log_ce"))
-		mce_dont_log_ce = 1;
+		cfg->dont_log_ce = true;
 	else if (!strcmp(str, "ignore_ce"))
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
@@ -1970,7 +1979,7 @@ static int __init mcheck_enable(char *str)
 	else if (!strcmp(str, "bios_cmci_threshold"))
 		mce_bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
-		get_option(&str, &tolerant);
+		get_option(&str, &(cfg->tolerant));
 		if (*str == ',') {
 			++str;
 			get_option(&str, &monarch_timeout);
@@ -2002,7 +2011,7 @@ static int mce_disable_error_reporting(void)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2190,9 +2199,9 @@ static ssize_t store_int_with_restart(struct device *s,
 }
 
 static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
-static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
+static DEVICE_INT_ATTR(tolerant, 0644, mca_cfg.tolerant);
 static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
-static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static DEVICE_BOOL_ATTR(dont_log_ce, 0644, mca_cfg.dont_log_ce);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
@@ -2259,7 +2268,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 		if (err)
 			goto error;
 	}
-	for (j = 0; j < banks; j++) {
+	for (j = 0; j < mca_cfg.banks; j++) {
 		err = device_create_file(dev, &mce_banks[j].attr);
 		if (err)
 			goto error2;
@@ -2291,7 +2300,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 	for (i = 0; mce_device_attrs[i]; i++)
 		device_remove_file(dev, mce_device_attrs[i]);
 
-	for (i = 0; i < banks; i++)
+	for (i = 0; i < mca_cfg.banks; i++)
 		device_remove_file(dev, &mce_banks[i].attr);
 
 	device_unregister(dev);
@@ -2310,7 +2319,7 @@ static void __cpuinit mce_disable_cpu(void *h)
 
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2328,7 +2337,7 @@ static void __cpuinit mce_reenable_cpu(void *h)
 
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
@@ -2381,7 +2390,7 @@ static __init void mce_init_banks(void)
 {
 	int i;
 
-	for (i = 0; i < banks; i++) {
+	for (i = 0; i < mca_cfg.banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 		struct device_attribute *a = &b->attr;
 
-- 
1.8.0.rc2.4.g42e55a5

