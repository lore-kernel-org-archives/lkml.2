Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab1IUFA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:00:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1IUFAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:00:55 -0400
Date: Wed, 21 Sep 2011 00:00:47 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: [PATCH] user namespace: make signal.c respect user namespaces (v2)
Message-ID: <20110921050047.GA6691@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920122202.GA26504@redhat.com>
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

Changelog:
Sep 20: Inspired by Oleg's suggestion, define map_cred_ns() helper to
	simplify callers and help make clear what we are translating
        (which uid into which namespace).  Passing the target task would
	make callers even easier to read, but we pass in user_ns because
	current_user_ns() != task_cred_xxx(current, user_ns).
Sep 20: As recommended by Oleg, also put task_pid_vnr() under rcu_read_lock
	in ptrace_signal().

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..466219b 100644
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
@@ -1019,6 +1020,15 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
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
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group, int from_ancestor_ns)
 {
@@ -1073,7 +1083,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
-			q->info.si_uid = current_uid();
+			q->info.si_uid = map_cred_ns(current_cred(),
+						     task_cred_xxx(t, user_ns));
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1618,7 +1629,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+				  task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
@@ -1703,7 +1715,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+				  task_cred_xxx(parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2121,8 +2134,11 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
+		rcu_read_lock();
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		info->si_uid = map_cred_ns(__task_cred(current->parent),
+					   current_user_ns());
+		rcu_read_unlock();
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
-- 
1.7.5.4

