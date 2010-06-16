Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab0FPKvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:51:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34218 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab0FPKvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:51:40 -0400
Message-ID: <4C18ACBB.1090002@kernel.dk>
Date: Wed, 16 Jun 2010 12:51:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
References: <4C17815A.8080402@redhat.com> <20100615135928.GK26788@csn.ul.ie> <4C178868.2010002@redhat.com> <20100615141601.GL26788@csn.ul.ie> <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com> <4C181AFD.5060503@redhat.com> <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com> <4C182097.2070603@redhat.com> <20100616104036.b45d352b.kamezawa.hiroyu@jp.fujitsu.com> <20100616112024.5b093905.kamezawa.hiroyu@jp.fujitsu.com> <20100616051133.GC10687@infradead.org>
In-Reply-To: <20100616051133.GC10687@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-16 07:11, Christoph Hellwig wrote:
> On Wed, Jun 16, 2010 at 11:20:24AM +0900, KAMEZAWA Hiroyuki wrote:
>> BTW, copy_from_user/copy_to_user is _real_ problem, I'm afraid following
>> much more than memcg.
>>
>> handle_mm_fault()
>> -> handle_pte_fault()
>> -> do_wp_page()
>> -> balance_dirty_page_rate_limited()
>> -> balance_dirty_pages()
>> -> writeback_inodes_wbc()
>> -> writeback_inodes_wb()
>> -> writeback_sb_inodes()
>> -> writeback_single_inode()
>> -> do_writepages()
>> -> generic_write_pages()
>> -> write_cache_pages()   // use on-stack pagevec.
>> -> writepage()
> 
> Yes, this is a massive issue.  Strangely enough I just wondered about
> this callstack as balance_dirty_pages is the only place calling into the
> per-bdi/sb writeback code directly instead of offloading it to the
> flusher threads.  It's something that should be fixed rather quickly
> IMHO.  write_cache_pages and other bits of this writeback code can use
> quite large amounts of stack.

I've had the same thought as well, bdp() should just signal a writeback
instead. Much cleaner than doing cleaning from that point.

-- 
Jens Axboe

