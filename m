Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2EHSGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:06:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50428 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2EHSGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:06:05 -0400
Date: Tue, 8 May 2012 11:05:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
In-Reply-To: <1336482202.16236.29.camel@twins>
Message-ID: <alpine.LSU.2.00.1205081032420.4071@eggly.anvils>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils> <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Peter Zijlstra wrote:
> On Mon, 2012-05-07 at 10:57 -0700, Tejun Heo wrote:
> > (cc'ing Peter and Ingo and quoting whole body)
> > 
> > On Mon, May 07, 2012 at 10:19:09AM -0700, Hugh Dickins wrote:
> > > Running MM load on recent linux-nexts (e.g. 3.4.0-rc5-next-20120504),
> > > with CONFIG_PROVE_LOCKING=y, I've been hitting an oops in __lock_acquire
> > > called from lock_acquire called from process_one_work: serving mm/swap.c's
> > > lru_add_drain_all - schedule_on_each_cpu(lru_add_drain_per_cpu).
> > > 
> > > In each case the oopsing address has been ffffffff00000198, and the
> > > oopsing instruction is the "atomic_inc((atomic_t *)&class->ops)" in
> > > __lock_acquire: so class is ffffffff00000000.
> > > 
> > > I notice Stephen's commit 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a
> > > workqueue: Catch more locking problems with flush_work()
> > > in linux-next but not 3.4-rc, adding
> > > 	lock_map_acquire(&work->lockdep_map);
> > > 	lock_map_release(&work->lockdep_map);
> > > to flush_work.
> > > 
> > > I believe that occasionally races with your
> > > 	struct lockdep_map lockdep_map = work->lockdep_map;
> > > in process_one_work, putting an entry into the class_cache
> > > just as you're copying it, so you end up with half a pointer.
> > > yes, the structure copy is using "rep movsl" not "rep movsq".
> 
> But the copy is copying from work->lockdep_map, not to, so it doesn't
> matter does it?

It doesn't matter to work->lockdep_map, it matters to the lockdep_map
on process_one_work()'s stack.

> If anything would explode it would be the:
> 
>   lock_map_acquire(&lockdep_map);

Yes, on line 1867 of the rc5-next-2012504 kernel/workqueue.c (line 1864
in rc6).  I have not noted down the offset in process_one_work() at which
it crashed (calling lock_acquire calling __lock_acquire), so cannot
reconfirm, but I believe that's the lock_acquire() I tracked it to.

> 
> because that's the target of the copy and could indeed observe a partial
> update (assuming the reported but silly "rep movsl").

When the racing copy is done earlier with "rep movsl", the bogus pointer
ffffffff00000000 is put in class_cache[N].  Then when it comes to
lock_map_acquire(&lockdep_map) here, it oopses on it.

Do you see it now?  (It's always hard to understand misunderstandings ;)

> 
> > The offending commit is 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a
> > "workqueue: Catch more locking problems with flush_work()".  It sounds
> > fancy but all it does is adding the following to flush_work().
> > 
> > 	lock_map_acquire(&work->lockdep_map);
> > 	lock_map_release(&work->lockdep_map);
> > 
> > Which seems correct to me and more importantly not different from what
> > wait_on_work() does, so if this is broken, flush_work_sync() and
> > cancel_work_sync() are broken too - probably masked by lower usage
> > frequency.
> > 
> > It seems the problem stems from how process_one_work() "caches"
> > lockdep_map.  This part predates cmwq changes but it seems necessary
> > because the work item may be freed during execution but lockdep_map
> > should be released after execution is complete.
> 
> Exactly.
> 
> >   Peter, do you
> > remember how this lockdep_map copying is added?  Is (or was) this
> > correct?  If it's broken, how do we fix it?  Add a lockdep_map copy
> > API which does some magic lockdep locking dancing?
> 
> I think there's a problem if indeed we do silly things like small copies
> like Hugh saw (why would gcc ever generate small copies for objects that
> are naturally aligned and naturally sized?).

I don't know.  gcc 4.5.1 here.  The structure is only 32 bytes, maybe
there's some advantage to copying that with movl rather than movq.

> 
> Something like the below should fix that problem, but it doesn't explain
> the observed issue..
> 
> ---
>  include/linux/lockdep.h |   19 +++++++++++++++++++
>  kernel/timer.c          |    2 +-
>  kernel/workqueue.c      |    2 +-
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index d36619e..dc6661b 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -157,6 +157,25 @@ struct lockdep_map {
>  #endif
>  };
>  
> +static inline struct lockdep_map lockdep_copy_map(struct lockdep_map *lock)

Does that "inline" need to be
"__this_will_go_very_horribly_wrong_if_not_inline"?

Ah, looks like Tejun suggests a more conventional interface in his reply.

> +{
> +	struct lockdep_map _lock = *lock;
> +	int i;
> +
> +	/*
> +	 * Since the class cache can be modified concurrently we could observe
> +	 * half pointers (64bit arch using 32bit copy insns). Therefore clear
> +	 * the caches and take the performance hit.
> +	 *
> +	 * XXX it doesn't work well with lockdep_set_class_and_subclass(), since
> +	 *     that relies on cache abuse.
> +	 */
> +	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
> +		_lock.class_cache[i] = NULL;
> +
> +	return _lock;
> +}
> +
>  /*
>   * Every lock has a list of other locks that were taken after it.
>   * We only grow the list, never remove from it:
> diff --git a/kernel/timer.c b/kernel/timer.c
> index a297ffc..fa98821 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1102,7 +1102,7 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
>  	 * warnings as well as problems when looking into
>  	 * timer->lockdep_map, make a copy and use that here.
>  	 */
> -	struct lockdep_map lockdep_map = timer->lockdep_map;
> +	struct lockdep_map lockdep_map = lockdep_map_copy(&timer->lockdep_map);
>  #endif
>  	/*
>  	 * Couple the lock chain with the lock chain at
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5abf42f..5d92b43 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1810,7 +1810,7 @@ __acquires(&gcwq->lock)
>  	 * lock freed" warnings as well as problems when looking into
>  	 * work->lockdep_map, make a copy and use that here.
>  	 */
> -	struct lockdep_map lockdep_map = work->lockdep_map;
> +	struct lockdep_map lockdep_map = lockdep_copy_map(&work->lockdep_map);
>  #endif
>  	/*
>  	 * A single work shouldn't be executed concurrently by
