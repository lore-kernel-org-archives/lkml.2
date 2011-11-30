Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1K3SQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:16:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40524 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1K3SQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:16:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, lidongyang@novell.com, JBeulich@novell.com
Cc: axboe@kernel.dk, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/blk[front|back]: Enhance discard support with secure erasing support.
Date: Wed, 30 Nov 2011 13:15:54 -0500
Message-Id: <1322676956-15691-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
References: <1322676956-15691-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ED672FD.0085,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the blkdev_issue_discard(xx) operation is that it can also
issue a secure discard operation that will permanantly remove the
sectors in question. We advertise that we can support that via the
'discard-secure' attribute and on the request, if the 'secure' bit
is set, we will attempt to pass in REQ_DISCARD | REQ_SECURE.

CC: Li Dongyang <lidongyang@novell.com>
[v1: Used 'flag' instead of 'secure:1' bit]
[v2: Use 'reserved' uint8_t instead of adding a new value]
[v3: Check for nseg when mapping instead of operation]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   18 ++++++++++-----
 drivers/block/xen-blkback/common.h  |    7 ++++-
 drivers/block/xen-blkback/xenbus.c  |   12 ++++++++++
 drivers/block/xen-blkfront.c        |   41 ++++++++++++++++++++++++++--------
 include/xen/interface/io/blkif.h    |   18 ++++++++++++++-
 5 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index d7104ab..9d2261b 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -422,13 +422,16 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 
-	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY)
+	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
+		unsigned long secure = (blkif->vbd.discard_secure &&
+			(req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
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
@@ -643,8 +646,11 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		break;
 	}
 
-	/* Check that the number of segments is sane. */
-	nseg = req->u.rw.nr_segments;
+	if (unlikely(operation == REQ_DISCARD))
+		nseg = 0;
+	else
+		/* Check that the number of segments is sane. */
+		nseg = req->u.rw.nr_segments;
 
 	if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
 				operation != REQ_DISCARD) ||
@@ -708,7 +714,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (operation != REQ_DISCARD && xen_blkbk_map(req, pending_req, seg))
+	if (nseg && xen_blkbk_map(req, pending_req, seg))
 		goto fail_flush;
 
 	/*
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index dbfe7b3..d0ee7ed 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -69,7 +69,7 @@ struct blkif_x86_32_request_rw {
 } __attribute__((__packed__));
 
 struct blkif_x86_32_request_discard {
-	uint8_t        nr_segments;  /* number of segments                   */
+	uint8_t        flag;         /* BLKIF_DISCARD_SECURE or zero         */
 	blkif_vdev_t   _pad1;        /* was "handle" for read/write requests */
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
@@ -104,7 +104,7 @@ struct blkif_x86_64_request_rw {
 } __attribute__((__packed__));
 
 struct blkif_x86_64_request_discard {
-	uint8_t        nr_segments;  /* number of segments                   */
+	uint8_t        flag;         /* BLKIF_DISCARD_SECURE or zero         */
 	blkif_vdev_t   _pad1;        /* was "handle" for read/write requests */
         uint32_t       _pad2;        /* offsetof(blkif_..,u.discard.id)==8   */
 	uint64_t       id;
@@ -164,6 +164,7 @@ struct xen_vbd {
 	/* Cached size parameter. */
 	sector_t		size;
 	bool			flush_support;
+	bool			discard_secure;
 };
 
 struct backend_info;
@@ -261,6 +262,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
 	case BLKIF_OP_DISCARD:
+		dst->u.discard.flag = src->u.discard.flag;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
@@ -290,6 +292,7 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 			dst->u.rw.seg[i] = src->u.rw.seg[i];
 		break;
 	case BLKIF_OP_DISCARD:
+		dst->u.discard.flag = src->u.discard.flag;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f759ad4..187fd2c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -338,6 +338,9 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (q && q->flush_flags)
 		vbd->flush_support = true;
 
+	if (q && blk_queue_secdiscard(q))
+		vbd->discard_secure = true;
+
 	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
@@ -420,6 +423,15 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
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
index 2c2c4be..351ddef 100644
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
@@ -305,11 +306,14 @@ static int blkif_queue_request(struct request *req)
 		ring_req->operation = info->flush_op;
 	}
 
