Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2EHI0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:26:54 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2EHI0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:26:52 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, peterz@infradead.org
Subject: [PATCH] UBI: Replace yield() with cond_resched()
Date: Tue,  8 May 2012 10:26:42 +0200
Message-Id: <1336465602-12627-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above yield()'s definition says:
 * If you want to use yield() to wait for something, use wait_event().
 * If you want to use yield() to be 'nice' for others, use cond_resched().
 * If you still want to use yield(), do not!

The yield() usage of UBI really looks like the "be nice for others" case,
so use cond_resched().

Signed-off-by: Richard Weinberger <richard@nod.at>
CC: peterz@infradead.org
---
 drivers/mtd/ubi/io.c |    6 +++---
 drivers/mtd/ubi/wl.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 43f1a00..a125ef6 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -192,7 +192,7 @@ retry:
 			dbg_io("error %d%s while reading %d bytes from PEB "
 			       "%d:%d, read only %zd bytes, retry",
 			       err, errstr, len, pnum, offset, read);
-			yield();
+			cond_resched();
 			goto retry;
 		}
 
@@ -366,7 +366,7 @@ retry:
 		if (retries++ < UBI_IO_RETRIES) {
 			dbg_io("error %d while erasing PEB %d, retry",
 			       err, pnum);
-			yield();
+			cond_resched();
 			goto retry;
 		}
 		ubi_err("cannot erase PEB %d, error %d", pnum, err);
@@ -384,7 +384,7 @@ retry:
 	if (ei.state == MTD_ERASE_FAILED) {
 		if (retries++ < UBI_IO_RETRIES) {
 			dbg_io("error while erasing PEB %d, retry", pnum);
-			yield();
+			cond_resched();
 			goto retry;
 		}
 		ubi_err("cannot erase PEB %d", pnum);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7c1a9bf..f2f9056 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1243,7 +1243,7 @@ retry:
 		 */
 		spin_unlock(&ubi->wl_lock);
 		dbg_wl("the PEB %d is not in proper tree, retry", pnum);
-		yield();
+		cond_resched();
 		goto retry;
 	}
 
-- 
1.7.6.4

