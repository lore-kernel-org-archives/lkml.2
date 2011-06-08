Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab1FHAKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:10:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:20021 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab1FHAKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="13245847"
Date: Wed, 8 Jun 2011 08:10:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110608001048.GC19547@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213853.757201783@intel.com>
 <20110607160313.86fb31df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607160313.86fb31df.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:03:13AM +0800, Andrew Morton wrote:
> On Wed, 08 Jun 2011 05:32:39 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > The flusher works on dirty inodes in batches, and may quit prematurely
> > if the batch of inodes happen to be metadata-only dirtied: in this case
> > wbc->nr_to_write won't be decreased at all, which stands for "no pages
> > written" but also mis-interpreted as "no progress".
> > 
> > So introduce writeback_control.inodes_cleaned to count the inodes get
> > cleaned.  A non-zero value means there are some progress on writeback,
> > in which case more writeback can be tried.
> 
> Yes, that makes sense.  I had a workload which demonstrated/exploited
> this nine years ago but I never got around to fixing it, never told
> anyone and nobody noticed ;)

Good to know that :)

> > +	long inodes_cleaned;		/* # of inodes cleaned */
> 
> nanonit: I'd call this inodes_written, because they may not actually be
> clean.

Yeah, at least for ext4.

Done the rename. Also added a note that it's not the exact number of
inodes written.

Thanks,
Fengguang
---
Subject: writeback: introduce writeback_control.inodes_written
Date: Wed Jul 21 22:50:57 CST 2010

The flusher works on dirty inodes in batches, and may quit prematurely
if the batch of inodes happen to be metadata-only dirtied: in this case
wbc->nr_to_write won't be decreased at all, which stands for "no pages
written" but also mis-interpreted as "no progress".

So introduce writeback_control.inodes_written to count the inodes get
cleaned from VFS POV.  A non-zero value means there are some progress on
writeback, in which case more writeback can be tried.

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    4 ++++
 include/linux/writeback.h |    1 +
 2 files changed, 5 insertions(+)

about v1: The initial version was to count successful ->write_inode()
calls.  However it leads to busy loops for sync() over NFS, because NFS
ridiculously returns 0 (success) while at the same time redirties the
inode.  The NFS case can be trivially fixed, however there may be more
hidden bugs in other filesystems..

--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:16.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:16.000000000 +0800
@@ -464,6 +464,7 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
+			wbc->inodes_written++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -725,6 +726,7 @@ static long wb_writeback(struct bdi_writ
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
+		wbc.inodes_written = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
@@ -741,6 +743,8 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (wbc.nr_to_write <= 0)
 			continue;
+		if (wbc.inodes_written)
+			continue;
 		/*
 		 * Didn't write everything and we don't have more IO, bail
 		 */
--- linux-next.orig/include/linux/writeback.h	2011-05-24 11:17:14.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-24 11:17:16.000000000 +0800
@@ -34,6 +34,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long inodes_written;		/* # of inodes written (at least) */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
