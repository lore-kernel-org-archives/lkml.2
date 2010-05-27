Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933Ab0E0S5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:57:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39148 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536Ab0E0S5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:57:16 -0400
Date: Thu, 27 May 2010 19:56:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527185658.GA5703@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <20100527160543.2228fc17@lxorguk.ukuu.org.uk> <20100527160714.GB31937@srcf.ucam.org> <20100527174131.18fd1c72@lxorguk.ukuu.org.uk> <20100527165210.GA1062@srcf.ucam.org> <20100527190204.14546caa@lxorguk.ukuu.org.uk> <20100527181239.GF3543@srcf.ucam.org> <20100527194840.5bca973f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527194840.5bca973f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:48:40PM +0100, Alan Cox wrote:
> > The application is a network monitoring app that renders server state 
> > via animated bouncing cows. The desired behaviour is that the 
> > application will cease to be scheduled if the session becomes idle 
> > (where idle is defined as the system having received no user input for 
> > 30 seconds) but that push notifications from the server still be 
> > received in order to allow the application to present the user with 
> > critical alerts.
> 
> This is a bit confusing - does the screen come back on for such events,
> what constraints is the server operating under ? How does your code look
> - it's hard to imagine the examples you've given as being workable given
> they would block on network packet wait when a critical event occurs.
> Are you using poll or threads or what ?

It's code that's broadly identical to what I posted. The screen will 
come on if the event is critical, won't otherwise.

> > Under Android:
> > 
> > User puts down phone. 30 seconds later the screen turns off and releases 
> > the last user-level suspend block. The phone enters suspend and the 
> > application is suspended. A network packet is received, causing the 
> > network driver to take a suspend block. The application finishes the 
> > frame it was drawing, takes its own suspend block and reads the network 
> > packet. In doing so the network driver releases its suspend block, but 
> > since userspace is holding one the phone stays awake. The application 
> > then handles the event as necessary, releases its suspend block and the 
> > phone goes to sleep again.
> > 
> > I don't see how this behaviour can be emulated in your model.
> 
> User puts down phone. 30 seconds later the X server decides to turn the
> screen off and closes the device. This probalby releases the constraint
> held via the display driver not to suspend. Any further draw requests will
> block.
>
> System looks at the other tasks and sees they are idle and can sink to a
> low power state. Cows is either blocked on a packet receive or could even
> be blocked on writing to the display (or both if its a realistic example
> and using poll)

Even if it's using poll, it could block purely on the display if X turns 
the screen off between poll() waking and the write being made.
 
> The kernel looks at the constraints it has
> 	- must not sink to a state below which network receive of packets
> 	  fails
> 	- must not sink below a state where whatever is needed for the
> 	  critical alert code etc to do its stuff
> 	- must not sink to a state which takes more than [constraint]
> 	  seconds to get back out of
> 
> It picks 'opportunistic suspend'
> It goes to sleep
> 
> A packet arrives
> It wakes the hardware
> We are busy, we do not wish to suspend
> It processes the packet
> It wakes the user app
> It starts processing the packet

If it's blocked on the write then it only starts processing the packet 
again if the screen wakes up. You need to power up every piece of 
hardware that an application's blocked on, just in case they need to 
complete that read or write in order to get back to the event loop where 
they have the opportunity to read the network packet.

So, yes, I think this can work in that case. But it doesn't work in 
others - you won't idle applications that aren't accessing hardware 
drivers.

As an aside, I think this is a good idea in any case since a fringe 
benefit is the removal of the requirement to use the process freezer in 
suspend to RAM...

> Stop transitioning Run->Forced Suspend. If you've got stuff stuck running
> then deal with it by constraining it to go idle or by blowing it out of
> the water. PM will then do the rest.

The problem is determining how to constrain it to go idle, where "idle" 
is defined as "Doesn't wake up until a wakeup event is received". It's 
acceptable for something to use as much CPU as it wants when the user is 
actively interacting with the device, but in most cases processes 
shouldn't be permitted to use any CPU when the session is idle. The 
question is how to implement something that allows a CPU-guzzling 
application to be idled without impairing its ability to process wakeup 
events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
