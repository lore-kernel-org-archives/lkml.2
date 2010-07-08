Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0GHM53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:57:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0GHM51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:57:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] scsi/i2o: restore ioctl changes
Date: Thu, 8 Jul 2010 14:57:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <201007072218.24013.arnd@arndb.de> <4C359200.8070105@kernel.dk>
In-Reply-To: <4C359200.8070105@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081457.03994.arnd@arndb.de>
X-Provags-ID: V02:K0:a8XG2HWb+wwQauSsSyVX9iYLKRGsDV6/Nfx3lZhU1uI
 3wTCTVy4qJRrYdP8uINQ0KpZLyjpoWmsYiBVqkhk8PBwOWGxaS
 r12/nBiRPAXjAIQUGGK0eENIWbolg0T+Q+rQzYO1lrrU/Kkvqk
 HFF8BHBJaiO6Q4WHFL1Uf1jak5LvQVT8IxK7nKgaDMg6bwDLKl
 OOaRXv9Rum4ALpY33Sa3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores the changes from "scsi/i2o_block: cleanup ioctl
handling", which accidentally got reverted.
    
Origignal changelog:
      This fixes the ioctl function of the i2o_block driver, which
      has multiple problems:
    
      * The BLKI2OSRSTRAT and BLKI2OSWSTRAT commands always return
        -ENOTTY on success, where they should return 0.
      * Support for 32 bit compat is missing
      * The driver should use the .ioctl function and because
        .locked_ioctl is going away.
    
      The use of the big kernel lock remains for now, but gets
      made explictit in the ioctl function.
    
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Jens, this is the commit that went missing due to my broken rebase.
Please either apply on top of you for-next branch or fold into
"block: push down BKL into .locked_ioctl", which reverted the change.

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index a5bc3ee..e6733bc 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -657,30 +657,40 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct i2o_block_device *dev = disk->private_data;
+	int ret = -ENOTTY;
 
 	/* Anyone capable of this syscall can do *real bad* things */
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	lock_kernel();
 	switch (cmd) {
 	case BLKI2OGRSTRAT:
-		return put_user(dev->rcache, (int __user *)arg);
+		ret = put_user(dev->rcache, (int __user *)arg);
+		break;
 	case BLKI2OGWSTRAT:
-		return put_user(dev->wcache, (int __user *)arg);
+		ret = put_user(dev->wcache, (int __user *)arg);
+		break;
 	case BLKI2OSRSTRAT:
+		ret = -EINVAL;
 		if (arg < 0 || arg > CACHE_SMARTFETCH)
-			return -EINVAL;
+			break;
 		dev->rcache = arg;
+		ret = 0;
 		break;
 	case BLKI2OSWSTRAT:
+		ret = -EINVAL;
 		if (arg != 0
 		    && (arg < CACHE_WRITETHROUGH || arg > CACHE_SMARTBACK))
-			return -EINVAL;
+			break;
 		dev->wcache = arg;
+		ret = 0;
 		break;
 	}
-	return -ENOTTY;
+	unlock_kernel();
+
+	return ret;
 };
 
 /**
@@ -936,6 +946,7 @@ static const struct block_device_operations i2o_block_fops = {
 	.open = i2o_block_open,
 	.release = i2o_block_release,
 	.ioctl = i2o_block_ioctl,
+	.compat_ioctl = i2o_block_ioctl,
 	.getgeo = i2o_block_getgeo,
 	.media_changed = i2o_block_media_changed
 };
