Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0E0ViJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:38:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49758 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757002Ab0E0ViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:38:07 -0400
Date: Thu, 27 May 2010 17:38:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Cox wrote:

> > That's the point -- suspend does not evaluate the system state 
> > correctly because it doesn't have the necessary information.  Suspend 
> 
> The power management layer knows if the machine is idle, it has insight
> into when the next wakeups will occur.

But not the kind of insight we need.  See below.

> > blockers are a way of providing it that information.  They don't paper 
> > over the problem; they solve it.
> 
> I'm still unconvinced (see Thomas examples as a starter) and even if they
> did, the cure would be far worse than the disease.

Perhaps.

> The hardware world also shows how you handle suspend/resume event races
> cleanly and in turn how we can handle right from user to hardware.
> 
> If you are dealing with a well behaved UI app then its event loop will
> just do
> 
> 	if (message == UI_OFF) {
> 		stop_background_stuff();
> 		event_mask &= stuff;
> 		send_reply(NIGHT_NIGHT);
> 		continue;
> 		/* Back to poll() */
> 	}
> 
> and power management does the rest. If an event wakes up the process
> before we get to suspend in kernel we will wake it back up.

Okay, and the kernel never suspends.  We _are_ talking about a kind of
forced suspend, right?

>  If the event
> gets in after pm decides to idle via suspend then it'll bounce through
> the kernel back to a kernel resume,

No, it won't.  That's the problem suspend blockers were meant to solve.  
The event winds up sitting in a kernel queue, the PM core doesn't know
about it (that's what I meant above -- the PM core doesn't know as much
as you seem to think it does), and the suspend takes place regardless.

> or potentially through a full
> hardware/software suspend/resume bounce.

It would be okay if that happened.  But once the event gets into the
kernel and the hardware IRQ source has turned off, there's nothing to
cause the resume.

> You have one person who needs to
> track the sequence - that's however is the guy sending UI_ON/UI_OFF
> information and making the screen light up.
> 
> If you are dealing with a badly behaved app then you can't win because it
> may not have the magic 'suspend blockers' or will do it wrong.

Agreed.  Badly behaved apps must not be allowed to block suspends.  As 
far as I'm concerned, we can ignore them.

Alan Stern

