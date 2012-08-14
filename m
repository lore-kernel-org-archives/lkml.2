Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2HNTP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:15:57 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52810 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2HNTPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:15:55 -0400
Date: Tue, 14 Aug 2012 12:15:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814191549.GX25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <alpine.LFD.2.02.1208131720070.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208131720070.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Tue, Aug 14, 2012 at 08:55:16PM +0200, Thomas Gleixner wrote:
> > * mod_delayed_work() can't be used from IRQ handlers.
> 
> This function does not exist. So what?

It makes the workqueue users messy.  It's difficult to get completely
correct and subtle errors are difficult to detect / verify.

> > * __cancel_delayed_work() can't use the usual try_to_grab_pending()
> >   which handles all three states but instead only deals with the first
> >   state using a separate implementation.  There's no way to make a
> >   delayed_work not pending from IRQ handlers.
> 
> And why is that desired and justifies the mess you are trying to
> create in the timer code?

Because API forcing its users to be messy is stupid.

> > * The context / behavior differences among cancel_delayed_work(),
> >   __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
> >   confusing (the first two are mostly historical tho).
> 
> We have a lot of subtle differences in interfaces for similar
> reasons.

And we should work to make them better.

> > This patchset implements irqsafe timers.  For an irqsafe timer, IRQ is
> > not enabled from dispatch till the end of its execution making it safe
> > to drain the timer regardless of context.  This will enable cleaning
> > up delayed_work interface.
> 
> By burdening crap on the timer code. We had a similar context case
> handling in the original hrtimers code and Linus went berserk on it.
> There is no real good reason to reinvent it in a different flavour.
> 
> Your general approach about workqueues seems to be adding hacks into
> other sensitive code paths [ see __schedule() ]. Can we please stop
> that? workqueues are not so special to justify that.

The schedule thing worked out pretty well, didn't it?  If it improves
the kernel in general, I don't see why timer shouldn't participate in
it.  Timer ain't that special either.  However, it does suck to add
one-off feature which isn't used by anyone else but I couldn't find a
better way.

So, if you can think of something better, sure.  Let's see.

> Right now delayed work arms a timer, whose callback enqueues the work
> and wakes the worker thread, which then executes the work.
> 
> So what about changing delayed_work into:
> 
> struct delayed_work {
>        struct work_struct work;
>        unsigned long expires;
> };
> 
> Now when delayed work gets scheduled it gets enqueued into a separate
> list in the workqueue core with the proper worker lock held. Then
> check the expiry time of the new work against the current expiry time
> of a timer in the worker itself.

Work items aren't assigned to worker on queue.  It's a shared worker
pool.  Workers take work items when they can.

> If the new expiry time is after the
> current expiry time, nothing to do. If the new expiry is before the
> current expiry time or the timer is not armed, then (re)arm the timer.
> 
> When the timer expires it wakes the worker and that evaluates the
> delayed list for expired works and executes them and rearms the timer
> if necessary.

How are you gonna decide which worker a delayed work item should be
queued on?  What if the work item before it takes a very long time to
finish?  Do we migrate those work items to a different worker?

> To cancel delayed work you don't have to worry about the timer
> callback being executed at all, simply because the timer callback is
> just a wakeup of the worker and not fiddling with the work itself. If
> the work is removed before the worker thread runs, life goes on as
> usual.
> 
> So all you have to do is to remove the work from the delayed list. If
> the timer is armed, just leave it alone and let it fire. Canceling
> delayed work is probably not a high frequency operation.
> 
> In fact that would make cancel_delayed_work and cancel_work basically
> the same operation.
> 
> I have no idea how many concurrent delayed works are on the fly, so I
> can't tell whether a simple ordered list is sufficient or if you need
> a tree which is better suited for a large number of sorted items. But
> that's a trivial to solve detail.

Aside from work <-> worker association confusion, you're basically
suggesting for workqueue to implement its own tvec_base in suboptimal
way.  Doesn't make much sense to me.

Thanks.

-- 
tejun
