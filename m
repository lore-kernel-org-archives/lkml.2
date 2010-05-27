Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0E0TGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:06:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33429 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0E0TGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:06:43 -0400
Date: Thu, 27 May 2010 20:06:23 +0100
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
Message-ID: <20100527190622.GB5703@srcf.ucam.org>
References: <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain> <20100527182633.GN3543@srcf.ucam.org> <alpine.LFD.2.00.1005272027560.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272027560.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:53:11PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > We were talking about PCs. Suspend-as-c-state is already implemented for 
> > OMAP.
>  
> Ah, now we talk about PCs. And all of a sudden the problem of the
> unability of determining wakeup sources is not longer relevant ? So
> how do you guarantee that we don't miss one if we cant figure out
> which ones are kept alive in S3 ?

A wakeup event is defined as one that wakes the system - if a system 
can't be woken by a specific event then it's impossible to lose it, 
since it wasn't a wakeup event to begin with.

> > > So the only thing you are imposing to app writers is to use an
> > > interface which solves nothing and does not save you any power at
> > > all. 
> > 
> > It's already been demonstrated that the Android approach saves power.
> 
> Demonstrated ? Care to explain me how it makes a difference:
> 
> while (1) {
>   block();
>   read();
>   process_event();
>   unblock();
> 		---> suspend
> 		<--- resume
>   do_crap();	1000000 cycles
> }
> 
> vs.
> 
> while (1) {
>   read();
> 		---> suspend
> 		<--- resume
>   process_event();
>   do_crap();	1000000 cycles
> }
> 
> You spend the damned 10000000 cycles in any case just at a different
> point in time. So if you are so convinced and have fully understood
> all the implications, please enlighten me why do_crap() costs less
> power with the blockers approach.

Consider the case where the read() is non-blocking.

> 1) The kernel blocker does not guarantee that the lousy app has
>    processed the event. It just guarantees that the lousy app has
>    emptied the input queue. So what's the point of the kernel blocker
>    in that case ?

Yes, I think you're right here. You need the userspace component as well 
for this to work correctly.

> 2) What's the difference on setting that app to QoS(NONE) and let the
>    kernel happily ignore it.

What sets that flag, and how does it interact with an application that 
never makes a blocking system call?

> Come up with real explanations and numbers and not just the "it has
> been demonstrated" chant which is not holding water if you look at the
> above.

The numbers were earlier in the thread.

> The kernel history is full of examples where crappy solutions got
> rejected and kept out of the kernel for a long time even if there was
> a need for them in the application field and they got shipped in
> quantities with out of tree patches (NOHZ, high resolution timers,
> ...). At some point people stopped arguing for crappy solutions and
> sat down and got it right. The problem of power management and
> opportunistic suspend is not different in any way.

Yes, and I'd agree with this if anyone seemed to have any idea how to do 
it right. But despite all the heat and noise in this thread, all we've 
got is an expression that it should be handled by the scheduler (a 
viewpoint I agree with) without any explanation of how to switch 
policies in such a way that applications idle without losing wakeup 
events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
