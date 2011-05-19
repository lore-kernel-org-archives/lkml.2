Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab1ESJac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:30:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44148 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab1ESJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qPUetGIv9EY1kWSE6jEkgFNd1wpkvArsDEyTJiGU/UDnRouVwvmMez2QwHiyOHbM3H
         AUe1kbBBMJ+Ry2PsSZc+KzDV/OIXjT1C0QrpsS/rs2ajLjvKJFXnOdBvEWPEXhPOeE28
         1S6inZBzqH7Kr8agG523WAPbMaH9XzQ9FujiI=
Date: Thu, 19 May 2011 11:30:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: New boot time message: detected capacity change
Message-ID: <20110519093026.GA627@htj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:32:50PM -0700, Tony Luck wrote:
> Today's pull from Linus' tree (HEAD = 258-ga2b9c1f) gave me some new
> messages during boot:
> 
> sda: detected capacity change from 0 to 146815737856
> sdb: detected capacity change from 0 to 146815737856
> 
> They weren't there yesterday (HEAD = 211-gc1d10d1) ... nor do they
> show up in any of my saved boot time dmesg files for the last few
> months.
> 
> Harmless?  Or something to worry about in the last few commits
> before 2.6.39 goes final?

Yes, it is harmless.  The order was changed between
rescan_partitions() and bd_set_size() - rescan_partitions() checked
for size change too and it resulted in simpler condition checks.
However, rescan_partitions() triggers the above message when it
detects size change unlike the silient bd_set_size().

Does the following patch remove the messages for you?

Thanks.

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
