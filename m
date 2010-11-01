Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab0KAQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:16:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:46833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab0KAQQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:16:55 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: Tejun Heo <tj@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
Date: Mon,  1 Nov 2010 17:15:25 +0100
Message-Id: <1288628129-12811-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 16:15:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two bdev exclusive open bugs.

* open_bdev_exclusive() must not be called with NULL holder.  Use dev
  as the holder.

* open_by_devnum() doesn't open the bdev exclusively but
  block2mtd_free_device() always assumes it.  Explicitly claim the
  bdev.

The latter is rather clumsy but will be simplified with future
blkdev_get/put() cleanups.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/block2mtd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 2cf0cc6..806a9ed 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -246,7 +246,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		return NULL;
 
 	/* Get a handle on the device */
-	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, NULL);
+	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, dev);
 #ifndef MODULE
 	if (IS_ERR(bdev)) {
 
@@ -256,6 +256,15 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		dev_t devt = name_to_dev_t(devname);
 		if (devt) {
 			bdev = open_by_devnum(devt, FMODE_WRITE | FMODE_READ);
+			if (!IS_ERR(bdev)) {
+				int ret;
+				ret = bd_claim(bdev, dev);
+				if (ret) {
+					blkdev_put(bdev,
+						   FMODE_READ | FMODE_WRITE);
+					bdev = ERR_PTR(ret);
+				}
+			}
 		}
 	}
 #endif
-- 
1.7.1

