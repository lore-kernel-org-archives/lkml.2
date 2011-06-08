Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1FHO52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:57:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1FHO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:57:24 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=ZvcZoPE4s-wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2NUIIGWYBPU8f108fU8A:9 a=TQyRH2l8uHT6HoWD9u0A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove unreliable pointer in
 mutex_spin_on_owner()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <BANLkTi=0hmKeg_dj-x4osX3N_b-cKjyqcw@mail.gmail.com>
References: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
	 <20110608125855.GE27245@home.goodmis.org>
	 <BANLkTi=0hmKeg_dj-x4osX3N_b-cKjyqcw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Jun 2011 10:57:16 -0400
Message-ID: <1307545036.9218.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 21:28 +0800, Hillf Danton wrote:

> > We don't want to spin if the owner of the lock sleeps. If it sleeps,
> > then the owner's on_cpu will be zero. That's the point of checking it.
> >
> not understand the point of checking owner->on_cpu, and the code's
> icy beauty blows me down again.

It's better to ask these questions than to send patches. You can send
code changes like below, with a question. But avoid official patches if
you don't understand why the code does what it does. An official patch
(with [PATCH] in subject and a Signed-off-by) states that you basically
know what you are doing, and it will frustrate maintainers if you do
not.

Now, I'll explain the owner->on_cpu.

When a task is running, it's on_cpu (in task_struct) is set to 1. When
it is scheduled away, it is zero. This is important.

A mutex is a lock that a task will schedule out in a sleep state if
there's contention. And the owner will wake up that task when it
releases the lock. This is the basic method of mutexes. But the problem
is, it can be very expensive, especially, if the mutexes are held for a
short period of time.

What happens then, is when there is contention, a process will start to
schedule out, and then be woken up again. But we already went into the
scheduler, and may have even scheduled another task. This can be very
expensive, especially if we flush the TLB in the mean time.

What this code does is to try not to sleep. But we need to very careful
in doing this, because the code that uses the mutex expects that this
may sleep. So, instead of just scheduling away when there's contention,
the task checks if the owner is running on another CPU. If it is, then
there's a good chance that it will soon release the mutex and we can
grab it. Instead of scheduling away, this task now waits and spins,
waiting for the owner to release the mutex. This now acts like the more
efficient (but limited) spin locks.

Because we are now spinning, we must be very careful, as the code that
uses the mutex is not made to handle spinners. The spinning must stop
under certain circumstances. One is, if the task that is spinning should
give up the CPU (which is why we check NEED_RESCEHD for current).

The other time to stop spinning is if the owner of the mutex is no
longer running on the CPU. That is, the owner scheduled away. If the
owner scheduled away, then there's no reason to spin anymore, and it
will be better schedule away the task instead. Why spin? The owner may
not wake up for a long time. No need to wait anymore.

> 
> Please thaw another hard to understand in rt_mutex_setprio(),
> 
> 
> 	if (running)
> 		p->sched_class->set_curr_task(rq);
> 	if (on_rq)
> -		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
> +		enqueue_task(rq, p, oldprio > prio ? ENQUEUE_HEAD : 0);
> 
> 	check_class_changed(rq, p, prev_class, oldprio);
> 

Now this is a confusing part of the kernel. It still confuses me
sometimes :)

The kernel looks at priorities opposite of how userspace does. In the
kernel, task->prio, the lower the number the higher the priority.

Now the above compares the oldprio with the (new) prio. If the oldprio
is less than the new prio, we just lowered our priority. But because we
were originally a high priority task, we go at the head of the queue.
Now if we upped, our priority, we have no right in jumping ahead of
other tasks of that same priority, so we go to the end of the queue.

Got it?

-- Steve


