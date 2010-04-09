Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0DIG3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0DIG3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:29:35 -0400
Message-ID: <4BBEC92B.9060407@redhat.com>
Date: Fri, 09 Apr 2010 14:28:59 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] slab: fix caller tracking on !CONFIG_DEBUG_SLAB && CONFIG_TRACING
References: <1270721493-27820-1-git-send-email-dfeng@redhat.com> <alpine.DEB.2.00.1004081209380.21040@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1004081209380.21040@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 03:12 AM, David Rientjes wrote:
> On Thu, 8 Apr 2010, Xiaotian Feng wrote:
>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 4884462..1a0625c 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -267,7 +267,7 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
>>    * allocator where we care about the real place the memory allocation
>>    * request comes from.
>>    */
>> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
>> +#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
>>   extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>>   #define kmalloc_track_caller(size, flags) \
>>   	__kmalloc_track_caller(size, flags, _RET_IP_)
>> @@ -285,7 +285,7 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>>    * standard allocator where we care about the real place the memory
>>    * allocation request comes from.
>>    */
>> -#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
>> +#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
>>   extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
>>   #define kmalloc_node_track_caller(size, flags, node) \
>>   	__kmalloc_node_track_caller(size, flags, node, \
>
> This doesn't work if the underlying slab allocator doesn't define
> __kmalloc_node_track_caller() regardless of whether CONFIG_TRACING is
> enabled or not.  SLOB, for example, never defines it, and that's why the
> conditional exists in the way it currently does.
>

Sorry, I didn't realized this, can we use (defined(CONFIG_TRACING) && 
defined(CONFIG_SLAB)) ?

> This is your patch with CONFIG_EMBEDDED&&  CONFIG_SLOB:
>
> mm/built-in.o: In function `__krealloc':
> (.text+0x1283c): undefined reference to `__kmalloc_track_caller'
> mm/built-in.o: In function `kmemdup':
> (.text+0x128b4): undefined reference to `__kmalloc_track_caller'
> mm/built-in.o: In function `kstrndup':
> (.text+0x128fc): undefined reference to `__kmalloc_track_caller'
> mm/built-in.o: In function `kstrdup':
> (.text+0x12943): undefined reference to `__kmalloc_track_caller'
> mm/built-in.o: In function `memdup_user':
> (.text+0x129f7): undefined reference to `__kmalloc_track_caller'
> drivers/built-in.o:(.text+0xc48a4): more undefined references to `__kmalloc_track_caller' follow
> net/built-in.o: In function `__alloc_skb':
> (.text+0x8dc6): undefined reference to `__kmalloc_node_track_caller'
>

