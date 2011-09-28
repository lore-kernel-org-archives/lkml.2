Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1I1AWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:22:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:57269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1I1AWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:22:52 -0400
Date: Wed, 28 Sep 2011 02:22:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
In-Reply-To: <1317158254.26514.55.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1109280211400.2711@ionos>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Steven Rostedt wrote:
> I looked at the task that it tried to migrate, and it happened to be the
> kworker thread! Then I went into kernel/workqueue.c and found this
> nonsense:
> 
> 	if (bind && !on_unbound_cpu)
> 		kthread_bind(worker->task, gcwq->cpu);
> 	else {
> 		worker->task->flags |= PF_THREAD_BOUND;
> 		if (on_unbound_cpu)
> 			worker->flags |= WORKER_UNBOUND;
> 	}
> 
> Nothing but the scheduler and kthread_bind() has the right to set the
> PF_THREAD_BOUND flag. Especially when the thread IS NOT BOUNDED!!!!!!

Yikes, I somehow missed that gem. :(
 
> I don't go around and stick my hand down your pants to play with your
> flags! Don't stick your hand in ours and play with our flags!
> 
> WTF is the workqueue code setting the PF_THREAD_BOUND flag manually?
> Talk about fragile coupling! You just made this flag meaningless. Don't
> do that.

And looking at the hotplug code in that very file is just making me
more nervous about that abuse.

> Sorry but I just wasted two whole days because of this nonsense and I'm
> not particularly happy about it.
>  
> -- Steve
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ec5f472..682a90c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2233,6 +2233,9 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  	if (task_cpu(p) != new_cpu) {
>  		p->se.nr_migrations++;
>  		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
> +		if (WARN_ON(p->flags & PF_THREAD_BOUND))
> +			printk(KERN_WARNING "migrating bounded task %s:%d\n",
> +			       p->comm, p->pid);

That should be a if (WARN(...)) and if triggers we should just refuse
to migrate it. So probably set_task_cpu() is not the proper place for
that. Can we move that check on layer up to avoid it reaching
set_task_cpu() ?

>  	}
>  
>  	__set_task_cpu(p, new_cpu);

And please submit a patch which gets rid of

> 		worker->task->flags |= PF_THREAD_BOUND;

Thanks,

	tglx
