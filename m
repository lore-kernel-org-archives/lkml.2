Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418Ab2BNE4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:56:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65158 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2BNE4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:56:17 -0500
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
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Cc: sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com,
        Luigi Semenzato <semenzato@chromium.org>
Subject: [PATCH] Perf: bug fix: distinguish between rename and exec
Date: Mon, 13 Feb 2012 20:56:00 -0800
Message-Id: <1329195360-10699-1-git-send-email-semenzato@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible for "perf report" to distinguish between an exec and
a rename (for instance from prctl(PR_SET_NAME)).  Currently a similar COMM
record is produced for the two events.  Perf report assumes all COMM records
are execs and discards the old mappings.  Without mappings, perf report
can no longer correlate sampled IPs to the functions containing them,
and collapses all samples into a single bucket.

This change maintains backward compatibility in both directions, i.e. old
version of perf will continue to work on new perf.data files in the same
way, and new versions of perf on old data files.

Another solution would be to not send COMM records for renames.  Although
it seems reasonable, it might break existing setups.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
---
 fs/exec.c                  |    6 +++---
 fs/proc/base.c             |    2 +-
 include/linux/perf_event.h |    9 +++++++--
 include/linux/sched.h      |    2 +-
 kernel/events/core.c       |    4 ++--
 kernel/kthread.c           |    2 +-
 kernel/sys.c               |    2 +-
 tools/perf/util/event.c    |    4 +++-
 tools/perf/util/session.c  |    2 +-
 tools/perf/util/thread.c   |   11 ++++++-----
 tools/perf/util/thread.h   |    2 +-
 11 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..fc2792d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1052,7 +1052,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(get_task_comm);
 
-void set_task_comm(struct task_struct *tsk, char *buf)
+void set_task_comm(struct task_struct *tsk, char *buf, bool is_rename)
 {
 	task_lock(tsk);
 
@@ -1068,7 +1068,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
-	perf_event_comm(tsk);
+	perf_event_comm(tsk, is_rename);
 }
 
 static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
@@ -1142,7 +1142,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, bprm->tcomm);
+	set_task_comm(current, bprm->tcomm, false);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..cd2f609 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1361,7 +1361,7 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 		return -ESRCH;
 
 	if (same_thread_group(current, p))
-		set_task_comm(p, buffer);
+		set_task_comm(p, buffer, true);
 	else
 		count = -EINVAL;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index abb2776..3007ef0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -328,6 +328,11 @@ struct perf_event_mmap_page {
  */
 #define PERF_RECORD_MISC_EXACT_IP		(1 << 14)
 /*
+ * Indicates that a PERF_RECORD_COMM is a rename (prctl) rather than an exec.
+ * Note: this bit position has different meanings for different record types.
+ */
+#define PERF_RECORD_MISC_RENAME			(1 << 14)
+/*
  * Reserve the last bit to indicate some extended misc field
  */
 #define PERF_RECORD_MISC_EXT_RESERVED		(1 << 15)
@@ -1089,7 +1094,7 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
-extern void perf_event_comm(struct task_struct *tsk);
+extern void perf_event_comm(struct task_struct *tsk, bool is_rename);
 extern void perf_event_fork(struct task_struct *tsk);
 
 /* Callchains */
@@ -1179,7 +1184,7 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
-static inline void perf_event_comm(struct task_struct *tsk)		{ }
+static inline void perf_event_comm(struct task_struct *tsk, bool is_rename) { }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..0283de4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2293,7 +2293,7 @@ extern int do_execve(const char *,
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
-extern void set_task_comm(struct task_struct *tsk, char *from);
+extern void set_task_comm(struct task_struct *tsk, char *from, bool is_rename);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba36013..879d7a9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4250,7 +4250,7 @@ next:
 	rcu_read_unlock();
 }
 
-void perf_event_comm(struct task_struct *task)
+void perf_event_comm(struct task_struct *task, bool is_rename)
 {
 	struct perf_comm_event comm_event;
 	struct perf_event_context *ctx;
@@ -4274,7 +4274,7 @@ void perf_event_comm(struct task_struct *task)
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_COMM,
-				.misc = 0,
+				.misc = is_rename ? PERF_RECORD_MISC_RENAME : 0,
 				/* .size */
 			},
 			/* .pid */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..cacda74 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -277,7 +277,7 @@ int kthreadd(void *unused)
 	struct task_struct *tsk = current;
 
 	/* Setup a clean context for our children to inherit. */
-	set_task_comm(tsk, "kthreadd");
+	set_task_comm(tsk, "kthreadd", false);
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_states[N_HIGH_MEMORY]);
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..a0f42a4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1879,7 +1879,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			if (strncpy_from_user(comm, (char __user *)arg2,
 					      sizeof(me->comm) - 1) < 0)
 				return -EFAULT;
-			set_task_comm(me, comm);
+			set_task_comm(me, comm, true);
 			proc_comm_connector(me);
 			return 0;
 		case PR_GET_NAME:
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 73ddaf0..ba21a63 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -502,11 +502,13 @@ int perf_event__process_comm(struct perf_tool *tool __used,
 			     struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	bool is_rename = event->header.misc & PERF_EVENT_MISC_RENAME;
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
 
-	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
+	if (thread == NULL || thread__set_comm(thread, event->comm.comm,
+                                               is_rename)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ca255..f263875 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -924,7 +924,7 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 {
 	struct thread *thread = perf_session__findnew(self, 0);
 
-	if (thread == NULL || thread__set_comm(thread, "swapper")) {
+	if (thread == NULL || thread__set_comm(thread, "swapper", false)) {
 		pr_err("problem inserting idle task.\n");
 		thread = NULL;
 	}
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..be8063c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -29,7 +29,7 @@ void thread__delete(struct thread *self)
 	free(self);
 }
 
-int thread__set_comm(struct thread *self, const char *comm)
+int thread__set_comm(struct thread *self, const char *comm, bool is_rename)
 {
 	int err;
 
@@ -37,11 +37,12 @@ int thread__set_comm(struct thread *self, const char *comm)
 		free(self->comm);
 	self->comm = strdup(comm);
 	err = self->comm == NULL ? -ENOMEM : 0;
-	if (!err) {
-		self->comm_set = true;
+	if (err)
+		return err;
+	self->comm_set = true;
+	if (!is_rename)
 		map_groups__flush(&self->mg);
-	}
-	return err;
+	return 0;
 }
 
 int thread__comm_len(struct thread *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 70c2c13..758df3a 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -22,7 +22,7 @@ struct machine;
 
 void thread__delete(struct thread *self);
 
-int thread__set_comm(struct thread *self, const char *comm);
+int thread__set_comm(struct thread *self, const char *comm, bool is_rename);
 int thread__comm_len(struct thread *self);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
-- 
1.7.7.3

