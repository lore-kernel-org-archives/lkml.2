Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1LMC3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:29:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:53321 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1LMC3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85015808"
Date: Tue, 13 Dec 2011 10:19:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] writeback: do strict bdi dirty_exceeded
Message-ID: <20111213021913.GB14660@localhost>
References: <20111213021633.GA14193@localhost>
 <20111213021740.GA14660@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213021740.GA14660@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps to reduce dirty throttling polls and hence CPU overheads.

bdi->dirty_exceeded typically only helps when suddenly starting 100+
dd's on a disk, in which case the dd's may need to poll
balance_dirty_pages() earlier than tsk->nr_dirtied_pause.

CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2011-12-04 12:03:06.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-04 12:03:07.000000000 +0800
@@ -1097,7 +1097,7 @@ static void balance_dirty_pages(struct a
 				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
-		dirty_exceeded = (bdi_dirty > bdi_thresh) ||
+		dirty_exceeded = (bdi_dirty > bdi_thresh) &&
 				  (nr_dirty > dirty_thresh);
 		if (dirty_exceeded && !bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
