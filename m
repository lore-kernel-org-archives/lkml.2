Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab0KPVvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:51:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534Ab0KPVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:51:53 -0500
Date: Tue, 16 Nov 2010 13:50:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
Message-Id: <20101116135038.fcaa90ca.akpm@linux-foundation.org>
In-Reply-To: <1289868791-16658-2-git-send-email-ying.huang@intel.com>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com>
	<1289868791-16658-2-git-send-email-ying.huang@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 08:53:10 +0800
Huang Ying <ying.huang@intel.com> wrote:

> This version of the gen_pool memory allocator supports lockless
> operation.
> 
> This makes it safe to use in NMI handlers and other special
> unblockable contexts that could otherwise deadlock on locks.  This is
> implemented by using atomic operations and retries on any conflicts.
> The disadvantage is that there may be livelocks in extreme cases.  For
> better scalability, one gen_pool allocator can be used for each CPU.
> 
> The lockless operation only works if there is enough memory available.
> If new memory is added to the pool a lock has to be still taken.  So
> any user relying on locklessness has to ensure that sufficient memory
> is preallocated.
> 
> The basic atomic operation of this allocator is cmpxchg on long.  On
> architectures that don't support cmpxchg natively a fallback is used.
> If the fallback uses locks it may not be safe to use it in NMI
> contexts on these architectures.

The code assumes that cmpxchg is atomic wrt NMI.  That would be news to
me - at present an architecture can legitimately implement cmpxchg()
with, say, spin_lock_irqsave() on a hashed spinlock.  I don't know
whether any architectures _do_ do anything like that.  If so then
that's a problem.  If not, it's an additional requirement on future
architecture ports.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/bitmap.h   |    1 
>  include/linux/genalloc.h |   35 +++++--
>  lib/bitmap.c             |    2 
>  lib/genalloc.c           |  228 ++++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 215 insertions(+), 51 deletions(-)
> 
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -142,6 +142,7 @@ extern void bitmap_release_region(unsign
>  extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
>  extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
>  
> +#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
>  #define BITMAP_LAST_WORD_MASK(nbits)					\
>  (									\
>  	((nbits) % BITS_PER_LONG) ?					\
> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -1,19 +1,26 @@
> +#ifndef GENALLOC_H
> +#define GENALLOC_H
>  /*
> - * Basic general purpose allocator for managing special purpose memory
> - * not managed by the regular kmalloc/kfree interface.
> - * Uses for this includes on-device special memory, uncached memory
> - * etc.
> + * Basic general purpose allocator for managing special purpose
> + * memory, for example, memory not managed by the regular
> + * kmalloc/kfree interface.  Uses for this includes on-device special
> + * memory, uncached memory etc.
> + *
> + * The gen_pool_alloc, gen_pool_free, gen_pool_avail and gen_pool_size
> + * implementation is lockless, that is, multiple users can
> + * allocate/free memory in the pool simultaneously without lock.  This
> + * also makes the gen_pool memory allocator can be used to

That sentence needs a fixup.

>  
> +static inline int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
> +{
> +	unsigned long val, nval;
> +
> +	nval = *addr;
> +	do {
> +		val = nval;
> +		if (val & mask_to_set)
> +			return -EBUSY;
> +	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
> +
> +	return 0;
> +}
> +
> +static inline int clear_bits_ll(unsigned long *addr,
> +				unsigned long mask_to_clear)
> +{
> +	unsigned long val, nval;
> +
> +	nval = *addr;
> +	do {
> +		val = nval;
> +		if ((val & mask_to_clear) != mask_to_clear)
> +			return -EBUSY;
> +	} while ((nval = cmpxchg(addr, val, val & ~mask_to_clear)) != val);
> +
> +	return 0;
> +}

These are waaaay too big to be inlined.  Let the compiler decide.

