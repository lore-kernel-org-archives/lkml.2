Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1JPUYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:24:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1JPUYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:24:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Sun, 16 Oct 2011 22:26:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
References: <Pine.LNX.4.44L0.1110152224461.19724-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110152224461.19724-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110162226.37474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, October 16, 2011, Alan Stern wrote:
> On Sun, 16 Oct 2011, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > On Friday, October 14, 2011, NeilBrown wrote:
> > > On Thu, 13 Oct 2011 21:45:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > ...
> > > 
> > > Hi Rafael,
> > > 
> > >  What do you mean by "too complicated to use in practice"?  What is you
> > >  measure for complexity?
> > 
> > I, personally, don't really know what the difficulty is, as I have already
> > described this approach for a few times (for example, in Section 5 of the
> > article at http://lwn.net/images/pdf/suspend_blockers.pdf).  However, I've
> > recently talked to a few people whom I regard as smart and who had tried
> > to implement it and it didn't work for them, and they aren't really able
> > to say why exactly.  Thus I have concluded it has to be complicated, but
> > obviously you're free to draw your own conclusions. :-)
> > 
> > [BTW, attempts to defend the approach I have invented against myself are
> >  extremely likely to fail, pretty much by definition. ;-)]
> 
> I'm with Neil on this.  I think the mechanisms you have proposed could 
> be implemented equally well in userspace, with very little penalty.

There's one little problem with that, which is to make user space developers
actually implement your idea. :-)

> Certainly any process that is wakeup-aware will have to be 
> specially written in any case.  Either it has provisions for using 
> /dev/sleepctl or it has provisions for communicating with a PM daemon.  
> One doesn't seem any simpler than the other.

I can agree with that.

> In addition, with proper care a PM daemon could be written that would
> work with "legacy" systems (all current systems qualify).  It would 
> allow for new wakeup-aware programs while allowing the legacy system to 
> work correctly.

Cool.  I thought pretty much the same one year ago, but so far, there are
no real-life implementations.

> > >  Using suspend in a race-free way is certainly less complex than - for
> > >  example - configuring bluetooth.
> > >  And in what way is it "inadequate for other reasons"? What reasons?
> > 
> > Consider the scenario described by John (the wakeup problem).  A process
> > has to do something at certain time and the system shouldn't be suspended
> > while the process is doing that, although it very well may be suspended
> > earlier or later.  The process puts itself to sleep with the assumption
> > that a wake alarm is set (presumably by another process) to wake the system
> > up from suspend at the right time (if the suspend happens).  However, the
> > process itself doesn't know _exactly_ what time the wake alarm is set to.
> 
> That's okay.  When the process is notified about an impending suspend,
> it checks the current time.  If the current time is more than Delta-T
> before the target time, it allows the suspend to occur (relying on the
> wake alarm to activate before the target time).  If not, it forbids the
> suspend.
> 
> > In the situation in which we only have the existing mechanism and a user space
> > power manager daemon, this scenario appears to be inherently racy, such that it
> > cannot be handled correctly.
> 
> Anything wrong with the scheme described above?

The wake alarm may happen before time T - Delta-T, in which case the process
will allow suspend to happen and won't be woken up.  However, I agree that this
is a matter of timing.

> > Is KDE going to use the same mechanism, for one example?  And what about other
> > user space variants?  MeeGo anyone?  Tizen?  Android??
> 
> It shouldn't matter.  We ought to be able to write a PM daemon that 
> would work under any of these systems as they currently exist.

OK

> > >  But I think it is very wrong to put some hack in the kernel like your
> > >    suspend_mode = disabled
> > 
> > Why is it wrong and why do you think it is a "hack"?
> > 
> > >  just because the user-space community hasn't got its act together yet.
> > 
> > Is there any guarantee that it will get its act together in any foreseeable
> > time frame?
> > 
> > >  And if you really need a hammer to stop processes from suspending the system:
> > > 
> > >    cat /sys/power/state > /tmp/state
> > >    mount --bind /tmp/state /sys/power/state
> > > 
> > >  should to it.
> > 
> > Except that (1) it appears to be racy (what if system suspend happens between
> > the first and second line in your example - can you safely start to upgrade
> > your firmware in that case?) and (2) it won't prevent the hibernate interface
> > based on /dev/snapshot from being used.
> 
> The bind mount, or something equivalent, would be done once, when the
> PM daemon starts up (presumably at boot time).  Races aren't an issue 
> then.
> 
> Basically, what we need is a reliable way to intercept the existing
> mechanisms for suspend/hibernate and to redirect the requests to the PM
> daemon.  When the daemon is started up in "legacy" mode, it assumes
> there is a legacy client (representing the entire set of
> non-wakeup-aware programs) that always forbids suspend _except_ when
> one of the old mechanisms is invoked.

