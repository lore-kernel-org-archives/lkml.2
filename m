Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1IWWYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:24:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28764 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1IWWYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:24:16 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [RFD 2/9] Move /proc/stat logic inside sched.c
Date: Fri, 23 Sep 2011 19:20:25 -0300
Message-Id: <1316816432-9237-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316816432-9237-1-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all of the /proc/stat display code inside
sched.c. The goal is to, later on, have a different version
of it per-cgroup. In containers environment, this is useful
to give each container a different and independent view of
the statistics displayed in this file.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 fs/proc/stat.c        |  117 +-----------------------------------------
 include/linux/sched.h |    4 ++
 kernel/sched.c        |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+), 116 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index ec708c7..c9b2ae9 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -11,124 +11,9 @@
 #include <linux/irqnr.h>
 #include <asm/cputime.h>
 
-#ifndef arch_irq_stat_cpu
-#define arch_irq_stat_cpu(cpu) 0
-#endif
-#ifndef arch_irq_stat
-#define arch_irq_stat() 0
-#endif
-#ifndef arch_idle_time
-#define arch_idle_time(cpu) 0
-#endif
-
 static int show_stat(struct seq_file *p, void *v)
 {
-	int i, j;
-	unsigned long jif;
-	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest, guest_nice;
-	u64 sum = 0;
-	u64 sum_softirq = 0;
-	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
-	struct timespec boottime;
-
-	user = nice = system = idle = iowait =
-		irq = softirq = steal = cputime64_zero;
-	guest = guest_nice = cputime64_zero;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
-
-	for_each_possible_cpu(i) {
-		user = cputime64_add(user, kstat_cpu(i).cpustat[USER]);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat[NICE]);
-		system = cputime64_add(system, kstat_cpu(i).cpustat[SYSTEM]);
-		idle = cputime64_add(idle, kstat_cpu(i).cpustat[IDLE]);
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat[IOWAIT]);
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat[IRQ]);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat[SOFTIRQ]);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat[STEAL]);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat[GUEST]);
-		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat[GUEST_NICE]);
-		sum += kstat_cpu_irqs_sum(i);
-		sum += arch_irq_stat_cpu(i);
-
-		for (j = 0; j < NR_SOFTIRQS; j++) {
-			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
-
-			per_softirq_sums[j] += softirq_stat;
-			sum_softirq += softirq_stat;
-		}
-	}
-	sum += arch_irq_stat();
-
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-		"%llu\n",
-		(unsigned long long)cputime64_to_clock_t(user),
-		(unsigned long long)cputime64_to_clock_t(nice),
-		(unsigned long long)cputime64_to_clock_t(system),
-		(unsigned long long)cputime64_to_clock_t(idle),
-		(unsigned long long)cputime64_to_clock_t(iowait),
-		(unsigned long long)cputime64_to_clock_t(irq),
-		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest),
-		(unsigned long long)cputime64_to_clock_t(guest_nice));
-	for_each_online_cpu(i) {
-
-		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat[USER];
-		nice = kstat_cpu(i).cpustat[NICE];
-		system = kstat_cpu(i).cpustat[SYSTEM];
-		idle = kstat_cpu(i).cpustat[IDLE];
-		idle = cputime64_add(idle, arch_idle_time(i));
-		iowait = kstat_cpu(i).cpustat[IOWAIT];
-		irq = kstat_cpu(i).cpustat[IRQ];
-		softirq = kstat_cpu(i).cpustat[SOFTIRQ];
-		steal = kstat_cpu(i).cpustat[STEAL];
-		guest = kstat_cpu(i).cpustat[GUEST];
-		guest_nice = kstat_cpu(i).cpustat[GUEST_NICE];
-		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-			"%llu\n",
-			i,
-			(unsigned long long)cputime64_to_clock_t(user),
-			(unsigned long long)cputime64_to_clock_t(nice),
-			(unsigned long long)cputime64_to_clock_t(system),
-			(unsigned long long)cputime64_to_clock_t(idle),
-			(unsigned long long)cputime64_to_clock_t(iowait),
-			(unsigned long long)cputime64_to_clock_t(irq),
-			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest),
-			(unsigned long long)cputime64_to_clock_t(guest_nice));
-	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
-
-	seq_printf(p,
-		"\nctxt %llu\n"
-		"btime %lu\n"
-		"processes %lu\n"
-		"procs_running %lu\n"
-		"procs_blocked %lu\n",
-		nr_context_switches(),
-		(unsigned long)jif,
-		total_forks,
-		nr_running(),
-		nr_iowait());
-
-	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
-
-	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_printf(p, " %u", per_softirq_sums[i]);
-	seq_putc(p, '\n');
-
-	return 0;
+	return cpu_cgroup_proc_stat(NULL, NULL, p);
 }
 
 static int stat_open(struct inode *inode, struct file *file)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..64c5ba5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2712,6 +2712,10 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+struct cgroup;
