Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0E0WBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:01:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49451 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933124Ab0E0WBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:01:19 -0400
Date: Thu, 27 May 2010 23:08:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 17:38:03 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > and power management does the rest. If an event wakes up the process
> > before we get to suspend in kernel we will wake it back up.
> 
> Okay, and the kernel never suspends.  We _are_ talking about a kind of
> forced suspend, right?

No ? We are talking about just letting power management solve the whole
problem for us.

> >  If the event
> > gets in after pm decides to idle via suspend then it'll bounce through
> > the kernel back to a kernel resume,
> 
> No, it won't.  That's the problem suspend blockers were meant to solve.  
> The event winds up sitting in a kernel queue, the PM core doesn't know
> about it (that's what I meant above -- the PM core doesn't know as much
> as you seem to think it does), and the suspend takes place regardless.

No - because we are not forcing the suspend. The app must go idle. If you
force the suspend of running processes then yes the entire thing goes
castors up - which is why it's a bad idea to do so.

> > or potentially through a full
> > hardware/software suspend/resume bounce.
> 
> It would be okay if that happened.  But once the event gets into the
> kernel and the hardware IRQ source has turned off, there's nothing to
> cause the resume.

Read the discussion about how the race is avoided at the hardware level.
That race is I think not there and furthermore most drivers get it right
already.

There are several cases

1.	IRQ during app layer (ie policy in user space) asking
		applications to go passive

	- The event occurs, we undo the app layer policy, easy
	  (or app wakes process and we let it fall through)

2.	IRQ after the app layer quiesces its clients

	- The task wakes, the app layer won't see it - the app layer
	  allows suspend as an idle mode. Not a problem - the app is
	  running the cpu policy manager will see this and not suspend
	  until the app has been asleep for a bit. The app may well of
	  course tell the UI layer 'hey I want you back on' and it take
	  you back to the full on case.

3.	IRQ after kernel suspend begins

	- The driver will refuse the suspend, we don't suspend, we unwind
	  the resume so far, the app wakes, we propogate stuff back up to
	  user space whose policy manager unwinds its position

4.	IRQ after driver has done its final checks

	- Wake up lines are set
	- We suspend
	- We immediately get resumed
	- We follow the full resume path

This is I believe robust (and has been implemented on some non x86
boxes). It depends on not forcing running tasks into suspend. That is the
key.

Alan
