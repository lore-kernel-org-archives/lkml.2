Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2K0Ipm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:45:42 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60858 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162Ab2K0Ipl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:45:41 -0500
MIME-Version: 1.0
In-Reply-To: <50B46F79.5010606@kernel.dk>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
	<20121120180949.GG1408@quack.suse.cz>
	<CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
	<CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
	<CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
	<50AF7901.20401@kernel.dk>
	<CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
	<Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
	<CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
	<CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
	<50B46E05.70906@kernel.dk>
	<50B46F79.5010606@kernel.dk>
Date: Tue, 27 Nov 2012 17:45:40 +0900
Message-ID: <CAAJw_Zsg7AW5+8h8pXZ-dPhBOZ2oechWA6N9eb1fea-vTj=vCw@mail.gmail.com>
Subject: Re: Recent kernel "mount" slow
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Limited access now at Incheon Airport. Will try the patch out when I arrived.

Thanks,
Jeff

On 11/27/12, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-11-27 08:38, Jens Axboe wrote:
>> On 2012-11-27 06:57, Jeff Chua wrote:
>>> On Sun, Nov 25, 2012 at 7:23 AM, Jeff Chua <jeff.chua.linux@gmail.com>
>>> wrote:
>>>> On Sun, Nov 25, 2012 at 5:09 AM, Mikulas Patocka <mpatocka@redhat.com>
>>>> wrote:
>>>>> So it's better to slow down mount.
>>>>
>>>> I am quite proud of the linux boot time pitting against other OS. Even
>>>> with 10 partitions. Linux can boot up in just a few seconds, but now
>>>> you're saying that we need to do this semaphore check at boot up. By
>>>> doing so, it's inducing additional 4 seconds during boot up.
>>>
>>> By the way, I'm using a pretty fast SSD (Samsung PM830) and fast CPU
>>> (2.8GHz). I wonder if those on slower hard disk or slower CPU, what
>>> kind of degradation would this cause or just the same?
>>
>> It'd likely be the same slow down time wise, but as a percentage it
>> would appear smaller on a slower disk.
>>
>> Could you please test Mikulas' suggestion of changing
>> synchronize_sched() in include/linux/percpu-rwsem.h to
>> synchronize_sched_expedited()?
>>
>> linux-next also has a re-write of the per-cpu rw sems, out of Andrews
>> tree. It would be a good data point it you could test that, too.
>>
>> In any case, the slow down definitely isn't acceptable. Fixing an
>> obscure issue like block sizes changing while O_DIRECT is in flight
>> definitely does NOT warrant a mount slow down.
>
> Here's Olegs patch, might be easier for you than switching to
> linux-next. Please try that.
>
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: percpu_rw_semaphore: reimplement to not block the readers
> unnecessarily
>
> Currently the writer does msleep() plus synchronize_sched() 3 times to
> acquire/release the semaphore, and during this time the readers are
> blocked completely.  Even if the "write" section was not actually started
> or if it was already finished.
>
> With this patch down_write/up_write does synchronize_sched() twice and
> down_read/up_read are still possible during this time, just they use the
> slow path.
>
> percpu_down_write() first forces the readers to use rw_semaphore and
> increment the "slow" counter to take the lock for reading, then it
> takes that rw_semaphore for writing and blocks the readers.
>
> Also.  With this patch the code relies on the documented behaviour of
> synchronize_sched(), it doesn't try to pair synchronize_sched() with
> barrier.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anton Arapov <anton@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/percpu-rwsem.h |   85 +++-------------------
>  lib/Makefile                 |    2
>  lib/percpu-rwsem.c           |  123 +++++++++++++++++++++++++++++++++
>  3 files changed, 138 insertions(+), 72 deletions(-)
>
> diff -puN
> include/linux/percpu-rwsem.h~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
> include/linux/percpu-rwsem.h
> ---
> a/include/linux/percpu-rwsem.h~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
> +++ a/include/linux/percpu-rwsem.h
> @@ -2,82 +2,25 @@
>  #define _LINUX_PERCPU_RWSEM_H
>
>  #include <linux/mutex.h>
> +#include <linux/rwsem.h>
>  #include <linux/percpu.h>
> -#include <linux/rcupdate.h>
> -#include <linux/delay.h>
> +#include <linux/wait.h>
>
>  struct percpu_rw_semaphore {
> -	unsigned __percpu *counters;
> -	bool locked;
> -	struct mutex mtx;
> +	unsigned int __percpu	*fast_read_ctr;
> +	struct mutex		writer_mutex;
> +	struct rw_semaphore	rw_sem;
> +	atomic_t		slow_read_ctr;
> +	wait_queue_head_t	write_waitq;
>  };
>
> -#define light_mb()	barrier()
> -#define heavy_mb()	synchronize_sched()
> +extern void percpu_down_read(struct percpu_rw_semaphore *);
> +extern void percpu_up_read(struct percpu_rw_semaphore *);
>
> -static inline void percpu_down_read(struct percpu_rw_semaphore *p)
> -{
> -	rcu_read_lock_sched();
> -	if (unlikely(p->locked)) {
> -		rcu_read_unlock_sched();
> -		mutex_lock(&p->mtx);
> -		this_cpu_inc(*p->counters);
> -		mutex_unlock(&p->mtx);
> -		return;
> -	}
> -	this_cpu_inc(*p->counters);
> -	rcu_read_unlock_sched();
> -	light_mb(); /* A, between read of p->locked and read of data, paired with
> D */
> -}
> -
> -static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> -{
> -	light_mb(); /* B, between read of the data and write to p->counter, paired
> with C */
> -	this_cpu_dec(*p->counters);
> -}
> -
> -static inline unsigned __percpu_count(unsigned __percpu *counters)
> -{
> -	unsigned total = 0;
> -	int cpu;
> -
> -	for_each_possible_cpu(cpu)
> -		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));
> -
> -	return total;
> -}
> -
> -static inline void percpu_down_write(struct percpu_rw_semaphore *p)
> -{
> -	mutex_lock(&p->mtx);
> -	p->locked = true;
> -	synchronize_sched(); /* make sure that all readers exit the
> rcu_read_lock_sched region */
> -	while (__percpu_count(p->counters))
> -		msleep(1);
> -	heavy_mb(); /* C, between read of p->counter and write to data, paired
> with B */
> -}
> -
> -static inline void percpu_up_write(struct percpu_rw_semaphore *p)
> -{
> -	heavy_mb(); /* D, between write to data and write to p->locked, paired
> with A */
> -	p->locked = false;
> -	mutex_unlock(&p->mtx);
> -}
> -
> -static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
> -{
> -	p->counters = alloc_percpu(unsigned);
> -	if (unlikely(!p->counters))
> -		return -ENOMEM;
> -	p->locked = false;
> -	mutex_init(&p->mtx);
> -	return 0;
> -}
> -
> -static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
> -{
> -	free_percpu(p->counters);
> -	p->counters = NULL; /* catch use after free bugs */
> -}
> +extern void percpu_down_write(struct percpu_rw_semaphore *);
> +extern void percpu_up_write(struct percpu_rw_semaphore *);
> +
> +extern int percpu_init_rwsem(struct percpu_rw_semaphore *);
> +extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
>
>  #endif
> diff -puN
> lib/Makefile~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
> lib/Makefile
> ---
> a/lib/Makefile~percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily
> +++ a/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 idr.o int_sqrt.o extable.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o earlycpio.o
> +	 is_single_threaded.o plist.o decompress.o earlycpio.o percpu-rwsem.o
>
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> diff -puN /dev/null lib/percpu-rwsem.c
> --- /dev/null
> +++ a/lib/percpu-rwsem.c
> @@ -0,0 +1,123 @@
> +#include <linux/percpu-rwsem.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +
> +int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
> +{
> +	brw->fast_read_ctr = alloc_percpu(int);
> +	if (unlikely(!brw->fast_read_ctr))
> +		return -ENOMEM;
> +
> +	mutex_init(&brw->writer_mutex);
> +	init_rwsem(&brw->rw_sem);
> +	atomic_set(&brw->slow_read_ctr, 0);
> +	init_waitqueue_head(&brw->write_waitq);
> +	return 0;
> +}
> +
> +void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
> +{
> +	free_percpu(brw->fast_read_ctr);
> +	brw->fast_read_ctr = NULL; /* catch use after free bugs */
> +}
> +
> +static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int
> val)
> +{
> +	bool success = false;
> +
> +	preempt_disable();
> +	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
> +		__this_cpu_add(*brw->fast_read_ctr, val);
> +		success = true;
> +	}
> +	preempt_enable();
> +
> +	return success;
> +}
> +
> +/*
> + * Like the normal down_read() this is not recursive, the writer can
> + * come after the first percpu_down_read() and create the deadlock.
> + */
> +void percpu_down_read(struct percpu_rw_semaphore *brw)
> +{
> +	if (likely(update_fast_ctr(brw, +1)))
> +		return;
> +
> +	down_read(&brw->rw_sem);
> +	atomic_inc(&brw->slow_read_ctr);
> +	up_read(&brw->rw_sem);
> +}
> +
> +void percpu_up_read(struct percpu_rw_semaphore *brw)
> +{
> +	if (likely(update_fast_ctr(brw, -1)))
> +		return;
> +
> +	/* false-positive is possible but harmless */
> +	if (atomic_dec_and_test(&brw->slow_read_ctr))
> +		wake_up_all(&brw->write_waitq);
> +}
> +
> +static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
> +{
> +	unsigned int sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		sum += per_cpu(*brw->fast_read_ctr, cpu);
> +		per_cpu(*brw->fast_read_ctr, cpu) = 0;
> +	}
> +
> +	return sum;
> +}
> +
> +/*
> + * A writer takes ->writer_mutex to exclude other writers and to force the
> + * readers to switch to the slow mode, note the mutex_is_locked() check in
> + * update_fast_ctr().
> + *
> + * After that the readers can only inc/dec the slow ->slow_read_ctr
> counter,
> + * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
> + * counter it represents the number of active readers.
> + *
> + * Finally the writer takes ->rw_sem for writing and blocks the new
> readers,
> + * then waits until the slow counter becomes zero.
> + */
> +void percpu_down_write(struct percpu_rw_semaphore *brw)
> +{
> +	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
> +	mutex_lock(&brw->writer_mutex);
> +
> +	/*
> +	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
> +	 *    so that update_fast_ctr() can't succeed.
> +	 *
> +	 * 2. Ensures we see the result of every previous this_cpu_add() in
> +	 *    update_fast_ctr().
> +	 *
> +	 * 3. Ensures that if any reader has exited its critical section via
> +	 *    fast-path, it executes a full memory barrier before we return.
> +	 */
> +	synchronize_sched();
> +
> +	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
> +	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
> +
> +	/* block the new readers completely */
> +	down_write(&brw->rw_sem);
> +
> +	/* wait for all readers to complete their percpu_up_read() */
> +	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
> +}
> +
> +void percpu_up_write(struct percpu_rw_semaphore *brw)
> +{
> +	/* allow the new readers, but only the slow-path */
> +	up_write(&brw->rw_sem);
> +
> +	/* insert the barrier before the next fast-path in down_read */
> +	synchronize_sched();
> +
> +	mutex_unlock(&brw->writer_mutex);
> +}
>
> --
> Jens Axboe
>
>
