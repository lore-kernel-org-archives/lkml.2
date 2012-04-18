Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2DRXKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:10:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:10355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2DRXK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="131417578"
Message-Id: <53cdc9cc093af9e4dfd191f7e4185e50f7fc9db3.1334790229.git.tony.luck@intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
Date: Wed, 18 Apr 2012 15:19:40 -0700
Subject: [PATCHv2] x86/mce: Avoid reading every machine check bank register
 twice.
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading machine check bank registers is slow. There is a trend of
increasing the number of banks, and the number of cores. The main section
of do_machine_check() is a serialized section where each cpu in turn
checks every bank. Even on a little two socket SandyBridge-EP system
that multiplies out as:

	2 sockets * 8 cores * 2 hyperthreads * 20 banks = 640 MSRs

We already scan the banks in parallel in mce_no_way_out() to see if there
is a fatal error anywhere in the system. If we build a cache of VALID
bits during this scan, we can avoid uselessly re-reading banks that have
no data. Note that this cache is only a hint. If the valid bit is set in a
shared bank, all cpus that share that bank will see it during the parallel
scan, but the first to find it in the sequential scan will (usually) clear
the bank.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Version 2:
	+ mce_no_way_out() now scans all banks to build the full bitmap (instead of
	  breaking out early if it saw a fatal issue).
	+ changed name of bitmap from "hint" to "valid_banks"

 arch/x86/kernel/cpu/mcheck/mce.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d086a09..66e1c51 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -641,16 +641,18 @@ EXPORT_SYMBOL_GPL(machine_check_poll);
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
  */
-static int mce_no_way_out(struct mce *m, char **msg)
+static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp)
 {
-	int i;
+	int i, ret = 0;
 
 	for (i = 0; i < banks; i++) {
 		m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		if (m->status & MCI_STATUS_VAL)
+			__set_bit(i, validp);
 		if (mce_severity(m, tolerant, msg) >= MCE_PANIC_SEVERITY)
-			return 1;
+			ret = 1;
 	}
-	return 0;
+	return ret;
 }
 
 /*
@@ -1011,6 +1013,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 */
 	int kill_it = 0;
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
+	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
 	atomic_inc(&mce_entry);
@@ -1025,7 +1028,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
-	no_way_out = mce_no_way_out(&m, &msg);
+	memset(valid_banks, 0, sizeof(valid_banks));
+	no_way_out = mce_no_way_out(&m, &msg, valid_banks);
 
 	barrier();
 
@@ -1045,6 +1049,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	order = mce_start(&no_way_out);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
+		if (!test_bit(i, valid_banks))
+			continue;
 		if (!mce_banks[i].ctl)
 			continue;
 
-- 
1.7.9.rc2.1.g69204

