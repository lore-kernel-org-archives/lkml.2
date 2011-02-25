Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab1BYXNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 18:13:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1BYXNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 18:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YSi1f5LwPRfhtnw789v16NsB2V2RpVZ1CAMb6engNWujXpjZ+bb3rI0mc1HDeRQqeY
         j62veGgL1r5zavopO0Cg==
From: Venkatesh Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] sched: Minor IRQ_TIME_ACCOUNTING code layout change
Date: Fri, 25 Feb 2011 15:13:16 -0800
Message-Id: <1298675596-10992-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTi=7Z7QoMLEMdwC=4mo3j_i-Bv5WxfjwONDG=wL8@mail.gmail.com>
References: <AANLkTi=7Z7QoMLEMdwC=4mo3j_i-Bv5WxfjwONDG=wL8@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a warning reported here
lkml.org/lkml/2011/1/30/124

kernel/sched.c:3719: warning: 'irqtime_account_idle_ticks' defined but not used
kernel/sched.c:3720: warning: 'irqtime_account_process_tick' defined but not used

The patch on that thread here
https://lkml.org/lkml/2011/1/31/363

Added the needed ifdef and also moved the code around a bit to make
it easy to follow. Here is the refresh of that patch on latest tip.

This patch will not have any functional impact. Just the code layout change.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   64 +++++++++++++++++++++++++++----------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 36e936d..5fb5aa2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3666,7 +3666,36 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
@@ -3728,42 +3757,11 @@ static void irqtime_account_idle_ticks(int ticks)
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
-- 
1.7.3.1

