Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1IGAzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:55:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:40401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1IGAzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:55:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45864818"
Message-ID: <4E66C0EA.6010302@intel.com>
Date: Wed, 07 Sep 2011 08:55:06 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -mm 4/4] irq_work, Use llist in irq_work
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com> <1315290307-25145-4-git-send-email-ying.huang@intel.com> <20110906105750.GD21602@Krystal>
In-Reply-To: <20110906105750.GD21602@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 06:57 PM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
>> Use llist in irq_work instead of the lock-less linked list
>> implementation in irq_work to avoid the code duplication.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>>  include/linux/irq_work.h |   15 ++++---
>>  kernel/irq_work.c        |   92 ++++++++++++++++-------------------------------
>>  2 files changed, 41 insertions(+), 66 deletions(-)
>>
> [...]
>> -static void __irq_work_queue(struct irq_work *entry)
>> +static void __irq_work_queue(struct irq_work *work)
>>  {
>> -	struct irq_work *next;
>> -
>>  	preempt_disable();
>>  
>> -	do {
>> -		next = __this_cpu_read(irq_work_list);
>> -		/* Can assign non-atomic because we keep the flags set. */
>> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
>> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
>> -
>> +	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>>  	/* The list was empty, raise self-interrupt to start processing. */
>> -	if (!irq_work_next(entry))
>> +	if (!work->llnode.next)
> 
> 
> Hrm. What happens if this function gets delayed between llist_add and
> "if (!work->llnode.next)" ? It seems like the threads performing
> llist_del_all would be within its right to free the memory pointed to by
> work in the meantime.

Yes.  This is an issue.  This can be fixed in several way

1) use another flag to indicate whether list is empty
2) make llist_add return whether list is empty before adding
3) request irq_work users to free the memory with call_rcu() or after
synchronize_rcu().

Personally I prefer 1), which will not expose llist implementation
details too.

Best Regards,
Huang Ying
