Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1JBTWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:22:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22883 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1JBTW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:22:26 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 03/10] Move /proc/stat logic inside sched.c
Date: Sun,  2 Oct 2011 23:21:20 +0400
Message-Id: <1317583287-18300-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317583287-18300-1-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
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
 fs/proc/stat.c        |  116 +-----------------------------------------------
 include/linux/sched.h |    1 +
 kernel/sched.c        |  119 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 115 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e8e2b39..6b10387 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -11,123 +11,9 @@
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
-	u64 user, nice, system, idle, iowait, irq, softirq, steal;
-	u64 guest, guest_nice;
-	u64 sum = 0;
-	u64 sum_softirq = 0;
-	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
-	struct timespec boottime;
-
-	user = nice = system = idle = iowait =
-		irq = softirq = steal = 0;
-	guest = guest_nice = 0;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
-
-	for_each_possible_cpu(i) {
-		user += kstat_cpu(i).cpustat[USER];
-		nice += kstat_cpu(i).cpustat[NICE];
-		system += kstat_cpu(i).cpustat[SYSTEM];
-		idle += kstat_cpu(i).cpustat[IDLE];
-		idle += arch_idle_time(i);
-		iowait += kstat_cpu(i).cpustat[IOWAIT];
-		irq += kstat_cpu(i).cpustat[IRQ];
-		softirq += kstat_cpu(i).cpustat[SOFTIRQ];
-		steal += kstat_cpu(i).cpustat[STEAL];
-		guest += kstat_cpu(i).cpustat[GUEST];
-		guest_nice += kstat_cpu(i).cpustat[GUEST_NICE];
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
-		idle += arch_idle_time(i);
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
+	return cpu_cgroup_proc_stat(p);
 }
 
 static int stat_open(struct inode *inode, struct file *file)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..25658d8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2712,6 +2712,7 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+int cpu_cgroup_proc_stat(struct seq_file *p);
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 8f0fa05..482e645 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9083,6 +9083,125 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
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
+int cpu_cgroup_proc_stat(struct seq_file *p)
+{
+	int i, j;
+	unsigned long jif;
+	u64 user, nice, system, idle, iowait, irq, softirq, steal;
+	u64 guest, guest_nice;
+	u64 sum = 0;
+	u64 sum_softirq = 0;
+	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
+	struct timespec boottime;
+
+	user = nice = system = idle = iowait =
+		irq = softirq = steal = 0;
+	guest = guest_nice = 0;
+	getboottime(&boottime);
+	jif = boottime.tv_sec;
+
+	for_each_possible_cpu(i) {
+		user += kstat_this_cpu->cpustat[USER];
+		nice += kstat_this_cpu->cpustat[NICE];
+		system += kstat_this_cpu->cpustat[SYSTEM];
+		idle += kstat_this_cpu->cpustat[IDLE];
+		idle += arch_idle_time(i);
+		iowait += kstat_this_cpu->cpustat[IOWAIT];
+		irq += kstat_this_cpu->cpustat[IRQ];
+		softirq += kstat_this_cpu->cpustat[SOFTIRQ];
+		steal += kstat_this_cpu->cpustat[STEAL];
+		guest += kstat_this_cpu->cpustat[GUEST];
+		guest_nice += kstat_this_cpu->cpustat[GUEST_NICE];
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
+
+		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
+		user = kstat_this_cpu->cpustat[USER];
+		nice = kstat_this_cpu->cpustat[NICE];
+		system = kstat_this_cpu->cpustat[SYSTEM];
+		idle = kstat_this_cpu->cpustat[IDLE];
+		idle += arch_idle_time(i);
+		iowait = kstat_this_cpu->cpustat[IOWAIT];
+		irq = kstat_this_cpu->cpustat[IRQ];
+		softirq = kstat_this_cpu->cpustat[SOFTIRQ];
+		steal = kstat_this_cpu->cpustat[STEAL];
+		guest = kstat_this_cpu->cpustat[GUEST];
+		guest_nice = kstat_this_cpu->cpustat[GUEST_NICE];
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
 #ifdef CONFIG_CGROUP_CPUACCT
 
 /*
-- 
1.7.6

