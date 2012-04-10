Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2DJXTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:19:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34221 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2DJXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:19:23 -0400
Date: Tue, 10 Apr 2012 16:18:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 3/4 V2] implement per-domain single-thread state machine
 call_srcu()
Message-ID: <20120410231858.GJ2428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
 <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041023-5518-0000-0000-00000393B0EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 04:12:13PM +0800, Lai Jiangshan wrote:
> o	state machine is light way and single-threaded, it is preemptible when checking.
> 
> o	state machine is a work_struct. So, there is no thread occupied
> 	by SRCU when the srcu is not actived(no callback). And it does
> 	not sleep(avoid to occupy a thread when sleep).
> 
> o	state machine is the only thread can flip/check/write(*) the srcu_struct,
> 	so we don't need any mutex.
> 	(write(*): except ->per_cpu_ref, ->running, ->batch_queue)
> 
> o	synchronize_srcu() will take the processing ownership when no other
> 	state-machine is running.(the task of synchronize_srcu() becomes
> 	the state-machine-thread). This fast patch can avoid scheduling.
> 	When the fast path fails, it falls back to "call_srcu() + wait".
> 
> o	callback is probably called in the same CPU when it is queued.
> 
> The trip of a callback:
> 	1) ->batch_queue when call_srcu()
> 
> 	2) ->batch_check0 when try to do check_zero
> 
> 	3) ->batch_check1 after finish its first check_zero and the flip
> 
> 	4) ->batch_done after finish its second check_zero
> 
> The current requirement of the callbacks:
> 	The callback will be called inside process context.
> 	The callback should be fast without any sleeping path.

