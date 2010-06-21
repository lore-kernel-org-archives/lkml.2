Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0FUVTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:19:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589Ab0FUVTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:19:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Mon, 21 Jun 2010 23:18:02 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006211244140.1687-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006211244140.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212318.03001.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Alan Stern wrote:
> On Mon, 21 Jun 2010, Florian Mickler wrote:
> 
> > > > > What happens if an event arrives just before you read
> > > > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > > > there is a new unprocessed event until after the power manager checks
> > > > > it?
> > > 
> > > > I think this is not the kernel's problem.  In this approach the kernel makes it
> > > > possible for the user space to avoid the race.  Whether or not the user space
> > > > will use this opportunity is a different matter.
> > > 
> > > It is _not_ possible for userspace to avoid this race.  Help from the 
> > > kernel is needed.
> > 
> > It is possible if every (relevant) userspace program implements a
> > callback for the powermanager to check if one of it's wakeup-sources
> > got activated.
> > 
> > That way the powermanager would read /sys/power/wakeup_count, then do
> > the roundtrip to all it's registered users and only then suspend. 
> 
> After further thought, there's still a race:
> 
> 	A wakeup event arrives.
> 
> 	The kernel increments /sys/power/wakeup_count and starts
> 	processing the event.
> 
> 	The power-manager process reads /sys/power/wakeup_count.

You assume that these two steps will occur instantaneously one after the other,
while there may be (and in fact there should be) a delay between them.

I would make the power manager wait for certain time after reading
/sys/power/wakeup_count and if no wakeup events are reported to it within
that time, to write to /sys/power/wakeup_count.

The length of the time to wait would be system-dependent in general, but I'd
also allow the event consumers to influence it (like when an application knows
it will process things for 10 minutes going forward, so it tells the power
manager to wait for at least 10 minutes before attempting to suspend).

> 	The power-manager process polls the relevant programs and
> 	they all say no events are pending.
> 
> 	The power-manager process successfully writes 
> 	/sys/power/wakeup_count.
> 
> 	The power-manager process initiates a suspend.
> 
> 	...  Hours later ...
> 
> 	The system wakes up.
> 
> 	The kernel finishes its internal processing of the event and
> 	sends a notification to a user program.
> 
> The problem here is that the power-manager process can't tell when the
> kernel has finished processing an event.  This is true both for events
> that need to propagate to userspace and for events that are handled
> entirely by the kernel.
> 
> This is a reflection of the two distinct pieces of information that we 
> need to keep track of:
> 
> 	A wakeup event has arrived, so it's no longer safe to suspend.
> 
> 	Wakeup events are no longer pending, so it's once again
> 	safe to suspend.
> 
> The wakeup_count interface tracks the first, but in this scheme nothing 
> tracks the second.

Which I don't think is really necessary, because we'll need to use timeouts
anyway, at least for events that have no user space consumers.

Rafael
