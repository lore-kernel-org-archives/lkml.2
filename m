Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab2JYOTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:19:07 -0400
Received: from mail.x86-64.org ([217.9.48.20]:40940 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759699Ab2JYORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:17:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/5] x86, MCA: Convert rip_msr, mce_bootlog, monarch_timeout
Date: Thu, 25 Oct 2012 16:17:45 +0200
Message-Id: <1351174667-5098-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351174667-5098-1-git-send-email-bp@amd64.org>
References: <1351174667-5098-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Move above configuration variables into struct mca_config and adjust
usage places accordingly.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/mce.h       |  3 +++
 arch/x86/kernel/cpu/mcheck/mce.c | 51 +++++++++++++++++++++-------------------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index e4060de88476..73ba1853951a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -123,7 +123,10 @@ struct mce_log {
 struct mca_config {
 	bool dont_log_ce;
 	u8 banks;
+	s8 bootlog;
 	int tolerant;
+	int monarch_timeout;
+	u32 rip_msr;
 };
 
 extern void mce_register_decode_chain(struct notifier_block *nb);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 10f4d256d9e8..aa11019eeb0e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -66,9 +66,6 @@ atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
-static int			rip_msr			__read_mostly;
-static int			mce_bootlog		__read_mostly = -1;
-static int			monarch_timeout		__read_mostly = -1;
 static int			mce_panic_timeout	__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
@@ -78,6 +75,7 @@ int				mce_bios_cmci_threshold	__read_mostly;
 struct mce_bank                *mce_banks		__read_mostly;
 
 struct mca_config mca_cfg __read_mostly = {
+	.bootlog  = -1,
 	/*
 	 * Tolerant levels:
 	 * 0: always panic on uncorrected errors, log corrected errors
@@ -85,7 +83,8 @@ struct mca_config mca_cfg __read_mostly = {
 	 * 2: SIGBUS or log uncorrected errors (if possible), log corr. errors
 	 * 3: never panic or SIGBUS, log all errors (for testing only)
 	 */
-	.tolerant = 1
+	.tolerant = 1,
+	.monarch_timeout = -1
 };
 
 /* User mode helper program triggered by machine check event */
@@ -373,7 +372,7 @@ static int msr_to_offset(u32 msr)
 {
 	unsigned bank = __this_cpu_read(injectm.bank);
 
-	if (msr == rip_msr)
+	if (msr == mca_cfg.rip_msr)
 		return offsetof(struct mce, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
 		return offsetof(struct mce, status);
@@ -452,8 +451,8 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 				m->cs |= 3;
 		}
 		/* Use accurate RIP reporting if available. */
-		if (rip_msr)
-			m->ip = mce_rdmsrl(rip_msr);
+		if (mca_cfg.rip_msr)
+			m->ip = mce_rdmsrl(mca_cfg.rip_msr);
 	}
 }
 
@@ -697,7 +696,7 @@ static int mce_timed_out(u64 *t)
 	rmb();
 	if (atomic_read(&mce_paniced))
 		wait_for_panic();
-	if (!monarch_timeout)
+	if (!mca_cfg.monarch_timeout)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
 		/* CHECKME: Make panic default for 1 too? */
@@ -803,7 +802,7 @@ static int mce_start(int *no_way_out)
 {
 	int order;
 	int cpus = num_online_cpus();
-	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
 
 	if (!timeout)
 		return -1;
@@ -867,7 +866,7 @@ static int mce_start(int *no_way_out)
 static int mce_end(int order)
 {
 	int ret = -1;
-	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
+	u64 timeout = (u64)mca_cfg.monarch_timeout * NSEC_PER_USEC;
 
 	if (!timeout)
 		goto reset;
@@ -1427,7 +1426,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 
 	/* Use accurate RIP reporting if available. */
 	if ((cap & MCG_EXT_P) && MCG_EXT_CNT(cap) >= 9)
-		rip_msr = MSR_IA32_MCG_EIP;
+		mca_cfg.rip_msr = MSR_IA32_MCG_EIP;
 
 	if (cap & MCG_SER_P)
 		mce_ser = 1;
@@ -1437,15 +1436,19 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 
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
 
@@ -1511,12 +1514,12 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
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
@@ -1581,22 +1584,22 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
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
+	if (cfg->monarch_timeout < 0)
+		cfg->monarch_timeout = 0;
+	if (cfg->bootlog != 0)
 		mce_panic_timeout = 30;
 
 	return 0;
@@ -1975,14 +1978,14 @@ static int __init mcheck_enable(char *str)
 	else if (!strcmp(str, "ignore_ce"))
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
-		mce_bootlog = (str[0] == 'b');
+		cfg->bootlog = (str[0] == 'b');
 	else if (!strcmp(str, "bios_cmci_threshold"))
 		mce_bios_cmci_threshold = 1;
 	else if (isdigit(str[0])) {
 		get_option(&str, &(cfg->tolerant));
 		if (*str == ',') {
 			++str;
-			get_option(&str, &monarch_timeout);
+			get_option(&str, &(cfg->monarch_timeout));
 		}
 	} else {
 		pr_info("mce argument %s ignored. Please use /sys\n", str);
@@ -2200,7 +2203,7 @@ static ssize_t store_int_with_restart(struct device *s,
 
 static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
 static DEVICE_INT_ATTR(tolerant, 0644, mca_cfg.tolerant);
-static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
+static DEVICE_INT_ATTR(monarch_timeout, 0644, mca_cfg.monarch_timeout);
 static DEVICE_BOOL_ATTR(dont_log_ce, 0644, mca_cfg.dont_log_ce);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
-- 
1.8.0

