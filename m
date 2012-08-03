Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2HCUjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:39:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48517 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2HCUjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:39:52 -0400
Message-ID: <1344026355.27828.10.camel@twins>
Subject: Re: [patch] sched: fix migration thread runtime bogosity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Aug 2012 22:39:15 +0200
In-Reply-To: <1344001354.17084.28.camel@marge.simpson.net>
References: <1344001354.17084.28.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 15:42 +0200, Mike Galbraith wrote:
> Greetings,
> 
> I have two bug reports of absurd migration thread CPU usage, one of them
> with a link to a bisection..
> 
>      https://bugs.gentoo.org/show_bug.cgi?id=394487
> 
> ..fingering d670ec13 - posix-cpu-timers: Cure SMP wobbles
> 
> I reproduced with my -rt kernel and 3.4, but didn't manage to reproduce
> with the 3.0 NOPREEMPT kernel it was reported against.

Ah, I've seen similar reports, never managed to reproduce though.


> Signed-off-by: Mike Galbraith <efault@gmx.de>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 82ad284..82a78a6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -974,6 +974,13 @@ void sched_set_stop_task(int cpu, struct task_struct *stop)
>  		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
>  
>  		stop->sched_class = &stop_sched_class;
> +
> +		/* Zero stale values for our non-accountable thread. */
> +		stop->se.exec_start = 0;
> +		stop->se.sum_exec_runtime = 0;
> +		stop->se.prev_sum_exec_runtime = 0;
> +		stop->stime = stop->stimescaled = 0;
> +		stop->nvcsw = stop->nivcsw = 0;
>  	}
>  
>  	cpu_rq(cpu)->stop = stop;


Now the question is, how did that stop thing get any time to begin with?
Are we hotplugging or somesuch sillyness?


Anyway, I think I like B best, could you re-submit as a proper patch so
I can press the magic button that queues stuff?


