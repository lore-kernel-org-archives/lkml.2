Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1EDJ2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:28:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:4162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab1EDJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="687915499"
Message-Id: <20110504091909.520602641@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 17:17:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/6] writeback: make nr_to_write a per-file limit
References: <20110504091707.910929441@intel.com>
Content-Disposition: inline; filename=writeback-single-file-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures large dirty files can be written in the full 4MB writeback
chunk size, rather than whatever remained quota in wbc->nr_to_write.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   11 +++++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 12 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2011-05-04 16:00:45.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-04 16:01:00.000000000 +0800
@@ -346,6 +346,8 @@ writeback_single_inode(struct inode *ino
 		       struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
+	long per_file_limit = wbc->per_file_limit;
+	long uninitialized_var(nr_to_write);
 	unsigned dirty;
 	int ret;
 
@@ -385,8 +387,16 @@ writeback_single_inode(struct inode *ino
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 
+	if (per_file_limit) {
+		nr_to_write = wbc->nr_to_write;
+		wbc->nr_to_write = per_file_limit;
+	}
+
 	ret = do_writepages(mapping, wbc);
 
+	if (per_file_limit)
+		wbc->nr_to_write += nr_to_write - per_file_limit;
+
 	/*
 	 * Make sure to wait on the data before writing out the metadata.
 	 * This is important for filesystems that modify metadata on data
@@ -710,6 +720,7 @@ static long wb_writeback(struct bdi_writ
 
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
+		wbc.per_file_limit = write_chunk;
 		wbc.pages_skipped = 0;
 		wbc.inodes_cleaned = 0;
 
--- linux-next.orig/include/linux/writeback.h	2011-05-04 16:00:45.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-04 16:01:00.000000000 +0800
@@ -28,6 +28,7 @@ struct writeback_control {
 					   older than this */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
+	long per_file_limit;		/* Write this many pages for one file */
 	long pages_skipped;		/* Pages which were not written */
 	long inodes_cleaned;		/* # of inodes cleaned */
 


