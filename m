Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1I2P0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1I2P03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:29 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 02/11] virtio-pci: add PM notification handlers for restore, freeze, thaw, poweroff
Date: Thu, 29 Sep 2011 20:55:58 +0530
Message-Id: <9f89dedd5e4e77c9244afde0ce22c1216a35c193.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle restore and freeze notification from the PM core.  Expose these
to individual virtio drivers that can quiesce and resume vq operations.

These functions also save device-specific data so that the device can be
put in pre-suspend state after resume.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_pci.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h      |    4 ++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 6947620..cc70662 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -55,6 +55,10 @@ struct virtio_pci_device
 	unsigned msix_vectors;
 	/* Vectors allocated, excluding per-vq vectors if any */
 	unsigned msix_used_vectors;
+
+	/* Status saved during hibernate/restore */
+	u8 saved_status;
+
 	/* Whether we have vector per vq */
 	bool per_vq_vectors;
 };
@@ -703,9 +707,46 @@ static int virtio_pci_resume(struct device *dev)
 	return 0;
 }
 
+static int virtio_pci_freeze(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	struct virtio_driver *drv;
+
+	drv = container_of(vp_dev->vdev.dev.driver,
+			   struct virtio_driver, driver);
+
+	vp_dev->saved_status = vp_get_status(&vp_dev->vdev);
+	if (drv && drv->freeze)
+		return drv->freeze(&vp_dev->vdev);
+
+	return 0;
+}
+
+static int virtio_pci_restore(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	struct virtio_driver *drv;
+
+	drv = container_of(vp_dev->vdev.dev.driver,
+			   struct virtio_driver, driver);
+
+	vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
+	vp_finalize_features(&vp_dev->vdev);
+	if (drv && drv->restore)
+		return drv->restore(&vp_dev->vdev);
+
+	return 0;
+}
+
 static const struct dev_pm_ops virtio_pci_pm_ops = {
 	.suspend = virtio_pci_suspend,
 	.resume  = virtio_pci_resume,
+	.freeze  = virtio_pci_freeze,
+	.thaw    = virtio_pci_restore,
+	.restore = virtio_pci_restore,
+	.poweroff = virtio_pci_suspend,
 };
 #endif
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7108857..9afb662 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -141,6 +141,10 @@ struct virtio_driver {
 	int (*probe)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
 	void (*config_changed)(struct virtio_device *dev);
+#ifdef CONFIG_PM
+	int (*freeze)(struct virtio_device *dev);
+	int (*restore)(struct virtio_device *dev);
+#endif
 };
 
 int register_virtio_driver(struct virtio_driver *drv);
-- 
1.7.6.2

