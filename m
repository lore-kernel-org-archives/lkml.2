Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1AETRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:17:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1AETRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:17:41 -0500
Date: Wed, 5 Jan 2011 21:17:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        gleb@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-pci: add softlinks between virtio and pci
Message-ID: <20110105191711.GA27489@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We sometimes need to map between the virtio device and
the given pci device. One such use is OS installer that
gets the boot pci device from BIOS and needs to
find the relevant block device. Since it can't,
installation fails.

Supply softlinks between these to make it possible.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Gleb, could you please ack that this patch below
will be enough to fix the installer issue that
you see?

 drivers/virtio/virtio_pci.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index ef8d9d5..06eb2f8 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -25,6 +25,7 @@
 #include <linux/virtio_pci.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
+#include <linux/sysfs.h>
 
 MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
 MODULE_DESCRIPTION("virtio-pci");
@@ -667,8 +668,21 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	if (err)
 		goto out_set_drvdata;
 
-	return 0;
+	err = sysfs_create_link(&pci_dev->dev.kobj, &vp_dev->vdev.dev.kobj,
+				"virtio_device");
+	if (err)
+		goto out_register_device;
+
+	err = sysfs_create_link(&vp_dev->vdev.dev.kobj, &pci_dev->dev.kobj,
+				"bus_device");
+	if (err)
+		goto out_create_link;
 
+	return 0;
+out_create_link:
+	sysfs_remove_link(&pci_dev->dev.kobj, "virtio_device");
+out_register_device:
+	unregister_virtio_device(&vp_dev->vdev);
 out_set_drvdata:
 	pci_set_drvdata(pci_dev, NULL);
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
@@ -685,6 +699,8 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 {
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 
+	sysfs_remove_link(&vp_dev->vdev.dev.kobj, "bus_device");
+	sysfs_remove_link(&pci_dev->dev.kobj, "virtio_device");
 	unregister_virtio_device(&vp_dev->vdev);
 }
 
-- 
1.7.3.2.91.g446ac
