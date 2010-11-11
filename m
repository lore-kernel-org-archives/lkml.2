Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0KKRIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:08:44 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:58701 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0KKRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:21 -0500
Message-Id: <20101111170813.527389224@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:53 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command TASKSTATS_CMD_ATTR_PIDS
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=01-taskstats-top-cmd-pids.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

The new command is designed to be used by commands like "top" that want
to create a snapshot of the running tasks. The command has the following
arguments:

 * pid:  PID to start searching
 * cnt:  Maximum number of taskstats to be returned
 * time: Timestamp (sched_clock)

The semantics of the command is as follows:

Return at most 'cnt' taskstats greater or equal to 'pid' for tasks that have
been or still are in state TASK_RUNNING between the given 'time' and now.
'time' correlates to the new taskstats field time_ns.

If no more taskstats are found, a final zero taskstats struct is returned that
marks the end of the netlink transmission.

As clock for 'now' and 'time' the sched_clock() function is used and the patch
adds a new field last_depart to the sched_info structure.

Sequence numbers are used to ensure reliable netlink communication with user
space. The first taskstat is returned with the same sequence number as the
command. Following taskstats are transmitted using ascending sequence numbers.

The new command can be used by user space as follows (pseudo code):

Initial: Get taskstats for all tasks

   int start_pid = 0, start_time = 0, oldest_time = INT_MAX;
   struct taskstats taskstats_vec[50];

   do {
          cnt = cmd_pids(start_pid, start_time, taskstats_vec, 50);
          for (i = 0; i < cnt; i++)
                  oldest_time = MIN(oldest_time, taskstats_vec[i].time_ns);
          update_database(taskstats_vec, cnt);
          start_pid = taskstats_vec[cnt - 1].ac_pid;
   } while (cnt == 50);

Update: Get all taskstats for tasks that were active after 'oldest_time'

   new_oldest_time = INT_MAX;
   start_pid = 0;
   do {
          cnt = cmd_pids(start_pid, oldest_time, taskstats_vec, 50);
          for (i = 0; i < cnt; i++)
                  new_oldest_time = MIN(new_oldest_time,
                                        taskstats_vec[i].time_ns);
          update_database(taskstats_vec, cnt);
          start_pid = taskstats_vec[cnt - 1].ac_pid;
   } while (cnt == 50);
   oldest_time = new_oldest_time;

The current approach assumes that sched_clock() can't wrap. If this
assumption is not true, things will become more difficult. The taskstats code
has to detect that sched_clock() wrapped since the last query and then return
a notification to user space. User space could then use oldest_time=0 to
resynchronize.

GOALS OF THIS PATCH
-------------------
Compared to the already existing taskstats command TASKSTATS_CMD_ATTR_PID,
the new command has the following advantages for implementing tools like top:
* No scan of procfs files necessary to find out running tasks.
* A consistent snapshot of task data is possible, if all taskstats can be
  transferred to the socket buffer.
* When using the 'time' parameter, only active tasks have to be transferred.
  This could be used for a special 'low CPU overhead' monitoring mode.
* Less system calls are necessary because only one command has to be sent
  for receiving multiple taskstasts.

OPEN ISSUES
-----------
* Because of the netlink socket buffer size restriction (default 64KB) it
  is not possible to transfer a consistent full taskstats snapshot that
  contains all tasks. See the procfs patch as a proposal to solve this problem.
* Is it a good idea to use the tasklist_lock for snapshot? To get a
  really consistent snapshot this is probably necessary.
* Force only non idle CPUs to account.
* Possible inconsistent data, because we use first taskstats_fill_atomic() and
  afterwards taskstats_fill_sleep().
