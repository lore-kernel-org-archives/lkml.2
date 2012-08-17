Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2HQGyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:54:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:65056 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab2HQGya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="scan'208";a="181839679"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: rename struct pci_dev *mei_device to mei_pdev
Date: Fri, 17 Aug 2012 09:54:23 +0300
Message-Id: <1345186463-30927-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. rename mei_device variable to mei_pdev to remove
confusion with type 'struct mei_device'
2. mei_pdev no longer need to be gloabal so make it static
 and remove the declaration from the header file

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c    |   17 ++++++++---------
 drivers/misc/mei/mei_dev.h |    5 -----
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d792f3c..e477e6f 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -41,9 +41,8 @@
 #include <linux/mei.h>
 #include "interface.h"
 
-/* The device pointer */
-/* Currently this driver works as long as there is only a single AMT device. */
-struct pci_dev *mei_device;
+/* AMT device is a singleton on the platform */
+static struct pci_dev *mei_pdev;
 
 /* mei_pci_tbl - PCI Device ID Table */
 static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
@@ -218,10 +217,10 @@ static int mei_open(struct inode *inode, struct file *file)
 	int err;
 
 	err = -ENODEV;
-	if (!mei_device)
+	if (!mei_pdev)
 		goto out;
 
-	dev = pci_get_drvdata(mei_device);
+	dev = pci_get_drvdata(mei_pdev);
 	if (!dev)
 		goto out;
 
@@ -946,7 +945,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		goto end;
 	}
 
-	if (mei_device) {
+	if (mei_pdev) {
 		err = -EEXIST;
 		goto end;
 	}
@@ -1007,7 +1006,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	if (err)
 		goto release_irq;
 
-	mei_device = pdev;
+	mei_pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 
@@ -1052,7 +1051,7 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 {
 	struct mei_device *dev;
 
-	if (mei_device != pdev)
+	if (mei_pdev != pdev)
 		return;
 
 	dev = pci_get_drvdata(pdev);
@@ -1065,7 +1064,7 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 
 	mei_wd_stop(dev);
 
-	mei_device = NULL;
+	mei_pdev = NULL;
 
 	if (dev->iamthif_cl.state == MEI_FILE_CONNECTED) {
 		dev->iamthif_cl.state = MEI_FILE_DISCONNECTING;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c8660c0..ad6c9d5 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -39,11 +39,6 @@
 
 #define MEI_RD_MSG_BUF_SIZE           (128 * sizeof(u32))
 
-/*
- * MEI PCI Device object
- */
-extern struct pci_dev *mei_device;
-
 
 /*
  * AMTHI Client UUID
-- 
1.7.4.4

