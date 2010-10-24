Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab0JXKCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:02:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0JXKCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:02:45 -0400
Message-ID: <4CC4043F.1070605@redhat.com>
Date: Sun, 24 Oct 2010 12:02:39 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: loop warnings in current git HEAD
References: <20101023155950.GA31946@lst.de>
In-Reply-To: <20101023155950.GA31946@lst.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/23/2010 05:59 PM, Christoph Hellwig wrote:

> The loop driver in current git HEAD is rather unhappy when running
> xfstests.  I gets lots of warnings like the one below.  The most likely
> culprit seems to be:
>
> 	loop: add some basic read-only sysfs attributes
>
> (commit ee86273062cbb310665fe49e1f1937d2cf85b0b9) 
yes, seems I forgot bdev can be NULL in destructor (autoclear mode).
can you try if patch below helps?

Milan

loop: Properly clear sysfs in autoclear mode

Signed-off-by: Milan Broz <mbroz@redhat.com>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6c48b35..c21d4f3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1049,9 +1049,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	if (bdev)
 		invalidate_bdev(bdev);
 	set_capacity(lo->lo_disk, 0);
+	loop_sysfs_exit(lo);
 	if (bdev) {
 		bd_set_size(bdev, 0);
-		loop_sysfs_exit(lo);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}