The basic algorithm looks safe, but I have some questions on liveness
and expeditedness below.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/srcu.h |   25 ++++-
>  kernel/srcu.c        |  310 +++++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 268 insertions(+), 67 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index e5ce804..075fb8c 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -29,16 +29,30 @@
> 
>  #include <linux/mutex.h>
>  #include <linux/rcupdate.h>
> +#include <linux/workqueue.h>
> 
>  struct srcu_struct_array {
>  	unsigned long c[2];
>  	unsigned long seq[2];
>  };
> 
> +struct rcu_batch {
> +	struct rcu_head *head, **tail;
> +};
> +
>  struct srcu_struct {
>  	unsigned completed;
>  	struct srcu_struct_array __percpu *per_cpu_ref;
> -	struct mutex mutex;
> +	spinlock_t queue_lock; /* protect ->batch_queue, ->running */
> +	bool running;
> +	/* callbacks just queued */
> +	struct rcu_batch batch_queue;
> +	/* callbacks try to do the first check_zero */
> +	struct rcu_batch batch_check0;
> +	/* callbacks done with the first check_zero and the flip */
> +	struct rcu_batch batch_check1;
> +	struct rcu_batch batch_done;
> +	struct delayed_work work;
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map dep_map;
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> @@ -62,12 +76,21 @@ int init_srcu_struct(struct srcu_struct *sp);
> 
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
> +/*
> + * queue callbacks which will be invoked after grace period.
> + * The callback will be called inside process context.
> + * The callback should be fast without any sleeping path.
> + */
> +void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
> +		void (*func)(struct rcu_head *head));
> +
>  void cleanup_srcu_struct(struct srcu_struct *sp);
>  int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
>  void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
>  void synchronize_srcu(struct srcu_struct *sp);
>  void synchronize_srcu_expedited(struct srcu_struct *sp);
>  long srcu_batches_completed(struct srcu_struct *sp);
> +void srcu_barrier(struct srcu_struct *sp);
> 
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 2923541..c193d59 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -34,10 +34,60 @@
>  #include <linux/delay.h>
>  #include <linux/srcu.h>
> 
> +static inline void rcu_batch_init(struct rcu_batch *b)
> +{
> +	b->head = NULL;
> +	b->tail = &b->head;
> +}
> +
> +static inline void rcu_batch_queue(struct rcu_batch *b, struct rcu_head *head)
> +{
> +	*b->tail = head;
> +	b->tail = &head->next;
> +}
> +
> +static inline bool rcu_batch_empty(struct rcu_batch *b)
> +{
> +	return b->tail == &b->head;
> +}
> +
> +static inline struct rcu_head *rcu_batch_dequeue(struct rcu_batch *b)
> +{
> +	struct rcu_head *head;
> +
> +	if (rcu_batch_empty(b))
> +		return NULL;
> +
> +	head = b->head;
> +	b->head = head->next;
> +	if (b->tail == &head->next)
> +		rcu_batch_init(b);
> +
> +	return head;
> +}
> +
> +static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
> +{
> +	if (!rcu_batch_empty(from)) {
> +		*to->tail = from->head;
> +		to->tail = from->tail;
> +		rcu_batch_init(from);
> +	}
> +}
> +
> +/* single-thread state-machine */
> +static void process_srcu(struct work_struct *work);
> +
>  static int init_srcu_struct_fields(struct srcu_struct *sp)
>  {
>  	sp->completed = 0;
> -	mutex_init(&sp->mutex);
> +	spin_lock_init(&sp->queue_lock);
> +	sp->running = false;
> +	rcu_batch_init(&sp->batch_queue);
> +	rcu_batch_init(&sp->batch_check0);
> +	rcu_batch_init(&sp->batch_check1);
> +	rcu_batch_init(&sp->batch_done);
> +	INIT_DELAYED_WORK(&sp->work, process_srcu);
>  	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
>  	return sp->per_cpu_ref ? 0 : -ENOMEM;
>  }
> @@ -251,29 +301,22 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
>   * we repeatedly block for 1-millisecond time periods.  This approach
>   * has done well in testing, so there is no need for a config parameter.
>   */
> -#define SYNCHRONIZE_SRCU_READER_DELAY	5
> +#define SRCU_RETRY_CHECK_DELAY		5
>  #define SYNCHRONIZE_SRCU_TRYCOUNT	2
>  #define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
> 
>  /*
> - * Wait until all the readers(which starts before this wait_idx()
> - * with the specified idx) complete.
> + * the caller should ensures the ->completed is not changed while checking
> + * and idx = (->completed & 1) ^ 1
>   */
> -static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
> +static bool try_check_zero(struct srcu_struct *sp, int idx, int trycount)
>  {
> -	/*
> -	 * SRCU read-side critical sections are normally short, so wait
> -	 * a small amount of time before possibly blocking.
> -	 */
> -	if (!srcu_readers_active_idx_check(sp, idx)) {
> -		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> -		while (!srcu_readers_active_idx_check(sp, idx)) {
> -			if (trycount > 0) {
> -				trycount--;
> -				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> -			} else
> -				schedule_timeout_interruptible(1);
> -		}
> +	for (;;) {
> +		if (srcu_readers_active_idx_check(sp, idx))
> +			return true;
> +		if (--trycount <= 0)
> +			return false;
> +		udelay(SRCU_RETRY_CHECK_DELAY);
>  	}
>  }
> 
> @@ -282,12 +325,51 @@ static void srcu_flip(struct srcu_struct *sp)
>  	sp->completed++;
>  }
> 
> +void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
> +		void (*func)(struct rcu_head *head))
> +{
> +	unsigned long flags;
> +
> +	head->next = NULL;
> +	head->func = func;
> +	spin_lock_irqsave(&sp->queue_lock, flags);
> +	rcu_batch_queue(&sp->batch_queue, head);
> +	if (!sp->running) {
> +		sp->running = true;
> +		queue_delayed_work(system_nrt_wq, &sp->work, 0);
> +	}
> +	spin_unlock_irqrestore(&sp->queue_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(call_srcu);
> +
> +struct rcu_synchronize {
> +	struct rcu_head head;
> +	struct completion completion;
> +};
> +
> +/*
> + * Awaken the corresponding synchronize_srcu() instance now that a
> + * grace period has elapsed.
> + */
> +static void wakeme_after_rcu(struct rcu_head *head)
> +{
> +	struct rcu_synchronize *rcu;
> +
> +	rcu = container_of(head, struct rcu_synchronize, head);
> +	complete(&rcu->completion);
> +}
> +
> +static void srcu_advance_batches(struct srcu_struct *sp, int trycount);
> +static void srcu_reschedule(struct srcu_struct *sp);
> +
>  /*
>   * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
>   */
>  static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
>  {
> -	int busy_idx;
> +	struct rcu_synchronize rcu;
> +	struct rcu_head *head = &rcu.head;
> +	bool done = false;
> 
>  	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
>  			   !lock_is_held(&rcu_bh_lock_map) &&
> @@ -295,54 +377,32 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
>  			   !lock_is_held(&rcu_sched_lock_map),
>  			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
> 
> -	mutex_lock(&sp->mutex);
> -	busy_idx = sp->completed & 0X1UL;
> -
> -	/*
> -	 * There are some readers start with idx=0, and some others start
> -	 * with idx=1. So two wait_idx()s are enough for synchronize:
> -	 * __synchronize_srcu() {
> -	 * 	wait_idx(sp, 0, trycount);
> -	 * 	wait_idx(sp, 1, trycount);
> -	 * }
> -	 * When it returns, all started readers have complete.
> -	 *
> -	 * But synchronizer may be starved by the readers, example,
> -	 * if sp->complete & 0x1L == 1, wait_idx(sp, 1, expedited)
> -	 * may not returns if there are continuous readers start
> -	 * with idx=1.
> -	 *
> -	 * So we need to flip the busy index to keep synchronizer
> -	 * from starvation.
> -	 */
> -
> -	/*
> -	 * The above comments assume we have readers with all the
> -	 * 2 idx. It does have this probability, some readers may
> -	 * hold the reader lock with idx=1-busy_idx:
> -	 *
> -	 * Suppose that during the previous grace period, a reader
> -	 * picked up the old value of the index, but did not increment
> -	 * its counter until after the previous instance of
> -	 * __synchronize_srcu() did the counter summation and recheck.
> -	 * That previous grace period was OK because the reader did
> -	 * not start until after the grace period started, so the grace
> -	 * period was not obligated to wait for that reader.
> -	 *
> -	 * Because this probability is not high, wait_idx()
> -	 * will normally not need to wait.
> -	 */
> -	wait_idx(sp, 1 - busy_idx, trycount);
> -
> -	/* flip the index to ensure the return of the next wait_idx() */
> -	srcu_flip(sp);
> -
> -	/*
> -	 * Now that wait_idx() has waited for the really old readers.
> -	 */
> -	wait_idx(sp, busy_idx, trycount);
> +	init_completion(&rcu.completion);
> +
> +	head->next = NULL;
> +	head->func = wakeme_after_rcu;
> +	spin_lock_irq(&sp->queue_lock);
> +	if (!sp->running) {
> +		/* steal the processing owner */
> +		sp->running = true;
> +		rcu_batch_queue(&sp->batch_check0, head);
> +		spin_unlock_irq(&sp->queue_lock);
> +
> +		srcu_advance_batches(sp, trycount);
> +		if (!rcu_batch_empty(&sp->batch_done)) {
> +			BUG_ON(sp->batch_done.head != head);
> +			rcu_batch_dequeue(&sp->batch_done);
> +			done = true;
> +		}
> +		/* give the processing owner to work_struct */
> +		srcu_reschedule(sp);
> +	} else {
> +		rcu_batch_queue(&sp->batch_queue, head);

Doesn't this mean that if there is a synchronize_srcu() in progress that
a later synchronize_srcu_expedited() won't actually be expedited?

Version 3.3 of the Linux kernel doesn't have any users that I can see
who mix expedited and normal SRCU grace periods, but this might need to
change if something comes up, for example, if the KVM guys decide to use
call_srcu() somewhere.  Or, if I understand the code correctly, if they
happen to do a pair of concurrent synchronize_srcu_expedited() calls.

So what would you do if that happened?

Or am I missing something subtle in the expedited handling?

> +		spin_unlock_irq(&sp->queue_lock);
> +	}
> 
> -	mutex_unlock(&sp->mutex);
> +	if (!done)
> +		wait_for_completion(&rcu.completion);
>  }
> 
>  /**
> @@ -386,6 +446,12 @@ void synchronize_srcu_expedited(struct srcu_struct *sp)
>  }
>  EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
> 
> +void srcu_barrier(struct srcu_struct *sp)
> +{
> +	synchronize_srcu(sp);
> +}
> +EXPORT_SYMBOL_GPL(srcu_barrier);
> +
>  /**
>   * srcu_batches_completed - return batches completed.
>   * @sp: srcu_struct on which to report batch completion.
> @@ -399,3 +465,115 @@ long srcu_batches_completed(struct srcu_struct *sp)
>  	return sp->completed;
>  }
>  EXPORT_SYMBOL_GPL(srcu_batches_completed);
> +
> +#define SRCU_CALLBACK_BATCH	10
> +#define SRCU_INTERVAL		1
> +
> +static void srcu_collect_new(struct srcu_struct *sp)
> +{
> +	if (!rcu_batch_empty(&sp->batch_queue)) {
> +		spin_lock_irq(&sp->queue_lock);
> +		rcu_batch_move(&sp->batch_check0, &sp->batch_queue);
> +		spin_unlock_irq(&sp->queue_lock);
> +	}
> +}
> +
> +static void srcu_advance_batches(struct srcu_struct *sp, int trycount)
> +{
> +	int idx = 1 ^ (sp->completed & 1);

Why not "int idx = !(sp->completed & 1)"?  Does the exclusive-or generate
better code?  (I am not all that worried either way, just curious.)

> +
> +	/*
> +	 * There are some readers start with idx=0, and some others start
> +	 * with idx=1. So two success try_check_zero()s (with idx=0,and idx=1)
> +	 * are enough for a callback to complete.
> +	 */
> +
> +	if (rcu_batch_empty(&sp->batch_check0) &&
> +	    rcu_batch_empty(&sp->batch_check1))
> +		return; /* no callbacks need to be advanced */

There might have been some callbacks enqueued on ->batch_queue in the
meantime, right?  This should not be a problem because they will be
picked up in the next iteration, just want to make sure that I understand.

> +
> +	if (!try_check_zero(sp, idx, trycount))
> +		return; /* failed to advance, will try after SRCU_INTERVAL */
> +
> +	/*
> +	 * The callbacks in ->batch_check1 have already done with their
> +	 * first check zero and a flip after check. Their first
> +	 * check zero is "try_check_zero(sp, idx^1, ...)",
> +	 * and they finish try_check_zero(sp, idx, ...) just now.
> +	 * So they all completed, move them to ->batch_done.
> +	 */
> +	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
> +
> +	if (rcu_batch_empty(&sp->batch_check0))
> +		return; /* no callbacks need to be advanced */
> +	srcu_flip(sp);
> +
> +	/*
> +	 * The callbacks in ->batch_check0 just finish their
> +	 * first check zero and a flip after check, move them to
> +	 * ->batch_check1 for future checking with a different idx.
> +	 */
> +	rcu_batch_move(&sp->batch_check1, &sp->batch_check0);

Interestingly enough, aside from the different handling of
try_check_zero()'s arguments, we could just return here and let the next
iteration cover the rest of the process.  In theory, anyway.  In practice,
I think I prefer the extra code to the extra context switches.

> +
> +	/*
> +	 * SRCU read-side critical sections are normally short, so check
> +	 * twice after a flip.
> +	 */
> +	trycount = trycount < 2 ? 2 : trycount;
> +	if (!try_check_zero(sp, idx^1, trycount))

And here, just out of curiosity, why not "!idx"?

> +		return; /* failed to advance, will try after SRCU_INTERVAL */
> +
> +	/*
> +	 * The callbacks in ->batch_check1 have already done with their
> +	 * first check zero and a flip after check. Their first
> +	 * check zero is "try_check_zero(sp, idx, ...)",
> +	 * and they finish try_check_zero(sp, idx^1, ...) just now.
> +	 * So they all completed, move them to ->batch_done.
> +	 */
> +	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
> +}
> +
> +static void srcu_invoke_callbacks(struct srcu_struct *sp)
> +{
> +	int i;
> +	struct rcu_head *head;
> +
> +	for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {

If there really can be thousands of callbacks dumped into SRCU, a more
adaptive strategy might be needed.  In the meantime, I am hoping that
the fact that the workqueue is retriggered in this case suffices.

Note that this function is preemptible, so there is less penalty for
running a very long batch.

Which reminds me...  An srcu_struct structure with a large pile of
SRCU callbacks won't react very quickly in response to an invocation of
synchronize_srcu_expedited().  This is why the other RCU implementations
have a non-callback codepath for expedited grace periods.

Or am I missing something here?

> +		head = rcu_batch_dequeue(&sp->batch_done);
> +		if (!head)
> +			break;
> +		head->func(head);

I have surrounded this with local_bh_disable() and local_bh_enable()
in order to enforce the no-sleeping-in-callbacks rule.  Please let me
know if I missed some other enforcement mechanism.

> +	}
> +}
> +
> +static void srcu_reschedule(struct srcu_struct *sp)
> +{
> +	bool pending = true;
> +
> +	if (rcu_batch_empty(&sp->batch_done) &&
> +	    rcu_batch_empty(&sp->batch_check1) &&
> +	    rcu_batch_empty(&sp->batch_check0) &&
> +	    rcu_batch_empty(&sp->batch_queue)) {
> +		spin_lock_irq(&sp->queue_lock);
> +		if (rcu_batch_empty(&sp->batch_queue)) {
> +			sp->running = false;
> +			pending = false;
> +		}
> +		spin_unlock_irq(&sp->queue_lock);

Hmmm...  What happens given the following sequence of events?

o	SRCU has just finished executing the last callback, so that
	all callback queues are empty.

o	srcu_reschedule() executes the condition of its "if" statement,
	but does not yet acquire the spinlock.  (If I read the code
	correctly, preemption could legitimately occur at this point.)

o	call_srcu() initializes the callback, acquires the spinlock,
	queues the callback, and invokes queue_delayed_work().

o	The delayed work starts executing process_srcu(), which
	calls srcu_collect_new(), which moves the callback to
	->batch_check0.

o	srcu_reschedule continues executing, acquires the spinlock,
	sees that ->batch_queue is empty, and therefore sets
	->running to false, thus setting the stage for two CPUs
	mucking with the queues concurrently without protection.

I believe that you need to recheck all the queues under the lock,
not just ->batch_queue (and I did update the patch in this manner).

Or am I missing something subtle?

> +	}
> +
> +	if (pending)
> +		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);

Here, we carefully invoke queue_delayed_work() outside of the lock,
while in call_srcu() we invoke it under the lock.  Why the difference?

> +}
> +
> +static void process_srcu(struct work_struct *work)
> +{
> +	struct srcu_struct *sp;
> +
> +	sp = container_of(work, struct srcu_struct, work.work);
> +
> +	srcu_collect_new(sp);
> +	srcu_advance_batches(sp, 1);
> +	srcu_invoke_callbacks(sp);
> +	srcu_reschedule(sp);
> +}
> -- 
> 1.7.4.4
> 

