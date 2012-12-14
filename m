Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2LNQIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:08:00 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45687 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2LNQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:56 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 11/11] remoteproc: Support virtio config space.
Date: Fri, 14 Dec 2012 17:07:00 +0100
Message-Id: <1355501220-4572-12-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support virtio configuration space and device status and
feature negotiation with remote device. This virtio device
can now access the resource table in shared memory.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c   |   10 ++++------
 drivers/remoteproc/remoteproc_virtio.c |   30 +++++++++++++++++++++++++++---
 include/linux/remoteproc.h             |    2 --
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index f95c08c..d59c4cf 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -364,13 +364,8 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			goto free_rvdev;
 	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
-
 	/* remember the device resource entry number */
 	rvdev->rsc_seqno = seqno;
-	/* remember the resource entry */
-	rvdev->rsc = rsc;
 
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
@@ -394,8 +389,11 @@ static int rproc_register_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	dev_dbg(&rproc->dev, "register device %s\n", rproc->name);
 
 	list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
-		if (seqno == rvdev->rsc_seqno)
+		if (seqno == rvdev->rsc_seqno) {
+			/* remember the resource entry */
+			rvdev->rsc = rsc;
 			return rproc_add_virtio_dev(rvdev, rsc->id);
+		}
 
 	return -ENODEV;
 }
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index e7a4780..9ebc5d9 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -176,16 +176,21 @@ error:
  */
 static u8 rproc_virtio_get_status(struct virtio_device *vdev)
 {
-	return 0;
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	return rvdev->rsc->status;
 }
 
 static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	rvdev->rsc->status = status;
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
 static void rproc_virtio_reset(struct virtio_device *vdev)
 {
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	rvdev->rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
 }
 
@@ -194,7 +199,7 @@ static u32 rproc_virtio_get_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 
-	return rvdev->dfeatures;
+	return rvdev->rsc->dfeatures;
 }
 
 static void rproc_virtio_finalize_features(struct virtio_device *vdev)
@@ -213,7 +218,23 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	 * fixed as part of a small resource table overhaul and then an
 	 * extension of the virtio resource entries.
 	 */
-	rvdev->gfeatures = vdev->features[0];
+	rvdev->rsc->gfeatures = vdev->features[0];
+}
+
+void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
+							void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
+	memcpy(buf, cfg + offset, len);
+}
+
+void rproc_virtio_set(struct virtio_device *vdev, unsigned offset,
+		      const void *buf, unsigned len)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
+	memcpy(cfg + offset, buf, len);
 }
 
 static struct virtio_config_ops rproc_virtio_config_ops = {
@@ -224,6 +245,9 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 	.reset		= rproc_virtio_reset,
 	.set_status	= rproc_virtio_set_status,
 	.get_status	= rproc_virtio_get_status,
+	.get		= rproc_virtio_get,
+	.set		= rproc_virtio_set,
+
 };
 
 /*
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 60a1002..de20e39 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -473,8 +473,6 @@ struct rproc_vdev {
 	struct rproc *rproc;
 	struct virtio_device vdev;
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
-	unsigned long dfeatures;
-	unsigned long gfeatures;
 	u32 rsc_seqno;
 	struct fw_rsc_vdev *rsc;
 };
-- 
1.7.5.4

