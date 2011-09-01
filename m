Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1IABqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:46:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:47670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1IABqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:46:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="43978071"
Message-ID: <4E5EE409.3060102@intel.com>
Date: Thu, 01 Sep 2011 09:46:49 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>	 <1314681384-20881-2-git-send-email-ying.huang@intel.com> <1314785405.23993.21.camel@twins>
In-Reply-To: <1314785405.23993.21.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

Thanks for your comments.

On 08/31/2011 06:10 PM, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 13:16 +0800, Huang Ying wrote:
>> Use llist in irq_work instead of the lock-less linked list
>> implementation in irq_work to avoid the code duplication.
> 
> Except you make code horrid as well.. both this and xlist don't have
> additional function calls, whereas you do.
> 
> Also, WTFH do you have unconditinoal cpu_relax() calls inside the
> cmpxchg() loops, that's just bloody insane.

You mean we should not use cpu_relax before the first cmpxchg?  You
suggest something as follow?

void llist_add(struct llist_node *new, struct llist_head *head)
{
        struct llist_node *entry, *old_entry;

#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
        BUG_ON(in_nmi());
#endif

        entry = head->first;
        for (;;) {
                old_entry = entry;
                new->next = entry;
                entry = cmpxchg(&head->first, old_entry, new);
                if (entry == old_entry)
                        break;
                cpu_relax();
        }
}

> Move all of lib/llist.c inline, create a new macro for the
> 
> #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG                                                    
>         BUG_ON(in_nmi());                                                                    
> #endif 
> 
> blurb and loose the LLIST Kconfig.

OK.  I will do that.

>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>>  include/linux/irq_work.h |   15 ++++---
>>  init/Kconfig             |    1 
>>  kernel/irq_work.c        |   92 ++++++++++++++++++-----------------------------
>>  3 files changed, 47 insertions(+), 61 deletions(-)
>>
>> --- a/include/linux/irq_work.h
>> +++ b/include/linux/irq_work.h
>> @@ -1,20 +1,23 @@
>>  #ifndef _LINUX_IRQ_WORK_H
>>  #define _LINUX_IRQ_WORK_H
>>  
>> +#include <linux/llist.h>
>> +
>>  struct irq_work {
>> -	struct irq_work *next;
>> +	unsigned long flags;
>> +	struct llist_node llnode;
>>  	void (*func)(struct irq_work *);
>>  };
> 
> Separating out the flags is unfortunate, but ok.
> 
> 
>> +#define LIST_NONEMPTY_BIT	0
> 
> This is just sad, see below.
>  
>> -static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
>> -{
>> -	unsigned long next = (unsigned long)entry;
>> -	next |= flags;
>> -	return (struct irq_work *)next;
>> -}
>> +struct irq_work_list {
>> +	unsigned long flags;
>> +	struct llist_head llist;
>> +};
> 
> which is superfluous
> 
> 
>> @@ -77,23 +62,19 @@ void __weak arch_irq_work_raise(void)
>>  /*
>>   * Queue the entry and raise the IPI if needed.
>>   */
>> -static void __irq_work_queue(struct irq_work *entry)
>> +static void __irq_work_queue(struct irq_work *work)
>>  {
>> -	struct irq_work *next;
>> +	struct irq_work_list *irq_work_list;
>>  
>> -	preempt_disable();
>> +	irq_work_list = &get_cpu_var(irq_work_lists);
>>  
>> -	do {
>> -		next = __this_cpu_read(irq_work_list);
>> -		/* Can assign non-atomic because we keep the flags set. */
>> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
>> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
>> +	llist_add(&work->llnode, &irq_work_list->llist);
>>  
>>  	/* The list was empty, raise self-interrupt to start processing. */
>> -	if (!irq_work_next(entry))
>> +	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
>>  		arch_irq_work_raise();
> 
> So why can't you simply test work->llnode->next?

Yes.  That is better.  Even if there may be a small race window, it is
not a big issue to raise one extra self interrupt seldom.

> and loose the get/put
> cpu muck? The existing preempt_disable/enable() are already superfluous
> and could be removed, you just made all this way more horrid than need
> be.

Will it cause race condition to remove preempt_disable/enable?
Considering something as follow:

- get irq_work_list of CPU A
- queue irq_work into irq_work_list of CPU A
- preempted and resumed execution on CPU B
- arch_irq_work_raise on CPU B

irq_work_run on CPU B will do nothing.  While irq_work need to wait for
next timer interrupt.  Isn't it an issue?

Best Regards,
Huang Ying
