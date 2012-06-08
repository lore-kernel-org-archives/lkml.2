Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846Ab2FHFNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:13:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43316 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761444Ab2FHFHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:30 -0400
Message-Id: <20120608041850.136256179@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [ 69/82] r8169: fix early queue wake-up.
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

[ Upstream commit ae1f23fb433ac0aaff8aeaa5a7b14348e9aa8277 ]

With infinite gratitude to Eric Dumazet for allowing me to identify
the error.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 5104d76..5f3fa32 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5561,7 +5561,18 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	RTL_W8(TxPoll, NPQ);
 
 	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
+		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
+		 * not miss a ring update when it notices a stopped queue.
+		 */
+		smp_wmb();
 		netif_stop_queue(dev);
+		/* Sync with rtl_tx:
+		 * - publish queue status and cur_tx ring index (write barrier)
+		 * - refresh dirty_tx ring index (read barrier).
+		 * May the current thread have a pessimistic view of the ring
+		 * status and forget to wake up queue, a racing rtl_tx thread
+		 * can't.
+		 */
 		smp_mb();
 		if (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)
 			netif_wake_queue(dev);
@@ -5663,6 +5674,13 @@ static void rtl8169_tx_interrupt(struct net_device *dev,
 
 	if (tp->dirty_tx != dirty_tx) {
 		tp->dirty_tx = dirty_tx;
+		/* Sync with rtl8169_start_xmit:
+		 * - publish dirty_tx ring index (write barrier)
+		 * - refresh cur_tx ring index and queue status (read barrier)
+		 * May the current thread miss the stopped queue condition,
+		 * a racing xmit thread can only have a right view of the
+		 * ring status.
+		 */
 		smp_mb();
 		if (netif_queue_stopped(dev) &&
 		    (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)) {


