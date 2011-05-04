Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1EDQS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:18:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1EDQSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:18:25 -0400
Date: Wed, 4 May 2011 12:18:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: make nr_to_write a per-file limit
Message-ID: <20110504161816.GA8147@infradead.org>
References: <20110504091707.910929441@intel.com>
 <20110504091909.520602641@intel.com>
 <20110504094221.GA20958@infradead.org>
 <20110504115251.GC5853@localhost>
 <20110504155100.GA29029@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504155100.GA29029@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - move MAX_WRITEBACK_PAGES and wb_writeback_work definitions to writeback.h

I think it would be a good idea to keep this in fs/fs-writeback.c, which
means we'd need a small writeback_inodes_wb wrapper for
balance_dirty_pages and bdi_flush_io.  But IIRC your tree already has
__writeback_inodes_wb for use in wb_writeback, so writeback_inodes_wb
could be that wrapper.

> +	long write_chunk = MAX_WRITEBACK_PAGES;
> +	long wrote = 0;
> +	bool inode_cleaned = false;
> +
> +	/*
> +	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
> +	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
> +	 * here avoids calling into writeback_inodes_wb() more than once.
> +	 *
> +	 * The intended call sequence for WB_SYNC_ALL writeback is:
> +	 *
> +	 *      wb_writeback()
> +	 *          writeback_sb_inodes()       <== called only once
> +	 *              write_cache_pages()     <== called once for each inode
> +	 *                   (quickly) tag currently dirty pages
> +	 *                   (maybe slowly) sync all tagged pages
> +	 */
> +	if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
> +		write_chunk = LONG_MAX;

I think this would be easier to read if kept as and if / else clause
with the MAX_WRITEBACK_PAGES usage.

> +		write_chunk = min(write_chunk, work->nr_pages);

Or in fact done here - for the WB_SYNC_ALL case LONG_MAX should
always be larger than work->nr_pages, so the whole thing could be
simplified to:

		if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
			write_chunk = LONG_MAX;
		else
			write_chunk = min(MAX_WRITEBACK_PAGES, work->nr_pages);


Other notes:

 - older_than_this in writeback_control shouldn't be needed anymore
 - is the early return for the mis-matching sb in writeback_sb_inodes
   handled correctly?  Before it had the special 0 return value, and
   I'm not quite sure how that fits into your new enum scheme.
