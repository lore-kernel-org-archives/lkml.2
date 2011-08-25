Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1HYPdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32955 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1HYPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 024/118] drbd: Remove some useless paranoia code
Date: Thu, 25 Aug 2011 17:07:20 +0200
Message-Id: <1314284934-17999-25-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The open_cnt check is an open-coded D_ASSERT() check.

In case the data.work queue is not empty, it does not really help to
know which drbd_work elements remained on that list: they will be freed
immediately afterwards, anyway.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 46ba4aa..2902f6d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3254,16 +3254,8 @@ static void drbd_delete_device(unsigned int minor)
 		return;
 
 	/* paranoia asserts */
-	if (mdev->open_cnt != 0)
-		dev_err(DEV, "open_cnt = %d in %s:%u", mdev->open_cnt,
-				__FILE__ , __LINE__);
-
-	if (!expect(list_empty(&mdev->data.work.q))) {
-		struct list_head *lp;
-		list_for_each(lp, &mdev->data.work.q) {
-			dev_err(DEV, "lp = %p\n", lp);
-		}
-	};
+	D_ASSERT(mdev->open_cnt == 0);
+	D_ASSERT(list_empty(&mdev->data.work.q));
 	/* end paranoia asserts */
 
 	del_gendisk(mdev->vdisk);
-- 
1.7.4.1

