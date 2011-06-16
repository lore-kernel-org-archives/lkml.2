Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab1FPDva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:51:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1FPDv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:51:29 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=amiImj7KDpwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=DfF1PS-KL5FLeBX5XaoA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: select eligible run-queue for RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1308194344.7492.57.camel@marge.simson.net>
References: <BANLkTinmZ1tSpbwV7448usb1nshw=FJXXA@mail.gmail.com>
	 <1308160240.9218.129.camel@gandalf.stny.rr.com>
	 <1308194344.7492.57.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Jun 2011 23:51:26 -0400
Message-ID: <1308196286.9218.134.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 05:19 +0200, Mike Galbraith wrote:
> On Wed, 2011-06-15 at 13:50 -0400, Steven Rostedt wrote:
> > On Fri, 2011-06-03 at 22:06 +0800, Hillf Danton wrote:
> > > When selecting run-queue for a given task, eligible run-queue should be
> > > returned by checking the CPU affinity of task.
> > > 
> > > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > > ---
> > >  kernel/sched_rt.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > > index 88725c9..45b3e0a 100644
> > > --- a/kernel/sched_rt.c
> > > +++ b/kernel/sched_rt.c
> > > @@ -1006,7 +1006,8 @@ select_task_rq_rt(struct task_struct *p, int
> > > sd_flag, int flags)
> > >  	int cpu;
> > > 
> > >  	if (sd_flag != SD_BALANCE_WAKE)
> > > -		return smp_processor_id();
> > > +		return cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed) ?
> > > +			smp_processor_id() : task_cpu(p);
> > 
> > I wonder if we should bother even dhoing a test here. Perhaps a better
> > solution is just:
> > 
> > 	if (sd_flag != SD_BALANCE_WAKE)
> > 		return task_cpu(p);
> 
> Hm.  We shouldn't need to check the mask here for SD_BALANCE_WAKE, since
> it will be checked when we return to select_task_rq().

How does that matter if it will be checked in select_task_rq(). The
point is that we want to avoid this work when not needed. But that's
more for exec.

> 
> For exec, it doesn't matter which we return, but for a preempted and
> migrated parent waking it's child, it could.  task_cpu(parent) seems
> better than task_cpu(child), since that is likely where the parent was
> preempted, and may still be occupied by a higher priority task.  We'll
> subsequently try to push, but we then fiddle with a higher priority rq
> needlessly, no?

I'm a bit confused by what you mean here. Actually, I have a patch to
have it do the same work for both WAKE and FORK. The reason is that we
will do this work in wake_up_new regardless. The question is when? If we
do it now, we push the task before it has been queued. If we do it later
(as it is done now), if we push the task, we have to first dequeue it,
because it has already been queued.

commit 318e0893ce3f524ca045f9fd9dfd567c0a6f9446 explains this nicely ;)


> 
> So to me, it looks like things are better as is.. but we could perhaps
> do better by handling SD_BALANCE_FORK here as well, to avoid some 'queue
> the child locally (overload) then push it away' overhead.

Maybe you just said what I said, but I'm still confused by what you
said. It's late for me, and I think it's time for bed ;)

Night!

-- Steve


