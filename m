Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0GASaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:30:01 -0400
Received: from kroah.org ([198.145.64.141]:40813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab0GASYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:22 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:17 2010
Message-Id: <20100701173217.690333248@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiajun Wu <b06378@freescale.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 129/149] ucc_geth: Fix full TX queue processing
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiajun Wu <b06378@freescale.com>

commit 34692421bc7d6145ef383b014860f4fde10b7505 upstream.

commit 7583605b6d29f1f7f6fc505b883328089f3485ad ("ucc_geth: Fix empty
TX queue processing") fixed empty TX queue mishandling, but didn't
account another corner case: when TX queue becomes full.

Without this patch the driver will stop transmiting when TX queue
becomes full since 'bd == ugeth->txBd[txQ]' actually checks for
two things: queue empty or full.

Let's better check for NULL skb, which unambiguously signals an empty
queue.

Signed-off-by: Jiajun Wu <b06378@freescale.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ucc_geth.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3276,13 +3276,12 @@ static int ucc_geth_tx(struct net_device
 		/* Handle the transmitted buffer and release */
 		/* the BD to be used with the current frame  */
 
-		if (bd == ugeth->txBd[txQ]) /* queue empty? */
+		skb = ugeth->tx_skbuff[txQ][ugeth->skb_dirtytx[txQ]];
+		if (!skb)
 			break;
 
 		dev->stats.tx_packets++;
 
-		skb = ugeth->tx_skbuff[txQ][ugeth->skb_dirtytx[txQ]];
-
 		if (skb_queue_len(&ugeth->rx_recycle) < RX_BD_RING_LEN &&
 			     skb_recycle_check(skb,
 				    ugeth->ug_info->uf_info.max_rx_buf_length +


