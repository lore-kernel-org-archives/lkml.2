Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0FUQys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:54:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40952 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757972Ab0FUQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:54:46 -0400
Date: Mon, 21 Jun 2010 12:54:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Mickler <florian@mickler.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100621073233.3f874ad0@schatten.dmk.lab>
Message-ID: <Pine.LNX.4.44L0.1006211244140.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Florian Mickler wrote:

> > > > What happens if an event arrives just before you read
> > > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > > there is a new unprocessed event until after the power manager checks
> > > > it?
> > 
> > > I think this is not the kernel's problem.  In this approach the kernel makes it
> > > possible for the user space to avoid the race.  Whether or not the user space
> > > will use this opportunity is a different matter.
> > 
> > It is _not_ possible for userspace to avoid this race.  Help from the 
> > kernel is needed.
> 
> It is possible if every (relevant) userspace program implements a
> callback for the powermanager to check if one of it's wakeup-sources
> got activated.
> 
> That way the powermanager would read /sys/power/wakeup_count, then do
> the roundtrip to all it's registered users and only then suspend. 

After further thought, there's still a race:

	A wakeup event arrives.

	The kernel increments /sys/power/wakeup_count and starts
	processing the event.

	The power-manager process reads /sys/power/wakeup_count.

	The power-manager process polls the relevant programs and
	they all say no events are pending.

	The power-manager process successfully writes 
	/sys/power/wakeup_count.

	The power-manager process initiates a suspend.

	...  Hours later ...

	The system wakes up.

	The kernel finishes its internal processing of the event and
	sends a notification to a user program.

The problem here is that the power-manager process can't tell when the
kernel has finished processing an event.  This is true both for events
that need to propagate to userspace and for events that are handled
entirely by the kernel.

This is a reflection of the two distinct pieces of information that we 
need to keep track of:

	A wakeup event has arrived, so it's no longer safe to suspend.

	Wakeup events are no longer pending, so it's once again
	safe to suspend.

The wakeup_count interface tracks the first, but in this scheme nothing 
tracks the second.

Alan Stern

