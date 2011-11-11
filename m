Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1KKBiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:38:24 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51302 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1KKBiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:38:23 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 20:38:23 EST
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v2 08/10] forcedeth: new ethtool stat counter for TX timeouts
Date: Thu, 10 Nov 2011 17:31:33 -0800
Message-Id: <b6e297c17195225568324d8d57c37b9049e924ad.1320974990.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
In-Reply-To: <cover.1320974990.git.david.decotigny@google.com>
References: <cover.1320974990.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change publishes a new ethtool stats: tx_timeout that counts the
number of times the tx_timeout callback was triggered.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 0a979b8..7813c37 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -634,6 +634,7 @@ static const struct nv_ethtool_str nv_estats_str[] = {
 	{ "rx_packets" },
 	{ "rx_errors_total" },
 	{ "tx_errors_total" },
+	{ "tx_timeout" },
 
 	/* version 2 stats */
 	{ "tx_deferral" },
@@ -674,6 +675,7 @@ struct nv_ethtool_stats {
 	u64 rx_packets;
 	u64 rx_errors_total;
 	u64 tx_errors_total;
+	u64 tx_timeout;
 
 	/* version 2 stats */
 	u64 tx_deferral;
@@ -851,6 +853,7 @@ struct fe_priv {
 	/* TX software stats */
 	struct nv_driver_stat stat_tx_packets; /* not always available in HW */
 	struct nv_driver_stat stat_tx_dropped;
+	atomic_t stat_tx_timeout;  /* TX timeouts since last nv_update_stats */
 
 	/* msi/msi-x fields */
 	u32 msi_flags;
@@ -1743,6 +1746,7 @@ static void nv_update_stats(struct net_device *dev)
 
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_packets);
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_dropped);
+	np->estats.tx_timeout += atomic_xchg(&np->stat_tx_timeout, 0);
 }
 
 /*
@@ -2624,6 +2628,8 @@ static void nv_tx_timeout(struct net_device *dev)
 		}
 	}
 
+	atomic_inc(&np->stat_tx_timeout);
+
 	spin_lock_irq(&np->lock);
 
 	/* 1) stop tx engine */
-- 
1.7.3.1

