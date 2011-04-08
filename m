Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1DHBdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 21:33:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:11985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab1DHBdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 21:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,321,1299484800"; 
   d="scan'208";a="676614525"
Message-ID: <4D9E65FC.8010507@intel.com>
Date: Fri, 08 Apr 2011 09:33:48 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2 3/4] lib, Make gen_pool memory allocator lockless
References: <1302139746-1030-1-git-send-email-ying.huang@intel.com> <1302139746-1030-4-git-send-email-ying.huang@intel.com> <20110407184946.GC6104@Krystal>
In-Reply-To: <20110407184946.GC6104@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 02:49 AM, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
>>
>> +static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
>> +{
>> +     unsigned long val, nval;
>> +
>> +     nval = *addr;
>> +     do {
>> +             val = nval;
>> +             if (val & mask_to_set)
>> +                     return -EBUSY;
>> +             cpu_relax();
>> +     } while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
> 
> Some architectures have their own atomic set bit already (e.g. intel),
> you should probably extend the existing set "bit" to a set "bits"
> instead, and use that instead for those, and put the generic
> implementation in asm-generic.

You mean implement set_bits_ll based on atomic set_bit or test_and_set?
 I don't know how to do that in a more efficient way.

This code is not put into generic bitmap implementation (lib/bitmap.c)
because Linus think we have no enough users yet.

[snip]
>> +/*
>> + * bitmap_set_ll - set the specified number of bits at the specified position
>> + * @map: pointer to a bitmap
>> + * @start: a bit position in @map
>> + * @nr: number of bits to set
>> + *
>> + * Set @nr bits start from @start in @map lock-lessly. Several users
>> + * can set/clear the same bitmap simultaneously without lock. If two
>> + * users set the same bit, one user will return remain bits, otherwise
>> + * return 0.
>> + */
>> +static int bitmap_set_ll(unsigned long *map, int start, int nr)
>> +{
>> +     unsigned long *p = map + BIT_WORD(start);
>> +     const int size = start + nr;
>> +     int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
>> +     unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
> 
> Ah :) I've had some fun working on bitfield management headers. First
> question: how did you test this code ? Shift of "32" being turned to a
> no-op on Intel is an example of how some odd cases can creep into this
> kind of code. If you are interested, you might want to have a look at my
> portable bitfield read/write MIT-licensed header in the Babeltrace
> library, file include/babeltrace/bitfield.h
> (http://git.efficios.com/?p=babeltrace.git).  It's not using atomic
> read/writes, but supports bitfield read/write event across different
> endiannesses. I made a testing program for it by providing limit values
> and random value, and checking that what is read/written matches. That
> helped me find interesting corner-cases.

I have some self-made testing program to test this.  And this code is
just copy/change of bitmap_set in lib/bitmap.c, same for bitmap_clear_ll
too.

If bitmap implementation is so tricky, I think it may be a good idea to
add your testing code into kernel for lib/bitmap.c.

[snip]
>> @@ -58,15 +184,15 @@ int gen_pool_add(struct gen_pool *pool,
>>
>>       chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
>>       if (unlikely(chunk == NULL))
>> -             return -1;
>> +             return -ENOMEM;
>>
>> -     spin_lock_init(&chunk->lock);
>>       chunk->start_addr = addr;
>>       chunk->end_addr = addr + size;
>> +     atomic_set(&chunk->avail, size);
>>
>> -     write_lock(&pool->lock);
>> -     list_add(&chunk->next_chunk, &pool->chunks);
>> -     write_unlock(&pool->lock);
>> +     spin_lock(&pool->lock);
>> +     list_add_rcu(&chunk->next_chunk, &pool->chunks);
> 
> hrm, where is the list_del_rcu ? Is there anywhere where we have some
> call_rcu scheme or synchronize_rcu to handle chunk teardown ?

That should be in gen_pool_remove.  But that have not been implemented
yet.  I have plan to do it, after the basic support is in place.

[snip]
>> @@ -108,43 +233,47 @@ EXPORT_SYMBOL(gen_pool_destroy);
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
> 
> missing rcu_read_lock() ?

rcu_read_lock() is not used here because we have not implement a
gen_pool_remove now.  So new chunk will be added into pool but no chunk
will be removed from pool.  After adding gen_pool_remove, we will add
rcu_read_lock() here.

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
> 
> maybe add cpu_relax() ? This is a busy loop after all.

There is cpu_relax() in bitmap_set_ll and bitmap_clear_ll already.  And
this loop is longer, do we need cpu_relax in long loop?

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
>>               return addr;
>>       }
>> -     read_unlock(&pool->lock);
>>       return 0;
>>  }
>>  EXPORT_SYMBOL(gen_pool_alloc);
>> @@ -155,33 +284,66 @@ EXPORT_SYMBOL(gen_pool_alloc);
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
>> -
>> -     nbits = (size + (1UL << order) - 1) >> order;
>> +     int start_bit, nbits, remain;
>>
>> -     read_lock(&pool->lock);
>> -     list_for_each(_chunk, &pool->chunks) {
>> -             chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>> +#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>> +     BUG_ON(in_nmi());
>> +#endif
>>
>> +     nbits = (size + (1UL << order) - 1) >> order;
> 
> missing rcu_read_lock ?

Same as above.

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
>> +                     return;
>>               }
>>       }
>> -     BUG_ON(nbits > 0);
>> -     read_unlock(&pool->lock);
>> +     BUG();
>>  }
>>  EXPORT_SYMBOL(gen_pool_free);
>> +
>> +/**
>> + * gen_pool_avail - get available free space of the pool
>> + * @pool: pool to get available free space
>> + *
>> + * Return available free space of the specified pool.
>> + */
>> +size_t gen_pool_avail(struct gen_pool *pool)
>> +{
>> +     struct gen_pool_chunk *chunk;
>> +     size_t avail = 0;
>> +
> 
> rcu_read_lock ?

Same as above.

>> +     list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
>> +             avail += atomic_read(&chunk->avail);
>> +     return avail;
>> +}
>> +EXPORT_SYMBOL_GPL(gen_pool_avail);
>> +
>> +/**
>> + * gen_pool_size - get size in bytes of memory managed by the pool
>> + * @pool: pool to get size
>> + *
>> + * Return size in bytes of memory managed by the pool.
>> + */
>> +size_t gen_pool_size(struct gen_pool *pool)
>> +{
>> +     struct gen_pool_chunk *chunk;
>> +     size_t size = 0;
>> +
> 
> rcu_read_lock ?

Same as above.

>> +     list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
>> +             size += chunk->end_addr - chunk->start_addr;
>> +     return size;
>> +}
>> +EXPORT_SYMBOL_GPL(gen_pool_size);

Best Regards,
Huang Ying
