Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1JQVH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:07:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1JQVH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:07:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Mon, 17 Oct 2011 23:10:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
References: <Pine.LNX.4.44L0.1110171046490.2430-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110171046490.2430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110172310.18069.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011, Alan Stern wrote:
> On Sun, 16 Oct 2011, Rafael J. Wysocki wrote:
> 
> > On Sunday, October 16, 2011, Alan Stern wrote:
> > > On Sat, 15 Oct 2011, Alan Stern wrote:
> > > 
> > > > Basically, what we need is a reliable way to intercept the existing
> > > > mechanisms for suspend/hibernate and to redirect the requests to the PM
> > > > daemon.  When the daemon is started up in "legacy" mode, it assumes
> > > > there is a legacy client (representing the entire set of
> > > > non-wakeup-aware programs) that always forbids suspend _except_ when
> > > > one of the old mechanisms is invoked.
> > > 
> > > The more I think about this, the better it seems.  In essence, it 
> > > amounts to "virtualizing" the existing PM interface.
> > > 
> > > Let's add /sys/power/manage, and make it single-open.
> > 
> > I'm not sure how to do that in sysfs.
> 
> If we don't implement the virtualization in the kernel, as Neil
> suggests, then /sys/power/manage isn't necessary.  (And yes, I don't 
> know how to make sysfs files single-open either -- probably there's no 
> way to do it.)
> 
> > Also I'm not sure what the real difference between /sys/power/manage
> > and my /sys/power/sleep_mode is (I could make /sys/power/sleep_mode
> > single-open too, if I knew how to do that).
> 
> We really need to determine up front what userspace environments we
> want to support.  It seems reasonable to decide that wakeup-awareness
> will be available only on systems that use a centralized mechanism for
> initiating system sleeps.  Whether that mechanism is pm-utils or a
> vendor-specific program in an embedded system shouldn't matter too much
> -- the important thing is that it can easily be changed to send
> requests to a PM daemon instead of writing directly to /sys/power/state
> or /dev/snapshot.
> 
> (Sending requests to the daemon need not be difficult; we could write a 
> special program just for that purpose.)
> 
> If we do things this way, it leaves open the possibility of bypassing 
> all the wakeup-aware code.  That's not necessarily a bad thing.

OK, I'd like to focus on this a bit more.  I'll reply to the rest of your
message separately.

_If_ we are going to use an extra interface for switching "modes" (e.g. current
behavior vs something that uses wakeup events detection unconditionally), then
it may be /dev/sleepctl working as follows:

1. It may be open only *once* for writing.
2. It may be open multiple times in parallel for reading.
3. While open for writing, it will cause all writes to /sys/power/wakeup_count
   fail (e.g. return -EACCES).
4. Writing to it will unconditionally store the written value as saved_count
   (this will allow the writer to effectively block all suspend/hibernate
   interfaces by writing a "known bad" number to it).
5. Reading from it will work like reading from /sys/power/wakeup_count.

This way, the writer using it (the power manager) won't have to open
/sys/power/wakeup_count in addition to opening /dev/sleepctl.

Next, we can add the SLEEPCTL_RELAX and SLEEPCTL_STAY_AWAKE ioctls to it in the
following way:

SLEEPCTL_STAY_AWAKE: cause all attempts to use /sys/power/state and the
  /dev/snapshot's ioctls to block until SLEEPCTL_RELAX is executed for
  the same file descriptor.

SLEEPCTL_RELAX(arg): if arg is 0, reverse the previous SLEEPCTL_STAY_AWAKE and
  return.  If arg is different from 0, reverse the previous SLEEPCTL_STAY_AWAKE
  and prepare the kernel to carry out an equivalent of SLEEPCTL_STAY_AWAKE on
  the given file descriptor and send the calling process the SIGPWR signal
  on the first wakeup event.

Then, the John's backup scenario will look like this:

1. SLEEPCTL_STAY_AWAKE
2. Set up the wakealarm.
3. SLEEPCTL_RELAX(1)
4. Sleep with timeout to wake up at time T (slightly before the wakealarm).
5. (a) if the system doesn't suspend and there are no wakeup events,
       do SLEEPCTL_STAY_AWAKE (when woken up) and create a backup.
   (b) if there is a wakeup event, check if the current time is earlier than
       T and go to 3 if so.  Otherwise, create a backup (the kernel has already
       done the SLEEPCTL_STAY_AWAKE for us).

Thanks,
Rafael
