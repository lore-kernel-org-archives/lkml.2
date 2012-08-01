Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2HAP4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:56:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2HAP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:56:46 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 10/32] PCI/AER: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:15 +0800
Message-Id: <1343836477-7287-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe AER implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/aer/aerdrv.c      |   17 ++++++--------
 drivers/pci/pcie/aer/aerdrv_core.c |   45 ++++++++----------------------------
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index f7c6245..b85750d 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -122,19 +122,17 @@ static void set_downstream_devices_error_reporting(struct pci_dev *dev,
 static void aer_enable_rootport(struct aer_rpc *rpc)
 {
 	struct pci_dev *pdev = rpc->rpd->port;
-	int pos, aer_pos;
+	int aer_pos;
 	u16 reg16;
 	u32 reg32;
 
-	pos = pci_pcie_cap(pdev);
 	/* Clear PCIe Capability's Device Status */
-	pci_read_config_word(pdev, pos+PCI_EXP_DEVSTA, &reg16);
-	pci_write_config_word(pdev, pos+PCI_EXP_DEVSTA, reg16);
+	pci_pcie_capability_read_word(pdev, PCI_EXP_DEVSTA, &reg16);
+	pci_pcie_capability_write_word(pdev, PCI_EXP_DEVSTA, reg16);
 
 	/* Disable system error generation in response to error messages */
-	pci_read_config_word(pdev, pos + PCI_EXP_RTCTL, &reg16);
-	reg16 &= ~(SYSTEM_ERROR_INTR_ON_MESG_MASK);
-	pci_write_config_word(pdev, pos + PCI_EXP_RTCTL, reg16);
+	pci_pcie_capability_change_word(pdev, PCI_EXP_RTCTL,
+					0, SYSTEM_ERROR_INTR_ON_MESG_MASK);
 
 	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
 	/* Clear error status */
@@ -396,9 +394,8 @@ static void aer_error_resume(struct pci_dev *dev)
 	u16 reg16;
 
 	/* Clean up Root device status */
-	pos = pci_pcie_cap(dev);
-	pci_read_config_word(dev, pos + PCI_EXP_DEVSTA, &reg16);
-	pci_write_config_word(dev, pos + PCI_EXP_DEVSTA, reg16);
+	pci_pcie_capability_read_word(dev, PCI_EXP_DEVSTA, &reg16);
+	pci_pcie_capability_write_word(dev, PCI_EXP_DEVSTA, reg16);
 
 	/* Clean AER Root Error Status */
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index f551534..2af79f7 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -34,51 +34,26 @@ module_param(nosourceid, bool, 0);
 
 int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
-	u16 reg16 = 0;
-	int pos;
-
 	if (pcie_aer_get_firmware_first(dev))
 		return -EIO;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
-	if (!pos)
-		return -EIO;
-
-	pos = pci_pcie_cap(dev);
-	if (!pos)
+	if (!pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR))
 		return -EIO;
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
-	reg16 |= (PCI_EXP_DEVCTL_CERE |
-		PCI_EXP_DEVCTL_NFERE |
-		PCI_EXP_DEVCTL_FERE |
-		PCI_EXP_DEVCTL_URRE);
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
-
-	return 0;
+	return pci_pcie_capability_change_word(dev, PCI_EXP_DEVCTL,
+			PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE |
+			PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE, 0);
 }
 EXPORT_SYMBOL_GPL(pci_enable_pcie_error_reporting);
 
 int pci_disable_pcie_error_reporting(struct pci_dev *dev)
 {
-	u16 reg16 = 0;
-	int pos;
-
 	if (pcie_aer_get_firmware_first(dev))
 		return -EIO;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return -EIO;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
-	reg16 &= ~(PCI_EXP_DEVCTL_CERE |
-		PCI_EXP_DEVCTL_NFERE |
-		PCI_EXP_DEVCTL_FERE |
-		PCI_EXP_DEVCTL_URRE);
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
-
-	return 0;
+	return pci_pcie_capability_change_word(dev, PCI_EXP_DEVCTL, 0,
+			PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE |
+			PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE);
 }
 EXPORT_SYMBOL_GPL(pci_disable_pcie_error_reporting);
 
@@ -151,18 +126,16 @@ static bool is_error_source(struct pci_dev *dev, struct aer_err_info *e_info)
 	 */
 	if (atomic_read(&dev->enable_cnt) == 0)
 		return false;
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return false;
 
 	/* Check if AER is enabled */
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
+	pci_pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);
 	if (!(reg16 & (
 		PCI_EXP_DEVCTL_CERE |
 		PCI_EXP_DEVCTL_NFERE |
 		PCI_EXP_DEVCTL_FERE |
 		PCI_EXP_DEVCTL_URRE)))
 		return false;
+
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!pos)
 		return false;
-- 
1.7.9.5

