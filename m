Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0LWByF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:54:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54303 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0LWByD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:54:03 -0500
Date: Thu, 23 Dec 2010 12:53:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20101223125356.9ce57329.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/target/target_core_iblock.c: In function 'iblock_create_virtdevice':
drivers/target/target_core_iblock.c:155: error: implicit declaration of function 'open_bdev_exclusive'
drivers/target/target_core_iblock.c:156: warning: assignment makes pointer from integer without a cast
drivers/target/target_core_iblock.c: In function 'iblock_free_device':
drivers/target/target_core_iblock.c:223: error: implicit declaration of function 'close_bdev_exclusive'
drivers/target/target_core_pscsi.c: In function 'pscsi_create_type_disk':
drivers/target/target_core_pscsi.c:463: error: implicit declaration of function 'open_bdev_exclusive'
drivers/target/target_core_pscsi.c:464: warning: assignment makes pointer from integer without a cast
drivers/target/target_core_pscsi.c:474: error: implicit declaration of function 'close_bdev_exclusive'

Caused by commit 759026ddf4bdcfc68d1d330c7a5a9aee026a77c3 ("[SCSI]
target: Add LIO target core v4.0.0-rc6") from the scsi tree interacting
with commits e525fd89d380c4a94c0d63913a1dd1a593ed25e7 ("block: make
blkdev_get/put() handle exclusive access") and
d4d77629953eabd3c14f6fa5746f6b28babfc55f ("block: clean up blkdev_get()
wrappers and their users") from the block tree.

We have better ways of deprecating/replacing interfaces ...

I have added the following fix up patch for today ... and can carry it as
necessary, though someone needs to remember to tell Linus when the latter
of the block and scsi trees get merged.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 23 Dec 2010 12:34:11 +1100
Subject: [PATCH] scsi: fix for open/close_bdev_exclusive going away

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/target/target_core_iblock.c |    6 +++---
 drivers/target/target_core_pscsi.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e99bfc2..0d55188 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -152,8 +152,8 @@ static struct se_device *iblock_create_virtdevice(
 	printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %s\n",
 			ib_dev->ibd_udev_path);
 
-	bd = open_bdev_exclusive(ib_dev->ibd_udev_path,
-			FMODE_WRITE|FMODE_READ, ib_dev);
+	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
+			FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
 	if (!(bd))
 		goto failed;
 	/*
@@ -220,7 +220,7 @@ static void iblock_free_device(void *p)
 {
 	struct iblock_dev *ib_dev = p;
 
-	close_bdev_exclusive(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ);
+	blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 	bioset_free(ib_dev->ibd_bio_set);
 	kfree(ib_dev);
 }
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6a7495b..05924d1 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -460,10 +460,10 @@ static struct se_device *pscsi_create_type_disk(
 	 * Claim exclusive struct block_device access to struct scsi_device
 	 * for TYPE_DISK using supplied udev_path
 	 */
-	bd = open_bdev_exclusive(se_dev->se_dev_udev_path,
-				FMODE_WRITE|FMODE_READ, pdv);
+	bd = blkdev_get_by_path(se_dev->se_dev_udev_path,
+				FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
 	if (!(bd)) {
-		printk("pSCSI: open_bdev_exclusive() failed\n");
+		printk("pSCSI: blkdev_get_by_path() failed\n");
 		scsi_device_put(sd);
 		return NULL;
 	}
@@ -471,7 +471,7 @@ static struct se_device *pscsi_create_type_disk(
 
 	dev = pscsi_add_device_to_list(hba, se_dev, pdv, sd, dev_flags);
 	if (!(dev)) {
-		close_bdev_exclusive(pdv->pdv_bd, FMODE_WRITE|FMODE_READ);
+		blkdev_put(pdv->pdv_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 		scsi_device_put(sd);
 		return NULL;
 	}
@@ -680,8 +680,8 @@ static void pscsi_free_device(void *p)
 		 * struct scsi_device with TYPE_DISK from pscsi_create_type_disk()
 		 */
 		if ((sd->type == TYPE_DISK) && pdv->pdv_bd) {
-			close_bdev_exclusive(pdv->pdv_bd,
-					FMODE_WRITE|FMODE_READ);
+			blkdev_put(pdv->pdv_bd,
+					FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 			pdv->pdv_bd = NULL;
 		}
 		/*

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
