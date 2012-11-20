Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2KTUOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:14:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2KTUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:14:16 -0500
Date: Tue, 20 Nov 2012 12:14:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] wait: add wait_event_lock_irq() interface
Message-Id: <20121120121414.a402ca43.akpm@linux-foundation.org>
In-Reply-To: <1353403385-735-1-git-send-email-lczerner@redhat.com>
References: <1353403385-735-1-git-send-email-lczerner@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 10:23:04 +0100
Lukas Czerner <lczerner@redhat.com> wrote:

> New wait_event_lock_irq{,cmd} macros added. This commit moves the
> private wait_event_lock_irq() macro from MD to regular wait includes,
> introduces new macro wait_event_lock_irq_cmd() instead of using the old
> method with omitting cmd parameter which is ugly and makes a use of new
> macros in the MD.
> 
> The use of new interface is when one have a special lock to protect data
> structures used in the condition, or one also needs to invoke "cmd"
> before putting it to sleep.
> 
> Both new macros are expected to be called with the lock taken. The lock
> is released before sleep and reacquired afterwards. We will leave the
> macro with the lock held.

Moving generic code out of md is a good thing.  It never should have
been put there.  Bad md.

> ...
>
> +#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
> +do {									\
> +	wait_queue_t __wait;						\
> +	init_waitqueue_entry(&__wait, current);				\
> +									\

The above two lines should be swapped - the blank line goes between
end-of-locals and start-of-code.

> +	add_wait_queue(&wq, &__wait);					\
> +	for (;;) {							\
> +		set_current_state(TASK_UNINTERRUPTIBLE);		\
> +		if (condition)						\
> +			break;						\
> +		spin_unlock_irq(&lock);					\
> +		cmd;							\
> +		schedule();						\
> +		spin_lock_irq(&lock);					\
> +	}								\
> +	current->state = TASK_RUNNING;					\
> +	remove_wait_queue(&wq, &__wait);				\
> +} while (0)

I'm scratching my head a bit over which situations this will be used
in, particularly outside md.

Because calling schedule() immediately after calling `cmd' might be a
problem for some callers.  Or at least, suboptimal.  If that evaluation
of `cmd' results in `condition' becoming true then we don't *want* to
call schedule().  Yes, `cmd' would have put this thread into
TASK_RUNNING, but it was just a waste of cycles.

So I wonder if we should retest `condition' there.  Or, perhaps, test
the return value of `cmd'.

Also, wait_event() uses prepare_to_wait().  It's a bit neater and more
efficient because the wakeup removes the waiter from the waitqueue.  I
wonder if we can use prepare_to_wait() here.

Also, we will surely end up needing TASK_INTERRUPTIBLE versions of
these macros, so you may as well design for that (or actually implement
them) in version 1.

> +/**
> + * wait_event_lock_irq_cmd - sleep until a condition gets true. The
> + * 			     condition is checked under the lock. This
> + * 			     is expected to be called with the lock
> + * 			     taken.
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + * @lock: a locked lock, which will be released before cmd and schedule()
> + * 	  and reacquired afterwards.

@lock isn't just any old lock.  It must have type spinlock_t.  It's
worth mentioning this here.  This is a significant restriction of this
interface!

> + * @cmd: a command which is invoked outside the critical section before
> + *       sleep
> + *
> + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> + * @condition evaluates to true. The @condition is checked each time
> + * the waitqueue @wq is woken up.
> + *
> + * wake_up() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + *
> + * This is supposed to be called with holding the lock. The lock is

s/with/while/

> + * dropped before invoking the cmd and going to sleep and reacquired

s/reacquired/ is reacquired/

> + * afterwards.
> + */
> +#define wait_event_lock_irq_cmd(wq, condition, lock, cmd) 		\
> +do {									\
> +	if (condition)	 						\
> +		break;							\
> +	__wait_event_lock_irq(wq, condition, lock, cmd);		\
> +} while (0)
> +
> +/**
> + * wait_event_lock_irq - sleep until a condition gets true. The
> + * 			 condition is checked under the lock. This
> + * 			 is expected to be called with the lock
> + * 			 taken.
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + * @lock: a locked lock, which will be released before schedule()
> + * 	  and reacquired afterwards.
> + *
> + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> + * @condition evaluates to true. The @condition is checked each time
> + * the waitqueue @wq is woken up.
> + *
> + * wake_up() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + *
> + * This is supposed to be called with holding the lock. The lock is
> + * dropped before going to sleep and reacquired afterwards.
> + */
> +#define wait_event_lock_irq(wq, condition, lock) 			\
> +do {									\
> +	if (condition)	 						\
> +		break;							\
> +	__wait_event_lock_irq(wq, condition, lock, );			\
> +} while (0)
> +
>  /*
>   * These are the old interfaces to sleep waiting for an event.
>   * They are racy.  DO NOT use them, use the wait_event* interfaces above.
>
> ...
>
