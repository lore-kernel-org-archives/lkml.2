Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2ECDnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:43:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:30606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab2ECDnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148757558"
Date: Thu, 3 May 2012 11:43:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH] btrfs: lower metadata writeback threshold on low dirty
 threshold
Message-ID: <20120503034311.GA14081@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
 <20120412142634.GA16559@quack.suse.cz>
 <20120413014026.GA9027@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413014026.GA9027@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps write performance when setting the dirty threshold to tiny numbers.

     3.4.0-rc2         3.4.0-rc2-btrfs4+
  ------------  ------------------------
         96.92        -0.4%        96.54  bay/thresh=1000M/btrfs-100dd-1-3.4.0-rc2
         98.47        +0.0%        98.50  bay/thresh=1000M/btrfs-10dd-1-3.4.0-rc2
         99.38        -0.3%        99.06  bay/thresh=1000M/btrfs-1dd-1-3.4.0-rc2
         98.04        -0.0%        98.02  bay/thresh=100M/btrfs-100dd-1-3.4.0-rc2
         98.68        +0.3%        98.98  bay/thresh=100M/btrfs-10dd-1-3.4.0-rc2
         99.34        -0.0%        99.31  bay/thresh=100M/btrfs-1dd-1-3.4.0-rc2
  ==>    88.98        +9.6%        97.53  bay/thresh=10M/btrfs-10dd-1-3.4.0-rc2
  ==>    86.99       +13.1%        98.39  bay/thresh=10M/btrfs-1dd-1-3.4.0-rc2
  ==>     2.75     +2442.4%        69.88  bay/thresh=1M/btrfs-10dd-1-3.4.0-rc2
  ==>     3.31     +2634.1%        90.54  bay/thresh=1M/btrfs-1dd-1-3.4.0-rc2

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/fs/btrfs/disk-io.c	2012-05-02 14:04:00.989262395 +0800
+++ linux-next/fs/btrfs/disk-io.c	2012-05-02 14:04:01.773262414 +0800
@@ -930,7 +930,8 @@ static int btree_writepages(struct addre
 
 		/* this is a bit racy, but that's ok */
 		num_dirty = root->fs_info->dirty_metadata_bytes;
-		if (num_dirty < thresh)
+		if (num_dirty < min(thresh,
+				    global_dirty_limit << (PAGE_CACHE_SHIFT-2)))
 			return 0;
 	}
 	return btree_write_cache_pages(mapping, wbc);
