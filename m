Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2GXQfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:35:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59725 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2GXQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:35:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 11/32] PCI/ASPM: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:23 +0800
Message-Id: <1343147504-25891-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe ASPM implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/aspm.c |   66 +++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 2591603..5c00f8c 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -125,21 +125,17 @@ static int policy_to_clkpm_state(struct pcie_link_state *link)
 
 static void pcie_set_clkpm_nocheck(struct pcie_link_state *link, int enable)
 {
-	int pos;
 	u16 reg16;
 	struct pci_dev *child;
 	struct pci_bus *linkbus = link->pdev->subordinate;
 
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		pos = pci_pcie_cap(child);
-		if (!pos)
-			return;
-		pci_read_config_word(child, pos + PCI_EXP_LNKCTL, &reg16);
+		pci_pcie_capability_read_word(child, PCI_EXP_LNKCTL, &reg16);
 		if (enable)
 			reg16 |= PCI_EXP_LNKCTL_CLKREQ_EN;
 		else
 			reg16 &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
-		pci_write_config_word(child, pos + PCI_EXP_LNKCTL, reg16);
+		pci_pcie_capability_write_word(child, PCI_EXP_LNKCTL, reg16);
 	}
 	link->clkpm_enabled = !!enable;
 }
@@ -157,7 +153,7 @@ static void pcie_set_clkpm(struct pcie_link_state *link, int enable)
 
 static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 {
-	int pos, capable = 1, enabled = 1;
+	int capable = 1, enabled = 1;
 	u32 reg32;
 	u16 reg16;
 	struct pci_dev *child;
@@ -165,16 +161,13 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 
 	/* All functions should have the same cap and state, take the worst */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		pos = pci_pcie_cap(child);
-		if (!pos)
-			return;
-		pci_read_config_dword(child, pos + PCI_EXP_LNKCAP, &reg32);
+		pci_pcie_capability_read_dword(child, PCI_EXP_LNKCAP, &reg32);
 		if (!(reg32 & PCI_EXP_LNKCAP_CLKPM)) {
 			capable = 0;
 			enabled = 0;
 			break;
 		}
-		pci_read_config_word(child, pos + PCI_EXP_LNKCTL, &reg16);
+		pci_pcie_capability_read_word(child, PCI_EXP_LNKCTL, &reg16);
 		if (!(reg16 & PCI_EXP_LNKCTL_CLKREQ_EN))
 			enabled = 0;
 	}
@@ -190,7 +183,7 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
  */
 static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 {
-	int ppos, cpos, same_clock = 1;
+	int same_clock = 1;
 	u16 reg16, parent_reg, child_reg[8];
 	unsigned long start_jiffies;
 	struct pci_dev *child, *parent = link->pdev;
@@ -203,46 +196,43 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 	BUG_ON(!pci_is_pcie(child));
 
 	/* Check downstream component if bit Slot Clock Configuration is 1 */
-	cpos = pci_pcie_cap(child);
-	pci_read_config_word(child, cpos + PCI_EXP_LNKSTA, &reg16);
+	pci_pcie_capability_read_word(child, PCI_EXP_LNKSTA, &reg16);
 	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
 		same_clock = 0;
 
 	/* Check upstream component if bit Slot Clock Configuration is 1 */
-	ppos = pci_pcie_cap(parent);
-	pci_read_config_word(parent, ppos + PCI_EXP_LNKSTA, &reg16);
+	pci_pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
 	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
 		same_clock = 0;
 
 	/* Configure downstream component, all functions */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		cpos = pci_pcie_cap(child);
-		pci_read_config_word(child, cpos + PCI_EXP_LNKCTL, &reg16);
+		pci_pcie_capability_read_word(child, PCI_EXP_LNKCTL, &reg16);
 		child_reg[PCI_FUNC(child->devfn)] = reg16;
 		if (same_clock)
 			reg16 |= PCI_EXP_LNKCTL_CCC;
 		else
 			reg16 &= ~PCI_EXP_LNKCTL_CCC;
-		pci_write_config_word(child, cpos + PCI_EXP_LNKCTL, reg16);
+		pci_pcie_capability_write_word(child, PCI_EXP_LNKCTL, reg16);
 	}
 
 	/* Configure upstream component */
-	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
+	pci_pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
 	parent_reg = reg16;
 	if (same_clock)
 		reg16 |= PCI_EXP_LNKCTL_CCC;
 	else
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
-	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+	pci_pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 
 	/* Retrain link */
 	reg16 |= PCI_EXP_LNKCTL_RL;
