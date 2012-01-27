Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2A0DlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:41:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:48949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2A0Dki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:40:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100232698"
Message-Id: <20120127031327.430238053@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 11:05:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] readahead: dont do start-of-file readahead after lseek()
References: <20120127030524.854259561@intel.com>
Content-Disposition: inline; filename=readahead-lseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications (eg. blkid, id3tool etc.) seek around the file
to get information. For example, blkid does

	     seek to	0
	     read	1024
	     seek to	1536
	     read	16384

The start-of-file readahead heuristic is wrong for them, whose
access pattern can be identified by lseek() calls.

So test-and-set a READAHEAD_LSEEK flag on lseek() and don't
do start-of-file readahead on seeing it. Proposed by Linus.

Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/read_write.c    |    3 +++
 include/linux/fs.h |    1 +
 mm/readahead.c     |    4 ++++
 3 files changed, 8 insertions(+)

--- linux-next.orig/mm/readahead.c	2012-01-25 15:57:57.000000000 +0800
+++ linux-next/mm/readahead.c	2012-01-25 15:57:58.000000000 +0800
@@ -485,6 +485,7 @@ unsigned long ra_submit(struct file_ra_s
 			ra->pattern, ra->start, ra->size, ra->async_size,
 			actual);
 
+	ra->lseek = 0;
 	ra->for_mmap = 0;
 	ra->for_metadata = 0;
 	return actual;
@@ -636,6 +637,8 @@ ondemand_readahead(struct address_space 
 	 * start of file
 	 */
 	if (!offset) {
+		if (ra->lseek && req_size < max)
+			goto random_read;
 		ra->pattern = RA_PATTERN_INITIAL;
 		goto initial_readahead;
 	}
@@ -721,6 +724,7 @@ ondemand_readahead(struct address_space 
 	if (try_context_readahead(mapping, ra, offset, req_size, max))
 		goto readit;
 
+random_read:
 	/*
 	 * standalone, small random read
 	 */
--- linux-next.orig/fs/read_write.c	2012-01-25 15:57:46.000000000 +0800
+++ linux-next/fs/read_write.c	2012-01-25 15:57:58.000000000 +0800
@@ -47,6 +47,9 @@ static loff_t lseek_execute(struct file 
 		file->f_pos = offset;
 		file->f_version = 0;
 	}
+
+	file->f_ra.lseek = 1;
+
 	return offset;
 }
 
--- linux-next.orig/include/linux/fs.h	2012-01-25 15:57:57.000000000 +0800
+++ linux-next/include/linux/fs.h	2012-01-25 15:57:58.000000000 +0800
@@ -956,6 +956,7 @@ struct file_ra_state {
 	u8 pattern;			/* one of RA_PATTERN_* */
 	unsigned int for_mmap:1;	/* readahead for mmap accesses */
 	unsigned int for_metadata:1;	/* readahead for meta data */
+	unsigned int lseek:1;		/* this read has a leading lseek */
 
 	loff_t prev_pos;		/* Cache last read() position */
 };


