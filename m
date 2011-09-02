Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab1IBBI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:08:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:25142 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab1IBBI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:08:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,316,1312182000"; 
   d="scan'208";a="47465329"
Message-ID: <4E602CA4.4000703@intel.com>
Date: Fri, 02 Sep 2011 09:08:52 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com> <1314681384-20881-2-git-send-email-ying.huang@intel.com> <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com> <4E5EFA08.30205@intel.com> <1314863927.7945.11.camel@twins> <4E5F48D1.801@intel.com> <20110901125140.GA22737@Krystal>
In-Reply-To: <20110901125140.GA22737@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 08:51 PM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
>> On 09/01/2011 03:58 PM, Peter Zijlstra wrote:
>>> On Thu, 2011-09-01 at 11:20 +0800, Huang Ying wrote:
>>>> On 09/01/2011 09:46 AM, Huang Ying wrote:
>>>>>>> -static void __irq_work_queue(struct irq_work *entry)
>>>>>>> +static void __irq_work_queue(struct irq_work *work)
>>>>>>>  {
>>>>>>> -	struct irq_work *next;
>>>>>>> +	struct irq_work_list *irq_work_list;
>>>>>>>  
>>>>>>> -	preempt_disable();
>>>>>>> +	irq_work_list = &get_cpu_var(irq_work_lists);
>>>>>>>  
>>>>>>> -	do {
>>>>>>> -		next = __this_cpu_read(irq_work_list);
>>>>>>> -		/* Can assign non-atomic because we keep the flags set. */
>>>>>>> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
>>>>>>> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
>>>>>>> +	llist_add(&work->llnode, &irq_work_list->llist);
>>>>>>>  
>>>>>>>  	/* The list was empty, raise self-interrupt to start processing. */
>>>>>>> -	if (!irq_work_next(entry))
>>>>>>> +	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
>>>>>>>  		arch_irq_work_raise();
>>>>>>
>>>>>> So why can't you simply test work->llnode->next?
>>>>>
>>>>> Yes.  That is better.  Even if there may be a small race window, it is
>>>>> not a big issue to raise one extra self interrupt seldom.
>>>>
>>>> Remember something about this.  I didn't test work->llnode->next here
>>>> because I didn't want expose the implementation details like that here.
>>>>  How about make llist_add() return whether list is empty before adding?
>>>>  Because it will be an inline function, that should be optimized out if
>>>> the caller do not need the information.
> 
> Yes, that would make sense.
> 
> something like
> 
> static inline
> struct llist_node *llist_add(struct llist_node *new, struct llist_head *head)
> {
> 	struct llist_node *entry, *old_entry;
> 
> #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
> 	BUG_ON(in_nmi());
> #endif
> 
> 	entry = head->first;
> 	do {
> 		old_entry = entry;
> 		new->next = entry;
> 		cpu_relax();
> 	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
>         return old_entry;
> }
> 
> Where llist_add returns NULL if the list was initially empty, else
> returns non-null. This return value usage should be documented in the
> function header, of course.
> 
> BUT, big warning here: this whole thing _should_ be renamed as a
> "lockless stack" rather than a "lockless list". Really. I said it in the
> past, and here I see another example showing why we should. The only
> reason why we can get away this easily with knowing atomically if the
> structure was empty prior to the insertion is because this "list"
> hehaves like a stack (LIFO). I foresee we'll need to add "lockless
> queues" at some point (FIFO), which has the ability to enqueue/dequeue
> concurrently without sharing the same cache-lines when the queue is
> non-empty. Within that kind of queue structure, knowing if the queue was
> empty prior to insertion would become a bottleneck, so I would not
> advise to make that part of _that_ API, which would require to add a new
> "llqueue" API. And at that point, the "llist" vs "llqueue" semantic
> would become really confusing. Maybe "llstack" would be more appropriate
> here instead of llist ? Or llfifo ? The API we can provide with a
> lock-less structure does not only depend on how the elements are
> organized, but also on the operations allowed on the structure. So the
> API should reflect that. So I'm saying this warning again: if we don't
> fix that now, I think we're heading into a lock-free structure
> namespacing trainwreck that will limit our ability to add other
> lock-free operations due vague naming that does not take the operations
> allowed on the structure into consideration, combined with API
> constraints permitted by a specific given behavior (e.g. FIFO semantic)
> that tend to define these lock-free APIs.

I remember the previous consensus between us is to keep the API of llist
and may change its implementation in the future.  But it seems that
define a really general llist API is too hard.  But fortunately, because
llist is just inside kernel (not like a user space library, which is
used by various applications), we can change its name in the future if
it is needed.

> I've been working on lock-free structures myself in Userspace RCU: I
> have lock-free stack and queue, wait-free stack, wait-free queue, and
> (work in progress), RCU red-black tree (not lock-free), and lock-free
> RCU expandable hash table. If we plan namespacing of lock-free data
> structure correctly, I think there will be room for very interesting
> performance and scalability improvements in the future.

That is interesting.  But we need find the user in Linux kernel first.

>>>
>>> You could also use llist_empty() although that brings me to that
>>> ACCESS_ONCE thing in there, what's the point?
>>
>> Something as follow with llist_empty() seems not work.
>>
>>   empty = llist_empty(irq_work_list);
>>   llist_add(&work->llnode, irq_work_list);
>>   if (empty)
>>           arch_irq_work_raise();
>>
>> Because irq_work IRQ handler or timer IRQ handler may be executed just
>> before "llist_add(&work->llnode, irq_work_list)", so that, although
>> "empty == false", arch_irq_work_raise() still should be executed.
>>
>> Can you tell me how to that with llist_empty()?
>>
>>
>> For ACCESS_ONCE, Mathiew suggest me to add it,
>>
>> Hi, Mathiew,
>>
>> Can you explain why ACCESS_ONCE should be used here?
> 
> It was mainly to force the compiler to re-fetch the head->first value
> from memory in busy-waiting loops. So even though the right practice is
> to have a cpu_relax() in the body of the loop (which would force the
> refetch due to the compiler barrier), having the ACCESS_ONCE in
> llist_empty() should not hurt much. It also seems to be what atomic*.h
> does (volatile read), so I guess the expected behavior wrt atomic
> accesses are to behave as volatile, hence my recommendation to make this
> llist_empty a volatile access. Quoting my previous email on that topic:
> 
> "Would it make sense to do:
> 
>  return ACCESS_ONCE(head->first) == NULL;
> 
> instead ? Otherwise the compiler can choose to keep the result around in
> registers without re-reading (e.g. busy waiting loop)."
> 
> So I was not implying it was strictly required, merely wondering whether
> it should be added.

Thanks for your explanation.  I should refer to our previous email
firstly.  I think your point is reasonable.

Best Regards,
Huang Ying
