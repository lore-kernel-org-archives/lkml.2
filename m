Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0E0O67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:58:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60864 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208Ab0E0O64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:58:56 -0400
Date: Thu, 27 May 2010 16:05:43 +0100
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
Message-ID: <20100527160543.2228fc17@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527140655.GA28048@srcf.ucam.org>
References: <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, if the user is playing this game, you want it to be scheduled. If 
> the user has put down their phone and the screen lock has kicked in, you 
> don't want it to be scheduled. So we could imagine some sort of cgroup 
> that contains untrusted tasks - when the session is active we set a flag 

I would hope not, because I'd rather prefer my app that used the screen
to get the chance to save important data on what it was doing
irrespective of the screen blank:  "I have an elegant proof for this
problem but my battery has gone flat"

(and I imagine we can play that examples game forever given Ashby's law)

> You can't express that with resource limits or QoS constraints. 

I don't see why not. You just have to think about the problem from the
right end. Start from "normality is well behaved applications" and
progress to "but I can constrain bogus ones". 

So what are the resource constraints/QoS constraints for your example:

[Simplistically]

1. App says 'I want to wakeup from events for me within 1 second'
	(Because I like drawing cows at about that rate)
2. App open driver for buttons
3. App opens driver for screen

   Driver for buttons goes 'humm, well I can trigger wakeup from all
   power states so I need no restrictions'. Screen will vary by device a
   lot.


(I'll come back to the screen a bit more in a moment)

So lets consider the same binary

App runs on OLPC like h/w

The pm code goes 'well I can suspend/resume in a second thats cool'
The screen code goes 'Hey I've got OLPC like video so thats ok'
The button driver can wake the system from suspend and queue an event


App runs on Android like h/w

The pm code goes 'well I can suspend/resume in a second thats cool'
The screen code goes 'Gee the screen goes blank if I go below level X' so
	I'll set a limit
The button driver can wake the system from suspend and queue an event


App runs on Android like h/w but not trusted

The pm code goes 'well tough, you can't do that, I'll refuse you'
	(Maybe user space wrapped by Android with a 'Cows wants to eat
	your phone alive [Refuse] [This Time Only] [Always] UI
	User hits refuse and Android duly assigns the code no guarantee
	and a hard limit of no guarantee.

The screen code goes 'tough'
The button driver can wake the system etc

Cows will get suspended for longer than one second whether it likes it or
not

App runs on a desktop PC

The pm code goes 'well I can't do suspend/resume in 1 second, but I can
do C6'
The screen goes 'I need C6'
The button driver goes 'I need C6'


Same app in each case and a lot less syscalls. No pathalogical cases
either - with suspend blockers you can get emergent synchronization
patterns between applications where each app rarely blocks suspends but
together their timings fall such that they never allow it. How do you
propose to even detect that ?


Ok now the screen

If I write to an X server and the server doesn't wish to talk to me it
ignores the stream and I block. This has been the case since the 1980s.

What is the problem here - your device driver for the display can block
tasks it doesn't want to use the display.

