Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768145Ab2KOPg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:36:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55176 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767939Ab2KOPgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:36:55 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc: fix error path of ->find_vqs
Date: Thu, 15 Nov 2012 17:36:48 +0200
Message-Id: <1352993808-23212-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.10.rc3.1067.gb129051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate an erroneous invocation of rproc_shutdown inside
the error path of rproc_virtio_find_vqs.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_virtio.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index e7a4780..9e198e5 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -120,15 +120,11 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	return vq;
 }
 
-static void rproc_virtio_del_vqs(struct virtio_device *vdev)
+static void __rproc_virtio_del_vqs(struct virtio_device *vdev)
 {
 	struct virtqueue *vq, *n;
-	struct rproc *rproc = vdev_to_rproc(vdev);
 	struct rproc_vring *rvring;
 
-	/* power down the remote processor before deleting vqs */
-	rproc_shutdown(rproc);
-
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		rvring = vq->priv;
 		rvring->vq = NULL;
@@ -137,6 +133,16 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 	}
 }
 
+static void rproc_virtio_del_vqs(struct virtio_device *vdev)
+{
+	struct rproc *rproc = vdev_to_rproc(vdev);
+
+	/* power down the remote processor before deleting vqs */
+	rproc_shutdown(rproc);
+
+	__rproc_virtio_del_vqs(vdev);
+}
+
 static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
@@ -163,7 +169,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	return 0;
 
 error:
-	rproc_virtio_del_vqs(vdev);
+	__rproc_virtio_del_vqs(vdev);
 	return ret;
 }
 
-- 
1.7.10.rc3.1067.gb129051

