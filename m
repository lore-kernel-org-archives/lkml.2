Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2HAPzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:55:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52606 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2HAPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:55:07 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 01/32] PCI: add pcie_flags_reg into struct pci_dev to cache PCIe capabilities register
Date: Wed,  1 Aug 2012 23:54:06 +0800
Message-Id: <1343836477-7287-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

From: Yijing Wang <wangyijing@huawei.com>

Since PCI Express Capabilities Register is read only, cache its value
into struct pci_dev to avoid repeatedly calling pci_read_config_*().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/probe.c |    3 ++-
 include/linux/pci.h |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6c143b4..ba4d855 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -929,7 +929,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->is_pcie = 1;
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
-	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+	pdev->pcie_flags_reg = reg16;
+	pdev->pcie_type = pci_pcie_type(pdev);
 	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
 	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..95662b2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -258,6 +258,7 @@ struct pci_dev {
 	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
+	u16		pcie_flags_reg;	/* cached PCI-E Capabilities Register */
 
 	struct pci_driver *driver;	/* which driver has allocated this device */
 	u64		dma_mask;	/* Mask of the bits of bus address this
@@ -1650,6 +1651,15 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 	return !!pci_pcie_cap(dev);
 }
 
+/**
+ * pci_pcie_type - get the PCIe device/port type
+ * @dev: PCI device
+ */
+static inline int pci_pcie_type(const struct pci_dev *dev)
+{
+	return (dev->pcie_flags_reg & PCI_EXP_FLAGS_TYPE) >> 4;
+}
+
 void pci_request_acs(void);
 bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
 bool pci_acs_path_enabled(struct pci_dev *start,
-- 
1.7.9.5

