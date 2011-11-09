Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935887Ab1KJDkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965213Ab1KJDj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.188299805@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [100/264] dp83640: free packet queues on remove
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 8b3408f8ee994973869d8ba32c5bf482bc4ddca4 upstream.

If the PHY should disappear (for example, on an USB Ethernet MAC), then
the driver would leak any undelivered time stamp packets. This commit
fixes the issue by calling the appropriate functions to free any packets
left in the transmit and receive queues.

The driver first appeared in v3.0.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/phy/dp83640.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -875,6 +875,7 @@ static void dp83640_remove(struct phy_de
 	struct dp83640_clock *clock;
 	struct list_head *this, *next;
 	struct dp83640_private *tmp, *dp83640 = phydev->priv;
+	struct sk_buff *skb;
 
 	if (phydev->addr == BROADCAST_ADDR)
 		return;
@@ -882,6 +883,12 @@ static void dp83640_remove(struct phy_de
 	enable_status_frames(phydev, false);
 	cancel_work_sync(&dp83640->ts_work);
 
+	while ((skb = skb_dequeue(&dp83640->rx_queue)) != NULL)
+		kfree_skb(skb);
+
+	while ((skb = skb_dequeue(&dp83640->tx_queue)) != NULL)
+		skb_complete_tx_timestamp(skb, NULL);
+
 	clock = dp83640_clock_get(dp83640->clock);
 
 	if (dp83640 == clock->chosen) {


