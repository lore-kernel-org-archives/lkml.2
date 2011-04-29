Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab1D2A4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:56:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:38477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382Ab1D2Azy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,283,1301900400"; 
   d="scan'208";a="427494080"
Message-ID: <4DBA0C97.8070908@intel.com>
Date: Fri, 29 Apr 2011 08:55:51 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v4 3/4] lib, Make gen_pool memory allocator lockless
References: <1303806878-333-1-git-send-email-ying.huang@intel.com> <1303806878-333-4-git-send-email-ying.huang@intel.com> <20110428143738.GA19161@Krystal>
In-Reply-To: <20110428143738.GA19161@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mathieu,

Thanks for your comments.

On 04/28/2011 10:37 PM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
[snip]
>>
>> +/**
>> + * gen_pool_for_each_chunk - iterate over chunks of generic memory pool
>> + * @chunk:   the struct gen_pool_chunk * to use as a loop cursor
>> + * @pool:    the generic memory pool
>> + *
>> + * Not lockless, proper mutual exclusion is needed to use this macro
>> + * with other gen_pool function simultaneously.
>> + */
>> +#define gen_pool_for_each_chunk(chunk, pool)                 \
>> +     list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk)
> 
> Is it just me or this macro is never used ? Maybe you should consider
> removing it.

This macro is not used in this patch.  But it is used in 4/4 of the
patchset to free the backing pages before destroy the pool.

[snip]
>> @@ -108,43 +226,50 @@ EXPORT_SYMBOL(gen_pool_destroy);
>>   * @size: number of bytes to allocate from the pool
>>   *
>>   * Allocate the requested number of bytes from the specified pool.
>> - * Uses a first-fit algorithm.
>> + * Uses a first-fit algorithm. Can not be used in NMI handler on
>> + * architectures without NMI-safe cmpxchg implementation.
>>   */
>>  unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
>>  {
>> -     struct list_head *_chunk;
>>       struct gen_pool_chunk *chunk;
>> -     unsigned long addr, flags;
>> +     unsigned long addr;
>>       int order = pool->min_alloc_order;
>> -     int nbits, start_bit, end_bit;
>> +     int nbits, start_bit = 0, end_bit, remain;
>> +
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>>
>>       if (size == 0)
>>               return 0;
>>
>>       nbits = (size + (1UL << order) - 1) >> order;
>> -
>> -     read_lock(&pool->lock);
>> -     list_for_each(_chunk, &pool->chunks) {
>> -             chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
>> +             if (size > atomic_read(&chunk->avail))
>> +                     continue;
>>
>>               end_bit = (chunk->end_addr - chunk->start_addr) >> order;
>> -
>> -             spin_lock_irqsave(&chunk->lock, flags);
>> -             start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
>> -                                             nbits, 0);
>> -             if (start_bit >= end_bit) {
>> -                     spin_unlock_irqrestore(&chunk->lock, flags);
>> +retry:
>> +             start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit,
>> +                                                    start_bit, nbits, 0);
>> +             if (start_bit >= end_bit)
>>                       continue;
>> +             remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
>> +             if (remain) {
>> +                     remain = bitmap_clear_ll(chunk->bits, start_bit,
>> +                                              nbits - remain);
>> +                     BUG_ON(remain);
>> +                     goto retry;
>>               }
>>
>>               addr = chunk->start_addr + ((unsigned long)start_bit << order);
>> -
>> -             bitmap_set(chunk->bits, start_bit, nbits);
>> -             spin_unlock_irqrestore(&chunk->lock, flags);
>> -             read_unlock(&pool->lock);
>> +             size = nbits << order;
>> +             atomic_sub(size, &chunk->avail);
>> +             rcu_read_unlock();
> 
> I don't really like seeing a rcu_read_unlock() within a rcu list
> iteration (even if it comes right before a "return"). Doing:
> 
> unsigned long addr = 0;
> 
> rcu_read_lock();
> list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
>   if (...)
>     continue;
>   ...
>   addr = ...;
>   break;
> }
> rcu_read_unlock();
> return addr;
> 
> Would be more symmetric, and would remove one return path, which makes
> the code easier to modify in the future.

Unlock in loop is common in Linux kernel.  Sometimes it makes code
cleaner (but not always).  Yes, for this case, we can avoid unlock in
loop easily.  But for the next case it is not so clean.

>>               return addr;
>>       }
>> -     read_unlock(&pool->lock);
>> +     rcu_read_unlock();
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(gen_pool_alloc);
>> @@ -155,33 +280,73 @@ EXPORT_SYMBOL(gen_pool_alloc);
>>   * @addr: starting address of memory to free back to pool
>>   * @size: size in bytes of memory to free
>>   *
>> - * Free previously allocated special memory back to the specified pool.
>> + * Free previously allocated special memory back to the specified
>> + * pool.  Can not be used in NMI handler on architectures without
>> + * NMI-safe cmpxchg implementation.
>>   */
>>  void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
>>  {
>> -     struct list_head *_chunk;
>>       struct gen_pool_chunk *chunk;
>> -     unsigned long flags;
>>       int order = pool->min_alloc_order;
>> -     int bit, nbits;
>> +     int start_bit, nbits, remain;
>>
>> -     nbits = (size + (1UL << order) - 1) >> order;
>> -
>> -     read_lock(&pool->lock);
>> -     list_for_each(_chunk, &pool->chunks) {
>> -             chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>>
>> +     nbits = (size + (1UL << order) - 1) >> order;
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
>>               if (addr >= chunk->start_addr && addr < chunk->end_addr) {
>>                       BUG_ON(addr + size > chunk->end_addr);
>> -                     spin_lock_irqsave(&chunk->lock, flags);
>> -                     bit = (addr - chunk->start_addr) >> order;
>> -                     while (nbits--)
>> -                             __clear_bit(bit++, chunk->bits);
>> -                     spin_unlock_irqrestore(&chunk->lock, flags);
>> -                     break;
>> +                     start_bit = (addr - chunk->start_addr) >> order;
>> +                     remain = bitmap_clear_ll(chunk->bits, start_bit, nbits);
>> +                     BUG_ON(remain);
>> +                     size = nbits << order;
>> +                     atomic_add(size, &chunk->avail);
>> +                     rcu_read_unlock();
> 
> Same comment as above apply here.

It is harder to remove unlock in loop here.  An extra variable should be
used to indicate that something is freed from the pool.  Do you think it
is cleaner to just keep the unlock in loop here?

Best Regards,
Huang Ying

> +                     return;
>               }
>       }
> -     BUG_ON(nbits > 0);
> -     read_unlock(&pool->lock);
> +     rcu_read_unlock();
> +     BUG();
>  }
[snip]
