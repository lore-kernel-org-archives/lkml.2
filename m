Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1K3SQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:16:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42766 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1K3SQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:16:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, lidongyang@novell.com, JBeulich@novell.com
Cc: axboe@kernel.dk, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen-blkback: convert hole punching to discard request on loop devices
Date: Wed, 30 Nov 2011 13:15:56 -0500
Message-Id: <1322676956-15691-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
References: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4ED672FD.00C5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Dongyang <lidongyang@novell.com>

As of dfaa2ef68e80c378e610e3c8c536f1c239e8d3ef, loop devices support
discard request now. We could just issue a discard request, and
the loop driver will punch the hole for us, so we don't need to touch
the internals of loop device and punch the hole ourselves, Thanks.

V0->V1: rebased on devel/for-jens-3.3

Signed-off-by: Li Dongyang <lidongyang@novell.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index b058de7..0088bf6 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -39,9 +39,6 @@
 #include <linux/list.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
-#include <linux/loop.h>
-#include <linux/falloc.h>
-#include <linux/fs.h>
 
 #include <xen/events.h>
 #include <xen/page.h>
@@ -426,27 +423,15 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	blkif->st_ds_req++;
 
 	xen_blkif_get(blkif);
-	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
+	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY ||
+	    blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
 		unsigned long secure = (blkif->vbd.discard_secure &&
 			(req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
 			BLKDEV_DISCARD_SECURE : 0;
-		/* just forward the discard request */
 		err = blkdev_issue_discard(bdev,
 				req->u.discard.sector_number,
 				req->u.discard.nr_sectors,
 				GFP_KERNEL, secure);
-	} else if (blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
-		/* punch a hole in the backing file */
-		struct loop_device *lo = bdev->bd_disk->private_data;
-		struct file *file = lo->lo_backing_file;
-
-		if (file->f_op->fallocate)
-			err = file->f_op->fallocate(file,
-				FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
-				req->u.discard.sector_number << 9,
-				req->u.discard.nr_sectors << 9);
-		else
-			err = -EOPNOTSUPP;
 	} else
 		err = -EOPNOTSUPP;
 
-- 
1.7.7.3

