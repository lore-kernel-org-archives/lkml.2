Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0FAWHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:07:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:07:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Wed, 2 Jun 2010 00:08:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1006011032150.2949-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006011032150.2949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006020008.49150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010, Alan Stern wrote:
> On Tue, 1 Jun 2010, Neil Brown wrote:
> 
> > > With wakeup events the problem isn't so bad.  Wakeup events are always
> > > noticed, and if the system is designed properly they will either abort
> > > a suspend-in-progress or else cause the system to resume as soon as the
> > > suspend is complete.  (Linux is not yet properly designed in this
> > > sense.)
> > 
> > This is exactly the issue.  Linux doesn't get this right.  A wakeup that is
> > processed by the driver just before suspend may not get all the way out to
> > it's final destination (possibly in meat-space) until after some other event
> > wakes the device.  It is not possible to guarantee full delivery of a wakeup
> > event with Linux in its current state.  This is a bug.
> 
> That wasn't what I meant.  An important requirement is that a wakeup 
> event received after the device has been suspended, but before the 
> system suspend is complete, should cause the system suspend to abort.  
> This is one of the things suspend blockers were meant to help with.  In 
> theory it should already work correctly -- but it doesn't.  That's a 
> real bug.
> 
> The other things you're talking about aren't really bugs.  That is,
> they are things which the kernel _ought_ to do but it wasn't _intended_
> to do.  They are misfeatures: failures of design, not failures of 
> execution.
> 
> > I don't think I'm missing that.  Wakeup events are the only events of
> > interest.  But wakeup events are more than just low-level hardware events.
> > They are also the virtual events that are a direct consequence of the
> > original hardware event.
> 
> This is a matter of semantics and it is highly debatable.
> 
> > A UART asserts 'data ready' which is routed to an IO interrupt line that
> > wakes the device.  This is a wakeup event.
> 
> Yes.
> 
> > So are the bits that appear on the data line which represent the data
> > So are the characters that appear on the serial port
> > So is the "here is a message from the GSM processor" event
> > So is the "there is a new TXT message" event
> > So is the "'beep beep beep' out the speaker" event
> 
> None of those things can cause the system to wake up after it is
> suspended.  Indeed, they can't happen at all if the CPU isn't running
> (unless the GSM processor runs autonomously -- let's ignore such
> details).  Hence it makes little sense to call them "wakeup" events.
> 
> > All these events are wakeup events, and should abort or instant-resume the
> > system.  Currently only the first can be guaranteed to do this (... and maybe
> > the second, depending on the details of the implementation).
> > suspend-blocks effectively pass a lock from one event to the next to ensure
> > that all of these event block the suspend.  There are various other ways to
> > achieve the same thing, and I think it can be done with no significant change
> > to the API.  But some how we need to allow all of these events to be
> > linked wake-up events, not just the first one.
> 
> That's not entirely clear.  Yes, for Android's use case that's what you 
> want.  But in other situations maybe you don't.  Consider the example 
> of someone who closes the lid of their laptop and throws it in a 
> backpack.  The computer should suspend immediately; it shouldn't be 
> delayed by these "virtual wakeup" events.

BTW, this is an important point.  We've already had some bug reports regarding
such unwanted wakeup events.

Rafael
