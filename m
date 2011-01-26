Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1AZMNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:13:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:39778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1AZMNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:13:22 -0500
Date: Wed, 26 Jan 2011 12:12:40 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292980144-28796-4-git-send-email-venki@google.com>
References: <1292980144-28796-4-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Refactor account_system_time separating id-update
Message-ID: <tip-70a89a6620f658d47a1488515bada4b8ee6291d8@git.kernel.org>
Git-Commit-ID: 70a89a6620f658d47a1488515bada4b8ee6291d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:12:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70a89a6620f658d47a1488515bada4b8ee6291d8
Gitweb:     http://git.kernel.org/tip/70a89a6620f658d47a1488515bada4b8ee6291d8
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 21 Dec 2010 17:09:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:21 +0100

sched: Refactor account_system_time separating id-update

Refactor account_system_time, to separate out the logic of
identifying the update needed and code that does actual update.

This is used by following patch for IRQ_TIME_ACCOUNTING,
which has different identification logic and same update logic.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292980144-28796-4-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8b89b3b..e3fa921 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3568,6 +3568,32 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 }
 
 /*
+ * Account system cpu time to a process and desired cpustat field
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ * @target_cputime64: pointer to cpustat field that has to be updated
+ */
+static inline
+void __account_system_time(struct task_struct *p, cputime_t cputime,
+			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+{
+	cputime64_t tmp = cputime_to_cputime64(cputime);
+
+	/* Add system time to process. */
+	p->stime = cputime_add(p->stime, cputime);
+	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
+	account_group_system_time(p, cputime);
+
+	/* Add system time to cpustat. */
+	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+
+	/* Account for system time used */
+	acct_update_integrals(p);
+}
+
+/*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3578,31 +3604,21 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	cputime64_t *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
 
-	/* Add system time to process. */
-	p->stime = cputime_add(p->stime, cputime);
-	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		target_cputime64 = &cpustat->irq;
 	else if (in_serving_softirq())
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		target_cputime64 = &cpustat->softirq;
 	else
-		cpustat->system = cputime64_add(cpustat->system, tmp);
+		target_cputime64 = &cpustat->system;
 
-	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
-
-	/* Account for system time used */
-	acct_update_integrals(p);
+	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
 /*
