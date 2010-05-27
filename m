Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0E0VSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:18:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46007 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755439Ab0E0VSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:18:48 -0400
Date: Thu, 27 May 2010 22:25:14 +0100
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
Message-ID: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271334560.3239-100000@iolanthe.rowland.org>
References: <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<Pine.LNX.4.44L0.1005271334560.3239-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's the point -- suspend does not evaluate the system state 
> correctly because it doesn't have the necessary information.  Suspend 

The power management layer knows if the machine is idle, it has insight
into when the next wakeups will occur.

> blockers are a way of providing it that information.  They don't paper 
> over the problem; they solve it.

I'm still unconvinced (see Thomas examples as a starter) and even if they
did, the cure would be far worse than the disease.

The hardware world also shows how you handle suspend/resume event races
cleanly and in turn how we can handle right from user to hardware.

If you are dealing with a well behaved UI app then its event loop will
just do

	if (message == UI_OFF) {
		stop_background_stuff();
		event_mask &= stuff;
		send_reply(NIGHT_NIGHT);
		continue;
		/* Back to poll() */
	}

and power management does the rest. If an event wakes up the process
before we get to suspend in kernel we will wake it back up. If the event
gets in after pm decides to idle via suspend then it'll bounce through
the kernel back to a kernel resume, or potentially through a full
hardware/software suspend/resume bounce. You have one person who needs to
track the sequence - that's however is the guy sending UI_ON/UI_OFF
information and making the screen light up.

If you are dealing with a badly behaved app then you can't win because it
may not have the magic 'suspend blockers' or will do it wrong. You
can constrain it (brute force SIGSTOP after it refuses to UI_OFF for a
bit, or via nice or other QoS policy) but you can't assume it'll
magically managge itself. It is "badly behaved" so by that very
definition you can't assume it has correct magic goo in it. (Side note:
the extra magic goo and complexity of such blockers makes it more likely
the app will be buggy and thus 'badly behaved' !)

You can pick up which tasks are stopping the suspend fairly easily at the
moment via the ktrace interfaces. Maybe there is a case for making that
tidier but powertop and the like already demonstrate you can track this.

A cpu policy can obviously expose offenders itself directly to user
space. That (and indeed people not responding to UI_OFF) then lets your
phone do

	<boop>
	X is misbehaving
	[Close it] [Allow this time] [Disable]

and also to provide stats for each wakeup a policy manager can spot
offenders (even those who are perhaps hard to see because they wake up a
little bit every so often but just enough to mess up pm). In the x86
world Arjan found a *lot* of that sort of stuff.

Your policy manager can also act on it. The current policy manager is
to fix app bugs and shows people up at conferences. I would imagine a
google policy would be to collate misbehaving app reports at google.com
and use them both to assist in 'educating' authors and in scoring app
store stuff.

As it is <boop> X is misbehaving is a powerful economic lever in a
pretty dynamic and functioning software market.

Google seem to be pretty good at statistical data, I can't believe
battery advice for apps on the app stores and indeed a 'where did my
battery go' pie chart are beyond their wit, or beyond the end user to
figure out.

There are a considerable number of people shipping power constrained
Linux devices without suddenely desperately needing extra magic potions.
Are they really all just that much smarter than Google ?

Alan
