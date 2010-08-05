Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab0HEQdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:33:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:35560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760367Ab0HEQ3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="644977062"
Message-Id: <20100805162433.673243074@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:10:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 07/13] writeback: explicit low bound for vm.dirty_ratio
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=min-dirty-ratio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force a user visible low bound of 5% for the vm.dirty_ratio interface.

Currently global_dirty_limits() applies a low bound of 5% for
vm_dirty_ratio.  This is not very user visible -- if the user sets
vm.dirty_ratio=1, the operation seems to succeed but will be rounded up
to 5% when used.

Another problem is inconsistency: calc_period_shift() uses the plain
vm_dirty_ratio value, which may be a problem when vm.dirty_ratio is set
to < 5 by the user.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/sysctl.c     |    3 ++-
 mm/page-writeback.c |   10 ++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

--- linux-next.orig/kernel/sysctl.c	2010-08-05 22:48:34.000000000 +0800
+++ linux-next/kernel/sysctl.c	2010-08-05 22:48:47.000000000 +0800
@@ -126,6 +126,7 @@ static int ten_thousand = 10000;
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
+static int dirty_ratio_min = 5;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -1031,7 +1032,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(vm_dirty_ratio),
 		.mode		= 0644,
 		.proc_handler	= dirty_ratio_handler,
-		.extra1		= &zero,
+		.extra1		= &dirty_ratio_min,
 		.extra2		= &one_hundred,
 	},
 	{
--- linux-next.orig/mm/page-writeback.c	2010-08-05 22:48:42.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-08-05 22:48:47.000000000 +0800
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


