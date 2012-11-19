Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2KSPKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:10:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2KSPKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:10:43 -0500
Date: Mon, 19 Nov 2012 16:10:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section
	needlessly
Message-ID: <20121119151050.GA4270@redhat.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com> <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Ivo Sieben wrote:
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3090,9 +3090,22 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,
>  {
>  	unsigned long flags;
>
> -	spin_lock_irqsave(&q->lock, flags);
> -	__wake_up_common(q, mode, nr_exclusive, 0, key);
> -	spin_unlock_irqrestore(&q->lock, flags);
> +	/*
> +	 * We check for list emptiness outside the lock. This prevents the wake
> +	 * up to enter the critical section needlessly when the task list is
> +	 * empty.
> +	 *
> +	 * Placed a full memory barrier before checking list emptiness to make
> +	 * 100% sure this function sees an up-to-date list administration.
> +	 * Note that other code that manipulates the list uses a spin_lock and
> +	 * therefore doesn't need additional memory barriers.
> +	 */
> +	smp_mb();
> +	if (!list_empty(&q->task_list)) {

waitqueue_active() ?

> +		spin_lock_irqsave(&q->lock, flags);
> +		__wake_up_common(q, mode, nr_exclusive, 0, key);
> +		spin_unlock_irqrestore(&q->lock, flags);
> +	}

I am wondering if it makes sense unconditionally. A lot of callers do

	if (waitqueue_active(q))
		wake_up(...);

this patch makes the optimization above pointless and adds mb().


But I won't argue.

Oleg.

