Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2JQLON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:14:13 -0400
Received: from mail.x86-64.org ([217.9.48.20]:49971 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab2JQLOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:14:01 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/5] x86, MCA: Finish mca_config conversion
Date: Wed, 17 Oct 2012 13:13:55 +0200
Message-Id: <1350472435-29307-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350472435-29307-1-git-send-email-bp@amd64.org>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

mce_ser, mce_bios_cmci_threshold and mce_disabled are the last three
bools which need conversion. Move them to the mca_config struct and
adjust usage sites accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h                |  5 ++--
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  2 --
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c          | 40 ++++++++++++++-----------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |  6 ++---
 arch/x86/lguest/boot.c                    |  2 +-
 6 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a711e3f4fbc7..d90c2fccc30c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -124,6 +124,9 @@ struct mca_config {
 	bool dont_log_ce;
 	bool cmci_disabled;
 	bool ignore_ce;
+	bool disabled;
+	bool ser;
+	bool bios_cmci_threshold;
 	u8 banks;
 	s8 bootlog;
 	int tolerant;
@@ -140,7 +143,6 @@ extern void mce_unregister_decode_chain(struct notifier_block *nb);
 #include <linux/init.h>
 #include <linux/atomic.h>
 
-extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_MCE
@@ -173,7 +175,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #define MAX_NR_BANKS 32
 
 #ifdef CONFIG_X86_MCE_INTEL
-extern int mce_bios_cmci_threshold;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 6a05c1d327a9..5b7d4fa5d3b7 100644
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
index 13017626f9a8..beb1f1689e52 100644
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
index a66b1c2321d6..326f5b55c858 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -58,18 +58,13 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
-int mce_disabled __read_mostly;
-
 #define SPINUNIT 100	/* 100ns */
 
 atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
-int				mce_ser			__read_mostly;
-int				mce_bios_cmci_threshold	__read_mostly;
-
-struct mce_bank                *mce_banks		__read_mostly;
+struct mce_bank *mce_banks __read_mostly;
 
 struct mca_config mca_cfg __read_mostly = {
 	.bootlog  = -1,
@@ -510,7 +505,7 @@ static int mce_ring_add(unsigned long pfn)
 
 int mce_available(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.disabled)
 		return 0;
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
@@ -562,7 +557,7 @@ static void mce_read_aux(struct mce *m, int i)
 		/*
 		 * Mask the reported address by the reported granularity.
 		 */
-		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
+		if (mca_cfg.ser && (m->status & MCI_STATUS_MISCV)) {
 			u8 shift = MCI_MISC_ADDR_LSB(m->misc);
 			m->addr >>= shift;
 			m->addr <<= shift;
@@ -617,7 +612,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * TBD do the same check for MCI_STATUS_EN here?
 		 */
 		if (!(flags & MCP_UC) &&
-		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
+		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
 		mce_read_aux(&m, i);
@@ -1009,6 +1004,7 @@ static void mce_clear_info(struct mce_info *mi)
  */
 void do_machine_check(struct pt_regs *regs, long error_code)
 {
+	struct mca_config *cfg = &mca_cfg;
 	struct mce m, *final;
 	int i;
 	int worst = 0;
@@ -1036,7 +1032,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	this_cpu_inc(mce_exception_count);
 
-	if (!mca_cfg.banks)
+	if (!cfg->banks)
 		goto out;
 
 	mce_gather_info(&m, regs);
@@ -1063,7 +1059,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * because the first one to see it will clear it.
 	 */
 	order = mce_start(&no_way_out);
-	for (i = 0; i < mca_cfg.banks; i++) {
+	for (i = 0; i < cfg->banks; i++) {
 		__clear_bit(i, toclear);
 		if (!test_bit(i, valid_banks))
 			continue;
@@ -1082,7 +1078,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * Non uncorrected or non signaled errors are handled by
 		 * machine_check_poll. Leave them alone, unless this panics.
 		 */
-		if (!(m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
+		if (!(m.status & (cfg->ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
 			!no_way_out)
 			continue;
 
@@ -1091,7 +1087,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
-		severity = mce_severity(&m, mca_cfg.tolerant, NULL);
+		severity = mce_severity(&m, cfg->tolerant, NULL);
 
 		/*
 		 * When machine check was for corrected handler don't touch,
@@ -1147,7 +1143,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * issues we try to recover, or limit damage to the current
 	 * process.
 	 */
-	if (mca_cfg.tolerant < 3) {
+	if (cfg->tolerant < 3) {
 		if (no_way_out)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
 		if (worst == MCE_AR_SEVERITY) {
@@ -1426,7 +1422,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 		mca_cfg.rip_msr = MSR_IA32_MCG_EIP;
 
 	if (cap & MCG_SER_P)
-		mce_ser = 1;
+		mca_cfg.ser = true;
 
 	return 0;
 }
@@ -1675,7 +1671,7 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
  */
 void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled)
+	if (mca_cfg.disabled)
 		return;
 
 	if (__mcheck_cpu_ancient_init(c))
@@ -1685,7 +1681,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 		return;
 
 	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
-		mce_disabled = 1;
+		mca_cfg.disabled = true;
 		return;
 	}
 
@@ -1967,7 +1963,7 @@ static int __init mcheck_enable(char *str)
 	if (*str == '=')
 		str++;
 	if (!strcmp(str, "off"))
-		mce_disabled = 1;
+		cfg->disabled = true;
 	else if (!strcmp(str, "no_cmci"))
 		cfg->cmci_disabled = true;
 	else if (!strcmp(str, "dont_log_ce"))
@@ -1977,7 +1973,7 @@ static int __init mcheck_enable(char *str)
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		cfg->bootlog = (str[0] == 'b');
 	else if (!strcmp(str, "bios_cmci_threshold"))
-		mce_bios_cmci_threshold = 1;
+		cfg->bios_cmci_threshold = true;
 	else if (isdigit(str[0])) {
 		get_option(&str, &(cfg->tolerant));
 		if (*str == ',') {
@@ -2219,8 +2215,8 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 };
 
 static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
-	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
-	&mce_bios_cmci_threshold
+	__ATTR(bios_cmci_threshold, 0444, device_show_bool, NULL),
+	&mca_cfg.bios_cmci_threshold
 };
 
 static struct device_attribute *mce_device_attrs[] = {
@@ -2441,7 +2437,7 @@ device_initcall_sync(mcheck_init_device);
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_disabled = 1;
+	mca_cfg.disabled = true;
 	return 1;
 }
 __setup("nomce", mcheck_disable);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 1acd8ecba1c3..79b2b6b6e613 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
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
index 642d8805bc1b..df4176cdbb32 100644
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
-- 
1.8.0.rc2.4.g42e55a5

