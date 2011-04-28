Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1D1DLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:11:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61839 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1D1DLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:11:12 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 4/7] seccomp_filter: add process state reporting
Date: Wed, 27 Apr 2011 22:08:48 -0500
Message-Id: <1303960136-14298-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303960136-14298-1-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds seccomp and seccomp_filter status reporting to proc.
/proc/<pid>/status will include a Seccomp field, and
/proc/<pid>/seccomp_filter will provide read-only access
to the current filter and bitmask set for seccomp_filters.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/proc/array.c |   21 +++++++++++++++++++++
 fs/proc/base.c  |   25 +++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 5e4f776..c35ec60 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -77,6 +77,7 @@
 #include <linux/cpuset.h>
 #include <linux/rcupdate.h>
 #include <linux/delayacct.h>
+#include <linux/seccomp.h>
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
@@ -337,6 +338,19 @@ static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 	seq_putc(m, '\n');
 }
 
+static void task_show_seccomp(struct seq_file *m, struct task_struct *p) {
+#if defined(CONFIG_SECCOMP)
+	int mode;
+	struct seccomp_state* state;
+	rcu_read_lock();
+	state = get_seccomp_state(rcu_dereference(p->seccomp.state));
+	mode = state ? state->mode : 0;
+	rcu_read_unlock();
+	put_seccomp_state(state);
+	seq_printf(m, "Seccomp:\t%d\n", mode);
+#endif
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -354,6 +368,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
+	task_show_seccomp(m, task);
 	return 0;
 }
 
@@ -544,3 +559,9 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 
 	return 0;
 }
+
+int proc_pid_seccomp(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
+{
+	return 0;
+}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..4b6f0c7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/seccomp.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -579,6 +580,24 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
+#ifdef CONFIG_SECCOMP_FILTER
+/*
+ * Print out the current seccomp filter set for the task.
+ */
+int proc_pid_seccomp_filter_show(struct seq_file *m, struct pid_namespace *ns,
+				 struct pid *pid, struct task_struct *task)
+{
+	struct seccomp_state *state;
+
+	rcu_read_lock();
+	state = get_seccomp_state(task->seccomp.state);
+	rcu_read_unlock();
+	seccomp_show_filters(state, m);
+	put_seccomp_state(state);
+	return 0;
+}
+#endif
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2838,6 +2857,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUSR, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
@@ -3180,6 +3202,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUSR, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
-- 
1.7.0.4

