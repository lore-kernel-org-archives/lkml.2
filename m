Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2DRFd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:33:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11296 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2DRFdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:33:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="180355739"
X-IronPort-AV: E=Sophos;i="4.75,438,1330934400"; 
   d="scan'208";a="303291721"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 04/12] atl1c: remove VPD register
Date: Wed, 18 Apr 2012 13:32:28 +0800
Message-ID: <1334727156-6830-5-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VPD register is only used for L1(devid=PCI_DEVICE_ID_ATTANSIC_L1) to
access external NV-memory.
l1c & later chip doesn't use it any more.
PHY 0/1 registers occupy the last 2 slots of the dump table.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |    7 +++----
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h      |   11 -----------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index c725ee5..cf82b74 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -100,7 +100,7 @@
 #define ATL1C_ASPM_L0s_ENABLE		0x0001
 #define ATL1C_ASPM_L1_ENABLE		0x0002
 
-#define AT_REGS_LEN	(75 * sizeof(u32))
+#define AT_REGS_LEN	(74 * sizeof(u32))
 #define AT_EEPROM_LEN 	512
 
 #define ATL1C_GET_DESC(R, i, type)	(&(((type *)((R)->desc))[i]))
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
index 0a9326a..3feb846 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
@@ -141,8 +141,7 @@ static void atl1c_get_regs(struct net_device *netdev,
 
 	memset(p, 0, AT_REGS_LEN);
 
-	regs->version = 0;
-	AT_READ_REG(hw, REG_VPD_CAP, 		  p++);
+	regs->version = 1;
 	AT_READ_REG(hw, REG_PM_CTRL, 		  p++);
 	AT_READ_REG(hw, REG_MAC_HALF_DUPLX_CTRL,  p++);
 	AT_READ_REG(hw, REG_TWSI_CTRL, 		  p++);
@@ -167,9 +166,9 @@ static void atl1c_get_regs(struct net_device *netdev,
 	AT_READ_REG(hw, REG_WOL_CTRL, 		  p++);
 
 	atl1c_read_phy_reg(hw, MII_BMCR, &phy_data);
-	regs_buff[73] =	(u32) phy_data;
+	regs_buff[AT_REGS_LEN/sizeof(u32) - 2] = (u32) phy_data;
 	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-	regs_buff[74] = (u32) phy_data;
+	regs_buff[AT_REGS_LEN/sizeof(u32) - 1] = (u32) phy_data;
 }
 
 static int atl1c_get_eeprom_len(struct net_device *netdev)
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index c22d698..f5c7473 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -59,17 +59,6 @@ int atl1c_phy_power_saving(struct atl1c_hw *hw);
 #define LINK_CTRL_L1_EN			0x02
 #define LINK_CTRL_EXT_SYNC		0x80
 
-#define REG_VPD_CAP			0x6C
-#define VPD_CAP_ID_MASK                 0xff
-#define VPD_CAP_ID_SHIFT                0
-#define VPD_CAP_NEXT_PTR_MASK           0xFF
-#define VPD_CAP_NEXT_PTR_SHIFT          8
-#define VPD_CAP_VPD_ADDR_MASK           0x7FFF
-#define VPD_CAP_VPD_ADDR_SHIFT          16
-#define VPD_CAP_VPD_FLAG                0x80000000
-
-#define REG_VPD_DATA                	0x70
-
 #define REG_PCIE_UC_SEVERITY		0x10C
 #define PCIE_UC_SERVRITY_TRN		0x00000001
 #define PCIE_UC_SERVRITY_DLP		0x00000010
-- 
1.7.7

