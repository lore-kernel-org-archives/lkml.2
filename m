Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0IRTOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:52 -0400
Received: from kroah.org ([198.145.64.141]:43195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab0IRTOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:48 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.374189339@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Chinner <dchinner@redhat.com>
Subject: [013/129] writeback: write_cache_pages doesnt terminate at nr_to_write <= 0
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 546a1924224078c6f582e68f890b05b387b42653 upstream.

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
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -949,22 +949,16 @@ continue_unlock:
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


