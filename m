Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162532Ab2GLXDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162525Ab2GLXD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/68] be2net: fix a race in be_xmit()
Date: Thu, 12 Jul 2012 16:01:48 -0700
Message-Id: <20120712175036.689626529@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd8f76c0a0c6fce0b2cf23c9bd0123f91453f46d ]

As soon as hardware is notified of a transmit, we no longer can assume
skb can be dereferenced, as TX completion might have freed the packet.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sathya Perla <sathya.perla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/benet/be_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -763,6 +763,8 @@ static netdev_tx_t be_xmit(struct sk_buf
 
 	copied = make_tx_wrbs(adapter, skb, wrb_cnt, dummy_wrb);
 	if (copied) {
+		int gso_segs = skb_shinfo(skb)->gso_segs;
+
 		/* record the sent skb in the sent_skb table */
 		BUG_ON(tx_obj->sent_skb_list[start]);
 		tx_obj->sent_skb_list[start] = skb;
@@ -780,8 +782,7 @@ static netdev_tx_t be_xmit(struct sk_buf
 
 		be_txq_notify(adapter, txq->id, wrb_cnt);
 
-		be_tx_stats_update(adapter, wrb_cnt, copied,
-				skb_shinfo(skb)->gso_segs, stopped);
+		be_tx_stats_update(adapter, wrb_cnt, copied, gso_segs, stopped);
 	} else {
 		txq->head = start;
 		dev_kfree_skb_any(skb);


