Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0DOCny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:43:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41756 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0DOCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:43:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415023704.GC20640@cmpxchg.org>
References: <20100414085132.GJ25756@csn.ul.ie> <20100415023704.GC20640@cmpxchg.org>
Message-Id: <20100415114043.D162.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 11:43:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Wed, Apr 14, 2010 at 09:51:33AM +0100, Mel Gorman wrote:
> > They will need to be tackled in turn then but obviously there should be
> > a focus on the common paths. The reclaim paths do seem particularly
> > heavy and it's down to a lot of temporary variables. I might not get the
> > time today but what I'm going to try do some time this week is
> > 
> > o Look at what temporary variables are copies of other pieces of information
> > o See what variables live for the duration of reclaim but are not needed
> >   for all of it (i.e. uninline parts of it so variables do not persist)
> > o See if it's possible to dynamically allocate scan_control
> > 
> > The last one is the trickiest. Basically, the idea would be to move as much
> > into scan_control as possible. Then, instead of allocating it on the stack,
> > allocate a fixed number of them at boot-time (NR_CPU probably) protected by
> > a semaphore. Limit the number of direct reclaimers that can be active at a
> > time to the number of scan_control variables. kswapd could still allocate
> > its on the stack or with kmalloc.
> > 
> > If it works out, it would have two main benefits. Limits the number of
> > processes in direct reclaim - if there is NR_CPU-worth of proceses in direct
> > reclaim, there is too much going on. It would also shrink the stack usage
> > particularly if some of the stack variables are moved into scan_control.
> > 
> > Maybe someone will beat me to looking at the feasibility of this.
> 
> I already have some patches to remove trivial parts of struct scan_control,
> namely may_unmap, may_swap, all_unreclaimable and isolate_pages.  The rest
> needs a deeper look.

Seems interesting. but scan_control diet is not so effective. How much
bytes can we diet by it?


> A rather big offender in there is the combination of shrink_active_list (360
> bytes here) and shrink_page_list (200 bytes).  I am currently looking at
> breaking out all the accounting stuff from shrink_active_list into a separate
> leaf function so that the stack footprint does not add up.

pagevec. it consume 128bytes per struct. I have removing patch.


> Your idea of per-cpu allocated scan controls reminds me of an idea I have
> had for some time now: moving reclaim into its own threads (per cpu?).
> 
> Not only would it separate the allocator's stack from the writeback stack,
> we could also get rid of that too_many_isolated() workaround and coordinate
> reclaim work better to prevent overreclaim.
> 
> But that is not a quick fix either...

So, I haven't think this way. probably seems good. but I like to do
simple diet at first.



