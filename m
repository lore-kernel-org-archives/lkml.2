Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1EDLw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:52:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:9201 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1EDLwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:52:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="742199501"
Date: Wed, 4 May 2011 19:52:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: make nr_to_write a per-file limit
Message-ID: <20110504115251.GC5853@localhost>
References: <20110504091707.910929441@intel.com>
 <20110504091909.520602641@intel.com>
 <20110504094221.GA20958@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504094221.GA20958@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 05:42:21PM +0800, Christoph Hellwig wrote:
> On Wed, May 04, 2011 at 05:17:10PM +0800, Wu Fengguang wrote:
> > This ensures large dirty files can be written in the full 4MB writeback
> > chunk size, rather than whatever remained quota in wbc->nr_to_write.
> 
> I like the high-level idea, but the implementation of overriding
> nr_to_write and then copying it back seems rather ugly.
> 
> The basic problem seems to be that struct writeback_control is
> designed to control writeback of a single file, but we keep abuse it
> for writing multiple files in writeback_sb_inodes and its callers.
> 
> It seems like we should only build the struct writeback_control from
> struct wb_writeback_work down in writeback_sb_inodes, even if that
> means passing some more information to it either in struct
> wb_writeback_work or on the stack.

Yes it's very reasonable and possible according to your notes in
another email.

> Then writeback_sb_inodes can do something like
> 
> 	if (wbc.sync_mode == WB_SYNC_NONE)
> 		wbc.nr_to_write = min(MAX_WRITEBACK_PAGES, work->nr_pages);

I like the min() idea. However it have the side effect of (very possible)
smallish IO from balance_dirty_pages(), which may call us with small
->nr_pages. 

We may explicitly do "write_chunk = max(MAX_WRITEBACK_PAGES, write_chunk)"
in balance_dirty_pages() to retain the old behavior.

> 	else
> 		wbc.nr_to_write = LONG_MAX;
> 
> for each inode it writes.

Thanks,
Fengguang
