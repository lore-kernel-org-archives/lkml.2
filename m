Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0LSKSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 05:18:06 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59939 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752360Ab0LSKSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 05:18:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX184dIgrTPQ4KMzP4CVoirm/Vx4Z2wwERMt+yGHHqR
	Bktc+Ed33MQRTh
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0DCE10.7000200@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 12:18:00 +0100
Message-ID: <1292757480.16367.168.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 11:19 +0200, Avi Kivity wrote:
> On 12/19/2010 12:05 PM, Mike Galbraith wrote:

> > That's why you'd drop lag, set to max(se->vruntime, cfs_rq->min_vruntime).
> 
> Internal scheduler terminology again, don't follow.

(distance to the fair stick, worthiness to receive cpu)

> > >  - even if it weren't, the process (containing the spinner and the
> > >  lock-holder) would yield as a whole.
> >
> > I don't get this part.  How does the whole process yield if one thread
> > yields?
> 
> The process is the sum of its threads.  If a thread yield loses 1 msec 
> of runtime due to the yield, the process loses 1 msec due to the yield.  
> If the lock is held for, say, 100 usec, it would be better for the 
> process to spin rather than yield.
> 
> With directed yield the process loses nothing by yielding to one of its 
> threads.
> 
> > >    If it yielded for exactly the time
> > >  needed (until the lock holder releases the lock), it wouldn't matter,
> > >  since the spinner isn't accomplishing anything, but we don't know what
> > >  the exact time is.  So we want to preserve our entitlement.
> >
> > And that's the hard part.  If can drop lag, you may hurt yourself, but
> > at least only yourself.
> 
> We already have a "hurt only yourself" thing.  We sleep for 100 usec 
> when we detect spinning.  It's awful.

Wondered about that, awful makes sense.

> > You want a specific task to run NOW for good reasons, but any number of
> > tasks may want the same godlike power for equally good reasons.
> 
> I don't want it to run now.  I want it to run before some other task.  I 
> don't care if N other tasks run before both.  So no godlike powers 
> needed, simply a courteous "after you".

If behaviors are very similar, and tasks are not likely to try to
exploit it (as described), you can likely swap lags without horrible
consequences.

I'm just pointing out the dangers.

> > >  What's the problem exactly?  What's the difference, system-wide, with
> > >  the donor continuing to run for that same entitlement?  Other tasks see
> > >  the same thing.
> >
> > SOME tasks receive gifts from the void.  The difference is the bias.
> 
> Isn't fork() a gift from the void?

>From process perspective, yup.  It can't stop time though.

> > >  >  >   >   Where did the entitlement come from if task A running alone on cpu A
> > >  >  >   >   tosses some entitlement over the fence to his pal task B on cpu B.. and
> > >  >  >   >   keeps on trucking on cpu A?  Where does that leave task C, B's
> > >  >  >   >   competition?
> > >  >  >
> > >  >  >   Eventually C would replace A, since its share will be exhausted.  If C
> > >  >  >   is pinned... good question.  How does fairness work with pinned tasks?
> > >  >
> > >  >  In the case I described, C had it's pocket picked by A.
> > >
> > >  Would that happen if global fairness was maintained?
> >
> > What's that? :)
> 
> If you run three tasks on a two cpu box, each gets 2/3 of a cpu.
> 
> 
> > No task may run until there are enough of you to fill
> > the box?
> 
> Why is that a consequence of global fairness? three tasks get 100% cpu 
> on a 4-cpu box, the fourth cpu idles.  Is that not fair for some reason?

Depends on fair reference frame, but..

> > God help you when somebody else wakes up Mr. Early-bird? ...
> 
> What?

..I was just trying to say that "global fairness" is not well defined.

Never mind.

	-Mike

