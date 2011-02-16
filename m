Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1BPWXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1BPWX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:23:29 -0500
Date: Wed, 16 Feb 2011 17:19:38 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: [Patch] Revert block_dev read-only check
Message-ID: <20110216171938.78fd4a2f@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 75f1dc0d076d1c1168f2115f1941ea627d38bd5a. The revert
could not be done automatically because changes after that commit
altered the code too much.

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
