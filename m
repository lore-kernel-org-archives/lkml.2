Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0GZKcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:32:13 -0400
Received: from irs1ma.bb4u.ne.jp ([202.229.9.180]:56050 "HELO irs1m.bias.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753807Ab0GZKcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:32:12 -0400
Date: Mon, 26 Jul 2010 19:28:37 +0900
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/6] [RFC] writeback: try to write older pages first
Message-Id: <20100726192837.1cac842e.kitayama@cl.bb4u.ne.jp>
In-Reply-To: <20100722050928.653312535@intel.com>
References: <20100722050928.653312535@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here's a touch up patch on top of your changes against the latest
mmotm.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
---
 fs/btrfs/extent_io.c        |    2 --
 include/trace/events/ext4.h |    5 +----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cb9af26..b494dee 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2586,7 +2586,6 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
        };
        struct writeback_control wbc_writepages = {
                .sync_mode      = wbc->sync_mode,
-               .older_than_this = NULL,
                .nr_to_write    = 64,
                .range_start    = page_offset(page) + PAGE_CACHE_SIZE,
                .range_end      = (loff_t)-1,
@@ -2619,7 +2618,6 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
        };
        struct writeback_control wbc_writepages = {
                .sync_mode      = mode,
-               .older_than_this = NULL,
                .nr_to_write    = nr_pages * 2,
                .range_start    = start,
                .range_end      = end + 1,
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f3865c7..099598b 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -305,7 +305,6 @@ TRACE_EVENT(ext4_da_writepages_result,
                __field(        int,    ret                     )
                __field(        int,    pages_written           )
                __field(        long,   pages_skipped           )
-               __field(        char,   more_io                 )       
                __field(       pgoff_t, writeback_index         )
        ),
 
@@ -315,15 +314,13 @@ TRACE_EVENT(ext4_da_writepages_result,
                __entry->ret            = ret;
                __entry->pages_written  = pages_written;
                __entry->pages_skipped  = wbc->pages_skipped;
-               __entry->more_io        = wbc->more_io;
                __entry->writeback_index = inode->i_mapping->writeback_index;
        ),
 
-       TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld more_io %d writeback_index %lu",
+       TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld writeback_index %lu",
                  jbd2_dev_to_name(__entry->dev),
                  (unsigned long) __entry->ino, __entry->ret,
                  __entry->pages_written, __entry->pages_skipped,
-                 __entry->more_io,
                  (unsigned long) __entry->writeback_index)
 );
 
-- 
1.7.1.1
