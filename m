Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab1FXAiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:38:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64818 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab1FXAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g7bSQVasAP2Vj3smvuF8OQj2T651rnVBywn747uMkTr7ylkqcUTQYQuDdcIh2sbZwG
         zZ52hch6COpANER5O8hZGwNhundtlQz85M+0NbftSNTYupoUIN78ISU28DZU/lxMJAkf
         DV/oA8HCNQMqaBTgfvTRh68bnm48fjPxWpEQU=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v9 03/13] seccomp_filter: new mode with configurable syscall filters
Date: Thu, 23 Jun 2011 19:36:42 -0500
Message-Id: <1308875813-20122-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308875813-20122-1-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a new seccomp mode which specifies the allowed system
calls dynamically.  When in the new mode (2), all system calls are
checked against process-defined filters - first by system call number,
then by a filter string.  If an entry exists for a given system call and
all filter predicates evaluate to true, then the task may proceed.
Otherwise, the task is killed.

Filter string parsing and evaluation is handled by the ftrace filter
engine.  Related patches tweak to the perf filter trace and free
allowing the calls to be shared. Filters inherit their understanding of
types and arguments for each system call from the CONFIG_FTRACE_SYSCALLS
subsystem which already populates this information in syscall_metadata
associated enter_event (and exit_event) structures. If
CONFIG_FTRACE_SYSCALLS is not compiled in, only filter strings of "1"
will be allowed.

The net result is a process may have its system calls filtered using the
ftrace filter engine's inherent understanding of systems calls.  The set
of filters is specified through the PR_SET_SECCOMP_FILTER argument in
prctl(). For example, a filterset for a process, like pdftotext, that
should only process read-only input could (roughly) look like:
  sprintf(rdonly, "flags == %u", O_RDONLY|O_LARGEFILE);
  type = PR_SECCOMP_FILTER_SYSCALL;
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_open, rdonly);
  prctl(PR_SET_SECCOMP_FILTER, type, __NR__llseek, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_brk, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_close, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_exit_group, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_fstat64, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_mmap2, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_munmap, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_read, "1");
  prctl(PR_SET_SECCOMP_FILTER, type, __NR_write, "fd == 1 || fd == 2");
  prctl(PR_SET_SECCOMP, 2);

Subsequent calls to PR_SET_SECCOMP_FILTER for the same system call will
be &&'d together to ensure that attack surface may only be reduced:
  prctl(PR_SET_SECCOMP_FILTER, __NR_write, "fd != 2");

With the earlier example, the active filter becomes:
  "(fd == 1 || fd == 2) && (fd != 2)"

The patch also adds PR_CLEAR_SECCOMP_FILTER and PR_GET_SECCOMP_FILTER.
The latter returns the current filter for a system call to userspace:

  prctl(PR_GET_SECCOMP_FILTER, type, __NR_write, buf, bufsize);

while the former clears any filters for a given system call changing it
back to a defaulty deny:

  prctl(PR_CLEAR_SECCOMP_FILTER, type, __NR_write);

Note, type may be either PR_SECCOMP_FILTER_EVENT or
PR_SECCOMP_FILTER_SYSCALL.  This allows for ftrace event ids to be used
in lieu of system call numbers.  At present, only syscalls:sys_enter_*
event id are supported, but this allows for potential future extension
of the backend.

v9: - rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
    - disallow PR_SECCOMP_FILTER_EVENT when a compat task is calling
      as ftrace has no compat_syscalls awareness yet.
    - return -ENOSYS when filter engine strings are used on a compat call
      as there are no compat_syscalls events to reference yet.
v8: - expand parenthical use during SET_SECCOMP_FILTER to avoid operator
      precedence undermining attack surface reduction (caught by
      segoon@openwall.com).  Opted to waste bytes on () than reparse to
      avoid OP_OR precedence overriding extend_filter's intentions.
    - remove more lingering references to @state
    - fix incorrect compat mismatch check (anyone up for a Tested-By?)
v7: - disallow seccomp_filter inheritance across fork except when seccomp
      is active.  This avoids filters leaking across processes when they
      are not actively in use but ensure an allowed fork/clone doesn't drop
      filters.
    - remove the Mode: print from show as it reflected current and not the
      filters holder.
v6: - clean up minor unnecessary changes (empty lines, ordering, etc)
    - fix one overly long line
    - add refcount overflow BUG_ON
v5: - drop mutex usage when the task_struct is safe to access directly
v4: - move off of RCU to a read/write guarding mutex after
      paulmck@linux.vnet.ibm.com's feedback (mem leak, rcu fail)
    - stopped inc/dec refcounts in mutex guard sections
    - added required changes to init the mutex in INIT_TASK and safely
      lock around fork inheritance.
    - added id_type support to the prctl interface to support using
      ftrace event ids as an alternative to syscall numbers.  Behavior
      is identical otherwise (as per discussion with mingo@elte.hu)
v3: - always block execve calls (as per torvalds@linux-foundation.org)
    - add __NR_seccomp_execve(_32) to seccomp-supporting arches
    - ensure compat tasks can't reach ftrace:syscalls
    - dropped new defines for seccomp modes.
    - two level array instead of hlists (sugg. by olofj@chromium.org)
    - added generic Kconfig entry that is not connected.
    - dropped internal seccomp.h
    - move prctl helpers to seccomp_filter
    - killed seccomp_t typedef (as per checkpatch)
