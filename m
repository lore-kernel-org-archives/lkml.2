Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0C2SQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0C2SQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:16:05 -0400
Date: Mon, 29 Mar 2010 20:13:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/4] cputimers: make sure thread_group_cputime() can't
	count the same thread twice lockless
Message-ID: <20100329181329.GC16356@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com> <20100329181204.GA16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329181204.GA16356@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change __exit_signal() to do __unhash_process() before we accumulate
  the counters in ->signal

- add a couple of barriers into thread_group_cputime() and __exit_signal()
  to make sure thread_group_cputime() can never account the same thread
  twice if it races with exit.

  If any thread T was already accounted in ->signal, next_thread() or
  pid_alive() must see the result of __unhash_process(T).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c             |   14 +++++++++-----
 kernel/posix-cpu-timers.c |    6 ++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

--- 34-rc1/kernel/exit.c~cpuacct_2_thread_group_cputime_rcu_safe	2010-03-29 18:03:17.000000000 +0200
+++ 34-rc1/kernel/exit.c	2010-03-29 18:29:35.000000000 +0200
@@ -88,6 +88,8 @@ static void __exit_signal(struct task_st
 					rcu_read_lock_held() ||
 					lockdep_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
+	__unhash_process(tsk, group_dead);
+	sig->nr_threads--;
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
@@ -111,9 +113,14 @@ static void __exit_signal(struct task_st
 		 * The group leader stays around as a zombie as long
 		 * as there are other threads.  When it gets reaped,
 		 * the exit.c code will add its counts into these totals.
-		 * We won't ever get here for the group leader, since it
-		 * will have been the last reference on the signal_struct.
+		 *
+		 * Make sure that this thread can't be accounted twice
+		 * by thread_group_cputime() under rcu. If it sees the
+		 * the result of accounting below it must see the result
+		 * of __unhash_process()->__list_del(thread_group) above.
 		 */
+		smp_wmb();
+
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
 		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
@@ -127,9 +134,6 @@ static void __exit_signal(struct task_st
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
-	sig->nr_threads--;
-	__unhash_process(tsk, group_dead);
-
 	/*
 	 * Do this under ->siglock, we can race with another thread
 	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
--- 34-rc1/kernel/posix-cpu-timers.c~cpuacct_2_thread_group_cputime_rcu_safe	2010-03-29 18:09:15.000000000 +0200
+++ 34-rc1/kernel/posix-cpu-timers.c	2010-03-29 18:29:35.000000000 +0200
@@ -239,6 +239,12 @@ void thread_group_cputime(struct task_st
 	times->utime = sig->utime;
 	times->stime = sig->stime;
 	times->sum_exec_runtime = sig->sum_sched_runtime;
+	/*
+	 * This pairs with wmb() in __exit_signal(). If any thread was
+	 * already accounted in tsk->signal, while_each_thread() must
+	 * not see it.
+	 */
+	smp_rmb();
 
 	rcu_read_lock();
 	/* make sure we can trust tsk->thread_group list */

