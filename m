Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1E0EJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:09:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33086 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1E0EJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:09:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF23F5.1090206@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:09:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 07/12] x86, mce: introduce mce_gather_info()
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces new function mce_gather_info() to be called
at beginning of error handling, to gather minimum error information
from proper error registers (and saved registers).

As the result the mce_get_rip() is integrated and unnecessary
zero-ing is removed.  This also fix an issue pointed by Tony Luck
that RIP is required to make some decision about error severity
(for SRAR errors) but it was retrieved later in the handler.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   46 +++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e807508..dbdbd60 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -368,6 +368,27 @@ static void mce_wrmsrl(u32 msr, u64 v)
 	wrmsrl(msr, v);
 }
 
+/* Fill struct with minimum info retrieved from registers */
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
 /*
  * Simple lockless ring to communicate PFNs from the exception handler with the
  * process context work function. This is vastly simplified because there's
@@ -439,24 +460,6 @@ static void mce_schedule_work(void)
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
@@ -506,9 +509,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	percpu_inc(mce_poll_count);
 
-	mce_setup(&m);
+	mce_gather_info(&m, NULL);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
@@ -907,9 +909,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	mce_setup(&m);
+	mce_gather_info(&m, regs);
 
-	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
@@ -993,7 +994,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {
-- 
1.7.1


