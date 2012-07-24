Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2GXQeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:34:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45118 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2GXQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:15 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 06/32] PCI/hotplug: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:18 +0800
Message-Id: <1343147504-25891-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify cpihp_slot.c.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pcihp_slot.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index 8c05a18..b7bd558 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -102,9 +102,7 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
 	if (!hpp)
 		return;
 
-	/* Find PCI Express capability */
-	pos = pci_pcie_cap(dev);
-	if (!pos)
+	if (!pci_is_pcie(dev))
 		return;
 
 	if (hpp->revision > 1) {
@@ -114,16 +112,16 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
 	}
 
 	/* Initialize Device Control Register */
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
+	pci_pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);
 	reg16 = (reg16 & hpp->pci_exp_devctl_and) | hpp->pci_exp_devctl_or;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
+	pci_pcie_capability_write_word(dev, PCI_EXP_DEVCTL, reg16);
 
 	/* Initialize Link Control Register */
 	if (dev->subordinate) {
-		pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &reg16);
+		pci_pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &reg16);
 		reg16 = (reg16 & hpp->pci_exp_lnkctl_and)
 			| hpp->pci_exp_lnkctl_or;
-		pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, reg16);
+		pci_pcie_capability_write_word(dev, PCI_EXP_LNKCTL, reg16);
 	}
 
 	/* Find Advanced Error Reporting Enhanced Capability */
-- 
1.7.9.5

