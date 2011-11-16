Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1KPWRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:17:14 -0500
Received: from mail-vx0-f202.google.com ([209.85.220.202]:49306 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1KPWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:15:38 -0500
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net-next v6 8/9] forcedeth: account for dropped RX frames
Date: Wed, 16 Nov 2011 14:15:14 -0800
Message-Id: <5bbe62a35ef59180b02d8dd0086641a04b17d38a.1321481064.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
In-Reply-To: <cover.1321481064.git.david.decotigny@google.com>
References: <cover.1321481064.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds code to update the stats counter for dropped RX frames.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 427c9c1..9bf993d 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -815,6 +815,7 @@ struct fe_priv {
 	u64 stat_rx_packets;
 	u64 stat_rx_bytes; /* not always available in HW */
 	u64 stat_rx_missed_errors;
+	u64 stat_rx_dropped;
 
 	/* media detection workaround.
 	 * Locking: Within irq hander or disable_irq+spin_lock(&np->lock);
@@ -1758,6 +1759,7 @@ nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 		syncp_start = u64_stats_fetch_begin(&np->swstats_rx_syncp);
 		storage->rx_packets       = np->stat_rx_packets;
 		storage->rx_bytes         = np->stat_rx_bytes;
+		storage->rx_dropped       = np->stat_rx_dropped;
 		storage->rx_missed_errors = np->stat_rx_missed_errors;
 	} while (u64_stats_fetch_retry(&np->swstats_rx_syncp, syncp_start));
 
@@ -1828,8 +1830,12 @@ static int nv_alloc_rx(struct net_device *dev)
 				np->put_rx.orig = np->first_rx.orig;
 			if (unlikely(np->put_rx_ctx++ == np->last_rx_ctx))
 				np->put_rx_ctx = np->first_rx_ctx;
-		} else
+		} else {
+			u64_stats_update_begin(&np->swstats_rx_syncp);
+			np->stat_rx_dropped++;
+			u64_stats_update_end(&np->swstats_rx_syncp);
 			return 1;
+		}
 	}
 	return 0;
 }
@@ -1860,8 +1866,12 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 				np->put_rx.ex = np->first_rx.ex;
 			if (unlikely(np->put_rx_ctx++ == np->last_rx_ctx))
 				np->put_rx_ctx = np->first_rx_ctx;
-		} else
+		} else {
+			u64_stats_update_begin(&np->swstats_rx_syncp);
+			np->stat_rx_dropped++;
+			u64_stats_update_end(&np->swstats_rx_syncp);
 			return 1;
+		}
 	}
 	return 0;
 }
-- 
1.7.3.1

