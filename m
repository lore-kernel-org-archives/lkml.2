Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2C1UW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:22:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30290 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab2C1UWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:22:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] PCI: move mutex locking out of pci_dev_reset function.
Date: Wed, 28 Mar 2012 16:18:20 -0400
Message-Id: <1332965900-1732-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F73731E.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of git commit 6fbf9e7a90862988c278462d85ce9684605a52b2
"PCI: Introduce __pci_reset_function_locked to be used when holding device_lock."
was to have a non-locking function that would call pci_dev_reset function.

But it failed sort of that by just probing and not actually reseting
the device. To make that work we need a way to move the lock
around device_lock to not be in pci_dev_reset (as the caller of
__pci_reset_function_locked already holds said lock). We do this by
renaming pci_dev_reset to __pci_dev_reset and bubbling said mutex out
of __pci_dev_reset to pci_dev_reset (a wrapper around __pci_dev_reset).
The __pci_reset_function_locked  can now call __pci_dev_reset without
having to worry about the dead-lock.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/pci.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8156744..79e080f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3137,18 +3137,12 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	return 0;
 }
 
-static int pci_dev_reset(struct pci_dev *dev, int probe)
+static int __pci_dev_reset(struct pci_dev *dev, int probe)
 {
 	int rc;
 
 	might_sleep();
 
-	if (!probe) {
-		pci_cfg_access_lock(dev);
-		/* block PM suspend, driver probe, etc. */
-		device_lock(&dev->dev);
-	}
-
 	rc = pci_dev_specific_reset(dev, probe);
 	if (rc != -ENOTTY)
 		goto done;
@@ -3167,14 +3161,27 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
 
 	rc = pci_parent_bus_reset(dev, probe);
 done:
+	return rc;
+}
+
+static int pci_dev_reset(struct pci_dev *dev, int probe)
+{
+	int rc;
+
+	if (!probe) {
+		pci_cfg_access_lock(dev);
+		/* block PM suspend, driver probe, etc. */
+		device_lock(&dev->dev);
+	}
+
+	rc = __pci_dev_reset(dev, probe);
+
 	if (!probe) {
 		device_unlock(&dev->dev);
 		pci_cfg_access_unlock(dev);
 	}
-
 	return rc;
 }
-
 /**
  * __pci_reset_function - reset a PCI device function
  * @dev: PCI device to reset
@@ -3219,7 +3226,7 @@ EXPORT_SYMBOL_GPL(__pci_reset_function);
  */
 int __pci_reset_function_locked(struct pci_dev *dev)
 {
-	return pci_dev_reset(dev, 1);
+	return __pci_dev_reset(dev, 0);
 }
 EXPORT_SYMBOL_GPL(__pci_reset_function_locked);
 
-- 
1.7.7.5

