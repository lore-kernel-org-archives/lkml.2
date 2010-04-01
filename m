Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0DASb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:31:58 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42383 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab0DASbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:31:53 -0400
Date: Thu, 1 Apr 2010 20:31:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: fengguang.wu@intel.com
Subject: [PATCH] readahead even for FMODE_RANDOM
Message-ID: <20100401183151.GO23510@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a problem report with fio where larger block size random reads
where markedly slower with buffered IO than with O_DIRECT, and the
initial thought was that perhaps this was some fio oddity. The reporter
eventually discovered that turning off the fadvise hint made it work
fine. So I took a look, and it seems we never do readahead for
FMODE_RANDOM even if the request size is larger than 1 page. That seems
like a bug, if an application is doing eg 16kb random reads, you want to
readahead the 12kb remaining data. On devices where smaller transfer
sizes are slower than larger ones, this can make a large difference.

This patch makes us readahead even for FMODE_RANDOM, iff we'll be
reading more pages in that single read. I ran a quick test here, and it
appears to fix the problem (no difference with fadvise POSIX_FADV_RANDOM
being passed in or not).

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/mm/readahead.c b/mm/readahead.c
index 337b20e..d4b201c 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -501,8 +501,11 @@ void page_cache_sync_readahead(struct address_space *mapping,
 	if (!ra->ra_pages)
 		return;
 
-	/* be dumb */
-	if (filp->f_mode & FMODE_RANDOM) {
+	/*
+	 * Be dumb for files marked as randomly accessed, but do readahead
+	 * inside the original request (req_size > 1).
+	 */
+	if ((filp->f_mode & FMODE_RANDOM) && req_size == 1) {
 		force_page_cache_readahead(mapping, filp, offset, req_size);
 		return;
 	}

-- 
Jens Axboe

