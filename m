Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0ESSB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:01:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab0ESSB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:01:26 -0400
Message-ID: <4BF427D4.40600@colorfullife.com>
Date: Wed, 19 May 2010 20:03:00 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: David Woodhouse <dwmw2@infradead.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org> <20100519133028.GA26659@sig21.net>
In-Reply-To: <20100519133028.GA26659@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 03:30 PM, Johannes Stezenbach wrote:
> Hi,
>
> I have some comments/questions, I hope it's not too silly:
>
> On Wed, May 19, 2010 at 12:01:42PM +0100, David Woodhouse wrote:
>    
>> +#ifndef ARCH_KMALLOC_MINALIGN
>> +/*
>> + * Enforce a minimum alignment for the kmalloc caches.
>> + * Usually, the kmalloc caches are cache_line_size() aligned, except when
>> + * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
>> + * Some archs want to perform DMA into kmalloc caches and need a guaranteed
>> + * alignment larger than the alignment of a 64-bit integer.
>> + * ARCH_KMALLOC_MINALIGN allows that.
>> + * Note that increasing this value may disable some debug features.
>> + */
>> +#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
>> +#endif
>>      
> I think the comment is confusing.  IIRC kmalloc() API guarantees that
> the allocated buffer is suitable for DMA, so if cache coherence is not
> handled by hardware the arch might need to set this to the cache line size,
> and that's what ARCH_KMALLOC_MINALIGN is about. Nothing else.
>    
Is this text better?

/*
* Enforce a minimum alignment for the kmalloc caches.
* kmalloc allocations are guaranteed to be BYTES_PER_WORD aligned - 
sizeof(void*)
* If an arch needs a larger guarantee (e.g. cache_line_size due to DMA), 
then it
* must use ARCH_KMALLOC_MINALIGN to enforce that.
* Note: Do not set ARCH_KMALLOC_MINALIGN for performance reasons.
* Unless debug options are enabled, the kernel uses cache_line_size() 
automatically.
*/

>> +#ifndef ARCH_SLAB_MINALIGN
>> +/*
>> + * Enforce a minimum alignment for all caches.
>> + * Intended for archs that get misalignment faults even for BYTES_PER_WORD
>> + * aligned buffers. Includes ARCH_KMALLOC_MINALIGN.
>> + * If possible: Do not enable this flag for CONFIG_DEBUG_SLAB, it disables
>> + * some debug features.
>> + */
>> +#define ARCH_SLAB_MINALIGN 0
>> +#endif
>>      
> Why is this needed at all?  If code calls kmem_cache_create()
> with wrong align parameter, or has wrong expectations wrt kmalloc()
> alignment guarantees, this code needs to be fixed?
> I mean, portable code cannot assume that unaligned accesses work?
>    
ARM uses 8 bytes. I don't know why.
A 32-bit arch and unaligned 64-bit loads are not supported?

--
     Manfred
