Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab1CaBj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:39:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:2222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab1CaBjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,271,1299484800"; 
   d="scan'208";a="411403055"
Message-ID: <4D93DB49.3060205@intel.com>
Date: Thu, 31 Mar 2011 09:39:21 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: About lock-less data structure patches
References: <4D928405.4050607@intel.com> <20110329182145.e64b66b5.akpm@linux-foundation.org> <4D9287C3.7030103@intel.com> <20110330032203.GC21838@one.firstfloor.org> <20110329202649.137a8a18.akpm@linux-foundation.org> <20110330133411.GA11101@Krystal> <BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl>
In-Reply-To: <BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mathieu,

Thank you very much for your review.  Do you have time to take a look at
the lock-less memory allocator as follow?

https://lkml.org/lkml/2011/2/21/15

On 03/30/2011 11:11 PM, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
>> * Andrew Morton (akpm@linux-foundation.org) wrote:
>>> On Wed, 30 Mar 2011 05:22:03 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>>> On Wed, Mar 30, 2011 at 09:30:43AM +0800, Huang Ying wrote:
>>>>> On 03/30/2011 09:21 AM, Andrew Morton wrote:
>>>>>> On Wed, 30 Mar 2011 09:14:45 +0800 Huang Ying <ying.huang@intel.com> wrote:
>>>>>>
>>>>>>> Hi, Andrew and Len,
>>>>>>>
>>>>>>> In my original APEI patches for 2.6.39, the following 3 patches is about
>>>>>>> lock-less data structure.
>>>>>>>
>>>>>>> [PATCH 1/7] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
>>>>>>> [PATCH 2/7] lib, Add lock-less NULL terminated single list
>>>>>>> [PATCH 6/7] lib, Make gen_pool memory allocator lockless
>>>>>>>
>>>>>>> Len think we need some non-Intel "Acked-by" or "Reviewed-by" for these
>>>>>>> patches to go through the ACPI git tree.  Or they should go through
>>>>>>> other tree, such as -mm tree.
>>>>>>
>>>>>> I just dropped a couple of your patches because include/linux/llist.h
>>>>>> vanished from linux-next.   Did Len trip over the power cord?
>>>>>
>>>>> Len has dropped lock-less data structure patches from acpi git tree.  He
>>>>> describe the reason in following mails.
>>>>>
>>>>> https://lkml.org/lkml/2011/3/2/501
>>>>> https://lkml.org/lkml/2011/3/23/6
>>>>
>>>> Ok so we still need a lockless reviewer really and I don't count.
>>>
>>> Well I think you count ;) If this is some Intel thing then cluebeat,
>>> cluebeat, cluebeat, overruled.
>>>
>>>> Copying Mathieu who did a lot of lockless stuff. Are you interested
>>>> in reviewing Ying's patches?
>>>
>>> That would be great.
>>
>> Sure, I can have a look. Huang, can you resend those three patches
>> adding me to CC list ? That will help me keep appropriate threading in
>> my review. Adding Paul McKenney would also be appropriate.
> 
> I know, I know, I said I would wait for a repost, but now the answer
> burns my fingers. ;-) I'm replying to the patch found in
> https://lkml.org/lkml/2011/2/21/13
> 
> 
>> --- /dev/null
>> +++ b/include/linux/llist.h
>> @@ -0,0 +1,98 @@
>> +#ifndef LLIST_H
>> +#define LLIST_H
>> +/*
>> + * Lock-less NULL terminated single linked list
> 
> Because this single-linked-list works like a stack (with "push"
> operation for llist_add, "pop" operation for llist_del_first), I would
> recommend to rename it accordingly (as a stack rather than "list"). If
> we think about other possible users of this kind of lock-free list, such
> as call_rcu(), a "queue" would be rather more appropriate than a "stack"
> (with enqueue/dequeue operations). So at the very least I would like to
> make sure this API keeps room for lock-free queue implementations that
> won't be confused with this stack API. It would also be important to
> figure out if what we really want is a stack or a queue. Some naming
> ideas follow (maybe they are a bit verbose, comments are welcome).
> 
> We should note that this list implements "lock-free" push and pop
> operations (cmpxchg loops), and a "wait-free" "llist_del_all" operation
> (using xchg) (only really true for architectures with "true" xchg
> operation though, not those using LL/SC). We should think about the real
> use-case requirements put on this lockless stack to decide which variant
> is most appropriate. We can either have, with the implementation you
> propose:
> 
> - Lock-free push
> - Pop protected by mutex
> - Wait-free pop all
> 
> Or, as an example of an alternative structure (as Paul and I implemented
> in the userspace RCU library):
> 
> - Wait-free push (stronger real-time guarantees provided by xchg())
> - Blocking pop/pop all (use cmpxchg and busy-wait for very short time
>   periods)
> 
> (there are others, with e.g. lock-free push, lock-free pop, lock-free
> pop all, but this one requires RCU read lock across the pop/pop/pop all
> operations and that memory reclaim of the nodes is only performed after
> a RCU grace-period has elapsed. This deals with ABA issues of concurrent
> push/pop you noticed without requiring mutexes protecting pop operations.)
> 
> So it all boils down to which are the constraints of the push/pop
> callers.  Typically, I would expect that the "push" operation has the
> most strict real-time constraints (and is possibly executed the most
> often, thus would also benefit from xchg() which is typically slightly
> faster than cmpxchg()), which would argue in favor of a wait-free
> push/blocking pop.  But maybe I'm lacking understanding of what you are
> trying to do with this stack. Do you need to ever pop from a NMI
> handler ?

In my user case, I don't need to pop in a NMI handler, just push.  But
we need to pop in a IRQ handler, so we can not use blocking pop.  Please
take a look at the user case patches listed later.

> Some ideas for API identifiers:
> 
> struct llist_head -> slist_stack_head
> struct llist_node -> slist_stack_node

Why call it a stack and a list?  Because it is a stack implemented with
single list?  I think it is better to name after usage instead of
implementation.

The next question is whether it should be named as stack or list.  I
think from current user's point of view, they think they are using a
list instead of stack.  There are 3 users so far as follow.

https://lkml.org/lkml/2011/1/17/14
https://lkml.org/lkml/2011/1/17/15
https://lkml.org/lkml/2011/2/21/16

And if we named this data structure as list, we can still use "queue"
for another data structure.  Do you think so?

> * For your lock-free push/pop + wait-free pop_all implementation:
> 
> llist_add -> slist_stack_push_lf        (lock-free)
> llist_del_first -> _slist_stack_pop     (needs mutex protection)
> llist_del_all -> slist_stack_pop_all_wf (wait-free)

Do we really need to distinguish between lock-free and wait-free from
interface?  Will we implement both slist_stack_push_lf and
slist_stack_push_wf for one data structure?

mutex is needed between multiple "_slist_stack_pop", but not needed
between slist_stack_push_lf and _slist_stack_pop.  I think it is hard to
explain that clearly via function naming.

> * If we choose to go with an alternate wait-free push implementation:
> 
> llist_add -> slist_stack_push_wf              (wait-free)
> llist_del_first -> slist_stack_pop_blocking   (blocking)
> llist_del_all -> slist_stack_pop_all_blocking (blocking)

We need non-blocking pop, so maybe you need implement another data
structure which has these interface.  I think there can be multiple
lock-less data structure in kernel.

>> + *
>> + * If there are multiple producers and multiple consumers, llist_add
>> + * can be used in producers and llist_del_all can be used in
>> + * consumers.  They can work simultaneously without lock.  But
>> + * llist_del_first can not be used here.  Because llist_del_first
>> + * depends on list->first->next does not changed if list->first is not
>> + * changed during its operation, but llist_del_first, llist_add,
>> + * llist_add sequence in another consumer may violate that.
> 
> You did not seem to define the locking rules when using both
> 
>   llist_del_all
> and
>   llist_del_first
> 
> in parallel. I expect that a mutex is needed, because a
> 
>   llist_del_all, llist_add, llist_add
> 
> in parallel with
> 
>   llist_del_first
> 
> could run into the same ABA problem as described above.

OK.  I will add that.

>> + *
>> + * If there are multiple producers and one consumer, llist_add can be
>> + * used in producers and llist_del_all or llist_del_first can be used
>> + * in the consumer.
>> + *
>> + * The list entries deleted via llist_del_all can be traversed with
>> + * traversing function such as llist_for_each etc.  But the list
>> + * entries can not be traversed safely before deleted from the list.
> 
> Given that this is in fact a stack, specifying the traversal order of
> llist_for_each and friends would be appropriate.

Ok.  I will add something like "traversing from head to tail" in the
comments.

>> + *
>> + * The basic atomic operation of this list is cmpxchg on long.  On
>> + * architectures that don't have NMI-safe cmpxchg implementation, the
>> + * list can NOT be used in NMI handler.  So code uses the list in NMI
>> + * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
>> + */
>> +
>> +struct llist_head {
>> +     struct llist_node *first;
>> +};
>> +
>> +struct llist_node {
>> +     struct llist_node *next;
>> +};
>> +
>> +#define LLIST_HEAD_INIT(name)        { NULL }
>> +#define LLIST_HEAD(name)     struct llist_head name = LLIST_HEAD_INIT(name)
>> +
>> +/**
>> + * init_llist_head - initialize lock-less list head
>> + * @head:    the head for your lock-less list
>> + */
>> +static inline void init_llist_head(struct llist_head *list)
>> +{
>> +     list->first = NULL;
>> +}
>> +
>> +/**
>> + * llist_entry - get the struct of this entry
>> + * @ptr:     the &struct llist_node pointer.
>> + * @type:    the type of the struct this is embedded in.
>> + * @member:  the name of the llist_node within the struct.
>> + */
>> +#define llist_entry(ptr, type, member)               \
>> +     container_of(ptr, type, member)
>> +
>> +/**
>> + * llist_for_each - iterate over some deleted entries of a lock-less list
>> + * @pos:     the &struct llist_node to use as a loop cursor
>> + * @node:    the first entry of deleted list entries
>> + *
>> + * In general, some entries of the lock-less list can be traversed
>> + * safely only after being deleted from list, so start with an entry
>> + * instead of list head.
>> + */
>> +#define llist_for_each(pos, node)                    \
>> +     for (pos = (node); pos; pos = pos->next)
>> +
>> +/**
>> + * llist_for_each_entry - iterate over some deleted entries of lock-less list of given type
>> + * @pos:     the type * to use as a loop cursor.
>> + * @node:    the fist entry of deleted list entries.
>> + * @member:  the name of the llist_node with the struct.
>> + *
>> + * In general, some entries of the lock-less list can be traversed
>> + * safely only after being removed from list, so start with an entry
>> + * instead of list head.
>> + */
>> +#define llist_for_each_entry(pos, node, member)                              \
>> +     for (pos = llist_entry((node), typeof(*pos), member);           \
>> +          &pos->member != NULL;                                      \
>> +          pos = llist_entry(pos->member.next, typeof(*pos), member))
>> +
>> +/**
>> + * llist_empty - tests whether a lock-less list is empty
> 
> How is this llist_empty test expected to be used in combination with
> other API members ? e.g. llist_del_first, llist_del_all, llist_add ? I
> suspect that without mutex to ensure that there are no concurrent
> changes, llist_empty return value can easily be non-current.

We don't need llist_empty to be accurate.  Just a quick way to test
whether list/stack is empty without deleting something from list/stack.

Best Regards,
Huang Ying

> Thanks,
> 
> Mathieu
> 
>> + * @head:    the list to test
>> + */
>> +static inline int llist_empty(const struct llist_head *head)
>> +{
>> +     return head->first == NULL;
>> +}
>> +
>> +void llist_add(struct llist_node *new, struct llist_head *head);
>> +void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
>> +                  struct llist_head *head);
>> +struct llist_node *llist_del_first(struct llist_head *head);
>> +struct llist_node *llist_del_all(struct llist_head *head);
>> +#endif /* LLIST_H */
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -219,4 +219,7 @@ config LRU_CACHE
>>  config AVERAGE
>>       bool
>>
>> +config LLIST
>> +     bool
>> +
>>  endmenu
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -110,6 +110,8 @@ obj-$(CONFIG_ATOMIC64_SELFTEST) += atomi
>>
>>  obj-$(CONFIG_AVERAGE) += average.o
>>
>> +obj-$(CONFIG_LLIST) += llist.o
>> +
>>  hostprogs-y  := gen_crc32table
>>  clean-files  := crc32table.h
>>
>> --- /dev/null
>> +++ b/lib/llist.c
>> @@ -0,0 +1,119 @@
>> +/*
>> + * Lock-less NULL terminated single linked list
>> + *
>> + * The basic atomic operation of this list is cmpxchg on long.  On
>> + * architectures that don't have NMI-safe cmpxchg implementation, the
>> + * list can NOT be used in NMI handler.  So code uses the list in NMI
>> + * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
>> + *
>> + * Copyright 2010 Intel Corp.
>> + *   Author: Huang Ying <ying.huang@intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation;
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/llist.h>
>> +
>> +#include <asm/system.h>
>> +
>> +/**
>> + * llist_add - add a new entry
>> + * @new:     new entry to be added
>> + * @head:    the head for your lock-less list
>> + */
>> +void llist_add(struct llist_node *new, struct llist_head *head)
>> +{
>> +     struct llist_node *entry;
>> +
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>> +
>> +     do {
>> +             entry = head->first;
>> +             new->next = entry;
>> +     } while (cmpxchg(&head->first, entry, new) != entry);
>> +}
>> +EXPORT_SYMBOL_GPL(llist_add);
>> +
>> +/**
>> + * llist_add_batch - add several linked entries in batch
>> + * @new_first:       first entry in batch to be added
>> + * @new_last:        last entry in batch to be added
>> + * @head:    the head for your lock-less list
>> + */
>> +void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
>> +                  struct llist_head *head)
>> +{
>> +     struct llist_node *entry;
>> +
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>> +
>> +     do {
>> +             entry = head->first;
>> +             new_last->next = entry;
>> +     } while (cmpxchg(&head->first, entry, new_first) != entry);
>> +}
>> +EXPORT_SYMBOL_GPL(llist_add_batch);
>> +
>> +/**
>> + * llist_del_first - delete the first entry of lock-less list
>> + * @head:    the head for your lock-less list
>> + *
>> + * If list is empty, return NULL, otherwise, return the first entry deleted.
>> + *
>> + * Only one llist_del_first user can be used simultaneously with
>> + * multiple llist_add users without lock. Because otherwise
>> + * llist_del_first, llist_add, llist_add sequence in another user may
>> + * change @head->first->next, but keep @head->first. If multiple
>> + * consumers are needed, please use llist_del_all.
>> + */
>> +struct llist_node *llist_del_first(struct llist_head *head)
>> +{
>> +     struct llist_node *entry;
>> +
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>> +
>> +     do {
>> +             entry = head->first;
>> +             if (entry == NULL)
>> +                     return NULL;
>> +     } while (cmpxchg(&head->first, entry, entry->next) != entry);
>> +
>> +     return entry;
>> +}
>> +EXPORT_SYMBOL_GPL(llist_del_first);
>> +
>> +/**
>> + * llist_del_all - delete all entries from lock-less list
>> + * @head:    the head of lock-less list to delete all entries
>> + *
>> + * If list is empty, return NULL, otherwise, delete all entries and
>> + * return the pointer to the first entry.
>> + */
>> +struct llist_node *llist_del_all(struct llist_head *head)
>> +{
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>> +
>> +     return xchg(&head->first, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(llist_del_all);
