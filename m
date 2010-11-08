Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0KHXTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:19:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:42412 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0KHXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,171,1288594800"; 
   d="scan'208";a="346159512"
Message-Id: <20101108231726.993880740@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Nov 2010 07:09:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] writeback: stop background/kupdate works from livelocking other works
References: <20101108230916.826791396@intel.com>
Content-Disposition: inline; filename=0002-mm-Stop-background-writeback-if-there-is-other-work-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Background writeback are easily livelockable (from a definition of their
target). This is inconvenient because it can make sync(1) stall forever waiting
on its queued work to be finished. Generally, when a flusher thread has
some work queued, someone submitted the work to achieve a goal more specific
than what background writeback does. So it makes sense to give it a priority
over a generic page cleaning.

Thus we interrupt background writeback if there is some other work to do. We
return to the background writeback after completing all the queued work.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-11-07 21:56:42.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-07 22:00:51.000000000 +0800
@@ -651,6 +651,15 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
+		 * Background writeout and kupdate-style writeback are
+		 * easily livelockable. Stop them if there is other work
+		 * to do so that e.g. sync can proceed.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
+		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */


