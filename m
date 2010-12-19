Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0LSJGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:06:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751343Ab0LSJGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:06:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tqQNMggxt3U8KxVUcCEhPftrwjRQDNyDouIE1Qx
	cDS4KUTTX1Y1x0
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0DA45A.9070600@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 11:05:56 +0100
Message-ID: <1292753156.16367.104.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 08:21 +0200, Avi Kivity wrote:
> On 12/18/2010 09:06 PM, Mike Galbraith wrote:

> > Hm, so it needs to be very cheap, and highly repeatable.
> >
> > What if: so you're trying to get spinners out of the way right?  You
> > somehow know they're spinning, so instead of trying to boost some task,
> > can you do a directed yield in terms of directing a spinner that you
> > have the right to diddle to yield.  Drop his lag, and resched him.  He's
> > not accomplishing anything anyway.
> 
> There are a couple of problems with this approach:
> 
> - current yield() is a no-op

That's why you'd drop lag, set to max(se->vruntime, cfs_rq->min_vruntime).

> - even if it weren't, the process (containing the spinner and the 
> lock-holder) would yield as a whole.

I don't get this part.  How does the whole process yield if one thread
yields?

>   If it yielded for exactly the time 
> needed (until the lock holder releases the lock), it wouldn't matter, 
> since the spinner isn't accomplishing anything, but we don't know what 
> the exact time is.  So we want to preserve our entitlement.

And that's the hard part.  If can drop lag, you may hurt yourself, but
at least only yourself.

> With a pure yield implementation the process would get less than its 
> fair share, even discounting spin time, which we'd be happy to donate to 
> the rest of the system.
> 
> > If the only thing running is virtualization, and nobody else can use the
> > interface being invented, all is fair, but this passing of vruntime
> > around is problematic when innocent bystanders may want to play too.
> 
> We definitely want to maintain fairness.  Both with a dedicated virt 
> host and with a mixed workload.

That makes it difficult to the point of impossible.

You want a specific task to run NOW for good reasons, but any number of
tasks may want the same godlike power for equally good reasons.

You could create a force select which only godly tasks could use that
didn't try to play games with vruntimes, just let the bugger run, and
let him also eat the latency hit he'll pay for that extra bit of cpu IFF
you didn't care about being able to mix loads.

Or, you could just bump his nice level with an automated return to
previous level on resched.

Any intervention has unavoidable consequences for all comers though.

> > Forcing a spinning task to parity doesn't have the same problems.
> 
> Sorry, parse failure.

(dropping lag on the floor)

> > >  >  Will his
> > >  >  pockets be deep enough to actually solve the problem?  Once he's
> > >  >  yielded, he's out of the picture for a while if he really gave anything
> > >  >  up.
> > >
> > >  Unless the other task donates some cpu share back.  This is exactly what
> > >  will happen in those extreme cases.
> >
> > So vruntime donation won't work.
> >
> > >  >  What happens to donated entitlement when the recipient goes to
> > >  >  sleep?
> > >
> > >  Nothing.
> >
> > It's vaporized by the sleep.
> >
> > >  >  If you try to give it back, what happens if the donor exited?
> > >
> > >  It's lost, too bad.
> >
> > Yep, so much for accounting.
> 
> What's the problem exactly?  What's the difference, system-wide, with 
> the donor continuing to run for that same entitlement?  Other tasks see 
> the same thing.

SOME tasks receive gifts from the void.  The difference is the bias.

> > >  >  Where did the entitlement come from if task A running alone on cpu A
> > >  >  tosses some entitlement over the fence to his pal task B on cpu B.. and
> > >  >  keeps on trucking on cpu A?  Where does that leave task C, B's
> > >  >  competition?
> > >
> > >  Eventually C would replace A, since its share will be exhausted.  If C
> > >  is pinned... good question.  How does fairness work with pinned tasks?
> >
> > In the case I described, C had it's pocket picked by A.
> 
> Would that happen if global fairness was maintained?

What's that? :)  No task may run until there are enough of you to fill
the box?  God help you when somebody else wakes up Mr. Early-bird? ...

> > >  >  >   Do I correctly read between the lines that CFS maintains complete
> > >  >  >   fairness only on a cpu, but not globally?
> > >  >
> > >  >  Nothing between the lines about it.  There are N individual engines,
> > >  >  coupled via load balancing.
> > >
> > >  Is this not seen as a major deficiency?
> >
> > Doesn't seem to be.  That's what SMP-nice was all about.  It's not
> > perfect, but seems to work well.
> 
> I guess random perturbations cause task migrations periodically and 
> things balance out.  But it seems wierd to have this devotion to 
> fairness on a single cpu and completely ignore fairness on a macro level.

It doesn't ignore it complete, it just doesn't try to do all the math
continuously (danger Will Robinson: Peter has scary patches).  Prodding
it in the right general direction with migrations is cheaper.

	-Mike

