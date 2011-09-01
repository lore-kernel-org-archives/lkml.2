Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1IAIop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:44:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:29275 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab1IAIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,312,1312182000"; 
   d="scan'208";a="47463618"
Message-ID: <4E5F45F6.70009@intel.com>
Date: Thu, 01 Sep 2011 16:44:38 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>		 <1314681384-20881-2-git-send-email-ying.huang@intel.com>	 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com> <1314863829.7945.9.camel@twins>
In-Reply-To: <1314863829.7945.9.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 03:57 PM, Peter Zijlstra wrote:
> On Thu, 2011-09-01 at 09:46 +0800, Huang Ying wrote:
> 
>> You mean we should not use cpu_relax before the first cmpxchg? 
> 
> Yeah, that's just wasting time for no reason..
> 
>>  You suggest something as follow?
>>
>> void llist_add(struct llist_node *new, struct llist_head *head)
>> {
>>         struct llist_node *entry, *old_entry;
>>
>> #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>>         BUG_ON(in_nmi());
>> #endif
>>
>>         entry = head->first;
>>         for (;;) {
>>                 old_entry = entry;
>>                 new->next = entry;
>>                 entry = cmpxchg(&head->first, old_entry, new);
>>                 if (entry == old_entry)
>>                         break;
>>                 cpu_relax();
>>         }
>> }
> 
> If you insist on having cpu_relax(), then yes that's lots better. Also
> avoids the assignment in your conditional. Thing with cpu_relax() is
> that its only beneficial in the highly contended case and degrade
> light/un-contended loads.

Because llist is in library, it may be used in highly contended case and
light/un-contended loads.  So maybe code as above is best choice for llist.

> Also, just noticed, why do you have different list_head/list_node
> structures? They're the same, a single pointer.

There is only one structure before (llist_head).  Linus give me some
comments about that, suggests to use 2 structures.  I think his comments
are reasonable.  Copied here:

"
Btw, looking at the lockless list, I really think it's a mistake to
use "struct llist_head" for both the head and for the list linkage.

They are _very_ different. In the <linux/list.h> kind of model, the
list_head really *is* the same regardless of where in the list you
are, and you can have headless lists (ie a list that doesn't really
have an anchor, the list is just comprised of the elements
themselves).

But that's not true of the lockless list. There, the head is very much
magical, and as I mentioned, you can NOT do a "traverse starting at
head" thing. You can only do add/del/clear on the head, and then to
traverse you have to have a list *without* the head entry, because it
has been removed.

So from a pure type safety angle, I think the lockless list should
have clearly separate types for the head and for the actual list
entries, because they behave totally differently. When the normal
"list_add()" things can be used to add things in the middle - so each
list entry really can act as a head - that isn't true at all for the
lockless version.
"

>>> and loose the get/put
>>> cpu muck? The existing preempt_disable/enable() are already superfluous
>>> and could be removed, you just made all this way more horrid than need
>>> be.
>>
>> Will it cause race condition to remove preempt_disable/enable?
>> Considering something as follow:
>>
>> - get irq_work_list of CPU A
>> - queue irq_work into irq_work_list of CPU A
>> - preempted and resumed execution on CPU B
>> - arch_irq_work_raise on CPU B
>>
>> irq_work_run on CPU B will do nothing.  While irq_work need to wait for
>> next timer interrupt.  Isn't it an issue?
> 
> Yes that's unfortunate, the current version would work just fine without
> preempt but that's because of the this_cpu_* ops foo. 
> 
> Not sure it would make sense to add a special this_cpu_llist_add() or
> so.. esp seeing that this_cpu_* is basically x86-only.

Even with this_cpu_* ops, it seems that the race condition I described
is still possible.

- use this_cpu_cmpxchg to queue irq_work into irq_work_list of CPU A
- preempted and resumed execution on CPU B
- arch_irq_work_raise on CPU B

Do you think so?

Best Regards,
Huang Ying
