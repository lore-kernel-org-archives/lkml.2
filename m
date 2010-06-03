Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0FCSkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:40:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0FCSkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:40:22 -0400
Date: Thu, 3 Jun 2010 20:39:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] perf fixes
Message-ID: <20100603183954.GA26533@elte.hu>
References: <20100602122838.GA23393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602122838.GA23393@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest perf-fixes-for-linus git tree from:

Here's an updated -2 tree which includes one more fix for a crasher, found by 
Frederic yesterday:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus-2

Would be nice to have that in -rc2.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf buildid-list: Fix --with-hits event processing

Borislav Petkov (1):
      perf-record: Check correct pid when forking

Frederic Weisbecker (4):
      perf_events: Fix unincremented buffer base on partial copy
      perf: Process comm events by tid
      perf: Use event__process_task from perf sched
      perf: Do the comm inheritance per thread in event__process_task

Konstantin Stepanyuk (1):
      perf hist: fix objdump output parsing

Peter Zijlstra (5):
      perf_events: Fix races and clean up perf_event and perf_mmap_data interaction
      perf_events: Fix races in group composition
      perf_events, trace: Fix probe unregister race
      perf_events, trace: Fix perf_trace_destroy(), mutex went missing
      perf: Fix crash in swevents

Pierre Tardy (1):
      perf scripts python: Give field dict to unhandled callback

Randy Dunlap (1):
      blktrace: Fix new kernel-doc warnings

Stephane Eranian (1):
      perf_events: Fix event scheduling issues introduced by transactional API


 arch/x86/kernel/cpu/perf_event.c                   |   22 ++
 include/linux/perf_event.h                         |    9 +-
 include/trace/ftrace.h                             |    2 +-
 kernel/perf_event.c                                |  351 ++++++++++++--------
 kernel/trace/blktrace.c                            |    2 +
 kernel/trace/trace_event_perf.c                    |   15 +-
 kernel/trace/trace_kprobe.c                        |    4 +-
 kernel/trace/trace_syscalls.c                      |    4 +-
 tools/perf/builtin-buildid-list.c                  |    4 +-
 tools/perf/builtin-record.c                        |    3 +-
 tools/perf/builtin-sched.c                         |    1 +
 tools/perf/scripts/python/check-perf-trace.py      |    3 +-
 tools/perf/util/event.c                            |   13 +-
 tools/perf/util/hist.c                             |    2 +-
 .../util/scripting-engines/trace-event-python.c    |   50 ++-
 15 files changed, 309 insertions(+), 176 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c775860..5db5b7d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -106,6 +106,7 @@ struct cpu_hw_events {
 
 	int			n_events;
 	int			n_added;
+	int			n_txn;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
@@ -983,6 +984,7 @@ static int x86_pmu_enable(struct perf_event *event)
 out:
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
+	cpuc->n_txn += n - n0;
 
 	return 0;
 }
@@ -1089,6 +1091,14 @@ static void x86_pmu_disable(struct perf_event *event)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int i;
 
