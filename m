Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0LOUOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:14:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:5800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0LOUOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:14:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,350,1288594800"; 
   d="scan'208";a="362217866"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "John Fastabend" <john.r.fastabend@intel.com>,
        "Xinan Tang" <xinan.tang@intel.com>,
        "Junchang Wang" <junchangwang@gmail.com>
Cc: "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Junchang Wang <junchangwang@gmail.com>,
        Xinan Tang <xinan.tang@intel.com>
Subject: [PATCH 3/3] drivers/net/ixgbe/ixgbe_main.c: get tx queue mapping specified in socket
Date: Wed, 15 Dec 2010 12:02:06 -0800
Message-Id: <e37daf1b95d0e61008c69298db5520d6b97acdba.1292405004.git.fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <cover.1292405004.git.fenghua.yu@intel.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
In-Reply-To: <cover.1292405004.git.fenghua.yu@intel.com>
References: <cover.1292405004.git.fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Instead of using calculated tx queue mapping, this patch selects tx queue mapping
which is specified in socket.

By doing this, tx queue mapping can be bigger than the number of cores and
stressfully use multiqueue TSS. Or application can specify some of cores/queues
to send packets and implement flexible load balance policies.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Junchang Wang <junchangwang@gmail.com>
Signed-off-by: Xinan Tang <xinan.tang@intel.com>
---
 drivers/net/ixgbe/ixgbe_main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index eee0b29..4d98928 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -6255,7 +6255,14 @@ static int ixgbe_maybe_stop_tx(struct net_device *netdev,
 static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
-	int txq = smp_processor_id();
+	int txq;
+
+	txq = sk_tx_queue_get(skb->sk);
+
+	if (txq >= 0 && txq < dev->real_num_tx_queues)
+		return txq;
+
+	txq = smp_processor_id();
 #ifdef IXGBE_FCOE
 	__be16 protocol;
 
-- 
1.6.0.3

