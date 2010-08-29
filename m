Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0H2ATi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 20:19:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:7520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab0H2ATg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 20:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,285,1280732400"; 
   d="scan'208";a="549698181"
Date: Sun, 29 Aug 2010 08:19:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Brown <neilb@suse.de>, Con Kolivas <kernel@kolivas.org>,
        Jan Kara <jack@suse.cz>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: [PATCH v2] writeback: remove the internal 5% low bound on
 dirty_ratio
Message-ID: <20100829001917.GA11403@localhost>
References: <20100827103603.GB6237@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827103603.GB6237@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dirty_ratio was siliently limited in global_dirty_limits() to >= 5%.
This is not a user expected behavior. And it's inconsistent with
calc_period_shift(), which uses the plain vm_dirty_ratio value.

Let's rip the internal bound.

At the same time, fix balance_dirty_pages() to work with the
dirty_thresh=0 case. This allows applications to proceed when
dirty+writeback pages are all cleaned.

And ">" fits with the name "exceeded" better than ">=" does. Neil
think it is an aesthetic improvement as well as a functional one :)

v2: convert the background writeback checks, too. Just to be sure.

CC: Jan Kara <jack@suse.cz>
Proposed-by: Con Kolivas <kernel@kolivas.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Neil Brown <neilb@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c   |    2 +-
 mm/page-writeback.c |   16 +++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-08-29 08:10:30.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-29 08:12:08.000000000 +0800
@@ -415,14 +415,8 @@ void global_dirty_limits(unsigned long *
 
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else {
-		int dirty_ratio;
-
-		dirty_ratio = vm_dirty_ratio;
-		if (dirty_ratio < 5)
-			dirty_ratio = 5;
-		dirty = (dirty_ratio * available_memory) / 100;
-	}
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
 
 	if (dirty_background_bytes)
 		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
@@ -510,7 +504,7 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <
+		if (nr_reclaimable + nr_writeback <=
 				(background_thresh + dirty_thresh) / 2)
 			break;
 
@@ -542,8 +536,8 @@ static void balance_dirty_pages(struct a
 		 * the last resort safeguard.
 		 */
 		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
-			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
+			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
+			|| (nr_reclaimable + nr_writeback > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
--- linux-next.orig/fs/fs-writeback.c	2010-08-29 08:12:51.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-29 08:12:53.000000000 +0800
@@ -574,7 +574,7 @@ static inline bool over_bground_thresh(v
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
 }
 
 /*
