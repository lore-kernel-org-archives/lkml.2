Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab2CMW41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:56:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25695 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760063Ab2CMW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:56:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Li Dongyang <lidongyang@novell.com>
Subject: [PATCH] xen/blkback: Squash the discard support for 'file' and 'phy' type.
Date: Tue, 13 Mar 2012 18:52:08 -0400
Message-Id: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F5FD091.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason for the distinction was for the special case of
'file' (which is assumed to be loopback device), was to reach inside
the loopback device, find the underlaying file, and call fallocate on it.
Fortunately "xen-blkback: convert hole punching to discard request on
loop devices" removes that use-case and we now based the discard
support based on blk_queue_discard(q) and extract all appropriate
parameters from the 'struct request_queue'.

CC: Li Dongyang <lidongyang@novell.com>
CC: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   20 ++++------
 drivers/block/xen-blkback/common.h  |    6 ---
 drivers/block/xen-blkback/xenbus.c  |   67 +++++++++++++---------------------
 3 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 0088bf6..1a83f39 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -419,21 +419,17 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	int err = 0;
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
-
+	unsigned long secure = 0;
 	blkif->st_ds_req++;
 
 	xen_blkif_get(blkif);
-	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY ||
-	    blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
-		unsigned long secure = (blkif->vbd.discard_secure &&
-			(req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
-			BLKDEV_DISCARD_SECURE : 0;
-		err = blkdev_issue_discard(bdev,
-				req->u.discard.sector_number,
-				req->u.discard.nr_sectors,
-				GFP_KERNEL, secure);
-	} else
-		err = -EOPNOTSUPP;
+	secure = (blkif->vbd.discard_secure &&
+		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
+		 BLKDEV_DISCARD_SECURE : 0;
+
+	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
+				   req->u.discard.nr_sectors,
+				   GFP_KERNEL, secure);
 
 	if (err == -EOPNOTSUPP) {
 		pr_debug(DRV_PFX "discard op failed, not supported\n");
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index d0ee7ed..773cf27 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -146,11 +146,6 @@ enum blkif_protocol {
 	BLKIF_PROTOCOL_X86_64 = 3,
 };
 
-enum blkif_backend_type {
-	BLKIF_BACKEND_PHY  = 1,
-	BLKIF_BACKEND_FILE = 2,
-};
-
 struct xen_vbd {
 	/* What the domain refers to this vbd as. */
 	blkif_vdev_t		handle;
@@ -177,7 +172,6 @@ struct xen_blkif {
 	unsigned int		irq;
 	/* Comms information. */
 	enum blkif_protocol	blk_protocol;
-	enum blkif_backend_type blk_backend_type;
 	union blkif_back_rings	blk_rings;
 	void			*blk_ring;
 	/* The VBD attached to this interface. */
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 24a2fb5..9aad6de 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -393,52 +393,37 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 	char *type;
 	int err;
 	int state = 0;
+	struct block_device *bdev = be->blkif->vbd.bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
 
-	type = xenbus_read(XBT_NIL, dev->nodename, "type", NULL);
-	if (!IS_ERR(type)) {
-		if (strncmp(type, "file", 4) == 0) {
-			state = 1;
-			blkif->blk_backend_type = BLKIF_BACKEND_FILE;
+	if (blk_queue_discard(q)) {
+		err = xenbus_printf(xbt, dev->nodename,
+			"discard-granularity", "%u",
+			q->limits.discard_granularity);
+		if (err) {
+			xenbus_dev_fatal(dev, err,
+				"writing discard-granularity");
+			goto kfree;
+		}
+		err = xenbus_printf(xbt, dev->nodename,
+			"discard-alignment", "%u",
+			q->limits.discard_alignment);
+		if (err) {
+			xenbus_dev_fatal(dev, err,
+				"writing discard-alignment");
+			goto kfree;
 		}
-		if (strncmp(type, "phy", 3) == 0) {
-			struct block_device *bdev = be->blkif->vbd.bdev;
-			struct request_queue *q = bdev_get_queue(bdev);
-			if (blk_queue_discard(q)) {
-				err = xenbus_printf(xbt, dev->nodename,
-					"discard-granularity", "%u",
-					q->limits.discard_granularity);
-				if (err) {
-					xenbus_dev_fatal(dev, err,
-						"writing discard-granularity");
-					goto kfree;
-				}
-				err = xenbus_printf(xbt, dev->nodename,
-					"discard-alignment", "%u",
-					q->limits.discard_alignment);
-				if (err) {
-					xenbus_dev_fatal(dev, err,
-						"writing discard-alignment");
-					goto kfree;
-				}
-				state = 1;
-				blkif->blk_backend_type = BLKIF_BACKEND_PHY;
-			}
-			/* Optional. */
-			err = xenbus_printf(xbt, dev->nodename,
-				"discard-secure", "%d",
-				blkif->vbd.discard_secure);
-			if (err) {
-				xenbus_dev_fatal(dev, err,
+		state = 1;
+		/* Optional. */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "discard-secure", "%d",
+				    blkif->vbd.discard_secure);
+		if (err) {
+			xenbus_dev_fatal(dev, err,
 					"writting discard-secure");
-				goto kfree;
-			}
+			goto kfree;
 		}
-	} else {
-		err = PTR_ERR(type);
-		xenbus_dev_fatal(dev, err, "reading type");
-		goto out;
 	}
-
 	err = xenbus_printf(xbt, dev->nodename, "feature-discard",
 			    "%d", state);
 	if (err)
-- 
1.7.9.48.g85da4d

