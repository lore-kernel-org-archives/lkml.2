Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947059Ab2LFTfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:35:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47724 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556Ab2LFTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:45 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 5/5] remoteproc: Support virtio config space.
Date: Thu,  6 Dec 2012 20:35:24 +0100
Message-Id: <1354822524-4497-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for bi-directional virtio configuration space,
visibility of device status to remote processor and
device feature-bit negotiation with remote device.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c   |    4 ++--
 drivers/remoteproc/remoteproc_virtio.c |   30 +++++++++++++++++++++++++++---
 include/linux/remoteproc.h             |    3 +--
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index e407197..5f99587 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -362,8 +362,8 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			goto free_rvdev;
 	}
 
-	/* remember the device features */
-	rvdev->dfeatures = rsc->dfeatures;
+	/* remember the vring resource address */
+	rvdev->rsc = rsc;
 
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
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
index 17b8120..39ce14e 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -471,8 +471,7 @@ struct rproc_vdev {
 	struct rproc *rproc;
 	struct virtio_device vdev;
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
-	unsigned long dfeatures;
-	unsigned long gfeatures;
+	struct fw_rsc_vdev *rsc;
 };
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-- 
1.7.9.5

