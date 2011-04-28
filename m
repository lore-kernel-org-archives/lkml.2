Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1D1DQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:16:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47934 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1D1DQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:16:05 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Will Drewry <wad@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
Date: Wed, 27 Apr 2011 22:08:47 -0500
Message-Id: <1303960136-14298-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303960136-14298-1-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a new seccomp mode based on the work by
agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
an optional linked list of seccomp_filter objects. When in mode 2, all
system calls are first checked against the bitmask to determine if they
are allowed or denied.  If allowed, the list of filters is checked for
the given syscall number. If all filter predicates for the system call
match or the system call was allowed without restriction, the process
continues. Otherwise, it is killed and a KERN_INFO notification is
posted.

The filter language itself is provided by the ftrace filter engine.
Related patches tweak to the perf filter trace and free allow the calls
to be shared. Filters inherit their understanding of types and arguments
for each system call from the CONFIG_FTRACE_SYSCALLS subsystem which
predefines this information in syscall_metadata associated enter_event
(and exit_event) structures.

The result is that a process may reduce its available interfaces to
the kernel through prctl() without knowing the appropriate system call
number a priori and with the flexibility of filtering based on
register-stored arguments.  (String checks suffer from TOCTOU issues and
should be left to LSMs to provide policy for! Don't get greedy :)

A sample filterset for a process that only needs to interact over stdin
and stdout and exit cleanly is shown below:
  sys_read: fd == 0
  sys_write: fd == 1
  sys_exit_group: 1

The filters may be specified once prior to entering the reduced access
state:
  prctl(PR_SET_SECCOMP, 2, filters);
If prctl() is in the allowed bitmask, the process may futher reduce
privileges by dropping system calls from the allowed set.

The only other twist is that it is possible to delay enforcement by one
system call by supplying a "on_next_syscall: 1" 'filter'.  This allows
for a launcher process to fork(), prctl(), then execve() leaving the
launched binary in a filtered state.

Implementation-wise, seccomp.c now uses seccomp_state struct which is
managed using RCU primitives.  It contains the system call bitmask and
a linked list of seccomp_filters (which are also managed as an RCU
list).  All mutations (barring one optional bit flip) to the
seccomp_state are always done on a duplicate of the current state value
which is swapped on prior to use.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h |   98 +++++++++++-
 include/trace/syscall.h |    2 +
 kernel/Makefile         |    1 +
 kernel/fork.c           |    8 +
 kernel/seccomp.c        |  144 +++++++++++++++--
 kernel/seccomp_filter.c |  428 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c            |   11 +-
 kernel/trace/Kconfig    |   10 +
 8 files changed, 687 insertions(+), 15 deletions(-)
 create mode 100644 kernel/seccomp_filter.c

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..16703c4 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -4,10 +4,33 @@
 
 #ifdef CONFIG_SECCOMP
 
+#include <linux/list.h>
 #include <linux/thread_info.h>
+#include <linux/types.h>
 #include <asm/seccomp.h>
 
-typedef struct { int mode; } seccomp_t;
+/**
+ * struct seccomp_state - the state of a seccomp'ed process
+ *
+ * @mode:
+ *     if this is 1, the process is under standard seccomp rules
+ *             is 2, the process is only allowed to make system calls where
+ *                   the corresponding bit is set in bitmask and any
+ *                   associated filters evaluate successfully.
+ * @usage: number of references to the current instance.
+ * @bitmask: a mask of allowed or filtered system calls and additional flags.
+ * @filter_count: number of seccomp filters in @filters.
+ * @filters: list of seccomp_filter entries for  system calls.
+ */
+struct seccomp_state {
+	uint16_t mode;
+	atomic_t usage;
+	DECLARE_BITMAP(bitmask, NR_syscalls + 1);
+	int filter_count;
+	struct list_head filters;
+};
+
+typedef struct { struct seccomp_state *state; } seccomp_t;
 
 extern void __secure_computing(int);
 static inline void secure_computing(int this_syscall)
@@ -16,8 +39,14 @@ static inline void secure_computing(int this_syscall)
 		__secure_computing(this_syscall);
 }
 
