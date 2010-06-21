Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0FUWti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:49:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0FUWtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:49:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 00:48:10 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006211814370.1687-100000@iolanthe.rowland.org> <201006220040.41524.rjw@sisk.pl>
In-Reply-To: <201006220040.41524.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006220048.10875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Rafael J. Wysocki wrote:
> On Tuesday, June 22, 2010, Alan Stern wrote:
> > On Mon, 21 Jun 2010, Florian Mickler wrote:
> > 
> > > > In the end you would want to have communication in both directions:  
> > > > suspend blockers _and_ callbacks.  Polling is bad if done too often.  
> > > > But I think the idea is a good one.
> > > 
> > > Actually, I'm not so shure. 
> > > 
> > > 1. you have to roundtrip whereas in the suspend_blocker scheme you have
> > > active annotations (i.e. no further action needed) 
> > 
> > That's why it's best to use both.  The normal case is that programs
> > activate and deactivate blockers by sending one-way messages to the PM
> > process.  The exceptional case is when the PM process is about to
> > initiate a suspend; that's when it does the round-trip polling.  Since
> > the only purpose of the polling is to avoid a race, 90% of the time it
> > will succeed.
> > 
> > > 2. it may not be possible for a user to determine if a wake-event is
> > > in-flight. you would have to somehow pass the wake-event-number with
> > > it, so that the userspace process could ack it properly without
> > > confusion. Or... I don't know of anything else... 
> > > 
> > > 	1. userspace-manager (UM) reads a number (42). 
> > > 
> > > 	2. it questions userspace program X: is it ok to suspend?
> > > 
> > > 	[please fill in how userspace program X determines to block
> > > 	suspend]
> > > 
> > > 	3a. UM's roundtrip ends and it proceeds to write "42" to the
> > > 	kernel [suspending]
> > > 	3b. UM's roundtrip ends and it aborts suspend, because a
> > > 	(userspace-)suspend-blocker got activated
> > > 
> > > I'm not shure how the userspace program could determine that there is a
> > > wake-event in flight. Perhaps by storing the number of last wake-event.
> > > But then you need per-wake-event-counters... :|
> > 
> > Rafael seems to think timeouts will fix this.  I'm not so sure.
> > 
> > > Do you have some thoughts about the wake-event-in-flight detection?
> > 
> > Not really, except for something like the original wakelock scheme in
> > which the kernel tells the PM core when an event is over.
> 
> But the kernel doesn't really know that, so it really can't tell the PM core
> anything useful.  What happens with suspend blockers is that a kernel suspend

s/suspend/subsyste/  (-ETOOLATE)

> cooperates with a user space consumer of the event to get the story straight.
> 
> However, that will only work if the user space is not buggy and doesn't crash,
> for example, before releasing the suspend blocker it's holding.
> 
> Apart from this, there are those events withoug user space "handoff" that
> use timeouts.
> 
> Also there are events like wake-on-LAN that can be regarded as instantaneous
> from the power manager's point of view, so they don't really need all of the
> "suspend blockers" machinery and for them we will need to use a cooldown
> timeout anyway.
> 
> And if we need to use that cooldown timeout, I don't see why not to use
> timeouts for avoiding the race you're worrying about.
