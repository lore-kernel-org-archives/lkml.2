Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab1I2P01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1I2P0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:25 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 01/11] virtio: pci: switch to new PM API
Date: Thu, 29 Sep 2011 20:55:57 +0530
Message-Id: <2905b3d3e9c97a480ea8cb0bd0d351aa928bf10d.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The older PM API doesn't have a way to get notifications on hibernate
events.  Switch to the newer one that gives us those notifications.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_pci.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4bcc8b8..6947620 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -685,19 +685,28 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 }
 
 #ifdef CONFIG_PM
-static int virtio_pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int virtio_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
 	pci_save_state(pci_dev);
 	pci_set_power_state(pci_dev, PCI_D3hot);
 	return 0;
 }
 
-static int virtio_pci_resume(struct pci_dev *pci_dev)
+static int virtio_pci_resume(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
 	pci_restore_state(pci_dev);
 	pci_set_power_state(pci_dev, PCI_D0);
 	return 0;
 }
+
+static const struct dev_pm_ops virtio_pci_pm_ops = {
+	.suspend = virtio_pci_suspend,
+	.resume  = virtio_pci_resume,
+};
 #endif
 
 static struct pci_driver virtio_pci_driver = {
@@ -706,8 +715,7 @@ static struct pci_driver virtio_pci_driver = {
 	.probe		= virtio_pci_probe,
 	.remove		= __devexit_p(virtio_pci_remove),
 #ifdef CONFIG_PM
-	.suspend	= virtio_pci_suspend,
-	.resume		= virtio_pci_resume,
+	.driver.pm	= &virtio_pci_pm_ops,
 #endif
 };
 
-- 
1.7.6.2

