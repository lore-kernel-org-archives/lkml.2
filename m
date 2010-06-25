Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0FYTai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:30:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54520 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab0FYTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:30:36 -0400
Date: Fri, 25 Jun 2010 21:30:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, tglx <tglx@linutronix.de>,
       davem <davem@davemloft.net>, paulus <paulus@samba.org>
Subject: Re: [RFC][PATCH] irq_work -v2
Message-ID: <20100625193031.GD13421@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
 <1277361352.1875.838.camel@laptop>
 <1277490625.1875.986.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277490625.1875.986.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 08:30:25PM +0200, Peter Zijlstra wrote:

I'm not sure what all the logic for entry enqueued by someone
else is good for? Is that for the case you don't have enough
entries preallocated and you share them with someone else?

Normally if the sharing is per cpu that would be difficult 
to recover from because if it's due to a nest situation (for example)
you would deadlock.

For me it would seem simpler to simply not share.

> +	struct irq_work *list;
> +
> +	BUG_ON(!in_irq());
> +	BUG_ON(!irqs_disabled());
> +
> +	list = xchg(&__get_cpu_var(irq_work_list), NULL);
> +	while (list != NULL) {
> +		struct irq_work *entry = list;
> +
> +		list = irq_work_next(list);
> +
> +		/*
> +		 * Clear the PENDING bit, after this point the @entry
> +		 * can be re-used.
> +		 */
> +		entry->next = next_flags(NULL, IRQ_WORK_BUSY);
> +		entry->func(entry);

Needs compiler memory barrier here I think.

> +		/*
> +		 * Clear the BUSY bit and return to the free state if
> +		 * no-one else claimed it meanwhile.
> +		 */
> +		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
> +	}
> +}

-Andi