+	/*
+	 * If we're called during a txn, we don't need to do anything.
+	 * The events never got scheduled and ->cancel_txn will truncate
+	 * the event_list.
+	 */
+	if (cpuc->group_flag & PERF_EVENT_TXN_STARTED)
+		return;
+
 	x86_pmu_stop(event);
 
 	for (i = 0; i < cpuc->n_events; i++) {
@@ -1379,6 +1389,7 @@ static void x86_pmu_start_txn(const struct pmu *pmu)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	cpuc->group_flag |= PERF_EVENT_TXN_STARTED;
+	cpuc->n_txn = 0;
 }
 
 /*
@@ -1391,6 +1402,11 @@ static void x86_pmu_cancel_txn(const struct pmu *pmu)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN_STARTED;
+	/*
+	 * Truncate the collected events.
+	 */
+	cpuc->n_added -= cpuc->n_txn;
+	cpuc->n_events -= cpuc->n_txn;
 }
 
 /*
@@ -1419,6 +1435,12 @@ static int x86_pmu_commit_txn(const struct pmu *pmu)
 	 */
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
+	/*
+	 * Clear out the txn count so that ->cancel_txn() which gets
+	 * run after ->commit_txn() doesn't undo things.
+	 */
+	cpuc->n_txn = 0;
+
 	return 0;
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fb6c91e..5d0266d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -585,6 +585,7 @@ enum perf_event_active_state {
 struct file;
 
 struct perf_mmap_data {
+	atomic_t			refcount;
 	struct rcu_head			rcu_head;
 #ifdef CONFIG_PERF_USE_VMALLOC
 	struct work_struct		work;
@@ -592,7 +593,6 @@ struct perf_mmap_data {
 #endif
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
-	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
@@ -631,6 +631,9 @@ struct swevent_hlist {
 	struct rcu_head		rcu_head;
 };
 
+#define PERF_ATTACH_CONTEXT	0x01
+#define PERF_ATTACH_GROUP	0x02
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -643,10 +646,10 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
-	struct perf_event		*output;
 	const struct pmu		*pmu;
 
 	enum perf_event_active_state	state;
+	unsigned int			attach_state;
 	atomic64_t			count;
 
 	/*
@@ -704,6 +707,8 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
 	struct perf_mmap_data		*data;
 
 	/* poll related */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 3d685d1..5a64905 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -725,7 +725,7 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = per_cpu_ptr(event_call->perf_events, smp_processor_id());\
+	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head);				\
 }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bd7ce8c..31d6afe 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -283,14 +283,15 @@ ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
 static void
 list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	struct perf_event *group_leader = event->group_leader;
+	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_CONTEXT);
+	event->attach_state |= PERF_ATTACH_CONTEXT;
 
 	/*
-	 * Depending on whether it is a standalone or sibling event,
-	 * add it straight to the context's event list, or to the group
-	 * leader's sibling list:
+	 * If we're a stand alone event or group leader, we go to the context
+	 * list, group events are kept attached to the group so that
+	 * perf_group_detach can, at all times, locate all siblings.
 	 */
-	if (group_leader == event) {
+	if (event->group_leader == event) {
 		struct list_head *list;
 
 		if (is_software_event(event))
@@ -298,13 +299,6 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 
 		list = ctx_group_list(event, ctx);
 		list_add_tail(&event->group_entry, list);
-	} else {
-		if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
-		    !is_software_event(event))
-			group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
-
-		list_add_tail(&event->group_entry, &group_leader->sibling_list);
-		group_leader->nr_siblings++;
 	}
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
@@ -313,6 +307,24 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 		ctx->nr_stat++;
 }
 
+static void perf_group_attach(struct perf_event *event)
+{
+	struct perf_event *group_leader = event->group_leader;
+
+	WARN_ON_ONCE(event->attach_state & PERF_ATTACH_GROUP);
+	event->attach_state |= PERF_ATTACH_GROUP;
+
+	if (group_leader == event)
+		return;
+
+	if (group_leader->group_flags & PERF_GROUP_SOFTWARE &&
+			!is_software_event(event))
+		group_leader->group_flags &= ~PERF_GROUP_SOFTWARE;
+
+	list_add_tail(&event->group_entry, &group_leader->sibling_list);
+	group_leader->nr_siblings++;
+}
+
 /*
  * Remove a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
@@ -320,17 +332,22 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
-	if (list_empty(&event->group_entry))
+	/*
+	 * We can have double detach due to exit/hot-unplug + close.
+	 */
+	if (!(event->attach_state & PERF_ATTACH_CONTEXT))
 		return;
+
+	event->attach_state &= ~PERF_ATTACH_CONTEXT;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
 
-	list_del_init(&event->group_entry);
 	list_del_rcu(&event->event_entry);
 
