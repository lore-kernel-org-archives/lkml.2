Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab1BZHES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 02:04:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:42430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1BZHER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 02:04:17 -0500
Date: Sat, 26 Feb 2011 07:03:54 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, venki@google.com, mingo@elte.hu
In-Reply-To: <1298675596-10992-1-git-send-email-venki@google.com>
References: <1298675596-10992-1-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up the IRQ_TIME_ACCOUNTING code
Message-ID: <tip-544b4a1f309d18f40969dbab7e08bafd136b2f55@git.kernel.org>
Git-Commit-ID: 544b4a1f309d18f40969dbab7e08bafd136b2f55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 07:03:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  544b4a1f309d18f40969dbab7e08bafd136b2f55
Gitweb:     http://git.kernel.org/tip/544b4a1f309d18f40969dbab7e08bafd136b2f55
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Fri, 25 Feb 2011 15:13:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 26 Feb 2011 07:59:58 +0100

sched: Clean up the IRQ_TIME_ACCOUNTING code

Fix this warning:

  lkml.org/lkml/2011/1/30/124

 kernel/sched.c:3719: warning: 'irqtime_account_idle_ticks' defined but not used
 kernel/sched.c:3720: warning: 'irqtime_account_process_tick' defined but not used

In a cleaner way than:

 7e9498705e81: sched: Add #ifdef around irq time accounting functions

This patch will not have any functional impact.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Cc: heiko.carstens@de.ibm.com
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <1298675596-10992-1-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   64 +++++++++++++++++++++++++++----------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 79bca16..0c87126 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3687,7 +3687,36 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
+/*
+ * Account for involuntary wait time.
+ * @cputime: the cpu time spent in involuntary wait
+ */
+void account_steal_time(cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+
+	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+}
+
+/*
+ * Account for idle time.
+ * @cputime: the cpu time spent in idle wait
+ */
+void account_idle_time(cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	struct rq *rq = this_rq();
+
+	if (atomic_read(&rq->nr_iowait) > 0)
+		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+	else
+		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+}
+
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -3749,42 +3778,11 @@ static void irqtime_account_idle_ticks(int ticks)
 	for (i = 0; i < ticks; i++)
 		irqtime_account_process_tick(current, 0, rq);
 }
-#else
+#else /* CONFIG_IRQ_TIME_ACCOUNTING */
 static void irqtime_account_idle_ticks(int ticks) {}
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq) {}
-#endif
-#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
-
-/*
- * Account for involuntary wait time.
- * @steal: the cpu time spent in involuntary wait
- */
-void account_steal_time(cputime_t cputime)
-{
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
-
-	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
-}
-
-/*
- * Account for idle time.
- * @cputime: the cpu time spent in idle wait
- */
-void account_idle_time(cputime_t cputime)
-{
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
-	struct rq *rq = this_rq();
-
-	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
-	else
-		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
-}
-
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 /*
  * Account a single tick of cpu time.
