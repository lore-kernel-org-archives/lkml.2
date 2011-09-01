Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab1IADUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:20:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:16651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab1IADUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,310,1312182000"; 
   d="scan'208";a="44548700"
Message-ID: <4E5EFA08.30205@intel.com>
Date: Thu, 01 Sep 2011 11:20:40 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>	 <1314681384-20881-2-git-send-email-ying.huang@intel.com> <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
In-Reply-To: <4E5EE409.3060102@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 09:46 AM, Huang Ying wrote:
>>> -static void __irq_work_queue(struct irq_work *entry)
>>> +static void __irq_work_queue(struct irq_work *work)
>>>  {
>>> -	struct irq_work *next;
>>> +	struct irq_work_list *irq_work_list;
>>>  
>>> -	preempt_disable();
>>> +	irq_work_list = &get_cpu_var(irq_work_lists);
>>>  
>>> -	do {
>>> -		next = __this_cpu_read(irq_work_list);
>>> -		/* Can assign non-atomic because we keep the flags set. */
>>> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
>>> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
>>> +	llist_add(&work->llnode, &irq_work_list->llist);
>>>  
>>>  	/* The list was empty, raise self-interrupt to start processing. */
>>> -	if (!irq_work_next(entry))
>>> +	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
>>>  		arch_irq_work_raise();
>>
>> So why can't you simply test work->llnode->next?
> 
> Yes.  That is better.  Even if there may be a small race window, it is
> not a big issue to raise one extra self interrupt seldom.

Remember something about this.  I didn't test work->llnode->next here
because I didn't want expose the implementation details like that here.
 How about make llist_add() return whether list is empty before adding?
 Because it will be an inline function, that should be optimized out if
the caller do not need the information.

Best Regards,
Huang Ying
