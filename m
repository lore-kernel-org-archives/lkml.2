Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab1IISbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:31:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16681 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699Ab1IISbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:31:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, JBeulich@novell.com,
        jeremy.fitzhardinge@citrix.com, axboe@kernel.dk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] xen/blk[front|back]: Use the full FLUSH | FUA instead of just FLUSH.
Date: Fri,  9 Sep 2011 14:30:59 -0400
Message-Id: <1315593060-20031-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E6A5B7F.0067:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a FLUSH we can pass sector number that we want to
have flushed - which is what FUA requests are.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   11 ++++++-----
 drivers/block/xen-blkfront.c        |   12 ++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 9713d5a..6ade8ab 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -603,7 +603,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		break;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		blkif->st_f_req++;
-		operation = WRITE_FLUSH;
+		operation = WRITE_FLUSH_FUA;
 		break;
 	case BLKIF_OP_DISCARD:
 		blkif->st_ds_req++;
@@ -618,7 +618,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	/* Check that the number of segments is sane. */
 	nseg = req->nr_segments;
-	if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
+	if (unlikely(nseg == 0 && operation != WRITE_FLUSH_FUA &&
 				operation != REQ_DISCARD) ||
 	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
 		pr_debug(DRV_PFX "Bad number of segments in request (%d)\n",
@@ -707,9 +707,10 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	/* This will be hit if the operation was a flush or discard. */
 	if (!bio) {
-		BUG_ON(operation != WRITE_FLUSH && operation != REQ_DISCARD);
+		BUG_ON(operation != WRITE_FLUSH_FUA &&
+		       operation != REQ_DISCARD);
 
-		if (operation == WRITE_FLUSH) {
+		if (operation == WRITE_FLUSH_FUA) {
 			bio = bio_alloc(GFP_KERNEL, 0);
 			if (unlikely(bio == NULL))
 				goto fail_put_bio;
@@ -743,7 +744,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	if (operation == READ)
 		blkif->st_rd_sect += preq.nr_sects;
-	else if (operation == WRITE || operation == WRITE_FLUSH)
+	else if (operation == WRITE || operation == WRITE_FLUSH_FUA)
 		blkif->st_wr_sect += preq.nr_sects;
 
 	return 0;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 86e2c63..e205d91 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1220,10 +1220,9 @@ static void blkfront_connect(struct blkfront_info *info)
 	 *
 	 * If there are barriers, then we use flush.
 	 */
-	if (!err && barrier) {
-		info->feature_flush = REQ_FLUSH | REQ_FUA;
+	if (!err && barrier)
 		info->flush_op = BLKIF_OP_WRITE_BARRIER;
-	}
+
 	/*
 	 * And if there is "feature-flush-cache" use that above
 	 * barriers.
@@ -1232,10 +1231,11 @@ static void blkfront_connect(struct blkfront_info *info)
 			    "feature-flush-cache", "%d", &flush,
 			    NULL);
 
-	if (!err && flush) {
-		info->feature_flush = REQ_FLUSH;
+	if (!err && flush)
 		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
-	}
+
+	if (info->flush_op)
+		info->feature_flush = REQ_FLUSH | REQ_FUA;
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-discard", "%d", &discard,
-- 
1.7.4.1

