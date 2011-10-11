Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1JKU6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:58:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45239 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1JKU6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:58:00 -0400
Date: Tue, 11 Oct 2011 16:57:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111011205729.GB22668@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
 <4E940E21020000780005AA29@nat28.tlf.novell.com>
 <20111011155133.GC29349@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011155133.GC29349@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090205.4E94ADCF.00A9,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My later response to it should include it:
> http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00652.html
> 
> > 
> > Further I wonder why you don't use the "reserved" field instead of
> > extending the structure at the end.
> 
> <blinks> I completly missed it. That would definitly work as well.
> 
> Let me redo it with that in mind.

I've posted the Xen hypervisor ABI one that thread above. The implementation
of that looks as follow:

commit ae33f998d66c5982af533bda25c2b6c4f863789f
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon Oct 10 10:58:40 2011 -0400

    xen/blk[front|back]: Enhance discard support with secure erasing support.
    
    Part of the blkdev_issue_discard(xx) operation is that it can also
    issue a secure discard operation that will permanantly remove the
    sectors in question. We advertise that we can support that via the
    'discard-secure' attribute and on the request, if the 'secure' bit
    is set, we will attempt to pass in REQ_DISCARD | REQ_SECURE.
    
    CC: Li Dongyang <lidongyang@novell.com>
    [v1: Used 'flag' instead of 'secure:1' bit]
    [v2: Use 'reserved 'uint8_t' as a flag]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 94e659d..4f33c13 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -362,7 +362,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	int i;
-	int nseg = req->nr_segments;
+	int nseg = req->u1.nr_segments;
 	int ret = 0;
 
 	/*
@@ -422,13 +422,16 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 
-	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY)
+	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
+		unsigned long secure = (blkif->vbd.discard_secure &&
+			(req->u1.flag & BLKIF_OP_DISCARD_FLAG_SECURE)) ?
+			BLKDEV_DISCARD_SECURE : 0;
 		/* just forward the discard request */
 		err = blkdev_issue_discard(bdev,
 				req->u.discard.sector_number,
 				req->u.discard.nr_sectors,
-				GFP_KERNEL, 0);
-	else if (blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
+				GFP_KERNEL, secure);
+	} else if (blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
 		/* punch a hole in the backing file */
 		struct loop_device *lo = bdev->bd_disk->private_data;
 		struct file *file = lo->lo_backing_file;
@@ -618,6 +621,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	struct blk_plug plug;
 	bool drain = false;
 
+	/* Check that the number of segments is sane. */
+	nseg = req->u1.nr_segments;
+
 	switch (req->operation) {
 	case BLKIF_OP_READ:
 		blkif->st_rd_req++;
@@ -636,6 +642,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	case BLKIF_OP_DISCARD:
 		blkif->st_ds_req++;
 		operation = REQ_DISCARD;
+		nseg = 0; /* The nr_segments and flag share the same space. */
 		break;
 	default:
 		operation = 0; /* make gcc happy */
@@ -643,8 +650,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		break;
 	}
 
-	/* Check that the number of segments is sane. */
-	nseg = req->nr_segments;
 	if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
 				operation != REQ_DISCARD) ||
 	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index e638457..c6a5462 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -76,7 +76,10 @@ struct blkif_x86_32_request_discard {
 
 struct blkif_x86_32_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
+	union {
+		uint8_t	nr_segments; /* number of segments                   */
+		uint8_t flag;        /* flag for blkif_x86_32_request_discard*/
+	} u1;
 	blkif_vdev_t   handle;       /* only for read/write requests         */
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	union {
@@ -105,7 +108,10 @@ struct blkif_x86_64_request_discard {
 
 struct blkif_x86_64_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
+	union {
+		uint8_t	nr_segments; /* number of segments                   */
+		uint8_t flag;        /* for blkif_x86_64_request_discard     */
+	} u1;
 	blkif_vdev_t   handle;       /* only for read/write requests         */
 	uint64_t       __attribute__((__aligned__(8))) id;
 	union {
@@ -157,6 +163,7 @@ struct xen_vbd {
 	/* Cached size parameter. */
 	sector_t		size;
 	bool			flush_support;
+	bool			discard_secure;
 };
 
 struct backend_info;
@@ -241,7 +248,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 {
 	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
 	dst->operation = src->operation;
-	dst->nr_segments = src->nr_segments;
+	dst->u1.nr_segments = src->u1.nr_segments;
 	dst->handle = src->handle;
 	dst->id = src->id;
 	switch (src->operation) {
@@ -251,14 +258,16 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		dst->u.rw.sector_number = src->u.rw.sector_number;
 		barrier();
-		if (n > dst->nr_segments)
-			n = dst->nr_segments;
+		if (n > dst->u1.nr_segments)
+			n = dst->u1.nr_segments;
 		for (i = 0; i < n; i++)
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
+		/* We should be doing "dst->u1.flag = src->u1.flag;" but the
+		 * copying of u1.nr_segments does it for us already. */
 		break;
 	default:
 		break;
@@ -270,7 +279,7 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 {
 	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
 	dst->operation = src->operation;
-	dst->nr_segments = src->nr_segments;
+	dst->u1.nr_segments = src->u1.nr_segments;
 	dst->handle = src->handle;
 	dst->id = src->id;
 	switch (src->operation) {
@@ -280,14 +289,16 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		dst->u.rw.sector_number = src->u.rw.sector_number;
 		barrier();
-		if (n > dst->nr_segments)
-			n = dst->nr_segments;
+		if (n > dst->u1.nr_segments)
+			n = dst->u1.nr_segments;
 		for (i = 0; i < n; i++)
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
+		/* We should be doing "dst->u1.flag = src->u1.flag;" but the
+		 * copying of u1.nr_segments does it for us already. */
 		break;
 	default:
 		break;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a6d4303..0c0ce39 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -378,6 +378,9 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (q && q->flush_flags)
 		vbd->flush_support = true;
 
+	if (q && blk_queue_secdiscard(q))
+		vbd->discard_secure = true;
+
 	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
@@ -460,6 +463,15 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 				state = 1;
 				blkif->blk_backend_type = BLKIF_BACKEND_PHY;
 			}
+			/* Optional. */
+			err = xenbus_printf(xbt, dev->nodename,
+				"discard-secure", "%d",
+				blkif->vbd.discard_secure);
+			if (err) {
+				xenbus_dev_fatal(dev, err,
+					"writting discard-secure");
+				goto kfree;
+			}
 		}
 	} else {
 		err = PTR_ERR(type);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 7b2ec59..f7e6ca5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -98,7 +98,8 @@ struct blkfront_info
 	unsigned long shadow_free;
 	unsigned int feature_flush;
 	unsigned int flush_op;
-	unsigned int feature_discard;
+	unsigned int feature_discard:1;
+	unsigned int feature_secdiscard:1;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	int is_ready;
@@ -305,16 +306,19 @@ static int blkif_queue_request(struct request *req)
 		ring_req->operation = info->flush_op;
 	}
 
-	if (unlikely(req->cmd_flags & REQ_DISCARD)) {
+	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
 		/* id, sector_number and handle are set above. */
 		ring_req->operation = BLKIF_OP_DISCARD;
-		ring_req->nr_segments = 0;
+		ring_req->u1.flag = 0;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
+		if ((req->cmd_flags & REQ_SECURE) && info->feature_secdiscard)
+			ring_req->u1.flag = BLKIF_OP_DISCARD_FLAG_SECURE;
 	} else {
-		ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
-		BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
+		ring_req->u1.nr_segments = blk_rq_map_sg(req->q, req, info->sg);
+		BUG_ON(ring_req->u1.nr_segments >
+			BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
-		for_each_sg(info->sg, sg, ring_req->nr_segments, i) {
+		for_each_sg(info->sg, sg, ring_req->u1.nr_segments, i) {
 			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
@@ -424,6 +428,8 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 		blk_queue_max_discard_sectors(rq, get_capacity(gd));
 		rq->limits.discard_granularity = info->discard_granularity;
 		rq->limits.discard_alignment = info->discard_alignment;
+		if (info->feature_secdiscard)
+			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, rq);
 	}
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
@@ -705,7 +711,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 static void blkif_completion(struct blk_shadow *s)
 {
 	int i;
-	for (i = 0; i < s->req.nr_segments; i++)
+	for (i = 0; i < s->req.u1.nr_segments; i++)
 		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
 }
 
@@ -749,7 +755,9 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 					   info->gd->disk_name);
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
+				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
+				queue_flag_clear(QUEUE_FLAG_SECDISCARD, rq);
 			}
 			__blk_end_request_all(req, error);
 			break;
@@ -763,7 +771,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
-				     info->shadow[id].req.nr_segments == 0)) {
+				info->shadow[id].req.u1.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
 				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
 				       "barrier" :  "flush disk cache",
@@ -1038,7 +1046,7 @@ static int blkif_recover(struct blkfront_info *info)
 		memcpy(&info->shadow[req->id], &copy[i], sizeof(copy[i]));
 
 		/* Rewrite any grant references invalidated by susp/resume. */
-		for (j = 0; j < req->nr_segments; j++)
+		for (j = 0; j < req->u1.nr_segments; j++)
 			gnttab_grant_foreign_access_ref(
 				req->u.rw.seg[j].gref,
 				info->xbdev->otherend_id,
@@ -1135,11 +1143,13 @@ static void blkfront_setup_discard(struct blkfront_info *info)
 	char *type;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
+	unsigned int discard_secure;
 
 	type = xenbus_read(XBT_NIL, info->xbdev->otherend, "type", NULL);
 	if (IS_ERR(type))
 		return;
 
+	info->feature_secdiscard = 0;
 	if (strncmp(type, "phy", 3) == 0) {
 		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			"discard-granularity", "%u", &discard_granularity,
@@ -1150,6 +1160,12 @@ static void blkfront_setup_discard(struct blkfront_info *info)
 			info->discard_granularity = discard_granularity;
 			info->discard_alignment = discard_alignment;
 		}
+		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "discard-secure", "%d", &discard_secure,
+			    NULL);
+		if (!err)
+			info->feature_secdiscard = discard_secure;
+
 	} else if (strncmp(type, "file", 4) == 0)
 		info->feature_discard = 1;
 
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 9324488..4a01e71 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -84,6 +84,20 @@ typedef uint64_t blkif_sector_t;
  *     e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc
  * http://www.seagate.com/staticfiles/support/disc/manuals/
  *     Interface%20manuals/100293068c.pdf
+ * The backend can optionally provide three extra XenBus attributes to
+ * further optimize the discard functionality:
+ * 'discard-aligment' - Devices that support discard functionality may
+ * internally allocate space in units that are bigger than the exported
+ * logical block size. The discard-alignment parameter indicates how many bytes
+ * the beginning of the partition is offset from the internal allocation unit's
+ * natural alignment.
+ * 'discard-granularity'  - Devices that support discard functionality may
+ * internally allocate space using units that are bigger than the logical block
+ * size. The discard-granularity parameter indicates the size of the internal
+ * allocation unit in bytes if reported by the device. Otherwise the
+ * discard-granularity will be set to match the device's physical block size.
+ * 'discard-secure' - All copies of the discarded sectors (potentially created
+ * by garbage collection) must also be erased.
  */
 #define BLKIF_OP_DISCARD           5
 
@@ -111,7 +125,11 @@ struct blkif_request_discard {
 
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
-	uint8_t        nr_segments;  /* number of segments                   */
+	union {
+		uint8_t nr_segments; /* number of segments                   */
+		uint8_t	flag;        /* flag for blkif_request_discard       */
+#define BLKIF_OP_DISCARD_FLAG_SECURE	(1<<0) /* ignored if discard-secure=0 */
+	} u1;
 	blkif_vdev_t   handle;       /* only for read/write requests         */
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	union {

