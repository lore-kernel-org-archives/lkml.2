Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1K3SQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:16:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40552 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1K3SQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:16:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, lidongyang@novell.com, JBeulich@novell.com
Cc: axboe@kernel.dk, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] xen/blk[front|back]: Squash blkif_request_rw and blkif_request_discard together
Date: Wed, 30 Nov 2011 13:15:53 -0500
Message-Id: <1322676956-15691-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
References: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4ED672FD.008A,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a union type structure to deal with the overlapping
attributes in a easier manner.

Suggested-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   13 ++++---
 drivers/block/xen-blkback/common.h  |   64 +++++++++++++++++++---------------
 drivers/block/xen-blkfront.c        |   44 ++++++++++++-----------
 include/xen/interface/io/blkif.h    |   24 +++++++++----
 4 files changed, 83 insertions(+), 62 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 15ec4db..d7104ab 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -362,7 +362,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	int i;
-	int nseg = req->nr_segments;
+	int nseg = req->u.rw.nr_segments;
 	int ret = 0;
 
 	/*
@@ -449,7 +449,7 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 	} else if (err)
 		status = BLKIF_RSP_ERROR;
 
-	make_response(blkif, req->id, req->operation, status);
+	make_response(blkif, req->u.discard.id, req->operation, status);
 }
 
 static void xen_blk_drain_io(struct xen_blkif *blkif)
@@ -644,7 +644,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	}
 
 	/* Check that the number of segments is sane. */
-	nseg = req->nr_segments;
+	nseg = req->u.rw.nr_segments;
+
 	if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
 				operation != REQ_DISCARD) ||
 	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
@@ -654,12 +655,12 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		goto fail_response;
 	}
 
-	preq.dev           = req->handle;
+	preq.dev           = req->u.rw.handle;
 	preq.sector_number = req->u.rw.sector_number;
 	preq.nr_sects      = 0;
 
 	pending_req->blkif     = blkif;
-	pending_req->id        = req->id;
+	pending_req->id        = req->u.rw.id;
 	pending_req->operation = req->operation;
 	pending_req->status    = BLKIF_RSP_OKAY;
 	pending_req->nr_pages  = nseg;
@@ -784,7 +785,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	xen_blkbk_unmap(pending_req);
  fail_response:
 	/* Haven't submitted any bio's yet. */
-	make_response(blkif, req->id, req->operation, BLKIF_RSP_ERROR);
+	make_response(blkif, req->u.rw.id, req->operation, BLKIF_RSP_ERROR);
 	free_req(pending_req);
 	msleep(1); /* back off a bit */
 	return -EIO;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index dfb1b3a..dbfe7b3 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -60,58 +60,66 @@ struct blkif_common_response {
 	char dummy;
 };
 
-/* i386 protocol version */
-#pragma pack(push, 4)
-
 struct blkif_x86_32_request_rw {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-};
+} __attribute__((__packed__));
 
 struct blkif_x86_32_request_discard {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   _pad1;        /* was "handle" for read/write requests */
+	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
-	uint64_t nr_sectors;
-};
+	uint64_t       nr_sectors;
+} __attribute__((__packed__));
 
 struct blkif_x86_32_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
-	blkif_vdev_t   handle;       /* only for read/write requests         */
-	uint64_t       id;           /* private guest value, echoed in resp  */
 	union {
 		struct blkif_x86_32_request_rw rw;
 		struct blkif_x86_32_request_discard discard;
 	} u;
-};
+} __attribute__((__packed__));
+
+/* i386 protocol version */
+#pragma pack(push, 4)
 struct blkif_x86_32_response {
 	uint64_t        id;              /* copied from request */
 	uint8_t         operation;       /* copied from request */
 	int16_t         status;          /* BLKIF_RSP_???       */
 };
 #pragma pack(pop)
-
 /* x86_64 protocol version */
 
 struct blkif_x86_64_request_rw {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+	uint32_t       _pad1;        /* offsetof(blkif_reqest..,u.rw.id)==8  */
+	uint64_t       id;
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-};
+} __attribute__((__packed__));
 
 struct blkif_x86_64_request_discard {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   _pad1;        /* was "handle" for read/write requests */
+        uint32_t       _pad2;        /* offsetof(blkif_..,u.discard.id)==8   */
+	uint64_t       id;
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
-	uint64_t nr_sectors;
-};
+	uint64_t       nr_sectors;
+} __attribute__((__packed__));
 
 struct blkif_x86_64_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
