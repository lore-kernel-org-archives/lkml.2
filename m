Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1KUJlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:41:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:36114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1KUJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:40:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78317617"
Message-Id: <20111121093846.887841399@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 17:18:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] readahead: basic support for backwards prefetching
References: <20111121091819.394895091@intel.com>
Content-Disposition: inline; filename=readahead-backwards.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the backwards prefetching feature. It's pretty simple if we don't
support async prefetching and interleaved reads.

Here is the behavior with an 8-page read sequence from 10000 down to 0.
(The readahead size is a bit large since it's an NFS mount.)

readahead-random(dev=0:16, ino=3948605, req=10000+8, ra=10000+8-0, async=0) = 8
readahead-backwards(dev=0:16, ino=3948605, req=9992+8, ra=9968+32-0, async=0) = 32
readahead-backwards(dev=0:16, ino=3948605, req=9960+8, ra=9840+128-0, async=0) = 128
readahead-backwards(dev=0:16, ino=3948605, req=9832+8, ra=9584+256-0, async=0) = 256
readahead-backwards(dev=0:16, ino=3948605, req=9576+8, ra=9072+512-0, async=0) = 512
readahead-backwards(dev=0:16, ino=3948605, req=9064+8, ra=8048+1024-0, async=0) = 1024
readahead-backwards(dev=0:16, ino=3948605, req=8040+8, ra=6128+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=6120+8, ra=4208+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=4200+8, ra=2288+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=2280+8, ra=368+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=360+8, ra=0+368-0, async=0) = 368

And a simple 1-page read sequence from 10000 down to 0.

readahead-random(dev=0:16, ino=3948605, req=10000+1, ra=10000+1-0, async=0) = 1
readahead-backwards(dev=0:16, ino=3948605, req=9999+1, ra=9996+4-0, async=0) = 4
readahead-backwards(dev=0:16, ino=3948605, req=9995+1, ra=9980+16-0, async=0) = 16
readahead-backwards(dev=0:16, ino=3948605, req=9979+1, ra=9916+64-0, async=0) = 64
readahead-backwards(dev=0:16, ino=3948605, req=9915+1, ra=9660+256-0, async=0) = 256
readahead-backwards(dev=0:16, ino=3948605, req=9659+1, ra=9148+512-0, async=0) = 512
readahead-backwards(dev=0:16, ino=3948605, req=9147+1, ra=8124+1024-0, async=0) = 1024
readahead-backwards(dev=0:16, ino=3948605, req=8123+1, ra=6204+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=6203+1, ra=4284+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=4283+1, ra=2364+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=2363+1, ra=444+1920-0, async=0) = 1920
readahead-backwards(dev=0:16, ino=3948605, req=443+1, ra=0+444-0, async=0) = 444

CC: Andi Kleen <andi@firstfloor.org>
CC: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |    1 +
 mm/readahead.c     |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- linux-next.orig/include/linux/fs.h	2011-11-21 17:17:44.000000000 +0800
+++ linux-next/include/linux/fs.h	2011-11-21 17:17:47.000000000 +0800
@@ -964,6 +964,7 @@ enum readahead_pattern {
 	RA_PATTERN_SUBSEQUENT,
 	RA_PATTERN_CONTEXT,
 	RA_PATTERN_MMAP_AROUND,
+	RA_PATTERN_BACKWARDS,
 	RA_PATTERN_FADVISE,
 	RA_PATTERN_OVERSIZE,
 	RA_PATTERN_RANDOM,
--- linux-next.orig/mm/readahead.c	2011-11-21 17:17:45.000000000 +0800
+++ linux-next/mm/readahead.c	2011-11-21 17:17:47.000000000 +0800
@@ -23,6 +23,7 @@ static const char * const ra_pattern_nam
 	[RA_PATTERN_SUBSEQUENT]         = "subsequent",
 	[RA_PATTERN_CONTEXT]            = "context",
 	[RA_PATTERN_MMAP_AROUND]        = "around",
+	[RA_PATTERN_BACKWARDS]          = "backwards",
 	[RA_PATTERN_FADVISE]            = "fadvise",
 	[RA_PATTERN_OVERSIZE]           = "oversize",
 	[RA_PATTERN_RANDOM]             = "random",
@@ -686,6 +687,19 @@ ondemand_readahead(struct address_space 
 	}
 
 	/*
+	 * backwards reading
+	 */
+	if (offset < ra->start && offset + req_size >= ra->start) {
+		ra_set_pattern(ra, RA_PATTERN_BACKWARDS);
+		ra->size = get_next_ra_size(ra, max);
+		if (ra->size > ra->start)
+			ra->size = ra->start;
+		ra->async_size = 0;
+		ra->start -= ra->size;
+		goto readit;
+	}
+
+	/*
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */


