Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1CIPlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:41:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63430 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab1CIPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UrjneMrhFW4wmJcy5V4OBE63kDkedFCFoqJ+4gcZom/mgRXFNc8njolo1qVvtD3VCi
         GumVtacrGnyg66pwbY3Od1nKWXeCCubMmJdNLsMHxEP8/HIdy+SNFZMvQiC1gOkE8xWd
         eGymdjKaUeVsps7+eAsx8CUgERsdtrRGyM9ZA=
Date: Wed, 9 Mar 2011 16:38:59 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, hch@infradead.org
Subject: block: Fix oops caused by __blkdev_get() calling
 disk_unblock_events() with invalid @disk
Message-ID: <20110309153859.GD27010@htj.dyndns.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
 <4D774641.3070806@kernel.dk>
 <4D779396.7050905@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D779396.7050905@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 57c966b8b2 (block: Don't check events while open is in
progress) made __blkdev_get() block events around open calls; however,
it used invalid @disk pointer in the following cases.

* When ->open() returns -ERESTARTSYS, disk_unblock_events() is called
  after @disk is put.  @disk may be invalid by the time unblock is
  called.

  This is fixed by moving references after disk_unblock_events().

* When there are multiple openers, @disk is cleared to %NULL and later
  disk_unblock_disk() is called with %NULL @disk causing oops.

  This is fixed by moving reference putting after open success is
  determined and not clearing @disk to %NULL.  On success, @disk is
  valid because there is another opener holding reference to it.  On
  failure, the references are put after disk_unblock_events() is
  called.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jens Axboe <axboe@kernel.dk>
---
Ah, sorry about that.  My test setup didn't include a device with
multiple partitions on it so the more than one opener case never
triggered.

Thanks.

 fs/block_dev.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: work/fs/block_dev.c
===================================================================
--- work.orig/fs/block_dev.c
+++ work/fs/block_dev.c
@@ -1109,11 +1109,11 @@ static int __blkdev_get(struct block_dev
 					 */
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
-					module_put(disk->fops->owner);
-					put_disk(disk);
 					bdev->bd_disk = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
+					module_put(disk->fops->owner);
+					put_disk(disk);
 					goto restart;
 				}
 				if (ret)
@@ -1150,9 +1150,6 @@ static int __blkdev_get(struct block_dev
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		module_put(disk->fops->owner);
-		put_disk(disk);
-		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
 				ret = bdev->bd_disk->fops->open(bdev, mode);
@@ -1162,6 +1159,9 @@ static int __blkdev_get(struct block_dev
 			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
 		}
+		/* only one opener holds refs to the module and disk */
+		module_put(disk->fops->owner);
+		put_disk(disk);
 	}
 	bdev->bd_openers++;
 	if (for_part)
@@ -1182,8 +1182,7 @@ static int __blkdev_get(struct block_dev
 	mutex_unlock(&bdev->bd_mutex);
 	disk_unblock_events(disk);
  out:
-	if (disk)
-		module_put(disk->fops->owner);
+	module_put(disk->fops->owner);
 	put_disk(disk);
 	bdput(bdev);
 
