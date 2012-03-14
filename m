Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030993Ab2CNSOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:14:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36352 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030971Ab2CNSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:14:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBeulich@suse.com, linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Li Dongyang <lidongyang@novell.com>
Subject: [PATCH 1/2] xen/blkback: Squash the discard support for 'file' and 'phy' type.
Date: Wed, 14 Mar 2012 14:10:30 -0400
Message-Id: <1331748631-4022-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
References: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020201.4F60E012.01A8,ss=1,re=0.000,fgs=0
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
Acked-by: Jan Beulich <JBeulich@suse.com>
[v1: Dropping pointless initializer and keeping blank line]
[v2: Remove the kfree as it is not used anymore]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   19 ++++-----
 drivers/block/xen-blkback/common.h  |    6 ---
 drivers/block/xen-blkback/xenbus.c  |   70 +++++++++++++----------------------
 3 files changed, 34 insertions(+), 61 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 70caa89..73f196c 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -398,21 +398,18 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	int err = 0;
 	int status = BLKIF_RSP_OKAY;
 	struct block_device *bdev = blkif->vbd.bdev;
+	unsigned long secure;
 
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
index 24a2fb5..d417c13 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -390,61 +390,43 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 {
 	struct xenbus_device *dev = be->dev;
 	struct xen_blkif *blkif = be->blkif;
-	char *type;
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
+			goto out;
+		}
+		err = xenbus_printf(xbt, dev->nodename,
+			"discard-alignment", "%u",
+			q->limits.discard_alignment);
+		if (err) {
+			xenbus_dev_fatal(dev, err,
+				"writing discard-alignment");
+			goto out;
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
+			goto out;
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
 		xenbus_dev_fatal(dev, err, "writing feature-discard");
-kfree:
-	kfree(type);
 out:
 	return err;
 }
-- 
1.7.9.48.g85da4d

