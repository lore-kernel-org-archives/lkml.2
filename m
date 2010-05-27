Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab0E0SmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:42:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54077 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759494Ab0E0SmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:42:15 -0400
Date: Thu, 27 May 2010 19:48:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527194840.5bca973f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527181239.GF3543@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<20100527160543.2228fc17@lxorguk.ukuu.org.uk>
	<20100527160714.GB31937@srcf.ucam.org>
	<20100527174131.18fd1c72@lxorguk.ukuu.org.uk>
	<20100527165210.GA1062@srcf.ucam.org>
	<20100527190204.14546caa@lxorguk.ukuu.org.uk>
	<20100527181239.GF3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, there's no problem so far. The question is how you guarantee that 
> the application has had the opportunity to handle the packet.

Because the application has said that it wants QoS guarantees. It wants
to know that if the events it can receive occur it will wake up within
the timescale.

So it receives the event. It's now running, not idle so we won't suspend
it.

At some point in time it will become idle again _or_ the CPU limit will
get it.


If the app is not trusted then we might suspend it before it handles the
packet. That is fine, it's not trusted and we will do that when we decide
its in the system interest to suspend it anyway.

You still don't lose the event because on resume the task will do its
processing.


> The application is a network monitoring app that renders server state 
> via animated bouncing cows. The desired behaviour is that the 
> application will cease to be scheduled if the session becomes idle 
> (where idle is defined as the system having received no user input for 
> 30 seconds) but that push notifications from the server still be 
> received in order to allow the application to present the user with 
> critical alerts.

This is a bit confusing - does the screen come back on for such events,
what constraints is the server operating under ? How does your code look
- it's hard to imagine the examples you've given as being workable given
they would block on network packet wait when a critical event occurs.
Are you using poll or threads or what ?

> Under Android:
> 
> User puts down phone. 30 seconds later the screen turns off and releases 
> the last user-level suspend block. The phone enters suspend and the 
> application is suspended. A network packet is received, causing the 
> network driver to take a suspend block. The application finishes the 
> frame it was drawing, takes its own suspend block and reads the network 
> packet. In doing so the network driver releases its suspend block, but 
> since userspace is holding one the phone stays awake. The application 
> then handles the event as necessary, releases its suspend block and the 
> phone goes to sleep again.
> 
> I don't see how this behaviour can be emulated in your model.

User puts down phone. 30 seconds later the X server decides to turn the
screen off and closes the device. This probalby releases the constraint
held via the display driver not to suspend. Any further draw requests will
block.

System looks at the other tasks and sees they are idle and can sink to a
low power state. Cows is either blocked on a packet receive or could even
be blocked on writing to the display (or both if its a realistic example
and using poll)

Everyone is idle, we can sleep

The kernel looks at the constraints it has
	- must not sink to a state below which network receive of packets
	  fails
	- must not sink below a state where whatever is needed for the
	  critical alert code etc to do its stuff
	- must not sink to a state which takes more than [constraint]
	  seconds to get back out of

It picks 'opportunistic suspend'
It goes to sleep

A packet arrives
It wakes the hardware
We are busy, we do not wish to suspend
It processes the packet
It wakes the user app
It starts processing the packet
[We are busy, we do not wish to suspend]

Presumably your display server listens to waking back up and decides to
re-activate the screen (your example is unclear and implies it carries on
processing the extra frame in the dark which seems a bit silly ?

I still don't see a problem. 

I think your problem arises because you start from the basis that forcing
suspend is special. As Thomas has said there are working implementations
where suspend is an idle mode.

The moment you discard that specific notion everything works, as it does
today on other embedded platforms.

Now what do you do if the app is burning too much processor time. That's
a QoS question too. We've got cpu limits, we've got SIGXCPU, we don't
have "cpu per second" type limits but that isn't hard to do either.

Stop transitioning Run->Forced Suspend. If you've got stuff stuck running
then deal with it by constraining it to go idle or by blowing it out of
the water. PM will then do the rest.

