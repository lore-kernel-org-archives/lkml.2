Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1JMC7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:59:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33728 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1JMC7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:59:31 -0400
Date: Wed, 12 Oct 2011 19:59:26 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, NeilBrown <neilb@suse.de>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111013025926.GA893@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164456.GC14312@mgross-G62>
 <20111008221439.48f30263@notabene.brown>
 <20111008181638.GA12672@mgross-G62>
 <201110082057.43020.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110082057.43020.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 08:57:42PM +0200, Rafael J. Wysocki wrote:
> On Saturday, October 08, 2011, mark gross wrote:
> > On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> > > On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wrote:
> > > 
> > > > resending to wider list for discussion
> > > > ----- Forwarded message from mark gross <markgross@thengar.org> -----
> > > > 
> > > > Subject: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
> > > > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > > > From: mark gross <markgross@thengar.org>
> > > > To: linux-pm@lists.linux-foundation.org
> > > > Reply-To: markgross@thegnar.org
> > > > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>
> > > > 
> > > > The following patch set implement an (untested) solution to the
> > > > following problems.
> > > > 
> > > > 1) a method for making a system unable to suspend for critical sections
> > > > of time.
> > > 
> > > We already have this.  A properly requested suspend (following wakeup_count
> > > protocol) is unable to complete between wakeup_source_activate() and
> > > wake_source_deactivate() - these delimit the critical sections.
> > > 
> > > What more than this do you need?
> > 
> > sometimes devices that are not wake up sources need critical sections
> > where suspend is a problem.
> > 
> > > If user-space wants to prevent suspend, it just needs some sort of protocol
> > > for talking to the user-space process which follows the correct protocol to
> > > initiate suspend.  That isn't a kernel problem.
> > 
> > The devices that I've seen that need to block suspend don't have a
> > communication interface to user mode. 
> > 
> > But, you are right the devices that need this sort of thing could
> > register as wakeup sources and block suspend as well.
> > 
> > FWIW This part of the patch set was to wrap up a proposal I got last
> > year from some folks to try to provide somewhat compatible semantics to
> > wakelock's for the android and linux kernel community.
> > 
> > I include it for completeness. 
> > > 
> > > > 
> > > > 2) providing a race free method for the acknowledgment of wake event
> > > > processing before re-entry into suspend can happen.
> > > 
> > > Again, this is a user-space problem.  It is user-space which requests
> > > suspend.  It shouldn't request it until it has checked that there are no wake
> > > events that need processing - and should use the wakeup_count protocol to
> > > avoid races with wakeup events happening after it has checked.
> > 
> > Here you are wrong, or missing the point.  The kernel needs to be
> > notified from user mode that an update event has been consumed by
> > whoever cares about it before the next suspend can happen.
> 
> This, in fact, isn't correct.  I have tried to turn your (and John's)
> attention to this for quite a few times already.
yup.

> The point is that the entity about to trigger suspend (that need not be the
> kernel!) has to communicate with the processes that consume wakeup events
> beforehand.  In theory this communication can happen entirely in user
> space, but that would involve quite complicated interactions between
> processes, so nobody does that in practice.
yes.

> The only "problem" that can't be solved entirely in user space, which is
> what John turned my attention to during the LPC, is that it may be
> possible to suspend when processes that should be asked about whether or
> not to suspend are sleeping and that may be done _without_ actually asking
> those processes for permission.  The difficult part is, if we suspend in
> such a situation, we need to wait until all of those processes have a chance
> to run before attempting to suspend again.
I'm not trying to address this.  I see this as an interesting
optimization that distracts from the issue this patch set is trying to
make better.  


> > The fact that there are time outs in the existing wake event code points to
> > this shortcoming in the current implementation.
> 
> Actually, the timeouts serve a different purpose.  Namely, there are wakeup
> events that aren't actually consumed by anyone above the layer signaling the
> event (think about Wake-on-LAN via a magic packet) and if such an event
> happens, we can't suspend at once, because we need to assume that it happened
> for a reason, so whoever triggered the event has to be given a chance to do
> whatever he needed to wake up the system for.  This cannot be achieved without
> timeouts.
Thats why I created the notification interface.  Couldn't the process
that needs a chance to do its work register for notification instead of
having a timeout with the hope that it was long enough?

> > I suppose one could rig up the user mode suspend daemon with
> > notification callbacks between event consumers across the user mode
> > stack but its really complex to get it right and forces a solution to a
> > problem better solved in kernel mode be done with hacky user mode
> > gyrations that may ripple wildly across user mode.
> 
> Agreed.
> 
> > Also it is the kernel that is currently deciding when to unblock the
> > suspend daemon for the next suspend attempt.  Why not build on that and
> > make is so we don't need the time outs?
> > 
> > > i.e. there is no kernel-space problem to solve here (except for possible
> > > bugs).
> > 
> > Just a race between the kernel allowing a suspend and the user mode code
> > having time to consume the last wake event.
> 
> That's correct.
> 
> Thanks,
> Rafael

sorry for the lat reply.

--mark
