Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1KKBkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:40:37 -0500
Received: from mail-wy0-f202.google.com ([74.125.82.202]:39994 "EHLO
	mail-wy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1KKBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:40:30 -0500
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
Subject: [PATCH net-next v2 07/10] forcedeth: account for dropped RX frames
Date: Thu, 10 Nov 2011 17:31:32 -0800
Message-Id: <d92ce3b825650e1be19baa6379e8dd51d886c65b.1320974990.git.david.decotigny@google.com>
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

This adds the stats counter for dropped RX frames.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index cabc121..0a979b8 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -824,6 +824,7 @@ struct fe_priv {
 	/* RX software stats */
 	struct nv_driver_stat stat_rx_bytes; /* not always available in HW */
 	struct nv_driver_stat stat_rx_missed_errors;
+	struct nv_driver_stat stat_rx_dropped;
 
 	/* media detection workaround.
 	 * Locking: Within irq hander or disable_irq+spin_lock(&np->lock);
@@ -1738,6 +1739,7 @@ static void nv_update_stats(struct net_device *dev)
 	/* update software stats */
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_rx_bytes);
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_rx_missed_errors);
+	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_rx_dropped);
 
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_packets);
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_dropped);
@@ -1780,6 +1782,8 @@ nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 		storage->tx_bytes   = np->estats.tx_bytes;
 		storage->rx_errors  = np->estats.rx_errors_total;
 		storage->tx_errors  = np->estats.tx_errors_total;
+		storage->rx_dropped = NV_DRIVER_STAT_GET_TOTAL(
+			&np->stat_rx_dropped);
 		storage->tx_dropped = NV_DRIVER_STAT_GET_TOTAL(
 			&np->stat_tx_dropped);
 
@@ -1835,8 +1839,10 @@ static int nv_alloc_rx(struct net_device *dev)
 				np->put_rx.orig = np->first_rx.orig;
 			if (unlikely(np->put_rx_ctx++ == np->last_rx_ctx))
 				np->put_rx_ctx = np->first_rx_ctx;
-		} else
+		} else {
+			NV_DRIVER_STAT_ATOMIC_INC(&np->stat_rx_dropped);
 			return 1;
+		}
 	}
 	return 0;
 }
@@ -1867,8 +1873,10 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 				np->put_rx.ex = np->first_rx.ex;
 			if (unlikely(np->put_rx_ctx++ == np->last_rx_ctx))
 				np->put_rx_ctx = np->first_rx_ctx;
-		} else
+		} else {
+			NV_DRIVER_STAT_ATOMIC_INC(&np->stat_rx_dropped);
 			return 1;
+		}
 	}
 	return 0;
 }
-- 
1.7.3.1

