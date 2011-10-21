Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1JUSjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:39:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:43470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab1JUSje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:39:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,387,1315206000"; 
   d="scan'208";a="65050693"
Date: Fri, 21 Oct 2011 18:40:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked
 inodes
Message-ID: <20111021104049.GA3784@localhost>
References: <20111020152240.751936131@intel.com>
 <20111020232116.GB20542@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020232116.GB20542@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

>   How about adding the attached patch to the series? With it applied we
> would have all busyloop prevention done in the same way.

Sure. It looks good.

> +		pr_warn_ratelimited("mm: Possible busyloop in data writeback "
> +			"(bdi %s nr_pages %ld sync_mode %d kupdate %d "
> +			"background %d)\n",
> +			wb->bdi->name, work->nr_pages, work->sync_mode,
> +			work->for_kupdate, work->for_background);

I'll change the last two fields to the newly introduced writeback "reason":

                pr_warn_ratelimited("mm: Possible busyloop in data writeback "
                        "(bdi %s nr_pages %ld sync_mode %d reason %s)\n",
                        wb->bdi->name, work->nr_pages, work->sync_mode,
                        wb_reason_name[work->reason]);

btw, with the I_SYNC case converted, it's actually no longer necessary
to keep a standalone b_more_io_wait. It should still be better to keep
the list and the above error check for catching possible errors and
the flexibility of adding policies like "don't retry possible blocked
inodes in N seconds as long as there are other inodes to work with".

The below diff only intends to show the _possibility_ to remove
b_more_io_wait:

--- linux-next.orig/fs/fs-writeback.c	2011-10-21 18:25:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-10-21 18:27:41.000000000 +0800
@@ -235,20 +235,7 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
-/*
- * The inode should be retried in an opportunistic way.
- *
- * The only difference between b_more_io and b_more_io_wait is:
- * wb_writeback() won't quit as long as b_more_io is not empty.  When
- * wb_writeback() quit on empty b_more_io and non-empty b_more_io_wait,
- * the kupdate work will wakeup more frequently to retry the inodes in
- * b_more_io_wait.
- */
-static void requeue_io_wait(struct inode *inode, struct bdi_writeback *wb)
-{
-	assert_spin_locked(&wb->list_lock);
-	list_move(&inode->i_wb_list, &wb->b_more_io_wait);
-}
+#define requeue_io_wait(inode, wb) requeue_io(inode, wb)
 
 static void inode_sync_complete(struct inode *inode)
 {
@@ -798,21 +785,8 @@ static long wb_writeback(struct bdi_writ
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (progress)
-			continue;
-		/*
-		 * No more inodes for IO, bail
-		 */
-		if (list_empty(&wb->b_more_io))
+		if (!progress)
 			break;
-		/*
-		 * Nothing written but some inodes were moved to b_more_io.
-		 * This should not happen as we can easily busyloop.
-		 */
-		pr_warn_ratelimited("mm: Possible busyloop in data writeback "
-			"(bdi %s nr_pages %ld sync_mode %d reason %s)\n",
-			wb->bdi->name, work->nr_pages, work->sync_mode,
-			wb_reason_name[work->reason]);
 	}
 	spin_unlock(&wb->list_lock);

Thanks,
Fengguang
