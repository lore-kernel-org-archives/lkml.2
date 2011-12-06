Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1LFTtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:49:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab1LFTta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:49:30 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v4 02/12] virtio: pci: add PM notification handlers for restore, freeze, thaw, poweroff
Date: Wed,  7 Dec 2011 01:18:40 +0530
Message-Id: <44b83ecd3dde322473dee6d3238aa786ad360bcb.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle thaw, restore and freeze notifications from the PM core.  Expose
these to individual virtio drivers that can quiesce and resume vq
operations.  For drivers not implementing the thaw() method, use the
restore method instead.

These functions also save device-specific data so that the device can be
put in pre-suspend state after resume, and disable and enable the PCI
device in the freeze and resume functions, respectively.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_pci.c |   85 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h      |    5 +++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 23e1532..bd33603 100644
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
@@ -726,9 +730,90 @@ static int virtio_pci_resume(struct device *dev)
 	return 0;
 }
 
+static int virtio_pci_freeze(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	struct virtio_driver *drv;
+	int ret;
+
+	drv = container_of(vp_dev->vdev.dev.driver,
+			   struct virtio_driver, driver);
+
+	ret = 0;
+	vp_dev->saved_status = vp_get_status(&vp_dev->vdev);
+	if (drv && drv->freeze)
+		ret = drv->freeze(&vp_dev->vdev);
+
+	if (!ret)
+		pci_disable_device(pci_dev);
+	return ret;
+}
+
+static int restore_common(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	int ret;
+
+	ret = pci_enable_device(pci_dev);
+	if (ret)
+		return ret;
+	pci_set_master(pci_dev);
+	vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
+	vp_finalize_features(&vp_dev->vdev);
+
+	return ret;
+}
+
+static int virtio_pci_restore(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	struct virtio_driver *drv;
+	int ret;
+
+	drv = container_of(vp_dev->vdev.dev.driver,
+			   struct virtio_driver, driver);
+
+	ret = restore_common(dev);
+	if (!ret && drv && drv->restore)
+		ret = drv->restore(&vp_dev->vdev);
+
+	return ret;
+}
+
+static int virtio_pci_thaw(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	struct virtio_driver *drv;
+	int ret;
+
+	ret = restore_common(dev);
+	if (ret)
+		return ret;
+
+	drv = container_of(vp_dev->vdev.dev.driver,
+			   struct virtio_driver, driver);
+	if (!drv)
+		return ret;
+
+	if (drv->thaw)
+		ret = drv->thaw(&vp_dev->vdev);
+	else if (drv->restore)
+		ret = drv->restore(&vp_dev->vdev);
+
+	return ret;
+}
+
 static const struct dev_pm_ops virtio_pci_pm_ops = {
 	.suspend = virtio_pci_suspend,
 	.resume  = virtio_pci_resume,
+	.freeze  = virtio_pci_freeze,
+	.thaw    = virtio_pci_thaw,
+	.restore = virtio_pci_restore,
+	.poweroff = virtio_pci_suspend,
 };
 #endif
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 4c069d8..92902ab 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -146,6 +146,11 @@ struct virtio_driver {
 	int (*probe)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
 	void (*config_changed)(struct virtio_device *dev);
+#ifdef CONFIG_PM
+	int (*freeze)(struct virtio_device *dev);
+	int (*thaw)(struct virtio_device *dev);
+	int (*restore)(struct virtio_device *dev);
+#endif
 };
 
 int register_virtio_driver(struct virtio_driver *drv);
-- 
1.7.7.3

