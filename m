Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0FQAaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:30:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43748 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0FQAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:30:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Jun 2010 09:25:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100617092538.c712342b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616050640.GA10687@infradead.org>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>
	<4C16A567.4080000@redhat.com>
	<20100615114510.GE26788@csn.ul.ie>
	<4C17815A.8080402@redhat.com>
	<20100615135928.GK26788@csn.ul.ie>
	<4C178868.2010002@redhat.com>
	<20100615141601.GL26788@csn.ul.ie>
	<20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
	<20100616050640.GA10687@infradead.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 01:06:40 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jun 16, 2010 at 09:17:55AM +0900, KAMEZAWA Hiroyuki wrote:
> > yes. It's only called from 
> > 	- page fault
> > 	- add_to_page_cache()
> > 
> > I think we'll see no stack problem. Now, memcg doesn't wakeup kswapd for
> > reclaiming memory, it needs direct writeback.
> 
> The page fault code should be fine, but add_to_page_cache can be called
> with quite deep stacks.  Two examples are grab_cache_page_write_begin
> which already was part of one of the stack overflows mentioned in this
> thread, or find_or_create_page which can be called via
> _xfs_buf_lookup_pages, which can be called from under the whole XFS
> allocator, or via grow_dev_page which might have a similarly deep
> stack for users of the normal buffer cache.  Although for the
> find_or_create_page we usually should not have __GFP_FS set in the
> gfp_mask.
> 

Hmm. ok, then, memory cgroup needs some care.

BTW, why xbf_buf_create() use GFP_KERNEL even if it can be blocked ?
memory cgroup just limits pages for users, then, doesn't intend to
limit kernel pages. If this buffer is not for user(visible page cache), but for
internal structure, I'll have to add a code for ignoreing memory cgroup check
when gfp_mask doesn't have GFP_MOVABLE.


Thanks,
-Kame

