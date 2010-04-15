Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab0DOChf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:37:35 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:45587 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0DOChe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:37:34 -0400
Date: Thu, 15 Apr 2010 04:37:04 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100415023704.GC20640@cmpxchg.org>
References: <20100413202021.GZ13327@think> <20100414014041.GD2493@dastard> <20100414155233.D153.A69D9226@jp.fujitsu.com> <20100414072830.GK2493@dastard> <20100414085132.GJ25756@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414085132.GJ25756@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 09:51:33AM +0100, Mel Gorman wrote:
> They will need to be tackled in turn then but obviously there should be
> a focus on the common paths. The reclaim paths do seem particularly
> heavy and it's down to a lot of temporary variables. I might not get the
> time today but what I'm going to try do some time this week is
> 
> o Look at what temporary variables are copies of other pieces of information
> o See what variables live for the duration of reclaim but are not needed
>   for all of it (i.e. uninline parts of it so variables do not persist)
> o See if it's possible to dynamically allocate scan_control
> 
> The last one is the trickiest. Basically, the idea would be to move as much
> into scan_control as possible. Then, instead of allocating it on the stack,
> allocate a fixed number of them at boot-time (NR_CPU probably) protected by
> a semaphore. Limit the number of direct reclaimers that can be active at a
> time to the number of scan_control variables. kswapd could still allocate
> its on the stack or with kmalloc.
> 
> If it works out, it would have two main benefits. Limits the number of
> processes in direct reclaim - if there is NR_CPU-worth of proceses in direct
> reclaim, there is too much going on. It would also shrink the stack usage
> particularly if some of the stack variables are moved into scan_control.
> 
> Maybe someone will beat me to looking at the feasibility of this.

I already have some patches to remove trivial parts of struct scan_control,
namely may_unmap, may_swap, all_unreclaimable and isolate_pages.  The rest
needs a deeper look.

A rather big offender in there is the combination of shrink_active_list (360
bytes here) and shrink_page_list (200 bytes).  I am currently looking at
breaking out all the accounting stuff from shrink_active_list into a separate
leaf function so that the stack footprint does not add up.

Your idea of per-cpu allocated scan controls reminds me of an idea I have
had for some time now: moving reclaim into its own threads (per cpu?).

Not only would it separate the allocator's stack from the writeback stack,
we could also get rid of that too_many_isolated() workaround and coordinate
reclaim work better to prevent overreclaim.

But that is not a quick fix either...
