Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2EABkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:40:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12931 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2EABkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:40:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="186394386"
X-IronPort-AV: E=Sophos;i="4.75,506,1330934400"; 
   d="scan'208";a="120671496"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 07/10] atl1c: cancel task when interface closed
Date: Tue, 1 May 2012 09:38:55 +0800
Message-ID: <1335836338-9425-8-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
References: <1335836338-9425-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

common_task might be running while close routine is called,
wait/cancel it.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index d910dbb..b95ef45 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -330,6 +330,9 @@ static void atl1c_common_task(struct work_struct *work)
 	adapter = container_of(work, struct atl1c_adapter, common_task);
 	netdev = adapter->netdev;
 
+	if (test_bit(__AT_DOWN, &adapter->flags))
+		return;
+
 	if (test_and_clear_bit(ATL1C_WORK_EVENT_RESET, &adapter->work_event)) {
 		netif_device_detach(netdev);
 		atl1c_down(adapter);
@@ -2311,6 +2314,8 @@ static int atl1c_close(struct net_device *netdev)
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	WARN_ON(test_bit(__AT_RESETTING, &adapter->flags));
+	set_bit(__AT_DOWN, &adapter->flags);
+	cancel_work_sync(&adapter->common_task);
 	atl1c_down(adapter);
 	atl1c_free_ring_resources(adapter);
 	return 0;
-- 
1.7.7

