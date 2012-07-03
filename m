Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2GCF1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:27:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2GCF06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:26:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6760"; a="204586557"
X-IronPort-AV: E=Sophos;i="4.77,514,1336374000"; 
   d="scan'208";a="121591027"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        Cloud Ren <cjren@qca.qualcomm.com>
Subject: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Date: Tue, 3 Jul 2012 10:27:36 -0300
Message-ID: <1341322056-26582-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cloud Ren <cjren@qca.qualcomm.com>

some people report atl1c could cause system hang with following
kernel trace info:
---------------------------------------
WARNING: at.../net/sched/sch_generic.c:258 dev_watchdog+0x1db/0x1d0()
...
NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
...
---------------------------------------
This is caused by netif_stop_queue calling when cable Link is down.
So remove netif_stop_queue, because link_watch will take it over.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 85717cb..7901831 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -261,7 +261,6 @@ static void atl1c_check_link_status(struct atl1c_adapter *adapter)
 	if ((phy_data & BMSR_LSTATUS) == 0) {
 		/* link down */
 		netif_carrier_off(netdev);
-		netif_stop_queue(netdev);
 		hw->hibernate = true;
 		if (atl1c_reset_mac(hw) != 0)
 			if (netif_msg_hw(adapter))
-- 
1.7.7

