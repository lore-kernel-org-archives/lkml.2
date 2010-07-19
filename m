Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0GSX5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:57:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab0GSX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:57:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=T0xLKrCaak6/gDoRybXJfW0t+AZZRicFUuTVVqyCdVO5Cqp3lEbPhEbMPPHfXijFK
	acfWKQT7IVuGlMMOrNexA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/4] sched: Track and export per task [hard|soft]irq time
Date: Mon, 19 Jul 2010 16:57:12 -0700
Message-Id: <1279583835-22854-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kernel does not account softirq and hardirq times at
the task level. There is irq time info in kstat_cpu which is
accumulated at the cpu level.

Without the task level information, the non irq run time of task(s) would
have to be guessed based on their exec time and CPU on which they were
running recently and assuming that the CPU irq time reported are spread
across all the tasks running there. And this guess can be widely off the mark.

Sample case, considering just the softirq:

If there are varied workloads running on a CPU, say a CPU bound task (loop)
and a network IO bound task (nc) along with the network softirq load,
there is no way for the administrator/user to know the non-irq runtime of each
of these tasks. Only information available is the total runtime for each of the
tasks and kstat_cpu softirq time for the CPU.

In this example, considering a 10 second sample, both loop and nc would have
total run time of ~5s. And kstat_cpu softirq on this cpu increase was
355 (~3.5s).

So, all the information the user gets is that both the tasks are running for
roughly the same amount of time and softirq is around 35%. As a result user
may conclude that irq overhead for both tasks are equal (1.75s) and the
non-irq runtime of both the tasks are around ~3.25s. Yes. There is another
factor of system and user time reported for these tasks that I am ignoring
as that is tough to correlate with irq time, in cases where the tasks have
significant non-irq system time.

This change adds tracking of softirq time on each task and task group.
This information is exported in /proc/<pid>/stat.

So, the user can get info like below, looking at exec_time and si_time in
appropriate /proc/<pid>/stat.
(Taken for a 10s interval)
task exec_time softirqtime (in USER_HZ)
(loop)  (nc)
505 0   500 359
502 1   501 363
503 0   502 354
504 0   499 359
503 3   500 360

with this, user can get the non-irq run time as 5s and ~1.45s for
loop and nc, respectively.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 Documentation/filesystems/proc.txt |    5 ++++-
 fs/proc/array.c                    |   17 +++++++++++++++--
 include/linux/sched.h              |    4 ++++
 kernel/exit.c                      |    2 ++
 kernel/sched.c                     |    9 ++++++---
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 9fb6cbe..9e03468 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -255,7 +255,7 @@ Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
 ..............................................................................
 
 
-Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
+Table 1-4: Contents of the stat files
 ..............................................................................
  Field          Content
   pid           process id
@@ -303,6 +303,9 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   blkio_ticks   time spent waiting for block IO
   gtime         guest time of the task in jiffies
   cgtime        guest time of the task children in jiffies
+  exec_time     execution time as accounted by scheduler
+  hi_time       hardirq time accounted to this process
+  si_time       softirq time accounted to this process
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b58d38..4555cfb 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -380,6 +380,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	cputime64_t exec_time = 0, si_time = 0, hi_time = 0;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -427,6 +428,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime = cputime_add(gtime, t->gtime);
+				si_time = cputime64_add(si_time, t->si_time);
+				hi_time = cputime64_add(hi_time, t->hi_time);
+				exec_time += t->se.sum_exec_runtime;
 				t = next_thread(t);
 			} while (t != task);
 
@@ -434,6 +438,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			maj_flt += sig->maj_flt;
 			thread_group_times(task, &utime, &stime);
 			gtime = cputime_add(gtime, sig->gtime);
+			si_time = cputime64_add(si_time, sig->si_time);
+			hi_time = cputime64_add(hi_time, sig->hi_time);
+			exec_time += sig->sum_sched_runtime;
 		}
 
 		sid = task_session_nr_ns(task, ns);
@@ -448,6 +455,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
+		si_time = task->si_time;
+		hi_time = task->hi_time;
+		exec_time = task->se.sum_exec_runtime;
 		task_times(task, &utime, &stime);
 		gtime = task->gtime;
 	}
@@ -467,7 +477,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %llu %llu %llu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -514,7 +524,10 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime));
+		cputime_to_clock_t(cgtime),
+		(unsigned long long)nsec_to_clock_t(exec_time),
+		(unsigned long long)cputime64_to_clock_t(hi_time),
+		(unsigned long long)cputime64_to_clock_t(si_time));
 	if (mm)
 		mmput(mm);
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..3ba8cb9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -593,6 +593,8 @@ struct signal_struct {
 	 */
 	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
+	cputime64_t si_time;
+	cputime64_t hi_time;
 	cputime_t cgtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
@@ -1284,6 +1286,8 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
+	cputime64_t si_time;
+	cputime64_t hi_time;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index ceffc67..f87f44c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -116,6 +116,8 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
 		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
+		sig->si_time = cputime64_add(sig->si_time, tsk->si_time);
+		sig->hi_time = cputime64_add(sig->hi_time, tsk->hi_time);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..3c246cb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3232,12 +3232,15 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
-	if (hardirq_count() - hardirq_offset)
+	if (hardirq_count() - hardirq_offset) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+		p->hi_time = cputime64_add(p->hi_time, tmp);
+	} else if (softirq_count()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	else
+		p->si_time = cputime64_add(p->si_time, tmp);
+	} else {
 		cpustat->system = cputime64_add(cpustat->system, tmp);
+	}
 
 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
-- 
1.7.1

