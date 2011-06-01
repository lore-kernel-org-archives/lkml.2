Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162086Ab1FAIRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162069Ab1FAIRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:15 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:03 2011
Message-Id: <20110601081102.816575538@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:54 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [024/165] block: move bd_set_size() above rescan_partitions() in
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 __blkdev_get()
Content-Length: 2050
Lines: 65

From: Tejun Heo <tj@kernel.org>

commit 7e69723fef8771a9d57bd27d36281d756130b4b5 upstream.

02e352287a4 (block: rescan partitions on invalidated devices on
-ENOMEDIA too) relocated partition rescan above explicit bd_set_size()
to simplify condition check.  As rescan_partitions() does its own bdev
size setting, this doesn't break anything; however,
rescan_partitions() prints out the following messages when adjusting
bdev size, which can be confusing.

  sda: detected capacity change from 0 to 146815737856
  sdb: detected capacity change from 0 to 146815737856

This patch restores the original order and remove the warning
messages.

stable: Please apply together with 02e352287a4 (block: rescan
        partitions on invalidated devices on -ENOMEDIA too).

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tony Luck <tony.luck@gmail.com>
Tested-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/block_dev.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1120,6 +1120,15 @@ static int __blkdev_get(struct block_dev
 					goto restart;
 				}
 			}
+
+			if (!ret && !bdev->bd_openers) {
+				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
+				bdi = blk_get_backing_dev_info(bdev);
+				if (bdi == NULL)
+					bdi = &default_backing_dev_info;
+				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
+			}
+
 			/*
 			 * If the device is invalidated, rescan partition
 			 * if open succeeded or failed with -ENOMEDIUM.
@@ -1130,14 +1139,6 @@ static int __blkdev_get(struct block_dev
 				rescan_partitions(disk, bdev);
 			if (ret)
 				goto out_clear;
-
-			if (!bdev->bd_openers) {
-				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
-				bdi = blk_get_backing_dev_info(bdev);
-				if (bdi == NULL)
-					bdi = &default_backing_dev_info;
-				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
-			}
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);


