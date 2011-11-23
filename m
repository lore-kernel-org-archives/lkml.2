Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab1KWCx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:53:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64709 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab1KWCxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:53:25 -0500
Date: Tue, 22 Nov 2011 18:53:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: zhihua che <zhihua.che@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org
Subject: Re: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) - 1 in
 function slab_order()?
In-Reply-To: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111221847320.30008@chino.kir.corp.google.com>
References: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, zhihua che wrote:

> Hi, everyone,
>         I'm reading the kernel codes about slub allocator and I come
> across a confusion. Precisely, I'm reading the initialization of the
> slub allocator, kmem_cache_init(), and I find it needs call
> calculate_sizes() to determine the order of a kmem_cache, given the
> size of the object. In turn, it calls the get_order() to get a
> possible order. The problem is, in the start of this function, why it
> looks like this:
> 
>         if (order_objects(min_order, size, reserved) > MAX_OBJS_PER_PAGE)
>                 return get_order(size * MAX_OBJS_PER_PAGE) - 1;
> 
>         I don't know why it subtracts one from the order returned by
> get_order().
>         because as far as I know, get_order() returns the order the
> slab requires to reserve size * MAX_OBJS_PER_PAGE memory. If it
> subtracts 1 from the order returned by get_order(), the slab can't
> store MAX_OBJS_PER_PAGE objects at all, instead it can only store half
> of the MAX_OBJS_PER_PAGE objects.
>         Could you correct me if I think in a wrong way.

I agree it looks confusing, but it's correct.  SLUB can only store 
MAX_OBJS_PER_PAGE because of limitations in struct page (see the comments 
in include/linux/mm_types.h).  So if the order will yield a page that 
could fit _more_ than MAX_OBJS_PER_PAGE, we need to reduce the order by a 
factor of 1.
