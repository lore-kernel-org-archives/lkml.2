Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab2CBTaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:30:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52156 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2CBTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:30:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of semenzato@chromium.org designates 10.68.228.103 as permitted sender) smtp.mail=semenzato@chromium.org; dkim=pass header.i=semenzato@chromium.org
MIME-Version: 1.0
From: Luigi Semenzato <semenzato@chromium.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Cc: sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com,
        Luigi Semenzato <semenzato@chromium.org>
Subject: [PATCH] perf: add PERF_RECORD_EXEC type, to distinguish from PERF_RECORD_COMM (DO NOT APPLY)
Date: Fri,  2 Mar 2012 11:30:07 -0800
Message-Id: <1330716607-28227-1-git-send-email-semenzato@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---- NOT FINISHED - NOT TESTED ---- rfc only

I agree with others that adding a new record type is the cleanest solution.
This is more or less what it takes to add a new record type.  It may be
more than we like but that's a separate problem.  I am open to other
solutions.  I may be able to do a bit of refactoring to reduce the
copy-paste, but of course the CL will grow as the refactoring would
not be limited to COMM and EXEC.

---- actual commit message below ----

Currently the kernel produces a PERF_RECORD_COMM type record both when
a process execs and when it renames its "comm" name.  The "perf report"
command interprets each COMM record as an exec, and flushes all
mappings to executables when it encounters one.  This can result in the
inability to correlate IP samples to function symbols.

This CL adds a PERF_RECORD_EXEC type, which doesn't contain the process
name (the comm field).  Thus, an exec now must send two records, one EXEC
and one COMM, whereas a rename sends only a COMM.

The change is mostly straightforward, but there are some complications
in the synthesized events sent when "perf record" starts to account for
existing processes.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
---
 fs/exec.c                  |    1 +
 include/linux/perf_event.h |   19 +++++-
 kernel/events/core.c       |  153 +++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-test.c  |   24 ++-----
 tools/perf/builtin-top.c   |    5 +-
 tools/perf/util/event.c    |  148 +++++++++++++++++++++++++++++-------------
 tools/perf/util/event.h    |   11 +++
 tools/perf/util/evsel.c    |    5 +-
 tools/perf/util/python.c   |   42 +++++++++++-
 tools/perf/util/session.c  |   11 +++
 tools/perf/util/thread.c   |    1 -
 tools/perf/util/tool.h     |    1 +
 12 files changed, 338 insertions(+), 83 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e33501a..077d199 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1144,6 +1144,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
+        perf_event_exec(current);
 	set_task_comm(current, bprm->tcomm);
 
 	/* Set the new mm task size. We have to do that late because it may
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 64426b7..8e4a472 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -200,8 +200,8 @@ struct perf_event_attr {
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
-				mmap           :  1, /* include mmap data     */
-				comm	       :  1, /* include comm data     */
+				mmap_attr      :  1, /* include mmap data     */
+				comm_attr      :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
@@ -223,8 +223,10 @@ struct perf_event_attr {
 
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
+                                /* COMM used to mean exec in older versions   */
+                                exec_attr      :  1, /* include exec data     */
 
-				__reserved_1   : 43;
+				__reserved_1   : 42;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -462,6 +464,15 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_SAMPLE			= 9,
 
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u32				pid, tid;
+	 * };
+	 */
+	PERF_RECORD_EXEC			= 10,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -1101,6 +1112,7 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
+extern void perf_event_exec(struct task_struct *tsk);
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
@@ -1191,6 +1203,7 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
+static inline void perf_event_exec(struct task_struct *tsk)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 529bb44..9e5e36e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -133,6 +133,7 @@ static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
+static atomic_t nr_exec_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
 
 static LIST_HEAD(pmus);
@@ -2779,10 +2780,12 @@ static void free_event(struct perf_event *event)
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
 			static_key_slow_dec_deferred(&perf_sched_events);
