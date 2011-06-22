Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab1FVOCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:02:06 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:48269 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab1FVOCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:02:05 -0400
X-ASG-Debug-ID: 1308751321-01de280c1e73810001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E01F5D6.1020107@fusionio.com>
Date: Wed, 22 Jun 2011 16:01:58 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
References: <20110621233444.094372367@chello.nl> <20110621233648.806475812@chello.nl> <4E019353.6030902@fusionio.com> <alpine.LFD.2.02.1106221015320.11814@ionos>
X-ASG-Orig-Subj: Re: [RFC][PATCH 1/3] sched, block: Move unplug
In-Reply-To: <alpine.LFD.2.02.1106221015320.11814@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308751321
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66800
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 15:53, Thomas Gleixner wrote:
> On Wed, 22 Jun 2011, Jens Axboe wrote:
> 
>> On 2011-06-22 01:34, Peter Zijlstra wrote:
>>> Thomas found that we're doing a horrendous amount of work in that scheduler
>>> unplug hook while having preempt and IRQs disabled.
>>>
>>> Move it to the head of schedule() where both preemption and IRQs are enabled
>>> such that we don't get these silly long IRQ/preempt disable times.
>>>
>>> This allows us to remove a lot of special magic in the unplug path,
>>> simplifying that code as a bonus.
>>
>> The major change here is moving the queue running inline, instead of
>> punting to a thread. The worry is/was that we risk blowing the stack if
>> something ends up blocking inadvertently further down the call path.
> 
> Is that a real problem or just a "we have no clue what might happen"
> countermeasure? The plug list should not be magically refilled once
> it's split off so this should not recurse endlessly, right? If it does
> then we better fix it at the root cause of the problem and not by
> adding some last resort band aid into the scheduler code.

It is supposedly a real problem, not just an inkling. It's not about
recursing indefinitely, the plug is fairly bounded. But the IO dispatch
path can be pretty deep, and if you hit that deep inside the reclaim or
file system write path, then you get dangerously close. Dave Chinner
posted some numbers in the 2.6.39-rc1 time frame showing how close we
got.

The scheduler hook has nothing to do wit this, we need that regardless.
My objection was the conversion from async to sync run, something that
wasn't even mentioned in the patch description (yet it was the most
interesting part of the change).
According to eg 

> If the stack usage of that whole block code is the real issue, then we
> probably need to keep that "delegate to async" workaround [sigh!], but
> definitely outside of the scheduler core code.

Placement of the call is also orthogonal. The only requirements are
really:

- IFF the process is going to sleep, flush the plug list

Nothing more, nothing less. We can tolerate false positives, but as a
general rule it should only happen when the process goes to sleep.

>> Since it's the unlikely way to unplug, a bit of latency was acceptable
>> to prevent this problem.
> 
> It's not at all acceptable. There is no reason to hook stuff which
> runs perfectly fine in preemptible code into the irq disabled region
> of the scheduler internals.

We are talking past each other again. Flushing on going to sleep is
needed. Placement of that call was pretty much left in the hands of the
scheduler people. I personally don't care where it's put, as long as it
does what is needed.

>> I'm curious why you made that change? It seems orthogonal to the change
>> you are actually describing in the commit message.
> 
> Right, it should be split into two separate commits, one moving the
> stuff out from the irq disabled region and the other removing that
> from_schedule hackery. The latter can be dropped.

Exactly.

-- 
Jens Axboe

