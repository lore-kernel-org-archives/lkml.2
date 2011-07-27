Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1G0WSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:18:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:44881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1G0WR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:17:56 -0400
Date: Thu, 28 Jul 2011 00:17:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <alpine.DEB.2.00.1107271542530.17752@router.home>
Message-ID: <alpine.LFD.2.02.1107280006510.2660@ionos>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins>  <alpine.DEB.2.00.1107270904290.9418@router.home> <1311783616.5890.178.camel@twins> <alpine.DEB.2.00.1107271204260.13058@router.home>
 <alpine.LFD.2.02.1107271919500.2660@ionos> <alpine.DEB.2.00.1107271542530.17752@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Christoph Lameter wrote:
> On Wed, 27 Jul 2011, Thomas Gleixner wrote:
> 
> > > The key issue is that the -rt kernel has always had grave issues with
> > > performance when it comes to per cpu data access. Solving that by forcing
> > > the kernel to go slow it not the right approach.
> >
> > Nobody want's the kernel to go slow. All we want and we consider that
> > also a benefit for mainline is: proper annotation of the per cpu data
> > access, like we have for RCU and for locking.
> 
> I love that stuff.
> 
> > For -rt this lack of documentation and the lack of verification,
> > debugability and traceability is a major PITA, but that's true for
> > non-rt as well, just the PITA is gradually smaller and the bugs which
> > are there today are just extremly hard to trigger.
> 
> Right. Sure wish there would be better checks. Or things would not have so
> many flavors.
> 
> > And Peters idea of per_cpu_lock*() annotations will boil down to the
> > exact same thing which is there today when you compile the kernel w/o
> > lockdep enabled for per_cpu data correctness. We don't want to change
> > anything or impose any slowness, we just want a proper way to document
> > and verify that maze. That's really not too much of a request.
> 
> No problem with that. The per cpu atomic ops are made to mostly stand on
> their own. However, the correctness is affected by placementin the per cpu
> sections that may start with get_cpu() or a preempt_disable().
> 
> The reason that I switched from get_cpu() to preempt_disable() in some
> functions was because the this_cpu operations eliminated the need to pass
> the cpu number to a function. Thus the cpu variable is not needed anymore.
> Preempt_disable() doesnt provide it and so I thought that was the proper
> function to use.

Yes, you had no other choice, but that does not make them more obvious
in terms of debugability and verification.

We just have to understand, that preempt_disable, bh_disable,
irq_disable are cpu local BKLs with very subtle semantics which are
pretty close to the original BKL horror. All these mechanisms are per
cpu locks in fact and we need to get some annotation in place which
will help understandability and debugability in the first place. The
side effect that it will help RT to deal with that is - of course
desired from our side - but not the primary goal of that excercise.

Thanks,

	tglx
