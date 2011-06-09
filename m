Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1FIVby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:31:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:56322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab1FIVbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="16380824"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 03/10] MCE: introduce mce_gather_info()
Date: Thu, 09 Jun 2011 14:31:41 -0700
Message-Id: <4df13bbd272507a0b4@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

This patch introduces new function mce_gather_info() to be called
at beginning of error handling, to gather minimum error information
from proper error registers (and saved registers).

As the result the mce_get_rip() is integrated and unnecessary
zero-ing is removed.  This also fix an issue pointed by Andi Kleen
that RIP is required to make some decision about error severity
(for SRAR errors) but it was retrieved later in the handler.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   50 ++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed1542a..cbd4b0f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -381,6 +381,31 @@ static void mce_wrmsrl(u32 msr, u64 v)
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
@@ -451,24 +476,6 @@ static void mce_schedule_work(void)
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
-
 #ifdef CONFIG_X86_LOCAL_APIC
 /*
  * Called after interrupts have been reenabled again
@@ -549,9 +556,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	percpu_inc(mce_poll_count);
 
-	mce_setup(&m);
+	mce_gather_info(&m, NULL);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
@@ -951,9 +957,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	mce_setup(&m);
+	mce_gather_info(&m, regs);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
@@ -1037,7 +1042,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.7.3.1

