Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1JMDsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:48:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57729 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1JMDsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:48:10 -0400
Date: Wed, 12 Oct 2011 20:48:05 -0700
From: mark gross <markgross@thegnar.org>
To: NeilBrown <neilb@suse.de>
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111013034805.GC893@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164456.GC14312@mgross-G62>
 <20111008221439.48f30263@notabene.brown>
 <20111008181638.GA12672@mgross-G62>
 <20111009093100.6c15be50@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111009093100.6c15be50@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 09:31:00AM +1100, NeilBrown wrote:
> On Sat, 8 Oct 2011 11:16:38 -0700 mark gross <markgross@thegnar.org> wrote:
> 
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
> 
> I agree with Alan that an example would help here.
> My naive perspective is that any device is either acting on behalf of a
> user-space program, so it should disable suspend, or on behalf of some
> external event, so that event is ipso-facto a wakeup event.

battery changing and usb gadget compilance are the ones I can think of
at the moment.  I guess the FW / BIOS update may be another (but is a
bit weak as an example)

I'm having a hard time thinking of anything else :( 

> 
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
> > whoever cares about it before the next suspend can happen.  The fact
> > that there are time outs in the existing wake event code points to this
> > shortcoming in the current implementation.
> 
>  ... or I have a different perspective.
> A write to wakeup_count is a notification to the kernel that all wakeup
> events that had commenced prior to that same number being read from
> wakeup_count have been consumed.
> 
> So we already have a mechanism for the notification that you want.

If I understand you correctly; those processes still need an efficient
way of notification that the wake event came in.

> 
> > 
> > I suppose one could rig up the user mode suspend daemon with
> > notification callbacks between event consumers across the user mode
> > stack but its really complex to get it right and forces a solution to a
> > problem better solved in kernel mode be done with hacky user mode
> > gyrations that may ripple wildly across user mode.
> 
> I suspect it is in here that the key to our different perspectives lies.
> I think than any solution must "ripple wildly across user mode" if by that
> you mean that more applications and daemons will need to be power-aware and
> make definitive decisions about when they cannot tolerate suspend.
> Whether those apps and daemons tell the kernel "don't suspend now" or tell
> some user-space daemon "don't suspend now" is fairly irrelevant when
> assessing the total impact on user-space.
> 
> I think a fairly simple protocol involving file locking can be perfectly
> adequate to communicate needs relating to suspend-or-don't-suspend among
> user-space processes.

I'm not sure how the wake event notification would get to the right
process(es) are that need to get the notification in your concept.  But
after the processes that need to consume the event are notified (by
magic???) then some file locking could be done to coordinate between
those and some suspend daemon.


> 
> > 
> > Also it is the kernel that is currently deciding when to unblock the
> > suspend daemon for the next suspend attempt.  Why not build on that and
> > make is so we don't need the time outs?
> 
> Suspend is a joint decision by user-space and kernel-space.  Each part should
> participate according to its expertise.
> The kernel can make use of information generated by drivers in the kernel.
> User-space can consolidate information generated by user-space processes.
> 
> 
> > 
> > > i.e. there is no kernel-space problem to solve here (except for possible
> > > bugs).
> > 
> > Just a race between the kernel allowing a suspend and the user mode code
> > having time to consume the last wake event.
> >
> 
> Providing that the source of the wake event does not deactivate the
> wakeup_source before the event is visible to userspace, this race is easily
> avoided in userspace:

Well this is the crux of the issue.  How are you going to ack the wake
event in a sane way?  Its not quite the same as in interrupt.  knowing
when to ack it takes both user and kernel mode coordination.  I think.

> 
>    - read wakeup_count
suspend daemon blocked here when not ok to suspend.

>    - check all possible wakeup events.
but there is a user mode process that needs to chew on this wake up
event.  It needs to be notified (somehow) then it needs to coordinate
with the suspend daemon before the next suspend happens.

>    - if there were none, write back to wakeup_count and request a suspend.
> 
> This is race-free.
I don't agree.

> 
> If some wakeup_source is deactivated before the event is visible to
> user-space, then that is a bug and should be fixed.
one way is to set up overlapping critical sections from the wake event
up to user mode (we can call the patch "wakelock.patch" ...  I kid...

The wake source is at the very bottom of the kernel mode stack.
Basically an interrupt is the wake event.  How can the ISR possible know
when its ok to deactivate the wake event?  There needs to be a
formalized hand shake.

> If there is some particular case where it is non-trivial to fix that bug,
> then that would certainly be worth exploring in detail.
>

I don't think you accept the idea that there is a notification problem.
Fine, Do you at least agree that my problem statement is approximately
what we thing the original wake lock design attempted to address?

If we can converge on something then maybe we can move forward.  (a bit)


Clearly the use case I'm talking about with out talking about it is the
Android wake lock problem.  I think my problem statement comes pretty
close to what it is trying to address.

I think my implementation concept is semantically close enough that I
think I could hack an android implementation to work with it without
having to change the framework API's and only minor tweaks to a few
services (that consume wake events).  And I think my idea provides a
more correct solution to the basic problem than the original wake lock
design.  i.e.  no over lapping critical sections up and down the stack
or the need for wake_locks with (racy) timeouts.

--mark
