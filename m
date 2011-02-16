Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1BPXPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:15:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1BPXPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:15:32 -0500
Date: Wed, 16 Feb 2011 18:11:53 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Milan Broz <mbroz@redhat.com>
Subject: [Patch v2] block: revert block_dev read-only check
Message-ID: <20110216181153.5b8f81d5@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 75f1dc0d076d1c1168f2115f1941ea627d38bd5a
("block: check bdev_read_only() from blkdev_get()"). That commit added
stricter checking to make sure devices that were being used read-only
were actually opened in that mode.

It turns out that the change breaks a bunch of kernel code that opens
block devices. Affected systems include dm, md, and the loop device.
Because strict checking for read-only opens of block devices was not
done before this, the code that opens the devices was opening them
read-write even if they were being used read-only. Auditing all that
code will take time, and new userspace packages for dm, mdadm, etc.
will also be required.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1215,12 +1215,6 @@ int blkdev_get(struct block_device *bdev
 
 	res = __blkdev_get(bdev, mode, 0);
 
-	/* __blkdev_get() may alter read only status, check it afterwards */
-	if (!res && (mode & FMODE_WRITE) && bdev_read_only(bdev)) {
-		__blkdev_put(bdev, mode, 0);
-		res = -EACCES;
-	}
-
 	if (whole) {
 		/* finish claiming */
 		mutex_lock(&bdev->bd_mutex);
@@ -1298,6 +1292,11 @@ struct block_device *blkdev_get_by_path(
 	if (err)
 		return ERR_PTR(err);
 
+	if ((mode & FMODE_WRITE) && bdev_read_only(bdev)) {
+		blkdev_put(bdev, mode);
+		return ERR_PTR(-EACCES);
+	}
+
 	return bdev;
 }
 EXPORT_SYMBOL(blkdev_get_by_path);
