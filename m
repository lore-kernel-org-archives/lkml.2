Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0KJCpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:45:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:50967 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab0KJCoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="346765838"
Message-Id: <20101110024223.847210776@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 10 Nov 2010 10:35:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] writeback: stop background/kupdate works from livelocking other works
References: <20101110023500.404859581@intel.com>
Content-Disposition: inline; filename=0002-mm-Stop-background-writeback-if-there-is-other-work-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Background writeback is easily livelockable in a loop in wb_writeback()
by a process continuously re-dirtying pages (or continuously appending
to a file). This is in fact intended as the target of background
writeback is to write dirty pages it can find as long as we are over
dirty_background_threshold.

But the above behavior gets inconvenient at times because no other work
queued in the flusher thread's queue gets processed. In particular,
since e.g. sync(1) relies on flusher thread to do all the IO for it,
sync(1) can hang forever waiting for flusher thread to do the work.

Generally, when a flusher thread has some work queued, someone submitted
the work to achieve a goal more specific than what background writeback
does. Moreover by working on the specific work, we also reduce amount of
dirty pages which is exactly the target of background writeout. So it
makes sense to give specific work a priority over a generic page
cleaning.

Thus we interrupt background writeback if there is some other work to
do. We return to the background writeback after completing all the
queued work.

This may delay the writeback of expired inodes for a while, however the
expired inodes will eventually be flushed to disk as long as the other
works won't livelock.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-11-10 07:04:34.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-10 10:32:09.000000000 +0800
@@ -651,6 +651,16 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
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
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */


