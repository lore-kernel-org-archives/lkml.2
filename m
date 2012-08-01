Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2HAQA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:00:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40535 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HAQAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:00:22 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Mark Einon <mark.einon@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 31/32] PCI/et131x: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:36 +0800
Message-Id: <1343836477-7287-32-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify et131x driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/staging/et131x/et131x.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 5b11c5e..7c2e781 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4001,16 +4001,14 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 static int et131x_pci_init(struct et131x_adapter *adapter,
 						struct pci_dev *pdev)
 {
-	int cap = pci_pcie_cap(pdev);
 	u16 max_payload;
-	u16 ctl;
 	int i, rc;
 
 	rc = et131x_init_eeprom(adapter);
 	if (rc < 0)
 		goto out;
 
-	if (!cap) {
+	if (!pci_is_pcie(pdev)) {
 		dev_err(&pdev->dev, "Missing PCIe capabilities\n");
 		goto err_out;
 	}
@@ -4018,7 +4016,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	/* Let's set up the PORT LOGIC Register.  First we need to know what
 	 * the max_payload_size is
 	 */
-	if (pci_read_config_word(pdev, cap + PCI_EXP_DEVCAP, &max_payload)) {
+	if (pci_pcie_capability_read_word(pdev, PCI_EXP_DEVCAP, &max_payload)) {
 		dev_err(&pdev->dev,
 		    "Could not read PCI config space for Max Payload Size\n");
 		goto err_out;
@@ -4055,17 +4053,10 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 	}
 
 	/* Change the max read size to 2k */
-	if (pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl)) {
+	if (pci_pcie_capability_change_word(pdev, PCI_EXP_DEVCTL,
+				0x4 << 12, PCI_EXP_DEVCTL_READRQ)) {
 		dev_err(&pdev->dev,
-			"Could not read PCI config space for Max read size\n");
-		goto err_out;
-	}
-
-	ctl = (ctl & ~PCI_EXP_DEVCTL_READRQ) | (0x04 << 12);
-
-	if (pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl)) {
-		dev_err(&pdev->dev,
-		      "Could not write PCI config space for Max read size\n");
+			"Couldn't change PCI config space for Max read size\n");
 		goto err_out;
 	}
 
-- 
1.7.9.5

