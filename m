Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1KDWYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:24:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:45256 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1KDWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:24:08 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, serge@hallyn.com, dhowells@redhat.com,
        eparis@redhat.com, Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 1/6] user namespace: make signal.c respect user namespaces (v4)
Date: Fri,  4 Nov 2011 22:24:37 +0000
Message-Id: <1320445482-8459-2-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320445482-8459-1-git-send-email-serge@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@canonical.com>

ipc/mqueue.c: for __SI_MESQ, convert the uid being sent to recipient's
user namespace. (new, thanks Oleg)

__send_signal: convert current's uid to the recipient's user namespace
for any siginfo which is not SI_FROMKERNEL (patch from Oleg, thanks
again :)

do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
user namespace

ptrace_signal maps parent's uid into current's user namespace before
including in signal to current.  IIUC Oleg has argued that this shouldn't
matter as the debugger will play with it, but it seems like not converting
the value currently being set is misleading.

Changelog:
Sep 20: Inspired by Oleg's suggestion, define map_cred_ns() helper to
	simplify callers and help make clear what we are translating
        (which uid into which namespace).  Passing the target task would
	make callers even easier to read, but we pass in user_ns because
	current_user_ns() != task_cred_xxx(current, user_ns).
Sep 20: As recommended by Oleg, also put task_pid_vnr() under rcu_read_lock
	in ptrace_signal().
Sep 23: In send_signal(), detect when (user) signal is coming from an
	ancestor or unrelated user namespace.  Pass that on to __send_signal,
	which sets si_uid to 0 or overflowuid if needed.
Oct 12: Base on Oleg's fixup_uid() patch.  On top of that, handle all
	SI_FROMKERNEL cases at callers, because we can't assume sender is
	current in those cases.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 ipc/mqueue.c    |    7 ++++++-
 kernel/signal.c |   38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 2e0ecfc..4dbf3cb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
+#include <linux/user_namespace.h>
 #include <linux/slab.h>
 
 #include <net/sock.h>
@@ -543,9 +544,13 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
+			/* map current pid/uid into info->owner's namespaces */
+			rcu_read_lock();
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = current_uid();
+			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
+						current_cred(), current_uid());
+			rcu_read_lock();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff --git a/kernel/signal.c b/kernel/signal.c
index d252be2..6a6c2f4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -28,6 +28,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/user_namespace.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
@@ -1019,6 +1020,29 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
+/*
+ * map the uid in struct cred into user namespace *ns
+ */
+static inline uid_t map_cred_ns(const struct cred *cred,
+				struct user_namespace *ns)
+{
+	return user_ns_map_uid(ns, cred, cred->uid);
+}
+
+static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
+{
+#ifdef CONFIG_USER_NS
+	if (current_user_ns() == task_cred_xxx(t, user_ns))
+#endif
+		return;
+
+	if (SI_FROMKERNEL(info))
+		return;
+
+	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
+					current_cred(), info->si_uid);
+}
+
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group, int from_ancestor_ns)
 {
@@ -1088,6 +1112,9 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 				q->info.si_pid = 0;
 			break;
 		}
+
+		fixup_uid(info, t);
+
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
 			/*
@@ -1626,7 +1653,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+			task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
@@ -1711,7 +1739,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+			task_cred_xxx(parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2129,8 +2158,11 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
+		rcu_read_lock();
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		info->si_uid = map_cred_ns(__task_cred(current->parent),
+				current_user_ns());
+		rcu_read_unlock();
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
-- 
1.7.0.4

