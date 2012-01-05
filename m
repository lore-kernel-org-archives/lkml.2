Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2AEAs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:48:26 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:64877 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2AEAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:48:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] pci: Introduce __pci_reset_function_locked to be used when holding device_lock.
Date: Wed,  4 Jan 2012 19:46:39 -0500
Message-Id: <1325724403-29642-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F04F353.003F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use case of this is when a driver wants to call FLR when a device
is attached to it using the SysFS "bind" or "unbind" functionality.

The call chain when a user does "bind" looks as so:

 echo "0000:01.07.0" > /sys/bus/pci/drivers/XXXX/bind

and ends up calling:
  driver_bind:
    device_lock(dev);  <=== TAKES LOCK
    XXXX_probe:
         .. pci_enable_device()
         ...__pci_reset_function(), which calls
                 pci_dev_reset(dev, 0):
                        if (!0) {
                                device_lock(dev) <==== DEADLOCK

The __pci_reset_function_locked function allows the the drivers
'probe' function to call the "pci_reset_function" while still holding
the driver mutex lock.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/pci.c   |   25 +++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d4a531..f9a2a0d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3020,6 +3020,31 @@ int __pci_reset_function(struct pci_dev *dev)
 EXPORT_SYMBOL_GPL(__pci_reset_function);
 
 /**
+ * __pci_reset_function_locked - reset a PCI device function while holding
+ * the @dev mutex lock.
+ * @dev: PCI device to reset
+ *
+ * Some devices allow an individual function to be reset without affecting
+ * other functions in the same device.  The PCI device must be responsive
+ * to PCI config space in order to use this function.
+ *
+ * The device function is presumed to be unused and the caller is holding
+ * the device mutex lock when this function is called.
+ * Resetting the device will make the contents of PCI configuration space
+ * random, so any caller of this must be prepared to reinitialise the
+ * device including MSI, bus mastering, BARs, decoding IO and memory spaces,
+ * etc.
+ *
+ * Returns 0 if the device function was successfully reset or negative if the
+ * device doesn't support resetting a single function.
+ */
+int __pci_reset_function_locked(struct pci_dev *dev)
+{
+	return pci_dev_reset(dev, 1);
+}
+EXPORT_SYMBOL_GPL(__pci_reset_function_locked);
+
+/**
  * pci_probe_reset_function - check whether the device can be safely reset
  * @dev: PCI device to reset
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cda65b..af5ee43 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -814,6 +814,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq);
 int pcie_get_mps(struct pci_dev *dev);
 int pcie_set_mps(struct pci_dev *dev, int mps);
 int __pci_reset_function(struct pci_dev *dev);
+int __pci_reset_function_locked(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
-- 
1.7.7.4

