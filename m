Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab1EYOOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:14:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab1EYOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:14:00 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=2hPWuqIl968A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=fz7pyEXQYRP1zBkFiHcA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTin-feweuE_vm_x1Ex8Yr4ezsJ2wKA@mail.gmail.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	 <1306244836.2497.60.camel@laptop>
	 <BANLkTik6cc+jA3Ft4wOTWPwKhOheUM-VbQ@mail.gmail.com>
	 <1306247058.1465.66.camel@gandalf.stny.rr.com>
	 <BANLkTimynA+wdsEwayzdDZRTPeZHRoDtgg@mail.gmail.com>
	 <1306248401.1465.69.camel@gandalf.stny.rr.com>
	 <BANLkTin-feweuE_vm_x1Ex8Yr4ezsJ2wKA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 10:13:58 -0400
Message-ID: <1306332838.1465.99.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 22:00 +0800, Hillf Danton wrote:

> >
> > Yes, that is the definition of FIFO (First In First Out). The tasks that
> > get to the CPU first run till they voluntarily schedule away, or are
> > preempted by an even high priority task. Tasks of the same priority must
> > wait till the previous task has finished.
> >
> 
> Then I try to fix the violation of FIFO, my thought is like below:
> 
> ---
> Subject: [PATCH] sched: fix the violation of SCHED_FIFO in
> check_preempt_equal_prio()
> 
> Starvation of the same priority tasks is a perfectly valid situation for
> SCHED_FIFO.
> 
> If task p is currently running and is a FIFO task, you do not push it
> off for another task of same prio.
> Yes, that is the definition of FIFO (First In First Out). The tasks that
> get to the CPU first run till they voluntarily schedule away, or are
> preempted by an even high priority task. Tasks of the same priority must
> wait till the previous task has finished.
> 

No, no, no!

I'm sorry if you misunderstood me. When I said 'finished', I did not
mean that it was truly finished and the process has exited. I simply
meant that finished meant that it scheduled away. Done for the time
being.

Thus, if a task is running of one priority, another task of same
priority will *not* preempt it. If that task schedules for whatever
reason, the next task of same priority will then run, and the first one
will now have to wait for it to schedule away. That is FIFO.

Now we do break this semantic a bit for SMP. If the current task that is
running can be migrated to another CPU, and the one that wakes up is of
same priority but is pinned to this CPU. If we can migrate the running
task to another CPU (another CPU has a lower prio process running), then
we will migrate that task to let the woken task run.

But this is not really preempting the running task, it is more "moving"
it. But there's no real guarantees to what RT tasks do on SMP, so we are
fine.

-- Steve
 

