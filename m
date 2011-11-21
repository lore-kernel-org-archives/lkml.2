Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1KUJmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:42:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:63814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1KUJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:40:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="93515260"
Message-Id: <20111121093847.015852579@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 17:18:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 8/8] readahead: dont do start-of-file readahead after lseek()
References: <20111121091819.394895091@intel.com>
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
 fs/read_write.c    |    4 ++++
 include/linux/fs.h |    1 +
 mm/readahead.c     |    3 +++
 3 files changed, 8 insertions(+)

--- linux-next.orig/mm/readahead.c	2011-11-20 22:02:01.000000000 +0800
+++ linux-next/mm/readahead.c	2011-11-20 22:02:03.000000000 +0800
@@ -629,6 +629,8 @@ ondemand_readahead(struct address_space 
 	 * start of file
 	 */
 	if (!offset) {
+		if ((ra->ra_flags & READAHEAD_LSEEK) && req_size < max)
+			goto random_read;
 		ra_set_pattern(ra, RA_PATTERN_INITIAL);
 		goto initial_readahead;
 	}
@@ -707,6 +709,7 @@ ondemand_readahead(struct address_space 
 	if (try_context_readahead(mapping, ra, offset, req_size, max))
 		goto readit;
 
+random_read:
 	/*
 	 * standalone, small random read
 	 */
--- linux-next.orig/fs/read_write.c	2011-11-20 22:02:01.000000000 +0800
+++ linux-next/fs/read_write.c	2011-11-20 22:02:03.000000000 +0800
@@ -47,6 +47,10 @@ static loff_t lseek_execute(struct file 
 		file->f_pos = offset;
 		file->f_version = 0;
 	}
+
+	if (!(file->f_ra.ra_flags & READAHEAD_LSEEK))
+		file->f_ra.ra_flags |= READAHEAD_LSEEK;
+
 	return offset;
 }
 
--- linux-next.orig/include/linux/fs.h	2011-11-20 22:02:01.000000000 +0800
+++ linux-next/include/linux/fs.h	2011-11-20 22:02:03.000000000 +0800
@@ -952,6 +952,7 @@ struct file_ra_state {
 /* ra_flags bits */
 #define	READAHEAD_MMAP_MISS	0x000003ff /* cache misses for mmap access */
 #define	READAHEAD_MMAP		0x00010000
+#define	READAHEAD_LSEEK		0x00020000 /* be conservative after lseek() */
 
 #define READAHEAD_PATTERN_SHIFT	28
 #define READAHEAD_PATTERN	0xf0000000


