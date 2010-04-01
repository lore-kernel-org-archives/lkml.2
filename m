Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0DAHJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:09:04 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:56142 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0DAHI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <4BB43D58.5030801@cs.helsinki.fi>
References: <l2g4810ea571003312024jb883f2eet5b48a7fbb9ec340f@mail.gmail.com>
	 <4BB43D58.5030801@cs.helsinki.fi>
Date: Thu, 1 Apr 2010 15:08:50 +0800
Message-ID: <i2h5f4a33681004010008rdda5bf16g7a9beb9d115da4fb@mail.gmail.com>
Subject: Re: [PATCH] Fix missing of last user info while getting DEBUG_SLAB 
	config enabled
From: TAO HU <tghk48@motorola.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: ShiYong LI <shi-yong.li@motorola.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pekka

Thanks for your feedback.

The subject and comments are kind of misleading. Sorry about that.
It intends to make  both Red-Zone and LastUser are available even the
alignment is larger than sizeof(long long).
The idea is to reserve certain room ("align") to let the obj's offset
is aligned to cache-line-size to address requirement of kmalloc().

Regarding align is less than sizeof(unsigned long long), I thin it is
handled in previous code.
Or you still expect to explicitly let align is no less than
sizeof(unsigned long long)?
if (flags & SLAB_RED_ZONE) {
                ralign = REDZONE_ALIGN;
             ... ...
        }


-- 
Best Regards
Hu Tao

On Thu, Apr 1, 2010 at 2:29 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> ShiYong LI kirjoitti:
>>
>> Hi all,
>>  For OMAP3430 chip, while getting DEBUG_SLAB config enabled, found a bug
>> that last user information is missed in slab corruption log dumped by
>> kernel. Actually, It's caused by ignorance of redzone and last user tag
>> while calling kmem_cache_create() function if cache alignment > 16 bytes
>> (unsigned long long).  Here is a patch to fix this problem. Already verified
>> it on kernel 2.6.29.
>
> The patch is badly whitespace damaged.
>
>>  From 26a5a8ad2a1d7612929a91f6866cea9d1bea6077 Mon Sep 17 00:00:00 2001
>> From: Shiyong Li <shi-yong.li@motorola.com
>> <mailto:shi-yong.li@motorola.com>>
>> Date: Wed, 31 Mar 2010 10:09:35 +0800
>> Subject: [PATCH] Fix missing of last user info while getting DEBUG_SLAB
>> config enabled.
>> As OMAP3 cache line is 64 byte long, while calling kmem_cache_create()
>> funtion, some cases need 64 byte alignment of requested memory space.
>> But, if cache line > 16 bytes, current kernel ignore redzone
>> and last user debug head/trail tag to make sure this alignment is not
>> broken.
>> This fix removes codes that ignorance of redzone and last user tag.
>> Instead, use "align" argument value as object offset to guarantee the
>> alignment.
>> Signed-off-by: Shiyong Li <shi-yong.li@motorola.com
>> <mailto:shi-yong.li@motorola.com>>
>> ---
>>  mm/slab.c |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>> diff --git a/mm/slab.c b/mm/slab.c
>> index a8a38ca..84af997 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2267,9 +2267,6 @@ kmem_cache_create (const char *name, size_t size,
>> size_t align,
>>  if (ralign < align) {
>>   ralign = align;
>>  }
>> - /* disable debug if necessary */
>> - if (ralign > __alignof__(unsigned long long))
>> -  flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>>  /*
>>   * 4) Store it.
>>   */
>> @@ -2289,8 +2286,8 @@ kmem_cache_create (const char *name, size_t size,
>> size_t align,
>>   */
>>  if (flags & SLAB_RED_ZONE) {
>>   /* add space for red zone words */
>> -  cachep->obj_offset += sizeof(unsigned long long);
>> -  size += 2 * sizeof(unsigned long long);
>> +  cachep->obj_offset += align;
>> +  size += align + sizeof(unsigned long long);
>>  }
>
> I don't understand what you're trying to do here. What if align is less han
> sizeof(unsigned long long)? What if SLAB_RED_ZONE is not enabled but
>  SLAB_STORE_USER is?
>
>                        Pekka
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
