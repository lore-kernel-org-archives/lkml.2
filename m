Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0FABd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:33:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0FABdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:33:24 -0400
Date: Tue, 1 Jun 2010 11:33:09 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601113309.609349fd@notabene.brown>
In-Reply-To: <201006010232.20263.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 02:32:20 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 01 June 2010, Neil Brown wrote:
> > I want to be able to turn my freerunner upside-down by which I tell it (via
> > the accelerometers) that I am done and want it to turn off.  If a TXT message
> > comes in just then, I don't want it to suspend, I want it to make an alert
> > noise.
> > I can put code in to ignore the accelerometer if a txt has just recently come
> > in, but if the TXT arrives just as the write to /sys/power/state starts, the
> > UART interrupt handler could have completed before it has the PRE_SUSPEND
> > method called.  So the suspend will complete and the wakeup from the UART
> > will have been "lost" in that the event didn't get all the way to its
> > destination: my ear.
> 
> As I said before, we generally can't prevent such things from happening,
> because even if we handle the particular race described above, it still is
> possible that the event will be "lost" if it arrives just a bit later (eg.
> during a suspend-toggle switch).  So the PRE_SUSPEND thing won't really
> solve the entire problem while increasing complexity.
> 
> > My freerunner has a single core so without CONFIG_PREEMPT it may be that
> > there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
> > soft_irq thread has a chance to finish handling of the interrupt (my
> > knowledge of these details is limits).  But on a muilti-core device I think
> > there would definitely be a race-window.
> 
> Yes, there always will be a race window.  The only thing we can do is to
> narrow it, but we cannot really close it (at least not on a PC, but I'm not
> really sure it can be closed at all).

Well you are the expert so I assume you are right, but I would really like to
understand why this is.

I guess that if the event was delivered as an edge-triggered interrupt which
the interrupt controller couldn't latch, then it might get lost.  Is that
what happens?
But if the event comes in as a level-triggered (or latched) interrupt, then
the driver simply chooses not to acknowledge the interrupt after PRE_SUSPEND
until RESUME.  Then any suspend would immediately be woken.  Maybe the window
for ignoring interrupt would have to be a bit smaller than that, but it
should be a well defined window that can be locked.
Why cannot we carry this sort of guarantee all the way up to user-space and
beyond?  Am I completely misunderstanding the hardware?

And if you are right that the race window cannot be closed, then the whole
suspend-blocker infrastructure is pointless as the purpose of it is simply to
close that window.  If it really does not and cannot work, then it would be
best to reject it for that reason rather than for less concrete aesthetic
arguments.
But presumably it does work in practice on Android hardware so ..... confused.

Having just seen the email from Thomas, maybe you mean that it cannot be
closed on devices using ACPI, but can on other devices.  I can sort-of
imagine how that would be the case (I tried reading an ACPI spec once - my
hat is of to those of you who understand it).
That shouldn't prevent us from closing the race window on "sane" hardware
that allows it.  This would, I think, be sufficient for Android's needs.

I'm hoping we can get agreement on:
  - there is a race with suspend
  - it can be closed on the sort of hardware that is typically used in the
    mobile space
  - closing it would address the need which lead to the suspend-block
    proposal.

If we have agreement on that, we can move on to
  - should we close the race? (hopefully "yes" because bugs should be fixed).
  - how should we close the race? (lots of room for exploration there).


Thanks,
NeilBrown
