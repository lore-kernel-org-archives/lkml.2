Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2EGAfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:35:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50967 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2EGAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:35:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com>
Date: Sun, 06 May 2012 17:35:02 -0700
In-Reply-To: <87havs7rvv.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 06 May 2012 17:32:20 -0700")
Message-ID: <8762c87rrd.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+pizq13Jj0pBNmeWxKGFR8Ufd7QxQnZG8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1751]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: XX
Subject: [PATCH 2/3] pidns: Guarantee that the pidns init will be the last pidns process reaped.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change extends the thread group zombie leader logic to work for pid
namespaces.  The task with pid 1 is declared the pid namespace leader.
A pid namespace with no more processes is detected by observing that the
init task is a zombie in an empty thread group, and the the init task
has no children.

Instead of moving lingering EXIT_DEAD tasks off of init's ->children
list we now block init from exiting until those children have self
reaped and have removed themselves.  Which guarantees that the init task
is the last task in a pid namespace to be reaped.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/exit.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d8bd3b42..7269260 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -164,6 +164,16 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(tsk);
 }
 
+static bool pidns_leader(struct task_struct *tsk)
+{
+	return is_child_reaper(task_pid(tsk));
+}
+
+static bool delay_pidns_leader(struct task_struct *tsk)
+{
+	return pidns_leader(tsk) &&
+	       (!thread_group_empty(tsk) || !list_empty(&tsk->children));
+}
 
 void release_task(struct task_struct * p)
 {
@@ -183,15 +193,23 @@ repeat:
 	__exit_signal(p);
 
 	/*
-	 * If we are the last non-leader member of the thread
-	 * group, and the leader is zombie, then notify the
-	 * group leader's parent process. (if it wants notification.)
+	 * If we are the last non-leader member of the thread group,
+	 * or the last non-leader member of the pid namespace, and the
+	 * leader is zombie, then notify the leader's parent
+	 * process. (if it wants notification.)
 	 */
 	zap_leader = 0;
-	leader = p->group_leader;
-	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
+	leader = NULL;
+	/* Do we need to worry about our thread_group or our pidns leader? */
+	if (p != p->group_leader)
+		leader = p->group_leader;
+	else if (pidns_leader(p->real_parent))
+		leader = p->real_parent;
+
+	if (leader && thread_group_empty(leader) &&
+	    leader->exit_state == EXIT_ZOMBIE && list_empty(&leader->children)) {
 		/*
-		 * If we were the last child thread and the leader has
+		 * If we were the last task in the group and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
 		 * then we are the one who should release the leader.
 		 */
@@ -720,11 +738,10 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
 		/*
-		 * We can not clear ->child_reaper or leave it alone.
-		 * There may by stealth EXIT_DEAD tasks on ->children,
-		 * forget_original_parent() must move them somewhere.
+		 * Move all lingering EXIT_DEAD tasks onto the
+		 * children list of init's thread group leader.
 		 */
-		pid_ns->child_reaper = init_pid_ns.child_reaper;
+		pid_ns->child_reaper = father->group_leader;
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
@@ -798,6 +815,12 @@ static void forget_original_parent(struct task_struct *father)
 	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
+	/* Return immediately if we aren't going to reparent anything */
+	if (unlikely(reaper == father)) {
+		write_unlock_irq(&tasklist_lock);
+		return;
+	}
+		
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		struct task_struct *t = p;
 		do {
@@ -853,6 +876,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		autoreap = do_notify_parent(tsk, sig);
 	} else if (thread_group_leader(tsk)) {
 		autoreap = thread_group_empty(tsk) &&
+			!delay_pidns_leader(tsk) &&
 			do_notify_parent(tsk, tsk->exit_signal);
 	} else {
 		autoreap = true;
@@ -1579,7 +1603,7 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		}
 
 		/* we don't reap group leaders with subthreads */
-		if (!delay_group_leader(p))
+		if (!delay_group_leader(p) && !delay_pidns_leader(p))
 			return wait_task_zombie(wo, p);
 
 		/*
-- 
1.7.5.4

