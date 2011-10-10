Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab1JJR7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:59:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17773 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1JJR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:59:08 -0400
Date: Mon, 10 Oct 2011 13:53:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111010175323.GA31210@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010164250.GG28646@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090207.4E933264.0044,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think an explicit flag variable is likely to be less trouble WRT
> > maintaining compatibility in the future than a bit-field. Also I think
> > you may as well align the struct size to something larger than a byte,
> > either 4 or 8 bytes would make sense.
> 
> Ok. Will change it and make it an uint64_t secure_flag
> variable. Later on if there are any "other" flags we can chop it down.

New patch (it also looks like the patch I sent to xen-devel to update
the blkif.h was never merged) - so let me send right now.

BTW, it seems that the #pragma pack(push, 4) is used in the
drivers/block/xen-blkback/common.h to compact the structures already so
I don't think we need the aligment.


>From f74cc58b77c2a1c1a93c0324a50b9d1b9a0cb159 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 10 Oct 2011 10:58:40 -0400
Subject: [PATCH] xen/blk[front|back]: Enhance discard support with secure
 erasing support.

Part of the blkdev_issue_discard(xx) operation is that it can also
issue a secure discard operation that will permanantly remove the
sectors in question. We advertise that we can support that via the
'discard-secure' attribute and on the request, if the 'secure' bit
is set, we will attempt to pass in REQ_DISCARD | REQ_SECURE.

CC: Li Dongyang <lidongyang@novell.com>
[v1: Used 'flag' instead of 'secure:1' bit]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    9 ++++++---
 drivers/block/xen-blkback/common.h  |    5 +++++
 drivers/block/xen-blkback/xenbus.c  |   12 ++++++++++++
 drivers/block/xen-blkfront.c        |   19 +++++++++++++++++--
 include/xen/interface/io/blkif.h    |    6 ++++++
 5 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index ca23dff..5ccb648 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -422,13 +422,16 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
 
-	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY)
+	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
+		unsigned long secure = (blkif->vbd.discard_secure &&
+			(req->u.discard.flag & BLKIF_OP_DISCARD_FLAG_SECURE)) ?
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
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index e638457..43b72a7 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -72,6 +72,7 @@ struct blkif_x86_32_request_rw {
 struct blkif_x86_32_request_discard {
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	uint64_t nr_sectors;
+	uint32_t flag;
 };
 
 struct blkif_x86_32_request {
@@ -101,6 +102,7 @@ struct blkif_x86_64_request_rw {
 struct blkif_x86_64_request_discard {
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	uint64_t nr_sectors;
+	uint32_t flag;
 };
 
 struct blkif_x86_64_request {
@@ -157,6 +159,7 @@ struct xen_vbd {
 	/* Cached size parameter. */
 	sector_t		size;
 	bool			flush_support;
+	bool			discard_secure;
 };
 
 struct backend_info;
@@ -259,6 +262,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
+		dst->u.discard.flag = src->u.discard.flag;
 		break;
 	default:
 		break;
@@ -288,6 +292,7 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
+		dst->u.discard.flag = src->u.discard.flag;
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
index 7b2ec59..807b7b6 100644
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
@@ -305,11 +306,13 @@ static int blkif_queue_request(struct request *req)
 		ring_req->operation = info->flush_op;
 	}
 
-	if (unlikely(req->cmd_flags & REQ_DISCARD)) {
+	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
 		/* id, sector_number and handle are set above. */
 		ring_req->operation = BLKIF_OP_DISCARD;
 		ring_req->nr_segments = 0;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
+		if ((req->cmd_flags & REQ_SECURE) && info->feature_secdiscard)
+			ring_req->u.discard.flag = BLKIF_OP_DISCARD_FLAG_SECURE;
 	} else {
 		ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
 		BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
@@ -424,6 +427,8 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 		blk_queue_max_discard_sectors(rq, get_capacity(gd));
 		rq->limits.discard_granularity = info->discard_granularity;
 		rq->limits.discard_alignment = info->discard_alignment;
+		if (info->feature_secdiscard)
+			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, rq);
 	}
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
@@ -749,7 +754,9 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 					   info->gd->disk_name);
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
+				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
+				queue_flag_clear(QUEUE_FLAG_SECDISCARD, rq);
 			}
 			__blk_end_request_all(req, error);
 			break;
@@ -1135,11 +1142,13 @@ static void blkfront_setup_discard(struct blkfront_info *info)
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
@@ -1150,6 +1159,12 @@ static void blkfront_setup_discard(struct blkfront_info *info)
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
index 9324488..13d040e 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -84,6 +84,10 @@ typedef uint64_t blkif_sector_t;
  *     e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc
  * http://www.seagate.com/staticfiles/support/disc/manuals/
  *     Interface%20manuals/100293068c.pdf
+ * We also provide three extra XenBus options to the discard operation:
+ * 'discard-granularity' - Max amount of sectors that can be discarded.
+ * 'discard-alignment' - 4K, 128K, etc aligment on sectors to erased.
+ * 'discard-secure' - whether the discard can also securely erase data.
  */
 #define BLKIF_OP_DISCARD           5
 
@@ -107,6 +111,8 @@ struct blkif_request_rw {
 struct blkif_request_discard {
 	blkif_sector_t sector_number;
 	uint64_t nr_sectors;
+#define BLKIF_OP_DISCARD_FLAG_SECURE	(1<<1) /* ignored if discard-secure=0 */
+	uint32_t flag;
 };
 
 struct blkif_request {
-- 
1.7.5.4

