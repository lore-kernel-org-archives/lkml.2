Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0FUWSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:18:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51070 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751379Ab0FUWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:18:05 -0400
Date: Mon, 21 Jun 2010 18:18:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Mickler <florian@mickler.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100621223841.1cf1942d@schatten.dmk.lab>
Message-ID: <Pine.LNX.4.44L0.1006211814370.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Florian Mickler wrote:

> > In the end you would want to have communication in both directions:  
> > suspend blockers _and_ callbacks.  Polling is bad if done too often.  
> > But I think the idea is a good one.
> 
> Actually, I'm not so shure. 
> 
> 1. you have to roundtrip whereas in the suspend_blocker scheme you have
> active annotations (i.e. no further action needed) 

That's why it's best to use both.  The normal case is that programs
activate and deactivate blockers by sending one-way messages to the PM
process.  The exceptional case is when the PM process is about to
initiate a suspend; that's when it does the round-trip polling.  Since
the only purpose of the polling is to avoid a race, 90% of the time it
will succeed.

> 2. it may not be possible for a user to determine if a wake-event is
> in-flight. you would have to somehow pass the wake-event-number with
> it, so that the userspace process could ack it properly without
> confusion. Or... I don't know of anything else... 
> 
> 	1. userspace-manager (UM) reads a number (42). 
> 
> 	2. it questions userspace program X: is it ok to suspend?
> 
> 	[please fill in how userspace program X determines to block
> 	suspend]
> 
> 	3a. UM's roundtrip ends and it proceeds to write "42" to the
> 	kernel [suspending]
> 	3b. UM's roundtrip ends and it aborts suspend, because a
> 	(userspace-)suspend-blocker got activated
> 
> I'm not shure how the userspace program could determine that there is a
> wake-event in flight. Perhaps by storing the number of last wake-event.
> But then you need per-wake-event-counters... :|

Rafael seems to think timeouts will fix this.  I'm not so sure.

> Do you have some thoughts about the wake-event-in-flight detection?

Not really, except for something like the original wakelock scheme in
which the kernel tells the PM core when an event is over.

Alan Stern

