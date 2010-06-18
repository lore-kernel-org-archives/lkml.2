Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab0FRKVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:21:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:55158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab0FRKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:20:58 -0400
Date: Fri, 18 Jun 2010 10:20:26 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100610230956.GA25921@redhat.com>
References: <20100610230956.GA25921@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: thread_group_cputime: Simplify, document the "alive" check
Message-ID: <tip-bfac7009180901f57f20a73c53c3e57b1ce75a1b@git.kernel.org>
Git-Commit-ID: bfac7009180901f57f20a73c53c3e57b1ce75a1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:20:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfac7009180901f57f20a73c53c3e57b1ce75a1b
Gitweb:     http://git.kernel.org/tip/bfac7009180901f57f20a73c53c3e57b1ce75a1b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 01:09:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:56 +0200

sched: thread_group_cputime: Simplify, document the "alive" check

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100610230956.GA25921@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/posix-cpu-timers.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9829646..bf2a650 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -232,31 +232,24 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 
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
