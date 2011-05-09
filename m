Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1EIVot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47272
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751360Ab1EIVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:42 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 002/206] Staging: hv: Cleanup spin lock usage
Date: Mon,  9 May 2011 14:54:44 -0700
Message-Id: <1304978288-22999-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This spin lock is potentially acquired from interrupt context.
Ensure that the interrupts are blocked whenever the lock is held.
The current code was not consistent with regards to blocking
interrupts - the same lock would be acquired without blocking
interrupts in some instance while the interrupts would be blocked
in other instances. Fix this potential deadlock problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index cfef1c0..74d51bb 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -249,12 +249,13 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
+	unsigned long flags;
 
-	spin_lock(&blkdev->lock);
+	spin_lock_irqsave(&blkdev->lock, flags);
 
 	blkdev->users++;
 
-	spin_unlock(&blkdev->lock);
+	spin_unlock_irqrestore(&blkdev->lock, flags);
 
 	return 0;
 }
@@ -616,17 +617,18 @@ static void blkvsc_shutdown(struct hv_device *dev)
 static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device_context *blkdev = disk->private_data;
+	unsigned long flags;
 
-	spin_lock(&blkdev->lock);
+	spin_lock_irqsave(&blkdev->lock, flags);
 	if (blkdev->users == 1) {
-		spin_unlock(&blkdev->lock);
+		spin_unlock_irqrestore(&blkdev->lock, flags);
 		blkvsc_do_operation(blkdev, DO_FLUSH);
-		spin_lock(&blkdev->lock);
+		spin_lock_irqsave(&blkdev->lock, flags);
 	}
 
 	blkdev->users--;
 
-	spin_unlock(&blkdev->lock);
+	spin_unlock_irqrestore(&blkdev->lock, flags);
 	return 0;
 }
 
-- 
1.7.4.1

