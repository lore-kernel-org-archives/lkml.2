Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab1KSAKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:10:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509Ab1KSAKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:28 2011
Message-Id: <20111119000328.123074999@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [03/26] virtio-pci: fix use after free
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 72103bd1285211440621f2c46f4fce377584de54 upstream.

Commit 31a3ddda166cda86d2b5111e09ba4bda5239fae6 introduced
a use after free in virtio-pci. The main issue is
that the release method signals removal of the virtio device,
while remove signals removal of the pci device.

For example, on driver removal or hot-unplug,
virtio_pci_release_dev is called before virtio_pci_remove.
We then might get a crash as virtio_pci_remove tries to use the
device freed by virtio_pci_release_dev.

We allocate/free all resources together with the
pci device, so we can leave the release method empty.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_pci.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -590,11 +590,11 @@ static struct virtio_config_ops virtio_p
 
 static void virtio_pci_release_dev(struct device *_d)
 {
-	struct virtio_device *dev = container_of(_d, struct virtio_device,
-						 dev);
-	struct virtio_pci_device *vp_dev = to_vp_device(dev);
-
-	kfree(vp_dev);
+	/*
+	 * No need for a release method as we allocate/free
+	 * all devices together with the pci devices.
+	 * Provide an empty one to avoid getting a warning from core.
+	 */
 }
 
 /* the PCI probing function */
@@ -682,6 +682,7 @@ static void __devexit virtio_pci_remove(
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
+	kfree(vp_dev);
 }
 
 #ifdef CONFIG_PM


