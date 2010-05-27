Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0E0Q7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:59:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45549 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0E0Q7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:59:50 -0400
Date: Thu, 27 May 2010 17:59:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527165931.GB1062@srcf.ucam.org>
References: <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 06:45:25PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > No. Suspend blockers are designed to ensure that suspend isn't racy with 
> > respect to wakeup events. The bit that mitigates badly written 
> > applications is the bit where the scheduler doesn't run any more.
> > 
> > If you're happy with a single badly written application being able to 
> > cripple your power management story, you don't need opportunistic 
> > suspend. But you still have complications when it comes to deciding to 
> > enter suspend at the same time as you receive a wakeup event.
> 
> Wrong. Setting the QoS requirements of the badly written app to any
> latency will allow the kernel to suspend even if the crappy app is
> active.

That's not what I want if I'm using the app at the time...

> And again. I'm opposing the general chant that fixing crappy
> applications in the kernel is a good thing. It's the worst decision we
> could make.

You still need the in-kernel suspend blockers if you want to guarantee 
that you can't lose wakeup events. But yes, if you're not concerned 
handling badly behaved applications then I believe that you can lose 
opportunistic suspend and just use the scheduler.

> The whole notion of treating suspend to RAM any different than a plain
> idle C-State is wrong. It's not different at all. You just use a
> different mechanism which has longer takedown and wakeup latencies and
> requires to shut down stuff and setup extra wakeup sources.

My question was about explicit suspend states, not implicitly handling 
an identical state based on scheduler constraints. Suspend-as-a-C-state 
isn't usable on x86 - you have to explicitly trigger it based on some 
policy. And if you want to be able to do that without risking the loss 
of wakeup events then you need in-kernel suspend blockers.

> I'm starting to get really grumpy about the chant that suspend
> blockers are the only way to fix missed wakeups. That might be the
> only way you can think of with your pink android glasses on, but again
> this is not rocket science even if it does not fit into the current
> way the kernel handles the whole suspend mechanism.

I don't work for Google. I'm not an Android developer.

> So if we really sit back and look at suspend as another idle state,
> then we have first off the same requirements for entering it as we
> have for any other idle state:

There are various platforms where we cannot treat suspend as an idle 
state. Any solution that requires that doesn't actually solve the 
problem. Yes, this is *trivial* if you can depend on the scheduler. But 
we can't, and so it's difficult.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
