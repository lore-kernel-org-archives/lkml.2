Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2BTWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:36:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36509 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2BTWgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:36:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mark.einon@gmail.com designates 10.180.95.1 as permitted sender) smtp.mail=mark.einon@gmail.com; dkim=pass header.i=mark.einon@gmail.com
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] staging: et131x: use netif_rx_ni() for packet receive
Date: Mon, 20 Feb 2012 22:33:24 +0000
Message-Id: <1329777204-2077-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netif_rx is meant to be called from interrupts because it doesn't wake
up ksoftirqd.  For calling from outside interrupts, netif_rx_ni exists.

This stops the error "NOHZ: local_softirq_panding 08" that happens on
some machines with NOHZ and plip --- it is caused by the fact that
softirq is pending and ksoftirqd is sleeping.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2c4069f..b4167ad 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3109,7 +3109,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 		skb->protocol = eth_type_trans(skb, adapter->netdev);
 		skb->ip_summed = CHECKSUM_NONE;
 
-		netif_rx(skb);
+		netif_rx_ni(skb);
 	} else {
 		rfd->len = 0;
 	}
-- 
1.7.7.6

