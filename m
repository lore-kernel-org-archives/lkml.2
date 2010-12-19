Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0LSJTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab0LSJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:19:35 -0500
Message-ID: <4D0DCE10.7000200@redhat.com>
Date: Sun, 19 Dec 2010 11:19:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com> <1292753156.16367.104.camel@marge.simson.net>
In-Reply-To: <1292753156.16367.104.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 12:05 PM, Mike Galbraith wrote:
> On Sun, 2010-12-19 at 08:21 +0200, Avi Kivity wrote:
> >  On 12/18/2010 09:06 PM, Mike Galbraith wrote:
>
> >  >  Hm, so it needs to be very cheap, and highly repeatable.
> >  >
> >  >  What if: so you're trying to get spinners out of the way right?  You
> >  >  somehow know they're spinning, so instead of trying to boost some task,
> >  >  can you do a directed yield in terms of directing a spinner that you
> >  >  have the right to diddle to yield.  Drop his lag, and resched him.  He's
> >  >  not accomplishing anything anyway.
> >
> >  There are a couple of problems with this approach:
> >
> >  - current yield() is a no-op
>
> That's why you'd drop lag, set to max(se->vruntime, cfs_rq->min_vruntime).

Internal scheduler terminology again, don't follow.

> >  - even if it weren't, the process (containing the spinner and the
> >  lock-holder) would yield as a whole.
>
> I don't get this part.  How does the whole process yield if one thread
> yields?

The process is the sum of its threads.  If a thread yield loses 1 msec 
of runtime due to the yield, the process loses 1 msec due to the yield.  
If the lock is held for, say, 100 usec, it would be better for the 
process to spin rather than yield.

With directed yield the process loses nothing by yielding to one of its 
threads.

> >    If it yielded for exactly the time
> >  needed (until the lock holder releases the lock), it wouldn't matter,
> >  since the spinner isn't accomplishing anything, but we don't know what
> >  the exact time is.  So we want to preserve our entitlement.
>
> And that's the hard part.  If can drop lag, you may hurt yourself, but
> at least only yourself.

We already have a "hurt only yourself" thing.  We sleep for 100 usec 
when we detect spinning.  It's awful.

> >  With a pure yield implementation the process would get less than its
> >  fair share, even discounting spin time, which we'd be happy to donate to
> >  the rest of the system.

We aren't happy to donate it to the rest of the system, since it will 
cause a guest with lots of internal contention to make very little 
forward progress.

> >
> >  >  If the only thing running is virtualization, and nobody else can use the
> >  >  interface being invented, all is fair, but this passing of vruntime
> >  >  around is problematic when innocent bystanders may want to play too.
> >
> >  We definitely want to maintain fairness.  Both with a dedicated virt
> >  host and with a mixed workload.
>
> That makes it difficult to the point of impossible.
>
> You want a specific task to run NOW for good reasons, but any number of
> tasks may want the same godlike power for equally good reasons.

I don't want it to run now.  I want it to run before some other task.  I 
don't care if N other tasks run before both.  So no godlike powers 
needed, simply a courteous "after you".

> You could create a force select which only godly tasks could use that
> didn't try to play games with vruntimes, just let the bugger run, and
> let him also eat the latency hit he'll pay for that extra bit of cpu IFF
> you didn't care about being able to mix loads.
>
> Or, you could just bump his nice level with an automated return to
> previous level on resched.
>
> Any intervention has unavoidable consequences for all comers though.

Since task A is running now, clearly the scheduler thinks it deserves to 
run.  What I want to do is take just enough of the "deserves" part to 
make it not run any more, and move it to task B.

> >  >
> >  >  Yep, so much for accounting.
> >
> >  What's the problem exactly?  What's the difference, system-wide, with
> >  the donor continuing to run for that same entitlement?  Other tasks see
> >  the same thing.
>
> SOME tasks receive gifts from the void.  The difference is the bias.

Isn't fork() a gift from the void?

> >  >  >   >   Where did the entitlement come from if task A running alone on cpu A
> >  >  >   >   tosses some entitlement over the fence to his pal task B on cpu B.. and
> >  >  >   >   keeps on trucking on cpu A?  Where does that leave task C, B's
> >  >  >   >   competition?
> >  >  >
> >  >  >   Eventually C would replace A, since its share will be exhausted.  If C
> >  >  >   is pinned... good question.  How does fairness work with pinned tasks?
> >  >
> >  >  In the case I described, C had it's pocket picked by A.
> >
> >  Would that happen if global fairness was maintained?
>
> What's that? :)

If you run three tasks on a two cpu box, each gets 2/3 of a cpu.


> No task may run until there are enough of you to fill
> the box?

Why is that a consequence of global fairness? three tasks get 100% cpu 
on a 4-cpu box, the fourth cpu idles.  Is that not fair for some reason?

> God help you when somebody else wakes up Mr. Early-bird? ...

What?

> >
> >  I guess random perturbations cause task migrations periodically and
> >  things balance out.  But it seems wierd to have this devotion to
> >  fairness on a single cpu and completely ignore fairness on a macro level.
>
> It doesn't ignore it complete, it just doesn't try to do all the math
> continuously (danger Will Robinson: Peter has scary patches).  Prodding
> it in the right general direction with migrations is cheaper.

Doesn't seem to work from my brief experiment.

-- 
error compiling committee.c: too many arguments to function