+extern struct seccomp_state *seccomp_state_new(void);
+extern struct seccomp_state *seccomp_state_dup(const struct seccomp_state *);
+extern struct seccomp_state *get_seccomp_state(struct seccomp_state *);
+extern void put_seccomp_state(struct seccomp_state *);
 extern long prctl_get_seccomp(void);
-extern long prctl_set_seccomp(unsigned long);
+extern long prctl_set_seccomp(unsigned long, char *);
+
+#define SECCOMP_MAX_FILTER_LENGTH 16384
 
 #else /* CONFIG_SECCOMP */
 
@@ -27,16 +56,79 @@ typedef struct { } seccomp_t;
 
 #define secure_computing(x) do { } while (0)
 
+#define SECCOMP_MAX_FILTER_LENGTH 0
+
 static inline long prctl_get_seccomp(void)
 {
 	return -EINVAL;
 }
 
-static inline long prctl_set_seccomp(unsigned long arg2)
+static inline long prctl_set_seccomp(unsigned long arg2, unsigned char *filters)
 {
 	return -EINVAL;
 }
 
+static inline struct seccomp_state *seccomp_state_new(void)
+{
+	return NULL;
+}
+
+static inline struct seccomp_state *seccomp_state_dup(
+					const struct seccomp_state *state)
+{
+	return NULL;
+}
+
+static inline struct seccomp_state *get_seccomp_state(
+					struct seccomp_state *state)
+{
+	return NULL;
+}
+
+static inline void put_seccomp_state(struct seccomp_state *state)
+{
+}
+
 #endif /* CONFIG_SECCOMP */
 