I think that implementing this will actually be more complicated than my
patches.

> > Do you honestly think I'd propose something like patch [1/2] if I didn't
> > see any other _working_ approach?
> 
> This redirection idea is worth considering.
> 
> > >  You second patch has little to recommend it either.
> > >  In the first place it seems to be entrenching the notion that timeouts are a
> > >  good and valid way to think about suspend.
> > 
> > That's because I think they are unavoidable.  Even if we are able to eliminate
> > all timeouts in the handling of wakeup events by the kernel and passing them
> > to user space, which I don't think is a realistic expectation, the user will
> > still have only so much time to wait for things to happen.  For example, if
> > a phone user doesn't see the screen turn on 0.5 sec after the button was
> > pressed, the button is pretty much guaranteed to be pressed again.  This
> > observation applies to other wakeup events, more or less.  They are very much
> > like items with "suitability for consumption" timestamps: it they are not
> > consumed quickly enough, we can simply forget about them.
> 
> At the moment, I don't see the utility of timeouts for wakeup-aware 
> user programs.  While they may sometimes be necessary in the kernel, a 
> program can implement its own timers.

So consider the following modification of patch [2/2] in this series.

The SLEEPCTL_RELAX ioctl may take an additional argument (0 or 1)
indicating whether or not the process should be sent a signal (e.g. SIGPWR)
on the next wakeup event.  Along with sending the signal, the kernel will
do an equivalent of the SLEEPCTL_STAY_AWAKE, but the process will know
that it's supposed to do SLEEPCTL_RELAX again.  In this case, the timeouts
will be entirely optional (they need not be present at all in the patch).

Which doesn't make me think we can avoid timeouts anyway on higher levels, so
I don't see why they are wrong at this level.

> > >  But worse - the mechanism you provide can be trivially implemented using
> > >  unix-domain sockets talking to a suspend-daemon.
> > > 
> > >  Instead of opening /dev/sleepctl, you connect to /var/run/suspend-daemon/sock
> > >  Instead of ioctl(SLEEPCTL_STAY_AWAKE), you write a number to the socket.
> > >  Instead of ioctl(SLEEPCTL_RELAX), you write zero to the socket.
> > > 
> > >  All the extra handling you do in the kernel, can easily be done by
> > >  user-space suspend-daemon.
> > 
> > I'm not exactly sure why it is "worse".  Doing it through sockets may require
> > the kernel to do more work and it won't be possible to implement the
> > SLEEPCTL_WAIT_EVENT ioctl I've just described to John this way.
> 
> Why not?  The PM daemon queries all its clients when a suspend is 
> imminent.  Those queries are just like the SIGPWR things you described 
> for SLEEPCTL_WAIT_EVENT.

SIGPWR means that a wakeup event has actually happened, but the queries are
just in case.  And I claim that programming applications for handling those
queries will be more complicated than using the SLEEPCTL_STAY_AWAKE and
SLEEPCTL_RELAX ioctls with the modification described above.

Plus we'll need to implement the PM manager daemon, which I think will take
more time and code than those relatively simple patches I sent. :-)

> > >  Isn't it much preferable to do this in userspace where people can
> > >  experiment and refine and improve without having to upgrade the kernel?
> > 
> > Well, I used to think that it's better to do things in user space.  Hence,
> > the hibernate user space interface that's used by many people.  And my
> > experience with that particular thing made me think that doing things in
> > the kernel may actually work better, even if they _can_ be done in user space.
> > 
> > Obviously, that doesn't apply to everything, but sometimes it simply is worth
> > discussing (if not trying).  If it doesn't work out, then fine, let's do it
> > differently, but I'm really not taking the "this should be done in user space"
> > argument at face value any more.  Sorry about that.
> 
> In this case, I strongly suspect that the difficulty level will be
> about the same either way.

I'm not sure about that.

> Both approaches would place strict requirements on the structure of
> wakeup-aware programs.

That's obviously correct.

Thanks,
Rafael