-		if (event->attr.mmap || event->attr.mmap_data)
+		if (event->attr.mmap_attr || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
-		if (event->attr.comm)
+		if (event->attr.comm_attr)
 			atomic_dec(&nr_comm_events);
+		if (event->attr.exec_attr)
+			atomic_dec(&nr_exec_events);
 		if (event->attr.task)
 			atomic_dec(&nr_task_events);
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
@@ -4073,8 +4076,8 @@ static int perf_event_task_match(struct perf_event *event)
 	if (!event_filter_match(event))
 		return 0;
 
-	if (event->attr.comm || event->attr.mmap ||
-	    event->attr.mmap_data || event->attr.task)
+	if (event->attr.exec_attr || event->attr.comm_attr ||
+            event->attr.mmap_attr || event->attr.mmap_data || event->attr.task)
 		return 1;
 
 	return 0;
@@ -4126,7 +4129,7 @@ static void perf_event_task(struct task_struct *task,
 {
 	struct perf_task_event task_event;
 
-	if (!atomic_read(&nr_comm_events) &&
+	if (!atomic_read(&nr_exec_events) &&
 	    !atomic_read(&nr_mmap_events) &&
 	    !atomic_read(&nr_task_events))
 		return;
@@ -4210,7 +4213,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (!event_filter_match(event))
 		return 0;
 
-	if (event->attr.comm)
+	if (event->attr.comm_attr)
 		return 1;
 
 	return 0;
@@ -4300,6 +4303,136 @@ void perf_event_comm(struct task_struct *task)
 }
 
 /*
+ * exec tracking
+ */
+
+struct perf_exec_event {
+	struct task_struct	*task;
+
+	struct {
+		struct perf_event_header	header;
+
+		u32				pid;
+		u32				tid;
+	} event_id;
+};
+
+static void perf_event_exec_output(struct perf_event *event,
+				     struct perf_exec_event *exec_event)
+{
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	int size = exec_event->event_id.header.size;
+	int ret;
+
+	perf_event_header__init_id(&exec_event->event_id.header,
+				   &sample, event);
+	ret = perf_output_begin(&handle, event,
+				exec_event->event_id.header.size);
+
+	if (ret)
+		goto out;
+
+	exec_event->event_id.pid = perf_event_pid(event, exec_event->task);
+	exec_event->event_id.tid = perf_event_tid(event, exec_event->task);
+
+	perf_output_put(&handle, exec_event->event_id);
+
+	perf_event__output_id_sample(event, &handle, &sample);
+
+	perf_output_end(&handle);
+out:
+	exec_event->event_id.header.size = size;
+}
+
+static int perf_event_exec_match(struct perf_event *event)
+{
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
+		return 0;
+
+	if (!event_filter_match(event))
+		return 0;
+
+	if (event->attr.exec_attr)
+		return 1;
+
+	return 0;
+}
+
+static void perf_event_exec_ctx(struct perf_event_context *ctx,
+				  struct perf_exec_event *exec_event)
+{
+	struct perf_event *event;
+
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		if (perf_event_exec_match(event))
+			perf_event_exec_output(event, exec_event);
+	}
+}
+
+static void perf_event_exec_event(struct perf_exec_event *exec_event)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int ctxn;
+
+	exec_event->event_id.header.size = sizeof(exec_event->event_id);
+	rcu_read_lock();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
+		perf_event_exec_ctx(&cpuctx->ctx, exec_event);
+
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			goto next;
+
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx)
+			perf_event_exec_ctx(ctx, exec_event);
+next:
+		put_cpu_ptr(pmu->pmu_cpu_context);
+	}
+	rcu_read_unlock();
+}
+
+void perf_event_exec(struct task_struct *task)
+{
+	struct perf_exec_event exec_event;
+	struct perf_event_context *ctx;
+	int ctxn;
+
+	for_each_task_context_nr(ctxn) {
+		ctx = task->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
+
+		perf_event_enable_on_exec(ctx);
+	}
+
+	if (!atomic_read(&nr_exec_events))
+		return;
+
+	exec_event = (struct perf_exec_event){
+		.task	= task,
+		/* .exec      */
+		.event_id  = {
+			.header = {
+				.type = PERF_RECORD_EXEC,
+				.misc = 0,
+				.size = sizeof(exec_event),
+			},
+			/* .pid */
+			/* .tid */
+		},
+	};
+
+	perf_event_exec_event(&exec_event);
+}
+
+/*
  * mmap tracking
  */
 