v2: - changed to use the existing syscall number ABI.
    - prctl changes to minimize parsing in the kernel:
      prctl(PR_SET_SECCOMP, {0 | 1 | 2 }, { 0 | ON_EXEC });
      prctl(PR_SET_SECCOMP_FILTER, __NR_read, "fd == 5");
      prctl(PR_CLEAR_SECCOMP_FILTER, __NR_read);
      prctl(PR_GET_SECCOMP_FILTER, __NR_read, buf, bufsize);
    - defined PR_SECCOMP_MODE_STRICT and ..._FILTER
    - added flags
    - provide a default fail syscall_nr_to_meta in ftrace
    - provides fallback for unhooked system calls
    - use -ENOSYS and ERR_PTR(-ENOSYS) for stubbed functionality
    - added kernel/seccomp.h to share seccomp.c/seccomp_filter.c
    - moved to a hlist and 4 bit hash of linked lists
    - added support to operate without CONFIG_FTRACE_SYSCALLS
    - moved Kconfig support next to SECCOMP
    - made Kconfig entries dependent on EXPERIMENTAL
    - added macros to avoid ifdefs from kernel/fork.c
    - added compat task/filter matching
    - drop seccomp.h inclusion in sched.h and drop seccomp_t
    - added Filtering to "show" output
    - added on_exec state dup'ing when enabling after a fast-path accept.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/init_task.h |   12 +
 include/linux/prctl.h     |    7 +
 include/linux/sched.h     |    2 +-
 include/linux/seccomp.h   |  119 ++++++-
 include/trace/syscall.h   |    7 +
 kernel/Makefile           |    3 +
 kernel/fork.c             |    4 +
 kernel/seccomp.c          |   38 ++-
 kernel/seccomp_filter.c   |  875 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c              |   12 +
 security/Kconfig          |   17 +
 11 files changed, 1083 insertions(+), 13 deletions(-)
 create mode 100644 kernel/seccomp_filter.c

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 580f70c..56deaf2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -126,6 +126,17 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_SECCOMP_FILTER
+# define INIT_SECCOMP_FILTER(tsk)					\
+	.seccomp = { \
+		.filters_guard = \
+			__MUTEX_INITIALIZER(tsk.seccomp.filters_guard), \
+	},
+#else
+# define INIT_SECCOMP_FILTER(tsk)
+#endif
+
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -188,6 +199,7 @@ extern struct cred init_cred;
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\
+	INIT_SECCOMP_FILTER(tsk)					\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..dac7413 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -64,6 +64,13 @@
 #define PR_GET_SECCOMP	21
 #define PR_SET_SECCOMP	22
 
+/* Get/set process seccomp filters */
+#define PR_GET_SECCOMP_FILTER	35
+#define PR_SET_SECCOMP_FILTER	36
+#define PR_CLEAR_SECCOMP_FILTER	37
+#  define PR_SECCOMP_FILTER_SYSCALL	0
+#  define PR_SECCOMP_FILTER_EVENT	1
+
 /* Get/set the capability bounding set (as per security/commoncap.c) */
 #define PR_CAPBSET_READ 23
 #define PR_CAPBSET_DROP 24
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..4cb3070 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1395,7 +1395,7 @@ struct task_struct {
 	uid_t loginuid;
 	unsigned int sessionid;
 #endif
-	seccomp_t seccomp;
+	struct seccomp_struct seccomp;
 
 /* Thread group tracking */
    	u32 parent_exec_id;
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..320fc88 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -1,13 +1,35 @@
 #ifndef _LINUX_SECCOMP_H
 #define _LINUX_SECCOMP_H
 
+struct seq_file;
 
 #ifdef CONFIG_SECCOMP
 
+#include <linux/errno.h>
 #include <linux/thread_info.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
 #include <asm/seccomp.h>
 
-typedef struct { int mode; } seccomp_t;
+struct seccomp_filters;
+/**
+ * struct seccomp_struct - the state of a seccomp'ed process
+ *
+ * @mode:
+ *     if this is 1, the process is under standard seccomp rules
+ *             is 2, the process is only allowed to make system calls where
+ *                   associated filters evaluate successfully.
+ * @filters: Metadata for filters if using CONFIG_SECCOMP_FILTER.
+ *           @filters assignment and use should always be guarded by
+ *           @filters_guard.
+ */
+struct seccomp_struct {
+	int mode;
+#ifdef CONFIG_SECCOMP_FILTER
+	struct mutex filters_guard;
+	struct seccomp_filters *filters;
+#endif
+};
 
 extern void __secure_computing(int);
 static inline void secure_computing(int this_syscall)
@@ -23,8 +45,7 @@ extern long prctl_set_seccomp(unsigned long);
 
 #include <linux/errno.h>
 
-typedef struct { } seccomp_t;
-
+struct seccomp_struct { };
 #define secure_computing(x) do { } while (0)
 
 static inline long prctl_get_seccomp(void)
@@ -39,4 +60,96 @@ static inline long prctl_set_seccomp(unsigned long arg2)
 
 #endif /* CONFIG_SECCOMP */
 
+#ifdef CONFIG_SECCOMP_FILTER
+
+#define seccomp_filter_init_task(_tsk) do { \
+	mutex_init(&(_tsk)->seccomp.filters_guard); \
+	(_tsk)->seccomp.filters = NULL; \
+} while (0);
+
+/* Do nothing unless seccomp filtering is active. If not, the execve boundary
+ * can not be cleanly enforced and preset filters may leak across execve calls.
+ */
+#define seccomp_filter_fork(_tsk, _orig) do { \
+	if ((_tsk)->seccomp.mode) { \
+		(_tsk)->seccomp.mode = (_orig)->seccomp.mode; \
+		mutex_lock(&(_orig)->seccomp.filters_guard); \
+		(_tsk)->seccomp.filters = \
+			get_seccomp_filters((_orig)->seccomp.filters); \
+		mutex_unlock(&(_orig)->seccomp.filters_guard); \
+	} \
+} while (0);
+
+/* No locking is needed here because the task_struct will
+ * have no parallel consumers.
+ */
+#define seccomp_filter_free_task(_tsk) do { \
+	put_seccomp_filters((_tsk)->seccomp.filters); \
+} while (0);
+
+extern int seccomp_show_filters(struct seccomp_filters *filters,
+				struct seq_file *);
+extern long seccomp_set_filter(int, char *);
+extern long seccomp_clear_filter(int);
+extern long seccomp_get_filter(int, char *, unsigned long);
+
+extern long prctl_set_seccomp_filter(unsigned long, unsigned long,
+				     char __user *);
+extern long prctl_get_seccomp_filter(unsigned long, unsigned long,
+				     char __user *, unsigned long);
+extern long prctl_clear_seccomp_filter(unsigned long, unsigned long);
+
+extern struct seccomp_filters *get_seccomp_filters(struct seccomp_filters *);
+extern void put_seccomp_filters(struct seccomp_filters *);
+
+extern int seccomp_test_filters(int);
+extern void seccomp_filter_log_failure(int);
+
+#else  /* CONFIG_SECCOMP_FILTER */
+
+struct seccomp_filters { };
+#define seccomp_filter_init_task(_tsk) do { } while (0);
+#define seccomp_filter_fork(_tsk, _orig) do { } while (0);
+#define seccomp_filter_free_task(_tsk) do { } while (0);
+
+static inline int seccomp_show_filters(struct seccomp_filters *filters,
+				       struct seq_file *m)
+{
+	return -ENOSYS;
+}
+
+static inline long seccomp_set_filter(int syscall_nr, char *filter)
+{
+	return -ENOSYS;
+}
+
+static inline long seccomp_clear_filter(int syscall_nr)
+{
+	return -ENOSYS;
+}
+
+static inline long seccomp_get_filter(int syscall_nr,
+				      char *buf, unsigned long available)
+{
+	return -ENOSYS;
+}
+
+static inline long prctl_set_seccomp_filter(unsigned long a2, unsigned long a3,
+					    char __user *a4)
+{
+	return -ENOSYS;
+}
+
+static inline long prctl_clear_seccomp_filter(unsigned long a2,
+					      unsigned long a3)
+{
+	return -ENOSYS;
+}
+
+static inline long prctl_get_seccomp_filter(unsigned long a2, unsigned long a3,
+					    char __user *a4, unsigned long a5)
+{
+	return -ENOSYS;
+}
+#endif  /* CONFIG_SECCOMP_FILTER */
 #endif /* _LINUX_SECCOMP_H */
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 242ae04..e061ad0 100644
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
@@ -49,6 +51,11 @@ enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
 				      struct trace_event *event);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
 				     struct trace_event *event);
