Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1JMDHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:07:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36107 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1JMDHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:07:46 -0400
Date: Wed, 12 Oct 2011 20:07:42 -0700
From: mark gross <markgross@thegnar.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, markgross@thegnar.org,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111013030742.GB893@mgross-G62>
Reply-To: markgross@thegnar.org
References: <201110082057.43020.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1110081550070.20695-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110081550070.20695-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 04:07:01PM -0400, Alan Stern wrote:
> On Sat, 8 Oct 2011, Rafael J. Wysocki wrote:
> 
> > On Saturday, October 08, 2011, mark gross wrote:
> > > On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> > > > On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wrote:
> > > > 
> > > > > resending to wider list for discussion
> > > > > ----- Forwarded message from mark gross <markgross@thengar.org> -----
> > > > > 
> > > > > Subject: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
> > > > > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > > > > From: mark gross <markgross@thengar.org>
> > > > > To: linux-pm@lists.linux-foundation.org
> > > > > Reply-To: markgross@thegnar.org
> > > > > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>
> > > > > 
> > > > > The following patch set implement an (untested) solution to the
> > > > > following problems.
> > > > > 
> > > > > 1) a method for making a system unable to suspend for critical sections
> > > > > of time.
> > > > 
> > > > We already have this.  A properly requested suspend (following wakeup_count
> > > > protocol) is unable to complete between wakeup_source_activate() and
> > > > wake_source_deactivate() - these delimit the critical sections.
> > > > 
> > > > What more than this do you need?
> > > 
> > > sometimes devices that are not wake up sources need critical sections
> > > where suspend is a problem.
> 
> Mark, can you give some examples?  This isn't the same as the firmware 
> update thing, is it?  That deserves to be handled by a completely 
> separate mechanism.

The biggest example I know of is any usb gadget implementation while
connected to a USB host.  If the device is connected to the USB bus then
it needs to not suspend because it cannot respond to the USB commands
for bus power.  i.e. if its connected to a laptop and the suspend the
laptop the gadget needs to handle the USB protocol packets.

Also, when charging battery under OS control we don't want to suspend
because it will be hard to respond to thermal events  or changing
battery conditions if the system is in suspend.

> > > > If user-space wants to prevent suspend, it just needs some sort of protocol
> > > > for talking to the user-space process which follows the correct protocol to
> > > > initiate suspend.  That isn't a kernel problem.
> > > 
> > > The devices that I've seen that need to block suspend don't have a
> > > communication interface to user mode. 
> > > 
> > > But, you are right the devices that need this sort of thing could
> > > register as wakeup sources and block suspend as well.
> > > 
> > > FWIW This part of the patch set was to wrap up a proposal I got last
> > > year from some folks to try to provide somewhat compatible semantics to
> > > wakelock's for the android and linux kernel community.
> > > 
> > > I include it for completeness. 
> 
> Although many of these problems could be solved by adopting a suitable
> protocol in userspace, currently there is no such protocol.  Even if
> one did exist, the process of getting all the relevant programs to
> adopt it would take quite a while.  This is a case where a problem can
> be solved either in the kernel or in userspace, and the in-kernel
> solution may be simpler.

I do think a better solution would involve some kernel coordination.

I don't want to split hairs on if its 100% possible to implement a
correct solution only in user mode.  but, I think there are corner cases
that may be hard or impossible to get right with only user mode.  See
gadget issue above.  Not all gadgets have a user mode daemon backing up
the kernel part do they?

--mark

> 
> > > > > 2) providing a race free method for the acknowledgment of wake event
> > > > > processing before re-entry into suspend can happen.
> > > > 
> > > > Again, this is a user-space problem.  It is user-space which requests
> > > > suspend.  It shouldn't request it until it has checked that there are no wake
> > > > events that need processing - and should use the wakeup_count protocol to
> > > > avoid races with wakeup events happening after it has checked.
> > > 
> > > Here you are wrong, or missing the point.  The kernel needs to be
> > > notified from user mode that an update event has been consumed by
> > > whoever cares about it before the next suspend can happen.
> > 
> > This, in fact, isn't correct.  I have tried to turn your (and John's)
> > attention to this for quite a few times already.
> > 
> > The point is that the entity about to trigger suspend (that need not be the
> > kernel!) has to communicate with the processes that consume wakeup events
> > beforehand.  In theory this communication can happen entirely in user
> > space, but that would involve quite complicated interactions between
> > processes, so nobody does that in practice.
> > 
> > The only "problem" that can't be solved entirely in user space, which is
> > what John turned my attention to during the LPC, is that it may be
> > possible to suspend when processes that should be asked about whether or
> > not to suspend are sleeping and that may be done _without_ actually asking
> > those processes for permission.
> 
> Essentially, there has to be a way for these processes to say "It's 
> okay to suspend until I tell you otherwise."  That could also be part 
> of the userspace protocol (if it existed).
> 
> >  The difficult part is, if we suspend in
> > such a situation, we need to wait until all of those processes have a chance
> > to run before attempting to suspend again.
> 
> Of course, a power-management daemon could handle that part easily.  
> Doing it in the kernel is more difficult.
> 
> > > The fact that there are time outs in the existing wake event code points to
> > > this shortcoming in the current implementation.
> > 
> > Actually, the timeouts serve a different purpose.  Namely, there are wakeup
> > events that aren't actually consumed by anyone above the layer signaling the
> > event (think about Wake-on-LAN via a magic packet) and if such an event
> > happens, we can't suspend at once, because we need to assume that it happened
> > for a reason, so whoever triggered the event has to be given a chance to do
> > whatever he needed to wake up the system for.  This cannot be achieved without
> > timeouts.
> 
> Also there are events that may or may not get consumed, but it is
> impossible to tell at the time whether or not a consumer exists.  If
> one does exist then good, the system can suspend again when the
> consumer is finished.  But if not, the system can only wait until a
> timeout.
> 
> > > I suppose one could rig up the user mode suspend daemon with
> > > notification callbacks between event consumers across the user mode
> > > stack but its really complex to get it right and forces a solution to a
> > > problem better solved in kernel mode be done with hacky user mode
> > > gyrations that may ripple wildly across user mode.
> > 
> > Agreed.
> > 
> > > Also it is the kernel that is currently deciding when to unblock the
> > > suspend daemon for the next suspend attempt.  Why not build on that and
> > > make is so we don't need the time outs?
> > > 
> > > > i.e. there is no kernel-space problem to solve here (except for possible
> > > > bugs).
> > > 
> > > Just a race between the kernel allowing a suspend and the user mode code
> > > having time to consume the last wake event.
> > 
> > That's correct.
> 
> Alan Stern
> 
