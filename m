Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0EESSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:18:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39081 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab0EESRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:17:47 -0400
Date: Wed, 5 May 2010 19:17:28 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
	the wrong VMA information
Message-ID: <20100505181728.GW20979@csn.ul.ie>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org> <20100505145620.GP20979@csn.ul.ie> <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org> <20100505175311.GU20979@csn.ul.ie> <alpine.LFD.2.00.1005051058380.27218@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005051058380.27218@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:02:25AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 5 May 2010, Mel Gorman wrote:
> > 
> > If the same_vma list is properly ordered then maybe something like the
> > following is allowed?
> 
> Heh. This is the same logic I just sent out. However:
> 
> > +	anon_vma = page_rmapping(page);
> > +	if (!anon_vma)
> > +		return NULL;
> > +
> > +	spin_lock(&anon_vma->lock);
> 
> RCU should guarantee that this spin_lock() is valid, but:
> 
> > +	/*
> > +	 * Get the oldest anon_vma on the list by depending on the ordering
> > +	 * of the same_vma list setup by __page_set_anon_rmap
> > +	 */
> > +	avc = list_entry(&anon_vma->head, struct anon_vma_chain, same_anon_vma);
> 
> We're not guaranteed that the 'anon_vma->head' list is non-empty.
> 
> Somebody could have freed the list and the anon_vma and we have a stale 
> 'page->anon_vma' (that has just not been _released_ yet). 
> 

Ahh, fair point. I asked in the other mail was the empty list check
necessary - it is. Thanks

> And shouldn't that be 'list_first_entry'? Or &anon_vma->head.next?
> 

Should have been list_first_entry.

> How did that line actually work for you? Or was it just a "it boots", but 
> no actual testing of the rmap walk?
> 

It's currently running a migration-related stress test without any
deadlocks or lockdep wobbly so far.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
