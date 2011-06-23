Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab1FWJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:58:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:47025 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab1FWJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:58:15 -0400
Date: Thu, 23 Jun 2011 11:58:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
In-Reply-To: <20110623083722.GF30101@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1106231139270.11814@ionos>
References: <20110622174659.496793734@linutronix.de> <20110622174919.135236139@linutronix.de> <20110623083722.GF30101@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Tejun Heo wrote:

> Hello, Thomas.
> 
> The hooking place doesn't have anything to do with rq->lock.  The
> problem with Peter's patch was preemption, not the lock.

And we can do it w/o preemption disabled as I have shown.
 
> > There is also no harm from updating nr_running when the task returns
> > from scheduling instead of accounting it in the wakeup code.
> 
> Well, not exactly.  If CPU is being thrashed, we don't want to try to
> fire up new workers or calling in rescuers.  If nr_running is bumped
> up from ttwu(), a woken up but not yet running worker already counts
> as running.  With the suggested change, when we hit such heavy CPU
> thrashing, workqueue code will add things on top of it.

That's the whole problem with that self forking workqueue stuff and
I'm not accepting that ttwu() is the only solution to that. Following
that logic would just invite more abusers of callbacks into ttwu() and
if you think it through then the logical consequence is to have an
upcall hook into userspace so a threading/forking server knows how
many instances are on the fly to avoid creating new ones under
pressure.

Thanks,

	tglx