-	if (event->group_leader != event)
-		event->group_leader->nr_siblings--;
+	if (event->group_leader == event)
+		list_del_init(&event->group_entry);
 
 	update_group_times(event);
 
@@ -345,21 +362,39 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 		event->state = PERF_EVENT_STATE_OFF;
 }
 
-static void
-perf_destroy_group(struct perf_event *event, struct perf_event_context *ctx)
+static void perf_group_detach(struct perf_event *event)
 {
 	struct perf_event *sibling, *tmp;
+	struct list_head *list = NULL;
+
+	/*
+	 * We can have double detach due to exit/hot-unplug + close.
+	 */
+	if (!(event->attach_state & PERF_ATTACH_GROUP))
+		return;
+
+	event->attach_state &= ~PERF_ATTACH_GROUP;
+
+	/*
+	 * If this is a sibling, remove it from its group.
+	 */
+	if (event->group_leader != event) {
+		list_del_init(&event->group_entry);
+		event->group_leader->nr_siblings--;
+		return;
+	}
+
+	if (!list_empty(&event->group_entry))
+		list = &event->group_entry;
 
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
-	 * to the context list directly:
+	 * to whatever list we are on.
 	 */
 	list_for_each_entry_safe(sibling, tmp, &event->sibling_list, group_entry) {
-		struct list_head *list;
-
-		list = ctx_group_list(event, ctx);
-		list_move_tail(&sibling->group_entry, list);
+		if (list)
+			list_move_tail(&sibling->group_entry, list);
 		sibling->group_leader = sibling;
 
 		/* Inherit group flags from the previous leader */
@@ -652,8 +687,11 @@ group_sched_in(struct perf_event *group_event,
 	if (txn)
 		pmu->start_txn(pmu);
 
-	if (event_sched_in(group_event, cpuctx, ctx))
+	if (event_sched_in(group_event, cpuctx, ctx)) {
+		if (txn)
+			pmu->cancel_txn(pmu);
 		return -EAGAIN;
+	}
 
 	/*
 	 * Schedule in siblings as one group (if any):
@@ -675,9 +713,6 @@ group_sched_in(struct perf_event *group_event,
 	}
 
 group_error:
-	if (txn)
-		pmu->cancel_txn(pmu);
-
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
@@ -689,6 +724,9 @@ group_error:
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
+	if (txn)
+		pmu->cancel_txn(pmu);
+
 	return -EAGAIN;
 }
 
@@ -727,6 +765,7 @@ static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
 	list_add_event(event, ctx);
+	perf_group_attach(event);
 	event->tstamp_enabled = ctx->time;
 	event->tstamp_running = ctx->time;
 	event->tstamp_stopped = ctx->time;
@@ -1841,6 +1880,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void perf_pending_sync(struct perf_event *event);
+static void perf_mmap_data_put(struct perf_mmap_data *data);
 
 static void free_event(struct perf_event *event)
 {
@@ -1856,9 +1896,9 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&nr_task_events);
 	}
 
-	if (event->output) {
-		fput(event->output->filp);
-		event->output = NULL;
+	if (event->data) {
+		perf_mmap_data_put(event->data);
+		event->data = NULL;
 	}
 
 	if (event->destroy)
@@ -1893,8 +1933,8 @@ int perf_event_release_kernel(struct perf_event *event)
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	raw_spin_lock_irq(&ctx->lock);
+	perf_group_detach(event);
 	list_del_event(event, ctx);
-	perf_destroy_group(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 	mutex_unlock(&ctx->mutex);
 
@@ -2175,7 +2215,27 @@ unlock:
 	return ret;
 }
 
-static int perf_event_set_output(struct perf_event *event, int output_fd);
+static const struct file_operations perf_fops;
+
+static struct perf_event *perf_fget_light(int fd, int *fput_needed)
+{
+	struct file *file;
+
+	file = fget_light(fd, fput_needed);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (file->f_op != &perf_fops) {
+		fput_light(file, *fput_needed);
+		*fput_needed = 0;
+		return ERR_PTR(-EBADF);
+	}
+
+	return file->private_data;
+}
+
+static int perf_event_set_output(struct perf_event *event,
+				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -2202,7 +2262,23 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return perf_event_period(event, (u64 __user *)arg);
 
 	case PERF_EVENT_IOC_SET_OUTPUT:
-		return perf_event_set_output(event, arg);
+	{
+		struct perf_event *output_event = NULL;
+		int fput_needed = 0;
+		int ret;
+
+		if (arg != -1) {
+			output_event = perf_fget_light(arg, &fput_needed);
+			if (IS_ERR(output_event))
+				return PTR_ERR(output_event);
+		}
+
+		ret = perf_event_set_output(event, output_event);
+		if (output_event)
+			fput_light(output_event->filp, fput_needed);
+
+		return ret;
+	}
 
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
@@ -2335,8 +2411,6 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	unsigned long size;
 	int i;
 
-	WARN_ON(atomic_read(&event->mmap_count));
-
 	size = sizeof(struct perf_mmap_data);
 	size += nr_pages * sizeof(void *);
 
@@ -2452,8 +2526,6 @@ perf_mmap_data_alloc(struct perf_event *event, int nr_pages)
 	unsigned long size;
 	void *all_buf;
 
-	WARN_ON(atomic_read(&event->mmap_count));
-
 	size = sizeof(struct perf_mmap_data);
 	size += sizeof(void *);
 
@@ -2536,7 +2608,7 @@ perf_mmap_data_init(struct perf_event *event, struct perf_mmap_data *data)
 	if (!data->watermark)
 		data->watermark = max_size / 2;
 
-
+	atomic_set(&data->refcount, 1);
 	rcu_assign_pointer(event->data, data);
 }
 
@@ -2548,13 +2620,26 @@ static void perf_mmap_data_free_rcu(struct rcu_head *rcu_head)
 	perf_mmap_data_free(data);
 }
 
-static void perf_mmap_data_release(struct perf_event *event)
+static struct perf_mmap_data *perf_mmap_data_get(struct perf_event *event)
 {
-	struct perf_mmap_data *data = event->data;
+	struct perf_mmap_data *data;
 
-	WARN_ON(atomic_read(&event->mmap_count));
+	rcu_read_lock();
+	data = rcu_dereference(event->data);
+	if (data) {
+		if (!atomic_inc_not_zero(&data->refcount))
+			data = NULL;
+	}
+	rcu_read_unlock();
+
+	return data;
+}
+
+static void perf_mmap_data_put(struct perf_mmap_data *data)
+{
+	if (!atomic_dec_and_test(&data->refcount))
+		return;
 
-	rcu_assign_pointer(event->data, NULL);
 	call_rcu(&data->rcu_head, perf_mmap_data_free_rcu);
 }
 
@@ -2569,15 +2654,18 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	WARN_ON_ONCE(event->ctx->parent_ctx);
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
 		unsigned long size = perf_data_size(event->data);
-		struct user_struct *user = current_user();
+		struct user_struct *user = event->mmap_user;
+		struct perf_mmap_data *data = event->data;
 
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->locked_vm -= event->data->nr_locked;
-		perf_mmap_data_release(event);
+		vma->vm_mm->locked_vm -= event->mmap_locked;
+		rcu_assign_pointer(event->data, NULL);
 		mutex_unlock(&event->mmap_mutex);
+
+		perf_mmap_data_put(data);
+		free_uid(user);
 	}
 }
 
@@ -2629,13 +2717,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
-	if (event->output) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	if (atomic_inc_not_zero(&event->mmap_count)) {
-		if (nr_pages != event->data->nr_pages)
+	if (event->data) {
+		if (event->data->nr_pages == nr_pages)
+			atomic_inc(&event->data->refcount);
+		else
 			ret = -EINVAL;
 		goto unlock;
 	}
@@ -2667,21 +2752,23 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	WARN_ON(event->data);
 
 	data = perf_mmap_data_alloc(event, nr_pages);
-	ret = -ENOMEM;
-	if (!data)
+	if (!data) {
+		ret = -ENOMEM;
 		goto unlock;
+	}
 
-	ret = 0;
 	perf_mmap_data_init(event, data);
-
-	atomic_set(&event->mmap_count, 1);
-	atomic_long_add(user_extra, &user->locked_vm);
-	vma->vm_mm->locked_vm += extra;
-	event->data->nr_locked = extra;
 	if (vma->vm_flags & VM_WRITE)
 		event->data->writable = 1;
 
+	atomic_long_add(user_extra, &user->locked_vm);
+	event->mmap_locked = extra;
+	event->mmap_user = get_current_user();
+	vma->vm_mm->locked_vm += event->mmap_locked;
+
 unlock:
+	if (!ret)
+		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
 	vma->vm_flags |= VM_RESERVED;
@@ -2977,6 +3064,7 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 
 		len -= size;
 		handle->addr += size;
+		buf += size;
 		handle->size -= size;
 		if (!handle->size) {
 			struct perf_mmap_data *data = handle->data;
@@ -2993,7 +3081,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size,
 		      int nmi, int sample)
 {
-	struct perf_event *output_event;
 	struct perf_mmap_data *data;
 	unsigned long tail, offset, head;
 	int have_lost;
@@ -3010,10 +3097,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (event->parent)
 		event = event->parent;
 
-	output_event = rcu_dereference(event->output);
-	if (output_event)
-		event = output_event;
-
 	data = rcu_dereference(event->data);
 	if (!data)
 		goto out;
@@ -3972,13 +4055,6 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 	}
 }
 
-static void perf_swevent_unthrottle(struct perf_event *event)
-{
-	/*
-	 * Nothing to do, we already reset hwc->interrupts.
-	 */
-}
-
 static void perf_swevent_add(struct perf_event *event, u64 nr,
 			       int nmi, struct perf_sample_data *data,
 			       struct pt_regs *regs)
@@ -4193,11 +4269,22 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
+static void perf_swevent_void(struct perf_event *event)
+{
+}
+
+static int perf_swevent_int(struct perf_event *event)
+{
+	return 0;
+}
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
 
 /*
@@ -4478,8 +4565,10 @@ static int swevent_hlist_get(struct perf_event *event)
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void,
 };
 
 static int perf_tp_filter_match(struct perf_event *event,
@@ -4912,39 +5001,17 @@ err_size:
 	goto out;
 }
 
-static int perf_event_set_output(struct perf_event *event, int output_fd)
+static int
+perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct perf_event *output_event = NULL;
-	struct file *output_file = NULL;
-	struct perf_event *old_output;
-	int fput_needed = 0;
+	struct perf_mmap_data *data = NULL, *old_data = NULL;
 	int ret = -EINVAL;
 
-	/*
-	 * Don't allow output of inherited per-task events. This would
-	 * create performance issues due to cross cpu access.
-	 */
-	if (event->cpu == -1 && event->attr.inherit)
-		return -EINVAL;
-
-	if (!output_fd)
+	if (!output_event)
 		goto set;
 
-	output_file = fget_light(output_fd, &fput_needed);
-	if (!output_file)
-		return -EBADF;
-
-	if (output_file->f_op != &perf_fops)
-		goto out;
-
-	output_event = output_file->private_data;
-
-	/* Don't chain output fds */
-	if (output_event->output)
-		goto out;
-
-	/* Don't set an output fd when we already have an output channel */
-	if (event->data)
+	/* don't allow circular references */
+	if (event == output_event)
 		goto out;
 
 	/*
@@ -4959,26 +5026,28 @@ static int perf_event_set_output(struct perf_event *event, int output_fd)
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
 
-	atomic_long_inc(&output_file->f_count);
-
 set:
 	mutex_lock(&event->mmap_mutex);
-	old_output = event->output;
-	rcu_assign_pointer(event->output, output_event);
-	mutex_unlock(&event->mmap_mutex);
+	/* Can't redirect output if we've got an active mmap() */
+	if (atomic_read(&event->mmap_count))
+		goto unlock;
 
-	if (old_output) {
-		/*
-		 * we need to make sure no existing perf_output_*()
-		 * is still referencing this event.
-		 */
-		synchronize_rcu();
-		fput(old_output->filp);
+	if (output_event) {
+		/* get the buffer we want to redirect to */
+		data = perf_mmap_data_get(output_event);
+		if (!data)
+			goto unlock;
 	}
 
+	old_data = event->data;
+	rcu_assign_pointer(event->data, data);
 	ret = 0;
+unlock:
+	mutex_unlock(&event->mmap_mutex);
+
+	if (old_data)
+		perf_mmap_data_put(old_data);
 out:
-	fput_light(output_file, fput_needed);
 	return ret;
 }
 
@@ -4994,7 +5063,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
-	struct perf_event *event, *group_leader;
+	struct perf_event *event, *group_leader = NULL, *output_event = NULL;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
@@ -5034,19 +5103,25 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_fd;
 	}
 
+	if (group_fd != -1) {
+		group_leader = perf_fget_light(group_fd, &fput_needed);
+		if (IS_ERR(group_leader)) {
+			err = PTR_ERR(group_leader);
+			goto err_put_context;
+		}
+		group_file = group_leader->filp;
+		if (flags & PERF_FLAG_FD_OUTPUT)
+			output_event = group_leader;
+		if (flags & PERF_FLAG_FD_NO_GROUP)
+			group_leader = NULL;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
-	group_leader = NULL;
-	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
+	if (group_leader) {
 		err = -EINVAL;
-		group_file = fget_light(group_fd, &fput_needed);
-		if (!group_file)
-			goto err_put_context;
-		if (group_file->f_op != &perf_fops)
-			goto err_put_context;
 
-		group_leader = group_file->private_data;
 		/*
 		 * Do not allow a recursive hierarchy (this new sibling
 		 * becoming part of another group-sibling):
@@ -5068,9 +5143,16 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
 				     NULL, NULL, GFP_KERNEL);
-	err = PTR_ERR(event);
-	if (IS_ERR(event))
+	if (IS_ERR(event)) {
+		err = PTR_ERR(event);
 		goto err_put_context;
+	}
+
+	if (output_event) {
+		err = perf_event_set_output(event, output_event);
+		if (err)
+			goto err_free_put_context;
+	}
 
 	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
 	if (IS_ERR(event_file)) {
@@ -5078,12 +5160,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_free_put_context;
 	}
 
-	if (flags & PERF_FLAG_FD_OUTPUT) {
-		err = perf_event_set_output(event, group_fd);
-		if (err)
-			goto err_fput_free_put_context;
-	}
-
 	event->filp = event_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
@@ -5097,12 +5173,16 @@ SYSCALL_DEFINE5(perf_event_open,
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
 
+	/*
+	 * Drop the reference on the group_event after placing the
+	 * new event on the sibling_list. This ensures destruction
+	 * of the group leader will find the pointer to itself in
+	 * perf_group_detach().
+	 */
 	fput_light(group_file, fput_needed);
 	fd_install(event_fd, event_file);
 	return event_fd;
 
-err_fput_free_put_context:
-	fput(event_file);
 err_free_put_context:
 	free_event(event);
 err_put_context:
@@ -5420,6 +5500,7 @@ static void perf_free_event(struct perf_event *event,
 
 	fput(parent->filp);
 
+	perf_group_detach(event);
 	list_del_event(event, ctx);
 	free_event(event);
 }
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 36ea2b6..638711c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -842,6 +842,7 @@ static void blk_add_trace_split(void *ignore,
 
 /**
  * blk_add_trace_remap - Add a trace for a remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
@@ -873,6 +874,7 @@ static void blk_add_trace_remap(void *ignore,
 
 /**
  * blk_add_trace_rq_remap - Add a trace for a request-remap operation
+ * @ignore:	trace callback data parameter (not used)
  * @q:		queue the io is for
  * @rq:		the source request
  * @dev:	target device
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index cb6f365..e6f6588 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -116,7 +116,7 @@ int perf_trace_enable(struct perf_event *p_event)
 	if (WARN_ON_ONCE(!list))
 		return -EINVAL;
 
-	list = per_cpu_ptr(list, smp_processor_id());
+	list = this_cpu_ptr(list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
 	return 0;
@@ -132,8 +132,9 @@ void perf_trace_destroy(struct perf_event *p_event)
 	struct ftrace_event_call *tp_event = p_event->tp_event;
 	int i;
 
+	mutex_lock(&event_mutex);
 	if (--tp_event->perf_refcount > 0)
-		return;
+		goto out;
 
 	if (tp_event->class->reg)
 		tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
@@ -142,6 +143,12 @@ void perf_trace_destroy(struct perf_event *p_event)
 					    tp_event->class->perf_probe,
 					    tp_event);
 
+	/*
+	 * Ensure our callback won't be called anymore. See
+	 * tracepoint_probe_unregister() and __DO_TRACE().
+	 */
+	synchronize_sched();
+
 	free_percpu(tp_event->perf_events);
 	tp_event->perf_events = NULL;
 
@@ -151,6 +158,8 @@ void perf_trace_destroy(struct perf_event *p_event)
 			perf_trace_buf[i] = NULL;
 		}
 	}
+out:
+	mutex_unlock(&event_mutex);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
@@ -169,7 +178,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	if (*rctxp < 0)
 		return NULL;
 
-	raw_data = per_cpu_ptr(perf_trace_buf[*rctxp], smp_processor_id());
+	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index faf7cef..f52b5f5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1359,7 +1359,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
 }
 
@@ -1392,7 +1392,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	for (i = 0; i < tp->nr_args; i++)
 		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
-	head = per_cpu_ptr(call->perf_events, smp_processor_id());
+	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d2c859c..34e3580 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -519,7 +519,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
 
-	head = per_cpu_ptr(sys_data->enter_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
@@ -595,7 +595,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	head = per_cpu_ptr(sys_data->exit_event->perf_events, smp_processor_id());
+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head);
 }
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..9989072 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -43,8 +43,10 @@ static int __cmd_buildid_list(void)
 	if (session == NULL)
 		return -1;
 
