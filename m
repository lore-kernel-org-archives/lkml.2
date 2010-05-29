Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0E2QKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:10:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:45812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab0E2QKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:10:31 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275120618.27810.12699.camel@twins>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100527223605.GB11364@srcf.ucam.org>
	 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	 <1275120618.27810.12699.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 11:10:18 -0500
Message-ID: <1275149418.4503.128.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 10:10 +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 17:43 -0700, Arve Hjønnevåg wrote:
> > On Fri, May 28, 2010 at 12:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Fri, 2010-05-28 at 00:31 -0400, tytso@mit.edu wrote:
> > >> Keep in mind, though, that a solution which is acceptable for Android
> > >> has to include making sure that crappy applications don't cause the
> > >> battery to get drained.  There seem to be some people who seem
> > >> adamently against this requirement.
> > >
> > > Again, Alan, Thomas and myself don't argue against that, what we do
> > > however argue against is suspend running apps as a form of power
> > > management.
> > >
> > 
> > You seem to argue that android is not allowed to use suspend because
> > the hardware we have shipped on can enter the same power state from
> > idle. From my point of view, since we need to support suspend on some
> > hardware we should be allowed to leverage this solution on the better
> > hardware platforms as well if it improves our battery life.
> 
> Correct, I strongly oppose using suspend. Not running runnable tasks is
> not a sane solution.

Look, this is getting into the realms of a pointless semantic quibble.
The problem is that untrusted tasks need to be forcibly suspended when
they have no legitimate work to do and the user hasn't authorised them
to continue even if the scheduler sees them as runnable.  Whether that's
achieved by suspending the entire system or forcibly idling the tasks
(using blocking states or freezers or something) so the scheduler can
suspend from idle is something to be discussed, but the net result is
that we have to stop a certain set of tasks in such a way that they can
still receive certain external events ... semantically, this is
equivalent to not running runnable tasks in my book. (Perhaps this whole
thing is because the word runnable means different things ... I'm
thinking a task that would consume power ... are you thinking in the
scheduler R state?)

Realistically, the main thing we need to do is stop timers posted
against the task (which is likely polling in a main loop, that being the
usual form of easy to write but power crazy app behaviour) from waking
the task and bringing the system out of suspend (whether from idle or
forced).

> If current hardware can't cope, too friggin bad, get better hardware.
> 
> But the truth is, all your OMAP phones really can deal with it.

That's rubbish and you know it.  We do software workarounds for hardware
problems all the time ... try doing a git grep -i errata in arch x86, or
imagine a USB subsystem that only supported sane standards conforming
devices: that would have an almost zero intersect with the current USB
device market.

The job of the kernel is to accommodate hardware as best it can ...
sometimes it might not be able to, but most of the time it does a pretty
good job.

The facts are that C states and S states are different and are entered
differently.  For some omap hardware, the power consumption in the
lowest C state (with all the ancillary power control) is the same as S3,
that's fine, suspend from idle works as well as suspend to ram modulo
bad apps. For quite a lot of MSM hardware, the lowest C state power
consumption is quite a bit above S3.  It's not acceptable to tell those
people "tough, your battery runs out in 30 minutes because you bought
the wrong hardware".  We have to figure out how to get to S3 ... whether
this is from idle or some other mechanism is again a discussion point,
but not doing it is not an option.

> > I have not seen any suggestions for how to deal with all our
> > interprocess dependencies when pausing a subset of processes. Without
> > a solution to that we can only pause a subset of the processes we want
> > to pause.
> 
> Do not 'pause' processes and you don't have the problem, make them stop
> on their own accord or kill them if they dont listen.. who cares about
> ill-behaved apps anyway?
> 
> But really, if you want a more detailed answer, you need to provide more
> detail on these problems.
> 
> If you want to allow an untrusted app to provide a dependency for a
> trusted app, you've lost and I don't care.
> 
> Trusted apps should be well behaved, otherwise there really is no point.
> 
> > These solutions do not allow us to use suspend. They may get us closer
> > to the power consumption we get from suspend on the good hardware or
> > even surpass it, but we still need suspend on some hardware, and we
> > would get event better results by using these solutions in addition to
> > suspend compared to using them instead of suspend.
> 
> Not using suspend is exactly the point. As Alan has argued, propagating
> suspend blockers up into all regions of userspace will take much longer
> than fixing the hardware.

Strange, that's not what I heard as the possible solution.  I thought he
was advocating expressing the kernel side of suspend blockers as QoS
constraints.  Once we have QoS constraints correctly done in the kernel,
userspace still has to express its requirements.  If the requirements
are static, then they can be done from policy files or in some other
static way but if they're dynamic, they'll still have to be in the
applications ... in about the same places the android wakelocks are.

> You got to realize this is about Linux as a whole, I really don't care
> one whit about the specific Android case. We want a solution that is
> generic enough to solve the power consumption problem and makes sense on
> future hardware.

I don't think anyone disagrees with this. As long as we find a long term
solution that satisfies the android case, everyone will be happy.

> The only abstraction that really makes sense in that view is idle
> states.

James


