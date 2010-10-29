Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440Ab0J2M1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:27:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:26210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab0J2M1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,259,1286175600"; 
   d="scan'208";a="672207298"
Date: Fri, 29 Oct 2010 14:29:28 +0200
From: Andi Kleen <andi.kleen@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
Message-ID: <20101029122928.GA17792@gargoyle.fritz.box>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
 <op.vlbywq137p4s8u@pikus>
 <20101029103154.GA10823@gargoyle.fritz.box>
 <20101029195900.88559162.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029195900.88559162.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 11:59:00AM +0100, KAMEZAWA Hiroyuki wrote:
> On Fri, 29 Oct 2010 12:31:54 +0200
> Andi Kleen <andi.kleen@intel.com> wrote:
> 
> > > When I was posting CMA, it had been suggested to create a new migration type
> > > dedicated to contiguous allocations.  I think I already did that and thanks to
> > > this new migration type we have (i) an area of memory that only accepts movable
> > > and reclaimable pages and 
> > 
> > Aka highmem next generation :-(
> > 
> 
> yes. But Nick's new shrink_slab() may be a new help even without
> new zone.

You would really need callbacks into lots of code. Christoph
used to have some patches for directed shrink of dcache/icache,
but they are currently not on the table.

I don't think Nick's patch does that, he simply optimizes the existing
shrinker (which in practice tends to not shrink a lot) to be a bit
less wasteful.

The coverage will never be 100% in any case. So you always have to
make a choice between movable or fully usable. That's essentially
highmem with most of its problems.

> 
> 
> > > (ii) is used only if all other (non-reserved) pages have
> > > been allocated.
> > 
> > That will be near always the case after some uptime, as memory fills up
> > with caches. Unless you do early reclaim? 
> > 
> 
> memory migration always do work with alloc_page() for getting migration target
> pages. So, memory will be reclaimed if filled by cache.

Was talking about that paragraph CMA, not your patch. 

If I understand it correctly CMA wants to define
a new zone which is somehow similar to movable, but only sometimes used
when another zone is full (which is the usual state in normal
operation actually)

It was unclear to me how this was all supposed to work. At least
as described in the paragraph it cannot I think.


> About my patch, I may have to prealloc all required pages before start.
> But I didn't do that at this time.

preallocate when? I thought the whole point of the large memory allocator
was to not have to pre-allocate.

-Andi
