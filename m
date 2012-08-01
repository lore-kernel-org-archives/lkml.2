Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2HAP6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:58:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61939 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2HAP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:39 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jon Mason <mason@myri.com>, Andrew Gallatin <gallatin@myri.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 21/32] PCI/myri10ge: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:26 +0800
Message-Id: <1343836477-7287-22-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify myri10ge driver's
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |   39 ++++------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 90153fc..fe6c44d 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1078,24 +1078,8 @@ static int myri10ge_reset(struct myri10ge_priv *mgp)
 #ifdef CONFIG_MYRI10GE_DCA
 static int myri10ge_toggle_relaxed(struct pci_dev *pdev, int on)
 {
-	int ret, cap, err;
-	u16 ctl;
-
-	cap = pci_pcie_cap(pdev);
-	if (!cap)
-		return 0;
-
-	err = pci_read_config_word(pdev, cap + PCI_EXP_DEVCTL, &ctl);
-	if (err)
-		return 0;
-
-	ret = (ctl & PCI_EXP_DEVCTL_RELAX_EN) >> 4;
-	if (ret != on) {
-		ctl &= ~PCI_EXP_DEVCTL_RELAX_EN;
-		ctl |= (on << 4);
-		pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, ctl);
-	}
-	return ret;
+	return pci_pcie_capability_change_word(pdev, PCI_EXP_DEVCTL,
+		       on << 4, PCI_EXP_DEVCTL_RELAX_EN);
 }
 
 static void
@@ -3192,18 +3176,13 @@ static void myri10ge_enable_ecrc(struct myri10ge_priv *mgp)
 	struct device *dev = &mgp->pdev->dev;
 	int cap;
 	unsigned err_cap;
-	u16 val;
-	u8 ext_type;
 	int ret;
 
 	if (!myri10ge_ecrc_enable || !bridge)
 		return;
 
 	/* check that the bridge is a root port */
-	cap = pci_pcie_cap(bridge);
-	pci_read_config_word(bridge, cap + PCI_CAP_FLAGS, &val);
-	ext_type = (val & PCI_EXP_FLAGS_TYPE) >> 4;
-	if (ext_type != PCI_EXP_TYPE_ROOT_PORT) {
+	if (pci_pcie_type(bridge) != PCI_EXP_TYPE_ROOT_PORT) {
 		if (myri10ge_ecrc_enable > 1) {
 			struct pci_dev *prev_bridge, *old_bridge = bridge;
 
@@ -3218,11 +3197,8 @@ static void myri10ge_enable_ecrc(struct myri10ge_priv *mgp)
 						" to force ECRC\n");
 					return;
 				}
-				cap = pci_pcie_cap(bridge);
-				pci_read_config_word(bridge,
-						     cap + PCI_CAP_FLAGS, &val);
-				ext_type = (val & PCI_EXP_FLAGS_TYPE) >> 4;
-			} while (ext_type != PCI_EXP_TYPE_ROOT_PORT);
+			} while (pci_pcie_type(bridge) !=
+				 PCI_EXP_TYPE_ROOT_PORT);
 
 			dev_info(dev,
 				 "Forcing ECRC on non-root port %s"
@@ -3335,11 +3311,10 @@ static void myri10ge_select_firmware(struct myri10ge_priv *mgp)
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