-	if (with_hits)
+	if (with_hits) {
+		symbol_conf.full_paths = true;
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
+	}
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9bc8905..dc3435e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -503,7 +503,6 @@ static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
-	pid_t pid = 0;
 	int flags;
 	int err;
 	unsigned long waking = 0;
@@ -572,7 +571,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	if (forks) {
 		child_pid = fork();
-		if (pid < 0) {
+		if (child_pid < 0) {
 			perror("failed to fork");
 			exit(-1);
 		}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f67bce2..55f3b5d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1645,6 +1645,7 @@ static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
 	.comm			= event__process_comm,
 	.lost			= event__process_lost,
+	.fork			= event__process_task,
 	.ordered_samples	= true,
 };
 
diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
index 964d934..d9f7893 100644
--- a/tools/perf/scripts/python/check-perf-trace.py
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -51,8 +51,7 @@ def kmem__kmalloc(event_name, context, common_cpu,
 
 		flag_str("kmem__kmalloc", "gfp_flags", gfp_flags)),
 
-def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
-		common_pid, common_comm):
+def trace_unhandled(event_name, context, event_fields_dict):
     try:
         unhandled[event_name] += 1
     except TypeError:
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 50771b5..1f08f00 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -370,9 +370,9 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm)
 
 int event__process_comm(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->comm.pid);
