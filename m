Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0JTWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:49:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50723 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0JTWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GsFUBcBib0Kh0Hic3fvY04PJJKfE8tSdwa1dwMXcSrb4ORIibjZzClRHMlKqFhaeW0
         aMaN4DIZbf1s0iKegrrg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 5/6] Account ksoftirq time as cpustat softirq
Date: Wed, 20 Oct 2010 15:49:01 -0700
Message-Id: <1287614941-32325-6-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287614941-32325-1-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

softirq time in ksoftirqd context is not accounted in ns granularity
per cpu softirq stats, as we want that to be a part of ksoftirqd
exec_runtime.

Accounting them separately, and using them while doing stats makes
/proc/stat include that time in cpu si time.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7e812a6..cba8090 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1941,6 +1941,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
  */
 static DEFINE_PER_CPU(u64, cpu_hardirq_time);
 static DEFINE_PER_CPU(u64, cpu_softirq_time);
+static DEFINE_PER_CPU(u64, cpu_ksoftirqd_time);
 
 static DEFINE_PER_CPU(u64, irq_start_time);
 static int sched_clock_irqtime;
@@ -1979,15 +1980,20 @@ void account_system_vtime(struct task_struct *curr)
 	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
 	/*
-	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
 	 * in that case, so as not to confuse scheduler with a special task
 	 * that do not consume any time, but still wants to run.
+	 * So, softirq time in ksoftirqd is accounted separately and used
+	 * for softirq time reporting in /proc/stat.
 	 */
-	if (in_irq())
+	if (in_irq()) {
 		per_cpu(cpu_hardirq_time, cpu) += delta;
-	else if (in_serving_softirq() && !(is_ksoftirqd_context()))
-		per_cpu(cpu_softirq_time, cpu) += delta;
+	} else if (in_serving_softirq()) {
+		if (is_ksoftirqd_context())
+			per_cpu(cpu_ksoftirqd_time, cpu) += delta;
+		else
+			per_cpu(cpu_softirq_time, cpu) += delta;
+	}
 
 	local_irq_restore(flags);
 }
@@ -2025,7 +2031,9 @@ static int irqtime_account_si_update(void)
 	int ret = 0;
 
 	local_irq_save(flags);
-	latest_ns = __get_cpu_var(cpu_softirq_time);
+	latest_ns = __get_cpu_var(cpu_softirq_time) +
+			__get_cpu_var(cpu_ksoftirqd_time);
+
 	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
 		ret = 1;
 	local_irq_restore(flags);
@@ -3606,7 +3614,8 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  * no timer going off while we are on hardirq and hence we may never get an
  * oppurtunity to update it solely in system time.
  * p->stime and friends are only updated on system time and not on irq
- * softirq as those do not count in task exec_runtime any more.
+ * softirq as those do not count in task exec_runtime any more (except
+ * for ksoftirqd).
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq)
@@ -3620,7 +3629,12 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (irqtime_account_si_update()) {
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		if (is_ksoftirqd_context()) {
+			__account_system_time(p, cputime_one_jiffy,
+					one_jiffy_scaled, &cpustat->softirq);
+		} else {
+			cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		}
 	} else if (p == rq->idle) {
 		account_idle_time(cputime_one_jiffy);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
-- 
1.7.1

