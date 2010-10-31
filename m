Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0JaOah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 10:30:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:32827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0JaOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 10:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,268,1286175600"; 
   d="scan'208";a="568972932"
Subject: Re: [PATCH -v3 2/8] lib, Make gen_pool memory allocator lock-less
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20101027091741.GD2472@basil.fritz.box>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
	 <1288157312-10441-3-git-send-email-ying.huang@intel.com>
	 <20101027091741.GD2472@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 22:30:36 +0800
Message-ID: <1288535436.3536.14.camel@yhuang-mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

Sorry for late. In traveling recently.

On Wed, 2010-10-27 at 02:17 -0700, Andi Kleen wrote:
> > --- a/lib/genalloc.c
> > +++ b/lib/genalloc.c
> > @@ -1,8 +1,8 @@
> >  /*
> > - * Basic general purpose allocator for managing special purpose memory
> > - * not managed by the regular kmalloc/kfree interface.
> > - * Uses for this includes on-device special memory, uncached memory
> > - * etc.
> > + * Basic general purpose allocator for managing special purpose
> > + * memory, for example, memory that is not managed by the regular
> > + * kmalloc/kfree interface.  Uses for this includes on-device special
> > + * memory, uncached memory etc.
> 
> I think we need some more description here about the locklessness:
> 
> How about adding to the comment:
> 
> This version of the allocator supports lockless operation.
> 
> This makes it safe to use in NMI handlers and other special unblockable
> contexts that could otherwise deadlock on locks.  This is implemented by 
> using atomic operations and retries on any conflicts. 
> The disadvantage is that there may be livelocks in extreme cases.

Or add something like:

To get better scalability, one allocator can be used for each CPU.

> The lockless operation only works if there is enough memory
> available. If new memory is added to the pool a lock has to 
> be still taken. So any user relying on locklessness has to ensure
> that sufficient memory is preallocated.

In fact, because RCU is used between gen_pool_add and
gen_pool_alloc/gen_pool_free, the memory can be added to pool at any
time. This makes the memory allocator more flexible. Maybe we can add
gen_pool_remove in the future to shrink the preallocated memory at any
time.

> The basic atomic operation of this allocator is cmpxchg on long. 
> On architectures that don't support cmpxchg natively a fallback
> is used. If the fallback uses locks it may not be safe to use
> it in NMI contexts on these architectures.
> 
> > +/**
> > + * gen_pool_for_each_chunk - iterate over chunks of generic memory pool
> > + * @chunk:	the struct gen_pool_chunk * to use as a loop cursor
> > + * @pool:	the generic memory pool
> > + */
> 
> I believe that's not safe in a lockless context right?
> Should note that.

Yes. Will add that.

Best Regards,
Huang Ying


