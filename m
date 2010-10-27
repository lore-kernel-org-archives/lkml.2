Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab0J0JRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:17:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760727Ab0J0JRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:17:42 -0400
Date: Wed, 27 Oct 2010 11:17:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH -v3 2/8] lib, Make gen_pool memory allocator lock-less
Message-ID: <20101027091741.GD2472@basil.fritz.box>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
 <1288157312-10441-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288157312-10441-3-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -1,8 +1,8 @@
>  /*
> - * Basic general purpose allocator for managing special purpose memory
> - * not managed by the regular kmalloc/kfree interface.
> - * Uses for this includes on-device special memory, uncached memory
> - * etc.
> + * Basic general purpose allocator for managing special purpose
> + * memory, for example, memory that is not managed by the regular
> + * kmalloc/kfree interface.  Uses for this includes on-device special
> + * memory, uncached memory etc.

I think we need some more description here about the locklessness:

How about adding to the comment:

This version of the allocator supports lockless operation.

This makes it safe to use in NMI handlers and other special unblockable
contexts that could otherwise deadlock on locks.  This is implemented by 
using atomic operations and retries on any conflicts. 
The disadvantage is that there may be livelocks in extreme cases.  

The lockless operation only works if there is enough memory
available. If new memory is added to the pool a lock has to 
be still taken. So any user relying on locklessness has to ensure
that sufficient memory is preallocated.

The basic atomic operation of this allocator is cmpxchg on long. 
On architectures that don't support cmpxchg natively a fallback
is used. If the fallback uses locks it may not be safe to use
it in NMI contexts on these architectures.

> +/**
> + * gen_pool_for_each_chunk - iterate over chunks of generic memory pool
> + * @chunk:	the struct gen_pool_chunk * to use as a loop cursor
> + * @pool:	the generic memory pool
> + */

I believe that's not safe in a lockless context right?
Should note that.

> +#define gen_pool_for_each_chunk(chunk, pool)			\
> +	list_for_each_entry(chunk, &pool->chunks, next_chunk)
> +

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
