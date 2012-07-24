Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2GXQgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:36:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55727 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2GXQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:36:45 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 21/32] PCI/myri10ge: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:33 +0800
Message-Id: <1343147504-25891-22-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify myri10ge driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 90153fc..3566236 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1078,14 +1078,13 @@ static int myri10ge_reset(struct myri10ge_priv *mgp)
 #ifdef CONFIG_MYRI10GE_DCA
 static int myri10ge_toggle_relaxed(struct pci_dev *pdev, int on)
 {
-	int ret, cap, err;
+	int ret, err;
 	u16 ctl;
 
-	cap = pci_pcie_cap(pdev);
-	if (!cap)
+	if (!pci_is_pcie(pdev))
 		return 0;
 
-	err = pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl);
+	err = pci_pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
 	if (err)
 		return 0;
 
@@ -1093,7 +1092,7 @@ static int myri10ge_toggle_relaxed(struct pci_dev *pdev, int on)
 	if (ret != on) {
 		ctl &= ~PCI_EXP_DEVCTL_RELAX_EN;
 		ctl |= (on << 4);
-		pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl);
+		pci_pcie_capability_write_word(pdev, PCI_EXP_DEVCTL, ctl);
 	}
 	return ret;
 }
@@ -3200,8 +3199,7 @@ static void myri10ge_enable_ecrc(struct myri10ge_priv *mgp)
 		return;
 
 	/* check that the bridge is a root port */
-	cap = pci_pcie_cap(bridge);
-	pci_read_config_word(bridge, cap + PCI_CAP_FLAGS, &val);
+	val = bridge->pcie_flags_reg;
 	ext_type = (val & PCI_EXP_FLAGS_TYPE) >> 4;
 	if (ext_type != PCI_EXP_TYPE_ROOT_PORT) {
 		if (myri10ge_ecrc_enable > 1) {
@@ -3218,9 +3216,7 @@ static void myri10ge_enable_ecrc(struct myri10ge_priv *mgp)
 						" to force ECRC\n");
 					return;
 				}
-				cap = pci_pcie_cap(bridge);
-				pci_read_config_word(bridge,
-						     cap + PCI_CAP_FLAGS, &val);
+				val = bridge->pcie_flags_reg;
 				ext_type = (val & PCI_EXP_FLAGS_TYPE) >> 4;
 			} while (ext_type != PCI_EXP_TYPE_ROOT_PORT);
 
@@ -3335,11 +3331,10 @@ static void myri10ge_select_firmware(struct myri10ge_priv *mgp)
 	int overridden = 0;
 
 	if (myri10ge_force_firmware == 0) {
-		int link_width, exp_cap;
+		int link_width;
 		u16 lnk;
 
-		exp_cap = pci_pcie_cap(mgp->pdev);
-		pci_read_config_word(mgp->pdev, exp_cap + PCI_EXP_LNKSTA, &lnk);
+		pci_pcie_capability_read_word(mgp->pdev, PCI_EXP_LNKSTA, &lnk);
 		link_width = (lnk >> 4) & 0x3f;
 
 		/* Check to see if Link is less than 8 or if the
-- 
1.7.9.5

