Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0CYQE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0CYQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:04:55 -0400
Date: Thu, 25 Mar 2010 17:02:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
Message-ID: <20100325160243.GA11517@redhat.com>
References: <20100315090958.GA9116@redhat.com> <1269452296.5109.508.camel@twins> <20100324180912.GA21774@redhat.com> <1269512531.12097.67.camel@laptop> <20100325154616.GA9773@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325154616.GA9773@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Oleg Nesterov wrote:
>
> I like the current idea to call select_task_rq() without rq->lock, but
> of course this is up to you.
>
> However, once again, can't we make a simpler patch?
>
> 	- remove PF_STARTING from task_waking()
> 	
> 	- change sched_fork() to set RUNNING instead of WAKING
>
> 	- change wake_up_new_task() to set WAKING under rq->lock
>
> This looks simpler to me, and allows to drop rq->lock in ttwu() right
> after it sets WAKING.

IOW, something like the (unchecked, uncompiled) patch below.

What do you think?

Oleg.

--- x/kernel/sched.c
+++ x/kernel/sched.c
@@ -912,7 +912,7 @@ static inline void finish_lock_switch(st
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+	return unlikely(p->state == TASK_WAKING);
 }
 
 /*
@@ -2568,11 +2568,10 @@ void sched_fork(struct task_struct *p, i
 
 	__sched_fork(p);
 	/*
-	 * We mark the process as waking here. This guarantees that
-	 * nobody will actually run it, and a signal or other external
-	 * event cannot wake it up and insert it on the runqueue either.
+	 * We mark the process as running here. This guarantees that
+	 * nobody will actually wake it up until wake_up_new_task().
 	 */
-	p->state = TASK_WAKING;
+	p->state = TASK_RUNNING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2638,15 +2637,18 @@ void wake_up_new_task(struct task_struct
 	struct rq *rq;
 	int cpu = get_cpu();
 
+	p->state = TASK_WAKING;
+	smp_mb();
+	raw_spin_unlock_wait(&rq->lock);
+
 #ifdef CONFIG_SMP
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
 	 *
-	 * We still have TASK_WAKING but PF_STARTING is gone now, meaning
-	 * ->cpus_allowed is stable, we have preemption disabled, meaning
-	 * cpu_online_mask is stable.
+	 * TASK_WAKING means ->cpus_allowed is stable, we have preemption
+	 * disabled, meaning cpu_online_mask is stable.
 	 */
 	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);

