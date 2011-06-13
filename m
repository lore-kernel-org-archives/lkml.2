Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1FMKop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:44:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1FMKoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qHSKWdXaWF5JCALYF84bJXOJqUrBKoE/uvtpW8hJ3EhhExX2SXEFEE1cT4i0+65Mxf
         Gi5SR22aM6IVTrI0XAJLDsTpUOo+RiyhUWvEurEy4pw0fwp54o3AmVbzlp9+tnAj868h
         5LH9JQ2xa2zO18y5zma7CiV7ooSf1XggF92g0=
Date: Mon, 13 Jun 2011 12:44:40 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        avillaci@ceibo.fiec.espol.edu.ec
Subject: [PATCH] block: use the passed in @bdev when claiming if partno is
 zero
Message-ID: <20110613104440.GB16021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6b4517a791 (block: implement bd_claiming and claiming block)
introduced claiming block to support O_EXCL blkdev opens properly.

bd_start_claiming() looks up the part 0 bdev and starts claiming
block.  The function assumed that there is only one part 0 bdev and
always used bdget_disk(disk, 0) to look it up; unfortunately, this
isn't true for some drivers (floppy) which use multiple block devices
to denote different operating parameters for the same physical device.
There can be multiple part 0 bdev's for the same device number.

This incorrect assumption caused the wrong bdev to be used during
claiming leading to unbalanced bd_holders as reported in the following
bug.

  https://bugzilla.kernel.org/show_bug.cgi?id=28522

This patch updates bd_start_claiming() such that it uses the bdev
specified as argument if its partno is zero.

Note that this means that different bdev's can be used for the same
device and O_EXCL check can be effectively bypassed.  It has always
been broken that way and floppy is fortunately on its way out.  Leave
that breakage alone.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Tested-by: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Cc: stable@kernel.org	# >= v2.6.36
---
 fs/block_dev.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a2421f..610e8e0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -762,7 +762,19 @@ static struct block_device *bd_start_claiming(struct block_device *bdev,
 	if (!disk)
 		return ERR_PTR(-ENXIO);
 
-	whole = bdget_disk(disk, 0);
+	/*
+	 * Normally, @bdev should equal what's returned from bdget_disk()
+	 * if partno is 0; however, some drivers (floppy) use multiple
+	 * bdev's for the same physical device and @bdev may be one of the
+	 * aliases.  Keep @bdev if partno is 0.  This means claimer
+	 * tracking is broken for those devices but it has always been that
+	 * way.
+	 */
+	if (partno)
+		whole = bdget_disk(disk, 0);
+	else
+		whole = bdgrab(bdev);
+
 	module_put(disk->fops->owner);
 	put_disk(disk);
 	if (!whole)
