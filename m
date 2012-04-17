Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2DQNDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:03:09 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53316 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2DQNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:03:08 -0400
Date: Tue, 17 Apr 2012 15:02:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
Message-ID: <20120417150237.0abb8ec5@de.ibm.com>
In-Reply-To: <20120417122925.GG2359@suse.de>
References: <20120416141423.GD2359@suse.de>
	<20120416175040.0e33b37f@de.ibm.com>
	<20120417122925.GG2359@suse.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041713-5024-0000-0000-0000024897B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 13:29:25 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Mon, Apr 16, 2012 at 05:50:40PM +0200, Martin Schwidefsky wrote:
> > On Mon, 16 Apr 2012 15:14:23 +0100
> > Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > This patch is horribly ugly and there has to be a better way of doing
> > > it. I'm looking for suggestions on what s390 can do here that is not
> > > painful or broken. 
> > > 
> > > However, s390 needs a better way of guarding against
> > > PageSwapCache pages being removed from the radix tree while set_page_dirty()
> > > is being called. The patch would be marginally better if in the PageSwapCache
> > > case we simply tried to lock once and in the contended case just fail to
> > > propogate the storage key. I lack familiarity with the s390 architecture
> > > to be certain if this is safe or not. Suggestions on a better fix?
> > 
> > One though that crossed my mind is that maybe a better approach would be
> > to move the page_test_and_clear_dirty check out of page_remove_rmap.
> > What we need to look out for are code sequences of the form:
> > 
> > 	if (pte_dirty(pte))
> > 		set_page_dirty(page);
> > 	...
> > 	page_remove_rmap(page);
> > 
> > There are four of those as far as I can see: in try_to_unmap_one,
> > try_to_unmap_cluster, zap_pte, and zap_pte_range.
> > 
> > A valid implementation for s390 would be to test and clear the changed
> > bit in the storage key for every of those pte_dirty() calls.
> > 
> > 	if (pte_dirty(pte) || page_test_and_clear_dirty(page))
> > 		set_page_dirty(page);
> > 	...
> > 	page_remove_rmap(page); /* w/o page_test_clear_dirty */
> > 
> 
> In the zap_pte_range() case at least, pte_dirty() is only being checked
> for !PageAnon pages so if we took this approach we would miss
> PageSwapCache pages. If we added the check then the same problem is hit
> and we'd need additional logic there for s390 to drop the PTL, take the
> page lock and retry the operation. It'd still be ugly :(

Well if x86 can get away with ignoring PageSwapCache pages in zap_pte_range()
pages then s390 should be able to get away with it as well, no ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

