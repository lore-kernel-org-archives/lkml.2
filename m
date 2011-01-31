Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1AaVRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:17:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1AaVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:17:12 -0500
Subject: Re: call_function_many: fix list delete vs add race
From: Peter Zijlstra <peterz@infradead.org>
To: Milton Miller <miltonm@bga.com>
Cc: akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-list-race-fix@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 22:17:57 +0100
Message-ID: <1296508677.26581.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 18:20 -0600, Milton Miller wrote:
> @@ -491,15 +491,17 @@ void smp_call_function_many(const struct
>         cpumask_clear_cpu(this_cpu, data->cpumask);
>  
>         /*
> -        * To ensure the interrupt handler gets an complete view
> -        * we order the cpumask and refs writes and order the read
> -        * of them in the interrupt handler.  In addition we may
> -        * only clear our own cpu bit from the mask.
> +        * We reuse the call function data without waiting for any grace
> +        * period after some other cpu removes it from the global queue.
> +        * This means a cpu might find our data block as it is writen.
> +        * The interrupt handler waits until it sees refs filled out
> +        * while its cpu mask bit is set; here we may only clear our
> +        * own cpu mask bit, and must wait to set refs until we are sure
> +        * previous writes are complete and we have obtained the lock to
> +        * add the element to the queue.  We use the acquire and release
> +        * of the lock as a wmb() -- acquire prevents write moving up and
> +        * release requires old writes are visible.

That's wrong:

 ->foo =
 LOCK
 UNLOCK
 ->bar =

can be re-ordered as:

 LOCK
 ->bar =
 ->foo =
 UNLOCK

Only a UNLOCK+LOCK sequence can be considered an MB.

However, I think the code is still OK, because list_add_rcu() implies a
wmb(), so in that respect its an improvement since we fix a race and
avoid an extra wmb. But the comment needs an update.

>          */
> -       smp_wmb();
> -
> -       atomic_set(&data->refs, cpumask_weight(data->cpumask));
> -
>         raw_spin_lock_irqsave(&call_function.lock, flags);
>         /*
>          * Place entry at the _HEAD_ of the list, so that any cpu still
> @@ -509,6 +511,8 @@ void smp_call_function_many(const struct
>         list_add_rcu(&data->csd.list, &call_function.queue);
>         raw_spin_unlock_irqrestore(&call_function.lock, flags);

And this wants to grow a comment that it relies on the wmb implied by
list_add_rcu()

> +       atomic_set(&data->refs, cpumask_weight(data->cpumask));
> +
>         /*
>          * Make the list addition visible before sending the ipi.
>          * (IPIs must obey or appear to obey normal Linux cache 