-	if (unlikely(req->cmd_flags & REQ_DISCARD)) {
+	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
 		/* id, sector_number and handle are set above. */
 		ring_req->operation = BLKIF_OP_DISCARD;
-		ring_req->u.discard.nr_segments = 0;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
+		if ((req->cmd_flags & REQ_SECURE) && info->feature_secdiscard)
+			ring_req->u.discard.flag = BLKIF_DISCARD_SECURE;
+		else
+			ring_req->u.discard.flag = 0;
 	} else {
 		ring_req->u.rw.nr_segments = blk_rq_map_sg(req->q, req,
 							   info->sg);
@@ -426,6 +430,8 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 		blk_queue_max_discard_sectors(rq, get_capacity(gd));
 		rq->limits.discard_granularity = info->discard_granularity;
 		rq->limits.discard_alignment = info->discard_alignment;
+		if (info->feature_secdiscard)
+			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, rq);
 	}
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
@@ -707,6 +713,8 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 static void blkif_completion(struct blk_shadow *s)
 {
 	int i;
+	/* Do not let BLKIF_OP_DISCARD as nr_segment is in the same place
+	 * flag. */
 	for (i = 0; i < s->req.u.rw.nr_segments; i++)
 		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
 }
@@ -738,7 +746,8 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		id   = bret->id;
 		req  = info->shadow[id].request;
 
-		blkif_completion(&info->shadow[id]);
+		if (bret->operation != BLKIF_OP_DISCARD)
+			blkif_completion(&info->shadow[id]);
 
 		add_id_to_freelist(info, id);
 
@@ -751,7 +760,9 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 					   info->gd->disk_name);
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
+				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
+				queue_flag_clear(QUEUE_FLAG_SECDISCARD, rq);
 			}
 			__blk_end_request_all(req, error);
 			break;
@@ -1039,13 +1050,15 @@ static int blkif_recover(struct blkfront_info *info)
 		req->u.rw.id = get_id_from_freelist(info);
 		memcpy(&info->shadow[req->u.rw.id], &copy[i], sizeof(copy[i]));
 
+		if (req->operation != BLKIF_OP_DISCARD) {
 		/* Rewrite any grant references invalidated by susp/resume. */
-		for (j = 0; j < req->u.rw.nr_segments; j++)
-			gnttab_grant_foreign_access_ref(
-				req->u.rw.seg[j].gref,
-				info->xbdev->otherend_id,
-				pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
-				rq_data_dir(info->shadow[req->u.rw.id].request));
+			for (j = 0; j < req->u.rw.nr_segments; j++)
+				gnttab_grant_foreign_access_ref(
+					req->u.rw.seg[j].gref,
+					info->xbdev->otherend_id,
+					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
+					rq_data_dir(info->shadow[req->u.rw.id].request));
+		}
 		info->shadow[req->u.rw.id].req = *req;
 
 		info->ring.req_prod_pvt++;
@@ -1137,11 +1150,13 @@ static void blkfront_setup_discard(struct blkfront_info *info)
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
@@ -1152,6 +1167,12 @@ static void blkfront_setup_discard(struct blkfront_info *info)
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
index f88e28b..ee338bf 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -84,6 +84,21 @@ typedef uint64_t blkif_sector_t;
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
+ * by garbage collection) must also be erased.  To use this feature, the flag
+ * BLKIF_DISCARD_SECURE must be set in the blkif_request_trim.
  */
 #define BLKIF_OP_DISCARD           5
 
@@ -111,7 +126,8 @@ struct blkif_request_rw {
 } __attribute__((__packed__));
 
 struct blkif_request_discard {
-	uint8_t        nr_segments;  /* number of segments                   */
+	uint8_t        flag;         /* BLKIF_DISCARD_SECURE or zero.        */
+#define BLKIF_DISCARD_SECURE (1<<0)  /* ignored if discard-secure=0          */
 	blkif_vdev_t   _pad1;        /* only for read/write requests         */
 #ifdef CONFIG_X86_64
 	uint32_t       _pad2;        /* offsetof(blkif_req..,u.discard.id)==8*/
-- 
1.7.7.3