-	blkif_vdev_t   handle;       /* only for read/write requests         */
-	uint64_t       __attribute__((__aligned__(8))) id;
 	union {
 		struct blkif_x86_64_request_rw rw;
 		struct blkif_x86_64_request_discard discard;
 	} u;
-};
+} __attribute__((__packed__));
+
 struct blkif_x86_64_response {
 	uint64_t       __attribute__((__aligned__(8))) id;
 	uint8_t         operation;       /* copied from request */
@@ -237,18 +245,18 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 {
 	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
 	dst->operation = src->operation;
-	dst->nr_segments = src->nr_segments;
-	dst->handle = src->handle;
-	dst->id = src->id;
 	switch (src->operation) {
 	case BLKIF_OP_READ:
 	case BLKIF_OP_WRITE:
 	case BLKIF_OP_WRITE_BARRIER:
 	case BLKIF_OP_FLUSH_DISKCACHE:
+		dst->u.rw.nr_segments = src->u.rw.nr_segments;
+		dst->u.rw.handle = src->u.rw.handle;
+		dst->u.rw.id = src->u.rw.id;
 		dst->u.rw.sector_number = src->u.rw.sector_number;
 		barrier();
-		if (n > dst->nr_segments)
-			n = dst->nr_segments;
+		if (n > dst->u.rw.nr_segments)
+			n = dst->u.rw.nr_segments;
 		for (i = 0; i < n; i++)
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
@@ -266,18 +274,18 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 {
 	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
 	dst->operation = src->operation;
-	dst->nr_segments = src->nr_segments;
-	dst->handle = src->handle;
-	dst->id = src->id;
 	switch (src->operation) {
 	case BLKIF_OP_READ:
 	case BLKIF_OP_WRITE:
 	case BLKIF_OP_WRITE_BARRIER:
 	case BLKIF_OP_FLUSH_DISKCACHE:
+		dst->u.rw.nr_segments = src->u.rw.nr_segments;
+		dst->u.rw.handle = src->u.rw.handle;
+		dst->u.rw.id = src->u.rw.id;
 		dst->u.rw.sector_number = src->u.rw.sector_number;
 		barrier();
-		if (n > dst->nr_segments)
-			n = dst->nr_segments;
+		if (n > dst->u.rw.nr_segments)
+			n = dst->u.rw.nr_segments;
 		for (i = 0; i < n; i++)
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 7b2ec59..2c2c4be 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -135,15 +135,15 @@ static int get_id_from_freelist(struct blkfront_info *info)
 {
 	unsigned long free = info->shadow_free;
 	BUG_ON(free >= BLK_RING_SIZE);
-	info->shadow_free = info->shadow[free].req.id;
-	info->shadow[free].req.id = 0x0fffffee; /* debug */
+	info->shadow_free = info->shadow[free].req.u.rw.id;
+	info->shadow[free].req.u.rw.id = 0x0fffffee; /* debug */
 	return free;
 }
 
 static void add_id_to_freelist(struct blkfront_info *info,
 			       unsigned long id)
 {
-	info->shadow[id].req.id  = info->shadow_free;
+	info->shadow[id].req.u.rw.id  = info->shadow_free;
 	info->shadow[id].request = NULL;
 	info->shadow_free = id;
 }
@@ -287,9 +287,9 @@ static int blkif_queue_request(struct request *req)
 	id = get_id_from_freelist(info);
 	info->shadow[id].request = req;
 
-	ring_req->id = id;
+	ring_req->u.rw.id = id;
 	ring_req->u.rw.sector_number = (blkif_sector_t)blk_rq_pos(req);
-	ring_req->handle = info->handle;
+	ring_req->u.rw.handle = info->handle;
 
 	ring_req->operation = rq_data_dir(req) ?
 		BLKIF_OP_WRITE : BLKIF_OP_READ;
@@ -308,13 +308,15 @@ static int blkif_queue_request(struct request *req)
 	if (unlikely(req->cmd_flags & REQ_DISCARD)) {
 		/* id, sector_number and handle are set above. */
 		ring_req->operation = BLKIF_OP_DISCARD;
-		ring_req->nr_segments = 0;
+		ring_req->u.discard.nr_segments = 0;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
 	} else {
-		ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
-		BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
+		ring_req->u.rw.nr_segments = blk_rq_map_sg(req->q, req,
+							   info->sg);
+		BUG_ON(ring_req->u.rw.nr_segments >
+		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
-		for_each_sg(info->sg, sg, ring_req->nr_segments, i) {
+		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
 			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
@@ -705,7 +707,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 static void blkif_completion(struct blk_shadow *s)
 {
 	int i;
-	for (i = 0; i < s->req.nr_segments; i++)
+	for (i = 0; i < s->req.u.rw.nr_segments; i++)
 		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
 }
 
@@ -763,7 +765,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
-				     info->shadow[id].req.nr_segments == 0)) {
+				     info->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
 				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
 				       "barrier" :  "flush disk cache",
@@ -984,8 +986,8 @@ static int blkfront_probe(struct xenbus_device *dev,
 	INIT_WORK(&info->work, blkif_restart_queue);
 
 	for (i = 0; i < BLK_RING_SIZE; i++)
-		info->shadow[i].req.id = i+1;
-	info->shadow[BLK_RING_SIZE-1].req.id = 0x0fffffff;
+		info->shadow[i].req.u.rw.id = i+1;
+	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
@@ -1019,9 +1021,9 @@ static int blkif_recover(struct blkfront_info *info)
 	/* Stage 2: Set up free list. */
 	memset(&info->shadow, 0, sizeof(info->shadow));
 	for (i = 0; i < BLK_RING_SIZE; i++)
-		info->shadow[i].req.id = i+1;
+		info->shadow[i].req.u.rw.id = i+1;
 	info->shadow_free = info->ring.req_prod_pvt;
-	info->shadow[BLK_RING_SIZE-1].req.id = 0x0fffffff;
+	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
 	/* Stage 3: Find pending requests and requeue them. */
 	for (i = 0; i < BLK_RING_SIZE; i++) {
@@ -1034,17 +1036,17 @@ static int blkif_recover(struct blkfront_info *info)
 		*req = copy[i].req;
 
 		/* We get a new request id, and must reset the shadow state. */
-		req->id = get_id_from_freelist(info);
-		memcpy(&info->shadow[req->id], &copy[i], sizeof(copy[i]));
+		req->u.rw.id = get_id_from_freelist(info);
+		memcpy(&info->shadow[req->u.rw.id], &copy[i], sizeof(copy[i]));
 
 		/* Rewrite any grant references invalidated by susp/resume. */
-		for (j = 0; j < req->nr_segments; j++)
+		for (j = 0; j < req->u.rw.nr_segments; j++)
 			gnttab_grant_foreign_access_ref(
 				req->u.rw.seg[j].gref,
 				info->xbdev->otherend_id,
-				pfn_to_mfn(info->shadow[req->id].frame[j]),
-				rq_data_dir(info->shadow[req->id].request));
-		info->shadow[req->id].req = *req;
+				pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
+				rq_data_dir(info->shadow[req->u.rw.id].request));
+		info->shadow[req->u.rw.id].req = *req;
 
 		info->ring.req_prod_pvt++;
 	}
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 9324488..f88e28b 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -95,6 +95,12 @@ typedef uint64_t blkif_sector_t;
 #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
 
 struct blkif_request_rw {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+#ifdef CONFIG_X86_64
+	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
+#endif
+	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	struct blkif_request_segment {
 		grant_ref_t gref;        /* reference to I/O buffer frame        */
@@ -102,23 +108,27 @@ struct blkif_request_rw {
 		/* @last_sect: last sector in frame to transfer (inclusive).     */
 		uint8_t     first_sect, last_sect;
 	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-};
+} __attribute__((__packed__));
 
 struct blkif_request_discard {
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   _pad1;        /* only for read/write requests         */
+#ifdef CONFIG_X86_64
+	uint32_t       _pad2;        /* offsetof(blkif_req..,u.discard.id)==8*/
+#endif
+	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;
-	uint64_t nr_sectors;
-};
+	uint64_t       nr_sectors;
+	uint8_t        _pad3;
+} __attribute__((__packed__));
 
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
-	blkif_vdev_t   handle;       /* only for read/write requests         */
-	uint64_t       id;           /* private guest value, echoed in resp  */
 	union {
 		struct blkif_request_rw rw;
 		struct blkif_request_discard discard;
 	} u;
-};
+} __attribute__((__packed__));
 
 struct blkif_response {
 	uint64_t        id;              /* copied from request */
-- 
1.7.7.3

