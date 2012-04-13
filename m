Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966722Ab2DMAU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:20:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18606 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966688Ab2DMAUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:20:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="178951033"
X-IronPort-AV: E=Sophos;i="4.73,1,1325491200"; 
   d="scan'208";a="120314433"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 34/37] atl1c: clear WoL status when reset pcie
Date: Fri, 13 Apr 2012 08:14:59 +0800
Message-ID: <1334276102-15866-35-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WoL status is read-clear and should be cleared when in S0
status.
putting it in atl1c_reset_pcie is more suitable than
in atl1c_get_permanent_address.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   |    5 -----
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
index 840150e..cd52d37 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -73,7 +73,6 @@ static int atl1c_get_permanent_address(struct atl1c_hw *hw)
 	u32 otp_ctrl_data;
 	u32 twsi_ctrl_data;
 	u32 ltssm_ctrl_data;
-	u32 wol_data;
 	u8  eth_addr[ETH_ALEN];
 	u16 phy_data;
 	bool raise_vol = false;
@@ -114,10 +113,6 @@ static int atl1c_get_permanent_address(struct atl1c_hw *hw)
 		ltssm_ctrl_data &= ~LTSSM_ID_EN_WRO;
 		AT_WRITE_REG(hw, REG_LTSSM_ID_CTRL, ltssm_ctrl_data);
 
-		/* clear any WOL settings */
-		AT_WRITE_REG(hw, REG_WOL_CTRL, 0);
-		AT_READ_REG(hw, REG_WOL_CTRL, &wol_data);
-
 
 		AT_READ_REG(hw, REG_TWSI_CTRL, &twsi_ctrl_data);
 		twsi_ctrl_data |= TWSI_CTRL_SW_LDSTART;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 5b51099..79dae19 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -132,6 +132,9 @@ static void atl1c_reset_pcie(struct atl1c_hw *hw, u32 flag)
 	 */
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
+	/* wol sts read-clear */
+	AT_READ_REG(hw, REG_WOL_CTRL, &data);
+	AT_WRITE_REG(hw, REG_WOL_CTRL, 0);
 
 	/*
 	 * Mask some pcie error bits
-- 
1.7.7

