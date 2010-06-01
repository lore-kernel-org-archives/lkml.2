Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0FACKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:10:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55711 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752003Ab0FACKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:10:01 -0400
Date: Mon, 31 May 2010 22:10:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Neil Brown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100601113309.609349fd@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1005312159420.9148-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Neil Brown wrote:

> > As I said before, we generally can't prevent such things from happening,
> > because even if we handle the particular race described above, it still is
> > possible that the event will be "lost" if it arrives just a bit later (eg.
> > during a suspend-toggle switch).  So the PRE_SUSPEND thing won't really
> > solve the entire problem while increasing complexity.
> > 
> > > My freerunner has a single core so without CONFIG_PREEMPT it may be that
> > > there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
> > > soft_irq thread has a chance to finish handling of the interrupt (my
> > > knowledge of these details is limits).  But on a muilti-core device I think
> > > there would definitely be a race-window.
> > 
> > Yes, there always will be a race window.  The only thing we can do is to
> > narrow it, but we cannot really close it (at least not on a PC, but I'm not
> > really sure it can be closed at all).
> 
> Well you are the expert so I assume you are right, but I would really like to
> understand why this is.
> 
> I guess that if the event was delivered as an edge-triggered interrupt which
> the interrupt controller couldn't latch, then it might get lost.  Is that
> what happens?

You're barking up the wrong tree.  If I understand correctly, Rafael is
saying that there's a race involving events which are not _wakeup_
events.  If a non-wakeup event arrives shortly before a suspend, it can
have its normal effect.  If it arrives while a suspend is in progress,
its delivery may be delayed until the system resumes.  And if it
arrives after the system is fully suspended, it may never be noticed at
all.

With wakeup events the problem isn't so bad.  Wakeup events are always
noticed, and if the system is designed properly they will either abort
a suspend-in-progress or else cause the system to resume as soon as the
suspend is complete.  (Linux is not yet properly designed in this
sense.)

Or maybe I'm misunderstanding also, and Rafael is saying that there's 
a race involving events whose meaning changes depending on whether or 
not the system is asleep.  This is obviously true and clearly 
unavoidable.

> And if you are right that the race window cannot be closed, then the whole
> suspend-blocker infrastructure is pointless as the purpose of it is simply to
> close that window.  If it really does not and cannot work, then it would be
> best to reject it for that reason rather than for less concrete aesthetic
> arguments.
> But presumably it does work in practice on Android hardware so ..... confused.

The point you're missing is that Android works with regard to wakeup
events.  It doesn't necessarily always receive non-wakeup events
(although I don't know how Android classifies events -- maybe
everything is a wakeup event for them).

Alan Stern

