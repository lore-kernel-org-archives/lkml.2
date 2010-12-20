Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab0LTRQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:16:01 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37636 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932676Ab0LTRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:16:00 -0500
Subject: Re: [PATCH] kthread_worker: Initialize dynamically allocated
 spinlock properly for lockdep
From: Andy Walls <awalls@md.metrocast.net>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, nicolas.mailhot@laposte.net,
        Tejun Heo <tj@kernel.org>, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
References: <1292762975.2403.29.camel@localhost>
	 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
	 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 12:16:27 -0500
Message-ID: <1292865387.9445.28.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-20_04:2010-12-20,2010-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012200082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 17:28 +0800, Yong Zhang wrote:
> On Mon, Dec 20, 2010 at 3:07 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Sun, Dec 19, 2010 at 8:49 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> init_kthread_worker(), via KTHREAD_WORKER_INIT(), used an
> >> initializer for static spin_lock objects, SPIN_LOCK_UNLOCKED, on
> >> a dynamically allocated kthread_worker object's internal spinlock_t.
> >> This causes lockdep to gripe:
> >>
> >>        INFO: trying to register non-static key.
> >>        the code is fine but needs lockdep annotation.
> >>        turning off the locking correctness validator.
> >>
> >> To keep lockdep happy, use spin_lock_init() for dynamically
> >> allocated kthread_worker objects' internal spinlock_t.
> >>
> >> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> >> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> >>
> >> Cc: Tejun Heo <tj@kernel.org>
> >> Cc: Jarod Wilson <jarod@redhat.com>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> Cc: Hans Verkuil <hverkuil@xs4all.nl>

> > This will make different kthead_worker->lock initialized with one same
> > key.

Well, that wouldn't be very useful. :P


> > So we should put the real initializer to kernel/kthread.c
> > and make init_kthread_worker() to be a MACRO.

Sounds OK to me.  I'm not a lockdep expert and I made my initial patch
with the sole intention of making this bugzilla report go away:

https://bugzilla.redhat.com/show_bug.cgi?id=662384


> untested patch is here. Andy/Nicolas, is it ok for you?

No, see my comments below.

> ---
> Subject: [PATCH] kthread_work: Make lockdep happy
> 
> spinlock in kthread_worker and wait_queue_head in kthread_work
> both should be lockdep annotated.
> So change the interface to make it suiltable for CONFIG_LOCKDEP.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
> I'm not sure if it's possible to define a worker on stack?
> So I left DEFINE_KTHREAD_WORKER() untouched.
> 
>  include/linux/kthread.h |   37 +++++++++++++++++++++++++++----------
>  kernel/kthread.c        |    9 +++++++++
>  2 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 685ea65..5d516b3 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -75,22 +75,39 @@ struct kthread_work {
>  	.flushing = ATOMIC_INIT(0),					\
>  	}
> 
> +/* Is it possible to define a worker on stack? */

This comment doesn't help a developer decide if this interface is OK to
use.

If there is an alternate preferred API for instantiating 1 (or more)
thread(s) to handle work objects off of the stack, then the comment
should point the reader to that API (e.g. singlethread_workqueue).

To answer the question in the comment:

It is possible to allocate a kthread worker off of the stack, but IMO it
has little advantage over a singlethread_workqueue allocated off of the
stack.

ivtv only needed the kthread_worker API, because it has some deferred
work with tight timing constraints.  ivtv sets the kthread_worker to
SCHED_FIFO scheduling for ivtv work, which couldn't be done on a
workqueue thread with the updated singlethread_workqueue implementation.
Note that ivtv does *not* allocate its kthread worker off of the stack.


>  #define DEFINE_KTHREAD_WORKER(worker)					\
>  	struct kthread_worker worker = KTHREAD_WORKER_INIT(worker)
> 
>  #define DEFINE_KTHREAD_WORK(work, fn)					\
>  	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
> 
> -static inline void init_kthread_worker(struct kthread_worker *worker)
> -{
> -	*worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
> -}
> -
> -static inline void init_kthread_work(struct kthread_work *work,
> -				     kthread_work_func_t fn)
> -{
> -	*work = (struct kthread_work)KTHREAD_WORK_INIT(*work, fn);
> -}
> +#ifdef CONFIG_LOCKDEP
> +# define KTHREAD_WORK_INIT_ONSTACK(work, fn)				\
> +	({init_kthread_work((&work), fn); work})
> +# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn)				\
> +	struct kthread_work work = KTHREAD_WORK_INIT_ONSTACK(work, fn)
> +#else
> +# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
> +#endif
> +
> +extern void __init_kthread_worker(struct kthread_worker *worker,
> +					struct lock_class_key *key);
> +
> +#define init_kthread_worker(worker)					\
> +	do {								\
> +		static struct lock_class_key __key;			\
> +		__init_kthread_worker((worker), &__key);		\
> +	} while (0)
> +
> +#define init_kthread_work(work, fn)					\
> +	do {								\
> +		memset((work), 0, sizeof(struct kthread_work));		\
> +		INIT_LIST_HEAD(&(work)->node);				\
> +		(work)->func = (fn);					\
> +		init_waitqueue_head(&(work)->done);			\
> +		(work)->flushing = ATOMIC_INIT(0);			\
> +	} while (0)
> 
>  int kthread_worker_fn(void *worker_ptr);
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 2dc3786..fae2eff 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -265,6 +265,15 @@ int kthreadd(void *unused)
>  	return 0;
>  }
> 
> +void __init_kthread_worker(struct kthread_worker *worker,
> +				struct lock_class_key *key)
> +{
> +	spin_lock_init(&worker->lock);
> +	lockdep_set_class(&worker->lock, key);
> +	INIT_LIST_HEAD(&worker->work_list);
> +	worker->task == NULL;
                       ^^
                        |  
GCC should have griped, "Statement with no effect," or something
similar.  (Did it?)

Regards,
Andy

> +}
> +
>  /**
>   * kthread_worker_fn - kthread function to process kthread_worker
>   * @worker_ptr: pointer to initialized kthread_worker
> -- 
> 1.7.0.4


