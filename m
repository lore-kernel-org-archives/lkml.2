Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1JQWAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:00:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab1JQWAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:00:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Tue, 18 Oct 2011 00:02:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <201110160010.40639.rjw@sisk.pl> <20111017104827.52a90114@notabene.brown>
In-Reply-To: <20111017104827.52a90114@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110180002.30932.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011, NeilBrown wrote:
> On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
...
> > 
> > >  But I think it is very wrong to put some hack in the kernel like your
> > >    suspend_mode = disabled
> > 
> > Why is it wrong and why do you think it is a "hack"?
> 
> I think it is a "hack" because it is addressing a specific complaint rather
> than fixing a real problem.

I wonder why you think that there's no real problem here.

The problem I see is that multiple processes can use the suspend/hibernate
interfaces pretty much at the same time (not exactly in parallel, becuase
there's some locking in there, but very well there may be two different
processes operating /sys/power/state independently of each other), while
the /sys/power/wakeup_count interface was designed with the assumption that
there will be only one such process in mind.

> Contrast that with your wakeup_events which are a carefully designed approach
> addressing a real problem and taking into account the big picture.
> 
> i.e. it seems to be addressing a symptom rather addressing the cause.
> 
> (and it is wrong because "hacks" are almost always wrong - short-term gain,
> long term cost).

Where I'm not sure what's the symptom and what's the cause. :-)


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
> > 
> > Do you honestly think I'd propose something like patch [1/2] if I didn't
> > see any other _working_ approach?
> 
> I think there are other workable approaches  (maybe not actually _working_,
> but only because no-one has written the code).
> 
> I'm not saying we should definitely not add more functionality to the kernel,
> but I am saying we should not do it at all hastily.

That I agree with.

> If someone has tried to use the current functionality, has really understood
> it, has made an appropriate attempt to make use of it, and has found that
> something cannot be make to work reliably, or efficiently, or securely or
> whatever, then certainly consider ways to address the problems.
> 
> But I don't think we are there yet.  We are only just getting to the
> "understanding" stage (and I have found these conversations very helpful in
> refining my understanding).
> 
> When I get my GTA04 (phone motherboard) I hope to write some code that
> actually realises these idea properly (I have code on my GTA02, but it is
> broken in various ways, and the kernel is too old to
> have /sys/power/wakeup_count anyway).
> 
> 
> > 
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
> I hadn't thought of it like that - I do see your point I think.
> However things are usually consumed long before they expire - expiry times
> are longer than expected shelf life.
> I think it is important to think carefully about the correct expiry time for
> each event type as they aren't all the same.
> So I would probably go for a larger default which is always safe, but
> possibly wasteful.  But that is a small point.
> 
> > 
> > >  I certainly agree that there are plenty of cases where timeouts are
> > >  important and necessary.  But there are also plenty of cases where you will
> > >  know exactly when you can allow suspend again, and having a timeout there is
> > >  just confusing.
> > 
> > Please note that with patch [2/2] the timeout can always be overriden.
> > 
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
> "worse" because it appears to me that you are adding functionality to the
> kernel which is effectively already present.  When people do that to meet a
> specific need it is usually not as usable as the original.  i.e. "You have
> re-invented XXX - badly".  In this case XXX is IPC.
> 
> Yes - more CPU cycles may be expended in the user-space solution than a
> kernel space solution, but that is a trade-off we often make.  I don't think
> that suspend is a time-critical operation - is it?
> 
> And I think SLEEPCTL_WAIT_EVENT would work fine over sockets, particularly
> instead of a signal being sense, a simple short message were sent back over
> the socket.
> 
> 
> 
> 
> > 
> > >  I really wish I could work out why people find the current mechanism
> > >  "difficult to use".  What exactly is it that is difficult?
> > >  I have describe previously how to build a race-free suspend system.  Which
> > >  bit of that is complicated or hard to achieve?  Or which bit of that cannot
> > >  work the way I claim?  Or which need is not met by my proposals?
> > > 
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
> :-)  I have had similar mixed experiences.   Sometimes it can be a lot easier
> to get things working if it is all in the kernel.
> But I think that doing things in user-space leads to a lot more flexibility.
> Once you have the interfaces and designs worked out you can then start doing
> more interesting things and experimenting with ideas more easily.
> 
> In this case, I think the *only* barrier to a simple solution in user-space
> is the pre-existing software that uses the 'old' kernel interface.  It seems
> that interfacing with that is as easy as adding a script or two to pm-utils.

Well, assuming that we're only going to address the systems that use PM utils.

> With that problem solved, experimenting is much easier in user-space than in
> the kernel.

Somehow, I'm not exactly sure if we should throw all kernel-based solutions away
just yet.

Thanks,
Rafael
