Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab1FXAlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:41:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab1FXAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GMgd9W/Ji/EN1YWgSrAqnFtFHkOFKI4GksA/vKIHNP+oRBZQUL1a3VwsHR4TD1PmBZ
         RZgCmzt+IiWnyTo4t0G6rXnGR4T3dd3CK5dCgfvjqxH5t8sA0ssDC/On6UM17Z3O5wh4
         Hjpi1QaZL/fd8sZaWQubkwPovRYWTgLY0ln+c=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v9 04/13] seccomp_filter: add process state reporting
Date: Thu, 23 Jun 2011 19:36:43 -0500
Message-Id: <1308875813-20122-4-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1308875813-20122-1-git-send-email-wad@chromium.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds seccomp and seccomp_filter status reporting to proc.
/proc/<pid>/seccomp_filter provides the current seccomp mode
and the list of allowed or dynamically filtered system calls.

v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf
v8: -
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
index 8a84210..52e1314 100644
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
@@ -582,6 +583,30 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
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
@@ -2785,6 +2810,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
@@ -3131,6 +3159,9 @@ static const struct pid_entry tid_base_stuff[] = {
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

