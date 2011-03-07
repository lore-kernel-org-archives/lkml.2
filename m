Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1CGReS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:34:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57053 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1CGReP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Mar 2011 12:34:15 -0500
Date: Mon, 7 Mar 2011 12:34:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, owen.smith@citrix.com
Subject: [owen.smith@citrix.com: [Xen-devel] [PATCH 1/2
 xen/stable-2.6.32.x] Union the blkif_request request specific fields]
Message-ID: <20110307173405.GA6087@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D751712.0089,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Are you OK with this patch? I was thinking to push it for 2.6.39.
I've it in my tree, but if you would rather carry it for the merge window
it is in 
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront-cleanup


commit cd50f830627fd8ec0d97a73c970ccec9811c6bae
Author: Owen Smith <owen.smith@citrix.com>
Date:   Wed Dec 22 15:05:00 2010 +0000

    xen: Union the blkif_request request specific fields
    
    Prepare for extending the block device ring to allow request
    specific fields, by moving the request specific fields for
    reads, writes and barrier requests to a union member.
    
    Signed-off-by: Owen Smith <owen.smith@citrix.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d7aa39e..cc4514c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -281,7 +281,7 @@ static int blkif_queue_request(struct request *req)
 	info->shadow[id].request = req;
 
 	ring_req->id = id;
-	ring_req->sector_number = (blkif_sector_t)blk_rq_pos(req);
+	ring_req->u.rw.sector_number = (blkif_sector_t)blk_rq_pos(req);
 	ring_req->handle = info->handle;
 
 	ring_req->operation = rq_data_dir(req) ?
@@ -317,7 +317,7 @@ static int blkif_queue_request(struct request *req)
 				rq_data_dir(req) );
 
 		info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
-		ring_req->seg[i] =
+		ring_req->u.rw.seg[i] =
 				(struct blkif_request_segment) {
 					.gref       = ref,
 					.first_sect = fsect,
@@ -615,7 +615,7 @@ static void blkif_completion(struct blk_shadow *s)
 {
 	int i;
 	for (i = 0; i < s->req.nr_segments; i++)
-		gnttab_end_foreign_access(s->req.seg[i].gref, 0, 0UL);
+		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -932,7 +932,7 @@ static int blkif_recover(struct blkfront_info *info)
 		/* Rewrite any grant references invalidated by susp/resume. */
 		for (j = 0; j < req->nr_segments; j++)
 			gnttab_grant_foreign_access_ref(
-				req->seg[j].gref,
+				req->u.rw.seg[j].gref,
 				info->xbdev->otherend_id,
 				pfn_to_mfn(info->shadow[req->id].frame[j]),
 				rq_data_dir(info->shadow[req->id].request));
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index c2d1fa4..e4f743c 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -51,11 +51,7 @@ typedef uint64_t blkif_sector_t;
  */
 #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
 
-struct blkif_request {
-	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
-	blkif_vdev_t   handle;       /* only for read/write requests         */
-	uint64_t       id;           /* private guest value, echoed in resp  */
+struct blkif_request_rw {
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	struct blkif_request_segment {
 		grant_ref_t gref;        /* reference to I/O buffer frame        */
@@ -65,6 +61,16 @@ struct blkif_request {
 	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
+struct blkif_request {
+	uint8_t        operation;    /* BLKIF_OP_???                         */
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+	uint64_t       id;           /* private guest value, echoed in resp  */
+	union {
+		struct blkif_request_rw rw;
+	} u;
+};
+
 struct blkif_response {
 	uint64_t        id;              /* copied from request */
 	uint8_t         operation;       /* copied from request */
