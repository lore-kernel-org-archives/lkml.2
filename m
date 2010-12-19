Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab0LSGVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 01:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0LSGVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 01:21:30 -0500
Message-ID: <4D0DA45A.9070600@redhat.com>
Date: Sun, 19 Dec 2010 08:21:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com> <1292699204.1181.51.camel@marge.simson.net>
In-Reply-To: <1292699204.1181.51.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 09:06 PM, Mike Galbraith wrote:
> >  >  I can see the problem, and I'm not trying to be Mr. Negative here, I'm
> >  >  only trying to point out problems I see with what's been proposed.
> >  >
> >  >  If the yielding task had a concrete fee he could pay, that would be
> >  >  fine, but he does not.
> >
> >  It does.  The yielding task is entitled to its fair share of the cpu, as
> >  modified by priority and group scheduling.  The yielding task is willing
> >  to give up some of this cpu, in return for increasing another task's
> >  share.  Other tasks would not be negatively affected by this.
>
> The donor does absolutely NOT have any claim to any specific quantum of
> any cpu at any given time.  There is no reservation, only a running
> clock.

Of course not, but we aren't interested in a specific quantum of time.  
All we want is to boost task A, and to unboost the donor in order to 
maintain fairness.  We don't want A to run now (though it would be 
nice); all we want is to run it before B.

>   If you let one task move another task's clock backward, you open
> a can of starvation worms.  This is exactly why vruntimes are monotonic.
>
> >  >  If he did have something, how often do you think it should be possible
> >  >  for task X to bribe the scheduler into selecting task Y?
> >
> >  In extreme cases, very often.  Say 100KHz.
>
> Hm, so it needs to be very cheap, and highly repeatable.
>
> What if: so you're trying to get spinners out of the way right?  You
> somehow know they're spinning, so instead of trying to boost some task,
> can you do a directed yield in terms of directing a spinner that you
> have the right to diddle to yield.  Drop his lag, and resched him.  He's
> not accomplishing anything anyway.

There are a couple of problems with this approach:

- current yield() is a no-op
- even if it weren't, the process (containing the spinner and the 
lock-holder) would yield as a whole.  If it yielded for exactly the time 
needed (until the lock holder releases the lock), it wouldn't matter, 
since the spinner isn't accomplishing anything, but we don't know what 
the exact time is.  So we want to preserve our entitlement.

With a pure yield implementation the process would get less than its 
fair share, even discounting spin time, which we'd be happy to donate to 
the rest of the system.

> If the only thing running is virtualization, and nobody else can use the
> interface being invented, all is fair, but this passing of vruntime
> around is problematic when innocent bystanders may want to play too.

We definitely want to maintain fairness.  Both with a dedicated virt 
host and with a mixed workload.

> Forcing a spinning task to parity doesn't have the same problems.

Sorry, parse failure.

> >  >  Will his
> >  >  pockets be deep enough to actually solve the problem?  Once he's
> >  >  yielded, he's out of the picture for a while if he really gave anything
> >  >  up.
> >
> >  Unless the other task donates some cpu share back.  This is exactly what
> >  will happen in those extreme cases.
>
> So vruntime donation won't work.
>
> >  >  What happens to donated entitlement when the recipient goes to
> >  >  sleep?
> >
> >  Nothing.
>
> It's vaporized by the sleep.
>
> >  >  If you try to give it back, what happens if the donor exited?
> >
> >  It's lost, too bad.
>
> Yep, so much for accounting.

What's the problem exactly?  What's the difference, system-wide, with 
the donor continuing to run for that same entitlement?  Other tasks see 
the same thing.

> >  >  Where did the entitlement come from if task A running alone on cpu A
> >  >  tosses some entitlement over the fence to his pal task B on cpu B.. and
> >  >  keeps on trucking on cpu A?  Where does that leave task C, B's
> >  >  competition?
> >
> >  Eventually C would replace A, since its share will be exhausted.  If C
> >  is pinned... good question.  How does fairness work with pinned tasks?
>
> In the case I described, C had it's pocket picked by A.

Would that happen if global fairness was maintained?

> >  >  >   Do I correctly read between the lines that CFS maintains complete
> >  >  >   fairness only on a cpu, but not globally?
> >  >
> >  >  Nothing between the lines about it.  There are N individual engines,
> >  >  coupled via load balancing.
> >
> >  Is this not seen as a major deficiency?
>
> Doesn't seem to be.  That's what SMP-nice was all about.  It's not
> perfect, but seems to work well.

I guess random perturbations cause task migrations periodically and 
things balance out.  But it seems wierd to have this devotion to 
fairness on a single cpu and completely ignore fairness on a macro level.

> >  I can understand intra-cpu scheduling decisions at 300 Hz and inter-cpu
> >  decisions at 10 Hz (or even lower, with some intermediate rate for
> >  intra-socket scheduling).  But this looks like a major deviation from
> >  fairness - instead of 33%/33%/33% you get 50%/25%/25% depending on
> >  random placement.
>
> Yeah, you have to bounce tasks around regularly to make that work out.

That's fine as long as the bounce period is significantly larger than 
the cost of a migration.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

