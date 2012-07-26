Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2GZPT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:19:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2GZPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:19:25 -0400
Date: Thu, 26 Jul 2012 08:19:02 -0700
From: tip-bot for Tony Luck <tony.luck@intel.com>
Message-ID: <tip-61b0fccd7f114573f973dfe25d864608822dc09e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com,
        gong.chen@linux.intel.com, bp@amd64.org, ying.huang@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, bp@amd64.org,
        gong.chen@linux.intel.com, ying.huang@intel.com, tglx@linutronix.de
In-Reply-To: <180a06f3f357cf9f78259ae443a082b14a29535b.1343078495.git.tony.luck@intel.com>
References: <180a06f3f357cf9f78259ae443a082b14a29535b.1343078495.git.tony.luck@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce:
  Add quirk for instruction recovery on Sandy Bridge processors
Git-Commit-ID: 61b0fccd7f114573f973dfe25d864608822dc09e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:19:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61b0fccd7f114573f973dfe25d864608822dc09e
Gitweb:     http://git.kernel.org/tip/61b0fccd7f114573f973dfe25d864608822dc09e
Author:     Tony Luck <tony.luck@intel.com>
AuthorDate: Thu, 19 Jul 2012 11:28:46 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 15:05:47 +0200

x86/mce: Add quirk for instruction recovery on Sandy Bridge processors

Sandy Bridge processors follow the SDM (Vol 3B, Table 15-20) and
set both the RIPV and EIPV bits in the MCG_STATUS register to
zero for machine checks during instruction fetch. This is more
than a little counter-intuitive and means that Linux cannot
recover from these errors. Rather than insert special case code
at several places in mce.c and mce-severity.c, we pretend the
EIPV bit was set for just this case early in processing the
machine check.

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/180a06f3f357cf9f78259ae443a082b14a29535b.1343078495.git.tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   43 +++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a5a5dc..8cf60e2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -105,6 +105,8 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -652,14 +654,18 @@ EXPORT_SYMBOL_GPL(machine_check_poll);
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
  */
-static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp)
+static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
+			  struct pt_regs *regs)
 {
 	int i, ret = 0;
 
 	for (i = 0; i < banks; i++) {
 		m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
-		if (m->status & MCI_STATUS_VAL)
+		if (m->status & MCI_STATUS_VAL) {
 			__set_bit(i, validp);
+			if (quirk_no_way_out)
+				quirk_no_way_out(i, m, regs);
+		}
 		if (mce_severity(m, tolerant, msg) >= MCE_PANIC_SEVERITY)
 			ret = 1;
 	}
@@ -1042,7 +1048,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	*final = m;
 
 	memset(valid_banks, 0, sizeof(valid_banks));
-	no_way_out = mce_no_way_out(&m, &msg, valid_banks);
+	no_way_out = mce_no_way_out(&m, &msg, valid_banks, regs);
 
 	barrier();
 
@@ -1418,6 +1424,34 @@ static void __mcheck_cpu_init_generic(void)
 	}
 }
 
+/*
+ * During IFU recovery Sandy Bridge -EP4S processors set the RIPV and
+ * EIPV bits in MCG_STATUS to zero on the affected logical processor (SDM
+ * Vol 3B Table 15-20). But this confuses both the code that determines
+ * whether the machine check occurred in kernel or user mode, and also
+ * the severity assessment code. Pretend that EIPV was set, and take the
+ * ip/cs values from the pt_regs that mce_gather_info() ignored earlier.
+ */
+static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
+{
+	if (bank != 0)
+		return;
+	if ((m->mcgstatus & (MCG_STATUS_EIPV|MCG_STATUS_RIPV)) != 0)
+		return;
+	if ((m->status & (MCI_STATUS_OVER|MCI_STATUS_UC|
+		          MCI_STATUS_EN|MCI_STATUS_MISCV|MCI_STATUS_ADDRV|
+			  MCI_STATUS_PCC|MCI_STATUS_S|MCI_STATUS_AR|
+			  MCACOD)) !=
+			 (MCI_STATUS_UC|MCI_STATUS_EN|
+			  MCI_STATUS_MISCV|MCI_STATUS_ADDRV|MCI_STATUS_S|
+			  MCI_STATUS_AR|MCACOD_INSTR))
+		return;
+
+	m->mcgstatus |= MCG_STATUS_EIPV;
+	m->ip = regs->ip;
+	m->cs = regs->cs;
+}
+
 /* Add per CPU specific workarounds here */
 static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
@@ -1515,6 +1549,9 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		 */
 		if (c->x86 == 6 && c->x86_model <= 13 && mce_bootlog < 0)
 			mce_bootlog = 0;
+
+		if (c->x86 == 6 && c->x86_model == 45)
+			quirk_no_way_out = quirk_sandybridge_ifu;
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
