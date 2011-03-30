Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab1C3WAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:00:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab1C3VGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132923"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: miltonm@bga.com, rusty@rustcorp.com.au, mst@redhat.com, ak@linux.intel.com,
        gleb@redhat.com, berrange@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [56/275] virtio: remove virtio-pci root device
Message-Id: <20110330210452.A19C33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Milton Miller <miltonm@bga.com>

commit 8b3bb3ecf1934ac4a7005ad9017de1127e2fbd2f upstream.

We sometimes need to map between the virtio device and
the given pci device. One such use is OS installer that
gets the boot pci device from BIOS and needs to
find the relevant block device. Since it can't,
installation fails.

Instead of creating a top-level devices/virtio-pci
directory, create each device under the corresponding
pci device node.  Symlinks to all virtio-pci
devices can be found under the pci driver link in
bus/pci/drivers/virtio-pci/devices, and all virtio
devices under drivers/bus/virtio/devices.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Tested-by: "Daniel P. Berrange" <berrange@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_pci.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

Index: linux-2.6.35.y/drivers/virtio/virtio_pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/virtio/virtio_pci.c	2011-03-29 22:51:47.321512330 -0700
+++ linux-2.6.35.y/drivers/virtio/virtio_pci.c	2011-03-29 23:02:59.322317511 -0700
@@ -96,11 +96,6 @@
 
 MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 
-/* A PCI device has it's own struct device and so does a virtio device so
- * we create a place for the virtio devices to show up in sysfs.  I think it
- * would make more sense for virtio to not insist on having it's own device. */
-static struct device *virtio_pci_root;
-
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 {
@@ -629,7 +624,7 @@
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.dev.parent = virtio_pci_root;
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
 	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
@@ -717,17 +712,7 @@
 
 static int __init virtio_pci_init(void)
 {
-	int err;
-
-	virtio_pci_root = root_device_register("virtio-pci");
-	if (IS_ERR(virtio_pci_root))
-		return PTR_ERR(virtio_pci_root);
-
-	err = pci_register_driver(&virtio_pci_driver);
-	if (err)
-		root_device_unregister(virtio_pci_root);
-
-	return err;
+	return pci_register_driver(&virtio_pci_driver);
 }
 
 module_init(virtio_pci_init);
@@ -735,7 +720,6 @@
 static void __exit virtio_pci_exit(void)
 {
 	pci_unregister_driver(&virtio_pci_driver);
-	root_device_unregister(virtio_pci_root);
 }
 
 module_exit(virtio_pci_exit);
