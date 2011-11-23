Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1KWTRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:17:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60827 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1KWTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:17:00 -0500
Date: Wed, 23 Nov 2011 11:16:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@lst.de>
cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] fs: wire up .truncate_range and .fallocate
In-Reply-To: <20111123103829.GA23168@lst.de>
Message-ID: <alpine.LSU.2.00.1111231107430.2226@sister.anvils>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <1322038412-29013-2-git-send-email-amwang@redhat.com> <20111123103829.GA23168@lst.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Christoph Hellwig wrote:
> 
> It also seems like all fallocate implementaions for far got away
> without the unmap_mapping_range, so either people didn't test them
> hard enough, or tmpfs doesn't need it either.  I fear the former
> is true.

They're saved by the funny little one-by-one unmap_mapping_range()
fallback in truncate_inode_page().  It's inefficient (in those rare
cases when someone is punching a hole somewhere that's mapped) and
we ought to do better, but we don't have an actual bug there.

Hugh

int truncate_inode_page(struct address_space *mapping, struct page *page)
{
	if (page_mapped(page)) {
		unmap_mapping_range(mapping,
				   (loff_t)page->index << PAGE_CACHE_SHIFT,
				   PAGE_CACHE_SIZE, 0);
	}
	return truncate_complete_page(mapping, page);
}
