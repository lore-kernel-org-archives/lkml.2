Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1KOALv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:11:51 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:44958 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab1KOALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:11:47 -0500
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
Subject: [PATCH net-next v3 7/9] forcedeth: new ethtool stat counter for TX timeouts
Date: Mon, 14 Nov 2011 16:11:17 -0800
Message-Id: <cfddaec4b8bdd66e27295a86978af744eae2dd85.1321313729.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1321313729.git.david.decotigny@google.com>
References: <cover.1321313729.git.david.decotigny@google.com>
In-Reply-To: <cover.1321313729.git.david.decotigny@google.com>
References: <cover.1321313729.git.david.decotigny@google.com>
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
index 84e8d17..dd24035 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -633,6 +633,7 @@ static const struct nv_ethtool_str nv_estats_str[] = {
 	{ "rx_packets" },
 	{ "rx_errors_total" },
 	{ "tx_errors_total" },
+	{ "tx_timeout" },
 
 	/* version 2 stats */
 	{ "tx_deferral" },
@@ -673,6 +674,7 @@ struct nv_ethtool_stats {
 	u64 rx_packets; /* should be ifconfig->rx_packets */
 	u64 rx_errors_total;
 	u64 tx_errors_total;
+	u64 tx_timeout;
 
 	/* version 2 stats */
 	u64 tx_deferral;
@@ -852,6 +854,7 @@ struct fe_priv {
 	struct nv_driver_stat stat_tx_packets; /* not always available in HW */
 	struct nv_driver_stat stat_tx_bytes;
 	struct nv_driver_stat stat_tx_dropped;
+	atomic_t stat_tx_timeout;  /* TX timeouts since last nv_update_stats */
 
 	/* msi/msi-x fields */
 	u32 msi_flags;
@@ -1746,6 +1749,7 @@ static void nv_update_stats(struct net_device *dev)
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_packets);
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_bytes);
 	NV_DRIVER_STAT_UPDATE_TOTAL(&np->stat_tx_dropped);
+	np->estats.tx_timeout += atomic_xchg(&np->stat_tx_timeout, 0);
 }
 
 /*
@@ -2639,6 +2643,8 @@ static void nv_tx_timeout(struct net_device *dev)
 		}
 	}
 
+	atomic_inc(&np->stat_tx_timeout);
+
 	spin_lock_irq(&np->lock);
 
 	/* 1) stop tx engine */
-- 
1.7.3.1

