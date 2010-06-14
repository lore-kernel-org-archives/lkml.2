Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0FNVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:41:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:46947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab0FNVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:23 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>, Anton Blanchard <anton@samba.org>
Subject: [PATCH 27/30] workqueue: implement DEBUGFS/workqueue
Date: Mon, 14 Jun 2010 23:37:44 +0200
Message-Id: <1276551467-21246-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement DEBUGFS/workqueue which lists all workers and works for
debugging.  Workqueues can also have ->show_work() callback which
describes a pending or running work in custom way.  If ->show_work()
is missing or returns %false, wchan is printed.

# cat /sys/kernel/debug/workqueue

CPU  ID   PID   WORK ADDR        WORKQUEUE    TIME  DESC
==== ==== ===== ================ ============ ===== ============================
   0    0    15 ffffffffa0004708 test-wq-04     1 s test_work_fn+0x469/0x690 [test_wq]
   0    2  4146                  <IDLE>         0us
   0    1    21                  <IDLE>         4 s
   0 DELA       ffffffffa00047b0 test-wq-04     1 s test work 2
   1    1   418                  <IDLE>       780ms
   1    0    16                  <IDLE>        40 s
   1    2   443                  <IDLE>        40 s

Workqueue debugfs support is suggested by David Howells and
implementation mostly mimics that of slow-work.

* Anton Blanchard spotted that ITER_* constants are overflowing w/
  high cpu configuration.  This was caused by using
  powerup_power_of_two() where order_base_2() should have been used.
  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
---
 include/linux/workqueue.h |   12 ++
 kernel/workqueue.c        |  369 ++++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug         |    7 +
 3 files changed, 384 insertions(+), 4 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index e8c3410..850942a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -17,6 +17,10 @@ struct workqueue_struct;
 struct work_struct;
 typedef void (*work_func_t)(struct work_struct *work);
 
+struct seq_file;
+typedef bool (*show_work_func_t)(struct seq_file *m, struct work_struct *work,
+				 bool running);
+
 /*
  * The first word is the work queue pointer and the flags rolled into
  * one
@@ -70,6 +74,9 @@ struct work_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+	unsigned long timestamp;	/* timestamp for debugfs */
+#endif
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_NO_CPU)
@@ -282,6 +289,11 @@ __create_workqueue_key(const char *name, unsigned int flags, int max_active,
 #define create_singlethread_workqueue(name)			\
 	__create_workqueue((name), WQ_SINGLE_CPU | WQ_RESCUER, 1)
 
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+extern void workqueue_set_show_work(struct workqueue_struct *wq,
+				    show_work_func_t show);
+#endif
+
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b829ddb..ae6e4c7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -119,7 +119,7 @@ struct worker {
 	struct task_struct	*task;		/* I: worker task */
 	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
-	unsigned long		last_active;	/* L: last active timestamp */
+	unsigned long		timestamp;	/* L: last active timestamp */
 	unsigned int		flags;		/* ?: flags */
 	int			id;		/* I: worker id */
 	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
@@ -153,6 +153,9 @@ struct global_cwq {
 	unsigned int		trustee_state;	/* L: trustee state */
 	wait_queue_head_t	trustee_wait;	/* trustee wait */
 	struct worker		*first_idle;	/* L: first idle worker */
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+	struct worker		*manager;	/* L: the current manager */
+#endif
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -208,6 +211,9 @@ struct workqueue_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+	show_work_func_t	show_work;	/* I: show work to debugfs */
+#endif
 };
 
 struct workqueue_struct *system_wq __read_mostly;
@@ -331,6 +337,27 @@ static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
 #endif
 
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+static void work_set_queued_at(struct work_struct *work)
+{
+	work->timestamp = jiffies;
+}
+
+static void worker_set_started_at(struct worker *worker)
+{
+	worker->timestamp = jiffies;
+}
+
+static void gcwq_set_manager(struct global_cwq *gcwq, struct worker *worker)
+{
+	gcwq->manager = worker;
+}
+#else
+static void work_set_queued_at(struct work_struct *work) { }
+static void worker_set_started_at(struct worker *worker) { }
+static void gcwq_set_manager(struct global_cwq *gcwq, struct worker *worker) { }
+#endif
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -685,6 +712,8 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 {
 	struct global_cwq *gcwq = cwq->gcwq;
 
+	work_set_queued_at(work);
+
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
 
@@ -964,7 +993,7 @@ static void worker_enter_idle(struct worker *worker)
 
 	worker->flags |= WORKER_IDLE;
 	gcwq->nr_idle++;
-	worker->last_active = jiffies;
+	worker->timestamp = jiffies;
 
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &gcwq->idle_list);
@@ -1219,7 +1248,7 @@ static void idle_worker_timeout(unsigned long __gcwq)
 
 		/* idle_list is kept in LIFO order, check the last one */
 		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
-		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+		expires = worker->timestamp + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires))
 			mod_timer(&gcwq->idle_timer, expires);
