Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1KQMAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:00:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab1KQL6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:17 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 02/11] virtio: pci: add PM notification handlers for restore, freeze, thaw, poweroff
Date: Thu, 17 Nov 2011 17:27:33 +0530
Message-Id: <42b65464513dadbefefe774339732628f7e4b4f1.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle restore and freeze notification from the PM core.  Expose these
to individual virtio drivers that can quiesce and resume vq operations.

These functions also save device-specific data so that the device can be
put in pre-suspend state after resume, and disable and enable the PCI
device in the freeze and resume functions, respectively.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_pci.c |   50 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h      |    4 +++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 5d36bc0..0db6f98 100644
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
@@ -708,9 +712,55 @@ static int virtio_pci_resume(struct device *dev)
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
+	ret = pci_enable_device(pci_dev);
+	if (ret)
+		return ret;
+	pci_set_master(pci_dev);
+	vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
+	vp_finalize_features(&vp_dev->vdev);
+	if (drv && drv->restore)
+		ret = drv->restore(&vp_dev->vdev);
+
+	return ret;
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
index 4c069d8..1c26416 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -146,6 +146,10 @@ struct virtio_driver {
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
1.7.7.1