-	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, reg16);
+	pci_pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end. Break out after waiting for timeout */
 	start_jiffies = jiffies;
 	for (;;) {
-		pci_read_config_word(parent, ppos + PCI_EXP_LNKSTA, &reg16);
+		pci_pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
 			break;
 		if (time_after(jiffies, start_jiffies + LINK_RETRAIN_TIMEOUT))
@@ -256,11 +246,10 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 	dev_printk(KERN_ERR, &parent->dev,
 		   "ASPM: Could not configure common clock\n");
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		cpos = pci_pcie_cap(child);
-		pci_write_config_word(child, cpos + PCI_EXP_LNKCTL,
-				      child_reg[PCI_FUNC(child->devfn)]);
+		pci_pcie_capability_write_word(child, PCI_EXP_LNKCTL,
+					child_reg[PCI_FUNC(child->devfn)]);
 	}
-	pci_write_config_word(parent, ppos + PCI_EXP_LNKCTL, parent_reg);
+	pci_pcie_capability_write_word(parent, PCI_EXP_LNKCTL, parent_reg);
 }
 
 /* Convert L0s latency encoding to ns */
@@ -305,16 +294,14 @@ struct aspm_register_info {
 static void pcie_get_aspm_reg(struct pci_dev *pdev,
 			      struct aspm_register_info *info)
 {
-	int pos;
 	u16 reg16;
 	u32 reg32;
 
-	pos = pci_pcie_cap(pdev);
-	pci_read_config_dword(pdev, pos + PCI_EXP_LNKCAP, &reg32);
+	pci_pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &reg32);
 	info->support = (reg32 & PCI_EXP_LNKCAP_ASPMS) >> 10;
 	info->latency_encoding_l0s = (reg32 & PCI_EXP_LNKCAP_L0SEL) >> 12;
 	info->latency_encoding_l1  = (reg32 & PCI_EXP_LNKCAP_L1EL) >> 15;
-	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &reg16);
 	info->enabled = reg16 & PCI_EXP_LNKCTL_ASPMC;
 }
 
@@ -420,7 +407,6 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 
 	/* Get and check endpoint acceptable latencies */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		int pos;
 		u32 reg32, encoding;
 		struct aspm_latency *acceptable =
 			&link->acceptable[PCI_FUNC(child->devfn)];
@@ -429,8 +415,7 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 		    pci_pcie_type(child) != PCI_EXP_TYPE_LEG_END)
 			continue;
 
-		pos = pci_pcie_cap(child);
-		pci_read_config_dword(child, pos + PCI_EXP_DEVCAP, &reg32);
+		pci_pcie_capability_read_dword(child, PCI_EXP_DEVCAP, &reg32);
 		/* Calculate endpoint L0s acceptable latency */
 		encoding = (reg32 & PCI_EXP_DEVCAP_L0S) >> 6;
 		acceptable->l0s = calc_l0s_acceptable(encoding);
@@ -445,12 +430,11 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 static void pcie_config_aspm_dev(struct pci_dev *pdev, u32 val)
 {
 	u16 reg16;
-	int pos = pci_pcie_cap(pdev);
 
-	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &reg16);
 	reg16 &= ~0x3;
 	reg16 |= val;
-	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+	pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, reg16);
 }
 
 static void pcie_config_aspm_link(struct pcie_link_state *link, u32 state)
@@ -505,7 +489,6 @@ static void free_link_state(struct pcie_link_state *link)
 static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 {
 	struct pci_dev *child;
-	int pos;
 	u32 reg32;
 
 	/*
@@ -513,8 +496,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	 * very strange. Disable ASPM for the whole slot
 	 */
 	list_for_each_entry(child, &pdev->subordinate->devices, bus_list) {
-		pos = pci_pcie_cap(child);
-		if (!pos)
+		if (!pci_is_pcie(child))
 			return -EINVAL;
 
 		/*
@@ -530,7 +512,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
 		 * RBER bit to determine if a function is 1.1 version device
 		 */
-		pci_read_config_dword(child, pos + PCI_EXP_DEVCAP, &reg32);
+		pci_pcie_capability_read_dword(child, PCI_EXP_DEVCAP, &reg32);
 		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
 			dev_printk(KERN_INFO, &child->dev, "disabling ASPM"
 				" on pre-1.1 PCIe device.  You can enable it"
-- 
1.7.9.5

