Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0LMG6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:58:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:35379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab0LMGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="360754652"
Message-Id: <20101213064839.291896969@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:08 +0800
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
Subject: [PATCH 19/47] writeback: fix increasement of nr_dirtied_pause
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-fix-increase-nr_dirtied_pause.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug that

	current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;

does not effectively increase nr_dirtied_pause when it's less than 32.
Thus nr_dirtied_pause may never grow up.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:27.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
@@ -700,7 +700,7 @@ pause:
 	if (pause == 0 && nr_dirty < background_thresh)
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
 	else if (pause == 1)
-		current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;
+		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
 	else if (pause >= HZ/10)
 		/*
 		 * when repeated, writing 1 page per 100ms on slow devices,


