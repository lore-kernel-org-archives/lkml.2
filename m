Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1AaCx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:53:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1AaCx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:53:58 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC Patch] virtio: export model and type in /sys
Date: Mon, 31 Jan 2011 10:53:00 +0800
Message-Id: <1296442381-21652-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our kdump script needs /sys/block/X/device/{vendor, model, type},
but virtio devices don't have {model, type}, this patch adds them.
Actually, I don't know how to fill the model field, other block devices
seem read it from SCSI. Any comments?

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index efb35aa..5ce70b7 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -17,6 +17,18 @@ static ssize_t vendor_show(struct device *_d,
 	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
 	return sprintf(buf, "0x%04x\n", dev->id.vendor);
 }
+static ssize_t model_show(struct device *_d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
+	return sprintf(buf, "0x%04x\n", dev->id.model);
+}
+static ssize_t type_show(struct device *_d,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
+	return sprintf(buf, "0x%04x\n", dev->id.type);
+}
 static ssize_t status_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
 {
@@ -49,6 +61,8 @@ static ssize_t features_show(struct device *_d,
 static struct device_attribute virtio_dev_attrs[] = {
 	__ATTR_RO(device),
 	__ATTR_RO(vendor),
+	__ATTR_RO(model),
+	__ATTR_RO(type),
 	__ATTR_RO(status),
 	__ATTR_RO(modalias),
 	__ATTR_RO(features),
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4fb5b2b..3bde99d 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -656,6 +656,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	 * the subsystem ids */
 	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
 	vp_dev->vdev.id.device = pci_dev->subsystem_device;
+	vp_dev->vdev.id.type = pci_dev->pcie_type;
 
 	/* finally register the virtio device */
 	err = register_virtio_device(&vp_dev->vdev);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 48c007d..b72cd50 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -385,6 +385,8 @@ struct ssb_device_id {
 struct virtio_device_id {
 	__u32 device;
 	__u32 vendor;
+	__u32 model;
+	__u32 type;
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
