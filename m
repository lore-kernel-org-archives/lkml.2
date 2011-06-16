Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1FPDTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:19:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35064 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751615Ab1FPDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:19:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+tWUs7kYutrTc+nTkTDpV317NWnAn7OTCvqoQK4V
	d4M2isEO80VeRb
Subject: Re: [PATCH] sched: select eligible run-queue for RT task
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1308160240.9218.129.camel@gandalf.stny.rr.com>
References: <BANLkTinmZ1tSpbwV7448usb1nshw=FJXXA@mail.gmail.com>
	 <1308160240.9218.129.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 05:19:04 +0200
Message-ID: <1308194344.7492.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 13:50 -0400, Steven Rostedt wrote:
> On Fri, 2011-06-03 at 22:06 +0800, Hillf Danton wrote:
> > When selecting run-queue for a given task, eligible run-queue should be
> > returned by checking the CPU affinity of task.
> > 
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > ---
> >  kernel/sched_rt.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> > index 88725c9..45b3e0a 100644
> > --- a/kernel/sched_rt.c
> > +++ b/kernel/sched_rt.c
> > @@ -1006,7 +1006,8 @@ select_task_rq_rt(struct task_struct *p, int
> > sd_flag, int flags)
> >  	int cpu;
> > 
> >  	if (sd_flag != SD_BALANCE_WAKE)
> > -		return smp_processor_id();
> > +		return cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed) ?
> > +			smp_processor_id() : task_cpu(p);
> 
> I wonder if we should bother even dhoing a test here. Perhaps a better
> solution is just:
> 
> 	if (sd_flag != SD_BALANCE_WAKE)
> 		return task_cpu(p);

Hm.  We shouldn't need to check the mask here for SD_BALANCE_WAKE, since
it will be checked when we return to select_task_rq().

For exec, it doesn't matter which we return, but for a preempted and
migrated parent waking it's child, it could.  task_cpu(parent) seems
better than task_cpu(child), since that is likely where the parent was
preempted, and may still be occupied by a higher priority task.  We'll
subsequently try to push, but we then fiddle with a higher priority rq
needlessly, no?

So to me, it looks like things are better as is.. but we could perhaps
do better by handling SD_BALANCE_FORK here as well, to avoid some 'queue
the child locally (overload) then push it away' overhead.

	-Mike

