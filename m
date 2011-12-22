Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1LVL3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab1LVL3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:29:06 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v6 08/11] virtio: net: Move vq and vq buf removal into separate function
Date: Thu, 22 Dec 2011 16:58:32 +0530
Message-Id: <96738116f38b183689b9c35d912a3bd8d2376ce5.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove and PM freeze functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec8c400..7a2a5bf 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1134,22 +1134,26 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	BUG_ON(vi->num != 0);
 }
 
-static void __devexit virtnet_remove(struct virtio_device *vdev)
+static void remove_vq_common(struct virtnet_info *vi)
 {
-	struct virtnet_info *vi = vdev->priv;
-
-	/* Stop all the virtqueues. */
-	vdev->config->reset(vdev);
-
-	unregister_netdev(vi->dev);
+	vi->vdev->config->reset(vi->vdev);
 
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
1.7.7.4

