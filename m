Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1CMU0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 16:26:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65098 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1CMU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 16:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bXtFxZRo7UdWU3bP7g4FRY+H9Y754+2TygZCEG8CCtCTR2/hiErs3sQwZAIN9AQaau
         A7szqMNDUVNiBDE0A6031+b2RqRBlvm2MJG9LlB8A4jMone4aY9Ud1wroES8R07IeFvN
         cG4ZpUrsksPNXmJkBfcPER8I0+9cHPT30cIe8=
Subject: [PATCH net-next-2.6] ftmac100: use GFP_ATOMIC allocations where
 needed
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1300047388.2761.48.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300047388.2761.48.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 21:26:42 +0100
Message-ID: <1300048002.2761.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 mars 2011 à 21:16 +0100, Eric Dumazet a écrit :

> BTW, it seems I missed the fact that ftmac100_alloc_rx_page() used a
> GFP_KERNEL allocation, while its called from softirq context (from
> ftmac100_rx_packet()) 

Here is a patch against ftmac100

[PATCH net-next-2.6] ftmac100: use GFP_ATOMIC allocations where needed

When running in softirq context, we should use GFP_ATOMIC allocations
instead of GFP_KERNEL ones.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/ftmac100.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ftmac100.c b/drivers/net/ftmac100.c
index df70368..76cf77a 100644
--- a/drivers/net/ftmac100.c
+++ b/drivers/net/ftmac100.c
@@ -80,7 +80,8 @@ struct ftmac100 {
 	struct mii_if_info mii;
 };
 
-static int ftmac100_alloc_rx_page(struct ftmac100 *priv, struct ftmac100_rxdes *rxdes);
+static int ftmac100_alloc_rx_page(struct ftmac100 *priv,
+				  struct ftmac100_rxdes *rxdes, gfp_t gfp);
 
 /******************************************************************************
  * internal functions (hardware register access)
@@ -441,7 +442,7 @@ static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
 	skb->truesize += length;
 	__pskb_pull_tail(skb, min(length, 64));
 
-	ftmac100_alloc_rx_page(priv, rxdes);
+	ftmac100_alloc_rx_page(priv, rxdes, GFP_ATOMIC);
 
 	ftmac100_rx_pointer_advance(priv);
 
@@ -659,13 +660,14 @@ static int ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
 /******************************************************************************
  * internal functions (buffer)
  *****************************************************************************/
-static int ftmac100_alloc_rx_page(struct ftmac100 *priv, struct ftmac100_rxdes *rxdes)
+static int ftmac100_alloc_rx_page(struct ftmac100 *priv,
+				  struct ftmac100_rxdes *rxdes, gtp_t gfp)
 {
 	struct net_device *netdev = priv->netdev;
 	struct page *page;
 	dma_addr_t map;
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(gfp);
 	if (!page) {
 		if (net_ratelimit())
 			netdev_err(netdev, "failed to allocate rx page\n");
@@ -736,7 +738,7 @@ static int ftmac100_alloc_buffers(struct ftmac100 *priv)
 	for (i = 0; i < RX_QUEUE_ENTRIES; i++) {
 		struct ftmac100_rxdes *rxdes = &priv->descs->rxdes[i];
 
-		if (ftmac100_alloc_rx_page(priv, rxdes))
+		if (ftmac100_alloc_rx_page(priv, rxdes, GFP_KERNEL))
 			goto err;
 	}
 


