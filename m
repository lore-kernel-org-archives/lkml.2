Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2CXQKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:10:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45271 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2CXQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:10:19 -0400
Message-ID: <1332605415.3487.14.camel@edumazet-laptop>
Subject: Re: [PATCH v3] Ethernet driver for the WIZnet W5300 chip
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 24 Mar 2012 09:10:15 -0700
In-Reply-To: <1332586938-2804-1-git-send-email-msink@permonline.ru>
References: <1332149037-12025-1-git-send-email-msink@permonline.ru>
	 <1332586938-2804-1-git-send-email-msink@permonline.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 24 mars 2012 à 16:02 +0500, Mike Sinkovsky a écrit :
> Based on original driver from chip manufacturer, but nearly full rewite.
> 
> Tested and used in production with Blackfin BF531 embedded processor.
> 
> Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
> ---

> +
> +static int w5300_start_tx(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct w5300_private *priv = netdev_priv(ndev);
> +
> +	if (unlikely(w5300_read32(priv, W5300_S0_TX_FSR) < skb->len)) {
> +		ndev->stats.tx_dropped++;
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	w5300_write_frame(priv, skb->data, skb->len);
> +	ndev->stats.tx_packets++;
> +	ndev->stats.tx_bytes += skb->len;
> +	dev_kfree_skb(skb);
> +
> +	return NETDEV_TX_OK;
> +}
> +

As there is no tx interrupt at the end of transmit to eventually XON the
queue, you cant XOFF it when there it no room in transmit queue.

Of course, this means qdisc will never have a backlog, since we never
stop the dequeue process.

Returning NETDEV_TX_BUSY essentialy is going to burn cpu cycles,
spinning there is enough room in NIC.

So you must drop the frame, and return NETDEV_TX_OK instead.


static int w5300_start_tx(struct sk_buff *skb, struct net_device *ndev)
{
       struct w5300_private *priv = netdev_priv(ndev);

       if (unlikely(w5300_read32(priv, W5300_S0_TX_FSR) < skb->len)) {
               ndev->stats.tx_dropped++;
               dev_kfree_skb(skb);
               return NETDEV_TX_OK;
       }



Rule to use NETDEV_TX_BUSY is : 

Before returning NETDEV_TX_BUSY, qdisc must have been stopped by
netif_stop_queue(ndev) (and tx completion might call netif_wake_queue()
later)




