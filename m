Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2HNUnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:43:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:33194 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2HNUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:43:35 -0400
Date: Tue, 14 Aug 2012 22:43:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
In-Reply-To: <20120814191549.GX25632@google.com>
Message-ID: <alpine.LFD.2.02.1208142118060.32033@ionos>
References: <1344449428-24962-1-git-send-email-tj@kernel.org> <alpine.LFD.2.02.1208131720070.32033@ionos> <20120814191549.GX25632@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Tejun Heo wrote:
> On Tue, Aug 14, 2012 at 08:55:16PM +0200, Thomas Gleixner wrote:
> > > * mod_delayed_work() can't be used from IRQ handlers.
> > 
> > This function does not exist. So what?
> 
> It makes the workqueue users messy.  It's difficult to get completely
> correct and subtle errors are difficult to detect / verify.

Ah, the function which does not exist makes the users
messy. Interesting observation.
 
> > > * __cancel_delayed_work() can't use the usual try_to_grab_pending()
> > >   which handles all three states but instead only deals with the first
> > >   state using a separate implementation.  There's no way to make a
> > >   delayed_work not pending from IRQ handlers.
> > 
> > And why is that desired and justifies the mess you are trying to
> > create in the timer code?
> 
> Because API forcing its users to be messy is stupid.

That's not an answer to my question. Let me rephrase:

Why is it required to cancel delayed work from interupt handlers? Is
it just because people are doing stupid things or is there are real
requirement?

No API forces users to be messy. Most of the mess originates from
using the wrong mechanisms and then trying to work around that.

If you are trying to clean up mess which originates from there, then
you are just nurturing the abuse instead of fixing the underlying
design problems in the affected code pathes.
 
> > > * The context / behavior differences among cancel_delayed_work(),
> > >   __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
> > >   confusing (the first two are mostly historical tho).
> > 
> > We have a lot of subtle differences in interfaces for similar
> > reasons.
> 
> And we should work to make them better.

No objection, but not for the price of cluttering common and hot code
pathes with conditionals and special cases. There are always
situations where it's justified to have a special function which is
tailored for a particular context instead of making the common case
slow and ugly.

> > > This patchset implements irqsafe timers.  For an irqsafe timer, IRQ is
> > > not enabled from dispatch till the end of its execution making it safe
> > > to drain the timer regardless of context.  This will enable cleaning
> > > up delayed_work interface.
> > 
> > By burdening crap on the timer code. We had a similar context case
> > handling in the original hrtimers code and Linus went berserk on it.
> > There is no real good reason to reinvent it in a different flavour.
> > 
> > Your general approach about workqueues seems to be adding hacks into
> > other sensitive code paths [ see __schedule() ]. Can we please stop
> > that? workqueues are not so special to justify that.
> 
> The schedule thing worked out pretty well, didn't it?  If it improves

You know my opinion about it. It's still a fricking nightmare for RT
and aside of that I still don't see a proper justification for having
it in the guts of the scheduler.

> the kernel in general, I don't see why timer shouldn't participate in
> it.  Timer ain't that special either.  However, it does suck to add

I didn't say that timers are special and timers have been improved all
the time to make the life of their users simpler. Just there is a
subtle difference between making the life simpler and adding stuff
which is designed to work around shortcomings in other parts of the
kernel.

> one-off feature which isn't used by anyone else but I couldn't find a
> better way.
>  
> So, if you can think of something better, sure.  Let's see.
> 
> > Right now delayed work arms a timer, whose callback enqueues the work
> > and wakes the worker thread, which then executes the work.
> > 
> > So what about changing delayed_work into:
> > 
> > struct delayed_work {
> >        struct work_struct work;
> >        unsigned long expires;
> > };
> > 
> > Now when delayed work gets scheduled it gets enqueued into a separate
> > list in the workqueue core with the proper worker lock held. Then
> > check the expiry time of the new work against the current expiry time
> > of a timer in the worker itself.
> 
> Work items aren't assigned to worker on queue.  It's a shared worker
> pool.  Workers take work items when they can.

Then add it to the worker pool. It's an implementation detail not a
design problem.

> > If the new expiry time is after the
> > current expiry time, nothing to do. If the new expiry is before the
> > current expiry time or the timer is not armed, then (re)arm the timer.
> > 
> > When the timer expires it wakes the worker and that evaluates the
> > delayed list for expired works and executes them and rearms the timer
> > if necessary.
> 
> How are you gonna decide which worker a delayed work item should be
> queued on?  What if the work item before it takes a very long time to
> finish?  Do we migrate those work items to a different worker?

You're the expert on those worker details :)

> > To cancel delayed work you don't have to worry about the timer
> > callback being executed at all, simply because the timer callback is
> > just a wakeup of the worker and not fiddling with the work itself. If
> > the work is removed before the worker thread runs, life goes on as
> > usual.
> > 
> > So all you have to do is to remove the work from the delayed list. If
> > the timer is armed, just leave it alone and let it fire. Canceling
> > delayed work is probably not a high frequency operation.
> > 
> > In fact that would make cancel_delayed_work and cancel_work basically
> > the same operation.
> > 
> > I have no idea how many concurrent delayed works are on the fly, so I
> > can't tell whether a simple ordered list is sufficient or if you need
> > a tree which is better suited for a large number of sorted items. But
> > that's a trivial to solve detail.
> 
> Aside from work <-> worker association confusion, you're basically
> suggesting for workqueue to implement its own tvec_base in suboptimal
> way.  Doesn't make much sense to me.

Your approach of adding a special case timer for workqueues which
burdens all other users and opens another cans of worms of subtle bugs
in the timer code does not make any sense to me.

Further I did not say that you need to implement your own tvec_base
code into workqueues for that.

First of all you did not answer my question whether the delayed timer
based works are frequent enough to require something else than a
simple linked list which is evaluated by a worker thread for the next
expiry and the code which adds a new work just checks the cached next
expiry value. If you have the requirement of serving tons of those
delayed works, then you have the choice of using a set of ready to use
library function which just needs a litte tweakage to work with
jiffies instead of nsec based values.

Secondly and what's worse you are completely ignoring the fact that
the problem you are trying to solve is due to the disconnection of the
delayed work (pending on a timer) and the workqueue core.

The reason why you can't cancel/modify stuff is due to the locking
issues which arise due to del_timer_sync() in the current design.

So instead of thinking about the shortcomings of your own design you
want to force extra cases into the core timer code as you see fit. 

And looking at the use cases:

 block/blk-core.c                    |    6 ++----
 block/blk-throttle.c                |    7 +------
 drivers/block/floppy.c              |    3 +--
 drivers/infiniband/core/mad.c       |   14 +++++---------
 drivers/input/keyboard/qt2160.c     |    3 +--
 drivers/input/mouse/synaptics_i2c.c |    7 +------
 net/core/link_watch.c               |   21 ++++++---------------

It's not that impressive and I really want to see a detailed analysis
why all of this is necessary in the first place before we add special
cases to the core timer infrastucture.

You can strike drivers/block/floppy.c, drivers/input/keyboard/qt2160.c
and drivers/input/mouse/synaptics_i2c.c from that argument list as
they are really not interesting at all either due to being obsolete or
a complete mess to begin with.

For the others please bring up proper arguments why we need this
special casing and why those things can't do with other mechanisms.

Thanks,

	tglx



