Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab2C3JYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:24:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58243 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2C3JXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:23:54 -0400
Message-ID: <1333099431.19659.15.camel@edumazet-laptop>
Subject: Re: [PATCH v5 2/2] Ethernet driver for the WIZnet W5100 chip
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2012 11:23:51 +0200
In-Reply-To: <1333090806-27988-2-git-send-email-msink@permonline.ru>
References: <1332752876-1650-1-git-send-email-msink@permonline.ru>
	 <1333090806-27988-2-git-send-email-msink@permonline.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 30 mars 2012 à 13:00 +0600, Mike Sinkovsky a écrit :
> Tested and used in production with Blackfin BF531 embedded processor.
> 
> Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
> ---

> +
> +static int w5100_start_tx(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct w5100_priv *priv = netdev_priv(ndev);
> +	u16 offset;
> +
> +	if (w5100_read16(priv, W5100_S0_TX_FSR) < skb->len) {

There is a race here.

Interrupt came come right here before you set the stop_queue()


> +		netif_stop_queue(ndev);

So Here I suggest adding a test again
	
	if (w5100_read16(priv, W5100_S0_TX_FSR) >= skb->len)
		netif_wake_queue(ndev);
	else
		return NETDEV_TX_BUSY;

> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	offset = w5100_read16(priv, W5100_S0_TX_WR);
> +	w5100_writebuf(priv, offset, skb->data, skb->len);
> +	w5100_write16(priv, W5100_S0_TX_WR, offset + skb->len);
> +	w5100_command(priv, S0_CR_SEND);
> +	ndev->stats.tx_bytes += skb->len;
> +	ndev->stats.tx_packets++;
> +	dev_kfree_skb(skb);
> +
> +	return NETDEV_TX_OK;
> +}
> +



