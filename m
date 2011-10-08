Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1JHSQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:16:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47269 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1JHSQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:16:43 -0400
Date: Sat, 8 Oct 2011 11:16:38 -0700
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
Message-ID: <20111008181638.GA12672@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111002164456.GC14312@mgross-G62>
 <20111008221439.48f30263@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111008221439.48f30263@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wrote:
> 
> > resending to wider list for discussion
> > ----- Forwarded message from mark gross <markgross@thengar.org> -----
> > 
> > Subject: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
> > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > From: mark gross <markgross@thengar.org>
> > To: linux-pm@lists.linux-foundation.org
> > Reply-To: markgross@thegnar.org
> > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>
> > 
> > The following patch set implement an (untested) solution to the
> > following problems.
> > 
> > 1) a method for making a system unable to suspend for critical sections
> > of time.
> 
> We already have this.  A properly requested suspend (following wakeup_count
> protocol) is unable to complete between wakeup_source_activate() and
> wake_source_deactivate() - these delimit the critical sections.
> 
> What more than this do you need?

sometimes devices that are not wake up sources need critical sections
where suspend is a problem.

> If user-space wants to prevent suspend, it just needs some sort of protocol
> for talking to the user-space process which follows the correct protocol to
> initiate suspend.  That isn't a kernel problem.

The devices that I've seen that need to block suspend don't have a
communication interface to user mode. 

But, you are right the devices that need this sort of thing could
register as wakeup sources and block suspend as well.

FWIW This part of the patch set was to wrap up a proposal I got last
year from some folks to try to provide somewhat compatible semantics to
wakelock's for the android and linux kernel community.

I include it for completeness. 
> 
> > 
> > 2) providing a race free method for the acknowledgment of wake event
> > processing before re-entry into suspend can happen.
> 
> Again, this is a user-space problem.  It is user-space which requests
> suspend.  It shouldn't request it until it has checked that there are no wake
> events that need processing - and should use the wakeup_count protocol to
> avoid races with wakeup events happening after it has checked.

Here you are wrong, or missing the point.  The kernel needs to be
notified from user mode that an update event has been consumed by
whoever cares about it before the next suspend can happen.  The fact
that there are time outs in the existing wake event code points to this
shortcoming in the current implementation.

I suppose one could rig up the user mode suspend daemon with
notification callbacks between event consumers across the user mode
stack but its really complex to get it right and forces a solution to a
problem better solved in kernel mode be done with hacky user mode
gyrations that may ripple wildly across user mode.

Also it is the kernel that is currently deciding when to unblock the
suspend daemon for the next suspend attempt.  Why not build on that and
make is so we don't need the time outs?

> i.e. there is no kernel-space problem to solve here (except for possible
> bugs).

Just a race between the kernel allowing a suspend and the user mode code
having time to consume the last wake event.

--mark

