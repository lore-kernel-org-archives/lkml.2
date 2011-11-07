Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1KGQf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab1KGQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:35:55 -0500
Date: Mon, 7 Nov 2011 18:37:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH] virtio-pci: fix use after free
Message-ID: <20111107163703.GA10358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/virtio/virtio_pci.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index d4ed130..a989b41 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -730,11 +730,11 @@ static struct virtio_config_ops virtio_pci_config_ops = {
 
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
@@ -822,6 +822,7 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 	virtio_pci_iounmap(vp_dev);
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
+	kfree(vp_dev);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.5.53.gc233e
