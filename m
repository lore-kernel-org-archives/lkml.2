Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2JIQTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:19:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:39185 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2JIQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:19:34 -0400
Date: Tue, 9 Oct 2012 18:19:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
In-Reply-To: <1349795389.24256.20.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210091811540.10988@ionos>
References: <alpine.LFD.2.02.1210091535140.10988@ionos> <1349795389.24256.20.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Steven Rostedt wrote:
> On Tue, 2012-10-09 at 15:46 +0200, Thomas Gleixner wrote:
> >      So instead of splitting the softirq threads I split the softirq
> >      locks so different softirqs can be handled seperately. If a
> >      softirq is raised in the context of a thread, then its noted in
> >      the task struct and when the thread leaves the bh disabled
> >      section it handles this particular soft interrupt in its own
> >      context. This removes the burden of running completely unrelated
> >      softirqs like timers, tasklets etc. from a context which raised a
> >      network soft interrupt. That way the softirq processing is
> >      coupled to the originating thread and its scheduling properties,
> >      so the need for finding optimal parameters should be gone.
> 
> Very interesting. I haven't looked at the patches yet (will do that
> after I finish with the stable merge releases), but I started looking
> into the softirq changes as well, and came up with something almost
> identical. I talked a little with Carsten about this, and he told me to
> wait for your release, which I then did, and I'm glad I did :-)
> 
> I was looking specifically at the network softirqs as well, and started
> some patches to separate out the softirqs with the task (sounds similar
> to what you did). But before that, I also played with the
> local_softirq_lock. For the end of interrupt processing only (where it
> should always be safe to lock), if the trylock fails, I grabbed it and
> then released it. Because if a lower priority task is currently running
> the softirq that the higher priority interrupt wants to run, it would at
> least priority boost the lower thread, and the higher priority interrupt
> could run its softirq at its priority. Maybe this can still be added?

I take the lock unconditionally now on local_bh_enable() to enforce
exactly that behaviour. That's what Carsten needs for his
deterministic networking stuff and my goal was zero configuration. Well,
it's not zero as you still have to get the priorities of the app and the
network irq thread straight, but the extra softirq fiddling is gone.

> >      Now this only works for soft interrupts which are raised in the
> >      context of a thread. Unfortunately there is no way to do the same
> >      for soft interrupts which are raised in hard interrupt context
> >      (e.g. RCU, timers). They have no thread associated and are
> >      therefor delegated to ksoftirqd. This is ok, except that it does
> >      not help people who want to use signal based timers, but that
> >      problem needs to be solved by moving the complex handling into
> >      the context of the thread which is going to receive the signal
> >      and should vanish from the softirq processing completely.
> >      
> >      In principle we should have even in mainline a clear separation
> >      of which soft interrupts are disabled by a particular code region
> >      instead of disabling them wholesale. Though the nicest solution
> >      would be to get rid of them completely :)
> 
> I've started looking at playing with the NAPI code again, and trying to
> see if I can add an ENAPI interface (Even Newer API), where the driver
> uses its own interrupt thread, and instead of having the polling in the
> network softirq, it can do the polling in its own thread.

It's pretty close to the behaviour I enforced with this change. Let's
play with that and figure out what influence it has on the network
throughput performance on RT. That needs probably a different
scheduling scheme than what Carsten needs for his deterministic
behaviour.

Thanks,

	tglx
