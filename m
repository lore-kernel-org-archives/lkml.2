Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0DGJwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:52:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0DGJwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:52:39 -0400
Message-ID: <4BBC55DD.2010201@kernel.org>
Date: Wed, 07 Apr 2010 18:52:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Matthias-Christian Ott <ott@mirix.org>
Subject: [PATCH 1/2] block: factor out bd_may_claim()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Apr 2010 09:52:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out bd_may_claim() from bd_claim(), add comments and apply a
couple of cosmetic edits.  This is to prepare for further updates to
claim path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Jens, these two patches fix a subtle problem in block device open path
where O_EXCL open attempts can interfere with an already exclusively
open device.

These definitely are not for this merge window and need to get good
amount testing in linux-next.

Thanks.

 fs/block_dev.c |   65 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 18 deletions(-)

Index: work/fs/block_dev.c
===================================================================
--- work.orig/fs/block_dev.c
+++ work/fs/block_dev.c
@@ -660,41 +660,70 @@ void bd_forget(struct inode *inode)
 		iput(bdev->bd_inode);
 }

-int bd_claim(struct block_device *bdev, void *holder)
+/**
+ * bd_may_claim - test whether a block device can be claimed
+ * @bdev: block device of interest
+ * @whole: whole block device containing @bdev, may equal @bdev
+ * @holder: holder trying to claim @bdev
+ *
+ * Test whther @bdev can be claimed by @holder.
+ *
+ * CONTEXT:
+ * spin_lock(&bdev_lock).
+ *
+ * RETURNS:
+ * %true if @bdev can be claimed, %false otherwise.
+ */
+static bool bd_may_claim(struct block_device *bdev, struct block_device *whole,
+			 void *holder)
 {
-	int res;
-	spin_lock(&bdev_lock);
-
-	/* first decide result */
 	if (bdev->bd_holder == holder)
-		res = 0;	 /* already a holder */
+		return true;	 /* already a holder */
 	else if (bdev->bd_holder != NULL)
-		res = -EBUSY; 	 /* held by someone else */
+		return false; 	 /* held by someone else */
 	else if (bdev->bd_contains == bdev)
-		res = 0;  	 /* is a whole device which isn't held */
+		return true;  	 /* is a whole device which isn't held */

-	else if (bdev->bd_contains->bd_holder == bd_claim)
-		res = 0; 	 /* is a partition of a device that is being partitioned */
-	else if (bdev->bd_contains->bd_holder != NULL)
-		res = -EBUSY;	 /* is a partition of a held device */
+	else if (whole->bd_holder == bd_claim)
+		return true; 	 /* is a partition of a device that is being partitioned */
+	else if (whole->bd_holder != NULL)
+		return false;	 /* is a partition of a held device */
 	else
-		res = 0;	 /* is a partition of an un-held device */
+		return true;	 /* is a partition of an un-held device */
+}

-	/* now impose change */
-	if (res==0) {
+/**
+ * bd_claim - claim a block device
+ * @bdev: block device to claim
+ * @holder: holder trying to claim @bdev
+ *
+ * Try to claim @bdev.
+ *
+ * RETURNS:
+ * 0 if successful, -EBUSY if @bdev is already claimed.
+ */
+int bd_claim(struct block_device *bdev, void *holder)
+{
+	struct block_device *whole = bdev->bd_contains;
+	int res = -EBUSY;
+
+	spin_lock(&bdev_lock);
+
+	if (bd_may_claim(bdev, whole, holder)) {
 		/* note that for a whole device bd_holders
 		 * will be incremented twice, and bd_holder will
 		 * be set to bd_claim before being set to holder
 		 */
-		bdev->bd_contains->bd_holders ++;
-		bdev->bd_contains->bd_holder = bd_claim;
+		whole->bd_holders++;
+		whole->bd_holder = bd_claim;
 		bdev->bd_holders++;
 		bdev->bd_holder = holder;
+		res = 0;
 	}
+
 	spin_unlock(&bdev_lock);
 	return res;
 }
-
 EXPORT_SYMBOL(bd_claim);

 void bd_release(struct block_device *bdev)
