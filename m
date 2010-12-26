Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0LZGrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 01:47:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LZGrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 01:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MTNJgfePaRmUkNJmY5oJwLV5eZ3hIrm9U/waiRS5JAdAzAG7RTKRSFVIXiNmFUhMN1
         gC+xoacep/aR9Ie6a1iYeBjDKkXZPmT6aK5QeP/7IpK5YQ4pQ5qGhjA4cFNoEFLrzdcH
         VcQreQiah2rQlYT+VTkwppwSRQIl7u435XkqU=
MIME-Version: 1.0
In-Reply-To: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
Date: Sun, 26 Dec 2010 12:46:57 +0600
Message-ID: <AANLkTi==ahwQXGK-hPq+2KVRRwQiL9j7vVakAwi=NTiq@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 11:13 AM, Hillf Danton <dhillf@gmail.com> wrote:
> Based upon high resolution timer and idea borrowed from semaphore,
> nano semaphore is created.
>
> Nano semaphore provides finer time resolution depending on system
> configuration and capabilities.
>
> Nano semaphore is not to replace semaphore, but used in application
> environments where nano seconds are required.
>
> Three methods, nano_semaphore_try_down, nano_semaphore_down and
> nano_semaphore_up are implemented in a header file, and there is no
> corresponding C file since nano semaphore is not complex.
>

Above description tells how its done, what it is but its not clear why
we should use it. Can I know why should we use it or its benefits?


