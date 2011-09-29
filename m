Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1I2P1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:27:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337Ab1I2P1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:27:04 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 11/11] virtio: balloon: Add freeze, restore handlers to support S4
Date: Thu, 29 Sep 2011 20:56:07 +0530
Message-Id: <e69775286e34e88ff5c7ad50ede4fafdd5f16087.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the vqs on the freeze callback to prepare for hibernation.
Re-create the vqs in the restore callback to resume normal function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_balloon.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 571d443..3ff955f9 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -362,6 +362,19 @@ static void __devexit virtballoon_remove(struct virtio_device *vdev)
 	kfree(vb);
 }
 
+#ifdef CONFIG_PM
+static int virtballoon_freeze(struct virtio_device *vdev)
+{
+	vdev->config->del_vqs(vdev);
+	return 0;
+}
+
+static int virtballoon_restore(struct virtio_device *vdev)
+{
+	return init_vqs(vdev->priv);
+}
+#endif
+
 static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
@@ -376,6 +389,10 @@ static struct virtio_driver virtio_balloon_driver = {
 	.probe =	virtballoon_probe,
 	.remove =	__devexit_p(virtballoon_remove),
 	.config_changed = virtballoon_changed,
+#ifdef CONFIG_PM
+	.freeze	=	virtballoon_freeze,
+	.restore =	virtballoon_restore,
+#endif
 };
 
 static int __init init(void)
-- 
1.7.6.2