+#if defined(CONFIG_SECCOMP) && defined(CONFIG_SECCOMP_FILTER)
+
+extern int seccomp_copy_all_filters(struct list_head *,
+				    const struct list_head *);
+extern void seccomp_drop_all_filters(struct seccomp_state *);
+
+extern int seccomp_parse_filters(struct seccomp_state *, char *);
+extern int seccomp_test_filters(struct seccomp_state *, int);
+
+extern int seccomp_show_filters(struct seccomp_state *, struct seq_file *);
+
+#else  /* CONFIG_SECCOMP && CONFIG_SECCOMP_FILTER */
+
+static inline int seccomp_test_filters(struct seccomp_state *state, int nr)
+{
+	return -EINVAL;
+}
+
+static inline int seccomp_parse_filters(struct seccomp_state *state,
+					char *filters)
+{
+	return -EINVAL;
+}
+
+static inline int seccomp_show_filters(struct seccomp_state *state,
+				       struct seq_file *m)
+{
+	return -EINVAL;
+}
+
+extern inline int seccomp_copy_all_filters(struct list_head *dst,
+					   const struct list_head *src)
+{
+	return 0;
+}
+
+static inline void seccomp_drop_all_filters(struct seccomp_state *state) { }
+
+#endif  /* CONFIG_SECCOMP && CONFIG_SECCOMP_FILTER */
+
 #endif /* _LINUX_SECCOMP_H */
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 242ae04..1f72fce 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -35,6 +35,8 @@ struct syscall_metadata {
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
+extern struct syscall_metadata *syscall_nr_to_meta(int);
+
 extern int reg_event_syscall_enter(struct ftrace_event_call *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
diff --git a/kernel/Makefile b/kernel/Makefile
index 85cbfb3..a4b21fb 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
+obj-$(CONFIG_SECCOMP_FILTER) += seccomp_filter.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..bdcf70b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -34,6 +34,7 @@
 #include <linux/cgroup.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/seccomp.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
@@ -169,6 +170,9 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
+#ifdef CONFIG_SECCOMP
+	put_seccomp_state(tsk->seccomp.state);
+#endif
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -280,6 +284,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (err)
 		goto out;
 
+#ifdef CONFIG_SECCOMP
+	tsk->seccomp.state = get_seccomp_state(orig->seccomp.state);
+#endif
+
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 57d4b13..1bee87c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -8,10 +8,11 @@
 
 #include <linux/seccomp.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/compat.h>
 
 /* #define SECCOMP_DEBUG 1 */
-#define NR_SECCOMP_MODES 1
+#define NR_SECCOMP_MODES 2
 
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
@@ -32,9 +33,11 @@ static int mode1_syscalls_32[] = {
 
 void __secure_computing(int this_syscall)
 {
-	int mode = current->seccomp.mode;
+	int mode = -1;
 	int * syscall;
-
+	/* Do we need an RCU read lock to access current's state? */
+	if (current->seccomp.state)
+		mode = current->seccomp.state->mode;
 	switch (mode) {
 	case 1:
 		syscall = mode1_syscalls;
@@ -47,6 +50,16 @@ void __secure_computing(int this_syscall)
 				return;
 		} while (*++syscall);
 		break;
+	case 2:
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
+			/* XXX: No compat support yet. */
+			break;
+#endif
+		if (!seccomp_test_filters(current->seccomp.state,
+					  this_syscall))
+			return;
+		break;
 	default:
 		BUG();
 	}
@@ -57,30 +70,139 @@ void __secure_computing(int this_syscall)
 	do_exit(SIGKILL);
 }
 
+/* seccomp_state_new - allocate a new state object. */
+struct seccomp_state *seccomp_state_new()
+{
+	struct seccomp_state *new = kzalloc(sizeof(struct seccomp_state),
+					    GFP_KERNEL);
+	if (!new)
+		return NULL;
+	atomic_set(&new->usage, 1);
+	INIT_LIST_HEAD(&new->filters);
+	return new;
+}
+
+/* seccomp_state_dup - copies an existing state object. */
+struct seccomp_state *seccomp_state_dup(const struct seccomp_state *orig)
+{
+	int err;
+	struct seccomp_state *new = seccomp_state_new();
+
+	err = -ENOMEM;
+	if (!new)
+		goto fail;
+	new->mode = orig->mode;
+	memcpy(new->bitmask, orig->bitmask, sizeof(new->bitmask));
+	err = seccomp_copy_all_filters(&new->filters,
+				       &orig->filters);
+	if (err)
+		goto fail;
+	new->filter_count = orig->filter_count;
+
+	return new;
+fail:
+	put_seccomp_state(new);
+	return NULL;
+}
+
+/* get_seccomp_state - increments the reference count of @orig */
+struct seccomp_state *get_seccomp_state(struct seccomp_state *orig)
+{
+	if (!orig)
+		return NULL;
+	atomic_inc(&orig->usage);
+	return orig;
+}
+
+static void __put_seccomp_state(struct seccomp_state *orig)
+{
+	WARN_ON(atomic_read(&orig->usage));
+	seccomp_drop_all_filters(orig);
+	kfree(orig);
+}
+
+/* put_seccomp_state - decrements the reference count of @orig and may free. */
+void put_seccomp_state(struct seccomp_state *orig)
+{
+	if (!orig)
+		return;
+
+	if (atomic_dec_and_test(&orig->usage))
+		__put_seccomp_state(orig);
+}
+
 long prctl_get_seccomp(void)
 {
-	return current->seccomp.mode;
+	if (!current->seccomp.state)
+		return 0;
+	return current->seccomp.state->mode;
 }
 
-long prctl_set_seccomp(unsigned long seccomp_mode)
+long prctl_set_seccomp(unsigned long seccomp_mode, char *filters)
 {
 	long ret;
+	struct seccomp_state *state, *orig_state;
 
-	/* can set it only once to be even more secure */
+	rcu_read_lock();
+	orig_state = get_seccomp_state(rcu_dereference(current->seccomp.state));
+	rcu_read_unlock();
+
+	/* mode 1 can only be set once, but mode 2 may have access reduced. */
 	ret = -EPERM;
-	if (unlikely(current->seccomp.mode))
+	if (orig_state && orig_state->mode != 2 && seccomp_mode != 2)
 		goto out;
 
 	ret = -EINVAL;
-	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
-		current->seccomp.mode = seccomp_mode;
-		set_thread_flag(TIF_SECCOMP);
+	if (!seccomp_mode || seccomp_mode > NR_SECCOMP_MODES)
+		goto out;
+
+	/* Prepare to modify the seccomp state by dropping the shared
+	 * reference after duplicating it.
+	 */
+	state = (orig_state ? seccomp_state_dup(orig_state) :
+			      seccomp_state_new());
+	if (!state) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = 0;
+	switch (seccomp_mode) {
+	case 1:
 #ifdef TIF_NOTSC
 		disable_TSC();
 #endif
+		state->mode = seccomp_mode;
+		set_thread_flag(TIF_SECCOMP);
 		ret = 0;
+		break;
+	case 2:
+		if (filters) {
+			ret = seccomp_parse_filters(state, filters);
+			/* No partial applications. */
+			if (ret)
+				goto free_state;
+		}
+
+		if (!state->mode) {
+			state->mode = seccomp_mode;
+			set_thread_flag(TIF_SECCOMP);
+		}
+		break;
+	default:
+		ret = -EINVAL;
 	}
 
- out:
+	rcu_assign_pointer(current->seccomp.state, state);
+	synchronize_rcu();
+	put_seccomp_state(orig_state);  /* for the get */
+
+out:
+	put_seccomp_state(orig_state);  /* for the task */
+	return ret;
+
+free_state:
+	put_seccomp_state(orig_state);  /* for the get */
+	put_seccomp_state(state);  /* drop the dup */
 	return ret;
 }
diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
new file mode 100644
index 0000000..8f7878b
--- /dev/null
+++ b/kernel/seccomp_filter.c
@@ -0,0 +1,428 @@
+/* filter engine-based seccomp system call filtering.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ */
+
+#include <linux/seccomp.h>
+#include <linux/seq_file.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include <asm/syscall.h>
+#include <trace/syscall.h>
+
+#define SECCOMP_MAX_FILTER_COUNT 16
+#define SECCOMP_DIRECTIVE_ON_NEXT "on_next_syscall"
+#define SECCOMP_ON_NEXT_BIT NR_syscalls
+
+struct seccomp_filter {
+	struct list_head list;
+	struct rcu_head rcu;
+	int syscall_nr;
+	struct syscall_metadata *data;
+	struct event_filter *event_filter;
+};
+
+static struct seccomp_filter *alloc_seccomp_filter(int syscall_nr,
+						   const char *filter_string)
+{
+	int err;
+	struct seccomp_filter *filter = kzalloc(sizeof(struct seccomp_filter),
+						GFP_KERNEL);
+	if (!filter)
+		goto fail;
+
+	filter->syscall_nr = syscall_nr;
+	filter->data = syscall_nr_to_meta(syscall_nr);
+	if (!filter->data)
+		goto fail;
+
+	err = ftrace_parse_filter(&filter->event_filter,
+				  filter->data->enter_event->event.type,
+				  filter_string);
+	if (err)
+		goto fail;
+
+	return filter;
+
+fail:
+	kfree(filter);
+	return NULL;
+}
+
+static void free_seccomp_filter(struct seccomp_filter *filter)
+{
+	ftrace_free_filter(filter->event_filter);
+	kfree(filter);
+}
+
+static void free_seccomp_filter_rcu(struct rcu_head *head)
+{
+	free_seccomp_filter(container_of(head,
+					 struct seccomp_filter,
+					 rcu));
+}
+
+static struct seccomp_filter *copy_seccomp_filter(struct seccomp_filter *orig)
+{
+	return alloc_seccomp_filter(orig->syscall_nr,
+				ftrace_get_filter_string(orig->event_filter));
+}
+
+/* Safely drops all filters for a given syscall. */
+static void drop_matching_filters(struct seccomp_state *state, int syscall_nr)
+{
+	struct list_head *this, *temp;
+	list_for_each_safe(this, temp, &state->filters) {
+		struct seccomp_filter *f = list_entry(this,
+						      struct seccomp_filter,
+						      list);
+		if (f->syscall_nr == syscall_nr) {
+			WARN_ON(state->filter_count == 0);
+			state->filter_count--;
+			list_del_rcu(this);
+			call_rcu(&f->rcu, free_seccomp_filter_rcu);
+		}
+	}
+}
+
+static int add_filter(struct seccomp_state *state, int syscall_nr,
+		      char *filter_string)
+{
+	struct syscall_metadata *data;
+	struct seccomp_filter *filter;
+
+	if (state->filter_count == SECCOMP_MAX_FILTER_COUNT - 1)
+		return -EINVAL;
+
+	/* This check will catch flag bits, like on_next_syscall. */
+	data = syscall_nr_to_meta(syscall_nr);
+	if (!data)
+		return -EINVAL;
+
+	filter = alloc_seccomp_filter(syscall_nr,
+				    filter_string);
+	if (!filter)
+		return -EINVAL;
+
+	state->filter_count++;
+	list_add_tail_rcu(&filter->list, &state->filters);
+	return 0;
+}
+
+static int syscall_name_to_nr(const char *name)
+{
+	int i;
+	for (i = 0; i < NR_syscalls; i++) {
+		struct syscall_metadata *meta = syscall_nr_to_meta(i);
+		if (!meta)
+			continue;
+		if (!strcmp(meta->name, name))
+			return i;
+	}
+	return -1;
+}
+
+static int directive_to_bit(const char *syscall)
+{
+	int syscall_nr = -1;
+	if (!strcmp(syscall, SECCOMP_DIRECTIVE_ON_NEXT))
+		return SECCOMP_ON_NEXT_BIT;
+	syscall_nr = syscall_name_to_nr(syscall);
+	return syscall_nr;
+}
+
+/* 1 on match, 0 otherwise. */
+static int filter_match_current(struct seccomp_filter *filter)
+{
+	int err;
+	uint8_t syscall_state[64];
+
+	memset(syscall_state, 0, sizeof(syscall_state));
+
+	/* The generic tracing entry can remain zeroed. */
+	err = ftrace_syscall_enter_state(syscall_state, sizeof(syscall_state),
+					 NULL);
+	if (err)
+		return 0;
+
+	return filter_match_preds(filter->event_filter, syscall_state);
+}
+
+/**
+ * parse_seccomp_filter() - update a system call mask
+ * @state: the seccomp_state to update.
+ * @filter: a rule expressed in a char array.
+ */
+static int parse_seccomp_filter(struct seccomp_state *state,
+				char *filter_spec)
+{
+	char *filter_string;
+	char *syscall = filter_spec;
+	int syscall_nr = -1;
+	int ret = -EINVAL;
+
+	if (!state)
+		goto done;
+
+	if (!filter_spec)
+		goto done;
+
+	/* Expected format is
+	 * directive: filter_string
+	 * where directive may be a system call name (sys_*) or
+	 * on_next_syscall.
+	 */
+	filter_string = strchr(filter_spec, ':');
+	if (!filter_string)
+		goto done;
+
+	*filter_string++ = '\0';
+
+	/* Map the name to the syscalls defined name. */
+	syscall_nr = directive_to_bit(syscall);
+	if (syscall_nr < 0) {
+		goto done;
+	}
+
+	/* Short-circuit filter parsing and check for "0" to clear. */
+	ret = 0;
+	if (!strcmp(strstrip(filter_string), "0")) {
+		clear_bit(syscall_nr, state->bitmask);
+		drop_matching_filters(state, syscall_nr);
+		goto done;
+	}
+	/* Do not allow any allowed syscalls or filter additions when a
+	 * secure computing mode is enabled.
+	 */
+	ret = -EPERM;
+	if (state->mode)
+		goto done;
+
+	/* Short-circuit parsing for the allow case. */
+	if (!strcmp(strstrip(filter_string), "1"))
+		goto allow;
+
+	/* Attempt to create a new filter, but don't do it if it doesn't parse.
+	 */
+	/* TODO either use append_filter_string or replace old matches. */
+	if (add_filter(state, syscall_nr, filter_string)) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+allow:
+	ret = 0;
+	set_bit(syscall_nr, state->bitmask);
+
+done:
+	return ret;
+}
+
+#ifndef KSTK_EIP
+#define KSTK_EIP(x) 0L
+#endif
+
+static void log_failure(int syscall)
+{
+	const char *syscall_name = "unknown";
+	struct syscall_metadata *data = syscall_nr_to_meta(syscall);
+	if (data)
+		syscall_name = data->name;
+	printk(KERN_INFO
+		"%s[%d]: system call %d (%s) blocked at ip:%lx\n",
+		current->comm, task_pid_nr(current), syscall, syscall_name,
+		KSTK_EIP(current));
+}
+
+/* seccomp_drop_all_filters - cleans up the filter list
+ *
+ * @state: the seccomp_state to destroy the filters in.
+ */
+void seccomp_drop_all_filters(struct seccomp_state *state)
+{
+	struct list_head *this, *temp;
+	state->filter_count = 0;
+	if (list_empty(&state->filters))
+		return;
+	list_for_each_safe(this, temp, &state->filters) {
+		struct seccomp_filter *f = list_entry(this,
+						      struct seccomp_filter,
+						      list);
+		list_del_rcu(this);
+		/* Schedules freeing on the RCU. */
+		call_rcu(&f->rcu, free_seccomp_filter_rcu);
+	}
+}
+EXPORT_SYMBOL_GPL(seccomp_drop_all_filters);
+
+/* seccomp_copy_all_filters - copies all filters from src to dst.
+ *
+ * @dst: the list_head for seccomp_filters to populate.
+ * @src: the list_head for seccomp_filters to copy from.
+ * Returns non-zero on failure.
+ */
+int seccomp_copy_all_filters(struct list_head *dst,
+			     const struct list_head *src)
+{
+	struct seccomp_filter *filter;
+	int ret = 0;
+	BUG_ON(!dst || !src);
+	if (list_empty(src))
+		goto done;
+	rcu_read_lock();
+	list_for_each_entry(filter, src, list) {
+		struct seccomp_filter *new_filter = copy_seccomp_filter(filter);
+		if (!new_filter) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		list_add_tail_rcu(&new_filter->list, dst);
+	}
+
+done:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(seccomp_copy_all_filters);
+
+/* seccomp_show_filters - prints the filter state to a seq_file
+ * @state: the seccomp_state to enumerate the filter and bitmask of.
+ * @m: the prepared seq_file to receive the data.
+ * Returns 0 on a successful write.
+ */
+int seccomp_show_filters(struct seccomp_state *state, struct seq_file *m)
+{
+	int i = 0;
+	if (!state) {
+		return 0;
+	}
+
+	if (test_bit(SECCOMP_ON_NEXT_BIT, state->bitmask))
+		seq_printf(m, SECCOMP_DIRECTIVE_ON_NEXT ": 1\n");
+	/* Lazy but effective. */
+	do {
+		struct syscall_metadata *meta;
+		struct seccomp_filter *filter;
+		int filtered = 0;
+		if (!test_bit(i, state->bitmask))
+			continue;
+		rcu_read_lock();
+		list_for_each_entry_rcu(filter, &state->filters, list) {
+			if (filter->syscall_nr == i) {
+				filtered = 1;
+				seq_printf(m, "%s: %s\n",
+				   filter->data->name,
+				   ftrace_get_filter_string(
+					filter->event_filter));
+			}
+		}
+		rcu_read_unlock();
+
+		if (!filtered) {
+			meta = syscall_nr_to_meta(i);
+			BUG_ON(!meta);
+			seq_printf(m, "%s: 1\n", meta->name);
+		}
+	} while (++i < NR_syscalls);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(seccomp_show_filters);
+
+/* seccomp_test_filters - tests 'current' agaist the given syscall
+ *
+ * @state: seccomp_state of current to use.
+ * @syscall: number of the system call to test
+ * Returns 0 on ok and non-zero on error/failure.
+ */
+int seccomp_test_filters(struct seccomp_state *state, int syscall)
+{
+	struct seccomp_filter *filter = NULL;
+	int ret = 0;
+	if (syscall >= NR_syscalls) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* The non-atomic version is used.  Since the goal of this bit is to
+	 * provide a means to set a filter set prior to  exec*(), it there
+	 * should not be a race nor should it matter if one occurs.
+	 */
+	if (__test_and_clear_bit(NR_syscalls, state->bitmask)) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!test_bit(syscall, state->bitmask)) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	/* Check if the syscall is filtered, if not, allow it. */
+	rcu_read_lock();
+	/* XXX: using two bitmasks would avoid searching the filter list
+	 *      unnecessarily.
+	 */
+	list_for_each_entry(filter, &state->filters, list) {
+		/* Multiple filters are allowed per system call.
+		 * They are logically ANDed in order of addition.
+		 */
+		if (filter->syscall_nr == syscall) {
+			if (!filter_match_current(filter)) {
+				ret = -EACCES;
+				goto out_unlock;
+			}
+		}
+	}
+
+out_unlock:
+	rcu_read_unlock();
+out:
+	if (ret)
+		log_failure(syscall);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(seccomp_test_filters);
+
+/* seccomp_parse_filters - populates state with seccomp_filters
+ *
+ * @state: seccomp state to manage the filters on.
+ * @buf: list of seccomp filters of the format:
+ *       directive: ftrace_filter_string
+ * Returns 0 on success or non-zero if any filter is invalid.
+ *
+ * A directive may be any valid syscalls enter event name,
+ * like sys_newuname, or SECCOMP_DIRECTIVE_ON_NEXT.
+ *
+ * See parse_seccomp_filter for exact behavior.
+ */
+int seccomp_parse_filters(struct seccomp_state *state, char *buf)
+{
+	char *filter, *next;
+	int err = 0;
+	next = buf;
+	while ((filter = strsep(&next, "\n")) != NULL) {
+		if (!filter[0])
+			continue;
+		if ((err = parse_seccomp_filter(state, filter)))
+			break;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(seccomp_parse_filters);
diff --git a/kernel/sys.c b/kernel/sys.c
index af468ed..1d3f27e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1620,6 +1620,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 {
 	struct task_struct *me = current;
 	unsigned char comm[sizeof(me->comm)];
+	char *seccomp_filter = NULL;
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -1703,7 +1704,15 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = prctl_get_seccomp();
 			break;
 		case PR_SET_SECCOMP:
-			error = prctl_set_seccomp(arg2);
+			if (arg3 && SECCOMP_MAX_FILTER_LENGTH) {
+				seccomp_filter = strndup_user(
+						   (char __user *)arg3,
+						   SECCOMP_MAX_FILTER_LENGTH);
+				if (!seccomp_filter)
+					return -ENOMEM;
+			}
+			error = prctl_set_seccomp(arg2, seccomp_filter);
+			kfree(seccomp_filter);
 			break;
 		case PR_GET_TSC:
 			error = GET_TSC_CTL(arg2);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 61d7d59..e21b9eb 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -240,6 +240,16 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
+config SECCOMP_FILTER
+	bool "Enable seccomp trace event-based filtering"
+	depends on FTRACE_SYSCALLS
+	select CONFIG_SECCOMP
+	help
+	  Per-process, inherited system call filtering using shared code
+	  across seccomp and ftrace_syscalls.
+
+	  See Documentation/trace/seccomp_filter.txt for more detail.
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
-- 
1.7.0.4

