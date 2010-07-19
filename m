Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899Ab0GSX6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:58:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760889Ab0GSX5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:57:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=r3gf7lNMb/UxwFkN+CFiiEJV9keuj3FrXE6PyqpnVty0TI67LLA+KlMg47UQw3ba+
	rp5/MtK+09uOajYjKyMdQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/4] sched: Export irq times through cpuacct cgroup
Date: Mon, 19 Jul 2010 16:57:15 -0700
Message-Id: <1279583835-22854-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
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
on a particular CPU can be noted and some resource reallocation
(move the irq away, assign a different CPU to this cgroup, etc)
can be done based on that info.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 Documentation/cgroups/cpuacct.txt |    5 +++
 kernel/sched.c                    |   73 +++++++++++++++++++++++++++++++------
 2 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index 8b93094..817435e 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -48,3 +48,8 @@ system times. This has two side effects:
   against concurrent writes.
 - It is possible to see slightly outdated values for user and system times
   due to the batch processing nature of percpu_counter.
+
+cpuacct.hi_time and cpuacct.si_time provides the information about hardirq
+and softirq processing time that was accounted to this cgroup. There is also
+percpu variants of hi_time and si_time that splits the info at percpu level.
+All this times are in USER_HZ unit.
diff --git a/kernel/sched.c b/kernel/sched.c
index c12c8ea..7198041 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1398,6 +1398,8 @@ enum cpuacct_stat_index {
 
 enum cpuacct_charge_index {
 	CPUACCT_CHARGE_USAGE,	/* ... execution time */
+	CPUACCT_CHARGE_SI_TIME,	/* ... softirq time */
+	CPUACCT_CHARGE_HI_TIME,	/* ... hardirq time */
 
 	CPUACCT_CHARGE_NCHARGES,
 };
@@ -3226,9 +3228,11 @@ void enable_sched_clock_irqtime(void)
 #endif
 
 #if defined(CONFIG_VIRT_CPU_ACCOUNTING)
-static void account_task_irqtime(cputime64_t *task_irqtime, cputime64_t irqtime)
+static void account_task_irqtime(struct task_struct *p,
+		cputime64_t *task_irqtime, int idx, cputime64_t irqtime)
 {
 	*task_irqtime = cputime64_add(*task_irqtime, irqtime);
+	cpuacct_charge(p, idx, irqtime);
 }
 #else
 /*
@@ -3236,10 +3240,13 @@ static void account_task_irqtime(cputime64_t *task_irqtime, cputime64_t irqtime)
  * We handle !sched_clock_irqtime case here as when sched_clock_irqtime is set,
  * this accounting is done in account_system_vtime() below.
  */
-static void account_task_irqtime(cputime64_t *task_irqtime, cputime64_t irqtime)
+static void account_task_irqtime(struct task_struct *p,
+		cputime64_t *task_irqtime, int idx, cputime64_t irqtime)
 {
-	if (!sched_clock_irqtime)
+	if (!sched_clock_irqtime) {
 		*task_irqtime = cputime64_add(*task_irqtime, TICK_NSEC);
+		cpuacct_charge(p, idx, TICK_NSEC);
+	}
 }
 #endif
 
@@ -3270,10 +3277,12 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-		account_task_irqtime(&p->hi_time, tmp);
+		account_task_irqtime(p, &p->hi_time,
+					CPUACCT_CHARGE_HI_TIME, tmp);
 	} else if (softirq_count()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-		account_task_irqtime(&p->si_time, tmp);
+		account_task_irqtime(p, &p->si_time,
+					CPUACCT_CHARGE_SI_TIME, tmp);
 	} else {
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	}
@@ -8737,6 +8746,22 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	kfree(ca);
 }
 
+static u64 cpuacct_cpuusage_convert(u64 data, enum cpuacct_charge_index idx)
+{
+	switch (idx) {
+	case CPUACCT_CHARGE_SI_TIME:
+	case CPUACCT_CHARGE_HI_TIME:
+		/*
+		 * irqtime is stored either in ns or cputime64, depending
+		 * on CONFIG_VIRT_CPU_ACCOUNTING. Convert it to clock_t
+		 * before returning to user.
+		 */
+		return irqtime_to_clock_t(data);
+	default:
+		return data;
+	}
+}
+
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca,
 		enum cpuacct_charge_index idx, int cpu)
 {
@@ -8754,7 +8779,7 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca,
 	data = *cpuusage;
 #endif
 
-	return data;
+	return cpuacct_cpuusage_convert(data, idx);
 }
 
 static void cpuacct_cpuusage_write(struct cpuacct *ca,
@@ -8853,6 +8878,26 @@ static struct cftype files[] = {
 		.private = CPUACCT_CHARGE_USAGE,
 	},
 	{
+		.name = "si_time",
+		.read_u64 = cpuusage_read,
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
@@ -9017,7 +9062,7 @@ void account_system_vtime(struct task_struct *tsk)
 {
 	unsigned long flags;
 	int cpu;
-	u64 now;
+	u64 now, delta;
 
 	if (!sched_clock_irqtime)
 		return;
@@ -9025,12 +9070,16 @@ void account_system_vtime(struct task_struct *tsk)
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
+
 	local_irq_restore(flags);
 }
 
-- 
1.7.1

