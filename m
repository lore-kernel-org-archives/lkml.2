Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab0FKOdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:33:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49490 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757006Ab0FKOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:33:31 -0400
Date: Fri, 11 Jun 2010 10:33:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTik9xMxx8IdYkUhd-oa_ik_MjGFOff_siUztls-9@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006111018190.12006-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Arve Hjønnevåg wrote:

> > You've lost me.  If the power manager is sitting inside a select/poll,
> > how can it miss the event (given that the event will make data
> > available to be read on one of the descriptors being polled)?
> >
> 
> It cannot sit inside of select/poll all the time.
> 
> > Or put it another way: With wakelocks, if the app doesn't use a suspend
> > blocker then once it reads the event data and the timed wakelock is
> > deactivated, there is nothing to prevent the system from immediately
> > going into opportunistic suspend.  My scheme can fail in the same way.
> > Is that what you meant?
> >
> 
> No, if an app reads from a file descriptor and block suspend when the
> read call returns, then suspend is blocked while processing the data.
> If the driver uses a wakelock with a timeout this will fail if the
> thread does not get to the suspend block call before the timeout
> expires, but unrelated events that don't prevent the app from running
> will not cause any problems.

Wait a second.  Maybe I have misunderstood how timeouts are supposed to
work with wakelocks.  I thought the idea was that the wakelock would be
released when the timeout expires or the event queue is emptied,
whichever comes first.  Now it sounds like you're saying that the
wakelock doesn't get released until the timeout expires, even if
userspace finishes processing all pending events before then.

> In your scheme the user-space power
> manager may miss events on this file descriptor since select/poll will
> not see an event if the app read that event right before the power
> manager called select/poll.

If the wakelock is supposed to remain active until the timeout expires 
then you are right.  On the other hand, this seems like a rather 
strange and suspicious way of handling wakelocks.  Why would you want 
to do it that way?

> > There's one question that I don't remember ever seeing answered.  To
> > which kernel drivers do you intend to add suspend blockers?
> >
> 
> All drivers that generate wakeup events need to either use suspend
> blockers directly or call into something else that does. For instance,
> with the patch to block suspend while input events are queued to
> user-space, an input driver that fully handles its events in its
> interrupt handler does not need any additional suspend blockers, but
> if the driver needs a work function or a timer to run before it
> reports the event it needs to block suspend until it has reported the
> event.

Sure.  But specifically, which drivers on Android generate wakeup
events?  And which of them don't fully handle their events in their
interrupt handlers?

Maybe another way to put this is: Where in the kernel do you intend to 
add suspend blockers?

Alan Stern