+struct cftype;
+int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
+			 struct seq_file *p);
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 2f6bab4..4d831fe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9049,6 +9049,142 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+#ifndef arch_irq_stat_cpu
+#define arch_irq_stat_cpu(cpu) 0
+#endif
+#ifndef arch_irq_stat
+#define arch_irq_stat() 0
+#endif
+#ifndef arch_idle_time
+#define arch_idle_time(cpu) 0
+#endif
+
+int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_file *p)
+{
+	int i, j;
+	unsigned long jif;
+	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
+	cputime64_t guest, guest_nice;
+	u64 sum = 0;
+	u64 sum_softirq = 0;
+	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
+	struct timespec boottime;
+	struct task_group *tg;
+
+	if (cgrp)
+		tg = cgroup_tg(cgrp);
+	else
+		tg = &root_task_group;
+
+	user = nice = system = idle = iowait =
+		irq = softirq = steal = cputime64_zero;
+	guest = guest_nice = cputime64_zero;
+	getboottime(&boottime);
+	jif = boottime.tv_sec;
+
+	for_each_possible_cpu(i) {
+		struct kernel_stat *kstat, *root_kstat;
+		kstat = per_cpu_ptr(tg->cpustat, i);
+		root_kstat = per_cpu_ptr(root_task_group.cpustat, i);
+
+		user = cputime64_add(user, kstat->cpustat[USER]);
+		nice = cputime64_add(nice, kstat->cpustat[NICE]);
+		system = cputime64_add(system, kstat->cpustat[SYSTEM]);
+		idle = cputime64_add(idle, root_kstat->cpustat[IDLE]);
+		idle = cputime64_add(idle, arch_idle_time(i));
+		iowait = cputime64_add(iowait, root_kstat->cpustat[IOWAIT]);
+		irq = cputime64_add(irq, kstat->cpustat[IRQ]);
+		softirq = cputime64_add(softirq, kstat->cpustat[SOFTIRQ]);
+		steal = cputime64_add(steal, kstat->cpustat[STEAL]);
+		guest = cputime64_add(guest, kstat->cpustat[GUEST]);
+		guest_nice = cputime64_add(guest_nice,
+			kstat->cpustat[GUEST_NICE]);
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
+		struct kernel_stat *kstat, *root_kstat;
+		kstat = per_cpu_ptr(tg->cpustat, i);
+		root_kstat = per_cpu_ptr(root_task_group.cpustat, i);
+
+		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
+		user = kstat->cpustat[USER];
+		nice = kstat->cpustat[NICE];
+		system = kstat->cpustat[SYSTEM];
+		idle = root_kstat->cpustat[IDLE];
+		idle = cputime64_add(idle, arch_idle_time(i));
+		iowait = root_kstat->cpustat[IOWAIT];
+		irq = kstat->cpustat[IRQ];
+		softirq = kstat->cpustat[SOFTIRQ];
+		steal = kstat->cpustat[STEAL];
+		guest = kstat->cpustat[GUEST];
+		guest_nice = kstat->cpustat[GUEST_NICE];
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
+}
+
+
+
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
-- 
1.7.6

