Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2EOB5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:57:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51365 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2EOB5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <4FB06B91.1080008@kernel.org>
References: <4FAB21E7.7020703@kernel.org>
	<20120510140215.GC26152@phenom.dumpdata.com>
	<4FABD503.4030808@vflare.org>
	<4FABDA9F.1000105@linux.vnet.ibm.com>
	<20120510151941.GA18302@kroah.com>
	<4FABECF5.8040602@vflare.org>
	<20120510164418.GC13964@kroah.com>
	<4FABF9D4.8080303@vflare.org>
	<20120510173322.GA30481@phenom.dumpdata.com>
	<4FAC4E3B.3030909@kernel.org>
	<20120511192831.GC3785@phenom.dumpdata.com>
	<4FB06B91.1080008@kernel.org>
Date: Mon, 14 May 2012 21:57:19 -0400
Message-ID: <CAPkvG_dTA7HwzVBo70bZuqkX+ZfjJpS+p4L9L+jF4Uz1ooEx0Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
From: Nitin Gupta <ngupta@vflare.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:18 PM, Minchan Kim <minchan@kernel.org> wrote:
> On 05/12/2012 04:28 AM, Konrad Rzeszutek Wilk wrote:
>
>>> Please look.
>>>
>>> struct zs_handle {
>>>      void *handle
>>> };
>>>
>>> 1)
>>>
>>> static struct zv_hdr *zv_create(..)
>>> {
>>>      struct zs_handle handle;
>>>      ..
>>>      handle = zs_malloc(pool, size);
>>>      ..
>>>      return handle;
>>
>> Compiler will complain that you are returning incorrect type.
>
>
> My bad. &handle.
>
>>
>>> }
>>>
>>> handle is on stack so it can't be used by index for slot of radix tree.
>>
>> The fix is of course to return a pointer (which your function
>> declared), and instead do this:
>>
>> {
>>       struct zs_handle *handle;
>>
>>       handle = zs_malloc(pool, size);
>
>
> It's not a good idea.
> For it, zs_malloc needs memory space to keep zs_handle internally.
> Why should zsallocator do it? Just for zcache?
> It's not good abstraction.
>
>
>>       return handle;
>> }
>>
>>>
>>> 2)
>>>
>>> static struct zv_hdr *zv_create(..)
>>> {
>>>      struct zs_handle handle;
>>>      ..
>>>      handle = zs_malloc(pool, size);
>>>      ..
>>>      return handle.handle;
>>> }
>>>
>>> Okay. Now it works but zcache coupled with zsmalloc tightly.
>>> User of zsmalloc should never know internal of zs_handle.
>>
>> OK. Then it can just forward declare it:
>>
>> struct zs_handle;
>>
>> and zsmalloc will treat it as an opaque pointer.
>>
>>>
>>> 3)
>>>
>>> - zsmalloc.h
>>> void *zs_handle_to_ptr(struct zs_handle handle)
>>> {
>>>      return handle.hanle;
>>> }
>>>
>>> static struct zv_hdr *zv_create(..)
>>> {
>>>      struct zs_handle handle;
>>>      ..
>>>      handle = zs_malloc(pool, size);
>>>      ..
>>>      return zs_handle_to_ptr(handle);
>>
>>> }
>>
>>>
>>> Why should zsmalloc support such interface?
>>
>> Why not? It is better than a 'void *' or a typedef.
>>
>> It is modeled after a pte_t.
>
>
> It's not same with pte_t.
> We normally don't use pte_val to (void*) for unique index of slot.
> The problem is that zcache assume handle of zsmalloc is a sizeof(void*)'s
> unique value but zcache never assume it's a sizeof(void*).
>
>>
>>
>>> It's a zcache problem so it's desriable to solve it in zcache internal.
>>
>> Not really. We shouldn't really pass any 'void *' pointers around.
>>
>>> And in future, if we can add/remove zs_handle's fields, we can't make
>>> sure such API.
>>
>> Meaning ... what exactly do you mean? That the size of the structure
>> will change and we won't return the right value? Why not?
>> If you use the 'zs_handle_to_ptr' won't that work? Especially if you
>> add new values to the end of the struct it won't cause issues.
>
>
> I mean we might change zs_handle to following as, in future.
> (It's insane but who know it?)
>
> struct zs_handle {
>        int upper;
>        int middle;
>        int lower;
> };
>
> How could you handle this for zs_handle_to_ptr?
>
>>
>>>
>>>
>>>>> Its true that making it a real struct would prevent accidental casts
>>>>> to void * but due to the above problem, I think we have to stick
>>>>> with unsigned long.
>>
>> So the problem you are seeing is that you don't want 'struct zs_handle'
>> be present in the drivers/staging/zsmalloc/zsmalloc.h header file?
>> It looks like the proper place.
>
>
> No. What I want is to remove coupling zsallocator's handle with zram/zcache.
> They shouldn't know internal of handle and assume it's a pointer.
>
> If Nitin confirm zs_handle's format can never change in future, I prefer "unsigned long" Nitin suggested than (void *).
> It can prevent confusion that normal allocator's return value is pointer for address so the problem is easy.
> But I am not sure he can make sure it.
>

zs_handle will always be an unsigned long so its better to just use
the same as return type.

Another alternative is to return 'struct zs_handle *' which can be
used as a 'void *' by zcache and as unsigned long by zsmalloc.
However, I see no good reason for preferring this over simple unsigned
long as the return type.

Thanks,
Nitin