@@ -4359,7 +4492,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
-	    (executable && event->attr.mmap))
+	    (executable && event->attr.mmap_attr))
 		return 1;
 
 	return 0;
@@ -5853,10 +5986,12 @@ done:
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
 			static_key_slow_inc(&perf_sched_events.key);
-		if (event->attr.mmap || event->attr.mmap_data)
+		if (event->attr.mmap_attr || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
-		if (event->attr.comm)
+		if (event->attr.comm_attr)
 			atomic_inc(&nr_comm_events);
+		if (event->attr.exec_attr)
+			atomic_inc(&nr_exec_events);
 		if (event->attr.task)
 			atomic_inc(&nr_task_events);
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3e087ce..d2ac012 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1109,19 +1109,7 @@ static int test__PERF_RECORD(void)
 
 	/*
 	 * mmap the first fd on a given CPU and ask for events for the other
-	 * fds in the same CPU to be injected in the same mmap ring buffer
-	 * (using ioctl(PERF_EVENT_IOC_SET_OUTPUT)).
-	 */
-	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
-	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
-	}
-
-	/*
-	 * We'll need these two to parse the PERF_SAMPLE_* fields in each
-	 * event.
-	 */
+	 * fds in the same CPU to be inj	 */
 	sample_type = perf_evlist__sample_type(evlist);
 	sample_size = __perf_evsel__sample_size(sample_type);
 
@@ -1192,6 +1180,7 @@ static int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
+				     type == PERF_RECORD_EXEC ||
 				     type == PERF_RECORD_MMAP ||
 				     type == PERF_RECORD_FORK ||
 				     type == PERF_RECORD_EXIT) &&
@@ -1201,6 +1190,7 @@ static int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
+                                     type == PERF_RECORD_EXEC ||
 				     type == PERF_RECORD_MMAP) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
@@ -1256,13 +1246,13 @@ static int test__PERF_RECORD(void)
 	}
 
 found_exit:
