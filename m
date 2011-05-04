Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1EDJma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:42:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1EDJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:42:27 -0400
Date: Wed, 4 May 2011 05:42:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] writeback: make nr_to_write a per-file limit
Message-ID: <20110504094221.GA20958@infradead.org>
References: <20110504091707.910929441@intel.com>
 <20110504091909.520602641@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504091909.520602641@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 05:17:10PM +0800, Wu Fengguang wrote:
> This ensures large dirty files can be written in the full 4MB writeback
> chunk size, rather than whatever remained quota in wbc->nr_to_write.

I like the high-level idea, but the implementation of overriding
nr_to_write and then copying it back seems rather ugly.

The basic problem seems to be that struct writeback_control is
designed to control writeback of a single file, but we keep abuse it
for writing multiple files in writeback_sb_inodes and its callers.

It seems like we should only build the struct writeback_control from
struct wb_writeback_work down in writeback_sb_inodes, even if that
means passing some more information to it either in struct
wb_writeback_work or on the stack.

Then writeback_sb_inodes can do something like

	if (wbc.sync_mode == WB_SYNC_NONE)
		wbc.nr_to_write = min(MAX_WRITEBACK_PAGES, work->nr_pages);
	else
		wbc.nr_to_write = LONG_MAX;

for each inode it writes.

