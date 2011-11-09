Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab1KJDkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965213Ab1KJDkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.391379932@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Cochran <richard.cochran@omicron.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [102/264] net: hold sock reference while processing tx timestamps
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit da92b194cc36b5dc1fbd85206aeeffd80bee0c39 upstream.

The pair of functions,

 * skb_clone_tx_timestamp()
 * skb_complete_tx_timestamp()

were designed to allow timestamping in PHY devices. The first
function, called during the MAC driver's hard_xmit method, identifies
PTP protocol packets, clones them, and gives them to the PHY device
driver. The PHY driver may hold onto the packet and deliver it at a
later time using the second function, which adds the packet to the
socket's error queue.

As pointed out by Johannes, nothing prevents the socket from
disappearing while the cloned packet is sitting in the PHY driver
awaiting a timestamp. This patch fixes the issue by taking a reference
on the socket for each such packet. In addition, the comments
regarding the usage of these function are expanded to highlight the
rule that PHY drivers must use skb_complete_tx_timestamp() to release
the packet, in order to release the socket reference, too.

These functions first appeared in v2.6.36.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/phy.h     |    2 +-
 include/linux/skbuff.h  |    7 ++++++-
 net/core/timestamping.c |   12 ++++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -420,7 +420,7 @@ struct phy_driver {
 
 	/*
 	 * Requests a Tx timestamp for 'skb'. The phy driver promises
-	 * to deliver it to the socket's error queue as soon as a
+	 * to deliver it using skb_complete_tx_timestamp() as soon as a
 	 * timestamp becomes available. One of the PTP_CLASS_ values
 	 * is passed in 'type'.
 	 */
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2020,8 +2020,13 @@ static inline bool skb_defer_rx_timestam
 /**
  * skb_complete_tx_timestamp() - deliver cloned skb with tx timestamps
  *
+ * PHY drivers may accept clones of transmitted packets for
+ * timestamping via their phy_driver.txtstamp method. These drivers
+ * must call this function to return the skb back to the stack, with
+ * or without a timestamp.
+ *
  * @skb: clone of the the original outgoing packet
- * @hwtstamps: hardware time stamps
+ * @hwtstamps: hardware time stamps, may be NULL if not available
  *
  */
 void skb_complete_tx_timestamp(struct sk_buff *skb,
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -57,9 +57,13 @@ void skb_clone_tx_timestamp(struct sk_bu
 	case PTP_CLASS_V2_VLAN:
 		phydev = skb->dev->phydev;
 		if (likely(phydev->drv->txtstamp)) {
+			if (!atomic_inc_not_zero(&sk->sk_refcnt))
+				return;
 			clone = skb_clone(skb, GFP_ATOMIC);
-			if (!clone)
+			if (!clone) {
+				sock_put(sk);
 				return;
+			}
 			clone->sk = sk;
 			phydev->drv->txtstamp(phydev, clone, type);
 		}
@@ -77,8 +81,11 @@ void skb_complete_tx_timestamp(struct sk
 	struct sock_exterr_skb *serr;
 	int err;
 
-	if (!hwtstamps)
+	if (!hwtstamps) {
+		sock_put(sk);
+		kfree_skb(skb);
 		return;
+	}
 
 	*skb_hwtstamps(skb) = *hwtstamps;
 	serr = SKB_EXT_ERR(skb);
@@ -87,6 +94,7 @@ void skb_complete_tx_timestamp(struct sk
 	serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
 	skb->sk = NULL;
 	err = sock_queue_err_skb(sk, skb);
+	sock_put(sk);
 	if (err)
 		kfree_skb(skb);
 }


