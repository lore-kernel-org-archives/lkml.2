Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0HEDMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:12:07 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:43056 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0HEDME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:12:04 -0400
Subject: [PATCH 2/2] PM: Compress hibernation image with LZO
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 13:12:01 +1000
Message-ID: <1280977921.2618.19.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that hibernation image is compressed, we need the data here and
now in order to decompress it, so a flag to read synchronously is
redundant (i.e. we always read synchronously).

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---

 kernel/power/power.h    |    4 ----
 kernel/power/snapshot.c |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 006270f..a760cf8 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -103,10 +103,6 @@ struct snapshot_handle {
 	void		*buffer;	/* address of the block to read from
 					 * or write to
 					 */
-	int		sync_read;	/* Set to one to notify the caller of
-					 * snapshot_write_next() that it may
-					 * need to call wait_on_bio_chain()
-					 */
 };
 
 /* This macro returns the address from/to which the caller of
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 25ce010..f24ee24 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2135,8 +2135,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
 
-	handle->sync_read = 1;
-
 	if (!handle->cur) {
 		if (!buffer)
 			/* This makes the buffer be freed by swsusp_free() */
@@ -2169,7 +2167,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
 			handle->buffer = get_buffer(&orig_bm, &ca);
-			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
 		}
@@ -2178,8 +2175,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
-		if (handle->buffer != buffer)
-			handle->sync_read = 0;
 	}
 	handle->cur++;
 	return PAGE_SIZE;


-- 
Bojan


