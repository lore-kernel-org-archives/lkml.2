Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966431Ab2DMAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:16:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29964 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966417Ab2DMAQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:16:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="178949639"
X-IronPort-AV: E=Sophos;i="4.75,411,1330934400"; 
   d="scan'208";a="196066654"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 07/37] atl1c: remove code related to rxq 1/2/3
Date: Fri, 13 Apr 2012 08:14:32 +0800
Message-ID: <1334276102-15866-8-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove code related to rxq 1/2/3 since multi-q not support.
refine REG_RXQ_CTRL definition as well.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |   29 +++++++++-------------
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    3 +-
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index ca45fad..18c1f18 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -493,26 +493,21 @@ int atl1c_phy_power_saving(struct atl1c_hw *hw);
 #define ASPM_THRUPUT_LIMIT_NO		0x00
 #define ASPM_THRUPUT_LIMIT_1M		0x01
 #define ASPM_THRUPUT_LIMIT_10M		0x02
-#define ASPM_THRUPUT_LIMIT_100M		0x04
-#define RXQ1_CTRL_EN			0x10
-#define RXQ2_CTRL_EN			0x20
-#define RXQ3_CTRL_EN			0x40
-#define IPV6_CHKSUM_CTRL_EN		0x80
-#define RSS_HASH_BITS_MASK		0x00FF
-#define RSS_HASH_BITS_SHIFT		8
-#define RSS_HASH_IPV4			0x10000
-#define RSS_HASH_IPV4_TCP		0x20000
-#define RSS_HASH_IPV6			0x40000
-#define RSS_HASH_IPV6_TCP		0x80000
+#define ASPM_THRUPUT_LIMIT_100M		0x03
+#define IPV6_CHKSUM_CTRL_EN		BIT(7)
 #define RXQ_RFD_BURST_NUM_MASK		0x003F
 #define RXQ_RFD_BURST_NUM_SHIFT		20
-#define RSS_MODE_MASK			0x0003
+#define RXQ_NUM_RFD_PREF_DEF		8
+#define RSS_MODE_MASK			3UL
 #define RSS_MODE_SHIFT			26
-#define RSS_NIP_QUEUE_SEL_MASK		0x1
-#define RSS_NIP_QUEUE_SEL_SHIFT		28
-#define RRS_HASH_CTRL_EN		0x20000000
-#define RX_CUT_THRU_EN			0x40000000
-#define RXQ_CTRL_EN			0x80000000
+#define RSS_MODE_DIS			0
+#define RSS_MODE_SQSI			1
+#define RSS_MODE_MQSI			2
+#define RSS_MODE_MQMI			3
+#define RSS_NIP_QUEUE_SEL		BIT(28) /* 0:q0, 1:table */
+#define RRS_HASH_CTRL_EN		BIT(29)
+#define RX_CUT_THRU_EN			BIT(30)
+#define RXQ_CTRL_EN			BIT(31)
 
 #define REG_RFD_FREE_THRESH		0x15A4
 #define RFD_FREE_THRESH_MASK		0x003F
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index c7d7640..ca1259d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1137,8 +1137,7 @@ static int atl1c_stop_mac(struct atl1c_hw *hw)
 	u32 data;
 
 	AT_READ_REG(hw, REG_RXQ_CTRL, &data);
-	data &= ~(RXQ1_CTRL_EN | RXQ2_CTRL_EN |
-		  RXQ3_CTRL_EN | RXQ_CTRL_EN);
+	data &= ~RXQ_CTRL_EN;
 	AT_WRITE_REG(hw, REG_RXQ_CTRL, data);
 
 	AT_READ_REG(hw, REG_TXQ_CTRL, &data);
-- 
1.7.7

