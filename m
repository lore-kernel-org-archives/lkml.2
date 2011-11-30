Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1K3SQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:16:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42765 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1K3SQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:16:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, lidongyang@novell.com, JBeulich@novell.com
Cc: axboe@kernel.dk, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen/blkback: Move processing of BLKIF_OP_DISCARD from dispatch_rw_block_io
Date: Wed, 30 Nov 2011 13:15:55 -0500
Message-Id: <1322676956-15691-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
References: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020206.4ED672FC.0121,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. and move it to its own function that will deal with the
discard operation.

Suggested-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   54 +++++++++++++++-------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 9d2261b..b058de7 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -416,12 +416,16 @@ static int xen_blkbk_map(struct blkif_request *req,
 	return ret;
 }
 
-static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
+static int dispatch_discard_io(struct xen_blkif *blkif,
+				struct blkif_request *req)
 {
 	int err = 0;
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 
+	blkif->st_ds_req++;
+
+	xen_blkif_get(blkif);
 	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
 		unsigned long secure = (blkif->vbd.discard_secure &&
 			(req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
@@ -453,6 +457,8 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 		status = BLKIF_RSP_ERROR;
 
 	make_response(blkif, req->u.discard.id, req->operation, status);
+	xen_blkif_put(blkif);
+	return err;
 }
 
 static void xen_blk_drain_io(struct xen_blkif *blkif)
@@ -576,8 +582,11 @@ __do_block_io_op(struct xen_blkif *blkif)
 
 		/* Apply all sanity checks to /private copy/ of request. */
 		barrier();
-
-		if (dispatch_rw_block_io(blkif, &req, pending_req))
+		if (unlikely(req.operation == BLKIF_OP_DISCARD)) {
+			free_req(pending_req);
+			if (dispatch_discard_io(blkif, &req))
+				break;
+		} else if (dispatch_rw_block_io(blkif, &req, pending_req))
 			break;
 
 		/* Yield point for this unbounded loop. */
@@ -636,24 +645,16 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		blkif->st_f_req++;
 		operation = WRITE_FLUSH;
 		break;
-	case BLKIF_OP_DISCARD:
-		blkif->st_ds_req++;
-		operation = REQ_DISCARD;
-		break;
 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
 		break;
 	}
 
-	if (unlikely(operation == REQ_DISCARD))
-		nseg = 0;
-	else
-		/* Check that the number of segments is sane. */
-		nseg = req->u.rw.nr_segments;
+	/* Check that the number of segments is sane. */
+	nseg = req->u.rw.nr_segments;
 
-	if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
-				operation != REQ_DISCARD) ||
+	if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
 	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
 		pr_debug(DRV_PFX "Bad number of segments in request (%d)\n",
 			 nseg);
@@ -714,7 +715,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (nseg && xen_blkbk_map(req, pending_req, seg))
+	if (xen_blkbk_map(req, pending_req, seg))
 		goto fail_flush;
 
 	/*
@@ -746,23 +747,16 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	/* This will be hit if the operation was a flush or discard. */
 	if (!bio) {
-		BUG_ON(operation != WRITE_FLUSH && operation != REQ_DISCARD);
+		BUG_ON(operation != WRITE_FLUSH);
 
-		if (operation == WRITE_FLUSH) {
-			bio = bio_alloc(GFP_KERNEL, 0);
-			if (unlikely(bio == NULL))
-				goto fail_put_bio;
+		bio = bio_alloc(GFP_KERNEL, 0);
+		if (unlikely(bio == NULL))
+			goto fail_put_bio;
 
-			biolist[nbio++] = bio;
-			bio->bi_bdev    = preq.bdev;
-			bio->bi_private = pending_req;
-			bio->bi_end_io  = end_block_io_op;
-		} else if (operation == REQ_DISCARD) {
-			xen_blk_discard(blkif, req);
-			xen_blkif_put(blkif);
-			free_req(pending_req);
-			return 0;
-		}
+		biolist[nbio++] = bio;
+		bio->bi_bdev    = preq.bdev;
+		bio->bi_private = pending_req;
+		bio->bi_end_io  = end_block_io_op;
 	}
 
 	/*
-- 
1.7.7.3

