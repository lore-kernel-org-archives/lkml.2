Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1IYURc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:17:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1IYURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:17:31 -0400
Date: Sun, 25 Sep 2011 15:17:23 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110925201723.GA5288@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110920174849.GB22317@redhat.com>
 <20110920185354.GA19629@sergelap>
 <20110921175357.GA25590@redhat.com>
 <20110923163113.GA3820@sergelap>
 <20110923173656.GA5233@redhat.com>
 <20110923212025.GA21330@sergelap>
 <20110924163709.GA6776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110924163709.GA6776@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/23, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 09/23, Serge E. Hallyn wrote:
> > > >
> > > > It looks like I can fix all the
> > > > cases
> > >
> > > except ptrace_signal(). Although we can simply ignore this case, imho.
> >
> > ptrace_signal() calls send_signal() though.
> 
> Confused... I meant the "if (signr != info->si_signo)" case. This is
> simple, and I only meant that this case is not that important.

Yes, that's the case I was talking about.  That then proceeds through
send_signal().

It appears to be the only (user) caller of send_signal() where the
info->si_pid and info->si_uid are not filled in from current.  But I
just realized that it's not a problem for the same reason that it isn't
for the analogous pid code - since the target task is current, the test
for whether current userns != target userns will always return false, so
the code simply won't trigger :)

+	if (si_fromuser(info) && current_user_ns() != task_cred_xxx(t, user_ns)) {
+		rcu_read_lock();
+		if (!map_cred_ns(current_cred(), task_cred_xxx(t, user_ns)))
+			userns_rel = USERNS_ANCESTOR;
+		else
+			userns_rel = USERNS_OTHER;
+		rcu_read_unlock();
+	}

The whole new patch (so far only compile-tested) is below.

> > > > by checking whether si_fromuser(info)
> > >
> > > I am not sure... sys_rt_queueinfo() is nasty. Plus we have to handle
> > > the "fromkernel" case too. May be we can ignore this too.
> >
> > sys_rt_tgsigqueueinfo() still seems to go through send_signal().
> 
> Yes. But how can you fix si_uid? We do not even know if it exists.
> Please look at siginfo/_uid, there is a union. We can't know what
> the caller of sys_rt_sigqueueinfo() puts in this location.

But it's a union alongside the pid.  I don't understand the callers
well enough to say whether there is a bug in the pid handling.  I'll
certainly try to take a wider look next week, but it seems to me
at least this patch should bring the uid namespacing code up to par
with the pid namespacing code for signals.

(patch follows - I'll resend if it passes more strenuous testing)

thanks,
-serge

 From d73866bec4032bed383ba977d11f97d0ae3e9596 Mon Sep 17 00:00:00 2001
 From: Serge Hallyn <serge.hallyn@canonical.com>
 Date: Mon, 19 Sep 2011 18:07:55 +0100
 Subject: [PATCH 1/1] user namespace: make signal.c respect user namespaces (v3)

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
Sep 23: In send_signal(), detect when (user) signal is coming from an
	ancestor or unrelated user namespace.  Pass that on to __send_signal,
	which sets si_uid to 0 or overflowuid if needed.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..d2ee505 100644
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
@@ -37,6 +38,14 @@
 #include <asm/siginfo.h>
 #include "audit.h"	/* audit_signal_info() */
 
+extern int overflowuid;
+/* sender and target have same user namespace */
+#define USERNS_SAME 0
+/* sendor's userns is ancestor of target's */
+#define USERNS_ANCESTOR 1
+/* sendor's userns is child of target's or unrelated to it */
+#define USERNS_OTHER 2
+
 /*
  * SLAB caches for signal bits.
  */
@@ -1019,8 +1028,17 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
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
-			int group, int from_ancestor_ns)
+			int group, int from_ancestor_ns, int userns_rel)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
@@ -1073,7 +1091,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
-			q->info.si_uid = current_uid();
+			q->info.si_uid = map_cred_ns(current_cred(),
+						     task_cred_xxx(t, user_ns));
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1086,6 +1105,16 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			copy_siginfo(&q->info, info);
 			if (from_ancestor_ns)
 				q->info.si_pid = 0;
+			switch (userns_rel) {
+			case USERNS_SAME:
+				break;
+			case USERNS_ANCESTOR:
+				q->info.si_uid = 0;
+				break;
+			default:
+				q->info.si_uid = overflowuid;
+				break;
+			}
 			break;
 		}
 	} else if (!is_si_special(info)) {
@@ -1117,13 +1146,24 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
 {
 	int from_ancestor_ns = 0;
+	int userns_rel = USERNS_SAME;
 
 #ifdef CONFIG_PID_NS
 	from_ancestor_ns = si_fromuser(info) &&
 			   !task_pid_nr_ns(current, task_active_pid_ns(t));
 #endif
+#ifdef CONFIG_USER_NS
+	if (si_fromuser(info) && current_user_ns() != task_cred_xxx(t, user_ns)) {
+		rcu_read_lock();
+		if (!map_cred_ns(current_cred(), task_cred_xxx(t, user_ns)))
+			userns_rel = USERNS_ANCESTOR;
+		else
+			userns_rel = USERNS_OTHER;
+		rcu_read_unlock();
+	}
+#endif
 
-	return __send_signal(sig, info, t, group, from_ancestor_ns);
+	return __send_signal(sig, info, t, group, from_ancestor_ns, userns_rel);
 }
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -1375,7 +1415,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 
 	if (sig) {
 		if (lock_task_sighand(p, &flags)) {
-			ret = __send_signal(sig, info, p, 1, 0);
+			ret = __send_signal(sig, info, p, 1, 0, USERNS_SAME);
 			unlock_task_sighand(p, &flags);
 		} else
 			ret = -ESRCH;
@@ -1618,7 +1658,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+				  task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
@@ -1703,7 +1744,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = map_cred_ns(__task_cred(tsk),
+				  task_cred_xxx(parent, user_ns));
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2121,8 +2163,11 @@ static int ptrace_signal(int signr, siginfo_t *info,
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
1.7.0.4

