Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403Ab2COTHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:07:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161277Ab2COTHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:07:17 -0400
Date: Thu, 15 Mar 2012 20:07:56 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Ido Yariv <ido@wizery.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Flush the irq thread on synchronization
Message-ID: <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
 <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:07:30AM -0700, tip-bot for Ido Yariv wrote:

Ido, Thomas,

Sorry for being late into the discussion.
Have couple of concerns regarding this hunk..

> @@ -783,39 +789,30 @@ static int irq_thread(void *data)
>  	current->irq_thread = 1;
>  
>  	while (!irq_wait_for_interrupt(action)) {
> +		irqreturn_t action_ret;
>  
>  		irq_thread_check_affinity(desc, action);
>  
> -		atomic_inc(&desc->threads_active);
> +		action_ret = handler_fn(desc, action);
> +		if (!noirqdebug)
> +			note_interrupt(action->irq, desc, action_ret);
>  
> -		raw_spin_lock_irq(&desc->lock);
> -		if (unlikely(irqd_irq_disabled(&desc->irq_data))) {
> -			/*
> -			 * CHECKME: We might need a dedicated
> -			 * IRQ_THREAD_PENDING flag here, which
> -			 * retriggers the thread in check_irq_resend()
> -			 * but AFAICT IRQS_PENDING should be fine as it
> -			 * retriggers the interrupt itself --- tglx
> -			 */
> -			desc->istate |= IRQS_PENDING;
> -			raw_spin_unlock_irq(&desc->lock);
> -		} else {
> -			irqreturn_t action_ret;
> -
> -			raw_spin_unlock_irq(&desc->lock);
> -			action_ret = handler_fn(desc, action);
> -			if (!noirqdebug)
> -				note_interrupt(action->irq, desc, action_ret);
> -		}
> -
> -		wake = atomic_dec_and_test(&desc->threads_active);
> -
> -		if (wake && waitqueue_active(&desc->wait_for_threads))
> -			wake_up(&desc->wait_for_threads);
> +		wake_threads_waitq(desc);
>  	}
>  
> -	/* Prevent a stale desc->threads_oneshot */
> -	irq_finalize_oneshot(desc, action, true);
> +	/*
> +	 * This is the regular exit path. __free_irq() is stopping the
> +	 * thread via kthread_stop() after calling
> +	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
> +	 * oneshot mask bit should be set.
> +	 *
> +	 * Verify that this is true.
> +	 */
> +	if (WARN_ON(test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags)))
> +		wake_threads_waitq(desc);

If we hit this warning we do not know if this IRQTF_RUNTHREAD bit's count in
desc->threads_active was decremented or not.

Nevertheless, wake_threads_waitq() gets called and desc->threads_active gets
decremented. As result, if desc->threads_active initially was decremented, we
might wrongly wake up the queue while some threaded handler is still running.

By contrast, if we choose not to wake up here, we might stuck in
synchronize_irq(). Which is probably better than a fooling synchronize_irq().

> +
> +	if (WARN_ON(desc->threads_oneshot & action->thread_mask))
> +		irq_finalize_oneshot(desc, action, true);

This check is called when the action is already removed in __free_irq() and no
desc->lock is held. Hence, a concurrent __setup_irq() could reallocate the very
same bit in the meantime. So neither irq_finalize_oneshot() nor the warning
are legitimate here.

>  
>  	/*
>  	 * Clear irq_thread. Otherwise exit_irq_thread() would make

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
