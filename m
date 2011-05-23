Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1EWLZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:25:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46312 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1EWLZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MYzq0Lxcx+IzEb4TaRKWka4krwxALM3FjvX7c0HnMIOcijTZD4X2XPF+3gVa+mlgXw
         lk0qaHoMDHAi4Pxk0yy5Qu/c2fMA3WLHCRh3+itvH91scYlo+W4qoAU70+5aF21W3t1v
         d6uvmme7d5jyjVDziwX0up241af1i9AS+sdCo=
Date: Mon, 23 May 2011 13:24:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: move bd_set_size() above rescan_partitions() in
 __blkdev_get()
Message-ID: <20110523112454.GA17547@htj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
 <20110519093026.GA627@htj.dyndns.org>
 <BANLkTinP7txzE2U+8qnJR2JVcGpGybnLrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinP7txzE2U+8qnJR2JVcGpGybnLrA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 fs/block_dev.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 257b00e..bf9c7a7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1120,6 +1120,15 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
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
@@ -1130,14 +1139,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
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
