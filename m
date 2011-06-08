Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1FHB6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:58:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54861 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1FHB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:58:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED71A.1060906@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 10:57:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 07/12] x86, mce: introduce mce_gather_info()
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new function mce_gather_info() to be called
at beginning of error handling, to gather minimum error information
from proper error registers (and saved registers).

As the result the mce_get_rip() is integrated and unnecessary
zero-ing is removed.  This also fix an expected issue that RIP is
required to make some decision about error severity (for SRAR errors)
but it was retrieved later in the handler.

v2:
  update comment (Thanks Tony)

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   50 ++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e807508..a182875 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -369,6 +369,31 @@ static void mce_wrmsrl(u32 msr, u64 v)
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
@@ -439,24 +464,6 @@ static void mce_schedule_work(void)
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
 DEFINE_PER_CPU(struct irq_work, mce_irq_work);
 
 static void mce_irq_work_cb(struct irq_work *entry)
@@ -506,9 +513,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	percpu_inc(mce_poll_count);
 
-	mce_setup(&m);
+	mce_gather_info(&m, NULL);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
@@ -907,9 +913,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	mce_setup(&m);
+	mce_gather_info(&m, regs);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
@@ -993,7 +998,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.7.1


