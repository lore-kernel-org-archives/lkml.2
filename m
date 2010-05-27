Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0E0UY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:24:58 -0400
Received: from www.tglx.de ([62.245.132.106]:47557 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0E0UY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:24:56 -0400
Date: Thu, 27 May 2010 22:23:50 +0200 (CEST)
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
In-Reply-To: <20100527190622.GB5703@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005272207500.3032@localhost.localdomain>
References: <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org>
 <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain> <20100527182633.GN3543@srcf.ucam.org> <alpine.LFD.2.00.1005272027560.3032@localhost.localdomain>
 <20100527190622.GB5703@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 08:53:11PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > We were talking about PCs. Suspend-as-c-state is already implemented for 
> > > OMAP.
> >  
> > Ah, now we talk about PCs. And all of a sudden the problem of the
> > unability of determining wakeup sources is not longer relevant ? So
> > how do you guarantee that we don't miss one if we cant figure out
> > which ones are kept alive in S3 ?
> 
> A wakeup event is defined as one that wakes the system - if a system 
> can't be woken by a specific event then it's impossible to lose it, 
> since it wasn't a wakeup event to begin with.

So where is the problem ?
 
> > > > So the only thing you are imposing to app writers is to use an
> > > > interface which solves nothing and does not save you any power at
> > > > all. 
> > > 
> > > It's already been demonstrated that the Android approach saves power.
> > 
> > Demonstrated ? Care to explain me how it makes a difference:
> > 
> > while (1) {
> >   block();
> >   read();
> >   process_event();
> >   unblock();
> > 		---> suspend
> > 		<--- resume
> >   do_crap();	1000000 cycles
> > }
> > 
> > vs.
> > 
> > while (1) {
> >   read();
> > 		---> suspend
> > 		<--- resume
> >   process_event();
> >   do_crap();	1000000 cycles
> > }
> > 
> > You spend the damned 10000000 cycles in any case just at a different
> > point in time. So if you are so convinced and have fully understood
> > all the implications, please enlighten me why do_crap() costs less
> > power with the blockers approach.
> 
> Consider the case where the read() is non-blocking.

Which I consider in the same range as the application which does:

      while (1);

> > 1) The kernel blocker does not guarantee that the lousy app has
> >    processed the event. It just guarantees that the lousy app has
> >    emptied the input queue. So what's the point of the kernel blocker
> >    in that case ?
> 
> Yes, I think you're right here. You need the userspace component as well 
> for this to work correctly.
>
> > 2) What's the difference on setting that app to QoS(NONE) and let the
> >    kernel happily ignore it.
> 
> What sets that flag, and how does it interact with an application that 
> never makes a blocking system call?

  QoS(NONE) would be default policy for untrusted apps in the same way
  as you'd refuse the usage of supsend blockers for untrusted apps.
  
  while (1); is definitely not an application which should be granted
  trusted rights, right ?

  block_suspend(); while(1);
  
  is the same as:

  QoS(minimal latency); while(1);

  So if you really go to trust an "while (1);" application you better
  make sure that this app has the appropriate QoS(NONE) or QoS(10s)
  call in it before letting it lose.
 
> > Come up with real explanations and numbers and not just the "it has
> > been demonstrated" chant which is not holding water if you look at the
> > above.
> 
> The numbers were earlier in the thread.

  Numbers, yes. But I really give a sh*t about numbers w/o a detailed
  explanation of the scenario which created those numbers. And if the
  numbers boil down to: we handle the untrusted app which does "while
  (1);" then they are absolutely useless.

> > The kernel history is full of examples where crappy solutions got
> > rejected and kept out of the kernel for a long time even if there was
> > a need for them in the application field and they got shipped in
> > quantities with out of tree patches (NOHZ, high resolution timers,
> > ...). At some point people stopped arguing for crappy solutions and
> > sat down and got it right. The problem of power management and
> > opportunistic suspend is not different in any way.
> 
> Yes, and I'd agree with this if anyone seemed to have any idea how to do 
> it right. But despite all the heat and noise in this thread, all we've 
> got is an expression that it should be handled by the scheduler (a 
> viewpoint I agree with) without any explanation of how to switch 
> policies in such a way that applications idle without losing wakeup 
> events.

Why in the world should they lose wakeup events ? If an app goes idle,
it goes idle because it is waiting for an event. There is no other
sane reason except for those apps which are untrusted and force
idled. And for those you agreed already the suspend blockers don't
solve anything as they are either not implemented or the app is not
trusted to use them.

So we are back to round one of the whole discussion:

   Is it worth to create an utter mess in the kernel just to handle a
   subset of crappy coded applications ?

And the answer stays the same: No, not at all.

Thanks,

	tglx