-	if (nr_events[PERF_RECORD_COMM] > 1) {
-		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
+	if (nr_events[PERF_RECORD_EXEC] != 1) {
+		pr_debug("Expected 1 PERF_RECORD_EXEC events, received %d\n", nr_events[PERF_RECORD_EXEC]);
 		++errs;
 	}
 
-	if (nr_events[PERF_RECORD_COMM] == 0) {
-		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
+	if (nr_events[PERF_RECORD_COMM] != 1) {
+		pr_debug("Expected 1 PERF_RECORD_COMM events, received %d\n", nr_events[PERF_RECORD_COMM]);
 		++errs;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..98a3cdf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -869,8 +869,9 @@ static void perf_top__start_counters(struct perf_top *top)
 		if (symbol_conf.use_callchain)
 			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
 
-		attr->mmap = 1;
-		attr->comm = 1;
+		attr->exec_bit = 1;
+		attr->comm_bit = 1;
+		attr->mmap_bit = 1;
 		attr->inherit = top->inherit;
 fallback_missing_features:
 		if (top->exclude_guest_missing)
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2044324..2243005 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -12,6 +12,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_MMAP]			= "MMAP",
 	[PERF_RECORD_LOST]			= "LOST",
 	[PERF_RECORD_COMM]			= "COMM",
+	[PERF_RECORD_EXEC]			= "EXEC",
 	[PERF_RECORD_EXIT]			= "EXIT",
 	[PERF_RECORD_THROTTLE]			= "THROTTLE",
 	[PERF_RECORD_UNTHROTTLE]		= "UNTHROTTLE",
@@ -88,9 +89,11 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 	return tgid;
 }
 
-static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
-					 union perf_event *event, pid_t pid,
-					 int full,
+static pid_t perf_event__synthesize_exec(struct perf_tool *tool,
+					 union perf_event *exec_event,
+					 union perf_event *comm_event,
+                                         pid_t pid,
+                                         int full,
 					 perf_event__handler_t process,
 					 struct machine *machine)
 {
@@ -100,26 +103,34 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	struct dirent dirent, *next;
 	pid_t tgid;
 
-	memset(&event->comm, 0, sizeof(event->comm));
+	memset(&exec_event->exec, 0, sizeof(exec_event->exec));
+	memset(&comm_event->comm, 0, sizeof(comm_event->comm));
+	exec_event->exec.header.type = PERF_RECORD_EXEC;
+	exec_event->exec.header.size =
+			sizeof(exec_event->exec) + machine->id_hdr_size;
+        comm_event->comm.header.type = PERF_RECORD_COMM;
 
-	tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
-					 sizeof(event->comm.comm));
+	tgid = perf_event__get_comm_tgid(pid, comm_event->comm.comm,
+					 sizeof(comm_event->comm.comm));
 	if (tgid < 0)
 		goto out;
 
-	event->comm.pid = tgid;
-	event->comm.header.type = PERF_RECORD_COMM;
+	comm_event->comm.pid = tgid;
+        exec_event->exec.pid = tgid;
 
-	size = strlen(event->comm.comm) + 1;
+	size = strlen(comm_event->comm.comm) + 1;
 	size = ALIGN(size, sizeof(u64));
-	memset(event->comm.comm + size, 0, machine->id_hdr_size);
-	event->comm.header.size = (sizeof(event->comm) -
-				(sizeof(event->comm.comm) - size) +
+	memset(comm_event->comm.comm + size, 0, machine->id_hdr_size);
+	comm_event->comm.header.size = (sizeof(comm_event->comm) -
+				(sizeof(comm_event->comm.comm) - size) +
 				machine->id_hdr_size);
-	if (!full) {
-		event->comm.tid = pid;
 
-		process(tool, event, &synth_sample, machine);
+	exec_event->comm.tid = pid;
+	process(tool, exec_event, &synth_sample, machine);
+
+	if (!full) {
+		comm_event->comm.tid = pid;
+		process(tool, comm_event, &synth_sample, machine);
 		goto out;
 	}
 
@@ -137,20 +148,20 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		if (*end)
 			continue;
 
-		/* already have tgid; jut want to update the comm */
-		(void) perf_event__get_comm_tgid(pid, event->comm.comm,
-					 sizeof(event->comm.comm));
+		/* already have tgid; just want to update the comm */
+		(void) perf_event__get_comm_tgid(pid, comm_event->comm.comm,
+					 sizeof(comm_event->comm.comm));
 
-		size = strlen(event->comm.comm) + 1;
+		size = strlen(comm_event->comm.comm) + 1;
 		size = ALIGN(size, sizeof(u64));
-		memset(event->comm.comm + size, 0, machine->id_hdr_size);
-		event->comm.header.size = (sizeof(event->comm) -
-					  (sizeof(event->comm.comm) - size) +
-					  machine->id_hdr_size);
-
-		event->comm.tid = pid;
-
-		process(tool, event, &synth_sample, machine);
+		memset(comm_event->comm.comm + size, 0, machine->id_hdr_size);
+		comm_event->comm.header.size =
+                    (sizeof(comm_event->comm) -
+                     (sizeof(comm_event->comm.comm) - size) +
+                     machine->id_hdr_size);
+
+		comm_event->comm.tid = pid;
+		process(tool, comm_event, &synth_sample, machine);
 	}
 
 	closedir(tasks);
@@ -290,14 +301,16 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 	return 0;
 }
 
-static int __event__synthesize_thread(union perf_event *comm_event,
+static int __event__synthesize_thread(union perf_event *exec_event,
+                                      union perf_event *comm_event,
 				      union perf_event *mmap_event,
 				      pid_t pid, int full,
-					  perf_event__handler_t process,
+				      perf_event__handler_t process,
 				      struct perf_tool *tool,
 				      struct machine *machine)
 {
-	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
+	pid_t tgid = perf_event__synthesize_exec(tool, exec_event,
+                                                 comm_event, pid, full,
 						 process, machine);
 	if (tgid == -1)
 		return -1;
@@ -310,20 +323,27 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      perf_event__handler_t process,
 				      struct machine *machine)
 {
-	union perf_event *comm_event, *mmap_event;
+	union perf_event *exec_event = NULL;
+	union perf_event *comm_event = NULL;
+	union perf_event *mmap_event = NULL;
 	int err = -1, thread, j;
 
+	exec_event = malloc(sizeof(exec_event->exec) + machine->id_hdr_size);
+	if (comm_event == NULL)
+		goto out;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
 	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
-		goto out_free_comm;
+		goto out;
 
 	err = 0;
 	for (thread = 0; thread < threads->nr; ++thread) {
-		if (__event__synthesize_thread(comm_event, mmap_event,
+		if (__event__synthesize_thread(exec_event,
+                                               comm_event, mmap_event,
 					       threads->map[thread], 0,
 					       process, tool, machine)) {
 			err = -1;
@@ -347,7 +367,8 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 
 			/* if not, generate events for it */
 			if (need_leader &&
-			    __event__synthesize_thread(comm_event,
+			    __event__synthesize_thread(exec_event,
+                                                      comm_event,
 						      mmap_event,
 						      comm_event->comm.pid, 0,
 						      process, tool, machine)) {
@@ -356,10 +377,10 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 			}
 		}
 	}
-	free(mmap_event);
-out_free_comm:
-	free(comm_event);
 out:
+        free(exec_event);
+        free(comm_event);
+        free(mmap_event);
 	return err;
 }
 
@@ -369,20 +390,26 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 {
 	DIR *proc;
 	struct dirent dirent, *next;
-	union perf_event *comm_event, *mmap_event;
+	union perf_event *exec_event = NULL;
+	union perf_event *comm_event = NULL;
+	union perf_event *mmap_event = NULL;
 	int err = -1;
 
+	exec_event = malloc(sizeof(exec_event->exec) + machine->id_hdr_size);
+	if (exec_event == NULL)
+		goto out;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
 	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
-		goto out_free_comm;
+		goto out;
 
 	proc = opendir("/proc");
 	if (proc == NULL)
-		goto out_free_mmap;
+                goto out;
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
@@ -391,17 +418,16 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine);
+		__event__synthesize_thread(exec_event, comm_event, mmap_event,
+                                           pid, 1, process, tool, machine);
 	}
 
 	closedir(proc);
 	err = 0;
-out_free_mmap:
-	free(mmap_event);
-out_free_comm:
-	free(comm_event);
 out:
+        free(exec_event);
+        free(comm_event);
+        free(mmap_event);
 	return err;
 }
 
@@ -514,6 +540,30 @@ int perf_event__process_comm(struct perf_tool *tool __used,
 	return 0;
 }
 
+size_t perf_event__fprintf_exec(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, ": %d\n", event->exec.tid);
+}
+
+int perf_event__process_exec(struct perf_tool *tool __used,
+			     union perf_event *event,
+			     struct perf_sample *sample __used,
+			     struct machine *machine)
+{
+	struct thread *thread = machine__findnew_thread(machine, event->exec.tid);
+
+	if (dump_trace)
+		perf_event__fprintf_exec(event, stdout);
+
+	if (thread == NULL) {
+		dump_printf("problem processing PERF_RECORD_EXEC, skipping event.\n");
+		return -1;
+	}
+        map_groups__flush(&thread->mg);
+
+	return 0;
+}
+
 int perf_event__process_lost(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
@@ -717,6 +767,9 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_COMM:
 		ret += perf_event__fprintf_comm(event, fp);
 		break;
+	case PERF_RECORD_EXEC:
+		perf_event__fprintf_exec(event, fp);
+		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
 		ret += perf_event__fprintf_task(event, fp);
@@ -738,6 +791,9 @@ int perf_event__process(struct perf_tool *tool, union perf_event *event,
 	case PERF_RECORD_COMM:
 		perf_event__process_comm(tool, event, sample, machine);
 		break;
+        case PERF_RECORD_EXEC:
+		perf_event__process_exec(tool, event, sample, machine);
+		break;
 	case PERF_RECORD_MMAP:
 		perf_event__process_mmap(tool, event, sample, machine);
 		break;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cbdeaad..52a5845 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -32,6 +32,11 @@ struct comm_event {
 	char comm[16];
 };
 
+struct exec_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+};
+
 struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
@@ -130,6 +135,7 @@ union perf_event {
 	struct ip_event			ip;
 	struct mmap_event		mmap;
 	struct comm_event		comm;
+	struct exec_event		exec;
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
@@ -170,6 +176,10 @@ int perf_event__process_comm(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
+int perf_event__process_exec(struct perf_tool *tool,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct machine *machine);
 int perf_event__process_lost(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -204,6 +214,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  bool swapped);
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_exec(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 302d49a..84f59c7 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -127,8 +127,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 		attr->wakeup_events = 1;
 	}
 
-	attr->mmap = track;
-	attr->comm = track;
+	attr->exec_bit = track;
+	attr->comm_bit = track;
+	attr->mmap_bit = track;
 
 	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
 		attr->disabled = 1;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..000b48c 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -156,6 +156,33 @@ static PyTypeObject pyrf_comm_event__type = {
 	.tp_repr	= (reprfunc)pyrf_comm_event__repr,
 };
 
+static char pyrf_exec_event__doc[] = PyDoc_STR("perf exec event object.");
+
+static PyMemberDef pyrf_exec_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	member_def(exec_event, pid, T_UINT, "event pid"),
+	member_def(exec_event, tid, T_UINT, "event tid"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_exec_event__repr(struct pyrf_event *pevent)
+{
+	return PyString_FromFormat("{ type: exec, pid: %u, tid: %u }",
+				   pevent->event.exec.pid,
+				   pevent->event.exec.tid);
+}
+
+static PyTypeObject pyrf_exec_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.exec_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_exec_event__doc,
+	.tp_members	= pyrf_exec_event__members,
+	.tp_repr	= (reprfunc)pyrf_exec_event__repr,
+};
+
 static char pyrf_throttle_event__doc[] = PyDoc_STR("perf throttle event object.");
 
 static PyMemberDef pyrf_throttle_event__members[] = {
@@ -306,6 +333,9 @@ static int pyrf_event__setup_types(void)
 	err = PyType_Ready(&pyrf_comm_event__type);
 	if (err < 0)
 		goto out;
+	err = PyType_Ready(&pyrf_exec_event__type);
+	if (err < 0)
+		goto out;
 	err = PyType_Ready(&pyrf_throttle_event__type);
 	if (err < 0)
 		goto out;
@@ -323,6 +353,7 @@ static PyTypeObject *pyrf_event__type[] = {
 	[PERF_RECORD_MMAP]	 = &pyrf_mmap_event__type,
 	[PERF_RECORD_LOST]	 = &pyrf_lost_event__type,
 	[PERF_RECORD_COMM]	 = &pyrf_comm_event__type,
+	[PERF_RECORD_EXEC]	 = &pyrf_exec_event__type,
 	[PERF_RECORD_EXIT]	 = &pyrf_task_event__type,
 	[PERF_RECORD_THROTTLE]	 = &pyrf_throttle_event__type,
 	[PERF_RECORD_UNTHROTTLE] = &pyrf_throttle_event__type,
@@ -524,6 +555,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 		"precise_ip",
 		"mmap_data",
 		"sample_id_all",
+		"exec",
 		"wakeup_events",
 		"bp_type",
 		"bp_addr",
@@ -548,7 +580,8 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 	    watermark = 0,
 	    precise_ip = 0,
 	    mmap_data = 0,
-	    sample_id_all = 1;
+	    sample_id_all = 1,
+	    exec = 0;
 	int idx = 0;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs,
@@ -561,6 +594,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 					 &mmap, &comm, &freq, &inherit_stat,
 					 &enable_on_exec, &task, &watermark,
 					 &precise_ip, &mmap_data, &sample_id_all,
+					 &exec,
 					 &attr.wakeup_events, &attr.bp_type,
 					 &attr.bp_addr, &attr.bp_len, &idx))
 		return -1;
@@ -733,10 +767,11 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 }
 
 static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
-					 PyObject *args __used, PyObject *kwargs __used)
+					 PyObject *args __used,
+					 PyObject *kwargs __used)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-        PyObject *list = PyList_New(0);
+	PyObject *list = PyList_New(0);
 	int i;
 
 	for (i = 0; i < evlist->nr_fds; ++i) {
@@ -987,6 +1022,7 @@ static struct {
 	{ "RECORD_MMAP",       PERF_RECORD_MMAP },
 	{ "RECORD_LOST",       PERF_RECORD_LOST },
 	{ "RECORD_COMM",       PERF_RECORD_COMM },
+	{ "RECORD_EXEC",       PERF_RECORD_EXEC },
 	{ "RECORD_EXIT",       PERF_RECORD_EXIT },
 	{ "RECORD_THROTTLE",   PERF_RECORD_THROTTLE },
 	{ "RECORD_UNTHROTTLE", PERF_RECORD_UNTHROTTLE },
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9f833cf..a0bff02 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -343,6 +343,8 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->mmap = process_event_stub;
 	if (tool->comm == NULL)
 		tool->comm = process_event_stub;
+	if (tool->exec == NULL)
+		tool->exec = process_event_stub;
 	if (tool->fork == NULL)
 		tool->fork = process_event_stub;
 	if (tool->exit == NULL)
@@ -394,6 +396,12 @@ static void perf_event__comm_swap(union perf_event *event)
 	event->comm.tid = bswap_32(event->comm.tid);
 }
 
+static void perf_event__exec_swap(union perf_event *event)
+{
+	event->exec.pid = bswap_32(event->exec.pid);
+	event->exec.tid = bswap_32(event->exec.tid);
+}
+
 static void perf_event__mmap_swap(union perf_event *event)
 {
 	event->mmap.pid	  = bswap_32(event->mmap.pid);
@@ -464,6 +472,7 @@ typedef void (*perf_event__swap_op)(union perf_event *event);
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
 	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
+	[PERF_RECORD_EXEC]		  = perf_event__exec_swap,
 	[PERF_RECORD_FORK]		  = perf_event__task_swap,
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
@@ -805,6 +814,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		return tool->mmap(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
+	case PERF_RECORD_EXEC:
+		return tool->exec(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
 		return tool->fork(tool, event, sample, machine);
 	case PERF_RECORD_EXIT:
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..8b3e593 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,7 +39,6 @@ int thread__set_comm(struct thread *self, const char *comm)
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
 		self->comm_set = true;
-		map_groups__flush(&self->mg);
 	}
 	return err;
 }
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b0e1aad..df560f0 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -33,6 +33,7 @@ struct perf_tool {
 			read;
 	event_op	mmap,
 			comm,
+			exec,
 			fork,
 			exit,
 			lost,
-- 
1.7.7.3

