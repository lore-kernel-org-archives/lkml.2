Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1AZMNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:13:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:39793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab1AZMNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:13:38 -0500
Date: Wed, 26 Jan 2011 12:13:07 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292980144-28796-5-git-send-email-venki@google.com>
References: <1292980144-28796-5-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Export ns irqtimes through /proc/stat
Message-ID: <tip-abb74cefa9c682fb38ba86c17ca3c86fed6cc464@git.kernel.org>
Git-Commit-ID: abb74cefa9c682fb38ba86c17ca3c86fed6cc464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:13:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abb74cefa9c682fb38ba86c17ca3c86fed6cc464
Gitweb:     http://git.kernel.org/tip/abb74cefa9c682fb38ba86c17ca3c86fed6cc464
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 21 Dec 2010 17:09:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:21 +0100

sched: Export ns irqtimes through /proc/stat

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

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292980144-28796-5-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e3fa921..2a3c979 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1920,8 +1920,40 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 		sched_rt_avg_update(rq, irq_delta);
 }
 
+static int irqtime_account_hi_update(void)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	unsigned long flags;
+	u64 latest_ns;
+	int ret = 0;
+
+	local_irq_save(flags);
+	latest_ns = this_cpu_read(cpu_hardirq_time);
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
+	latest_ns = this_cpu_read(cpu_softirq_time);
+	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+		ret = 1;
+	local_irq_restore(flags);
+	return ret;
+}
+
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#define sched_clock_irqtime	(0)
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
 	rq->clock_task += delta;
@@ -3621,6 +3653,65 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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
+ * - pending softirq update
+ * - user_time
+ * - idle_time
+ * - system time
+ *   - check for guest_time
+ *   - else account as system_time
+ *
+ * Check for hardirq is done both for system and user time as there is
+ * no timer going off while we are on hardirq and hence we may never get an
+ * opportunity to update it solely in system time.
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
+	} else if (irqtime_account_si_update()) {
+		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+	} else if (user_tick) {
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
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
@@ -3661,6 +3752,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
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
@@ -3686,6 +3782,12 @@ void account_steal_ticks(unsigned long ticks)
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
 