+#else
+static inline struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	return NULL;
+}
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..ffc77c8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -79,6 +79,9 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
+ifeq ($(CONFIG_SECCOMP_FILTER),y)
+obj-$(CONFIG_SECCOMP) += seccomp_filter.o
+endif
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..166cf10 100644
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
@@ -168,6 +169,7 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
+	seccomp_filter_free_task(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -1211,6 +1213,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p);
 
+	seccomp_filter_init_task(p);
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
@@ -1366,6 +1369,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_fork_read_unlock(current);
 	perf_event_fork(p);
+	seccomp_filter_fork(p, current);
 	return p;
 
 bad_fork_free_pid:
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 57d4b13..0a942be 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -2,16 +2,20 @@
  * linux/kernel/seccomp.c
  *
  * Copyright 2004-2005  Andrea Arcangeli <andrea@cpushare.com>
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
  *
  * This defines a simple but solid secure-computing mode.
  */
 
 #include <linux/seccomp.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/compat.h>
+#include <linux/unistd.h>
+#include <linux/ftrace_event.h>
 
+#define SECCOMP_MAX_FILTER_LENGTH MAX_FILTER_STR_VAL
 /* #define SECCOMP_DEBUG 1 */
-#define NR_SECCOMP_MODES 1
 
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
@@ -32,10 +36,9 @@ static int mode1_syscalls_32[] = {
 
 void __secure_computing(int this_syscall)
 {
-	int mode = current->seccomp.mode;
 	int * syscall;
 
-	switch (mode) {
+	switch (current->seccomp.mode) {
 	case 1:
 		syscall = mode1_syscalls;
 #ifdef CONFIG_COMPAT
@@ -47,6 +50,17 @@ void __secure_computing(int this_syscall)
 				return;
 		} while (*++syscall);
 		break;
+#ifdef CONFIG_SECCOMP_FILTER
+	case 2:
+		if (this_syscall >= NR_syscalls || this_syscall < 0)
+			break;
+
+		if (!seccomp_test_filters(this_syscall))
+			return;
+
+		seccomp_filter_log_failure(this_syscall);
+		break;
+#endif
 	default:
 		BUG();
 	}
@@ -71,16 +85,22 @@ long prctl_set_seccomp(unsigned long seccomp_mode)
 	if (unlikely(current->seccomp.mode))
 		goto out;
 
-	ret = -EINVAL;
-	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
-		current->seccomp.mode = seccomp_mode;
-		set_thread_flag(TIF_SECCOMP);
+	ret = 0;
+	switch (seccomp_mode) {
+	case 1:
 #ifdef TIF_NOTSC
 		disable_TSC();
 #endif
-		ret = 0;
+#ifdef CONFIG_SECCOMP_FILTER
+	case 2:
+#endif
+		current->seccomp.mode = seccomp_mode;
+		set_thread_flag(TIF_SECCOMP);
+		break;
+	default:
+		ret = -EINVAL;
 	}
 
- out:
+out:
 	return ret;
 }
diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
new file mode 100644
index 0000000..16a53e6
--- /dev/null
+++ b/kernel/seccomp_filter.c
@@ -0,0 +1,875 @@
+/* filter engine-based seccomp system call filtering
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
+#include <linux/compat.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/ftrace_event.h>
+#include <linux/seccomp.h>
+#include <linux/seq_file.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/prctl.h>
+
+#include <asm/syscall.h>
+#include <trace/syscall.h>
+
+#define SECCOMP_MAX_FILTER_LENGTH MAX_FILTER_STR_VAL
+
+#define SECCOMP_FILTER_ALLOW "1"
+#define SECCOMP_ACTION_DENY 0xffff
+#define SECCOMP_ACTION_ALLOW 0xfffe
+
+/**
+ * struct seccomp_filters - container for seccomp filters
+ *
+ * @syscalls: array of 16-bit indices into @event_filters by syscall_nr
+ *            May also be SECCOMP_ACTION_DENY or SECCOMP_ACTION_ALLOW
+ * @event_filters: array of pointers to ftrace event filters
+ * @count: size of @event_filters
+ * @flags: anonymous struct to wrap filters-specific flags
+ * @usage: reference count to manage the object lifetime.
+ *         get/put helpers should be used when accessing an instance
+ *         outside of a lifetime-guarded section.  In general, this
+ *         is only needed for handling shared filters across tasks.
+ *
+ * seccomp_filters objects should never be modified after being attached
+ * to a task_struct.
+ */
+struct seccomp_filters {
+	uint16_t syscalls[NR_syscalls];
+	struct event_filter **event_filters;
+	uint16_t count;
+	struct {
+		uint32_t compat:1,
+			 __reserved:31;
+	} flags;
+	atomic_t usage;
+};
+
+/* Handle ftrace symbol non-existence */
+#ifdef CONFIG_FTRACE_SYSCALLS
+#define create_event_filter(_ef_pptr, _event_type, _str) \
+	ftrace_parse_filter(_ef_pptr, _event_type, _str)
+#define get_filter_string(_ef) ftrace_get_filter_string(_ef)
+#define free_event_filter(_f) ftrace_free_filter(_f)
+
+#else
+
+#define create_event_filter(_ef_pptr, _event_type, _str) (-ENOSYS)
+#define get_filter_string(_ef) (NULL)
+#define free_event_filter(_f) do { } while (0)
+#endif
+
+/**
+ * seccomp_filters_new - allocates a new filters object
+ * @count: count to allocate for the event_filters array
+ *
+ * Returns ERR_PTR on error or an allocated object.
+ */
+static struct seccomp_filters *seccomp_filters_new(uint16_t count)
+{
+	struct seccomp_filters *f;
+
+	if (count >= SECCOMP_ACTION_ALLOW)
+		return ERR_PTR(-EINVAL);
+
+	f = kzalloc(sizeof(struct seccomp_filters), GFP_KERNEL);
+	if (!f)
+		return ERR_PTR(-ENOMEM);
+
+	/* Lazy SECCOMP_ACTION_DENY assignment. */
+	memset(f->syscalls, 0xff, sizeof(f->syscalls));
+	atomic_set(&f->usage, 1);
+
+	f->event_filters = NULL;
+	f->count = count;
+	if (!count)
+		return f;
+
+	f->event_filters = kzalloc(count * sizeof(struct event_filter *),
+				   GFP_KERNEL);
+	if (!f->event_filters) {
+		kfree(f);
+		f = ERR_PTR(-ENOMEM);
+	}
+	return f;
+}
+
+/**
+ * seccomp_filters_free - cleans up the filter list and frees the table
+ * @filters: NULL or live object to be completely destructed.
+ */
+static void seccomp_filters_free(struct seccomp_filters *filters)
+{
+	uint16_t count = 0;
+	if (!filters)
+		return;
+	while (count < filters->count) {
+		struct event_filter *f = filters->event_filters[count];
+		free_event_filter(f);
+		count++;
+	}
+	kfree(filters->event_filters);
+	kfree(filters);
+}
+
+static void __put_seccomp_filters(struct seccomp_filters *orig)
+{
+	WARN_ON(atomic_read(&orig->usage));
+	seccomp_filters_free(orig);
+}
+
+#define seccomp_filter_allow(_id) ((_id) == SECCOMP_ACTION_ALLOW)
+#define seccomp_filter_deny(_id) ((_id) == SECCOMP_ACTION_DENY)
+#define seccomp_filter_dynamic(_id) \
+	(!seccomp_filter_allow(_id) && !seccomp_filter_deny(_id))
+static inline uint16_t seccomp_filter_id(const struct seccomp_filters *f,
+					 int syscall_nr)
+{
+	if (!f)
+		return SECCOMP_ACTION_DENY;
+	return f->syscalls[syscall_nr];
+}
+
+static inline struct event_filter *seccomp_dynamic_filter(
+		const struct seccomp_filters *filters, uint16_t id)
+{
+	if (!seccomp_filter_dynamic(id))
+		return NULL;
+	return filters->event_filters[id];
+}
+
+static inline void set_seccomp_filter_id(struct seccomp_filters *filters,
+					 int syscall_nr, uint16_t id)
+{
+	filters->syscalls[syscall_nr] = id;
+}
+
+static inline void set_seccomp_filter(struct seccomp_filters *filters,
+				      int syscall_nr, uint16_t id,
+				      struct event_filter *dynamic_filter)
+{
+	filters->syscalls[syscall_nr] = id;
+	if (seccomp_filter_dynamic(id))
+		filters->event_filters[id] = dynamic_filter;
+}
+
+static struct event_filter *alloc_event_filter(int syscall_nr,
+					       const char *filter_string)
+{
+	struct syscall_metadata *data;
+	struct event_filter *filter = NULL;
+	int err;
+
+	data = syscall_nr_to_meta(syscall_nr);
+	/* Argument-based filtering only works on ftrace-hooked syscalls. */
+	err = -ENOSYS;
+	if (!data)
+		goto fail;
+	err = create_event_filter(&filter,
+				  data->enter_event->event.type,
+				  filter_string);
+	if (err)
+		goto fail;
+
+	return filter;
+fail:
+	kfree(filter);
+	return ERR_PTR(err);
+}
+
+/**
+ * seccomp_filters_copy - copies filters from src to dst.
+ *
+ * @dst: seccomp_filters to populate.
+ * @src: table to read from.
+ * @skip: specifies an entry, by system call, to skip.
+ *
+ * Returns non-zero on failure.
+ * Both the source and the destination should have no simultaneous
+ * writers, and dst should be exclusive to the caller.
+ * If @skip is < 0, it is ignored.
+ */
+static int seccomp_filters_copy(struct seccomp_filters *dst,
+				const struct seccomp_filters *src,
+				int skip)
+{
+	int id = 0, ret = 0, nr;
+	memcpy(&dst->flags, &src->flags, sizeof(src->flags));
+	memcpy(dst->syscalls, src->syscalls, sizeof(dst->syscalls));
+	if (!src->count)
+		goto done;
+	for (nr = 0; nr < NR_syscalls; ++nr) {
+		struct event_filter *filter;
+		const char *str;
+		uint16_t src_id = seccomp_filter_id(src, nr);
+		if (nr == skip) {
+			set_seccomp_filter(dst, nr, SECCOMP_ACTION_DENY,
+					   NULL);
+			continue;
+		}
+		if (!seccomp_filter_dynamic(src_id))
+			continue;
+		if (id >= dst->count) {
+			ret = -EINVAL;
+			goto done;
+		}
+		str = get_filter_string(seccomp_dynamic_filter(src, src_id));
+		filter = alloc_event_filter(nr, str);
+		if (IS_ERR(filter)) {
+			ret = PTR_ERR(filter);
+			goto done;
+		}
+		set_seccomp_filter(dst, nr, id, filter);
+		id++;
+	}
+
+done:
+	return ret;
+}
+
+/**
+ * seccomp_extend_filter - appends more text to a syscall_nr's filter
+ * @filters: unattached filter object to operate on
+ * @syscall_nr: syscall number to update filters for
+ * @filter_string: string to append to the existing filter
+ *
+ * The new string will be &&'d to the original filter string to ensure that it
+ * always matches the existing predicates or less:
+ *   (old_filter) && @filter_string
+ * A new seccomp_filters instance is returned on success and a ERR_PTR on
+ * failure.
+ */
+static int seccomp_extend_filter(struct seccomp_filters *filters,
+				 int syscall_nr, char *filter_string)
+{
+	struct event_filter *filter;
+	uint16_t id = seccomp_filter_id(filters, syscall_nr);
+	char *merged = NULL;
+	int ret = -EINVAL, expected;
+
+	/* No extending with a "1". */
+	if (!strcmp(SECCOMP_FILTER_ALLOW, filter_string))
+		goto out;
+
+	/* ftrace events are not aware of CONFIG_COMPAT system calls and will
+	 * use the incorrect argument metadata if enabled.
+	 */
+	ret = -ENOSYS;
+	if (filters->flags.compat)
+		goto out;
+
+	filter = seccomp_dynamic_filter(filters, id);
+	ret = -ENOENT;
+	if (!filter)
+		goto out;
+
+	merged = kzalloc(SECCOMP_MAX_FILTER_LENGTH + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!merged)
+		goto out;
+
+	/* Encapsulate the filter strings in parentheses to isolate operator
+	 * precedence behavior.
+	 */
+	expected = snprintf(merged, SECCOMP_MAX_FILTER_LENGTH, "(%s) && (%s)",
+			    get_filter_string(filter), filter_string);
+	ret = -E2BIG;
+	if (expected >= SECCOMP_MAX_FILTER_LENGTH || expected < 0)
+		goto out;
+
+	/* Free the old filter */
+	free_event_filter(filter);
+	set_seccomp_filter(filters, syscall_nr, id, NULL);
+
+	/* Replace it */
+	filter = alloc_event_filter(syscall_nr, merged);
+	if (IS_ERR(filter)) {
+		ret = PTR_ERR(filter);
+		goto out;
+	}
+	set_seccomp_filter(filters, syscall_nr, id, filter);
+	ret = 0;
+
+out:
+	kfree(merged);
+	return ret;
+}
+
+/**
+ * seccomp_add_filter - adds a filter for an unfiltered syscall
+ * @filters: filters object to add a filter/action to
+ * @syscall_nr: system call number to add a filter for
+ * @filter_string: the filter string to apply
+ *
+ * Returns 0 on success and non-zero otherwise.
+ */
+static int seccomp_add_filter(struct seccomp_filters *filters, int syscall_nr,
+			      char *filter_string)
+{
+	struct event_filter *filter;
+	int ret = 0;
+
+	if (!strcmp(SECCOMP_FILTER_ALLOW, filter_string)) {
+		set_seccomp_filter(filters, syscall_nr,
+				   SECCOMP_ACTION_ALLOW, NULL);
+		goto out;
+	}
+
+	/* ftrace events are not aware of CONFIG_COMPAT system calls and will
+	 * use the incorrect argument metadata if enabled.
+	 */
+	ret = -ENOSYS;
+	if (filters->flags.compat)
+		goto out;
+
+	ret = 0;
+	filter = alloc_event_filter(syscall_nr, filter_string);
+	if (IS_ERR(filter)) {
+		ret = PTR_ERR(filter);
+		goto out;
+	}
+	/* Always add to the last slot available since additions are
+	 * are only done one at a time.
+	 */
+	set_seccomp_filter(filters, syscall_nr, filters->count - 1, filter);
+out:
+	return ret;
+}
+
+/* Wrap optional ftrace syscall support. Returns 1 on match or 0 otherwise. */
+static int filter_match_current(struct event_filter *event_filter)
+{
+	int err = 0;
+#ifdef CONFIG_FTRACE_SYSCALLS
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
+	err = filter_match_preds(event_filter, syscall_state);
+#endif
+	return err;
+}
+
+static const char *syscall_nr_to_name(int syscall)
+{
+	const char *syscall_name = "unknown";
+	struct syscall_metadata *data = syscall_nr_to_meta(syscall);
+	if (data)
+		syscall_name = data->name;
+	return syscall_name;
+}
+
+/* Encodes translation from sys_enter events to system call numbers.
+ * Returns -ENOSYS when the event doesn't match a system call or if
+ * current is_compat_task().  ftrace has no awareness of CONFIG_COMPAT
+ * yet.
+ */
+static int event_to_syscall_nr(int event_id)
+{
+	int nr, nosys = 1;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		return -ENOSYS;
+#endif
+	for (nr = 0; nr < NR_syscalls; ++nr) {
+		struct syscall_metadata *data = syscall_nr_to_meta(nr);
+		if (!data)
+			continue;
+		nosys = 0;
+		if (data->enter_event->event.type == event_id)
+			return nr;
+	}
+	if (nosys)
+		return -ENOSYS;
+	return -EINVAL;
+}
+
+static void filters_set_compat(struct seccomp_filters *filters)
+{
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		filters->flags.compat = 1;
+#endif
+}
+
+static inline int filters_compat_mismatch(struct seccomp_filters *filters)
+{
+	int ret = 0;
+	if (!filters)
+		return 0;
+#ifdef CONFIG_COMPAT
+	if (!!(is_compat_task()) != filters->flags.compat)
+		ret = 1;
+#endif
+	return ret;
+}
+
+static inline int syscall_is_execve(int syscall)
+{
+	int nr = __NR_execve;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task())
+		nr = __NR_seccomp_execve_32;
+#endif
+	return syscall == nr;
+}
+
+#ifndef KSTK_EIP
+#define KSTK_EIP(x) 0L
+#endif
+
+void seccomp_filter_log_failure(int syscall)
+{
+	pr_info("%s[%d]: system call %d (%s) blocked at 0x%lx\n",
+		current->comm, task_pid_nr(current), syscall,
+		syscall_nr_to_name(syscall), KSTK_EIP(current));
+}
+
+/* put_seccomp_filters - decrements the reference count of @orig and may free. */
+void put_seccomp_filters(struct seccomp_filters *orig)
+{
+	if (!orig)
+		return;
+
+	if (atomic_dec_and_test(&orig->usage))
+		__put_seccomp_filters(orig);
+}
+
+/* get_seccomp_filters - increments the reference count of @orig. */
+struct seccomp_filters *get_seccomp_filters(struct seccomp_filters *orig)
+{
+	int usage;
+	if (!orig)
+		return NULL;
+	usage = atomic_inc_return(&orig->usage);
+	/* Catch the pathological refcount overflow before it happens. */
+	BUG_ON(usage == INT_MAX);
+	return orig;
+}
+
+/**
+ * seccomp_test_filters - tests 'current' against the given syscall
+ * @syscall: number of the system call to test
+ *
+ * Returns 0 on ok and non-zero on error/failure.
+ */
+int seccomp_test_filters(int syscall)
+{
+	uint16_t id;
+	struct event_filter *filter;
+	struct seccomp_filters *filters;
+	int ret = -EACCES;
+
+	mutex_lock(&current->seccomp.filters_guard);
+	/* No reference counting is done. filters_guard should protect the
+	 * lifetime of any existing pointer below.
+	 */
+	filters = current->seccomp.filters;
+	if (!filters)
+		goto out;
+
+	if (filters_compat_mismatch(filters)) {
+		pr_info("%s[%d]: seccomp_filter compat() mismatch.\n",
+			current->comm, task_pid_nr(current));
+		goto out;
+	}
+
+	/* execve is never allowed. */
+	if (syscall_is_execve(syscall))
+		goto out;
+
+	ret = 0;
+	id = seccomp_filter_id(filters, syscall);
+	if (seccomp_filter_allow(id))
+		goto out;
+
+	ret = -EACCES;
+	if (!seccomp_filter_dynamic(id))
+		goto out;
+
+	filter = seccomp_dynamic_filter(filters, id);
+	if (filter && filter_match_current(filter))
+		ret = 0;
+out:
+	mutex_unlock(&current->seccomp.filters_guard);
+	return ret;
+}
+
+/**
+ * seccomp_show_filters - prints the current filter state to a seq_file
+ * @filters: properly get()'d filters object
+ * @m: the prepared seq_file to receive the data
+ *
+ * Returns 0 on a successful write.
+ */
+int seccomp_show_filters(struct seccomp_filters *filters, struct seq_file *m)
+{
+	int syscall;
+	if (!filters)
+		goto out;
+
+	for (syscall = 0; syscall < NR_syscalls; ++syscall) {
+		uint16_t id = seccomp_filter_id(filters, syscall);
+		const char *filter_string = SECCOMP_FILTER_ALLOW;
+		if (seccomp_filter_deny(id))
+			continue;
+		seq_printf(m, "%d (%s): ",
+			      syscall,
+			      syscall_nr_to_name(syscall));
+		if (seccomp_filter_dynamic(id))
+			filter_string = get_filter_string(
+					  seccomp_dynamic_filter(filters, id));
+		seq_printf(m, "%s\n", filter_string);
+	}
+out:
+	return 0;
+}
+EXPORT_SYMBOL_GPL(seccomp_show_filters);
+
+/**
+ * seccomp_get_filter - copies the filter_string into "buf"
+ * @syscall_nr: system call number to look up
+ * @buf: destination buffer
+ * @bufsize: available space in the buffer.
+ *
+ * Context: User context only. This function may sleep on allocation and
+ *          operates on current. current must be attempting a system call
+ *          when this is called.
+ *
+ * Looks up the filter for the given system call number on current.  If found,
+ * the string length of the NUL-terminated buffer is returned and < 0 is
+ * returned on error. The NUL byte is not included in the length.
+ */
+long seccomp_get_filter(int syscall_nr, char *buf, unsigned long bufsize)
+{
+	struct seccomp_filters *filters;
+	struct event_filter *filter;
+	long ret = -EINVAL;
+	uint16_t id;
+
+	if (bufsize > SECCOMP_MAX_FILTER_LENGTH)
+		bufsize = SECCOMP_MAX_FILTER_LENGTH;
+
+	mutex_lock(&current->seccomp.filters_guard);
+	filters = current->seccomp.filters;
+
+	if (!filters)
+		goto out;
+
+	ret = -ENOENT;
+	id = seccomp_filter_id(filters, syscall_nr);
+	if (seccomp_filter_deny(id))
+		goto out;
+
+	if (seccomp_filter_allow(id)) {
+		ret = strlcpy(buf, SECCOMP_FILTER_ALLOW, bufsize);
+		goto copied;
+	}
+
+	filter = seccomp_dynamic_filter(filters, id);
+	if (!filter)
+		goto out;
+	ret = strlcpy(buf, get_filter_string(filter), bufsize);
+
+copied:
+	if (ret >= bufsize) {
+		ret = -ENOSPC;
+		goto out;
+	}
+	/* Zero out any remaining buffer, just in case. */
+	memset(buf + ret, 0, bufsize - ret);
+out:
+	mutex_unlock(&current->seccomp.filters_guard);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(seccomp_get_filter);
+
+/**
+ * seccomp_clear_filter: clears the seccomp filter for a syscall.
+ * @syscall_nr: the system call number to clear filters for.
+ *
+ * Context: User context only. This function may sleep on allocation and
+ *          operates on current. current must be attempting a system call
+ *          when this is called.
+ *
+ * Returns 0 on success.
+ */
+long seccomp_clear_filter(int syscall_nr)
+{
+	struct seccomp_filters *filters = NULL, *orig_filters;
+	uint16_t id;
+	int ret = -EINVAL;
+
+	mutex_lock(&current->seccomp.filters_guard);
+	orig_filters = current->seccomp.filters;
+
+	if (!orig_filters)
+		goto out;
+
+	if (filters_compat_mismatch(orig_filters))
+		goto out;
+
+	id = seccomp_filter_id(orig_filters, syscall_nr);
+	if (seccomp_filter_deny(id))
+		goto out;
+
+	/* Create a new filters object for the task */
+	if (seccomp_filter_dynamic(id))
+		filters = seccomp_filters_new(orig_filters->count - 1);
+	else
+		filters = seccomp_filters_new(orig_filters->count);
+
+	if (IS_ERR(filters)) {
+		ret = PTR_ERR(filters);
+		goto out;
+	}
+
+	/* Copy, but drop the requested entry. */
+	ret = seccomp_filters_copy(filters, orig_filters, syscall_nr);
+	if (ret)
+		goto out;
+	get_seccomp_filters(filters);  /* simplify the out: path */
+
+	current->seccomp.filters = filters;
+	put_seccomp_filters(orig_filters);  /* for the task */
+out:
+	put_seccomp_filters(filters);  /* for the extra get */
+	mutex_unlock(&current->seccomp.filters_guard);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(seccomp_clear_filter);
+
+/**
+ * seccomp_set_filter: - Adds/extends a seccomp filter for a syscall.
+ * @syscall_nr: system call number to apply the filter to.
+ * @filter: ftrace filter string to apply.
+ *
+ * Context: User context only. This function may sleep on allocation and
+ *          operates on current. current must be attempting a system call
+ *          when this is called.
+ *
+ * New filters may be added for system calls when the current task is
+ * not in a secure computing mode (seccomp).  Otherwise, existing filters may
+ * be extended.
+ *
+ * Returns 0 on success or an errno on failure.
+ */
+long seccomp_set_filter(int syscall_nr, char *filter)
+{
+	struct seccomp_filters *filters = NULL, *orig_filters = NULL;
+	uint16_t id;
+	long ret = -EINVAL;
+	uint16_t filters_needed;
+
+	mutex_lock(&current->seccomp.filters_guard);
+	if (!filter)
+		goto out;
+
+	filter = strstrip(filter);
+	/* Disallow empty strings. */
+	if (filter[0] == 0)
+		goto out;
+
+	orig_filters = current->seccomp.filters;
+
+	/* After the first call, compatibility mode is selected permanently. */
+	ret = -EACCES;
+	if (filters_compat_mismatch(orig_filters))
+		goto out;
+
+	filters_needed = orig_filters ? orig_filters->count : 0;
+	id = seccomp_filter_id(orig_filters, syscall_nr);
+	if (seccomp_filter_deny(id)) {
+		/* Don't allow DENYs to be changed when in a seccomp mode */
+		ret = -EACCES;
+		if (current->seccomp.mode)
+			goto out;
+		filters_needed++;
+	}
+
+	filters = seccomp_filters_new(filters_needed);
+	if (IS_ERR(filters)) {
+		ret = PTR_ERR(filters);
+		goto out;
+	}
+
+	filters_set_compat(filters);
+	if (orig_filters) {
+		ret = seccomp_filters_copy(filters, orig_filters, -1);
+		if (ret)
+			goto out;
+	}
+
+	if (seccomp_filter_deny(id))
+		ret = seccomp_add_filter(filters, syscall_nr, filter);
+	else
+		ret = seccomp_extend_filter(filters, syscall_nr, filter);
+	if (ret)
+		goto out;
+	get_seccomp_filters(filters);  /* simplify the error paths */
+
+	current->seccomp.filters = filters;
+	put_seccomp_filters(orig_filters);  /* for the task */
+out:
+	put_seccomp_filters(filters);  /* for get or task, on err */
+	mutex_unlock(&current->seccomp.filters_guard);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(seccomp_set_filter);
+
+long prctl_set_seccomp_filter(unsigned long id_type,
+			      unsigned long id,
+			      char __user *user_filter)
+{
+	int nr;
+	long ret;
+	char *filter = NULL;
+
+	ret = -EINVAL;
+	if (id_type != PR_SECCOMP_FILTER_EVENT &&
+	    id_type != PR_SECCOMP_FILTER_SYSCALL)
+		goto out;
+
+	if (id > (unsigned long) INT_MAX)
+		goto out;
+	nr = (int) id;
+
+	if (id_type == PR_SECCOMP_FILTER_EVENT)
+		nr = event_to_syscall_nr(nr);
+
+	if (nr < 0) {
+		ret = nr;
+		goto out;
+	}
+
+	if (nr >= NR_syscalls)
+		goto out;
+
+	ret = -EFAULT;
+	if (!user_filter)
+		goto out;
+
+	filter = kzalloc(SECCOMP_MAX_FILTER_LENGTH + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!filter)
+		goto out;
+
+	ret = -EFAULT;
+	if (strncpy_from_user(filter, user_filter,
+			      SECCOMP_MAX_FILTER_LENGTH - 1) < 0)
+		goto out;
+
+	ret = seccomp_set_filter(nr, filter);
+
+out:
+	kfree(filter);
+	return ret;
+}
+
+long prctl_clear_seccomp_filter(unsigned long id_type, unsigned long id)
+{
+	int nr = -1;
+	long ret = -EINVAL;
+
+	if (id_type != PR_SECCOMP_FILTER_EVENT &&
+	    id_type != PR_SECCOMP_FILTER_SYSCALL)
+		goto out;
+
+	if (id > (unsigned long) INT_MAX)
+		goto out;
+
+	nr = (int) id;
+	if (id_type == PR_SECCOMP_FILTER_EVENT)
+		nr = event_to_syscall_nr(nr);
+
+	if (nr < 0) {
+		ret = nr;
+		goto out;
+	}
+
+	if (nr >= NR_syscalls)
+		goto out;
+
+	ret = seccomp_clear_filter(nr);
+
+out:
+	return ret;
+}
+
+long prctl_get_seccomp_filter(unsigned long id_type, unsigned long id,
+			      char __user *dst, unsigned long available)
+{
+	unsigned long copied;
+	char *buf = NULL;
+	int nr, ret = -EINVAL;
+
+	if (!available)
+		goto out;
+
+	/* Ignore extra buffer space. */
+	if (available > SECCOMP_MAX_FILTER_LENGTH)
+		available = SECCOMP_MAX_FILTER_LENGTH;
+
+	if (id_type != PR_SECCOMP_FILTER_EVENT &&
+	    id_type != PR_SECCOMP_FILTER_SYSCALL)
+		goto out;
+
+	if (id > (unsigned long) INT_MAX)
+		goto out;
+	nr = (int) id;
+
+	if (id_type == PR_SECCOMP_FILTER_EVENT)
+		nr = event_to_syscall_nr(nr);
+
+	if (nr < 0) {
+		ret = nr;
+		goto out;
+	}
+
+	if (nr >= NR_syscalls)
+		goto out;
+
+	ret = -ENOMEM;
+	buf = kmalloc(available, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	ret = seccomp_get_filter(nr, buf, available);
+	if (ret < 0)
+		goto out;
+
+	/* Include the NUL byte in the copy. */
+	copied = copy_to_user(dst, buf, ret + 1);
+	ret = -ENOSPC;
+	if (copied)
+		goto out;
+	ret = 0;
+out:
+	kfree(buf);
+	return ret;
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..b9f9155 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1704,6 +1704,18 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_SET_SECCOMP:
 			error = prctl_set_seccomp(arg2);
 			break;
+		case PR_SET_SECCOMP_FILTER:
+			error = prctl_set_seccomp_filter(arg2, arg3,
+							 (char __user *) arg4);
+			break;
+		case PR_CLEAR_SECCOMP_FILTER:
+			error = prctl_clear_seccomp_filter(arg2, arg3);
+			break;
+		case PR_GET_SECCOMP_FILTER:
+			error = prctl_get_seccomp_filter(arg2, arg3,
+							 (char __user *) arg4,
+							 arg5);
+			break;
 		case PR_GET_TSC:
 			error = GET_TSC_CTL(arg2);
 			break;
diff --git a/security/Kconfig b/security/Kconfig
index e0f08b5..2f29234 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -2,6 +2,10 @@
 # Security configuration
 #
 
+# Make seccomp filter Kconfig switch below available
+config HAVE_SECCOMP_FILTER
+       bool
+
 menu "Security options"
 
 config KEYS
@@ -82,6 +86,19 @@ config SECURITY_DMESG_RESTRICT
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECCOMP_FILTER
+	bool "Enable seccomp-based system call filtering"
+	select SECCOMP
+	depends on HAVE_SECCOMP_FILTER && EXPERIMENTAL
+	help
+	  This kernel feature expands CONFIG_SECCOMP to allow computing
+	  in environments with reduced kernel access dictated by the
+	  application itself through prctl calls.  If
+	  CONFIG_FTRACE_SYSCALLS is available, then system call
+	  argument-based filtering predicates may be used.
+
+	  See Documentation/prctl/seccomp_filter.txt for more detail.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
-- 
1.7.0.4

