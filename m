Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2HNVkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:40:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58678 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2HNVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:40:14 -0400
Date: Tue, 14 Aug 2012 14:40:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120814214009.GD25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <alpine.LFD.2.02.1208131720070.32033@ionos>
 <20120814191549.GX25632@google.com>
 <alpine.LFD.2.02.1208142118060.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208142118060.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Tue, Aug 14, 2012 at 10:43:30PM +0200, Thomas Gleixner wrote:
> > It makes the workqueue users messy.  It's difficult to get completely
> > correct and subtle errors are difficult to detect / verify.
> 
> Ah, the function which does not exist makes the users
> messy. Interesting observation.

Can we get a little less snarky please?  It's tiring.

Lack of mod_delayed_work() has been an annoyance for quite a few
users.  People use either explicit cancel + queue or separate timer +
work_struct to work around, or just side-step it in some other way.
In any case, they end up implementing it ad-hoc in their code.  Nasty.

> That's not an answer to my question. Let me rephrase:
> 
> Why is it required to cancel delayed work from interupt handlers? Is
> it just because people are doing stupid things or is there are real
> requirement?

That's pretty much like asking why does del_timer() need to be called
from IRQ context.  Workqueue is pretty extensively used from IRQ
handlers.  Queueing a work item from IRQ handlers is a pretty common
operation and modding / canceling pending delayed work items isn't
difficult to reach from there.  Can people live without it?  Sure,
people can live without pretty much anything, but it's just not good.

> No API forces users to be messy. Most of the mess originates from
> using the wrong mechanisms and then trying to work around that.
> 
> If you are trying to clean up mess which originates from there, then
> you are just nurturing the abuse instead of fixing the underlying
> design problems in the affected code pathes.

There are good APIs and bad APIs.  delayed_work is widely used and
unfortunately has complications which stem from implementation details
which force its users to work around the shortcomings on their own.
It's usually better to go some extra miles (it's not even that much
here) in the common API if that saves cruft in its many users.

> > > > * The context / behavior differences among cancel_delayed_work(),
> > > >   __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
> > > >   confusing (the first two are mostly historical tho).
> > > 
> > > We have a lot of subtle differences in interfaces for similar
> > > reasons.
> > 
> > And we should work to make them better.
> 
> No objection, but not for the price of cluttering common and hot code
> pathes with conditionals and special cases. There are always
> situations where it's justified to have a special function which is
> tailored for a particular context instead of making the common case
> slow and ugly.

I agree the addition isn't the prettiest thing in the world.  I tried
to implement it inside workqueue proper by trying to detect the case
where try_to_grab_pending() is called from an IRQ handler which
interrupted delayed_work_timer_fn() but I couldn't make it work
reliably in any sane way.  So, if you can come up with something
better, be my guest.  Short of that, I think adding irqsafe timer is a
reasonable trade-off.

> > The schedule thing worked out pretty well, didn't it?  If it improves
> 
> You know my opinion about it. It's still a fricking nightmare for RT
> and aside of that I still don't see a proper justification for having
> it in the guts of the scheduler.

I can imagine it sucking for RT but for mainline, we now have
self-regulating worker pool without huge and messy heuristics trying
to guesstimate what's going on and we need some sort of worker pool
mechanism in kernel.  It might not suit your fancy but it has been
working pretty well.

> > the kernel in general, I don't see why timer shouldn't participate in
> > it.  Timer ain't that special either.  However, it does suck to add
> 
> I didn't say that timers are special and timers have been improved all
> the time to make the life of their users simpler. Just there is a
> subtle difference between making the life simpler and adding stuff
> which is designed to work around shortcomings in other parts of the
> kernel.

The problem here is that it's really difficult to make delayed_work
(or any other generic construct wrapping timer) work properly (people
naturally expect similar behavior to timer) using the interface timer
currently exposes and it's not caused by some random limitation in
delayed_work implementation.  Until now, the burden has been
transferred to delayed_work users, which is rather sad.

So, I really don't think there's any fundamental conflict regarding
the basic direction.

> > Aside from work <-> worker association confusion, you're basically
> > suggesting for workqueue to implement its own tvec_base in suboptimal
> > way.  Doesn't make much sense to me.
> 
> Your approach of adding a special case timer for workqueues which
> burdens all other users and opens another cans of worms of subtle bugs
> in the timer code does not make any sense to me.

What kind of cans of worms would it open?

