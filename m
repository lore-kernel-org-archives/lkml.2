Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0KMLBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:01:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:42394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0KMLB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:01:29 -0500
Message-ID: <4CDE6FAA.9030605@kernel.org>
Date: Sat, 13 Nov 2010 11:59:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: axboe@kernel.dk, dedekind1@gmail.com
CC: hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de,
        leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com,
        swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-mtd@lists.infradead.org
Subject: [PATCH UPDATED 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
References: <1288628129-12811-1-git-send-email-tj@kernel.org> <1288628129-12811-2-git-send-email-tj@kernel.org>
In-Reply-To: <1288628129-12811-2-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Nov 2010 11:00:02 +0000 (UTC)
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

- Updated to use local variable @mode to cache FMODE_* masks as
  suggested by Artem Bityutskiy.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: linux-mtd@lists.infradead.org
Cc: Artem Bityutskiy <dedekind1@gmail.com>
---

This change will cause two conflicts in the series.  I'm not reposting
them now as they're mostly trivial.  Git tree is fully updated.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cleanup-bd_claim

Jens, please let me know when/if you want the full series reposted.

Thanks.

 drivers/mtd/devices/block2mtd.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: work/drivers/mtd/devices/block2mtd.c
===================================================================
--- work.orig/drivers/mtd/devices/block2mtd.c
+++ work/drivers/mtd/devices/block2mtd.c
@@ -234,6 +234,7 @@ static void block2mtd_free_device(struct
 /* FIXME: ensure that mtd->size % erase_size == 0 */
 static struct block2mtd_dev *add_device(char *devname, int erase_size)
 {
+	const fmode_t mode = FMODE_READ | FMODE_WRITE;
 	struct block_device *bdev;
 	struct block2mtd_dev *dev;
 	char *name;
@@ -246,7 +247,7 @@ static struct block2mtd_dev *add_device(
 		return NULL;

 	/* Get a handle on the device */
-	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, NULL);
+	bdev = open_bdev_exclusive(devname, mode, dev);
 #ifndef MODULE
 	if (IS_ERR(bdev)) {

@@ -255,7 +256,15 @@ static struct block2mtd_dev *add_device(

 		dev_t devt = name_to_dev_t(devname);
 		if (devt) {
-			bdev = open_by_devnum(devt, FMODE_WRITE | FMODE_READ);
+			bdev = open_by_devnum(devt, mode);
+			if (!IS_ERR(bdev)) {
+				int ret;
+				ret = bd_claim(bdev, dev);
+				if (ret) {
+					blkdev_put(bdev, mode);
+					bdev = ERR_PTR(ret);
+				}
+			}
 		}
 	}
 #endif
