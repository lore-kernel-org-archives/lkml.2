Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1LOMrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:47:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab1LOMrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:47:12 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v5 08/11] virtio: net: Move vq and vq buf removal into separate function
Date: Thu, 15 Dec 2011 18:15:54 +0530
Message-Id: <7b3b395af6da6b459245ca67755932f1dd2d6496.1323952934.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove and PM freeze functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6baa563..697a0fc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1123,24 +1123,29 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	BUG_ON(vi->num != 0);
 }
 
-static void __devexit virtnet_remove(struct virtio_device *vdev)
+static void remove_vq_common(struct virtnet_info *vi)
 {
-	struct virtnet_info *vi = vdev->priv;
-
 	/* Stop all the virtqueues. */
-	vdev->config->reset(vdev);
-
+	vi->vdev->config->reset(vi->vdev);
 
-	unregister_netdev(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
 
 	/* Free unused buffers in both send and recv, if any. */
 	free_unused_bufs(vi);
 
-	vdev->config->del_vqs(vi->vdev);
+	vi->vdev->config->del_vqs(vi->vdev);
 
 	while (vi->pages)
 		__free_pages(get_a_page(vi, GFP_KERNEL), 0);
+}
+
+static void __devexit virtnet_remove(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	unregister_netdev(vi->dev);
+
+	remove_vq_common(vi);
 
 	free_percpu(vi->stats);
 	free_netdev(vi->dev);
-- 
1.7.7.3

