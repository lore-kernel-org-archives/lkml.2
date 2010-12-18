Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0LRSGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:06:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757141Ab0LRSGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:06:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19XHUwCWJFXWYyZx9teUvoR9aOQRX0h4oIKyHHVk1
	NYC4hCU0IQOZar
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0CE937.8090601@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 20:06:44 +0100
Message-ID: <1292699204.1181.51.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 19:02 +0200, Avi Kivity wrote:
> On 12/17/2010 09:51 PM, Mike Galbraith wrote:
> > On Fri, 2010-12-17 at 17:09 +0200, Avi Kivity wrote:
> > >  On 12/17/2010 08:56 AM, Mike Galbraith wrote:
> > >  >  >   Surely that makes it a reasonable idea to call yield, and
> > >  >  >   get one of the other tasks on the current CPU running for
> > >  >  >   a bit?
> > >  >
> > >  >  There's nothing wrong with trying to give up the cpu.  It's the concept
> > >  >  of a cross cpu yield_to() that I find mighty strange.
> > >
> > >  What's so strange about it?  From a high level there are N runnable
> > >  tasks contending for M cpus.  If task X really needs task Y to run, what
> > >  does it matter if task Y last ran on the same cpu as task X or not?
> >
> > Task X wants control of when runnable task Y gets the cpu.  Task X
> > clearly wants to be the scheduler.  This isn't about _yielding_ diddly
> > spit, it's about individual tasks wanting to make scheduling decisions,
> > so calling it a yield is high grade horse-pookey.  You're trying to give
> > the scheduler a hint, the stronger that hint, the happier you'll be.
> 
> Please suggest a better name then.

Don't have one handy.

> > I can see the problem, and I'm not trying to be Mr. Negative here, I'm
> > only trying to point out problems I see with what's been proposed.
> >
> > If the yielding task had a concrete fee he could pay, that would be
> > fine, but he does not.
> 
> It does.  The yielding task is entitled to its fair share of the cpu, as 
> modified by priority and group scheduling.  The yielding task is willing 
> to give up some of this cpu, in return for increasing another task's 
> share.  Other tasks would not be negatively affected by this.

The donor does absolutely NOT have any claim to any specific quantum of
any cpu at any given time.  There is no reservation, only a running
clock.  If you let one task move another task's clock backward, you open
a can of starvation worms.  This is exactly why vruntimes are monotonic.

> > If he did have something, how often do you think it should be possible
> > for task X to bribe the scheduler into selecting task Y?
> 
> In extreme cases, very often.  Say 100KHz.

Hm, so it needs to be very cheap, and highly repeatable.

What if: so you're trying to get spinners out of the way right?  You
somehow know they're spinning, so instead of trying to boost some task,
can you do a directed yield in terms of directing a spinner that you
have the right to diddle to yield.  Drop his lag, and resched him.  He's
not accomplishing anything anyway.

If the only thing running is virtualization, and nobody else can use the
interface being invented, all is fair, but this passing of vruntime
around is problematic when innocent bystanders may want to play too.
Forcing a spinning task to parity doesn't have the same problems. 

> > Will his
> > pockets be deep enough to actually solve the problem?  Once he's
> > yielded, he's out of the picture for a while if he really gave anything
> > up.
> 
> Unless the other task donates some cpu share back.  This is exactly what 
> will happen in those extreme cases.

So vruntime donation won't work.

> > What happens to donated entitlement when the recipient goes to
> > sleep?
> 
> Nothing.

It's vaporized by the sleep.

> > If you try to give it back, what happens if the donor exited?
> 
> It's lost, too bad.

Yep, so much for accounting.

> > Where did the entitlement come from if task A running alone on cpu A
> > tosses some entitlement over the fence to his pal task B on cpu B.. and
> > keeps on trucking on cpu A?  Where does that leave task C, B's
> > competition?
> 
> Eventually C would replace A, since its share will be exhausted.  If C 
> is pinned... good question.  How does fairness work with pinned tasks?

In the case I described, C had it's pocket picked by A.

> > >  Do I correctly read between the lines that CFS maintains complete
> > >  fairness only on a cpu, but not globally?
> >
> > Nothing between the lines about it.  There are N individual engines,
> > coupled via load balancing.
> 
> Is this not seen as a major deficiency?

Doesn't seem to be.  That's what SMP-nice was all about.  It's not
perfect, but seems to work well.

> I can understand intra-cpu scheduling decisions at 300 Hz and inter-cpu 
> decisions at 10 Hz (or even lower, with some intermediate rate for 
> intra-socket scheduling).  But this looks like a major deviation from 
> fairness - instead of 33%/33%/33% you get 50%/25%/25% depending on 
> random placement.

Yeah, you have to bounce tasks around regularly to make that work out.

	-Mike