* Complete the aggregation of swapper tasks.
* Add more filters besides of the 'time' parameter?
* Find a solution, if sched_clock() can wrap.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/sched.h          |    4 
 include/linux/taskstats.h      |   13 ++
 include/linux/taskstats_kern.h |    9 +
 include/linux/tsacct_kern.h    |    4 
 kernel/Makefile                |    2 
 kernel/sched.c                 |    6 +
 kernel/sched_stats.h           |    1 
 kernel/taskstats.c             |   89 +++++++++++++++++-
 kernel/taskstats_snap.c        |  199 +++++++++++++++++++++++++++++++++++++++++
 kernel/tsacct.c                |   32 ++++--
 10 files changed, 339 insertions(+), 20 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -718,7 +718,8 @@ struct sched_info {
 
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
-			   last_queued;	/* when we were last queued to run */
+			   last_queued,	/* when we were last queued to run */
+			   last_depart;	/* when we last departed from a cpu */
 #ifdef CONFIG_SCHEDSTATS
 	/* BKL stats */
 	unsigned int bkl_count;
@@ -1298,6 +1299,7 @@ struct task_struct {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
 #endif
+	unsigned long long acct_time;		/* Time for last accounting */
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -33,7 +33,7 @@
  */
 
 
-#define TASKSTATS_VERSION	7
+#define TASKSTATS_VERSION	8
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -163,6 +163,10 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
+	/* version 7 ends here */
+
+	/* Timestamp where data has been collected in ns since boot time */
+	__u64	time_ns;
 };
 
 
@@ -199,9 +203,16 @@ enum {
 	TASKSTATS_CMD_ATTR_TGID,
 	TASKSTATS_CMD_ATTR_REGISTER_CPUMASK,
 	TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
+	TASKSTATS_CMD_ATTR_PIDS,
 	__TASKSTATS_CMD_ATTR_MAX,
 };
 
+struct taskstats_cmd_pids {
+	__u64	time_ns;
+	__u32	pid;
+	__u32	cnt;
+};
+
 #define TASKSTATS_CMD_ATTR_MAX (__TASKSTATS_CMD_ATTR_MAX - 1)
 
 /* NETLINK_GENERIC related info */
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -23,6 +23,15 @@ static inline void taskstats_tgid_free(s
 
 extern void taskstats_exit(struct task_struct *, int group_dead);
 extern void taskstats_init_early(void);
+extern void taskstats_fill(struct task_struct *tsk, struct taskstats *stats);
+extern int taskstats_snap(int pid_start, int cnt, u64 time_ns,
+			  struct taskstats *stats_vec);
+extern int taskstats_snap_user(int pid_start, int cnt, u64 time_ns,
+			       struct taskstats *stats_vec);
+extern void taskstats_fill_atomic(struct task_struct *tsk,
+				  struct taskstats *stats);
+extern void taskstats_fill_sleep(struct task_struct *tsk,
+				 struct taskstats *stats);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -18,11 +18,15 @@ static inline void bacct_add_tsk(struct
 
 #ifdef CONFIG_TASK_XACCT
 extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+extern void xacct_add_tsk_mem(struct taskstats *stats, struct task_struct *p);
 extern void acct_update_integrals(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
+static inline void xacct_add_tsk_mem(struct taskstats *stats,
+				     struct task_struct *p)
+{}
 static inline void acct_update_integrals(struct task_struct *tsk)
 {}
 static inline void acct_clear_integrals(struct task_struct *tsk)
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -90,7 +90,7 @@ obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutin
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
-obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o taskstats_snap.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9400,4 +9400,10 @@ void synchronize_sched_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
+struct task_struct *get_swapper(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	return rq->idle;
+}
+
 #endif /* #else #ifndef CONFIG_SMP */
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -218,6 +218,7 @@ static inline void sched_info_depart(str
 	unsigned long long delta = task_rq(t)->clock -
 					t->sched_info.last_arrival;
 
+	t->sched_info.last_depart = task_rq(t)->clock;
 	rq_sched_info_depart(task_rq(t), delta);
 
 	if (t->state == TASK_RUNNING)
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -27,6 +27,7 @@
 #include <linux/cgroup.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/vmalloc.h>
 #include <net/genetlink.h>
 #include <asm/atomic.h>
 
@@ -51,7 +52,8 @@ static const struct nla_policy taskstats
 	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
-	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
+	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },
+	[TASKSTATS_CMD_ATTR_PIDS] = { .type = NLA_BINARY },};
 
 static const struct nla_policy cgroupstats_cmd_get_policy[CGROUPSTATS_CMD_ATTR_MAX+1] = {
 	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
@@ -175,9 +177,12 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
-static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
+void taskstats_fill_atomic(struct task_struct *tsk, struct taskstats *stats)
 {
 	memset(stats, 0, sizeof(*stats));
+	preempt_disable();
+	stats->time_ns = sched_clock();
+	preempt_enable();
 	/*
 	 * Each accounting subsystem adds calls to its functions to
 	 * fill in relevant parts of struct taskstsats as follows
@@ -197,6 +202,17 @@ static void fill_stats(struct task_struc
 	xacct_add_tsk(stats, tsk);
 }
 
+void taskstats_fill_sleep(struct task_struct *tsk, struct taskstats *stats)
+{
+	xacct_add_tsk_mem(stats, tsk);
+}
+
+void taskstats_fill(struct task_struct *tsk, struct taskstats *stats)
+{
+	taskstats_fill_atomic(tsk, stats);
+	taskstats_fill_sleep(tsk, stats);
+}
+
 static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
 {
 	struct task_struct *tsk;
@@ -208,7 +224,7 @@ static int fill_stats_for_pid(pid_t pid,
 	rcu_read_unlock();
 	if (!tsk)
 		return -ESRCH;
-	fill_stats(tsk, stats);
+	taskstats_fill(tsk, stats);
 	put_task_struct(tsk);
 	return 0;
 }
@@ -424,6 +440,68 @@ err:
 	return rc;
 }
 
+static int cmd_attr_pids(struct genl_info *info)
+{
+	struct taskstats_cmd_pids *cmd_pids;
+	struct taskstats *stats_vec;
+	struct sk_buff *rep_skb;
+	struct taskstats *stats;
+	unsigned int tsk_cnt, i;
+	size_t size;
+	int  rc;
+
+	size = nla_total_size(sizeof(u32)) +
+		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
+	cmd_pids = nla_data(info->attrs[TASKSTATS_CMD_ATTR_PIDS]);
+
+	if (cmd_pids->cnt > 1000) // XXX socket buffer size check
+		return -EINVAL;
+
+	stats_vec = vmalloc(sizeof(struct taskstats) * cmd_pids->cnt);
+	if (!stats_vec)
+		return -ENOMEM;
+
+	rc = taskstats_snap(cmd_pids->pid, cmd_pids->cnt,
+			    cmd_pids->time_ns, stats_vec);
+	if (rc < 0)
+		goto fail_vfree;
+	tsk_cnt = rc;
+	for (i = 0; i < min(cmd_pids->cnt, tsk_cnt + 1); i++) {
+		rc = prepare_reply(info, TASKSTATS_CMD_NEW, &rep_skb, size);
+		if (rc < 0)
+			goto fail_vfree;
+		if (i < tsk_cnt) {
+			stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID,
+					 stats_vec[i].ac_pid);
+			if (!stats) {
+				rc = -ENOMEM;
+				goto fail_nlmsg_free;
+			}
+			memcpy(stats, &stats_vec[i], sizeof(*stats));
+		} else {
+			/* zero taskstats marks end of transmission */
+			stats = mk_reply(rep_skb, TASKSTATS_TYPE_PID, 0);
+			if (!stats) {
+				rc = -ENOMEM;
+				goto fail_nlmsg_free;
+			}
+			memset(stats, 0, sizeof(*stats));
+		}
+		rc = send_reply(rep_skb, info);
+		if (rc)
+			goto fail_nlmsg_free;
+		info->snd_seq++;
+	}
+	vfree(stats_vec);
+	return 0;
+
+fail_nlmsg_free:
+	nlmsg_free(rep_skb);
+fail_vfree:
+	vfree(stats_vec);
+	return rc;
+}
+
 static int cmd_attr_register_cpumask(struct genl_info *info)
 {
 	cpumask_var_t mask;
@@ -526,6 +604,8 @@ static int taskstats_user_cmd(struct sk_
 		return cmd_attr_pid(info);
 	else if (info->attrs[TASKSTATS_CMD_ATTR_TGID])
 		return cmd_attr_tgid(info);
+	else if (info->attrs[TASKSTATS_CMD_ATTR_PIDS])
+		return cmd_attr_pids(info);
 	else
 		return -EINVAL;
 }
@@ -593,7 +673,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	fill_stats(tsk, stats);
+	taskstats_fill(tsk, stats);
 
 	/*
 	 * Doesn't matter if tsk is the leader or the last group member leaving
@@ -653,7 +733,6 @@ static int __init taskstats_init(void)
 	rc = genl_register_ops(&family, &cgroupstats_ops);
 	if (rc < 0)
 		goto err_cgroup_ops;
-
 	family_registered = 1;
 	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
--- /dev/null
+++ b/kernel/taskstats_snap.c
@@ -0,0 +1,199 @@
+/*
+ * taskstats_snap.c - Create exact taskstats snapshot
+ *
+ * Copyright IBM Corp. 2010
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <linux/taskstats_kern.h>
+#include <linux/pid_namespace.h>
+#include <linux/kernel_stat.h>
+#include <linux/vmalloc.h>
+#include <asm/uaccess.h>
+
+static DECLARE_WAIT_QUEUE_HEAD(snapshot_wait);
+static atomic_t snapshot_use;
+
+static int wait_snapshot(void)
+{
+	while (atomic_cmpxchg(&snapshot_use, 0, 1) != 0) {
+		if (wait_event_interruptible(snapshot_wait,
+					     atomic_read(&snapshot_use) == 0))
+			return -ERESTARTSYS;
+	}
+	return 0;
+}
+
+static void wake_up_snapshot(void)
+{
+	atomic_set(&snapshot_use, 0);
+	wake_up_interruptible(&snapshot_wait);
+}
+
+static void force_accounting(void *ptr)
+{
+	account_process_tick(current, 1);
+}
+
+/*
+ * TODO Do not force idle CPUs to do accounting
+ */
+static void account_online_cpus(void)
+{
+	smp_call_function(force_accounting, NULL, 1);
+}
+
+extern struct task_struct *get_swapper(int cpu);
+
+/*
+ * TODO Implement complete taskstasts_add() function that aggregates
+ *      all fields.
+ */
+static void taskstats_add(struct taskstats *ts1, struct taskstats *ts2)
+{
+	ts1->ac_utime += ts2->ac_utime;
+	ts1->ac_stime += ts2->ac_stime;
+	ts1->ac_sttime += ts2->ac_sttime;
+}
+
+static struct task_struct *find_next_task(int pid_start, u64 time_ns)
+{
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
+	struct task_struct *tsk;
+	struct pid *pid;
+
+	do {
+		pid = find_ge_pid(pid_start, ns);
+		if (!pid) {
+			tsk = NULL;
+			break;
+		}
+		tsk = pid_task(pid, PIDTYPE_PID);
+		if (tsk && (tsk->state == TASK_RUNNING ||
+		    tsk->sched_info.last_depart > time_ns)) {
+			get_task_struct(tsk);
+			break;
+		}
+		pid_start++;
+	} while (1);
+	return tsk;
+}
+
+int taskstats_snap(int pid_start, int cnt, u64 time_ns,
+		   struct taskstats *stats_vec)
+{
+	int tsk_cnt = 0, rc, i, cpu, first = 1;
+	struct task_struct *tsk, **tsk_vec;
+	u32 pid_curr = pid_start;
+	struct taskstats *ts;
+	u64 task_snap_time;
+
+	rc = wait_snapshot();
+	if (rc)
+		return rc;
+
+	rc = -ENOMEM;
+	tsk_vec = kmalloc(sizeof(struct task_struct *) * cnt, GFP_KERNEL);
+	if (!tsk_vec)
+		goto fail_wake_up_snapshot;
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		goto fail_free_tsk_vec;
+
+	task_snap_time = sched_clock();
+
+	/*
+	 * Force running CPUs to do accounting
+	 */
+	account_online_cpus();
+
+	read_lock(&tasklist_lock);
+
+	/*
+	 * Aggregate swapper tasks (pid = 0)
+	 */
+	if (pid_curr == 0) {
+		for_each_online_cpu(cpu) {
+			tsk = get_swapper(cpu);
+			if (tsk->state != TASK_RUNNING &&
+			    tsk->sched_info.last_depart < time_ns)
+				continue;
+			if (first) {
+				tsk_vec[0] = tsk;
+				taskstats_fill_atomic(tsk, &stats_vec[tsk_cnt]);
+				stats_vec[tsk_cnt].ac_pid = 0;
+				first = 0;
+			} else {
+				taskstats_fill_atomic(tsk, ts);
+				taskstats_add(&stats_vec[tsk_cnt], ts);
+			}
+			if (tsk->acct_time < task_snap_time)
+				stats_vec[tsk_cnt].time_ns = task_snap_time;
+			else
+				stats_vec[tsk_cnt].time_ns = tsk->acct_time;
+		}
+		tsk_cnt++;
+		pid_curr++;
+	}
+	/*
+	 * Collect normal tasks (pid >=1)
+	 */
+	do {
+		tsk = find_next_task(pid_curr, time_ns);
+		if (!tsk)
+			break;
+		taskstats_fill_atomic(tsk, &stats_vec[tsk_cnt]);
+		tsk_vec[tsk_cnt] = tsk;
+		if (tsk->acct_time < task_snap_time)
+			stats_vec[tsk_cnt].time_ns = task_snap_time;
+		else
+			stats_vec[tsk_cnt].time_ns = tsk->acct_time;
+		tsk_cnt++;
+		pid_curr = next_pidmap(current->nsproxy->pid_ns, tsk->pid);
+	} while (tsk_cnt != cnt);
+
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * Add rest of accounting information that we can't add under lock
+	 */
+	for (i = 0; i < tsk_cnt; i++) {
+		if (tsk_vec[i]->pid == 0)
+			continue;
+		taskstats_fill_sleep(tsk_vec[i], &stats_vec[i]);
+		put_task_struct(tsk_vec[i]);
+	}
+	rc = tsk_cnt;
+
+	kfree(ts);
+fail_free_tsk_vec:
+	kfree(tsk_vec);
+fail_wake_up_snapshot:
+	wake_up_snapshot();
+	return rc;
+}
+
+int taskstats_snap_user(int pid_start, int cnt, u64 time_ns,
+			struct taskstats *stats_vec)
+{
+	struct taskstats *stats_vec_int;
+	int i, tsk_cnt, rc;
+
+	stats_vec_int = vmalloc(sizeof(struct taskstats) * cnt);
+	if (!stats_vec)
+		return -ENOMEM;
+
+	tsk_cnt = taskstats_snap(pid_start, cnt, time_ns, stats_vec_int);
+
+	for (i = 0; i < tsk_cnt; i++) {
+		if (copy_to_user(&stats_vec[i], &stats_vec_int[i],
+				 sizeof(struct taskstats))) {
+			rc = -EFAULT;
+			goto out;
+		}
+	}
+	rc = tsk_cnt;
+out:
+	vfree(stats_vec_int);
+	return rc;
+}
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -83,18 +83,6 @@ void bacct_add_tsk(struct taskstats *sta
  */
 void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {
-	struct mm_struct *mm;
-
-	/* convert pages-usec to Mbyte-usec */
-	stats->coremem = p->acct_rss_mem1 * PAGE_SIZE / MB;
-	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
-	mm = get_task_mm(p);
-	if (mm) {
-		/* adjust to KB unit */
-		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
-		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
-		mmput(mm);
-	}
 	stats->read_char	= p->ioac.rchar;
 	stats->write_char	= p->ioac.wchar;
 	stats->read_syscalls	= p->ioac.syscr;
@@ -109,6 +97,26 @@ void xacct_add_tsk(struct taskstats *sta
 	stats->cancelled_write_bytes = 0;
 #endif
 }
+
+/*
+ * fill in memory data (function can sleep)
+ */
+void xacct_add_tsk_mem(struct taskstats *stats, struct task_struct *p)
+{
+	struct mm_struct *mm;
+
+	/* convert pages-usec to Mbyte-usec */
+	stats->coremem = p->acct_rss_mem1 * PAGE_SIZE / MB;
+	stats->virtmem = p->acct_vm_mem1 * PAGE_SIZE / MB;
+	mm = get_task_mm(p);
+	if (mm) {
+		/* adjust to KB unit */
+		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
+		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
+		mmput(mm);
+	}
+}
+
 #undef KB
 #undef MB
 

