Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2BQSIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:08:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab2BQSIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:08:11 -0500
Date: Fri, 17 Feb 2012 19:00:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, rientjes@google.com,
        rusty@rustcorp.com.au, tj@kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 1/1] hung_task: fix the broken rcu_lock_break() logic
Message-ID: <20120217180040.GB8762@redhat.com>
References: <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com> <20120216173233.GF30393@redhat.com> <201202172211.CGH81726.OStOJFLFHQVMFO@I-love.SAKURA.ne.jp> <20120217150726.GD22440@redhat.com> <20120217180011.GA8762@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217180011.GA8762@redhat.com>
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

Change this code to check pid_alive() instead, and do this before
we drop the reference to the task_struct.

Note: while_each_thread() under rcu_read_lock() is not really safe,
it can livelock. This will be fixed later, but fortunately in this
case the "max_count" logic saves us anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Mandeep Singh Baines <msb@google.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/hung_task.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 2e48ec0..c21449f 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -119,15 +119,20 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
  * to exit the grace period. For classic RCU, a reschedule is required.
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
@@ -154,9 +159,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
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
-- 
1.5.5.1


