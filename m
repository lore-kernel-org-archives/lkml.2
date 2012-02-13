Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2BMKMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:12:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2BMKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:12:44 -0500
Date: Mon, 13 Feb 2012 10:12:39 +0000
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20120213101239.GU5938@suse.de>
References: <alpine.DEB.2.00.1202080907320.30248@router.home>
 <20120208163421.GL5938@suse.de>
 <alpine.DEB.2.00.1202081338210.32060@router.home>
 <20120208212323.GM5938@suse.de>
 <alpine.DEB.2.00.1202081557540.5970@router.home>
 <20120209125018.GN5938@suse.de>
 <alpine.DEB.2.00.1202091345540.4413@router.home>
 <20120210102605.GO5938@suse.de>
 <alpine.DEB.2.00.1202101443570.31424@router.home>
 <alpine.DEB.2.00.1202101606530.3840@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202101606530.3840@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 04:07:57PM -0600, Christoph Lameter wrote:
> Proposal for a patch for slub to move the pfmemalloc handling out of the
> fastpath by simply not assigning a per cpu slab when pfmemalloc processing
> is going on.
> 
> 
> 
> Subject: [slub] Fix so that no mods are required for the fast path
> 
> Remove the check for pfmemalloc from the alloc hotpath and put the logic after
> the election of a new per cpu slab.
> 
> For a pfmemalloc page do not use the fast path but force use of the slow
> path (which is also used for the debug case).
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

This weakens pfmemalloc processing in the following way

1. Process that is performance network swap calls __slab_alloc.
   pfmemalloc_match is true so the freelist is loaded and
   c->freelist is now pointing to a pfmemalloc page
2. Process that is attempting normal allocations calls slab_alloc,
   finds the pfmemalloc page on the freelist and uses it because it
   did not check pfmemalloc_match()

The patch allows non-pfmemalloc allocations to use pfmemalloc pages with
the kmalloc slabs being the most vunerable caches on the grounds they are
most likely to have a mix of pfmemalloc and !pfmemalloc requests. Patch
14 will still protect the system as processes will get throttled if the
pfmemalloc reserves get depleted so performance will not degrade as smoothly.

Assuming this passes testing, I'll add the patch to the series with the
information above included in the changelog.

Thanks Christoph.

-- 
Mel Gorman
SUSE Labs
