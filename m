Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1FJPlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:41:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43205 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab1FJPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rhz/frqsz3pIr60sZQl+48iUW6IUsUecJsRQEtb9L6f5Cxi4LsBnoFTCqjW3lcaEEZ
         sT2qjVieiPDX3Z0UrzUSPhMf/jRdJz3FgD9JAnWEwFLDfjrlIhJJBjeKHz6V2n6uGfSH
         Xy3K482EjEjzXyyOvX/EXai/Bs7TyeNMgh0xc=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, kees.cook@canonical.com, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, fweisbec@gmail.com,
        tglx@linutronix.de, Will Drewry <wad@chromium.org>
Subject: [PATCH v7 04/13] seccomp_filter: add process state reporting
Date: Fri, 10 Jun 2011 10:40:34 -0500
Message-Id: <1307720434-22689-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307137817-26731-1-git-send-email-wad@chromium.org>
References: <1307137817-26731-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds seccomp and seccomp_filter status reporting to proc.
/proc/<pid>/seccomp_filter provides the current seccomp mode
and the list of allowed or dynamically filtered system calls.

v7: emit seccomp mode directly
v6: -
v5: fix typos when mailing the wrong patch series
v4: move from rcu guard to mutex guard
v3: changed to using filters directly.
v2: removed status entry, added seccomp file.
    (requested by kosaki.motohiro@jp.fujitsu.com)
    allowed S_IRUGO reading of entries
    (requested by viro@zeniv.linux.org.uk)
    added flags
    got rid of the seccomp_t type
    dropped seccomp file

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/proc/base.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..fba2a72 100644
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
@@ -579,6 +580,30 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
+/*
+ * Print out the current seccomp filter set for the task.
+ */
+#ifdef CONFIG_SECCOMP_FILTER
+int proc_pid_seccomp_filter_show(struct seq_file *m, struct pid_namespace *ns,
+				 struct pid *pid, struct task_struct *task)
+{
+	struct seccomp_filters *filters;
+
+	seq_printf(m, "Mode: %d\n", task->seccomp.mode);
+	/* Avoid allowing other processes to incur too much added contention by
+	 * only acquiring a reference under the task-wide mutex.
+	 */
+	if (mutex_lock_killable(&task->seccomp.filters_guard))
+		return -1;
+	filters = get_seccomp_filters(task->seccomp.filters);
+	mutex_unlock(&task->seccomp.filters_guard);
+
+	seccomp_show_filters(filters, m);
+	put_seccomp_filters(filters);
+	return 0;
+}
+#endif /* CONFIG_SECCOMP_FILTER */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2838,6 +2863,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
@@ -3180,6 +3208,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
-- 
1.7.0.4

