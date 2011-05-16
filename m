Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1EPNBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:01:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:23830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1EPNBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:01:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,374,1301900400"; 
   d="scan'208";a="747845870"
Date: Mon, 16 May 2011 21:00:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110516130055.GA12407@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140031.390955672@intel.com>
 <20110512225525.GK19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512225525.GK19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:55:25AM +0800, Dave Chinner wrote:
> On Thu, May 12, 2011 at 09:57:12PM +0800, Wu Fengguang wrote:
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> > 
> > At each queue_io() time, first try enqueuing only newly expired inodes.
> > If there are zero expired inodes to work with, then relax the rule and
> > enqueue all dirty inodes.
> > 
> > It at least makes sense from the data integrity point of view.
> > 
> > This may also reduce the number of dirty pages encountered by page
> > reclaim, eg. the pageout() calls. Normally older inodes contain older
> > dirty pages, which are more close to the end of the LRU lists. So
> > syncing older inodes first helps reducing the dirty pages reached by the
> > page reclaim code.
> > 
> > More background: as Mel put it, "it makes sense to write old pages first
> > to reduce the chances page reclaim is initiating IO."
> > 
> > Rik also presented the situation with a graph:
> > 
> > LRU head                                 [*] dirty page
> > [                          *              *      * *  *  * * * * * *]
> > 
> > Ideally, most dirty pages should lie close to the LRU tail instead of
> > LRU head. That requires the flusher thread to sync old/expired inodes
> > first (as there are obvious correlations between inode age and page
> > age), and to give fair opportunities to newly expired inodes rather
> > than sticking with some large eldest inodes (as larger inodes have
> > weaker correlations in the inode<=>page ages).
> > 
> > This patch helps the flusher to meet both the above requirements.
> > 
> > Side effects: it might reduce the batch size and hence reduce
> > inode_wb_list_lock hold time, but in turn make the cluster-by-partition
> > logic in the same function less effective on reducing disk seeks.
> > 
> > v2: keep policy changes inside wb_writeback() and keep the
> > wbc.older_than_this visibility as suggested by Dave.
> > 
> > CC: Dave Chinner <david@fromorbit.com>
> > Acked-by: Jan Kara <jack@suse.cz>
> > Acked-by: Rik van Riel<riel@redhat.com>
> > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  fs/fs-writeback.c |   16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:25.000000000 +0800
> > +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:26.000000000 +0800
> > @@ -718,7 +718,7 @@ static long wb_writeback(struct bdi_writ
> >  		if (work->for_background && !over_bground_thresh())
> >  			break;
> >  
> > -		if (work->for_kupdate) {
> > +		if (work->for_kupdate || work->for_background) {
> >  			oldest_jif = jiffies -
> >  				msecs_to_jiffies(dirty_expire_interval * 10);
> >  			wbc.older_than_this = &oldest_jif;
> > @@ -729,6 +729,7 @@ static long wb_writeback(struct bdi_writ
> >  		wbc.pages_skipped = 0;
> >  		wbc.inodes_cleaned = 0;
> >  
> > +retry:
> >  		trace_wbc_writeback_start(&wbc, wb->bdi);
> >  		if (work->sb)
> >  			__writeback_inodes_sb(work->sb, wb, &wbc);
> > @@ -752,6 +753,19 @@ static long wb_writeback(struct bdi_writ
> >  		if (wbc.inodes_cleaned)
> >  			continue;
> >  		/*
> > +		 * background writeback will start with expired inodes, and
> > +		 * if none is found, fallback to all inodes. This order helps
> > +		 * reduce the number of dirty pages reaching the end of LRU
> > +		 * lists and cause trouble to the page reclaim.
> > +		 */
> > +		if (work->for_background &&
> > +		    wbc.older_than_this &&
> > +		    list_empty(&wb->b_io) &&
> > +		    list_empty(&wb->b_more_io)) {
> > +			wbc.older_than_this = NULL;
> > +			goto retry;
> > +		}
> > +		/*
> >  		 * No more inodes for IO, bail
> >  		 */
> >  		if (!wbc.more_io)
> 
> I have to say that I dislike this implicit nested looping structure
> using a goto. It would seem better to me to make it explicit that we
> can do multiple writeback calls by using a do/while loop here and
> moving the logic of setting/resetting wbc.older_than_this to one
> place inside the nested loop...

This is the best I can do. Does it look better? Now the
.older_than_this modifying lines are close to each others :)

Thanks,
Fengguang
---

 fs/fs-writeback.c |   58 +++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-16 20:29:53.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-16 20:53:31.000000000 +0800
@@ -713,42 +713,22 @@ static long wb_writeback(struct bdi_writ
 	unsigned long oldest_jif;
 	struct inode *inode;
 	long progress;
+	bool bg_retry_all = false;
 
 	oldest_jif = jiffies;
 	work->older_than_this = &oldest_jif;
 
 	spin_lock(&wb->list_lock);
 	for (;;) {
-		/*
-		 * Stop writeback when nr_pages has been consumed
-		 */
-		if (work->nr_pages <= 0)
-			break;
-
-		/*
-		 * Background writeout and kupdate-style writeback may
-		 * run forever. Stop them if there is other work to do
-		 * so that e.g. sync can proceed. They'll be restarted
-		 * after the other works are all done.
-		 */
-		if ((work->for_background || work->for_kupdate) &&
-		    !list_empty(&wb->bdi->work_list))
-			break;
-
-		/*
-		 * For background writeout, stop when we are below the
-		 * background dirty threshold
-		 */
-		if (work->for_background && !over_bground_thresh())
-			break;
-
-		if (work->for_kupdate || work->for_background) {
+		if (bg_retry_all) {
+			bg_retry_all = false;
+			work->older_than_this = NULL;
+		} else if (work->for_kupdate || work->for_background) {
 			oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 			work->older_than_this = &oldest_jif;
 		}
 
-retry:
 		trace_writeback_start(wb->bdi, work);
 		if (list_empty(&wb->b_io))
 			queue_io(wb, work->older_than_this);
@@ -778,14 +758,38 @@ retry:
 		    work->older_than_this &&
 		    list_empty(&wb->b_io) &&
 		    list_empty(&wb->b_more_io)) {
-			work->older_than_this = NULL;
-			goto retry;
+			bg_retry_all = true;
+			continue;
 		}
 		/*
 		 * No more inodes for IO, bail
 		 */
 		if (list_empty(&wb->b_more_io))
 			break;
+
+		/*
+		 * Stop writeback when nr_pages has been consumed
+		 */
+		if (work->nr_pages <= 0)
+			break;
+
+		/*
+		 * Background writeout and kupdate-style writeback may
+		 * run forever. Stop them if there is other work to do
+		 * so that e.g. sync can proceed. They'll be restarted
+		 * after the other works are all done.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
+		/*
+		 * For background writeout, stop when we are below the
+		 * background dirty threshold
+		 */
+		if (work->for_background && !over_bground_thresh())
+			break;
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
