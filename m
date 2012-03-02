Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2CBGKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:10:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:63578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab2CBGKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:10:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72657840"
Date: Fri, 2 Mar 2012 14:10:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: don't set __GFP_WRITE on ramfs/sysfs writes
Message-ID: <20120302061035.GA2344@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not much of a point in skipping zones during allocation based
on the dirty usage which they'll never contribute to. And we'd like to
avoid page reclaim waits when writing to ramfs/sysfs etc.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/mm/filemap.c	2012-03-02 14:06:47.000000000 +0800
+++ linux/mm/filemap.c	2012-03-02 14:07:21.325766507 +0800
@@ -2341,7 +2341,9 @@ struct page *grab_cache_page_write_begin
 	struct page *page;
 	gfp_t gfp_notmask = 0;
 
-	gfp_mask = mapping_gfp_mask(mapping) | __GFP_WRITE;
+	gfp_mask = mapping_gfp_mask(mapping);
+	if (mapping_cap_account_dirty(mapping))
+		gfp_mask |= __GFP_WRITE;
 	if (flags & AOP_FLAG_NOFS)
 		gfp_notmask = __GFP_FS;
 repeat:
