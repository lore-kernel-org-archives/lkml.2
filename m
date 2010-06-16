Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0FPFLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:11:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0FPFLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:11:45 -0400
Date: Wed, 16 Jun 2010 01:11:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100616051133.GC10687@infradead.org>
References: <4C17815A.8080402@redhat.com>
 <20100615135928.GK26788@csn.ul.ie>
 <4C178868.2010002@redhat.com>
 <20100615141601.GL26788@csn.ul.ie>
 <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
 <4C181AFD.5060503@redhat.com>
 <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
 <4C182097.2070603@redhat.com>
 <20100616104036.b45d352b.kamezawa.hiroyu@jp.fujitsu.com>
 <20100616112024.5b093905.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616112024.5b093905.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 11:20:24AM +0900, KAMEZAWA Hiroyuki wrote:
> BTW, copy_from_user/copy_to_user is _real_ problem, I'm afraid following
> much more than memcg.
> 
> handle_mm_fault()
> -> handle_pte_fault()
> -> do_wp_page()
> -> balance_dirty_page_rate_limited()
> -> balance_dirty_pages()
> -> writeback_inodes_wbc()
> -> writeback_inodes_wb()
> -> writeback_sb_inodes()
> -> writeback_single_inode()
> -> do_writepages()
> -> generic_write_pages()
> -> write_cache_pages()   // use on-stack pagevec.
> -> writepage()

Yes, this is a massive issue.  Strangely enough I just wondered about
this callstack as balance_dirty_pages is the only place calling into the
per-bdi/sb writeback code directly instead of offloading it to the
flusher threads.  It's something that should be fixed rather quickly
IMHO.  write_cache_pages and other bits of this writeback code can use
quite large amounts of stack.
