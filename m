Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1KWG72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:59:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33953 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab1KWG71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:59:27 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfEte8U5pVBJ=LvRKMY5=oW7F2vRjw_d9893Yy8W88hfDg@mail.gmail.com>
References: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com>
	<alpine.DEB.2.00.1111221847320.30008@chino.kir.corp.google.com>
	<CABexPfEte8U5pVBJ=LvRKMY5=oW7F2vRjw_d9893Yy8W88hfDg@mail.gmail.com>
Date: Wed, 23 Nov 2011 14:59:26 +0800
Message-ID: <CABexPfHxM=NpwrrbFrTJUVZHzORpVaqAwoh1yC7d=RTfwnQWwg@mail.gmail.com>
Subject: Fwd: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) - 1 in
 function slab_order()?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: zhihua che <zhihua.che@gmail.com>
Date: 2011/11/23
Subject: Re: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) -
1 in function slab_order()?
To: David Rientjes <rientjes@google.com>


I know what you mean, that is, a slab can only store no more than
MAX_OBJS_PER_PAGE, actually 0x7FFF, objects.

But  get_order(size * MAX_OBJS_PER_PAGE) already returns the order
which reserves no_more_than size * MAX_OBJS_PER_PAGE memory.  Right?

So I think there is no need to subtract one.



2011/11/23 David Rientjes <rientjes@google.com>:
> On Wed, 23 Nov 2011, zhihua che wrote:
>
>> Hi, everyone,
>>         I'm reading the kernel codes about slub allocator and I come
>> across a confusion. Precisely, I'm reading the initialization of the
>> slub allocator, kmem_cache_init(), and I find it needs call
>> calculate_sizes() to determine the order of a kmem_cache, given the
>> size of the object. In turn, it calls the get_order() to get a
>> possible order. The problem is, in the start of this function, why it
>> looks like this:
>>
>>         if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
>>                 return get_order(size * MAX_OBJS_PER_PAGE) - 1;
>>
>>         I don't know why it subtracts one from the order returned by
>> get_order().
>>         because as far as I know, get_order() returns the order the
>> slab requires to reserve size * MAX_OBJS_PER_PAGE memory. If it
>> subtracts 1 from the order returned by get_order(), the slab can't
>> store MAX_OBJS_PER_PAGE objects at all, instead it can only store half
>> of the MAX_OBJS_PER_PAGE objects.
>>         Could you correct me if I think in a wrong way.
>
> I agree it looks confusing, but it's correct.  SLUB can only store
> MAX_OBJS_PER_PAGE because of limitations in struct page (see the comments
> in include/linux/mm_types.h).  So if the order will yield a page that
> could fit _more_ than MAX_OBJS_PER_PAGE, we need to reduce the order by a
> factor of 1.
>