> First of all you did not answer my question whether the delayed timer
> based works are frequent enough to require something else than a
> simple linked list which is evaluated by a worker thread for the next
> expiry and the code which adds a new work just checks the cached next
> expiry value. If you have the requirement of serving tons of those
> delayed works, then you have the choice of using a set of ready to use
> library function which just needs a litte tweakage to work with
> jiffies instead of nsec based values.

Grep for delayed_work.  It can be as frequent as any timer.  Some
drivers use it to delay certain processing from IRQ handlers.  Block
layer uses it a lot to manage plugging and other delayed processing.
They can generate a lot of timer modifications.  It isn't different
from any timer.

Custom ad-hoc unscalable timer mechanism vs. single if().

> Secondly and what's worse you are completely ignoring the fact that
> the problem you are trying to solve is due to the disconnection of the
> delayed work (pending on a timer) and the workqueue core.

Alternatively, it's addressing timer's deficiency of not allowing
building other generic constructs on top of it.  It's not some black
or white thing.

> The reason why you can't cancel/modify stuff is due to the locking
> issues which arise due to del_timer_sync() in the current design.
> 
> So instead of thinking about the shortcomings of your own design you
> want to force extra cases into the core timer code as you see fit. 

No, the shortcoming is fundamental in the *timer* interface if you
want to build something which incorporates it and be able to present
the same timer-like behavior to its users.  Really, try it with the
current interface.

Now, whether being able to wrap timer to build something like
delayed_work is necessary could be debated.  Maybe everyone should
just use timer + work_struct directly, but I think it's a bit too late
to have that discussion and even if we aren't I think having
delayed_work is a good idea.

> And looking at the use cases:
> 
>  block/blk-core.c                    |    6 ++----
>  block/blk-throttle.c                |    7 +------
>  drivers/block/floppy.c              |    3 +--
>  drivers/infiniband/core/mad.c       |   14 +++++---------
>  drivers/input/keyboard/qt2160.c     |    3 +--
>  drivers/input/mouse/synaptics_i2c.c |    7 +------
>  net/core/link_watch.c               |   21 ++++++---------------

Hmmm?  The diffstat is more like,

 arch/powerpc/platforms/cell/cpufreq_spudemand.c |    2
 block/blk-core.c                                |    8 -
 block/blk-throttle.c                            |    7 -
 drivers/block/floppy.c                          |    5
 drivers/cpufreq/cpufreq_conservative.c          |    2
 drivers/cpufreq/cpufreq_ondemand.c              |    2
 drivers/devfreq/devfreq.c                       |    2
 drivers/infiniband/core/mad.c                   |   16 --
 drivers/input/keyboard/qt2160.c                 |    3
 drivers/input/mouse/synaptics_i2c.c             |    7 -
 drivers/net/ethernet/mellanox/mlx4/sense.c      |    2
 drivers/power/ab8500_btemp.c                    |    2
 drivers/power/ab8500_charger.c                  |    8 -
 drivers/power/ab8500_fg.c                       |    8 -
 drivers/power/abx500_chargalg.c                 |    4
 drivers/power/max17040_battery.c                |    2
 drivers/video/omap2/displays/panel-taal.c       |    6
 drivers/video/omap2/dss/dsi.c                   |    6
 mm/slab.c                                       |    2
 mm/vmstat.c                                     |    2
 net/core/link_watch.c                           |   21 ---
 net/core/neighbour.c                            |    2
 net/ipv4/inetpeer.c                             |    2
 net/sunrpc/cache.c                              |    2

and these are only the obvious conversions and aren't simple
conversions.  Now they behave *properly*.  If the user calls cancel,
the delayed_work is reliably canceled and mod_delayed_work()
*reliably* schedule the work item at the specified time regardless of
the current state of delayed_work.

> It's not that impressive and I really want to see a detailed analysis
> why all of this is necessary in the first place before we add special
> cases to the core timer infrastucture.
> 
> You can strike drivers/block/floppy.c, drivers/input/keyboard/qt2160.c
> and drivers/input/mouse/synaptics_i2c.c from that argument list as
> they are really not interesting at all either due to being obsolete or
> a complete mess to begin with.
> 
> For the others please bring up proper arguments why we need this
> special casing and why those things can't do with other mechanisms.

I think I've written enough here and in the commit message but to sum
up,

A single if() in timer enables,

* Quite a few cleanups.  I did only cancel + queue ones here.  There
  are some which were using explicit timer + work_struct.

* Much cleaner API which behaves reliably as expected, which makes
  delayed_work users life easier and reduces the possibility of subtle
  bugs.

Thanks.

-- 
tejun
