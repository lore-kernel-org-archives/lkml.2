Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1FPLSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:18:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:45205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1FPLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:18:50 -0400
Date: Thu, 16 Jun 2011 11:18:42 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-b8325c5b110d7ff460b79588e7e9afdcc73d5c3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED71A.1060906@jp.fujitsu.com>
References: <4DEED71A.1060906@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Introduce mce_gather_info()
Git-Commit-ID: b8325c5b110d7ff460b79588e7e9afdcc73d5c3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:18:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8325c5b110d7ff460b79588e7e9afdcc73d5c3c
Gitweb:     http://git.kernel.org/tip/b8325c5b110d7ff460b79588e7e9afdcc73d5c3c
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:57:46 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:10 +0200

x86, mce: Introduce mce_gather_info()

This patch introduces mce_gather_info() which is to be called at the
beginning of error handling and gathers minimum error information from
proper error registers (and saved registers).

As the result of mce_get_rip() is integrated, unnecessary zeroing
is removed. This also takes care of saving RIP which is required to
make some decision about error severity for SRAR errors, instead of
retrieving it later in the handler.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED71A.1060906@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
