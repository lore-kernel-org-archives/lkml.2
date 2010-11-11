Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0KKRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:11:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:49403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab0KKRLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:11:36 -0500
Message-ID: <4CDC2379.3050505@kernel.org>
Date: Thu, 11 Nov 2010 18:10:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        dbrownell@users.sourceforge.net
Subject: [PATCH 6/5] block: check bdev_read_only() from blkdev_get()
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 17:10:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdev read-only status can be queried using bdev_read_only() and may
change while the device is being opened.  Enforce it by checking it
from blkdev_get() after open succeeds.

This makes bdev_read_only() check in open_bdev_exclusive() and
fsg_lun_open() unnecessary.  Drop them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/storage_common.c |    7 ++-----
 fs/block_dev.c                      |   11 ++++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 3b513ba..b015561 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -543,7 +543,7 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	ro = curlun->initially_ro;
 	if (!ro) {
 		filp = filp_open(filename, O_RDWR | O_LARGEFILE, 0);
-		if (-EROFS == PTR_ERR(filp))
+		if (PTR_ERR(filp) == -EROFS || PTR_ERR(filp) == -EACCES)
 			ro = 1;
 	}
 	if (ro)
@@ -558,10 +558,7 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)

 	if (filp->f_path.dentry)
 		inode = filp->f_path.dentry->d_inode;
-	if (inode && S_ISBLK(inode->i_mode)) {
-		if (bdev_read_only(inode->i_bdev))
-			ro = 1;
-	} else if (!inode || !S_ISREG(inode->i_mode)) {
+	if (!inode || (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))) {
 		LINFO(curlun, "invalid file type: %s\n", filename);
 		goto out;
 	}
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 269bfbb..606a525 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1149,6 +1149,12 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)

 	res = __blkdev_get(bdev, mode, 0);

+	/* __blkdev_get() may alter read only status, check it afterwards */
+	if (!res && (mode & FMODE_WRITE) && bdev_read_only(bdev)) {
+		__blkdev_put(bdev, mode, 0);
+		res = -EACCES;
+	}
+
 	if (whole) {
 		/* finish claiming */
 		spin_lock(&bdev_lock);
@@ -1453,11 +1459,6 @@ struct block_device *open_bdev_exclusive(const char *path, fmode_t mode, void *h
 	if (error)
 		return ERR_PTR(error);

-	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
-		blkdev_put(bdev, mode);
-		return ERR_PTR(-EACCES);
-	}
-
 	return bdev;
 }

-- 
1.7.1

