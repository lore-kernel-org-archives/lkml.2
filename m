Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab2ERG3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:29:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2ERG3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:29:52 -0400
Date: Fri, 18 May 2012 02:29:48 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 07/16] Closures
Message-ID: <20120518062948.GA21163@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <82f00ebb4ee0404788c5bd7fbfa1fe4969f28ba1.1336619038.git.koverstreet@google.com>
 <20120515224137.GA15386@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515224137.GA15386@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 03:41:37PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Wed, May 09, 2012 at 11:09:46PM -0400, Kent Overstreet wrote:
> > Closures are asynchronous refcounty things based on workqueues, used
> > extensively in bcache.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> Overall, I can't find myself liking this closure thing much.  It seems
> to be trying to roll too much into itself.  To me, it almost feels
> like some combination of semaphore and async execution with hierarchy
> and some other stuff thrown in for good measure.  Kernel moved away
> from semaphores for pretty good reasons.
> 
> I haven't seen the actual usages yet so my opinion might do a
> back-flip but for now I would much prefer something simpler -
> e.g. work item triggering mechanism which might include hierarchy
> support, some wrappers around wait_queue_head_t and so on.
> 
> Another concern that the terms and concepts introduced are foreign.
> When something gets executed asynchronously, we make that explicit.
> Such explicit bouncing tends to cause some tension especially in IO
> code paths which often end up doing stuff which might require sleeping
> without process context but it usually is manageable with sensible
> split between what gets done with and without process context.  Maybe
> having a mechanism to blur the distinction helps such situations
> enough to justify introduction of new constructs but I feel somewhat
> skeptical at this point.
> 
> So, those are my high level concerns.  I generally feel reserved about
> it.  Let's see whether that changes with the actual review of the
> usages.

Well, I can definitely understand your reservations about the code; it's
strange and foreign and complicated. But having beaten my head against
the various problems and difficulties inherent in asynchronous
programming for years - well, having found a way to make it sane to me
it'd be madness to go back.

And to me it's a small and elegant solution to a lot of nasty problems,
but I just don't know how to distill all that down and make it easy to
understand. Which is unfortunate.

That said, while IMO the basic concepts and the way it all fits together
is _elegant_ (seriously, watching code simplify as I've converted things
in bcache I hadn't considered originally to use bcache - it's been a
thing of beauty) - the whole thing is still evolving and rough in areas,
and I'm still looking for ways to simplify it.

The locking stuff still feels tacked on to me and somewhat inelegant -
insufficiently general, perhaps - but there's very strong motivations
for it. Until I or someone else comes up with something better, I'm
stuck with it but you can ignore it for the most part.

The closure_with_waitlist and closure_with_timer stuff I'm much happier
with, as they don't affect the base concepts and they just build off of
it relatively cleanly (at least conceptually), much like delayed work
items.

> > +struct closure;
> > +typedef void (closure_fn) (struct closure *);
> > +
> > +typedef struct llist_head	closure_list_t;
> 
> Please just use llist_head directly.

Don't want to do that because it really is a distinct type; however, it
shouldn't be a typedef since that doesn't actually get us typechecking.
I'll just make a struct closure_waitlist.

