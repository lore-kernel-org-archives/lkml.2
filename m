Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0LMPOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:14:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:60850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab0LMPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="583219906"
Message-Id: <20101213150328.526742344@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/35] writeback: start background writeback earlier
References: <20101213144646.341970461@intel.com>
Content-Disposition: inline; filename=writeback-kick-background-early.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for some one to suddenly eat lots of memory,
leading to sudden drop of global dirty limit. So a dirtier
task may get hard throttled immediately without some previous
balance_dirty_pages() call to invoke background writeback.

In this case we need to check for background writeback earlier in the
loop to avoid stucking the application for very long time. This was not
a problem before the IO-less balance_dirty_pages() because it will try
to write something and then break out of the loop regardless of the
global limit.

Another scheme this check will help is, the dirty limit is too close to
the background threshold, so that someone manages to jump directly into
the pause threshold (background+dirty)/2.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-13 21:46:17.000000000 +0800
@@ -748,6 +748,9 @@ static void balance_dirty_pages(struct a
 				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
+		if (unlikely(!writeback_in_progress(bdi)))
+			bdi_start_background_writeback(bdi);
+
 		bdi_update_bandwidth(bdi, start_time, bdi_dirty, bdi_thresh);
 
 		/*


