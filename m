Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2JOX2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:28:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55573 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JOX2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:28:53 -0400
Date: Mon, 15 Oct 2012 16:28:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121015232814.GC3010@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121015190958.GA4799@redhat.com>
 <20121015191018.GA4816@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015191018.GA4816@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101523-2876-0000-0000-000001113F91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 09:10:18PM +0200, Oleg Nesterov wrote:
> This patch adds the new sleeping lock, brw_mutex. Unlike rw_semaphore
> it allows multiple writers too, just "read" and "write" are mutually
> exclusive.
> 
> brw_start_read() and brw_end_read() are extremely cheap, they only do
> this_cpu_inc(read_ctr) + atomic_read() if there are no waiting writers.
> 
> OTOH it is write-biased, any brw_start_write() blocks the new readers.
> But "write" is slow, it does synchronize_sched() to serialize with
> preempt_disable() in brw_start_read(), and wait_event(write_waitq) can
> have a lot of extra wakeups before percpu-counter-sum becomes zero.

A few questions and comments below, as always.

							Thanx, Paul

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/brw_mutex.h |   22 +++++++++++++++
>  lib/Makefile              |    2 +-
>  lib/brw_mutex.c           |   67 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/brw_mutex.h
>  create mode 100644 lib/brw_mutex.c
> 
> diff --git a/include/linux/brw_mutex.h b/include/linux/brw_mutex.h
> new file mode 100644
> index 0000000..16b8d5f
> --- /dev/null
> +++ b/include/linux/brw_mutex.h
> @@ -0,0 +1,22 @@
> +#ifndef _LINUX_BRW_MUTEX_H
> +#define _LINUX_BRW_MUTEX_H
> +
> +#include <linux/percpu.h>
> +#include <linux/wait.h>
> +
> +struct brw_mutex {
> +	long __percpu		*read_ctr;
> +	atomic_t		write_ctr;
> +	wait_queue_head_t	read_waitq;
> +	wait_queue_head_t	write_waitq;
> +};
> +
> +extern int brw_mutex_init(struct brw_mutex *brw);
> +
> +extern void brw_start_read(struct brw_mutex *brw);
> +extern void brw_end_read(struct brw_mutex *brw);
> +
> +extern void brw_start_write(struct brw_mutex *brw);
> +extern void brw_end_write(struct brw_mutex *brw);
> +
> +#endif
> diff --git a/lib/Makefile b/lib/Makefile
> index 3128e35..18f2876 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 idr.o int_sqrt.o extable.o \
>  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o
> +	 is_single_threaded.o plist.o decompress.o brw_mutex.o
> 
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> diff --git a/lib/brw_mutex.c b/lib/brw_mutex.c
> new file mode 100644
> index 0000000..41984a6
> --- /dev/null
> +++ b/lib/brw_mutex.c
> @@ -0,0 +1,67 @@
> +#include <linux/brw_mutex.h>
> +#include <linux/rcupdate.h>
> +#include <linux/sched.h>
> +
> +int brw_mutex_init(struct brw_mutex *brw)
> +{
> +	atomic_set(&brw->write_ctr, 0);
> +	init_waitqueue_head(&brw->read_waitq);
> +	init_waitqueue_head(&brw->write_waitq);
> +	brw->read_ctr = alloc_percpu(long);
> +	return brw->read_ctr ? 0 : -ENOMEM;
> +}
> +
> +void brw_start_read(struct brw_mutex *brw)
> +{
> +	for (;;) {
> +		bool done = false;
> +
> +		preempt_disable();
> +		if (likely(!atomic_read(&brw->write_ctr))) {
> +			__this_cpu_inc(*brw->read_ctr);
> +			done = true;
> +		}

brw_start_read() is not recursive -- attempting to call it recursively
can result in deadlock if a writer has shown up in the meantime.

Which is often OK, but not sure what you intended.

> +		preempt_enable();
> +
> +		if (likely(done))
> +			break;
> +
> +		__wait_event(brw->read_waitq, !atomic_read(&brw->write_ctr));
> +	}
> +}
> +
> +void brw_end_read(struct brw_mutex *brw)
> +{

I believe that you need smp_mb() here.  The wake_up_all()'s memory barriers
do not suffice because some other reader might have awakened the writer
between this_cpu_dec() and wake_up_all().  IIRC, this smp_mb() is also
needed if the timing is such that the writer does not actually block.

> +	this_cpu_dec(*brw->read_ctr);
> +
> +	if (unlikely(atomic_read(&brw->write_ctr)))
> +		wake_up_all(&brw->write_waitq);
> +}

Of course, it would be good to avoid smp_mb on the fast path.  Here is
one way to avoid it:

void brw_end_read(struct brw_mutex *brw)
{
	if (unlikely(atomic_read(&brw->write_ctr))) {
		smp_mb();
		this_cpu_dec(*brw->read_ctr);
		wake_up_all(&brw->write_waitq);
	} else {
		this_cpu_dec(*brw->read_ctr);
	}
}

> +static inline long brw_read_ctr(struct brw_mutex *brw)
> +{
> +	long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(*brw->read_ctr, cpu);
> +
> +	return sum;
> +}
> +
> +void brw_start_write(struct brw_mutex *brw)
> +{
> +	atomic_inc(&brw->write_ctr);
> +	synchronize_sched();
> +	/*
> +	 * Thereafter brw_*_read() must see write_ctr != 0,
> +	 * and we should see the result of __this_cpu_inc().
> +	 */
> +	wait_event(brw->write_waitq, brw_read_ctr(brw) == 0);

This looks like it allows multiple writers to proceed concurrently.
They both increment, do a synchronize_sched(), do the wait_event(),
and then are both awakened by the last reader.

Was that the intent?  (The implementation of brw_end_write() makes
it look like it is in fact the intent.)

> +}
> +
> +void brw_end_write(struct brw_mutex *brw)
> +{
> +	if (atomic_dec_and_test(&brw->write_ctr))
> +		wake_up_all(&brw->read_waitq);
> +}
> -- 
> 1.5.5.1
> 

