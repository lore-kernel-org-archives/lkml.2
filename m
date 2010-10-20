Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0JTWtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:49:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0JTWtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YM9GjvulvxGLm8YEwrX+OPFl+mHosDI9F14OUPZF6yC2pSmEyTq8Q5yI6fHBJH9RBS
         87qMrNuPtupi4klOVlJg==
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
Subject: [PATCH 4/6] Export ns irqtimes from IRQ_TIME_ACCOUNTING through /proc/stat
Date: Wed, 20 Oct 2010 15:49:00 -0700
Message-Id: <1287614941-32325-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287614941-32325-1-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IRQ_TIME_ACCOUNTING adds ns granularity irq time on each CPU.
This info is already used in scheduler to do proper task chargeback
(earlier patches). This patch retro-fits this ns granularity
hardirq and softirq information to /proc/stat irq and softirq fields.

The update is still done on timer tick, where we look at accumulated
ns hardirq/softirq time and account the tick to user/system/irq/hardirq/guest
accordingly.

No new interface added.

Earlier versions looked at adding this as new fields in some /proc
files. This one seems to be the best in terms of impact to existing
apps, even though it has somewhat more kernel code than earlier versions.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8b97958..7e812a6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2002,8 +2002,40 @@ static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 	}
 }
 
+static int irqtime_account_hi_update(void)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = __get_cpu_var(cpu_hardirq_time);
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int irqtime_account_si_update(void)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = __get_cpu_var(cpu_softirq_time);
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
 #else
 
+#define sched_clock_irqtime	(0)
+
 static u64 irq_time_cpu(int cpu)
 {
 	return 0;
@@ -3554,6 +3586,65 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+/*
+ * Account a tick to a process and cpustat
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: is the tick from userspace
+ * @rq: the pointer to rq
+ *
+ * Tick demultiplexing follows the order
+ * - pending hardirq update
+ * - user_time
+ * - pending softirq update
+ * - idle_time
+ * - system time
+ *   - check for guest_time
+ *   - else account as system_time
+ *
+ * Check for hardirq is done both for system and user time as there is
+ * no timer going off while we are on hardirq and hence we may never get an
+ * oppurtunity to update it solely in system time.
+ * p->stime and friends are only updated on system time and not on irq
+ * softirq as those do not count in task exec_runtime any more.
+ */
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq)
+{
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+
+	if (irqtime_account_hi_update()) {
+		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+	} else if (user_tick) {
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else if (irqtime_account_si_update()) {
+		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+	} else if (p == rq->idle) {
+		account_idle_time(cputime_one_jiffy);
+	} else if (p->flags & PF_VCPU) { /* System time or guest time */
+		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
+	} else {
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					&cpustat->system);
+	}
+}
+
+static void irqtime_account_idle_ticks(int ticks)
+{
+	int i;
+	struct rq *rq = this_rq();
+
+	for (i = 0; i < ticks; i++)
+		irqtime_account_process_tick(current, 0, rq);
+}
+#else
+static void irqtime_account_idle_ticks(int ticks) {}
+static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+						struct rq *rq) {}
+#endif
+
 /*
  * Account for involuntary wait time.
  * @steal: the cpu time spent in involuntary wait
@@ -3594,6 +3685,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
+	if (sched_clock_irqtime) {
+		irqtime_account_process_tick(p, user_tick, rq);
+		return;
+	}
+
 	if (user_tick)
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
@@ -3619,6 +3715,12 @@ void account_steal_ticks(unsigned long ticks)
  */
 void account_idle_ticks(unsigned long ticks)
 {
+
+	if (sched_clock_irqtime) {
+		irqtime_account_idle_ticks(ticks);
+		return;
+	}
+
 	account_idle_time(jiffies_to_cputime(ticks));
 }
 
-- 
1.7.1

