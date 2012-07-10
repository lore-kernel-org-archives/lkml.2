Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2GJKr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:47:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2GJKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:47:26 -0400
Date: Tue, 10 Jul 2012 11:47:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: JoonSoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order
 0
Message-ID: <20120710104722.GB14154@suse.de>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
 <alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
 <CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 11:33:14AM +0900, JoonSoo Kim wrote:
> 2012/7/7 David Rientjes <rientjes@google.com>:
> > On Sat, 7 Jul 2012, Joonsoo Kim wrote:
> >
> >> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
> >> And in almost invoking case, order is 0, so return immediately.
> >>
> >
> > If "zero cost" is "very costly", then this might make sense.
> >
> > __alloc_pages_direct_compact() is inlined by gcc.
> 
> In my kernel image, __alloc_pages_direct_compact() is not inlined by gcc.

Indeed it is due to their being two callsites. In most cases, the page
allocator takes care that functions have only one callsite so they get
inlined.

You say that invoking the function is very costly. I agree that a function
call with that many parameters is hefty but it is also in the slow path of
the allocator. For order-0 allocations we are about to enter direct reclaim
where I would expect the cost far exceeds the cost of a function call.

If the cost is indeed high and you have seen this in profiles then I
suggest you create a forced inline function alloc_pages_direct_compact
that does this;

if (order != 0)
	__alloc_pages_direct_compact(...)

and then call alloc_pages_direct_compact instead of
__alloc_pages_direct_compact. After that, recheck the profiles (although I
expect the difference to be marginal) and the size of vmlinux (if it gets
bigger, it's probably not worth it).

That would be functionally similar to your patch but it will preserve git
blame, churn less code and be harder to make mistakes with in the unlikely
event a third call to alloc_pages_direct_compact is ever added.

Thanks.

-- 
Mel Gorman
SUSE Labs
