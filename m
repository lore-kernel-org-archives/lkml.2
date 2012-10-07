Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2JGJu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:50:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:1381 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2JGJuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:50:18 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] [RFC] pidns: don't zap processes several times
Date: Sun,  7 Oct 2012 13:49:18 +0400
Message-Id: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a test program. It does clone(CLONE_NEWPID | CLONE_VM) and
sleep(), a new task repeates the same actions. This program creates
4000 tasks. When I tried to kill all this processes, a system was
inaccessible for some minutes.

The system is inaccessible, because each process calls
zap_pid_ns_processes, which tries to kill subprocesses under
tasklist_lock. The most time are required for find_vpid().

I suggest to mark sub-namespaces in zap_pid_ns_processes.
zap_pid_ns_processes for marked pidns doesn't kill tasks,
it only waits them.

I am not sure, that this idea is correct, but it helps.

Maybe we should restrict depth of pidns?
Why can't we enumerate task->children instead of using find_vpid()?

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/pid_namespace.h |    1 +
 kernel/pid_namespace.c        |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 00474b0..28073a0 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -34,6 +34,7 @@ struct pid_namespace {
 	kgid_t pid_gid;
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
+	atomic_t zapped; /* non zero if all process were killed */
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index b051fa6..7db7dcd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -177,21 +177,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * 	  maintain a tasklist for each pid namespace.
 	 *
 	 */
+
+	if (atomic_read(&pid_ns->zapped))
+		goto wait; /* All processes were already killed */
+
 	read_lock(&tasklist_lock);
 	nr = next_pidmap(pid_ns, 1);
 	while (nr > 0) {
 		rcu_read_lock();
 
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
-		if (task && !__fatal_signal_pending(task))
+		if (task && !__fatal_signal_pending(task)) {
+			struct pid_namespace *ns;
+
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
+			ns = task_active_pid_ns(task);
+			if (unlikely(ns->child_reaper == task))
+				atomic_set(&ns->zapped, 1);
+		}
 
 		rcu_read_unlock();
 
 		nr = next_pidmap(pid_ns, nr);
 	}
 	read_unlock(&tasklist_lock);
-
+wait:
 	/* Firstly reap the EXIT_ZOMBIE children we may have. */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
-- 
1.7.1

