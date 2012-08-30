Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2H3AZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 20:25:05 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:59922 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab2H3AZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 20:25:02 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH] rpmsg: use right device paramter when calling dma_free_coherent function
Date: Wed, 29 Aug 2012 19:24:52 -0500
Message-Id: <1346286292-21773-1-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_alloc/free_coherent APIs requires the platform specific remoteproc
device as the device parameter. We are passing vdev->dev.parent to the
dma_free_coherent function which is the generic rproc device and it is
wrong, it has to be vdev->dev.parent->parent instead, same as when we
call dma_alloc_coherent function.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 590cfaf..1859f71 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1008,8 +1008,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 	return 0;
 
 free_coherent:
-	dma_free_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE, bufs_va,
-					vrp->bufs_dma);
+	dma_free_coherent(vdev->dev.parent->parent, RPMSG_TOTAL_BUF_SPACE,
+					bufs_va, vrp->bufs_dma);
 vqs_del:
 	vdev->config->del_vqs(vrp->vdev);
 free_vrp:
@@ -1043,7 +1043,7 @@ static void __devexit rpmsg_remove(struct virtio_device *vdev)
 
 	vdev->config->del_vqs(vrp->vdev);
 
-	dma_free_coherent(vdev->dev.parent, RPMSG_TOTAL_BUF_SPACE,
+	dma_free_coherent(vdev->dev.parent->parent, RPMSG_TOTAL_BUF_SPACE,
 					vrp->rbufs, vrp->bufs_dma);
 
 	kfree(vrp);
-- 
1.7.1

