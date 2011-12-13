Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1LMTOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:14:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:64874 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab1LMTOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85309307"
Message-Id: <f00f81fe745bf8323f24fa6eeced59f211b01de9.1323803130.git.tony.luck@intel.com>
In-Reply-To: <cover.1323803130.git.tony.luck@intel.com>
References: <cover.1323803130.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 13 Dec 2011 09:48:13 -0800
Subject: [PATCH 3/6] x86, mce: create helper function to save addr/misc when needed
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCI_STATUS_MISCV and MCI_STATUS_ADDRV bits in the bank status
registers define whether the MISC and ADDR registers respectively
contain valid data - provide a helper function to check these bits
and read the registers when needed.

In addition, processors that support software error recovery (as
indicated by the MCG_SER_P bit in the MCG_CAP register) may include
some undefined bits in the ADDR register - mask these out.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 265139d..43f22c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -492,6 +492,27 @@ static void mce_report_event(struct pt_regs *regs)
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
+			u8 shift = m->misc & 0x3f;
+			m->addr >>= shift;
+			m->addr <<= shift;
+		}
+	}
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -542,10 +563,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -981,10 +999,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AR_SEVERITY)
 			kill_it = 1;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		/*
 		 * Action optional error. Queue address for later processing.
-- 
1.7.3.1

