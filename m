Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0C2SPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0C2SPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:15:04 -0400
Date: Mon, 29 Mar 2010 20:12:38 +0200
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
Subject: [PATCH -mm 1/4] cputimers: thread_group_cputime: cleanup
	rcu/signal stuff
Message-ID: <20100329181238.GB16356@redhat.com>
References: <20100324204550.GA31777@redhat.com> <20100326035344.GQ3308@balbir.in.ibm.com> <20100326214906.GA18467@redhat.com> <20100329111731.GA4488@dhcp-lab-161.englab.brq.redhat.com> <20100329125415.GA22451@redhat.com> <20100329181204.GA16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329181204.GA16356@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- With the recent changes tsk->signal is stable, we can read it
  first and avoid the initialization from INIT_CPUTIME.

- Even if tsk->signal is always valid, we still have to check it
  is safe to use next_thread() under rcu_read_lock(). Currently
  the code checks ->sighand != NULL, change it to use pid_alive()
  which is commonly used to ensure the task wasn't unhashed before
  we take rcu_read_lock().

- Change the main loop to use the while_each_thread() helper.

This change itself doesn't add the functional changes, currently
it is always called under tasklist/siglock or when we know that
this thread group is already dead (wait, coredump).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/posix-cpu-timers.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- 34-rc1/kernel/posix-cpu-timers.c~cpuacct_1_thread_group_cputime_cleanup_rcu	2010-03-29 18:08:14.000000000 +0200
+++ 34-rc1/kernel/posix-cpu-timers.c	2010-03-29 18:09:15.000000000 +0200
@@ -233,31 +233,24 @@ static int cpu_clock_sample(const clocki
 
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

