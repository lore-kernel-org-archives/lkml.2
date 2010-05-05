Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab0EEPzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:55:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57357 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0EEPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:55:13 -0400
Date: Wed, 5 May 2010 16:54:54 +0100
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
Message-ID: <20100505155454.GT20979@csn.ul.ie>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie> <1273065281-13334-2-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org> <20100505145620.GP20979@csn.ul.ie> <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:31:42AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 5 May 2010, Mel Gorman wrote:
> > 
> > rmap_walk() appears to be the only one that takes multiple locks but it itself
> > is not serialised. If there are more than one process calling rmap_walk()
> > on different processes sharing the same VMAs, is there a guarantee they walk
> > it in the same order?
> 
> So I had this notion of the list always getting deeper and us guaranteeing 
> the order in it, but you're right - that's not the 'same_anon_vma' list, 
> it's the 'same_vma' one.
> 
> Damn. So yeah, I don't see us guaranteeing any ordering guarantees. My 
> bad.
> 
> That said, I do wonder if we could _make_ the ordering reliable.

I'm still thinking of the ordering but one possibility would be to use a mutex
similar to mm_all_locks_mutex to force the serialisation of rmap_walk instead
of the trylock-and-retry. That way, the ordering wouldn't matter. It would
slow migration if multiple processes are migrating pages by some unknowable
quantity but it would avoid livelocking.

> I did 
> that for the 'same_vma' one, because I wanted to be able to verify that 
> chains were consistent (and we also needed to be able to find the "oldest 
> anon_vma" for the case of re-instantiating pages that migth exist in 
> multiple different anon_vma's).
> 
> Any ideas?
> 

Not yet.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
