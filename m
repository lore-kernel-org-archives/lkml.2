Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2LZCxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:53:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47254 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2LZCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:53:32 -0500
X-AuditID: 85900ec0-d727cb900000152f-ef-50da66aa22c1
Subject: [PATCH v4 -tip 2/3] tracing: make a snapshot feature available from
 userspace
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        yrl.pp-manager.tt@hitachi.com, masami.hiramatsu.pt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>
Date: Wed, 26 Dec 2012 11:53:00 +0900
Message-ID: <20121226025300.3252.86850.stgit@liselsia>
In-Reply-To: <20121226025243.3252.61095.stgit@liselsia>
References: <20121226025243.3252.61095.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace has a snapshot feature available from kernel space and
latency tracers (e.g. irqsoff) are using it. This patch enables
user applictions to take a snapshot via debugfs.

Add "snapshot" debugfs file in "tracing" directory.

  snapshot:
    This is used to take a snapshot and to read the output of the
    snapshot.

     # echo 1 > snapshot

    This will allocate the spare buffer for snapshot (if it is
    not allocated), and take a snapshot.

     # cat snapshot

    This will show contents of the snapshot.

     # echo 0 > snapshot

    This will free the snapshot if it is allocated.

    Any other positive values will clear the snapshot contents if
    the snapshot is allocated, or return EINVAL if it is not allocated.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/ftrace_event.h |    3 +
 kernel/trace/Kconfig         |   10 +++
 kernel/trace/trace.c         |  134 ++++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace.h         |    1 
 4 files changed, 136 insertions(+), 12 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a3d4895..9bebadd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -84,6 +84,9 @@ struct trace_iterator {
 	long			idx;
 
 	cpumask_var_t		started;
+
+	/* it's true when current open file is snapshot */
+	bool			snapshot;
 };
 
 enum trace_iter_flags {
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5d89335..82a8ff5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -250,6 +250,16 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
+config TRACER_SNAPSHOT
+	bool "Create a snapshot trace buffer"
+	select TRACER_MAX_TRACE
+	help
+	  Allow tracing users to take snapshot of the current buffer using the
+	  ftrace interface, e.g.:
+
+	      echo 1 > /sys/kernel/debug/tracing/snapshot
+	      cat snapshot
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1787304..9522af0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -709,7 +709,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	if (!current_trace->use_max_tr) {
+	if (!current_trace->allocated_snapshot) {
 		WARN_ON_ONCE(1);
 		return;
 	}
@@ -739,7 +739,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	if (!current_trace->use_max_tr) {
+	if (!current_trace->allocated_snapshot) {
 		WARN_ON_ONCE(1);
 		return;
 	}
@@ -1964,7 +1964,11 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		*iter->trace = *current_trace;
 	mutex_unlock(&trace_types_lock);
 
-	atomic_inc(&trace_record_cmdline_disabled);
+	if (iter->snapshot && iter->trace->use_max_tr)
+		return ERR_PTR(-EBUSY);
+
+	if (!iter->snapshot)
+		atomic_inc(&trace_record_cmdline_disabled);
 
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
@@ -2003,7 +2007,11 @@ static void s_stop(struct seq_file *m, void *p)
 {
 	struct trace_iterator *iter = m->private;
 
-	atomic_dec(&trace_record_cmdline_disabled);
+	if (iter->snapshot && iter->trace->use_max_tr)
+		return;
+
+	if (!iter->snapshot)
+		atomic_dec(&trace_record_cmdline_disabled);
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
@@ -2438,7 +2446,7 @@ static const struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct inode *inode, struct file *file)
+__tracing_open(struct inode *inode, struct file *file, bool snapshot)
 {
 	long cpu_file = (long) inode->i_private;
 	struct trace_iterator *iter;
@@ -2471,10 +2479,11 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
 
-	if (current_trace && current_trace->print_max)
+	if ((current_trace && current_trace->print_max) || snapshot)
 		iter->tr = &max_tr;
 	else
 		iter->tr = &global_trace;
+	iter->snapshot = snapshot;
 	iter->pos = -1;
 	mutex_init(&iter->mutex);
 	iter->cpu_file = cpu_file;
@@ -2491,8 +2500,9 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (trace_clocks[trace_clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
-	/* stop the trace while dumping */
-	tracing_stop();
+	/* stop the trace while dumping if we are not opening "snapshot" */
+	if (!iter->snapshot)
+		tracing_stop();
 
 	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
@@ -2555,8 +2565,9 @@ static int tracing_release(struct inode *inode, struct file *file)
 	if (iter->trace && iter->trace->close)
 		iter->trace->close(iter);
 
-	/* reenable tracing if it was previously enabled */
-	tracing_start();
+	if (!iter->snapshot)
+		/* reenable tracing if it was previously enabled */
+		tracing_start();
 	mutex_unlock(&trace_types_lock);
 
 	mutex_destroy(&iter->mutex);
@@ -2584,7 +2595,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(inode, file);
+		iter = __tracing_open(inode, file, false);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
@@ -3215,7 +3226,7 @@ static int tracing_set_tracer(const char *buf)
 	trace_branch_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
-	if (current_trace && current_trace->use_max_tr) {
+	if (current_trace && current_trace->allocated_snapshot) {
 		/*
 		 * We don't free the ring buffer. instead, resize it because
 		 * The max_tr ring buffer has some state (e.g. ring->clock) and
@@ -3223,6 +3234,8 @@ static int tracing_set_tracer(const char *buf)
 		 */
 		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
 		set_buffer_entries(&max_tr, 1);
+		tracing_reset_online_cpus(&max_tr);
+		current_trace->allocated_snapshot = false;
 	}
 	destroy_trace_option_files(topts);
 
@@ -3235,6 +3248,7 @@ static int tracing_set_tracer(const char *buf)
 						   RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
+		t->allocated_snapshot = true;
 	}
 
 	if (t->init) {
@@ -4054,6 +4068,87 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
 	return single_open(file, tracing_clock_show, NULL);
 }
 
+#ifdef CONFIG_TRACER_SNAPSHOT
+static int tracing_snapshot_open(struct inode *inode, struct file *file)
+{
+	struct trace_iterator *iter;
+	int ret = 0;
+
+	if (file->f_mode & FMODE_READ) {
+		iter = __tracing_open(inode, file, true);
+		if (IS_ERR(iter))
+			ret = PTR_ERR(iter);
+	}
+	return ret;
+}
+
+static ssize_t
+tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		       loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&trace_types_lock);
+
+	if (current_trace && current_trace->use_max_tr) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	switch (val) {
+	case 0:
+		if (current_trace->allocated_snapshot) {
+			/* free spare buffer */
+			ring_buffer_resize(max_tr.buffer, 1,
+					   RING_BUFFER_ALL_CPUS);
+			set_buffer_entries(&max_tr, 1);
+			tracing_reset_online_cpus(&max_tr);
+			current_trace->allocated_snapshot = false;
+		}
+		break;
+	case 1:
+		if (!current_trace->allocated_snapshot) {
+			/* allocate spare buffer */
+			ret = resize_buffer_duplicate_size(&max_tr,
+					&global_trace, RING_BUFFER_ALL_CPUS);
+			if (ret < 0)
+				break;
+			current_trace->allocated_snapshot = true;
+		}
+
+		local_irq_disable();
+		/* Now, we're going to swap */
+		update_max_tr(&global_trace, current, smp_processor_id());
+		local_irq_enable();
+		break;
+	default:
+		if (current_trace->allocated_snapshot)
+			tracing_reset_online_cpus(&max_tr);
+		else
+			ret = -EINVAL;
+		break;
+	}
+
+	if (ret >= 0) {
+		*ppos += cnt;
+		ret = cnt;
+	}
+out:
+	mutex_unlock(&trace_types_lock);
+	return ret;
+}
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -4110,6 +4205,16 @@ static const struct file_operations trace_clock_fops = {
 	.write		= tracing_clock_write,
 };
 
+#ifdef CONFIG_TRACER_SNAPSHOT
+static const struct file_operations snapshot_fops = {
+	.open		= tracing_snapshot_open,
+	.read		= seq_read,
+	.write		= tracing_snapshot_write,
+	.llseek		= tracing_seek,
+	.release	= tracing_release,
+};
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
 struct ftrace_buffer_info {
 	struct trace_array	*tr;
 	void			*spare;
@@ -4901,6 +5006,11 @@ static __init int tracer_init_debugfs(void)
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 
+#ifdef CONFIG_TRACER_SNAPSHOT
+	trace_create_file("snapshot", 0644, d_tracer,
+			  (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
+#endif
+
 	create_trace_options_dir();
 
 	for_each_tracing_cpu(cpu)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c75d798..512afe5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -287,6 +287,7 @@ struct tracer {
 	struct tracer_flags	*flags;
 	bool			print_max;
 	bool			use_max_tr;
+	bool			allocated_snapshot;
 };
 
 