thanks,
rakib

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/include/linux/nano_semaphore.h    1970-01-01 08:00:00.000000000 +0800
> +++ b/include/linux/nano_semaphore.h    2010-12-26 12:38:36.000000000 +0800
> @@ -0,0 +1,263 @@
> +/*
> + *  linux/nano_semaphore.h
> + *
> + *  Definition and implementation of nano semaphore
> + *
> + *  Nano semaphore provides finer time resolution depending on system
> + *  configuration and capabilities.
> + *
> + *  Nano semaphore could be used in parallel with semaphore.
> + *
> + *  Started-by: Hillf Danton
> + *
> + *  Credits:
> + *     ideas are borrowed from semaphore and high resolution timer
> + *
> + *  Distributed under the terms of GPL v2
> + */
> +
> +#ifndef __NANO_SEMAPHORE_H_
> +#define __NANO_SEMAPHORE_H_
> +
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/ktime.h>
> +#include <linux/sched.h>
> +#include <linux/hrtimer.h>
> +
> +/* must be initialized before use */
> +struct nano_semaphore {
> +       struct list_head        chair;
> +       struct task_struct      *holder;
> +       spinlock_t              lock;
> +};
> +
> +#define NANO_SEMAPHORE_INITIALIZER(name)               \
> +{                                                      \
> +       .chair  = LIST_HEAD_INIT((name).chair),         \
> +       .holder = NULL,                                 \
> +       .lock   = __SPIN_LOCK_UNLOCKED((name).lock),    \
> +}
> +
> +
> +#define DEFINE_NANO_SEMAPHORE(name)    \
> +       struct nano_semaphore name = NANO_SEMAPHORE_INITIALIZER(name)
> +
> +
> +static inline void nano_semaphore_init(struct nano_semaphore *s)
> +{
> +       INIT_LIST_HEAD(&s->chair);
> +       s->holder = NULL;
> +       spin_lock_init(&s->lock);
> +}
> +
> +/*
> + * Helper functions about nano semaphore
> + */
> +
> +/*
> + * Helper function to check, whether anyone is waiting the nano semaphore
> + *
> + * Called with lock hold
> + */
> +static inline int nano_semaphore_waiter_pending(struct nano_semaphore *s)
> +{
> +       return !list_empty(&s->chair);
> +}
> +
> +/*
> + * Helper function to check, whether the nano semaphore is not hold by anyone
> + *
> + * Called with lock hold
> + */
> +static inline int nano_semaphore_holder_empty(struct nano_semaphore *s)
> +{
> +       return !s->holder;
> +}
> +
> +/*
> + * Helper function to check, whether `task' is the holder of nano semaphore
> + *
> + * Called with lock hold
> + */
> +static inline int
> +nano_semaphore_holder_match(struct nano_semaphore *s, struct task_struct *task)
> +{
> +       return s->holder == task;
> +}
> +
> +/*
> + * Helper function to set `task' to be the holder of nano semaphore
> + *
> + * Called with lock hold
> + */
> +static inline void
> +nano_semaphore_set_holder(struct nano_semaphore *s, struct task_struct *task)
> +{
> +       s->holder = task;
> +}
> +
> +/*
> + * Helper function try to acquire the nano semaphore
> + *
> + * Returns 1 if acquired successfully, 0 otherwise.
> + *
> + * Called with lock hold
> + */
> +static inline int __nano_semaphore_try_down(struct nano_semaphore *s)
> +{
> +       int ret;
> +
> +       ret = !nano_semaphore_waiter_pending(s) &&
> +               nano_semaphore_holder_empty(s);
> +       if (ret)
> +               nano_semaphore_set_holder(s, current);
> +
> +       return ret;
> +}
> +
> +/*
> + * nano_semaphore_try_down - try to acquire the nano semaphore without waiting
> + * @s: the nano semaphore to be acquired
> + *
> + * Returns 1 if acquired successfully, 0 otherwise.
> + */
> +static inline int nano_semaphore_try_down(struct nano_semaphore *s)
> +{
> +       unsigned long flags;
> +       int ret;
> +
> +       spin_lock_irqsave(&s->lock, flags);
> +       ret = __nano_semaphore_try_down(s);
> +       spin_unlock_irqrestore(&s->lock, flags);
> +
> +       return ret;
> +}
> +
> +
> +/* only for internal use by nano semaphore */
> +struct nano_semaphore_waiter {
> +       struct list_head        node;
> +       struct task_struct      *task;
> +};
> +
> +/*
> + * Helper function to init a waiter with `task'
> + */
> +static inline void nano_semaphore_waiter_init(struct nano_semaphore_waiter *w,
> +                                               struct task_struct *task)
> +{
> +       INIT_LIST_HEAD(&w->node);
> +       w->task = task;
> +}
> +
> +/*
> + * Helper function to get the first pending waiter of nano semaphore
> + *
> + * Called with lock hold
> + */
> +struct inline struct nano_semaphore_waiter *
> +nano_semaphore_get_waiter(struct nano_semaphore *s)
> +{
> +       if (nano_semaphore_waiter_pending(s))
> +               return list_first_entry(&s->chair,
> +                                       struct nano_semaphore_waiter, node);
> +       return NULL;
> +}
> +
> +/*
> + * Helper function to sleep a while
> + *
> + * Called with lock not hold
> + */
> +static inline int nano_semaphore_sleep(unsigned long nano_secs)
> +{
> +       int ret;
> +
> +       if (nano_secs) {
> +               ktime_t ktime = ktime_set(0, nano_secs);
> +
> +               ret = schedule_hrtimeout(&ktime, HRTIMER_MODE_REL);
> +       } else
> +               ret = schedule_hrtimeout(NULL, HRTIMER_MODE_REL);
> +
> +       return ret;
> +}
> +
> +/*
> + * nano_semaphore_down - acquire the nano semaphore
> + * @s: the nano semaphore to be acquired
> + * @nano_secs: the nano seconds to wait if necessary,
> + *             could be zero if want to wait as long as possible.
> + *
> + * Returns >0 if acquired successfully, <=0 otherwise.
> + *
> + * Note unlike down() in semaphore, nano_semaphore_down is not looping until
> + * the nano semaphore is hold, but simply reports the result. And the callers
> + * could, if they like, loop in simple manner, for instance,
> + *     while (1 != nano_semaphore_down(s, 800));
> + *     do_home_work();
> + *     nano_semaphore_up(s);
> + *
> + */
> +static inline int
> +nano_semaphore_down(struct nano_semaphore *s, unsigned long nano_secs)
> +{
> +       unsigned long flags;
> +       int ret;
> +       struct nano_semaphore_waiter w;
> +
> +       spin_lock_irqsave(&s->lock, flags);
> +
> +       ret = __nano_semaphore_try_down(s);
> +       if (ret)
> +               goto out;
> +
> +       nano_semaphore_waiter_init(&w, current);
> +
> +       __set_task_state(current, TASK_INTERRUPTIBLE);
> +
> +       list_add_tail(&w.node, &s->chair);
> +
> +       spin_unlock_irqrestore(&s->lock, flags);
> +       ret = nano_semaphore_sleep(nano_secs);
> +       spin_lock_irqsave(&s->lock, flags);
> +
> +       list_del(&w.node);
> +
> +       if (nano_semaphore_holder_match(s, current))
> +               ret = 1;
> + out:
> +       spin_unlock_irqrestore(&s->lock, flags);
> +
> +       return ret;
> +}
> +
> +/**
> + * nano_semaphore_up - release the nano semaphore
> + * @s: the nano semaphore to release
> + *
> + * Note nano_semaphore_up() could be called even by tasks which have never
> + * called nano_semaphore_down(), but the tricky is not recommended.
> + */
> +static inline void nano_semaphore_up(struct nano_semaphore *s)
> +{
> +       struct nano_semaphore_waiter *w;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&s->lock, flags);
> +
> +       if (! nano_semaphore_holder_match(s, current))
> +               goto out;
> +
> +       w = nano_semaphore_get_waiter(s);
> +       if (w) {
> +               nano_semaphore_set_holder(s, w->task);
> +               wake_up_process(w->task);
> +       } else
> +               nano_semaphore_set_holder(s, NULL);
> + out:
> +       spin_unlock_irqrestore(&s->lock, flags);
> +}
> +
> +#endif /* __NANO_SEMAPHORE_H_ */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
