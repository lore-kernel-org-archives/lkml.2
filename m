Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1BXOtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:49:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37852 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1BXOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:49:05 -0500
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
CC: kovariadam@gmail.com, florian@mickler.org, rjw@sisk.pl, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix refcounting in BLKBSZSET
Message-Id: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Feb 2011 15:48:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[and lkml cc-d too]

This fixes bug 29202 in the 2.6.38 regression list.

Please apply.

Thanks,
Miklos

----
Subject: block: fix refcounting in BLKBSZSET

From: Miklos Szeredi <mszeredi@suse.cz>

Adam Kovari and others reported that disconnecting an USB drive with
an ntfs-3g filesystem would cause "kernel BUG at fs/inode.c:1421!" to
be triggered.

The BUG could be traced back to ioctl(BLKBSZSET), which would
erroneously decrement the refcount on the bdev.  This is because
blkdev_get() expects the refcount to be already incremented and either
returns success or decrements the refcount and returns an error.

The bug was introduced by e525fd89 (block: make blkdev_get/put()
handle exclusive access), which didn't take into account this behavior
of blkdev_get().

Reported-by: Adam Kovari <kovariadam@gmail.com>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 block/ioctl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux.git/block/ioctl.c
===================================================================
--- linux.git.orig/block/ioctl.c	2011-01-18 09:02:44.000000000 +0100
+++ linux.git/block/ioctl.c	2011-02-24 14:23:56.000000000 +0100
@@ -294,9 +294,11 @@ int blkdev_ioctl(struct block_device *bd
 			return -EINVAL;
 		if (get_user(n, (int __user *) arg))
 			return -EFAULT;
-		if (!(mode & FMODE_EXCL) &&
-		    blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
-			return -EBUSY;
+		if (!(mode & FMODE_EXCL)) {
+			bdgrab(bdev);
+			if (blkdev_get(bdev, mode | FMODE_EXCL, &bdev) < 0)
+				return -EBUSY;
+		}
 		ret = set_blocksize(bdev, n);
 		if (!(mode & FMODE_EXCL))
 			blkdev_put(bdev, mode | FMODE_EXCL);

