Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1KQMYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:24:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:38437 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab1KQMYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:24:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,526,1315206000"; 
   d="scan'208";a="76157212"
Date: Thu, 17 Nov 2011 20:24:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: lower the dirty balance poll interval
Message-ID: <20111117122403.GA32363@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests show that the original large intervals can easily make the dirty
limit exceeded on 100 concurrent dd's. So adapt to as large as the
next check point selected by the dirty throttling algorithm.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next.orig/fs/btrfs/file.c	2011-11-17 20:18:51.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-11-17 20:18:55.000000000 +0800
@@ -1168,6 +1168,8 @@ static noinline ssize_t __btrfs_buffered
 	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
+	nrptrs = min(nrptrs, current->nr_dirtied_pause - current->nr_dirtied);
+	nrptrs = max(nrptrs, 8);
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
