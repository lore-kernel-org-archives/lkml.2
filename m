Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320Ab2B1O6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:58:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:43154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab2B1O4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:56:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112219230"
Message-Id: <20120228144747.440418051@intel.com>
User-Agent: quilt/0.51-1
Date: Tue, 28 Feb 2012 22:00:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] mm: dont set __GFP_WRITE on ramfs/sysfs writes
References: <20120228140022.614718843@intel.com>
Content-Disposition: inline; filename=mm-__GFP_WRITE-cap_account_dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to avoid page reclaim waits when writing to ramfs/sysfs etc.

Maybe not a big deal...

CC: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/filemap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux.orig/mm/filemap.c	2012-02-28 10:24:12.000000000 +0800
+++ linux/mm/filemap.c	2012-02-28 10:25:55.568321275 +0800
@@ -2340,9 +2340,13 @@ struct page *grab_cache_page_write_begin
 	int status;
 	gfp_t gfp_mask;
 	struct page *page;
-	gfp_t lru_gfp_mask = GFP_KERNEL | __GFP_WRITE;
+	gfp_t lru_gfp_mask = GFP_KERNEL;
 
-	gfp_mask = mapping_gfp_mask(mapping) | __GFP_WRITE;
+	gfp_mask = mapping_gfp_mask(mapping);
+	if (mapping_cap_account_dirty(mapping)) {
+		gfp_mask |= __GFP_WRITE;
+		lru_gfp_mask |= __GFP_WRITE;
+	}
 	if (flags & AOP_FLAG_NOFS) {
 		gfp_mask &= ~__GFP_FS;
 		lru_gfp_mask &= ~__GFP_FS;