> > +#define CLOSURE_REMAINING_MASK	(~(~0 << 20))
> > +#define CLOSURE_GUARD_MASK					\
> > +	((1 << 20)|(1 << 22)|(1 << 24)|(1 << 26)|(1 << 28)|(1 << 30))
> > +
> > +	/*
> > +	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
> > +	 * closure_init() and when closure_put() runs then next function), and
> > +	 * must be cleared before remaining hits 0. Primarily to help guard
> > +	 * against incorrect usage and accidently transferring references.
> > +	 * continue_at() and closure_return() clear it for you, if you're doing
> > +	 * something unusual you can use closure_set_dead() which also helps
> > +	 * annotate where references are being transferred.
> > +	 *
> > +	 * CLOSURE_BLOCKING: Causes closure_wait_event() to block, instead of
> > +	 * waiting asynchronously
> > +	 *
> > +	 * CLOSURE_STACK: Sanity check - remaining should never hit 0 on a
> > +	 * closure with this flag set
> > +	 *
> > +	 * CLOSURE_WAITING: Set iff the closure is on a waitlist. Must be set by
> > +	 * the thread that owns the closure, and cleared by the thread that's
> > +	 * waking up the closure.
> > +	 *
> > +	 * CLOSURE_SLEEPING: Must be set before a thread uses a closure to sleep
> > +	 * - indicates that cl->task is valid and closure_put() may wake it up.
> > +	 * Only set or cleared by the thread that owns the closure.
> > +	 *
> > +	 * CLOSURE_TIMER: Analagous to CLOSURE_WAITING, indicates that a closure
> > +	 * has an outstanding timer. Must be set by the thread that owns the
> > +	 * closure, and cleared by the timer function when the timer goes off.
> > +	 */
> > +
> > +#define	CLOSURE_RUNNING		(1 << 21)
> > +#define	CLOSURE_BLOCKING	(1 << 23)
> > +#define CLOSURE_STACK		(1 << 25)
> > +#define	CLOSURE_WAITING		(1 << 27)
> > +#define	CLOSURE_SLEEPING	(1 << 29)
> > +#define	CLOSURE_TIMER		(1 << 31)
> > +	atomic_t		remaining;
> 
> So, these bits are to be set alonside refcnt in lower 20 bits and
> there are guard bits between flag bits to detect cases where flag
> modification over/underflow caused by atomic_add/sub(), right?
> Hmmmm... I *hope* it were something dumber, especially given that the
> flags seem to be mostly for debugging and it would be nice which ones
> are for debugging and which ones are actually necessary for operation
> with better overall explanation.

So, CLOSURE_RUNNING and CLOSURE_STACK are debugging aids - the rest are
not. I'll rearrange them to better distinguish that.

> Also, I personally don't like embedding constant definitions inside
> struct definition and wish these were defined outside as enums but
> that's just my preference.

I do tend to prefer defining constants next to the member they're
for when they're for only one thing, but it's not something I feel that
strongly about. Suppose it's big enough with the comments to justify
pulling out of struct closure into an enum.

> > +#ifdef CONFIG_DEBUG_CLOSURES
> > +#define CLOSURE_MAGIC_DEAD	0xc1054e0dead
> > +#define CLOSURE_MAGIC_ALIVE	0xc1054e0a11e
> > +
> > +	unsigned long		magic;
> > +	struct list_head	all;
> > +	unsigned long		ip;
> > +	unsigned long		waiting_on;
> > +#endif
> > +};
> 
> Maybe using debugobj is better for debugging object lifetime issues?

Quite possibly. I looked at it briefly and I was having trouble figuring
out how to use it, but I can take another look.

> > +#define __CL_TYPE(cl, _t)						\
> > +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> > +		? TYPE_ ## _t :						\
> > +
> > +#define __closure_type(cl)						\
> > +(									\
> > +	__CL_TYPE(cl, closure)						\
> > +	__CL_TYPE(cl, closure_with_waitlist)				\
> > +	__CL_TYPE(cl, closure_with_timer)				\
> > +	__CL_TYPE(cl, closure_with_waitlist_and_timer)			\
> > +	invalid_closure_type()						\
> > +)
> 
> Again, I with this were dumber and more conventional.  Not everything
> has to be smart and it's not like this can cover all cases anyway.
> What about INITIALIZERs?  I'd suggest just following what everyone
> else does.

Heh, that thing was kind of perverse. But we've got this 1:1 mapping
from types to enums, so it makes sense to consolidate that and not open
code it for each every type, IMO. I felt dirty after I wrote that,
though.

> > +#define closure_init_type(cl, parent, running, memset)		\
> > +do {								\
> > +	struct closure *_cl = __to_internal_closure(cl);	\
> > +	_cl->type = __closure_type(*(cl));			\
> > +	closure_set_ip(_cl);					\
> > +	do_closure_init(_cl, parent, running);			\
> > +} while (0)
> 
> Why is @memset unused?  And is it actually worth having a separate
> initializer to avoid memset?

I can't for the life of me remember what the memset parameter is doing
there. But at one point when I was working on bcache performance the
memset showed up enough in the profile to be worth it, yeah.

> > +/**
> > + * closure_sleep() - asynchronous sleep
> 
> Heh, I would much prefer delayed queue (or something along that line).
> Sleep has a lot of connotation attached to it and asynchronous sleep
> is way too confusing.

closure_delay(), maybe? Agreed about sleep.

> > +#define closure_flush(cl)				\
> > +	__closure_flush(__to_internal_closure(cl), &(cl)->timer)
> > +
> > +#define closure_flush_sync(cl)				\
> > +	__closure_flush_sync(__to_internal_closure(cl), &(cl)->timer)
> 
> Is this distinction really necessary?

Not sure. Haven't used that code much yet, it's definitely more
experimental than the rest.

> > +/**
> > + * closure_wake_up() - wake up all closures on a wait list.
> > + */
> > +static inline void closure_wake_up(closure_list_t *list)
> > +{
> > +	smp_mb();
> 
> Why is this mb() instead of wmb()?  Which barrier is it paired with?
> In general, please always annotate barrier pairs when using barriers.
> Nothing causes more head scratches than memory barriers without proper
> explanation.
> 
> > +	__closure_wake_up(list);

That one is for when you just made a condition true that another thread
is checking - the barrier is between whatever made the condition true
and the wakeup.

Uh, there should be a corresponding barrier in __closure_wait_event().
Now that I think about it though, probably neither are needed;
closure_wait() and __closure_wake_up() are lockless, but if memory
serves cmpxchg()/xchg() imply full barriers, and it's just
atomic_xchg()/atomic_cmxchg() that don't - does that sound right to you?

> > +}
> > +
> > +/*
> > + * Wait on an event, synchronously or asynchronously - analagous to wait_event()
> > + * but for closures.
> > + *
> > + * The loop is oddly structured so as to avoid a race; we must check the
> > + * condition again after we've added ourself to the waitlist. We know if we were
> > + * already on the waitlist because closure_wait() returns false; thus, we only
> > + * schedule or break if closure_wait() returns false. If it returns true, we
> > + * just loop again - rechecking the condition.
> > + *
> > + * The __closure_wake_up() is necessary because we may race with the event
> > + * becoming true; i.e. we see event false -> wait -> recheck condition, but the
> > + * thread that made the event true may have called closure_wake_up() before we
> > + * added ourself to the wait list.
> > + *
> > + * We have to call closure_sync() at the end instead of just
> > + * __closure_end_sleep() because a different thread might've called
> > + * closure_wake_up() before us and gotten preempted before they dropped the
> > + * refcount on our closure. If this was a stack allocated closure, that would be
> > + * bad.
> > + */
> > +#define __closure_wait_event(list, cl, condition, _block)		\
> > +({									\
> > +	__label__ out;							\
> > +	bool block = _block;						\
> 
> What if @condition contains @block?  Local vars in macros better have
> long and ugly prefixes.

Yeah, good point.

> 
> > +	typeof(condition) ret;						\
> > +									\
> > +	while (!(ret = (condition))) {					\
> > +		if (block)						\
> > +			__closure_start_sleep(cl);			\
> > +		if (!closure_wait(list, cl)) {				\
> > +			if (!block)					\
> > +				goto out;				\
> > +			schedule();					\
> > +		}							\
> > +	}								\
> > +	__closure_wake_up(list);					\
> > +	if (block)							\
> > +		closure_sync(cl);					\
> > +out:									\
> 
> I suppose __label__ out decl makes this local somehow.  I'd *much*
> prefer if something this unusual wasn't used tho.

It does. I just rewrote it to not use the goto, but... eh, I think I
like the old version better. 

> > +static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
> > +				  struct workqueue_struct *wq)
> > +{
> > +	cl->fn = fn;
> > +	cl->wq = wq;
> > +	/* between atomic_dec() in closure_put() */
> > +	smp_mb__before_atomic_dec();
> 
> Please be more explicit.  I can't follow.

Thread 1 does set_closure_fn() then closure_put(), but remaining doesn't
go to 0 - thread 2 does closure_put() and remaining is now 0. Don't want
thread 2 to see the old fn/wq.

> > +#define continue_at(_cl, _fn, _wq, ...)					\
> > +do {									\
> > +	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
> > +	closure_set_ip(_cl);						\
> > +	set_closure_fn(_cl, _fn, _wq);					\
> > +	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
> > +	return __VA_ARGS__;						\
> > +} while (0)
> > +
> > +#define closure_return(_cl)	continue_at((_cl), NULL, NULL)
> 
> Umm... so, anything which wraps something which are baked into
> people's reflexes is a bad idea.  It might seem to increase
> writability or whatnot somewhat and could feel fun but the accumulated
> overhead of all other people going WTF when trying to read the code
> far outweights any benefit which can be gained that way.  So, please
> don't bury return in a macro.  It's just a bad idea.

It's not about writeability or terseness, it's there so you really have
to go out of your way to use your closure after you've dropped your
refcount on it, and making sure you think and are conscious of it if
you're doing anything unusual.

Having been bit painfully by bugs like that - and honestly I of all
people should know better - there's just no way I'm just taking it out.
Yes, confusing the reader is bad, but - it's really the lesser evil
here.

That said, your idea about having it return an opaque struct that the
caller then has to return - I liked that idea. I don't know what to do
about the first user of a closure (i.e. the function that allocated it),
but it can be made to work cleanly I'd be fine with that.

> > +void closure_queue(struct closure *cl)
> > +{
> > +	struct workqueue_struct *wq = cl->wq;
> > +	if (wq) {
> > +		cl->work.data = (atomic_long_t) WORK_DATA_INIT();
> > +		INIT_LIST_HEAD(&cl->work.entry);
> > +		BUG_ON(!queue_work(wq, &cl->work));
> > +	} else
> > +		cl->fn(cl);
> 
> Umm... so the code is taking advantage of how fields of work_struct is
> laid and using internal initializer to partially initialize work item?
> Am I reading it correctly?  If so, please don't do this.  It's way too
> fragile.

It's not really partially initializing it, it is fully initializing it
(except for work->func which is the same as cl->fn). I used to have
INIT_WORK() there, don't remember why I switched (debug code?). Can
probably switch back.

The only part of work_struct's layout that I'm really depending on is
func. It is kind of a terrible hack but it makes struct closure 8 bytes
smaller (48 instead of 56), and for generic infrastructure it is not IMO
completely crazy.

Should at least have a BUILD_BUG_ON() somewhere, though...

> > +#define CL_FIELD(type, field)					\
> > +	case TYPE_ ## type:					\
> > +	return &container_of(cl, struct type, cl)->field
> > +
> > +static closure_list_t *closure_waitlist(struct closure *cl)
> > +{
> > +	switch (cl->type) {
> > +		CL_FIELD(closure_with_waitlist, wait);
> > +		CL_FIELD(closure_with_waitlist_and_timer, wait);
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static struct timer_list *closure_timer(struct closure *cl)
> > +{
> > +	switch (cl->type) {
> > +		CL_FIELD(closure_with_timer, timer);
> > +		CL_FIELD(closure_with_waitlist_and_timer, timer);
> > +	}
> > +	return NULL;
> > +}
> 
> C code trumps macros.  There are only four of them.  Let's just open
> code.

Eh, this one I don't feel that strongly about. 

> > +static void closure_put_after_sub(struct closure *cl, int r)
> > +{
> > +	BUG_ON(r & CLOSURE_GUARD_MASK);
> > +	/* CLOSURE_BLOCK is the only flag that's allowed when r hits 0 */
> > +	BUG_ON((r & CLOSURE_REMAINING_MASK) == 0 &&
> > +	       (r & ~CLOSURE_BLOCKING));
> > +
> > +	/* Must deliver precisely one wakeup */
> > +	if ((r & CLOSURE_REMAINING_MASK) == 1 &&
> > +	    (r & CLOSURE_SLEEPING)) {
> > +		smp_mb__after_atomic_dec();
> 
> Why?  wake_up_process() includes smp_wmb() and atomic_sub_return() has
> full smp_mb().

Missed that about atomic_sub_return().

> > +		wake_up_process(cl->task);
> > +	}
> > +
> > +	if ((r & CLOSURE_REMAINING_MASK) == 0) {
> > +		smp_mb__after_atomic_dec();
> 
> Ditto.
> 
> > +		if (cl->fn) {
> > +			/* CLOSURE_BLOCKING might be set - clear it */
> > +			atomic_set(&cl->remaining,
> > +				   CLOSURE_REMAINING_INITIALIZER);
> > +			closure_queue(cl);
> > +		} else {
> > +			struct closure *parent = cl->parent;
> > +			closure_list_t *wait = closure_waitlist(cl);
> > +
> > +			closure_debug_destroy(cl);
> > +
> > +			smp_wmb();
> 
> Why?  What is it paired with?  The only thing between the previous
> smp_mb() and here is closure_debug_destroy().

It used to be that it grabbed the waitlist before unlocking, but that
was incorrect and buggy. I can't think of any reason for it now.

> 
> > +			/* mb between last use of closure and unlocking it */
> > +			atomic_set(&cl->remaining, -1);
> > +
> > +			if (wait)
> > +				closure_wake_up(wait);
> > +
> > +			if (parent)
> > +				closure_put(parent);
> > +		}
> > +	}
> > +}
> ...
> > +/*
> > + * Broken up because closure_put() has to do the xchg() and grab the wait list
> > + * before unlocking the closure, but the wakeup has to come after unlocking the
> > + * closure.
> > + */
> 
> Doesn't seem to be used by closure_put().  Stale comment?

Yes.

> > +static void closure_wake_up_after_xchg(struct llist_node *list)
> > +{
> > +	struct closure *cl;
> > +	struct llist_node *reverse = NULL;
> > +
> > +	while (list) {
> > +		struct llist_node *t = list;
> > +		list = llist_next(list);
> > +
> > +		t->next = reverse;
> > +		reverse = t;
> > +	}
> > +
> > +	while (reverse) {
> > +		cl = container_of(reverse, struct closure, list);
> > +		reverse = llist_next(reverse);
> > +
> > +		set_waiting(cl, 0);
> > +		closure_sub(cl, CLOSURE_WAITING + 1);
> 
> Why is it done in reverse?  To keep FIFO order?  If so, what
> difference does that make and why no explanation?

Exactly. I'm sure it's the kind of thing that'd make a difference only
under extremely pathalogical conditions, but... it's easy to do it
right. Added a comment, though.

> > +/**
> > + * closure_sync() - sleep until a closure a closure has nothing left to wait on
> 
>                                    ^^^^^^^^^^^^^^^^^^^
> > + *
> > + * Sleeps until the refcount hits 1 - the thread that's running the closure owns
> > + * the last refcount.
> > + */
> > +void closure_sync(struct closure *cl)
> > +{
> > +	while (1) {
> > +		__closure_start_sleep(cl);
> > +		closure_set_ret_ip(cl);
> > +
> > +		if ((atomic_read(&cl->remaining) &
> > +		     CLOSURE_REMAINING_MASK) == 1)
> > +			break;
> > +
> > +		schedule();
> > +	}
> > +
> > +	__closure_end_sleep(cl);
> > +}
> > +EXPORT_SYMBOL_GPL(closure_sync);
> ...
> > +void __closure_flush(struct closure *cl, struct timer_list *timer)
> > +{
> > +	if (del_timer(timer))
> > +		closure_sub(cl, CLOSURE_TIMER + 1);
> > +}
> > +EXPORT_SYMBOL_GPL(__closure_flush);
> > +
> > +void __closure_flush_sync(struct closure *cl, struct timer_list *timer)
> > +{
> > +	if (del_timer_sync(timer))
> > +		closure_sub(cl, CLOSURE_TIMER + 1);
> > +}
> > +EXPORT_SYMBOL_GPL(__closure_flush_sync);
> 
> I'm kinda lost why this distinction is necessary.  Can you please
> explain a bit?

I had a reason for it, but I can't remember what it was. I'll have to
look at the code that uses it - quite possibly it's not needed at all.
Like I said above, this is newer/more experimental.
