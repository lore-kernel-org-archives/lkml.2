Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab0E0RQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:16:34 -0400
Received: from www.tglx.de ([62.245.132.106]:34078 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0E0RQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:16:32 -0400
Date: Thu, 27 May 2010 19:15:31 +0200 (CEST)
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
In-Reply-To: <20100527165931.GB1062@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
References: <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
 <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
 <20100527165931.GB1062@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 06:45:25PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > No. Suspend blockers are designed to ensure that suspend isn't racy with 
> > > respect to wakeup events. The bit that mitigates badly written 
> > > applications is the bit where the scheduler doesn't run any more.
> > > 
> > > If you're happy with a single badly written application being able to 
> > > cripple your power management story, you don't need opportunistic 
> > > suspend. But you still have complications when it comes to deciding to 
> > > enter suspend at the same time as you receive a wakeup event.
> > 
> > Wrong. Setting the QoS requirements of the badly written app to any
> > latency will allow the kernel to suspend even if the crappy app is
> > active.
> 
> That's not what I want if I'm using the app at the time...

Your crappy app does not use suspend blockers either.
 
> > And again. I'm opposing the general chant that fixing crappy
> > applications in the kernel is a good thing. It's the worst decision we
> > could make.
> 
> You still need the in-kernel suspend blockers if you want to guarantee 
> that you can't lose wakeup events. But yes, if you're not concerned 
> handling badly behaved applications then I believe that you can lose 
> opportunistic suspend and just use the scheduler.

No, we do not. We need correctly implemented drivers and a safe
switchover from normal event delivery to wakeup based.
 
> > The whole notion of treating suspend to RAM any different than a plain
> > idle C-State is wrong. It's not different at all. You just use a
> > different mechanism which has longer takedown and wakeup latencies and
> > requires to shut down stuff and setup extra wakeup sources.
> 
> My question was about explicit suspend states, not implicitly handling 
> an identical state based on scheduler constraints. Suspend-as-a-C-state 
> isn't usable on x86 - you have to explicitly trigger it based on some 

And why not ? Just because suspend is not implemented as an ACPI
C-state ? 

Nonsense, if we want to push the system into suspend from the idle
state we can do that. It's just not implemented and we've never tried
to do it as it requires a non trivial amount of work, but I have done
it on an ARM two years ago as a prove of concept and it works like a
charm.

> policy. And if you want to be able to do that without risking the loss 
> of wakeup events then you need in-kernel suspend blockers.

Crap. Stop beating on those lost wakeup events. If we lose them then
the drivers are broken and do not handle the switch over correctly. Or
the suspend mechanism is broken as it does not evaluate the system
state correctly. Blockers are just papering over that w/o tackling the
real problem.

> > So if we really sit back and look at suspend as another idle state,
> > then we have first off the same requirements for entering it as we
> > have for any other idle state:
> 
> There are various platforms where we cannot treat suspend as an idle 
> state. Any solution that requires that doesn't actually solve the 
> problem. Yes, this is *trivial* if you can depend on the scheduler. But 
> we can't, and so it's difficult.

Stop handwaving. Which platforms prevent us to go into suspend from
idle ? Please point me to the relevant documentation which says so.

Just because we have not tried to implemented it does not mean that we
cannot implement it.

Thanks,

	tglx


