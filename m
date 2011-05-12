Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab1ELDHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:07:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1ELDHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:07:13 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>, Will Drewry <wad@chromium.org>
Subject: [PATCH 4/5] v2 seccomp_filter: add process state reporting
Date: Wed, 11 May 2011 22:04:17 -0500
Message-Id: <1305169457-2485-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1303960136-14298-3-git-send-email-wad@chromium.org>
References: <1303960136-14298-3-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds seccomp_filter status reporting to proc.
/proc/<pid>/seccomp_filter will provide read-only access to the current
filter set.

v2: removed status entry, added seccomp file.
    (requested by kosaki.motohiro@jp.fujitsu.com)
    allowed S_IRUGO reading of entries
    (requested by viro@zeniv.linux.org.uk)
    added flags
    got rid of the seccomp_t type
    dropped seccomp file

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/proc/base.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..f991d1a 100644
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
 
+/*
+ * Print out the current seccomp filter set for the task.
+ */
+#ifdef CONFIG_SECCOMP_FILTER
+int proc_pid_seccomp_filter_show(struct seq_file *m, struct pid_namespace *ns,
+				 struct pid *pid, struct task_struct *task)
+{
+	struct seccomp_state *state;
+
+	rcu_read_lock();
+	state = get_seccomp_state(task->seccomp);
+	rcu_read_unlock();
+	seccomp_show_filters(state, m);
+	put_seccomp_state(state);
+	return 0;
+}
+#endif /* CONFIG_SECCOMP_FILTER */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2838,6 +2857,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
+#ifdef CONFIG_SECCOMP_FILTER
+	ONE("seccomp_filter",     S_IRUGO, proc_pid_seccomp_filter_show),
+#endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
@@ -3180,6 +3202,9 @@ static const struct pid_entry tid_base_stuff[] = {
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

