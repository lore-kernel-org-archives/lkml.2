Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2HAP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:57:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2HAP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:57:48 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 16/32] PCI/broadcom: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:21 +0800
Message-Id: <1343836477-7287-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify broadcom ethernet drivers'
implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   25 ++-------
 drivers/net/ethernet/broadcom/tg3.c              |   60 ++++++++--------------
 2 files changed, 25 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index f755a66..c631f62 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1142,14 +1142,9 @@ static int bnx2x_send_final_clnup(struct bnx2x *bp, u8 clnup_func,
 
 static u8 bnx2x_is_pcie_pending(struct pci_dev *dev)
 {
-	int pos;
 	u16 status;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return false;
-
-	pci_read_config_word(dev, pos + PCI_EXP_DEVSTA, &status);
+	pci_pcie_capability_read_word(dev, PCI_EXP_DEVSTA, &status);
 	return status & PCI_EXP_DEVSTA_TRPND;
 }
 
@@ -6114,8 +6109,7 @@ static void bnx2x_init_pxp(struct bnx2x *bp)
 	u16 devctl;
 	int r_order, w_order;
 
-	pci_read_config_word(bp->pdev,
-			     pci_pcie_cap(bp->pdev) + PCI_EXP_DEVCTL, &devctl);
+	pci_pcie_capability_read_word(bp->pdev, PCI_EXP_DEVCTL, &devctl);
 	DP(NETIF_MSG_HW, "read 0x%x from devctl\n", devctl);
 	w_order = ((devctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
 	if (bp->mrrs == -1)
@@ -9330,15 +9324,10 @@ static int __devinit bnx2x_prev_mark_path(struct bnx2x *bp)
 
 static bool __devinit bnx2x_can_flr(struct bnx2x *bp)
 {
-	int pos;
 	u32 cap;
 	struct pci_dev *dev = bp->pdev;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return false;
-
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP, &cap);
+	pci_pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
 	if (!(cap & PCI_EXP_DEVCAP_FLR))
 		return false;
 
@@ -9347,7 +9336,7 @@ static bool __devinit bnx2x_can_flr(struct bnx2x *bp)
 
 static int __devinit bnx2x_do_flr(struct bnx2x *bp)
 {
-	int i, pos;
+	int i;
 	u16 status;
 	struct pci_dev *dev = bp->pdev;
 
@@ -9355,16 +9344,12 @@ static int __devinit bnx2x_do_flr(struct bnx2x *bp)
 	if (bnx2x_can_flr(bp))
 		return -ENOTTY;
 
-	pos = pci_pcie_cap(dev);
-	if (!pos)
-		return -ENOTTY;
-
 	/* Wait for Transaction Pending bit clean */
 	for (i = 0; i < 4; i++) {
 		if (i)
 			msleep((1 << (i - 1)) * 100);
 
-		pci_read_config_word(dev, pos + PCI_EXP_DEVSTA, &status);
+		pci_pcie_capability_read_word(dev, PCI_EXP_DEVSTA, &status);
 		if (!(status & PCI_EXP_DEVSTA_TRPND))
 			goto clear;
 	}
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 09fa3c6..d29fe27 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3541,17 +3541,9 @@ static int tg3_power_down_prepare(struct tg3 *tp)
 	tg3_enable_register_access(tp);
 
 	/* Restore the CLKREQ setting. */
-	if (tg3_flag(tp, CLKREQ_BUG)) {
-		u16 lnkctl;
-
-		pci_read_config_word(tp->pdev,
-				     pci_pcie_cap(tp->pdev) + PCI_EXP_LNKCTL,
-				     &lnkctl);
-		lnkctl |= PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(tp->pdev,
-				      pci_pcie_cap(tp->pdev) + PCI_EXP_LNKCTL,
-				      lnkctl);
-	}
+	if (tg3_flag(tp, CLKREQ_BUG))
+		pci_pcie_capability_change_word(tp->pdev, PCI_EXP_LNKCTL,
+						PCI_EXP_LNKCTL_CLKREQ_EN, 0);
 
 	misc_host_ctrl = tr32(TG3PCI_MISC_HOST_CTRL);
 	tw32(TG3PCI_MISC_HOST_CTRL,
@@ -4322,20 +4314,15 @@ relink:
 
 	/* Prevent send BD corruption. */
 	if (tg3_flag(tp, CLKREQ_BUG)) {
-		u16 oldlnkctl, newlnkctl;
+		u16 set = 0, clr = 0;
 
-		pci_read_config_word(tp->pdev,
-				     pci_pcie_cap(tp->pdev) + PCI_EXP_LNKCTL,
-				     &oldlnkctl);
 		if (tp->link_config.active_speed == SPEED_100 ||
 		    tp->link_config.active_speed == SPEED_10)
-			newlnkctl = oldlnkctl & ~PCI_EXP_LNKCTL_CLKREQ_EN;
+			clr = PCI_EXP_LNKCTL_CLKREQ_EN;
 		else
-			newlnkctl = oldlnkctl | PCI_EXP_LNKCTL_CLKREQ_EN;
-		if (newlnkctl != oldlnkctl)
-			pci_write_config_word(tp->pdev,
-					      pci_pcie_cap(tp->pdev) +
-					      PCI_EXP_LNKCTL, newlnkctl);
+			set = PCI_EXP_LNKCTL_CLKREQ_EN;
+		pci_pcie_capability_change_word(tp->pdev, PCI_EXP_LNKCTL,
+						set, clr);
 	}
 
 	if (current_link_up != netif_carrier_ok(tp->dev)) {
@@ -7942,7 +7929,7 @@ static int tg3_chip_reset(struct tg3 *tp)
 
 	udelay(120);
 
-	if (tg3_flag(tp, PCI_EXPRESS) && pci_pcie_cap(tp->pdev)) {
+	if (tg3_flag(tp, PCI_EXPRESS) && pci_is_pcie(tp->pdev)) {
 		u16 val16;
 
 		if (tp->pci_chip_rev_id == CHIPREV_ID_5750_A0) {
@@ -7959,28 +7946,22 @@ static int tg3_chip_reset(struct tg3 *tp)
 		}
 
 		/* Clear the "no snoop" and "relaxed ordering" bits. */
-		pci_read_config_word(tp->pdev,
-				     pci_pcie_cap(tp->pdev) + PCI_EXP_DEVCTL,
-				     &val16);
-		val16 &= ~(PCI_EXP_DEVCTL_RELAX_EN |
-			   PCI_EXP_DEVCTL_NOSNOOP_EN);
+		val16 = PCI_EXP_DEVCTL_RELAX_EN | PCI_EXP_DEVCTL_NOSNOOP_EN;
 		/*
 		 * Older PCIe devices only support the 128 byte
 		 * MPS setting.  Enforce the restriction.
 		 */
 		if (!tg3_flag(tp, CPMU_PRESENT))
-			val16 &= ~PCI_EXP_DEVCTL_PAYLOAD;
-		pci_write_config_word(tp->pdev,
-				      pci_pcie_cap(tp->pdev) + PCI_EXP_DEVCTL,
-				      val16);
+			val16 |= PCI_EXP_DEVCTL_PAYLOAD;
+		pci_pcie_capability_change_word(tp->pdev, PCI_EXP_DEVCTL,
+						0, val16);
 
 		/* Clear error status */
-		pci_write_config_word(tp->pdev,
-				      pci_pcie_cap(tp->pdev) + PCI_EXP_DEVSTA,
-				      PCI_EXP_DEVSTA_CED |
-				      PCI_EXP_DEVSTA_NFED |
-				      PCI_EXP_DEVSTA_FED |
-				      PCI_EXP_DEVSTA_URD);
+		pci_pcie_capability_write_word(tp->pdev, PCI_EXP_DEVSTA,
+					       PCI_EXP_DEVSTA_CED |
+					       PCI_EXP_DEVSTA_NFED |
+					       PCI_EXP_DEVSTA_FED |
+					       PCI_EXP_DEVSTA_URD);
 	}
 
 	tg3_restore_pci_state(tp);
@@ -14303,9 +14284,8 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 
 		tg3_flag_set(tp, PCI_EXPRESS);
 
-		pci_read_config_word(tp->pdev,
-				     pci_pcie_cap(tp->pdev) + PCI_EXP_LNKCTL,
-				     &lnkctl);
+		pci_pcie_capability_read_word(tp->pdev,
+					      PCI_EXP_LNKCTL, &lnkctl);
 		if (lnkctl & PCI_EXP_LNKCTL_CLKREQ_EN) {
 			if (GET_ASIC_REV(tp->pci_chip_rev_id) ==
 			    ASIC_REV_5906) {
-- 
1.7.9.5

