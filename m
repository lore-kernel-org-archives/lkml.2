Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2HNSzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:55:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:60953 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2HNSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:55:22 -0400
Date: Tue, 14 Aug 2012 20:55:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <1344449428-24962-1-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.02.1208131720070.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Tejun Heo wrote:
> Timer internals are protected by irqsafe lock but the lock is
> naturally dropped and irq enabled while a timer is executed.  This
> makes dequeueing timer for execution and the actual execution
> non-atomic against IRQs.  No matter what the timer function does, IRQs
> can occur between timer dispatch and execution.  This means that an
> IRQ handler could interrupt any timer in progress and it's impossible
> for an IRQ handler to cancel and drain a timer.
> 
> This restriction manifests as ugly convolutions in workqueue
> delayed_work interface.  A !idle delayed_work is either on timer,
> being transferred from timer to worklist, on worklist, or executing.
> There are interfaces which need to cancel a pending delayed_work -
> cancel_delayed_work() and friends and mod_delayed_work().  They want
> to cancel a work item in the first three states but it's impossible to
> drain the second state from IRQ handlers which lead to the following
> oddities.
> 
> * mod_delayed_work() can't be used from IRQ handlers.

This function does not exist. So what?
 
> * __cancel_delayed_work() can't use the usual try_to_grab_pending()
>   which handles all three states but instead only deals with the first
>   state using a separate implementation.  There's no way to make a
>   delayed_work not pending from IRQ handlers.

And why is that desired and justifies the mess you are trying to
create in the timer code?

> * The context / behavior differences among cancel_delayed_work(),
>   __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
>   confusing (the first two are mostly historical tho).

We have a lot of subtle differences in interfaces for similar
reasons.

> This patchset implements irqsafe timers.  For an irqsafe timer, IRQ is
> not enabled from dispatch till the end of its execution making it safe
> to drain the timer regardless of context.  This will enable cleaning
> up delayed_work interface.

By burdening crap on the timer code. We had a similar context case
handling in the original hrtimers code and Linus went berserk on it.
There is no real good reason to reinvent it in a different flavour.

Your general approach about workqueues seems to be adding hacks into
other sensitive code paths [ see __schedule() ]. Can we please stop
that? workqueues are not so special to justify that.

The whole delayed work handling is a fragile construct due to the
combination of the timer and the work struct itself. As long as the
timer is pending the work is detached from the workqueue code and
that's what causes the issues at hand.

So rather than hacking special cases into the timer code, why can't we
manage those delayed works in the workqueue core itself and avoid the
whole timer dance?

Right now delayed work arms a timer, whose callback enqueues the work
and wakes the worker thread, which then executes the work.

So what about changing delayed_work into:

struct delayed_work {
       struct work_struct work;
       unsigned long expires;
};

Now when delayed work gets scheduled it gets enqueued into a separate
list in the workqueue core with the proper worker lock held. Then
check the expiry time of the new work against the current expiry time
of a timer in the worker itself. If the new expiry time is after the
current expiry time, nothing to do. If the new expiry is before the
current expiry time or the timer is not armed, then (re)arm the timer.

When the timer expires it wakes the worker and that evaluates the
delayed list for expired works and executes them and rearms the timer
if necessary.

To cancel delayed work you don't have to worry about the timer
callback being executed at all, simply because the timer callback is
just a wakeup of the worker and not fiddling with the work itself. If
the work is removed before the worker thread runs, life goes on as
usual.

So all you have to do is to remove the work from the delayed list. If
the timer is armed, just leave it alone and let it fire. Canceling
delayed work is probably not a high frequency operation.

In fact that would make cancel_delayed_work and cancel_work basically
the same operation.

I have no idea how many concurrent delayed works are on the fly, so I
can't tell whether a simple ordered list is sufficient or if you need
a tree which is better suited for a large number of sorted items. But
that's a trivial to solve detail.

Thoughts?

	tglx
