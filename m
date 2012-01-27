Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2A0DlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:41:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:41153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab2A0Dki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:40:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100232696"
Message-Id: <20120127031326.881533433@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 11:05:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] readahead: tag metadata call sites
References: <20120127030524.854259561@intel.com>
Content-Disposition: inline; filename=readahead-for-metadata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may be doing more metadata readahead in future.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext3/dir.c      |    1 +
 fs/ext4/dir.c      |    1 +
 include/linux/fs.h |    1 +
 mm/readahead.c     |    1 +
 4 files changed, 4 insertions(+)

--- linux-next.orig/fs/ext3/dir.c	2012-01-25 15:57:46.000000000 +0800
+++ linux-next/fs/ext3/dir.c	2012-01-25 15:57:52.000000000 +0800
@@ -136,6 +136,7 @@ static int ext3_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
+				filp->f_ra.for_metadata = 1;
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
--- linux-next.orig/fs/ext4/dir.c	2012-01-25 15:57:46.000000000 +0800
+++ linux-next/fs/ext4/dir.c	2012-01-25 15:57:52.000000000 +0800
@@ -153,6 +153,7 @@ static int ext4_readdir(struct file *fil
 			pgoff_t index = map.m_pblk >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
+				filp->f_ra.for_metadata = 1;
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
--- linux-next.orig/include/linux/fs.h	2012-01-25 15:57:51.000000000 +0800
+++ linux-next/include/linux/fs.h	2012-01-25 15:57:52.000000000 +0800
@@ -955,6 +955,7 @@ struct file_ra_state {
 	u16 mmap_miss;			/* Cache miss stat for mmap accesses */
 	u8 pattern;			/* one of RA_PATTERN_* */
 	unsigned int for_mmap:1;	/* readahead for mmap accesses */
+	unsigned int for_metadata:1;	/* readahead for meta data */
 
 	loff_t prev_pos;		/* Cache last read() position */
 };
--- linux-next.orig/mm/readahead.c	2012-01-25 15:57:51.000000000 +0800
+++ linux-next/mm/readahead.c	2012-01-25 15:57:52.000000000 +0800
@@ -260,6 +260,7 @@ unsigned long ra_submit(struct file_ra_s
 					ra->start, ra->size, ra->async_size);
 
 	ra->for_mmap = 0;
+	ra->for_metadata = 0;
 	return actual;
 }
 


