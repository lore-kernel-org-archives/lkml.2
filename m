Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2GXQnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:43:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2GXQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:43:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 24/32] PCI/ath9k: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:41:09 +0800
Message-Id: <1343148077-25941-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify ath9k driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a856b51..f90342d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -112,11 +112,9 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	struct ath_hw *ah = sc->sc_ah;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	struct pci_dev *parent;
-	int pos;
-	u8 aspm;
+	u16 aspm;
 
-	pos = pci_pcie_cap(pdev);
-	if (!pos)
+	if (!pci_is_pcie(pdev))
 		return;
 
 	parent = pdev->bus->self;
@@ -125,24 +123,22 @@ static void ath_pci_aspm_init(struct ath_common *common)
 
 	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
 		/* Bluetooth coexistance requires disabling ASPM. */
-		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
+		pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
+		pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, aspm);
 
 		/*
 		 * Both upstream and downstream PCIe components should
 		 * have the same ASPM settings.
 		 */
-		pos = pci_pcie_cap(parent);
-		pci_read_config_byte(parent, pos + PCI_EXP_LNKCTL, &aspm);
+		pci_pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
-		pci_write_config_byte(parent, pos + PCI_EXP_LNKCTL, aspm);
+		pci_pcie_capability_write_word(parent, PCI_EXP_LNKCTL, aspm);
 
 		return;
 	}
 
-	pos = pci_pcie_cap(parent);
-	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
+	pci_pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &aspm);
 	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
-- 
1.7.9.5

