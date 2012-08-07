Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2HGW3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2HGW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cloud Ren <cjren@qca.qualcomm.com>, xiong <xiong@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 052/122] atl1c: fix issue of io access mode for AR8152 v2.1
Date: Tue,  7 Aug 2012 15:25:40 -0700
Message-Id: <20120807221952.916532455@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cloud Ren <cjren@qca.qualcomm.com>

commit fa0afcd10951afad2022dda09777d2bf70cdab3d upstream.

When io access mode is enabled by BOOTROM or BIOS for AR8152 v2.1,
the register can't be read/write by memory access mode.
Clearing Bit 8  of Register 0x21c could fixed the issue.

Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
Signed-off-by: xiong <xiong@qca.qualcomm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |    5 +++++
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |   16 +++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -74,6 +74,8 @@ void atl1c_post_phy_linkchg(struct atl1c
 #define PCI_DEVICE_ID_ATHEROS_L1D_2_0	0x1083 /* AR8151 v2.0 Gigabit 1000 */
 #define L2CB_V10			0xc0
 #define L2CB_V11			0xc1
+#define L2CB_V20			0xc0
+#define L2CB_V21			0xc1
 
 /* register definition */
 #define REG_DEVICE_CAP              	0x5C
@@ -87,6 +89,9 @@ void atl1c_post_phy_linkchg(struct atl1c
 #define LINK_CTRL_L1_EN			0x02
 #define LINK_CTRL_EXT_SYNC		0x80
 
+#define REG_PCIE_IND_ACC_ADDR		0x80
+#define REG_PCIE_IND_ACC_DATA		0x84
+
 #define REG_DEV_SERIALNUM_CTRL		0x200
 #define REG_DEV_MAC_SEL_MASK		0x0 /* 0:EUI; 1:MAC */
 #define REG_DEV_MAC_SEL_SHIFT		0
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -739,6 +739,8 @@ static const struct atl1c_platform_patch
 
 static void __devinit atl1c_patch_assign(struct atl1c_hw *hw)
 {
+	struct pci_dev	*pdev = hw->adapter->pdev;
+	u32 misc_ctrl;
 	int i = 0;
 
 	hw->msi_lnkpatch = false;
@@ -753,6 +755,18 @@ static void __devinit atl1c_patch_assign
 		}
 		i++;
 	}
+
+	if (hw->device_id == PCI_DEVICE_ID_ATHEROS_L2C_B2 &&
+	    hw->revision_id == L2CB_V21) {
+		/* config acess mode */
+		pci_write_config_dword(pdev, REG_PCIE_IND_ACC_ADDR,
+				       REG_PCIE_DEV_MISC_CTRL);
+		pci_read_config_dword(pdev, REG_PCIE_IND_ACC_DATA, &misc_ctrl);
+		misc_ctrl &= ~0x100;
+		pci_write_config_dword(pdev, REG_PCIE_IND_ACC_ADDR,
+				       REG_PCIE_DEV_MISC_CTRL);
+		pci_write_config_dword(pdev, REG_PCIE_IND_ACC_DATA, misc_ctrl);
+	}
 }
 /*
  * atl1c_sw_init - Initialize general software structures (struct atl1c_adapter)
@@ -780,7 +794,7 @@ static int __devinit atl1c_sw_init(struc
 	hw->device_id = pdev->device;
 	hw->subsystem_vendor_id = pdev->subsystem_vendor;
 	hw->subsystem_id = pdev->subsystem_device;
-	AT_READ_REG(hw, PCI_CLASS_REVISION, &revision);
+	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &revision);
 	hw->revision_id = revision & 0xFF;
 	/* before link up, we assume hibernate is true */
 	hw->hibernate = true;


