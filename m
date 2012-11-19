Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2KSKVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:21:23 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40906 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2KSKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:21:21 -0500
Message-ID: <50AA07FA.5020503@linux.vnet.ibm.com>
Date: Mon, 19 Nov 2012 15:50:42 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section needlessly
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com> <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
In-Reply-To: <1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12111910-5490-0000-0000-000002821575
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,

On 11/19/2012 01:00 PM, Ivo Sieben wrote:
> Check the waitqueue task list to be non empty before entering the critical
> section. This prevents locking the spin lock needlessly in case the queue
> was empty, and therefor also prevent scheduling overhead on a PREEMPT_RT
> system.
> 
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
> 
>  a second repost of this patch v2: Can anyone respond?
>  Did I apply the memory barrier correct?
> 
>  v2:
>  - We don't need the "careful" list empty, a normal list empty is sufficient:
>    if you miss an update it was just as it happened a little later.
>  - Because of memory ordering problems we can observe an unupdated list
>    administration. This can cause an wait_event-like code to miss an event.
>    Adding a memory barrier befor checking the list to be empty will guarantee we
>    evaluate a 100% updated list adminsitration.
> 
>  kernel/sched/core.c |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d8927f..168a9b2 100644
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
> +		spin_lock_irqsave(&q->lock, flags);
> +		__wake_up_common(q, mode, nr_exclusive, 0, key);
> +		spin_unlock_irqrestore(&q->lock, flags);
> +	}
>  }
>  EXPORT_SYMBOL(__wake_up);
>  
> 
Looks good to me.
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Regards
Preeti U Murthy

