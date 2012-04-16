Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2DPPvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:51:06 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:55891 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2DPPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:51:03 -0400
Date: Mon, 16 Apr 2012 17:50:40 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
Message-ID: <20120416175040.0e33b37f@de.ibm.com>
In-Reply-To: <20120416141423.GD2359@suse.de>
References: <20120416141423.GD2359@suse.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041615-0542-0000-0000-0000018E86F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 15:14:23 +0100
Mel Gorman <mgorman@suse.de> wrote:

> This patch is horribly ugly and there has to be a better way of doing
> it. I'm looking for suggestions on what s390 can do here that is not
> painful or broken. 
> 
> However, s390 needs a better way of guarding against
> PageSwapCache pages being removed from the radix tree while set_page_dirty()
> is being called. The patch would be marginally better if in the PageSwapCache
> case we simply tried to lock once and in the contended case just fail to
> propogate the storage key. I lack familiarity with the s390 architecture
> to be certain if this is safe or not. Suggestions on a better fix?

One though that crossed my mind is that maybe a better approach would be
to move the page_test_and_clear_dirty check out of page_remove_rmap.
What we need to look out for are code sequences of the form:

	if (pte_dirty(pte))
		set_page_dirty(page);
	...
	page_remove_rmap(page);

There are four of those as far as I can see: in try_to_unmap_one,
try_to_unmap_cluster, zap_pte, and zap_pte_range.

A valid implementation for s390 would be to test and clear the changed
bit in the storage key for every of those pte_dirty() calls.

	if (pte_dirty(pte) || page_test_and_clear_dirty(page))
		set_page_dirty(page);
	...
	page_remove_rmap(page); /* w/o page_test_clear_dirty */

Trouble is that the ISKE and SSKE instructions are very expensive, that
is why we currently have the operation in page_remove_rmap after the
map counter dropped to zero (which is wrong as we now have learned the
hard way). The additional check for (!PageAnon || PageSwapCache) is
just another variation of avoiding ISKE/SSKE.

Thinking about a function like this:

static inline int page_test_dirty_eco(struct page *page)
{
	if (page_mapcount(page) > 1)
		return 0;
	if (PageAnon(page) && !PageSwapCache(page))
		return 0;
	return page_test_and_clear_dirty(page);
}

and use it alongside the pte_dirty() check. The worry I have is the
map counter. What guarantees us that the map counter is not decremented
concurrently? Which is probably a problem with the current patch as
well, checking atomic_add_negative(-1, &page->_mapcount) against zero
works, doing (page_mapcount(page) == 1) followed by the decrement 
can race. And we better not forget a dirty bit ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

