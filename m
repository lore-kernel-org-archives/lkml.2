Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1KQL6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:58:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab1KQL6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:15 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 01/11] virtio: pci: switch to new PM API
Date: Thu, 17 Nov 2011 17:27:32 +0530
Message-Id: <d2b192cf720abf714b438f2cf43d0149a0193c47.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
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
index 3d1bf41..5d36bc0 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -690,19 +690,28 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
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
@@ -711,8 +720,7 @@ static struct pci_driver virtio_pci_driver = {
 	.probe		= virtio_pci_probe,
 	.remove		= __devexit_p(virtio_pci_remove),
 #ifdef CONFIG_PM
-	.suspend	= virtio_pci_suspend,
-	.resume		= virtio_pci_resume,
+	.driver.pm	= &virtio_pci_pm_ops,
 #endif
 };
 
-- 
1.7.7.1

