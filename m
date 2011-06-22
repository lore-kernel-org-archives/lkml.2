Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1FVNxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:53:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:46886 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:53:43 -0400
Date: Wed, 22 Jun 2011 15:53:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jens Axboe <jaxboe@fusionio.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
In-Reply-To: <4E019353.6030902@fusionio.com>
Message-ID: <alpine.LFD.2.02.1106221015320.11814@ionos>
References: <20110621233444.094372367@chello.nl> <20110621233648.806475812@chello.nl> <4E019353.6030902@fusionio.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Jens Axboe wrote:

> On 2011-06-22 01:34, Peter Zijlstra wrote:
> > Thomas found that we're doing a horrendous amount of work in that scheduler
> > unplug hook while having preempt and IRQs disabled.
> > 
> > Move it to the head of schedule() where both preemption and IRQs are enabled
> > such that we don't get these silly long IRQ/preempt disable times.
> > 
> > This allows us to remove a lot of special magic in the unplug path,
> > simplifying that code as a bonus.
> 
> The major change here is moving the queue running inline, instead of
> punting to a thread. The worry is/was that we risk blowing the stack if
> something ends up blocking inadvertently further down the call path.

Is that a real problem or just a "we have no clue what might happen"
countermeasure? The plug list should not be magically refilled once
it's split off so this should not recurse endlessly, right? If it does
then we better fix it at the root cause of the problem and not by
adding some last resort band aid into the scheduler code.

If the stack usage of that whole block code is the real issue, then we
probably need to keep that "delegate to async" workaround [sigh!], but
definitely outside of the scheduler core code.

> Since it's the unlikely way to unplug, a bit of latency was acceptable
> to prevent this problem.

It's not at all acceptable. There is no reason to hook stuff which
runs perfectly fine in preemptible code into the irq disabled region
of the scheduler internals.

> I'm curious why you made that change? It seems orthogonal to the change
> you are actually describing in the commit message.

Right, it should be split into two separate commits, one moving the
stuff out from the irq disabled region and the other removing that
from_schedule hackery. The latter can be dropped.

Thanks,

	tglx
