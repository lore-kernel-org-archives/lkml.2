Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab1FVVLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909Ab1FVVLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:31 -0400
Date: Wed, 22 Jun 2011 23:09:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 4/8] make do_notify_parent() __must_check, update the
	callers
Message-ID: <20110622210909.GE20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change other callers of do_notify_parent() to check the value it
returns, this makes the subsequent task_detached() unnecessary.
Mark do_notify_parent() as __must_check.

Use thread_group_leader() instead of !task_detached() to check
if we need to notify the real parent in wait_task_zombie().

Remove the stale comment in release_task(). "just for sanity" is
no longer true, we have to set EXIT_DEAD to avoid the races with
do_wait().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    2 +-
 kernel/exit.c         |   29 ++++++++---------------------
 2 files changed, 9 insertions(+), 22 deletions(-)

--- ptrace/include/linux/sched.h~4_all_notify_callers	2011-06-22 22:47:11.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-06-22 22:47:12.000000000 +0200
@@ -2161,7 +2161,7 @@ extern int kill_pid_info_as_uid(int, str
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
-extern bool do_notify_parent(struct task_struct *, int);
+extern __must_check bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
--- ptrace/kernel/exit.c~4_all_notify_callers	2011-06-22 22:47:11.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-22 22:47:12.000000000 +0200
@@ -190,21 +190,12 @@ repeat:
 	leader = p->group_leader;
 	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
 		BUG_ON(task_detached(leader));
-		do_notify_parent(leader, leader->exit_signal);
 		/*
 		 * If we were the last child thread and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
 		 * then we are the one who should release the leader.
-		 *
-		 * do_notify_parent() will have marked it self-reaping in
-		 * that case.
-		 */
-		zap_leader = task_detached(leader);
-
-		/*
-		 * This maintains the invariant that release_task()
-		 * only runs on a task in EXIT_DEAD, just for sanity.
 		 */
+		zap_leader = do_notify_parent(leader, leader->exit_signal);
 		if (zap_leader)
 			leader->exit_state = EXIT_DEAD;
 	}
@@ -765,8 +756,7 @@ static void reparent_leader(struct task_
 	/* If it has exited notify the new parent about this child's death. */
 	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
-		do_notify_parent(p, p->exit_signal);
-		if (task_detached(p)) {
+		if (do_notify_parent(p, p->exit_signal)) {
 			p->exit_state = EXIT_DEAD;
 			list_move_tail(&p->sibling, dead);
 		}
@@ -1348,16 +1338,13 @@ static int wait_task_zombie(struct wait_
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
 		/*
-		 * If this is not a detached task, notify the parent.
-		 * If it's still not detached after that, don't release
-		 * it now.
+		 * If this is not a sub-thread, notify the parent.
+		 * If parent wants a zombie, don't release it now.
 		 */
-		if (!task_detached(p)) {
-			do_notify_parent(p, p->exit_signal);
-			if (!task_detached(p)) {
-				p->exit_state = EXIT_ZOMBIE;
-				p = NULL;
-			}
+		if (thread_group_leader(p) &&
+		    !do_notify_parent(p, p->exit_signal)) {
+			p->exit_state = EXIT_ZOMBIE;
+			p = NULL;
 		}
 		write_unlock_irq(&tasklist_lock);
 	}

