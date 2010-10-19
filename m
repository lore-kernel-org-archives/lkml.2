Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0JSB1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:27:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40585 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0JSB1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k3R0felhCswlOvwbruhobNR6IhuxG129RyGSy5aBD6/GIL9//wsoSJBjKrsgYMNr4h
         IJTupVzBLM5AgNse45LZ9R/f4VV578onJsFWpWIyJetWscqOPlr1j+p8e+3q74w026OG
         JEMBhPF1oDdcCqpBYVWUay8LyZgUmgsYIetBg=
MIME-Version: 1.0
In-Reply-To: <20101018164647.bc928c78.akpm@linux-foundation.org>
References: <20101016043331.GA3177@darkstar>
	<20101018164647.bc928c78.akpm@linux-foundation.org>
Date: Tue, 19 Oct 2010 09:27:47 +0800
Message-ID: <AANLkTikVueTjihngtC2rsoeqkUb5Wg-zeEFH1HKgcuuo@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 7:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 16 Oct 2010 12:33:31 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Add vzalloc for convinience of vmalloc-then-memset-zero case
>>
>> Use __GFP_ZERO in vzalloc to zero fill the allocated memory.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>>  include/linux/vmalloc.h |    1 +
>>  mm/vmalloc.c            |   13 +++++++++++++
>>  2 files changed, 14 insertions(+)
>>
>> --- linux-2.6.orig/include/linux/vmalloc.h    2010-08-22 15:31:38.000000000 +0800
>> +++ linux-2.6/include/linux/vmalloc.h 2010-10-16 10:50:54.739996121 +0800
>> @@ -53,6 +53,7 @@ static inline void vmalloc_init(void)
>>  #endif
>>
>>  extern void *vmalloc(unsigned long size);
>> +extern void *vzalloc(unsigned long size);
>>  extern void *vmalloc_user(unsigned long size);
>>  extern void *vmalloc_node(unsigned long size, int node);
>>  extern void *vmalloc_exec(unsigned long size);
>> --- linux-2.6.orig/mm/vmalloc.c       2010-08-22 15:31:39.000000000 +0800
>> +++ linux-2.6/mm/vmalloc.c    2010-10-16 10:51:57.126665918 +0800
>> @@ -1604,6 +1604,19 @@ void *vmalloc(unsigned long size)
>>  EXPORT_SYMBOL(vmalloc);
>>
>>  /**
>> + *   vzalloc  -  allocate virtually contiguous memory with zero filled
>
> s/filled/fill/

Thanks, Will fix

>
>> + *   @size:          allocation size
>> + *   Allocate enough pages to cover @size from the page level
>> + *   allocator and map them into contiguous kernel virtual space.
>> + */
>> +void *vzalloc(unsigned long size)
>> +{
>> +     return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
>> +                             PAGE_KERNEL, -1, __builtin_return_address(0));
>> +}
>> +EXPORT_SYMBOL(vzalloc);
>
> We'd need to add the same interface to nommu, please.

Ok, will do

Minchan kim, thanks as well. I missed your comments about nommu before.

>
> Also, a slightly better implementation would be
>
> static inline void *__vmalloc_node_flags(unsigned long size, gfp_t flags)
> {
>        return __vmalloc_node(size, 1, flags, PAGE_KERNEL, -1,
>                                __builtin_return_address(0));
> }
>
> void *vzalloc(unsigned long size)
> {
>        return __vmalloc_node_flags(size,
>                                GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
> }
>
> void *vmalloc(unsigned long size)
> {
>        return __vmalloc_node_flags(size, GFP_KERNEL | __GFP_HIGHMEM);
> }
>
> just to avoid code duplication (and possible later errors derived from it).
>
> Perhaps it should be always_inline, so the __builtin_return_address()
> can't get broken.
>
> Or just leave it the way you had it :)

Andrew, your suggestion is cleaner and better. I will do as yours.

-- 
Regards
dave
