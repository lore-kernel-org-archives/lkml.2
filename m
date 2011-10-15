Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1JOWIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:08:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1JOWIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:08:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Sun, 16 Oct 2011 00:10:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <20111014165212.7929243c@notabene.brown>
In-Reply-To: <20111014165212.7929243c@notabene.brown>
MIME-Version: 1.0
Message-Id: <201110160010.40639.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, October 14, 2011, NeilBrown wrote:
> On Thu, 13 Oct 2011 21:45:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
...
> 
> Hi Rafael,
> 
>  What do you mean by "too complicated to use in practice"?  What is you
>  measure for complexity?

I, personally, don't really know what the difficulty is, as I have already
described this approach for a few times (for example, in Section 5 of the
article at http://lwn.net/images/pdf/suspend_blockers.pdf).  However, I've
recently talked to a few people whom I regard as smart and who had tried
to implement it and it didn't work for them, and they aren't really able
to say why exactly.  Thus I have concluded it has to be complicated, but
obviously you're free to draw your own conclusions. :-)

[BTW, attempts to defend the approach I have invented against myself are
 extremely likely to fail, pretty much by definition. ;-)]

>  Using suspend in a race-free way is certainly less complex than - for
>  example - configuring bluetooth.
>  And in what way is it "inadequate for other reasons"? What reasons?

Consider the scenario described by John (the wakeup problem).  A process
has to do something at certain time and the system shouldn't be suspended
while the process is doing that, although it very well may be suspended
earlier or later.  The process puts itself to sleep with the assumption
that a wake alarm is set (presumably by another process) to wake the system
up from suspend at the right time (if the suspend happens).  However, the
process itself doesn't know _exactly_ what time the wake alarm is set to.

In the situation in which we only have the existing mechanism and a user space
power manager daemon, this scenario appears to be inherently racy, such that it
cannot be handled correctly.

>  The only sane way to handle suspend is for any (suitably privileged) process
>  to be able to request that suspend doesn't happen, and then for one process
>  to initiate suspend when no-one is blocking it.

As long as you don't specify the exact way by which the request is made and
how the suspend is blocked, the above statement is almost meaningless.

>  This is very different from the way it is currently handled were the GUI
>  says "Hmm.. I'm not doing anything just now, I think I'll suspend".
> 
>  The later simply doesn't scale.  It is broken.  It has to be replaced.
>  And it is being replaced.

Cool, good to hear that! :-)

>  gnome-power-manage has a dbus interface on which you can request
>  "InhibitInactiveSleep".  Call that will stop gnome-power-manager from
>  sleeping (I assume - haven't looked at the code).
>  It might not inhibit an explicit request for sleep - in that case it is
>  probably broken and needs to be fixed.  But is can be fixed.  Or replaced.

Perhaps.

Is KDE going to use the same mechanism, for one example?  And what about other
user space variants?  MeeGo anyone?  Tizen?  Android??

>  So if someone is running gnome-power-manager and wants to perform a firmware
>  update, the correct thing to do is to use dbus to disable the inactive sleep.
>  If someone is using some other power manager they might need to use some
>  other mechanism.  Presumably these things will be standardised at some stage.

Unless you have a specific idea about how to make this standardization happen,
I call it wishful thinking to put it lightly.  Sorry about the harsh words, but
that's how it goes IMNSHO. 

>  But I think it is very wrong to put some hack in the kernel like your
>    suspend_mode = disabled

Why is it wrong and why do you think it is a "hack"?

>  just because the user-space community hasn't got its act together yet.

Is there any guarantee that it will get its act together in any foreseeable
time frame?

>  And if you really need a hammer to stop processes from suspending the system:
> 
>    cat /sys/power/state > /tmp/state
>    mount --bind /tmp/state /sys/power/state
> 
>  should to it.

Except that (1) it appears to be racy (what if system suspend happens between
the first and second line in your example - can you safely start to upgrade
your firmware in that case?) and (2) it won't prevent the hibernate interface
based on /dev/snapshot from being used.

Do you honestly think I'd propose something like patch [1/2] if I didn't
see any other _working_ approach?

>  You second patch has little to recommend it either.
>  In the first place it seems to be entrenching the notion that timeouts are a
>  good and valid way to think about suspend.

That's because I think they are unavoidable.  Even if we are able to eliminate
all timeouts in the handling of wakeup events by the kernel and passing them
to user space, which I don't think is a realistic expectation, the user will
still have only so much time to wait for things to happen.  For example, if
a phone user doesn't see the screen turn on 0.5 sec after the button was
pressed, the button is pretty much guaranteed to be pressed again.  This
observation applies to other wakeup events, more or less.  They are very much
like items with "suitability for consumption" timestamps: it they are not
consumed quickly enough, we can simply forget about them.

>  I certainly agree that there are plenty of cases where timeouts are
>  important and necessary.  But there are also plenty of cases where you will
>  know exactly when you can allow suspend again, and having a timeout there is
>  just confusing.

Please note that with patch [2/2] the timeout can always be overriden.

>  But worse - the mechanism you provide can be trivially implemented using
>  unix-domain sockets talking to a suspend-daemon.
> 
>  Instead of opening /dev/sleepctl, you connect to /var/run/suspend-daemon/sock
>  Instead of ioctl(SLEEPCTL_STAY_AWAKE), you write a number to the socket.
>  Instead of ioctl(SLEEPCTL_RELAX), you write zero to the socket.
> 
>  All the extra handling you do in the kernel, can easily be done by
>  user-space suspend-daemon.

I'm not exactly sure why it is "worse".  Doing it through sockets may require
the kernel to do more work and it won't be possible to implement the
SLEEPCTL_WAIT_EVENT ioctl I've just described to John this way.

>  I really wish I could work out why people find the current mechanism
>  "difficult to use".  What exactly is it that is difficult?
>  I have describe previously how to build a race-free suspend system.  Which
>  bit of that is complicated or hard to achieve?  Or which bit of that cannot
>  work the way I claim?  Or which need is not met by my proposals?
> 
>  Isn't it much preferable to do this in userspace where people can
>  experiment and refine and improve without having to upgrade the kernel?

Well, I used to think that it's better to do things in user space.  Hence,
the hibernate user space interface that's used by many people.  And my
experience with that particular thing made me think that doing things in
the kernel may actually work better, even if they _can_ be done in user space.

Obviously, that doesn't apply to everything, but sometimes it simply is worth
discussing (if not trying).  If it doesn't work out, then fine, let's do it
differently, but I'm really not taking the "this should be done in user space"
argument at face value any more.  Sorry about that.

Thanks,
Rafael
