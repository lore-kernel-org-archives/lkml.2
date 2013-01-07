Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3AGPEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:04:30 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:50198 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3AGPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:04:28 -0500
Date: Mon, 7 Jan 2013 07:04:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rostedt@goodmis.org, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
Message-ID: <20130107150422.GB3926@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
 <20121126171539.GZ15971@htj.dyndns.org>
 <CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
 <CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
 <20130104150928.GC15633@mtj.dyndns.org>
 <CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Mon, Jan 07, 2013 at 03:28:33PM +0530, Viresh Kumar wrote:
> Firstly the root cause of this patchset.
> 
> Myself and some others in Linaro are working on ARM future cores:
> big.LITTLE systems.
> Here we have few very powerful, high power consuming cores (big,
> currently A15's) and
> few very efficient ones (LITTLE, currently A7's).
> 
> The ultimate goal is to save as much power as possible without compromising
> much with performance. For, that we wanted most of the stuff to run on LITTLE
> cores and some performance-demanding stuff on big Cores. There are
> multiple things
> going around in this direction. Now, we thought A15's or big cores
> shouldn't be used
> for running small tasks like timers/workqueues and hence this patch is
> an attempt
> towards reaching that goal.

I see.  My understanding of big.little is very superficial so there
are very good chances that I'm utterly wrong, but to me it seems like
more of a stop-gap solution than something which will have staying
power in the sense that the complexity doesn't seem to have any
inherent reason other than the failure to make the big ones power
efficient enough while idle or under minor load.

Maybe this isn't specific to big.little and heterogeneous cores will
be the way of future with big.little being just a forefront of the
trend.  And even if that's not the case, it definitely doesn't mean
that we can't accomodate big.little, but, at this point, it does make
me a bit more reluctant to make wholesale changes specifically for
big.little.

> Over that we can do some load balancing of works within multiple alive
> cpus, so that
> it can get done quickly. Also, we shouldn't start using an idle cpu
> just for processing
> work :)

The latter part "not using idle cpu just for processing work" does
apply to homogeneous systems too but as I wrote earlier work items
don't spontaneously happen on an idle core.  Something, including
timer, needs to kick it.  So, by definition, a CPU already isn't idle
when a work item starts execution on it.  What am I missing here?

> I have another idea that we can try:
> 
> queue_work_on_any_cpu().
>
> With this we would not break any existing code and can try to migrate
> old users to
> this new infrastructure (atleast the ones which are rearming works from their
> work_handlers). What do you say?

Yeah, this could be a better solution, I think.  Plus, it's not like
finding the optimal cpu is free.

> To take care of the cache locality issue, we can pass an argument to
> this routine,
> that can provide
> - the mask of cpus to schedule this work on
>   OR
> - Sched Level (SD_LEVEL) of cpus to run it.

Let's start simple for now.  If we really need it, we can always add
more later.

Thanks.

-- 
tejun
