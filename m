Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1GUQ6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:58:41 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36892
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752881Ab1GUQ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:58:29 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 8/9] staging: hv: fix the return status of netvsc_start_xmit()
Date: Thu, 21 Jul 2011 10:14:56 -0700
Message-Id: <1311268497-8671-9-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
References: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the return status, so the upper layer will retry if transmission
fails.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index a15165e..818ddf8 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -142,12 +142,12 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 			 (num_pages * sizeof(struct hv_page_buffer)) +
 			 sizeof(struct rndis_filter_packet), GFP_ATOMIC);
 	if (!packet) {
-		/* out of memory, silently drop packet */
+		/* out of memory, drop packet */
 		netdev_err(net, "unable to allocate hv_netvsc_packet\n");
 
 		dev_kfree_skb(skb);
 		net->stats.tx_dropped++;
-		return NETDEV_TX_OK;
+		return NETDEV_TX_BUSY;
 	}
 
 	packet->extension = (void *)(unsigned long)packet +
@@ -196,7 +196,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 		dev_kfree_skb_any(skb);
 	}
 
-	return NETDEV_TX_OK;
+	return ret ? NETDEV_TX_BUSY : NETDEV_TX_OK;
 }
 
 /*
-- 
1.6.3.2

