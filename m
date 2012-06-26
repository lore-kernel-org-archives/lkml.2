Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab2FZHcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:32:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29920 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2FZHcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:32:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6753"; a="202214942"
X-IronPort-AV: E=Sophos;i="4.77,476,1336374000"; 
   d="scan'208";a="121505399"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Date: Tue, 26 Jun 2012 12:33:06 -0300
Message-ID: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>

some people report atl1c could cause system hang with following
kernel trace info:
---------------------------------------
WARNING: at.../net/sched/sch_generic.c:258
dev_watchdog+0x1db/0x1d0()
...
NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
...
---------------------------------------
This is caused by netif_stop_queue calling when cable Link is down
but netif_wake_queue isn't called when cable Link is resume.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 85717cb..c2736c4 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -351,6 +351,8 @@ static void atl1c_common_task(struct work_struct *work)
 		atl1c_irq_disable(adapter);
 		atl1c_check_link_status(adapter);
 		atl1c_irq_enable(adapter);
+		if (netif_queue_stopped(netdev) && netif_carrier_ok(netdev))
+			netif_wake_queue(netdev);
 	}
 }
 
-- 
1.7.7

