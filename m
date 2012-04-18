Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2DRSaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:30:01 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43152 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2DRS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:29:58 -0400
Date: Wed, 18 Apr 2012 20:29:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ken Chen <kenchen@google.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
Message-ID: <20120418202949.13c484f1@de.ibm.com>
In-Reply-To: <20120418152831.GK2359@suse.de>
References: <20120416141423.GD2359@suse.de>
	<alpine.LSU.2.00.1204161332120.1675@eggly.anvils>
	<20120417122202.GF2359@suse.de>
	<alpine.LSU.2.00.1204172023390.1609@eggly.anvils>
	<20120418152831.GK2359@suse.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041818-1948-0000-0000-0000018F2DF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012 16:28:31 +0100
Mel Gorman <mgorman@suse.de> wrote:

> > <SNIP>
> >
> > [PATCH] mm: fix s390 BUG by using __set_page_dirty_no_writeback on swap
> > 
> > Mel reports a BUG_ON(slot == NULL) in radix_tree_tag_set() on s390 3.0.13:
> > called from __set_page_dirty_nobuffers() when page_remove_rmap() tries to
> > transfer dirty flag from s390 storage key to struct page and radix_tree.
> > 
> > That would be because of reclaim's shrink_page_list() calling add_to_swap()
> > on this page at the same time: first PageSwapCache is set (causing
> > page_mapping(page) to appear as &swapper_space), then page->private set,
> > then tree_lock taken, then page inserted into radix_tree - so there's
> > an interval before taking the lock when the radix_tree slot is empty.
> > 
> 
> Yes, makes sense.
> 
> > We could fix this by moving __add_to_swap_cache()'s spin_lock_irq up
> > before SetPageSwapCache, with error case ClearPageSwapCache moved up
> > under tree_lock too.
> > 
> 
> This can be done if/when swapper_space can make proper use of the dirty
> tag information.
> 
> > But a better fix is just to do what's five years overdue.  Ken Chen
> > added __set_page_dirty_no_writeback() (if !PageDirty TestSetPageDirty)
> > for tmpfs to skip all that radix_tree overhead, and swap is just the same:
> > it ignores the radix_tree tag, and does not participate in dirty page
> > accounting, so should be using __set_page_dirty_no_writeback() too.
> > 
> > Reported-by: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 
> I've sent a kernel based on this patch to the s390 folk that originally
> reported the bug. Hopefully they'll test and get back to me in a few
> days.
> 
> Thanks Hugh.

Indeed, thanks Hugh. The patches so far were not pretty at all.. 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

