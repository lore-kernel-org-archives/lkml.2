Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab0E0R7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:59:32 -0400
Received: from www.tglx.de ([62.245.132.106]:53391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab0E0R73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:59:29 -0400
Date: Thu, 27 May 2010 19:59:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527172343.GB2468@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain>
References: <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org>
 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
 <20100527172343.GB2468@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:15:31PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > My question was about explicit suspend states, not implicitly handling 
> > > an identical state based on scheduler constraints. Suspend-as-a-C-state 
> > > isn't usable on x86 - you have to explicitly trigger it based on some 
> > 
> > And why not ? Just because suspend is not implemented as an ACPI
> > C-state ? 
> > 
> > Nonsense, if we want to push the system into suspend from the idle
> > state we can do that. It's just not implemented and we've never tried
> > to do it as it requires a non trivial amount of work, but I have done
> > it on an ARM two years ago as a prove of concept and it works like a
> > charm.
> 
> ACPI provides no guarantees about what level of hardware functionality 
> remains during S3. You don't have any useful ability to determine which 
> events will generate wakeups. And from a purely practical point of view, 
> since the latency is in the range of seconds, you'll never have a low 
> enough wakeup rate to hit it.

Right, it does not as of today. So we cannot use that on x86
hardware. Fine. That does not prevent us to implement it for
architectures which can do it. And if x86 comes to the point where it
can handle it as well we're going to use it. Where is the problem ? If
x86 cannot guarantee the wakeup sources it's not going to be used for
such devices. The kernel just does not provide the service for it, so
what ?
 
> > > policy. And if you want to be able to do that without risking the loss 
> > > of wakeup events then you need in-kernel suspend blockers.
> > 
> > Crap. Stop beating on those lost wakeup events. If we lose them then
> > the drivers are broken and do not handle the switch over correctly. Or
> > the suspend mechanism is broken as it does not evaluate the system
> > state correctly. Blockers are just papering over that w/o tackling the
> > real problem.
> 
> Ger;kljaserf;kljf;kljer;klj. Suspend blockers are the mechanism for the 
> driver to indicate whether the wakeup event has been handled. That's 
> what they're there for. The in-kernel ones don't paper over anything.

So the driver says: events have been handled. Neat.

Now if that crappy app does not use the user space blockers or is not
allowed to use them, then what are you guaranteeing ? All you
guarantee is that the application has emptied the input queue. Nothing
else. And that's the same as setting the QoS guarantee to NONE.

An application which uses the blocker is just holding off the system
from going into deep idle. Nothing which cannot be done today.

So the only thing you are imposing to app writers is to use an
interface which solves nothing and does not save you any power at
all. 

If the application drops the blocker after processing the event and
before it goes back to the read event then you just postpone the CPU
usage and therefor power consumption to a later point in time instead
of going back to the blocking read right away. 

Again what is it saving ?  NOTHING!  And for nothing you want to mess
up the kernel big time ?

Runnable tasks and QoS guarantees are the indicators whether you can
go to opportunistic suspend or not. Everything else is just window
dressing.

Thanks,

	tglx
