Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab2HXVXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:23:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2HXVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:22:58 -0400
Date: Fri, 24 Aug 2012 14:22:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] aoe: kernel thread handles I/O completions for
 simple locking
Message-Id: <20120824142257.cbfb21a6.akpm@linux-foundation.org>
In-Reply-To: <752ecb77a67b4ba55e8f3ebddd745491aacc8818.1345743801.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
	<752ecb77a67b4ba55e8f3ebddd745491aacc8818.1345743801.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012 21:24:08 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> This patch makes the frames the aoe driver uses to track the
> relationship between bios and packets more flexible and detached, so
> that they can be passed to an "aoe_ktio" thread for completion of I/O.
> 
> The frames are handled much like skbs, with a capped amount of
> preallocation so that real-world use cases are likely to run smoothly
> and degenerate gracefully even under memory pressure.
> 
> Decoupling I/O completion from the receive path and serializing it in
> a process makes it easier to think about the correctness of the
> locking in the driver, especially in the case of a remote MAC address
> becoming unusable.
> 
> ...
>
> +static int
> +kthread(void *vp)
> +{
> +	struct ktstate *k;
> +	DECLARE_WAITQUEUE(wait, current);
> +	sigset_t blocked;
> +	int more;
> +
> +	k = vp;
> +#ifdef PF_NOFREEZE

PF_NOFREEZE can never be undefined.

> +	current->flags |= PF_NOFREEZE;
> +#endif
> +	set_user_nice(current, -10);
> +	sigfillset(&blocked);
> +	sigprocmask(SIG_BLOCK, &blocked, NULL);
> +	flush_signals(current);

This is a kernel thread - it shouldn't need to fiddle with signals.

> +	complete(&k->rendez);

That's odd.  Why do a complete() before we even start?  A code comment
is needed if this is indeed correct.

> +	do {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);

I think this statement is simply unneeded.

> +		spin_lock_irq(k->lock);
> +		more = k->fn();
> +		if (!more) {
> +			add_wait_queue(k->waitq, &wait);
> +			__set_current_state(TASK_INTERRUPTIBLE);
> +		}
> +		spin_unlock_irq(k->lock);
> +		if (!more) {
> +			schedule();
> +			remove_wait_queue(k->waitq, &wait);
> +		} else
> +			cond_resched();

Here we can do a cond_resched() when in state TASK_INTERRUPTIBLE.  Such
a schedule() will never return unless some other thread flips this task
into state TASK_RUNNING.  But if another thread does that, we should
have been on that waitqueue!

It seems all confused and racy.

> +	} while (!kthread_should_stop());
> +	__set_current_state(TASK_RUNNING);

I don't think there's any path by which we can get here in any state
other than TASK_RUNNING.

> +	complete(&k->rendez);
> +	return 0;
> +}

This function might be a bit neater if it were to use
prepare_to_wait()/finish_wait().

> +static void
> +aoe_ktstop(struct ktstate *k)
> +{
> +	kthread_stop(k->task);
> +	wait_for_completion(&k->rendez);
> +}
> +
> +static int
> +aoe_ktstart(struct ktstate *k)
> +{
> +	struct task_struct *task;
> +
> +	init_completion(&k->rendez);
> +	task = kthread_run(kthread, k, k->name);
> +	if (task == NULL || IS_ERR(task))
> +		return -EFAULT;

EFAULT makes no sense?

> +	k->task = task;
> +	wait_for_completion(&k->rendez);
> +	init_completion(&k->rendez);	/* for exit */
> +	return 0;
> +}
>
> ...
>
