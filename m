Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0HWEn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:43:59 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:49895 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933Ab0HWEn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:43:57 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH] writeback: write_cache_pages doesn't terminate at nr_to_write <= 0
Date: Mon, 23 Aug 2010 14:43:40 +1000
Message-Id: <1282538620-10824-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

I noticed XFS writeback in 2.6.36-rc1 was much slower than it should have
been. Enabling writeback tracing showed:

    flush-253:16-8516  [007] 1342952.351608: wbc_writepage: bdi 253:16: towrt=1024 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [007] 1342952.351654: wbc_writepage: bdi 253:16: towrt=1023 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369520: wbc_writepage: bdi 253:16: towrt=0 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369542: wbc_writepage: bdi 253:16: towrt=-1 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369549: wbc_writepage: bdi 253:16: towrt=-2 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0

Writeback is not terminating in background writeback if ->writepage is
returning with wbc->nr_to_write == 0, resulting in sub-optimal single page
writeback on XFS.

Fix the write_cache_pages loop to terminate correctly when this situation
occurs and so prevent this sub-optimal background writeback pattern. This
improves sustained sequential buffered write performance from around
250MB/s to 750MB/s for a 100GB file on an XFS filesystem on my 8p test VM.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page-writeback.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7262aac..f069782 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -984,22 +984,16 @@ continue_unlock:
 				}
 			}
 
-			if (wbc->nr_to_write > 0) {
-				if (--wbc->nr_to_write == 0 &&
-				    wbc->sync_mode == WB_SYNC_NONE) {
-					/*
-					 * We stop writing back only if we are
-					 * not doing integrity sync. In case of
-					 * integrity sync we have to keep going
-					 * because someone may be concurrently
-					 * dirtying pages, and we might have
-					 * synced a lot of newly appeared dirty
-					 * pages, but have not synced all of the
-					 * old dirty pages.
-					 */
-					done = 1;
-					break;
-				}
+			/*
+			 * We stop writing back only if we are not doing
+			 * integrity sync. In case of integrity sync we have to
+			 * keep going until we have written all the pages
+			 * we tagged for writeback prior to entering this loop.
+			 */
+			if (--wbc->nr_to_write <= 0 &&
+			    wbc->sync_mode == WB_SYNC_NONE) {
+				done = 1;
+				break;
 			}
 		}
 		pagevec_release(&pvec);
-- 
1.7.1

