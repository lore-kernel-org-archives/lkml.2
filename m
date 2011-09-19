Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1ISVpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:45:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1ISVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:45:38 -0400
Date: Mon, 19 Sep 2011 16:45:31 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: richard@nod.at, Andrew Morton <akpm@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com, serge.hallyn@canonical.com
Subject: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110919214531.GA18085@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__send_signal: convert the uid being sent in SI_USER to the target task's
user namespace.

do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
 user namespace

ptrace_signal: map parent's uid into current's user namespace before
including in signal to current.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..bb8ce03 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -27,6 +27,7 @@
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
@@ -1073,7 +1074,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
-			q->info.si_uid = current_uid();
+			q->info.si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
+					current_cred(), current_uid());
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1618,7 +1620,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = user_ns_map_uid(task_cred_xxx(tsk->parent, user_ns),
+				      __task_cred(tsk), __task_cred(tsk)->uid);
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
@@ -1688,6 +1691,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	const struct cred *cred;
 
 	if (for_ptracer) {
 		parent = tsk->parent;
@@ -1703,7 +1707,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	cred = __task_cred(tsk);
+	info.si_uid = user_ns_map_uid(task_cred_xxx(parent, user_ns),
+				cred, cred->uid);
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2118,11 +2124,16 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	 * have updated *info via PTRACE_SETSIGINFO.
 	 */
 	if (signr != info->si_signo) {
+		const struct cred *pcred;
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		rcu_read_lock();
+		pcred = __task_cred(current->parent);
+		info->si_uid = user_ns_map_uid(current_user_ns(),
+			pcred, pcred->uid);
+		rcu_read_unlock();
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
-- 
1.7.5.4

