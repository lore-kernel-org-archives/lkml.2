Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0FUW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:27:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59764 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754707Ab0FUW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:27:57 -0400
Date: Mon, 21 Jun 2010 18:27:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <201006212318.03001.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006211820220.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Rafael J. Wysocki wrote:

> > After further thought, there's still a race:
> > 
> > 	A wakeup event arrives.
> > 
> > 	The kernel increments /sys/power/wakeup_count and starts
> > 	processing the event.
> > 
> > 	The power-manager process reads /sys/power/wakeup_count.
> 
> You assume that these two steps will occur instantaneously one after the other,
> while there may be (and in fact there should be) a delay between them.

No, I'm not assuming that.

> I would make the power manager wait for certain time after reading
> /sys/power/wakeup_count and if no wakeup events are reported to it within
> that time, to write to /sys/power/wakeup_count.

Why?  That's just wasted time -- time during which the system could 
have been suspended.

I can understand the power manager might reason as follows: If this
wakeup event hasn't been handed over to a userspace program in the next
5 seconds, I'm going to suspend anyway on the theory that something is
wrong.  But why do that when you can get exact information?

> The length of the time to wait would be system-dependent in general, but I'd
> also allow the event consumers to influence it (like when an application knows
> it will process things for 10 minutes going forward, so it tells the power
> manager to wait for at least 10 minutes before attempting to suspend).

It tells the power manager to wait by activating a userspace suspend
blocker.  While a blocker is active, the power manager doesn't have to
poll /sys/power/wakeup_count or anything; it just waits for all the
suspend blockers to be deactivated.  And there's no guesswork involved;  
the power manager knows immediately when it's time to try suspending
again.

> > 	The power-manager process polls the relevant programs and
> > 	they all say no events are pending.
> > 
> > 	The power-manager process successfully writes 
> > 	/sys/power/wakeup_count.
> > 
> > 	The power-manager process initiates a suspend.
> > 
> > 	...  Hours later ...
> > 
> > 	The system wakes up.
> > 
> > 	The kernel finishes its internal processing of the event and
> > 	sends a notification to a user program.
> > 
> > The problem here is that the power-manager process can't tell when the
> > kernel has finished processing an event.  This is true both for events
> > that need to propagate to userspace and for events that are handled
> > entirely by the kernel.
> > 
> > This is a reflection of the two distinct pieces of information that we 
> > need to keep track of:
> > 
> > 	A wakeup event has arrived, so it's no longer safe to suspend.
> > 
> > 	Wakeup events are no longer pending, so it's once again
> > 	safe to suspend.
> > 
> > The wakeup_count interface tracks the first, but in this scheme nothing 
> > tracks the second.
> 
> Which I don't think is really necessary, because we'll need to use timeouts
> anyway, at least for events that have no user space consumers.

You wouldn't need to use timeouts for them either if the kernel had a 
way to indicate when it was finished processing events.

Alan Stern

