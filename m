Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0E0UjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:39:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51050 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0E0UjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:39:02 -0400
Date: Thu, 27 May 2010 21:38:43 +0100
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
Message-ID: <20100527203843.GA8395@srcf.ucam.org>
References: <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain> <20100527182633.GN3543@srcf.ucam.org> <alpine.LFD.2.00.1005272027560.3032@localhost.localdomain> <20100527190622.GB5703@srcf.ucam.org> <alpine.LFD.2.00.1005272207500.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272207500.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:23:50PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > A wakeup event is defined as one that wakes the system - if a system 
> > can't be woken by a specific event then it's impossible to lose it, 
> > since it wasn't a wakeup event to begin with.
> 
> So where is the problem ?

The problem is that, right now, if a wakeup event is received between 
the point where userspace decides to start a suspend and userspace 
actually starts a suspend, that event may not abort the suspend.

> > Consider the case where the read() is non-blocking.
> 
> Which I consider in the same range as the application which does:
> 
>       while (1);

Not at all. Depending on what it reads, it may follow some other path 
where it sleeps. But, as I keep saying, if you don't want to support 
that kind of code then all of this is massively easier.

> > What sets that flag, and how does it interact with an application that 
> > never makes a blocking system call?
> 
>   QoS(NONE) would be default policy for untrusted apps in the same way
>   as you'd refuse the usage of supsend blockers for untrusted apps.
>
>   while (1); is definitely not an application which should be granted
>   trusted rights, right ?

No, but if that while (1) is draw_cows() then the user may want this to 
run while their session is active and stop running while their session 
is idle. So you only want it to be QoS(NONE) in the idle session case. 
How do you change that state?
 
> > The numbers were earlier in the thread.
> 
>   Numbers, yes. But I really give a sh*t about numbers w/o a detailed
>   explanation of the scenario which created those numbers. And if the
>   numbers boil down to: we handle the untrusted app which does "while
>   (1);" then they are absolutely useless.

The tested case was a stock Android install with opportunistic suspend 
enabled and one that just used runtime idle. The lowest power state 
entered was the same on both.

> > Yes, and I'd agree with this if anyone seemed to have any idea how to do 
> > it right. But despite all the heat and noise in this thread, all we've 
> > got is an expression that it should be handled by the scheduler (a 
> > viewpoint I agree with) without any explanation of how to switch 
> > policies in such a way that applications idle without losing wakeup 
> > events.
> 
> Why in the world should they lose wakeup events ? If an app goes idle,
> it goes idle because it is waiting for an event. There is no other
> sane reason except for those apps which are untrusted and force
> idled. And for those you agreed already the suspend blockers don't
> solve anything as they are either not implemented or the app is not
> trusted to use them.
>
> So we are back to round one of the whole discussion:
> 
>    Is it worth to create an utter mess in the kernel just to handle a
>    subset of crappy coded applications ?
> 
> And the answer stays the same: No, not at all.

You need suspend blockers to avoid losing wakeups in the explicit 
suspend case even if you don't want to implement opportunistic suspend.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
