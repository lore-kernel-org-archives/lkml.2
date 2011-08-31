Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1HaWZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:25:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:44436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab1HaWZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:25:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,309,1312182000"; 
   d="scan'208";a="47278074"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
Subject: [PATCH 2/5] mce: mask out undefined bits from MCi_ADDR
Date: Wed, 31 Aug 2011 15:25:49 -0700
Message-Id: <4e5eb4ed21051e7a15@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	"Luck, Tony" <tony.luck@intel.com>

From: Tony Luck <tony.luck@intel.com>

Move duplicate copies of the code that reads ADDR/MISC registers
to a function. Add masking code for systems that have undefined
low-order bits in the MCi_ADDR register.

Based on original code by Andi Kleen

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Andi originally posted this as two patches - one to move the common
code to the new function "mce_read_aux()", the second to add the
masking.
Seto-san objected to the masking on the grounds that the bits might
contain something useful - but after some thought, I agree with Andi
that it is better to drop undefined bits.

 arch/x86/kernel/cpu/mcheck/mce.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 91bb983..1ce64c3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -490,6 +490,27 @@ static void mce_report_event(struct pt_regs *regs)
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
+		 * Mask the reported address by the reported granuality.
+		 */
+		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
+			u8 shift = m->misc & 0x1f;
+			m->addr >>= shift;
+			m->addr <<= shift;
+		}
+	}
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -540,10 +561,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -984,10 +1002,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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

