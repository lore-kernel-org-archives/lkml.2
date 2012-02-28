Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428Ab2B1BOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:14:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965372Ab2B1BMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.220.7 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010434.956400374@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Riesch <christian.riesch@omicron.at>,
        Cyril Chemparathy <cyril@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 63/72] davinci_emac: Do not free all rx dma descriptors during init
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Riesch <christian.riesch@omicron.at>

commit 5d69703263d588dbb03f4e57091afd8942d96e6d upstream.

This patch fixes a regression that was introduced by

commit 0a5f38467765ee15478db90d81e40c269c8dda20
davinci_emac: Add Carrier Link OK check in Davinci RX Handler

Said commit adds a check whether the carrier link is ok. If the link is
not ok, the skb is freed and no new dma descriptor added to the rx dma
channel. This causes trouble during initialization when the carrier
status has not yet been updated. If a lot of packets are received while
netif_carrier_ok returns false, all dma descriptors are freed and the
rx dma transfer is stopped.

The bug occurs when the board is connected to a network with lots of
traffic and the ifconfig down/up is done, e.g., when reconfiguring
the interface with DHCP.

The bug can be reproduced by flood pinging the davinci board while doing
ifconfig eth0 down
ifconfig eth0 up
on the board.

After that, the rx path stops working and the overrun value reported
by ifconfig is counting up.

This patch reverts commit 0a5f38467765ee15478db90d81e40c269c8dda20
and instead issues warnings only if cpdma_chan_submit returns -ENOMEM.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: <stable@vger.kernel.org>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Rajashekhara, Sudhakar <sudhakar.raj@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/davinci_emac.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1007,7 +1007,7 @@ static void emac_rx_handler(void *token,
 	int			ret;
 
 	/* free and bail if we are shutting down */
-	if (unlikely(!netif_running(ndev) || !netif_carrier_ok(ndev))) {
+	if (unlikely(!netif_running(ndev))) {
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -1036,7 +1036,9 @@ static void emac_rx_handler(void *token,
 recycle:
 	ret = cpdma_chan_submit(priv->rxchan, skb, skb->data,
 			skb_tailroom(skb), GFP_KERNEL);
-	if (WARN_ON(ret < 0))
+
+	WARN_ON(ret == -ENOMEM);
+	if (unlikely(ret < 0))
 		dev_kfree_skb_any(skb);
 }
 


