Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0FRTEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab0FRTEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:04:47 -0400
Date: Fri, 18 Jun 2010 21:02:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH] fix the racy
	check_hung_uninterruptible_tasks()->rcu_lock_break() logic
Message-ID: <20100618190251.GA17297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
"softlockup: check all tasks in hung_task" commit ce9dbe24 looks
absolutely wrong.

	- rcu_lock_break() does put_task_struct(). If the task has exited
	  it is not safe to even read its ->state, nothing protects this
	  task_struct.

	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
	  can't use it to check if the task was unhashed. It can be unhashed
	  without TASK_DEAD, or it can be valid with TASK_DEAD.

	  For example, an autoreaping task can do release_task(current)
	  long before it sets TASK_DEAD in do_exit().

	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
	  was not called, and in this case we must not break the loop.

Change this code to check pid_alive() instead, and do this before we
drop the reference to the task_struct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/hung_task.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- 35-rc2/kernel/hung_task.c~CHT_FIX_RCU_LOCK_BREAK	2009-12-18 19:05:38.000000000 +0100
+++ 35-rc2/kernel/hung_task.c	2010-06-18 20:06:11.000000000 +0200
@@ -113,15 +113,20 @@ static void check_hung_task(struct task_
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
  * exit the grace period. For classic RCU, a reschedule is required.
  */
-static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
+static bool rcu_lock_break(struct task_struct *g, struct task_struct *t)
 {
+	bool can_cont;
+
 	get_task_struct(g);
 	get_task_struct(t);
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
+	can_cont = pid_alive(g) && pid_alive(t);
 	put_task_struct(t);
 	put_task_struct(g);
+
+	return can_cont;
 }
 
 /*
@@ -148,9 +153,7 @@ static void check_hung_uninterruptible_t
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;
-			rcu_lock_break(g, t);
-			/* Exit if t or g was unhashed during refresh. */
-			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+			if (!rcu_lock_break(g, t))
 				goto unlock;
 		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */

