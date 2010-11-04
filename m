Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0KDNy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:54:29 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:48557 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0KDNy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:54:28 -0400
Date: Thu, 4 Nov 2010 14:54:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, arunabal@in.ibm.com,
        sbest@us.ibm.com, stable <stable@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Revalidate page->mapping in do_generic_file_read()
Message-ID: <20101104135413.GB6384@cmpxchg.org>
References: <20101103220941.C88FA932@kernel.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103220941.C88FA932@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 03:09:41PM -0700, Dave Hansen wrote:
> 
> 70 hours into some stress tests of a 2.6.32-based enterprise kernel,
> we ran into a NULL dereference in here:
> 
> 	int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
> 	                                        unsigned long from)
> 	{
> ---->		struct inode *inode = page->mapping->host;
> 
> It looks like page->mapping was the culprit.  (xmon trace is below).
> After closer examination, I realized that do_generic_file_read() does
> a find_get_page(), and eventually locks the page before calling
> block_is_partially_uptodate().  However, it doesn't revalidate the
> page->mapping after the page is locked.  So, there's a small window
> between the find_get_page() and ->is_partially_uptodate() where the
> page could get truncated and page->mapping cleared.
> 
> We _have_ a reference, so it can't get reclaimed, but it certainly
> can be truncated.
> 
> I think the correct thing is to check page->mapping after the
> trylock_page(), and jump out if it got truncated.  This patch has
> been running in the test environment for a month or so now, and we
> have not seen this bug pop up again.

[...]

> diff -puN mm/filemap.c~is_partially_uptodate-revalidate-page mm/filemap.c
> --- linux-2.6.git/mm/filemap.c~is_partially_uptodate-revalidate-page	2010-11-03 13:49:21.000000000 -0700
> +++ linux-2.6.git-dave/mm/filemap.c	2010-11-03 14:01:07.000000000 -0700
> @@ -1016,6 +1016,8 @@ find_page:
>  				goto page_not_up_to_date;
>  			if (!trylock_page(page))
>  				goto page_not_up_to_date;
> +			if (page->mapping != mapping)
> +				goto page_not_up_to_date_locked;

My understanding is that the page can only get truncated but not moved
to another mapping.  So I would find it more straight-forward to just
check for !page->mapping instead (like the code you jump to does, too)

It should not stand in the way of this very important bug fix, though!

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