@@ -1357,7 +1386,7 @@ static bool maybe_destroy_workers(struct global_cwq *gcwq)
 		unsigned long expires;
 
 		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
-		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
+		expires = worker->timestamp + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires)) {
 			mod_timer(&gcwq->idle_timer, expires);
@@ -1401,6 +1430,7 @@ static bool manage_workers(struct worker *worker)
 
 	gcwq->flags &= ~GCWQ_MANAGE_WORKERS;
 	gcwq->flags |= GCWQ_MANAGING_WORKERS;
+	gcwq_set_manager(gcwq, worker);
 
 	/*
 	 * Destroy and then create so that may_start_working() is true
@@ -1410,6 +1440,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_create_worker(gcwq);
 
 	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
+	gcwq_set_manager(gcwq, NULL);
 
 	/*
 	 * The trustee might be waiting to take over the manager
@@ -1574,6 +1605,8 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	set_work_cpu(work, gcwq->cpu);
 	list_del_init(&work->entry);
 
+	worker_set_started_at(worker);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -3180,6 +3213,334 @@ out_unlock:
 }
 #endif /* CONFIG_FREEZER */
 
+#ifdef CONFIG_WORKQUEUE_DEBUGFS
+
+#include <linux/seq_file.h>
+#include <linux/log2.h>
+#include <linux/debugfs.h>
+
+/**
+ * workqueue_set_show_work - set show_work callback for a workqueue
+ * @wq: workqueue of interest
+ * @show: show_work callback
+ *
+ * Set show_work callback of @wq to @show.  This is used by workqueue
+ * debugfs support to allow workqueue users to describe the work with
+ * specific details.
+ *
+ * bool (*@show)(struct seq_file *m, struct work_struct *work, bool running);
+ *
+ * It should print to @m without new line.  If @running is set, @show
+ * is responsible for ensuring @work is still accessible.  %true
+ * return suppresses wchan printout.
+ */
+void workqueue_set_show_work(struct workqueue_struct *wq, show_work_func_t show)
+{
+	wq->show_work = show;
+}
+EXPORT_SYMBOL_GPL(workqueue_set_show_work);
+
+enum {
+	ITER_TYPE_MANAGER	= 0,
+	ITER_TYPE_BUSY_WORKER,
+	ITER_TYPE_IDLE_WORKER,
+	ITER_TYPE_PENDING_WORK,
+	ITER_TYPE_DELAYED_WORK,
+	ITER_NR_TYPES,
+
+	/* iter: sign [started bit] [cpu bits] [type bits] [idx bits] */
+	ITER_CPU_BITS		= order_base_2(NR_CPUS),
+	ITER_CPU_MASK		= ((loff_t)1 << ITER_CPU_BITS) - 1,
+	ITER_TYPE_BITS		= order_base_2(ITER_NR_TYPES),
+	ITER_TYPE_MASK		= ((loff_t)1 << ITER_TYPE_BITS) - 1,
+
+	ITER_BITS		= BITS_PER_BYTE * sizeof(loff_t) - 1,
+	ITER_STARTED_BIT	= ITER_BITS - 1,
+	ITER_CPU_SHIFT		= ITER_STARTED_BIT - ITER_CPU_BITS,
+	ITER_TYPE_SHIFT		= ITER_CPU_SHIFT - ITER_TYPE_BITS,
+
+	ITER_IDX_MASK		= ((loff_t)1 << ITER_TYPE_SHIFT) - 1,
+};
+
+struct wq_debugfs_token {
+	struct global_cwq	*gcwq;
+	struct worker		*worker;
+	struct work_struct	*work;
+	bool			work_delayed;
+};
+
+static void wq_debugfs_decode_pos(loff_t pos, unsigned int *cpup, int *typep,
+				  int *idxp)
+{
+	*cpup = (pos >> ITER_CPU_SHIFT) & ITER_CPU_MASK;
+	*typep = (pos >> ITER_TYPE_SHIFT) & ITER_TYPE_MASK;
+	*idxp = pos & ITER_IDX_MASK;
+}
+
+/* try to dereference @pos and set @tok accordingly, %true if successful */
+static bool wq_debugfs_deref_pos(loff_t pos, struct wq_debugfs_token *tok)
+{
+	int type, idx, i;
+	unsigned int cpu;
+	struct global_cwq *gcwq;
+	struct worker *worker;
+	struct work_struct *work;
+	struct hlist_node *hnode;
+	struct workqueue_struct *wq;
+	struct cpu_workqueue_struct *cwq;
+
+	wq_debugfs_decode_pos(pos, &cpu, &type, &idx);
+
+	/* make sure the right gcwq is locked and init @tok */
+	gcwq = get_gcwq(cpu);
+	if (tok->gcwq != gcwq) {
+		if (tok->gcwq)
+			spin_unlock_irq(&tok->gcwq->lock);
+		if (gcwq)
+			spin_lock_irq(&gcwq->lock);
+	}
+	memset(tok, 0, sizeof(*tok));
+	tok->gcwq = gcwq;
+
+	/* dereference index@type and record it in @tok */
+	switch (type) {
+	case ITER_TYPE_MANAGER:
+		if (!idx)
+			tok->worker = gcwq->manager;
+		return tok->worker;
+
+	case ITER_TYPE_BUSY_WORKER:
+		if (idx < gcwq->nr_workers - gcwq->nr_idle)
+			for_each_busy_worker(worker, i, hnode, gcwq)
+				if (!idx--) {
+					tok->worker = worker;
+					return true;
+				}
+		break;
+
+	case ITER_TYPE_IDLE_WORKER:
+		if (idx < gcwq->nr_idle)
+			list_for_each_entry(worker, &gcwq->idle_list, entry)
+				if (!idx--) {
+					tok->worker = worker;
+					return true;
+				}
+		break;
+
+	case ITER_TYPE_PENDING_WORK:
+		list_for_each_entry(work, &gcwq->worklist, entry)
+			if (!idx--) {
+				tok->work = work;
+				return true;
+			}
+		break;
+
+	case ITER_TYPE_DELAYED_WORK:
+		list_for_each_entry(wq, &workqueues, list) {
+			cwq = get_cwq(gcwq->cpu, wq);
+			list_for_each_entry(work, &cwq->delayed_works, entry)
+				if (!idx--) {
+					tok->work = work;
+					tok->work_delayed = true;
+					return true;
+				}
+		}
+		break;
+	}
+	return false;
+}
+
+static bool wq_debugfs_next_pos(loff_t *ppos, bool next_type)
+{
+	int type, idx;
+	unsigned int cpu;
+
+	wq_debugfs_decode_pos(*ppos, &cpu, &type, &idx);
+
+	if (next_type) {
+		/* proceed to the next type */
+		if (++type >= ITER_NR_TYPES) {
+			/* oops, was the last type, to the next cpu */
+			cpu = cpumask_next(cpu, cpu_possible_mask);
+			if (cpu >= nr_cpu_ids)
+				return false;
+			type = ITER_TYPE_MANAGER;
+		}
+		idx = 0;
+	} else	/* bump up the index */
+		idx++;
+
+	*ppos = ((loff_t)1 << ITER_STARTED_BIT) |
+		((loff_t)cpu << ITER_CPU_SHIFT) |
+		((loff_t)type << ITER_TYPE_SHIFT) | idx;
+	return true;
+}
+
+static void wq_debugfs_free_tok(struct wq_debugfs_token *tok)
+{
+	if (tok && tok->gcwq)
+		spin_unlock_irq(&tok->gcwq->lock);
+	kfree(tok);
+}
+
+static void *wq_debugfs_start(struct seq_file *m, loff_t *ppos)
+{
+	struct wq_debugfs_token *tok;
+
+	if (*ppos == 0) {
+		seq_puts(m, "CPU  ID   PID   WORK ADDR        WORKQUEUE    TIME  DESC\n");
+		seq_puts(m, "==== ==== ===== ================ ============ ===== ============================\n");
+		*ppos = (loff_t)1 << ITER_STARTED_BIT |
+		      (loff_t)cpumask_first(cpu_possible_mask) << ITER_CPU_BITS;
+	}
+
+	tok = kzalloc(sizeof(*tok), GFP_KERNEL);
+	if (!tok)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&workqueue_lock);
+
+	while (!wq_debugfs_deref_pos(*ppos, tok)) {
+		if (!wq_debugfs_next_pos(ppos, true)) {
+			wq_debugfs_free_tok(tok);
+			return NULL;
+		}
+	}
+	return tok;
+}
+
+static void *wq_debugfs_next(struct seq_file *m, void *p, loff_t *ppos)
+{
+	struct wq_debugfs_token *tok = p;
+
+	wq_debugfs_next_pos(ppos, false);
+
+	while (!wq_debugfs_deref_pos(*ppos, tok)) {
+		if (!wq_debugfs_next_pos(ppos, true)) {
+			wq_debugfs_free_tok(tok);
+			return NULL;
+		}
+	}
+	return tok;
+}
+
+static void wq_debugfs_stop(struct seq_file *m, void *p)
+{
+	wq_debugfs_free_tok(p);
+	spin_unlock(&workqueue_lock);
+}
+
+static void wq_debugfs_print_duration(struct seq_file *m,
+				      unsigned long timestamp)
+{
+	const char *units[] =	{ "us", "ms", " s", " m", " h", " d" };
+	const int factors[] =	{ 1000, 1000,   60,   60,   24,    0 };
+	unsigned long v = jiffies_to_usecs(jiffies - timestamp);
+	int i;
+
+	for (i = 0; v > 999 && i < ARRAY_SIZE(units) - 1; i++)
+		v /= factors[i];
+
+	seq_printf(m, "%3lu%s ", v, units[i]);
+}
+
+static int wq_debugfs_show(struct seq_file *m, void *p)
+{
+	struct wq_debugfs_token *tok = p;
+	struct worker *worker = NULL;
+	struct global_cwq *gcwq;
+	struct work_struct *work;
+	struct workqueue_struct *wq;
+	const char *name;
+	unsigned long timestamp;
+	char id_buf[11] = "", pid_buf[11] = "", addr_buf[17] = "";
+	bool showed = false;
+
+	if (tok->work) {
+		work = tok->work;
+		gcwq = get_work_gcwq(work);
+		wq = get_work_cwq(work)->wq;
+		name = wq->name;
+		timestamp = work->timestamp;
+
+		if (tok->work_delayed)
+			strncpy(id_buf, "DELA", sizeof(id_buf));
+		else
+			strncpy(id_buf, "PEND", sizeof(id_buf));
+	} else {
+		worker = tok->worker;
+		gcwq = worker->gcwq;
+		work = worker->current_work;
+		timestamp = worker->timestamp;
+
+		snprintf(id_buf, sizeof(id_buf), "%4d", worker->id);
+		snprintf(pid_buf, sizeof(pid_buf), "%4d",
+			 task_pid_nr(worker->task));
+
+		if (work) {
+			wq = worker->current_cwq->wq;
+			name = wq->name;
+		} else {
+			wq = NULL;
+			if (worker->gcwq->manager == worker)
+				name = "<MANAGER>";
+			else
+				name = "<IDLE>";
+		}
+	}
+
+	if (work)
+		snprintf(addr_buf, sizeof(addr_buf), "%16p", work);
+
+	seq_printf(m, "%4d %4s %5s %16s %-12s ",
+		   gcwq->cpu, id_buf, pid_buf, addr_buf, name);
+
+	wq_debugfs_print_duration(m, timestamp);
+
+	if (wq && work && wq->show_work)
+		showed = wq->show_work(m, work, worker != NULL);
+	if (!showed && worker && work) {
+		char buf[KSYM_SYMBOL_LEN];
+
+		sprint_symbol(buf, get_wchan(worker->task));
+		seq_printf(m, "%s", buf);
+	}
+
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static const struct seq_operations wq_debugfs_ops = {
+	.start		= wq_debugfs_start,
+	.next		= wq_debugfs_next,
+	.stop		= wq_debugfs_stop,
+	.show		= wq_debugfs_show,
+};
+
+static int wq_debugfs_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &wq_debugfs_ops);
+}
+
+static const struct file_operations wq_debugfs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= wq_debugfs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init init_workqueue_debugfs(void)
+{
+	debugfs_create_file("workqueue", S_IFREG | 0400, NULL, NULL,
+			    &wq_debugfs_fops);
+	return 0;
+}
+late_initcall(init_workqueue_debugfs);
+
+#endif /* CONFIG_WORKQUEUE_DEBUGFS */
+
 void __init init_workqueues(void)
 {
 	unsigned int cpu;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..99b1690 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1117,6 +1117,13 @@ config ATOMIC64_SELFTEST
 
 	  If unsure, say N.
 
+config WORKQUEUE_DEBUGFS
+	bool "Enable workqueue debugging info via debugfs"
+	depends on DEBUG_FS
+	help
+	  Enable debug FS support for workqueue.  Information about all the
+	  current workers and works is available through <debugfs>/workqueue.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
-- 
1.6.4.2

