Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1AGP3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:29:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1AGP3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:29:49 -0500
Date: Fri, 7 Jan 2011 16:22:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to
	the remote cpu
Message-ID: <20110107152207.GA16341@redhat.com>
References: <20110104145929.772813816@chello.nl> <20110104150103.164045216@chello.nl> <20110105210754.GA2579@redhat.com> <1294326577.2016.373.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294326577.2016.373.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Peter Zijlstra wrote:
>
> On Wed, 2011-01-05 at 22:07 +0100, Oleg Nesterov wrote:
>
> > I'll try to read it once again with the fresh head, though ;)
> > I also have a couple of very minor nits... In particular, perhaps
> > TASK_WAKING can die...
>
> I think it might.. I'll do a patch at the end removing it, lets see what
> happens.

Yes, ttwu can just set TASK_RUNNING. But, otoh, perhaps the
special state makes sense anyway, say, it can help to debug
the problems. We can even have TASK_WAKING_CONTRIBUTES_TO_LOAD
insetad of ->sched_contributes_to_load. But this all is very
minor.

A couple of questions...


Why sched_fork() does set_task_cpu() ? Just curious, it seems
that wake_up_new_task() does all we need.


ttwu_queue_remote() does "struct task_struct *next = NULL".
Probably "next = rq->wake_list" makes more sens. Otherwise the
first cmpxchg() always fails if rq->wake_list != NULL.



Doesn't __migrate_task() need pi_lock? Consider:

1. A task T runs on CPU_0, it does set_current_state(TASK_INTERRUBTIBLE)

2. some CPU does set_cpus_allowed_ptr(T, new_mask), new_mask doesn't
   include CPU_0.

   T is running, cpumask_any_and() picks CPU_1, set_cpus_allowed_ptr()
   drops pi_lock and rq->lock before stop_one_cpu().

3. T calls schedule() and becomes deactivated.

4. CPU_2 does try_to_wake_up(T, TASK_INTERRUPTIBLE), takes pi_lock
   and sees on_rq == F.

5. set_cpus_allowed_ptr() resumes and calls stop_one_cpu(cpu => 1).

6. cpu_stopper_thread() runs on CPU_1 and calls ____migrate_task().
   It locks CPU_0 and CPU_1 rq's and checks task_cpu() == src_cpu.

7. CPU_2 calls select_task_rq(), it returns (to simplify) 2.

   Now try_to_wake_up() does set_task_cpu(T, 2), and calls
   ttwu_queue()->ttwu_do_activate()->activate_task().

8. __migrate_task() on CPU_1 sees p->on_rq and starts the
   deactivate/activate dance racing with ttwu_do_activate()
   on CPU_2.



And a final question. This is really, really minor, but
activate_task/deactivate_task are not symmetric, the former
always sets p->on_rq. Looks correct, but imho a bit confusing and
can complicate the understanding. Since p->on_rq is cleared
explicitly by schedule(), perhaps it can be set explicitly to
in try_to_wake_up_*. Or, perhaps, activate/deactivate can check
ENQUEUE_WAKEUP/DEQUEUE_SLEEP and set/clear p->on_rq. Once again,
this is purely cosmetic issue.

Oleg.

