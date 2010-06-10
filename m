Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab0FJXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930Ab0FJXMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:12:00 -0400
Date: Fri, 11 Jun 2010 01:09:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] thread_group_cputime: simplify, document the "alive"
	check
Message-ID: <20100610230956.GA25921@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_group_cputime() looks as if it is rcu-safe, but in fact this
was wrong until ea6d290c which pins task->signal to task_struct.
It checks ->sighand != NULL under rcu, but this can't help if ->signal
can go away. Fortunately the caller either holds ->siglock, or it is
fastpath_timer_check() which uses current and checks exit_state == 0.

- Since ea6d290c commit tsk->signal is stable, we can read it first
  and avoid the initialization from INIT_CPUTIME.

- Even if tsk->signal is always valid, we still have to check it
  is safe to use next_thread() under rcu_read_lock(). Currently
  the code checks ->sighand != NULL, change it to use pid_alive()
  which is commonly used to ensure the task wasn't unhashed before
  we take rcu_read_lock().

  Add the comment to explain this check.

- Change the main loop to use the while_each_thread() helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/posix-cpu-timers.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- 35-rc2/kernel/posix-cpu-timers.c~4_TG_CPUTIME	2010-06-11 00:47:33.000000000 +0200
+++ 35-rc2/kernel/posix-cpu-timers.c	2010-06-11 01:07:48.000000000 +0200
@@ -232,31 +232,24 @@ static int cpu_clock_sample(const clocki
 
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
-	struct sighand_struct *sighand;
-	struct signal_struct *sig;
+	struct signal_struct *sig = tsk->signal;
 	struct task_struct *t;
 
-	*times = INIT_CPUTIME;
+	times->utime = sig->utime;
+	times->stime = sig->stime;
+	times->sum_exec_runtime = sig->sum_sched_runtime;
 
 	rcu_read_lock();
-	sighand = rcu_dereference(tsk->sighand);
-	if (!sighand)
+	/* make sure we can trust tsk->thread_group list */
+	if (!likely(pid_alive(tsk)))
 		goto out;
 
-	sig = tsk->signal;
-
 	t = tsk;
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
 		times->sum_exec_runtime += t->se.sum_exec_runtime;
-
-		t = next_thread(t);
-	} while (t != tsk);
-
-	times->utime = cputime_add(times->utime, sig->utime);
-	times->stime = cputime_add(times->stime, sig->stime);
-	times->sum_exec_runtime += sig->sum_sched_runtime;
+	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
 }

