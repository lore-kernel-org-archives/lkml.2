Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0FACjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:39:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:37557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0FACjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:39:01 -0400
Date: Tue, 1 Jun 2010 12:38:46 +1000
From: Neil Brown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601123846.14d0535b@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1005312159420.9148-100000@netrider.rowland.org>
References: <20100601113309.609349fd@notabene.brown>
	<Pine.LNX.4.44L0.1005312159420.9148-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 22:10:00 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 1 Jun 2010, Neil Brown wrote:
> 
> > > As I said before, we generally can't prevent such things from happening,
> > > because even if we handle the particular race described above, it still is
> > > possible that the event will be "lost" if it arrives just a bit later (eg.
> > > during a suspend-toggle switch).  So the PRE_SUSPEND thing won't really
> > > solve the entire problem while increasing complexity.
> > > 
> > > > My freerunner has a single core so without CONFIG_PREEMPT it may be that
> > > > there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
> > > > soft_irq thread has a chance to finish handling of the interrupt (my
> > > > knowledge of these details is limits).  But on a muilti-core device I think
> > > > there would definitely be a race-window.
> > > 
> > > Yes, there always will be a race window.  The only thing we can do is to
> > > narrow it, but we cannot really close it (at least not on a PC, but I'm not
> > > really sure it can be closed at all).
> > 
> > Well you are the expert so I assume you are right, but I would really like to
> > understand why this is.
> > 
> > I guess that if the event was delivered as an edge-triggered interrupt which
> > the interrupt controller couldn't latch, then it might get lost.  Is that
> > what happens?
> 
> You're barking up the wrong tree.  If I understand correctly, Rafael is
> saying that there's a race involving events which are not _wakeup_
> events.  If a non-wakeup event arrives shortly before a suspend, it can
> have its normal effect.  If it arrives while a suspend is in progress,
> its delivery may be delayed until the system resumes.  And if it
> arrives after the system is fully suspended, it may never be noticed at
> all.

I am only thinking of wakeup event. (And I am only thinking of suspend as
initiated by writing 'mem' to /sys/power/state.)
I agree that non-wakeup events can easily be delayed by suspend, and this is
by design and no-one wants it to change.

> 
> With wakeup events the problem isn't so bad.  Wakeup events are always
> noticed, and if the system is designed properly they will either abort
> a suspend-in-progress or else cause the system to resume as soon as the
> suspend is complete.  (Linux is not yet properly designed in this
> sense.)

This is exactly the issue.  Linux doesn't get this right.  A wakeup that is
processed by the driver just before suspend may not get all the way out to
it's final destination (possibly in meat-space) until after some other event
wakes the device.  It is not possible to guarantee full delivery of a wakeup
event with Linux in its current state.  This is a bug.

> 
> Or maybe I'm misunderstanding also, and Rafael is saying that there's 
> a race involving events whose meaning changes depending on whether or 
> not the system is asleep.  This is obviously true and clearly 
> unavoidable.
> 
> > And if you are right that the race window cannot be closed, then the whole
> > suspend-blocker infrastructure is pointless as the purpose of it is simply to
> > close that window.  If it really does not and cannot work, then it would be
> > best to reject it for that reason rather than for less concrete aesthetic
> > arguments.
> > But presumably it does work in practice on Android hardware so ..... confused.
> 
> The point you're missing is that Android works with regard to wakeup
> events.  It doesn't necessarily always receive non-wakeup events
> (although I don't know how Android classifies events -- maybe
> everything is a wakeup event for them).
> 

I don't think I'm missing that.  Wakeup events are the only events of
interest.  But wakeup events are more than just low-level hardware events.
They are also the virtual events that are a direct consequence of the
original hardware event.
A UART asserts 'data ready' which is routed to an IO interrupt line that
wakes the device.  This is a wakeup event.
So are the bits that appear on the data line which represent the data
So are the characters that appear on the serial port
So is the "here is a message from the GSM processor" event
So is the "there is a new TXT message" event
So is the "'beep beep beep' out the speaker" event

All these events are wakeup events, and should abort or instant-resume the
system.  Currently only the first can be guaranteed to do this (... and maybe
the second, depending on the details of the implementation).
suspend-blocks effectively pass a lock from one event to the next to ensure
that all of these event block the suspend.  There are various other ways to
achieve the same thing, and I think it can be done with no significant change
to the API.  But some how we need to allow all of these events to be
linked wake-up events, not just the first one.

Thanks,
NeilBrown
