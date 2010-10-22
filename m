Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0JVOOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab0JVOOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:14:33 -0400
Date: Fri, 22 Oct 2010 10:13:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, tj@kernel.org
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101022141349.GA6498@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <1287659656.16971.573.camel@gandalf.stny.rr.com> <20101021112614.GB26984@elte.hu> <20101022014441.GA1948@redhat.com> <1287735271.15336.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287735271.15336.18.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 10:14:31AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 21:44 -0400, Jason Baron wrote:
> 
> > I finally found that we actually continue to run after the above
> > apparent 'hang'. That is, we continue to make progress updating the jump
> > labels. And doing a dump of all the system tasks at the time of the hang
> > showed the processes in various places besides the stop machine threads.
> > Thus, I thought that perhaps, for some reason the stop machine threads
> > weren't being scheduled.
> > 
> > Thus, I tried commenting out the special scheduling that is set up for
> > stop machine threads, and that fixed the hang. I haven't yet looked into
> > what might be going wrong with that scheduling...but maybe somebody else
> > knows...
> 
> Hrmm, so are you saying rq->stop was runnable but not running?

yes, that's what it seems like.

> 
> That would imply broken wakeup-preemption, does something like the below
> cure that?
> 
> 

no still seeing the same hang with the below patch...also, as a data point I
backed out the patch that adds the stop_sched_class and that resolved the hang
as well - just as a data point.

thanks,

-Jason

> ---
>  kernel/sched_stoptask.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
> index 45bddc0..50ad10f 100644
> --- a/kernel/sched_stoptask.c
> +++ b/kernel/sched_stoptask.c
> @@ -35,6 +35,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
>  static void
>  enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
>  {
> +	resched_cpu(cpu_of(rq));
>  }
>  
>  static void
> 
> 
