Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1H3JHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:07:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38223 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3JF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/15] drbd: silence some log messages on bitmap IO
Date: Tue, 30 Aug 2011 11:05:48 +0200
Message-Id: <1314695149-387-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Summary log messages meant for global bitmap IO
should not be printed for bitmap IO caused by
activity log transactions.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_bitmap.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 2d00a8f..2fc3dfa 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1090,9 +1090,12 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
 	 */
 	if (!atomic_dec_and_test(&ctx.in_flight))
 		wait_for_completion(&ctx.done);
-	dev_info(DEV, "bitmap %s of %u pages took %lu jiffies\n",
-			rw == WRITE ? "WRITE" : "READ",
-			count, jiffies - now);
+
+	/* summary for global bitmap IO */
+	if (flags == 0)
+		dev_info(DEV, "bitmap %s of %u pages took %lu jiffies\n",
+				rw == WRITE ? "WRITE" : "READ",
+				count, jiffies - now);
 
 	if (ctx.error) {
 		dev_alert(DEV, "we had at least one MD IO ERROR during bitmap IO\n");
@@ -1110,8 +1113,9 @@ static int bm_rw(struct drbd_conf *mdev, int rw, unsigned flags, unsigned lazy_w
 	}
 	now = b->bm_set;
 
-	dev_info(DEV, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
-	     ppsize(ppb, now << (BM_BLOCK_SHIFT-10)), now);
+	if (flags == 0)
+		dev_info(DEV, "%s (%lu bits) marked out-of-sync by on disk bit-map.\n",
+		     ppsize(ppb, now << (BM_BLOCK_SHIFT-10)), now);
 
 	return err;
 }
-- 
1.7.4.1

