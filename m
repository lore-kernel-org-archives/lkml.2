Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2KUPT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab2KUPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:19:27 -0500
Date: Wed, 21 Nov 2012 16:19:06 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-104.brq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        Neil Brown <neilb@suse.de>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] wait: add wait_event_lock_irq() interface
In-Reply-To: <20121120121414.a402ca43.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1211211526320.28163@dhcp-1-104.brq.redhat.com>
References: <1353403385-735-1-git-send-email-lczerner@redhat.com> <20121120121414.a402ca43.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Andrew Morton wrote:

> Date: Tue, 20 Nov 2012 12:14:14 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
>     jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
>     David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
>     Peter Zijlstra <a.p.zijlstra@chello.nl>
> Subject: Re: [PATCH 1/2] wait: add wait_event_lock_irq() interface
> 
> On Tue, 20 Nov 2012 10:23:04 +0100
> Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > New wait_event_lock_irq{,cmd} macros added. This commit moves the
> > private wait_event_lock_irq() macro from MD to regular wait includes,
> > introduces new macro wait_event_lock_irq_cmd() instead of using the old
> > method with omitting cmd parameter which is ugly and makes a use of new
> > macros in the MD.
> > 
> > The use of new interface is when one have a special lock to protect data
> > structures used in the condition, or one also needs to invoke "cmd"
> > before putting it to sleep.
> > 
> > Both new macros are expected to be called with the lock taken. The lock
> > is released before sleep and reacquired afterwards. We will leave the
> > macro with the lock held.
> 
> Moving generic code out of md is a good thing.  It never should have
> been put there.  Bad md.
> 
> > ...
> >
> > +#define __wait_event_lock_irq(wq, condition, lock, cmd) 		\
> > +do {									\
> > +	wait_queue_t __wait;						\
> > +	init_waitqueue_entry(&__wait, current);				\
> > +									\
> 
> The above two lines should be swapped - the blank line goes between
> end-of-locals and start-of-code.

Good point.

> 
> > +	add_wait_queue(&wq, &__wait);					\
> > +	for (;;) {							\
> > +		set_current_state(TASK_UNINTERRUPTIBLE);		\
> > +		if (condition)						\
> > +			break;						\
> > +		spin_unlock_irq(&lock);					\
> > +		cmd;							\
> > +		schedule();						\
> > +		spin_lock_irq(&lock);					\
> > +	}								\
> > +	current->state = TASK_RUNNING;					\
> > +	remove_wait_queue(&wq, &__wait);				\
> > +} while (0)
> 
> I'm scratching my head a bit over which situations this will be used
> in, particularly outside md.
> 
> Because calling schedule() immediately after calling `cmd' might be a
> problem for some callers.  Or at least, suboptimal.  If that evaluation
> of `cmd' results in `condition' becoming true then we don't *want* to
> call schedule().  Yes, `cmd' would have put this thread into
> TASK_RUNNING, but it was just a waste of cycles.
> 
> So I wonder if we should retest `condition' there.  Or, perhaps, test
> the return value of `cmd'.

Right, it might makes sense to swap the lines and let cmd to be run
after the schedule(). That way, if 'cmd' would result in 'condition'
becoming true, then we would catch it before going to schedule()
again.

> 
> Also, wait_event() uses prepare_to_wait().  It's a bit neater and more
> efficient because the wakeup removes the waiter from the waitqueue.  I
> wonder if we can use prepare_to_wait() here.

I suspect that it was a tradeoff between using the neat
prepare_to_wait() with waitqueue removal, but having to lock the
wait_queue_head_t->lock or using simply set_current_state() since
we already hold external 'lock'.

Whoever wrote the code originally thought that it was better this
way, however since the waitqueue lock should not actually be
contended at all here, I think it is ok to use prepare_to_wait().

> 
> Also, we will surely end up needing TASK_INTERRUPTIBLE versions of
> these macros, so you may as well design for that (or actually implement
> them) in version 1.

Sure, I can add the TASK_INTERRUPTIBLE version as well. The reason I
did not included that initially was that I did not want to introduce
unused code. But if you're ok with it, I'll add it.

> 
> > +/**
> > + * wait_event_lock_irq_cmd - sleep until a condition gets true. The
> > + * 			     condition is checked under the lock. This
> > + * 			     is expected to be called with the lock
> > + * 			     taken.
> > + * @wq: the waitqueue to wait on
> > + * @condition: a C expression for the event to wait for
> > + * @lock: a locked lock, which will be released before cmd and schedule()
> > + * 	  and reacquired afterwards.
> 
> @lock isn't just any old lock.  It must have type spinlock_t.  It's
> worth mentioning this here.  This is a significant restriction of this
> interface!

Right, it's better to be explicit.

> 
> > + * @cmd: a command which is invoked outside the critical section before
> > + *       sleep
> > + *
> > + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> > + * @condition evaluates to true. The @condition is checked each time
> > + * the waitqueue @wq is woken up.
> > + *
> > + * wake_up() has to be called after changing any variable that could
> > + * change the result of the wait condition.
> > + *
> > + * This is supposed to be called with holding the lock. The lock is
> 
> s/with/while/
> 
> > + * dropped before invoking the cmd and going to sleep and reacquired
> 
> s/reacquired/ is reacquired/

Thanks!
-Lukas

> 
> > + * afterwards.
> > + */
> > +#define wait_event_lock_irq_cmd(wq, condition, lock, cmd) 		\
> > +do {									\
> > +	if (condition)	 						\
> > +		break;							\
> > +	__wait_event_lock_irq(wq, condition, lock, cmd);		\
> > +} while (0)
> > +
> > +/**
> > + * wait_event_lock_irq - sleep until a condition gets true. The
> > + * 			 condition is checked under the lock. This
> > + * 			 is expected to be called with the lock
> > + * 			 taken.
> > + * @wq: the waitqueue to wait on
> > + * @condition: a C expression for the event to wait for
> > + * @lock: a locked lock, which will be released before schedule()
> > + * 	  and reacquired afterwards.
> > + *
> > + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> > + * @condition evaluates to true. The @condition is checked each time
> > + * the waitqueue @wq is woken up.
> > + *
> > + * wake_up() has to be called after changing any variable that could
> > + * change the result of the wait condition.
> > + *
> > + * This is supposed to be called with holding the lock. The lock is
> > + * dropped before going to sleep and reacquired afterwards.
> > + */
> > +#define wait_event_lock_irq(wq, condition, lock) 			\
> > +do {									\
> > +	if (condition)	 						\
> > +		break;							\
> > +	__wait_event_lock_irq(wq, condition, lock, );			\
> > +} while (0)
> > +
> >  /*
> >   * These are the old interfaces to sleep waiting for an event.
> >   * They are racy.  DO NOT use them, use the wait_event* interfaces above.
> >
> > ...
> >
> 
