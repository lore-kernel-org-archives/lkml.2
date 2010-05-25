Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab0EYAMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:12:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab0EYAMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:12:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=eibKKEhSce1AeZxaRB9XBJdngAcYTEUO366inhaRaGWNIX/L7MtvhZllu3gFDiAxA
	N9orB9nmaK4Izu1MEuQHA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: [RFC PATCH 4/4] sched: Export irq times through cpuacct cgroup
Date: Mon, 24 May 2010 17:11:22 -0700
Message-Id: <1274746282-21533-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274746282-21533-4-git-send-email-venki@google.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
 <1274746282-21533-2-git-send-email-venki@google.com>
 <1274746282-21533-3-git-send-email-venki@google.com>
 <1274746282-21533-4-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds hi_time, si_time, hi_time_percpu and si_time_percpu info in cpuacct
cgroup.

The info will be fine granularity timings when either
CONFIG_IRQ_TIME_ACCOUNTING or CONFIG_VIRT_CPU_ACCOUNTING is enabled.
Otherwise the info will be based on tick samples.

Looked at adding this under cpuacct.stat. But, this information is useful
to the administrator in percpu format, so that any hi or si activity
on a particular CPU can be noted and some config change
(move the irq away, assign a different CPU to this cgroup, etc)
may be done based on that info.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   55 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d7d7efe..19e4d5d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1404,6 +1404,8 @@ enum cpuacct_stat_index {
 
 enum cpuacct_charge_index {
 	CPUACCT_CHARGE_USAGE,	/* ... execution time */
+	CPUACCT_CHARGE_SI_TIME,	/* ... softirq time */
+	CPUACCT_CHARGE_HI_TIME,	/* ... hardirq time */
 
 	CPUACCT_CHARGE_NCHARGES,
 };
@@ -3238,9 +3240,15 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /* In this case, we charge the task at irq time for finer accounting */
-#define TASK_IRQ_CHARGE_AT_TICK(x, y)	(x)
+static inline void task_cpuacct_irq_charge(struct task_struct *p,
+			cputime64_t *ptime, int idx, cputime64_t delta) { }
 #else
-#define TASK_IRQ_CHARGE_AT_TICK(x, y)	cputime64_add(x, y)
+static inline void task_cpuacct_irq_charge(struct task_struct *p,
+			cputime64_t *ptime, int idx, cputime64_t delta)
+{
+	*ptime = cputime64_add(*ptime, delta);
+	cpuacct_charge(p, idx, delta);
+}
 #endif
 
 /*
@@ -3270,10 +3278,12 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-		p->hi_time = TASK_IRQ_CHARGE_AT_TICK(p->hi_time, tmp);
+		task_cpuacct_irq_charge(p, &p->hi_time,
+					CPUACCT_CHARGE_HI_TIME, tmp);
 	} else if (softirq_count()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-		p->si_time = TASK_IRQ_CHARGE_AT_TICK(p->si_time, tmp);
+		task_cpuacct_irq_charge(p, &p->si_time,
+					CPUACCT_CHARGE_SI_TIME, tmp);
 	} else {
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	}
@@ -8832,6 +8842,28 @@ static struct cftype files[] = {
 		.private = CPUACCT_CHARGE_USAGE,
 	},
 	{
+		.name = "si_time",
+		.read_u64 = cpuusage_read,
+		.write_u64 = cpuusage_write,
+		.private = CPUACCT_CHARGE_SI_TIME,
+	},
+	{
+		.name = "si_time_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+		.private = CPUACCT_CHARGE_SI_TIME,
+	},
+	{
+		.name = "hi_time",
+		.read_u64 = cpuusage_read,
+		.write_u64 = cpuusage_write,
+		.private = CPUACCT_CHARGE_HI_TIME,
+	},
+	{
+		.name = "hi_time_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+		.private = CPUACCT_CHARGE_HI_TIME,
+	},
+	{
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
@@ -8996,17 +9028,20 @@ void account_system_vtime(struct task_struct *tsk)
 {
 	unsigned long flags;
 	int cpu;
-	u64 now;
+	u64 now, delta;
 
 	local_irq_save(flags);
 	cpu = task_cpu(tsk);
 	now = sched_clock_cpu(cpu);
-	if (hardirq_count())
-		tsk->hi_time += now - per_cpu(irq_start_time, cpu);
-	else if (softirq_count())
-		tsk->si_time += now - per_cpu(irq_start_time, cpu);
-
+	delta = now - per_cpu(irq_start_time, cpu);
 	per_cpu(irq_start_time, cpu) = now;
+	if (hardirq_count()) {
+		tsk->hi_time += delta;
+		cpuacct_charge(tsk, CPUACCT_CHARGE_HI_TIME, delta);
+	} else if (softirq_count()) {
+		tsk->si_time += delta;
+		cpuacct_charge(tsk, CPUACCT_CHARGE_SI_TIME, delta);
+	}
 	local_irq_restore(flags);
 }
 
-- 
1.7.0.1