+	struct thread *thread = perf_session__findnew(session, self->comm.tid);
 
-	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
+	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
 
 	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
@@ -532,16 +532,11 @@ out_problem:
 
 int event__process_task(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->fork.pid);
-	struct thread *parent = perf_session__findnew(session, self->fork.ppid);
+	struct thread *thread = perf_session__findnew(session, self->fork.tid);
+	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
-	/*
-	 * A thread clone will have the same PID for both parent and child.
-	 */
-	if (thread == parent)
-		return 0;
 
 	if (self->header.type == PERF_RECORD_EXIT)
 		return 0;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cbf7eae..07f89b6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -965,7 +965,7 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':')
+		if (*tmp2 != ':' || tmp == tmp2)
 			line_ip = -1;
 	}
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 81f39ca..33a6325 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -208,7 +208,7 @@ static void python_process_event(int cpu, void *data,
 				 int size __unused,
 				 unsigned long long nsecs, char *comm)
 {
-	PyObject *handler, *retval, *context, *t, *obj;
+	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long long val;
@@ -232,6 +232,14 @@ static void python_process_event(int cpu, void *data,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
+	handler = PyDict_GetItemString(main_dict, handler_name);
+	if (handler && !PyCallable_Check(handler))
+		handler = NULL;
+	if (!handler) {
+		dict = PyDict_New();
+		if (!dict)
+			Py_FatalError("couldn't create Python dict");
+	}
 	s = nsecs / NSECS_PER_SEC;
 	ns = nsecs - s * NSECS_PER_SEC;
 
@@ -242,12 +250,20 @@ static void python_process_event(int cpu, void *data,
 	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
 	PyTuple_SetItem(t, n++,
 			PyCObject_FromVoidPtr(scripting_context, NULL));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(s));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
-	PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
-	PyTuple_SetItem(t, n++, PyString_FromString(comm));
 
+	if (handler) {
+		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
+		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
+		PyTuple_SetItem(t, n++, PyString_FromString(comm));
+	} else {
+		PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
+		PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
+		PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
+		PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
+		PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
+	}
 	for (field = event->format.fields; field; field = field->next) {
 		if (field->flags & FIELD_IS_STRING) {
 			int offset;
@@ -272,27 +288,31 @@ static void python_process_event(int cpu, void *data,
 					obj = PyLong_FromUnsignedLongLong(val);
 			}
 		}
-		PyTuple_SetItem(t, n++, obj);
+		if (handler)
+			PyTuple_SetItem(t, n++, obj);
+		else
+			PyDict_SetItemString(dict, field->name, obj);
+
 	}
+	if (!handler)
+		PyTuple_SetItem(t, n++, dict);
 
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
 
-	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && PyCallable_Check(handler)) {
+	if (handler) {
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
 	} else {
 		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
-			if (_PyTuple_Resize(&t, N_COMMON_FIELDS) == -1)
-				Py_FatalError("error resizing Python tuple");
 
 			retval = PyObject_CallObject(handler, t);
 			if (retval == NULL)
 				handler_call_die("trace_unhandled");
 		}
+		Py_DECREF(dict);
 	}
 
 	Py_DECREF(t);
@@ -548,12 +568,10 @@ static int python_generate_script(const char *outfile)
 	}
 
 	fprintf(ofp, "def trace_unhandled(event_name, context, "
-		"common_cpu, common_secs, common_nsecs,\n\t\t"
-		"common_pid, common_comm):\n");
+		"event_fields_dict):\n");
 
-	fprintf(ofp, "\t\tprint_header(event_name, common_cpu, "
-		"common_secs, common_nsecs,\n\t\tcommon_pid, "
-		"common_comm)\n\n");
+	fprintf(ofp, "\t\tprint ' '.join(['%%s=%%s'%%(k,str(v))"
+		"for k,v in sorted(event_fields_dict.items())])\n\n");
 
 	fprintf(ofp, "def print_header("
 		"event_name, cpu, secs, nsecs, pid, comm):\n"
