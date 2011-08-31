Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1HaKKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:10:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57113 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1HaKKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:10:16 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 31 Aug 2011 12:10:05 +0200
In-Reply-To: <1314681384-20881-2-git-send-email-ying.huang@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
	 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314785405.23993.21.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 13:16 +0800, Huang Ying wrote:
> Use llist in irq_work instead of the lock-less linked list
> implementation in irq_work to avoid the code duplication.

Except you make code horrid as well.. both this and xlist don't have
additional function calls, whereas you do.

Also, WTFH do you have unconditinoal cpu_relax() calls inside the
cmpxchg() loops, that's just bloody insane.

Move all of lib/llist.c inline, create a new macro for the

#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG                                                    
        BUG_ON(in_nmi());                                                                    
#endif 

blurb and loose the LLIST Kconfig.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/irq_work.h |   15 ++++---
>  init/Kconfig             |    1 
>  kernel/irq_work.c        |   92 ++++++++++++++++++-----------------------------
>  3 files changed, 47 insertions(+), 61 deletions(-)
> 
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -1,20 +1,23 @@
>  #ifndef _LINUX_IRQ_WORK_H
>  #define _LINUX_IRQ_WORK_H
>  
> +#include <linux/llist.h>
> +
>  struct irq_work {
> -	struct irq_work *next;
> +	unsigned long flags;
> +	struct llist_node llnode;
>  	void (*func)(struct irq_work *);
>  };

Separating out the flags is unfortunate, but ok.


> +#define LIST_NONEMPTY_BIT	0

This is just sad, see below.
 
> -static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
> -{
> -	unsigned long next = (unsigned long)entry;
> -	next |= flags;
> -	return (struct irq_work *)next;
> -}
> +struct irq_work_list {
> +	unsigned long flags;
> +	struct llist_head llist;
> +};

which is superfluous


> @@ -77,23 +62,19 @@ void __weak arch_irq_work_raise(void)
>  /*
>   * Queue the entry and raise the IPI if needed.
>   */
> -static void __irq_work_queue(struct irq_work *entry)
> +static void __irq_work_queue(struct irq_work *work)
>  {
> -	struct irq_work *next;
> +	struct irq_work_list *irq_work_list;
>  
> -	preempt_disable();
> +	irq_work_list = &get_cpu_var(irq_work_lists);
>  
> -	do {
> -		next = __this_cpu_read(irq_work_list);
> -		/* Can assign non-atomic because we keep the flags set. */
> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
> +	llist_add(&work->llnode, &irq_work_list->llist);
>  
>  	/* The list was empty, raise self-interrupt to start processing. */
> -	if (!irq_work_next(entry))
> +	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
>  		arch_irq_work_raise();

So why can't you simply test work->llnode->next? and loose the get/put
cpu muck? The existing preempt_disable/enable() are already superfluous
and could be removed, you just made all this way more horrid than need
be.

>  
> -	preempt_enable();
> +	put_cpu_var(irq_work_list);
>  }

