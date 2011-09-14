Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab1INUGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36682 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab1INUGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:20 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 7/9] Create cpuacct.proc.stat file
Date: Wed, 14 Sep 2011 17:04:53 -0300
Message-Id: <1316030695-19826-8-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing containers, this file represents how /proc/stat should like
from inside it. It is user, system, etc, from the perspective of
the current cgroup.

In this submission, not all fields are converted

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6c953f5..4611c54 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9300,6 +9300,129 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+#ifndef arch_idle_time
+#define arch_idle_time(cpu) 0
+#endif
+
+static int cpuacct_proc_stat(struct cgroup *cgrp, struct cftype *cft,
+		struct seq_file *p)
+{
+	int i, j;
+	unsigned long jif;
+	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+	cputime64_t guest, guest_nice;
+	u64 sum = 0;
+	u64 sum_softirq = 0;
+	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
+	struct timespec boottime;
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	u64 *cpustat;
+
+	user = nice = system = idle = iowait =
+		irq = softirq = steal = cputime64_zero;
+	guest = guest_nice = cputime64_zero;
+	getboottime(&boottime);
+	jif = boottime.tv_sec;
+
+	for_each_possible_cpu(i) {
+		cpustat = per_cpu_ptr(ca->cpustat, i);
+		user = cputime64_add(user, cpustat[CPUACCT_STAT_USER]);
+		nice = cputime64_add(nice, cpustat[CPUACCT_STAT_NICE]);
+		system = cputime64_add(system, cpustat[CPUACCT_STAT_SYSTEM]);
+		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
+		idle = cputime64_sub(idle, cpustat[CPUACCT_STAT_IDLE]);
+		idle = cputime64_add(idle, arch_idle_time(i));
+		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
+		iowait = cputime64_sub(idle, cpustat[CPUACCT_STAT_IOWAIT]);
+		irq = cputime64_add(irq, cpustat[CPUACCT_STAT_IRQ]);
+		softirq = cputime64_add(softirq, cpustat[CPUACCT_STAT_SOFTIRQ]);
+		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
+		guest = cputime64_add(guest, cpustat[CPUACCT_STAT_GUEST]);
+		guest_nice = cputime64_add(guest_nice,
+			cpustat[CPUACCT_STAT_GUEST_NICE]);
+		sum += kstat_cpu_irqs_sum(i);
+		sum += arch_irq_stat_cpu(i);
+
+		for (j = 0; j < NR_SOFTIRQS; j++) {
+			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
+
+			per_softirq_sums[j] += softirq_stat;
+			sum_softirq += softirq_stat;
+		}
+	}
+	sum += arch_irq_stat();
+
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+		"%llu\n",
+		(unsigned long long)cputime64_to_clock_t(user),
+		(unsigned long long)cputime64_to_clock_t(nice),
+		(unsigned long long)cputime64_to_clock_t(system),
+		(unsigned long long)cputime64_to_clock_t(idle),
+		(unsigned long long)cputime64_to_clock_t(iowait),
+		(unsigned long long)cputime64_to_clock_t(irq),
+		(unsigned long long)cputime64_to_clock_t(softirq),
+		(unsigned long long)cputime64_to_clock_t(steal),
+		(unsigned long long)cputime64_to_clock_t(guest),
+		(unsigned long long)cputime64_to_clock_t(guest_nice));
+	for_each_online_cpu(i) {
+		cpustat = per_cpu_ptr(ca->cpustat, i);
+		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
+		user = cpustat[CPUACCT_STAT_USER];
+		nice = cpustat[CPUACCT_STAT_NICE];
+		system = cpustat[CPUACCT_STAT_SYSTEM];
+		idle = kstat_cpu(i).cpustat.idle;
+		idle = cputime64_sub(idle, cpustat[CPUACCT_STAT_IDLE]);
+		idle = cputime64_add(idle, arch_idle_time(i));
+		iowait = kstat_cpu(i).cpustat.iowait;
+		iowait = cputime64_sub(iowait, cpustat[CPUACCT_STAT_IOWAIT]);
+		irq = cpustat[CPUACCT_STAT_IRQ];
+		softirq = cpustat[CPUACCT_STAT_SOFTIRQ];
+		steal = kstat_cpu(i).cpustat.steal;
+		guest = cpustat[CPUACCT_STAT_GUEST];
+		guest_nice = cpustat[CPUACCT_STAT_GUEST_NICE];
+		seq_printf(p,
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
+			"%llu\n",
+			i,
+			(unsigned long long)cputime64_to_clock_t(user),
+			(unsigned long long)cputime64_to_clock_t(nice),
+			(unsigned long long)cputime64_to_clock_t(system),
+			(unsigned long long)cputime64_to_clock_t(idle),
+			(unsigned long long)cputime64_to_clock_t(iowait),
+			(unsigned long long)cputime64_to_clock_t(irq),
+			(unsigned long long)cputime64_to_clock_t(softirq),
+			(unsigned long long)cputime64_to_clock_t(steal),
+			(unsigned long long)cputime64_to_clock_t(guest),
+			(unsigned long long)cputime64_to_clock_t(guest_nice));
+	}
+	seq_printf(p, "intr %llu", (unsigned long long)sum);
+
+	/* sum again ? it could be updated? */
+	for_each_irq_nr(j)
+		seq_printf(p, " %u", kstat_irqs(j));
+
+	seq_printf(p,
+		"\nctxt %llu\n"
+		"btime %lu\n"
+		"processes %lu\n"
+		"procs_running %lu\n"
+		"procs_blocked %lu\n",
+		nr_context_switches(),
+		(unsigned long)jif,
+		total_forks,
+		nr_running(),
+		nr_iowait());
+
+	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+
+	for (i = 0; i < NR_SOFTIRQS; i++)
+		seq_printf(p, " %u", per_softirq_sums[i]);
+	seq_putc(p, '\n');
+
+	return 0;
+
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -9314,6 +9437,11 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{
+		.name = "proc.stat",
+		.read_seq_string = cpuacct_proc_stat,
+	},
+
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
-- 
1.7.6

