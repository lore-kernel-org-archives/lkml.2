Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab1FVUPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:15:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:42647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1FVUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:15:18 -0400
Date: Wed, 22 Jun 2011 22:15:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] sched: Separate the scheduler entry for preemption
In-Reply-To: <4E0245A1.3090903@kernel.dk>
Message-ID: <alpine.LFD.2.02.1106222211140.11814@ionos>
References: <20110622174659.496793734@linutronix.de> <20110622174918.813258321@linutronix.de> <20110622184328.GA6475@infradead.org> <4E0245A1.3090903@kernel.dk>
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

> On 2011-06-22 20:43, Christoph Hellwig wrote:
> > On Wed, Jun 22, 2011 at 05:52:13PM -0000, Thomas Gleixner wrote:
> >> Block-IO and workqueues call into notifier functions from the
> >> scheduler core code with interrupts and preemption disabled. These
> >> calls should be made before entering the scheduler core.
> >>
> >> To simplify this, separate the scheduler core code into
> >> __schedule(). __schedule() is directly called from the places which
> >> set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
> >> checks into schedule(), so they are only called when a task voluntary
> >> goes to sleep.
> > 
> > I don't think that works.  We'll need to flush the block requests even
> > for an involuntary schedule.
> 
> Yep, doing it just for voluntary schedule() is pointless, since the
> caller should just do the flushing on his own. The whole point of the
> sched hook was to ensure that involuntary schedules flushed it.

I guess we talk about different things here. The involuntary is when
you are preempted, which keeps state unchanged and the current code
already excludes that case.

If you block on a mutex, semaphore, completion or whatever that's a
different thing. That code calls schedule() not __schedule() and that
will flush your stuff as it does now.

Thanks,

	tglx
