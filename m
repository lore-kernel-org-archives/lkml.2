Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2GIOia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab2GIOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:20 -0400
Message-Id: <20120709143121.566212315@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/48] be2net: fix a race in be_xmit()
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd8f76c0a0c6fce0b2cf23c9bd0123f91453f46d ]

As soon as hardware is notified of a transmit, we no longer can assume
skb can be dereferenced, as TX completion might have freed the packet.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/emulex/benet/be_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index bf266a0..36c7c4e 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -696,6 +696,8 @@ static netdev_tx_t be_xmit(struct sk_buff *skb,
 
 	copied = make_tx_wrbs(adapter, txq, skb, wrb_cnt, dummy_wrb);
 	if (copied) {
+		int gso_segs = skb_shinfo(skb)->gso_segs;
+
 		/* record the sent skb in the sent_skb table */
 		BUG_ON(txo->sent_skb_list[start]);
 		txo->sent_skb_list[start] = skb;
@@ -713,8 +715,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb,
 
 		be_txq_notify(adapter, txq->id, wrb_cnt);
 
-		be_tx_stats_update(txo, wrb_cnt, copied,
-				skb_shinfo(skb)->gso_segs, stopped);
+		be_tx_stats_update(txo, wrb_cnt, copied, gso_segs, stopped);
 	} else {
 		txq->head = start;
 		dev_kfree_skb_any(skb);


