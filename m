Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1BPB1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:27:09 -0500
Received: from kroah.org ([198.145.64.141]:39491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab1BPAWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.544975529@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [145/272] virtio: remove virtio-pci root device
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
Tested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Tested-by: "Daniel P. Berrange" <berrange@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_pci.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -96,11 +96,6 @@ static struct pci_device_id virtio_pci_i
 
 MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
 
-/* A PCI device has it's own struct device and so does a virtio device so
- * we create a place for the virtio devices to show up in sysfs.  I think it
- * would make more sense for virtio to not insist on having it's own device. */
-static struct device *virtio_pci_root;
-
 /* Convert a generic virtio device to our structure */
 static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 {
@@ -629,7 +624,7 @@ static int __devinit virtio_pci_probe(st
 	if (vp_dev == NULL)
 		return -ENOMEM;
 
-	vp_dev->vdev.dev.parent = virtio_pci_root;
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
 	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
@@ -717,17 +712,7 @@ static struct pci_driver virtio_pci_driv
 
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
@@ -735,7 +720,6 @@ module_init(virtio_pci_init);
 static void __exit virtio_pci_exit(void)
 {
 	pci_unregister_driver(&virtio_pci_driver);
-	root_device_unregister(virtio_pci_root);
 }
 
 module_exit(virtio_pci_exit);


