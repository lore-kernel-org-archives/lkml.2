Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1GHFEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab1GHFEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.262241607@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [077/107] block: use the passed in @bdev when claiming if partno is zero
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d4c208b86b8be4254eba0e74071496e599f94639 upstream.

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
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -762,7 +762,19 @@ static struct block_device *bd_start_cla
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


