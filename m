Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0JLToE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:44:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0JLToC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kPrTkZyfU/3C828oGZQkMX2+orkvReybwXd+CC77pnybTVjjPRE2HBfLroeJ32RT+a
         rV9WwyyPPWXySo1bDR3g==
Date: Tue, 12 Oct 2010 12:43:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <alpine.DEB.2.00.1010120745360.31832@router.home>
Message-ID: <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Christoph Lameter wrote:

> Hmmm. Given these effects I think we should be more cautious regarding the
> unification work. May be the "unified allocator" should replace SLAB
> instead and SLUB can stay unchanged?

Linus has said that he refuses to merge another allocator until one is 
removed or replaced, so that would force the unificiation patches to go 
into slab instead if you want to leave slub untouched.

> The unification patches go back to
> the one lock per node SLAB thing because the queue maintenance overhead is
> otherwise causing large regressions in hackbench because of lots of atomic
> ops. The per node lock seem to be causing problems here in the network
> stack,.

The TCP_RR regression on slub is because of what I described a couple 
years ago as "slab thrashing" where cpu slabs would be filled with 
allocations, then frees would occur to move those slabs from the full to 
partial list with only a few free objects, those partial slabs would 
quickly become full, etc.  Performance gets better if you change the 
per-node lock to a trylock when iterating the partial list and preallocate 
and have a substantially longer partial list than normal (and it still 
didn't rival slab's performance), so I don't think it's only a per-node 
lock that's the issue , it's all the slowpath overhead of swapping the cpu 
slab out for another slab.  The TCP_RR load would show slub stats that 
indicate certain caches, kmalloc-256 and kmalloc-2048, would have ~98% of 
allocations coming from the slowpath.

This gets better if you allocate higher order slabs (and kmalloc-2048 is 
already order-3 by default) but then allocating new slabs gets really slow 
if not impossible on smaller machines.  The overhead of even compaction 
will kill us.

> Take the unified as a SLAB cleanup instead? Then at least we have
> a large common code base and just differentiate through the locking
> mechanism?
> 

Will you be adding the extensive slub debugging to slab then?  It would be 
a shame to lose it because one allocator is chosen over another for 
performance reasons and then we need to recompile to debug issues as they 
arise.
