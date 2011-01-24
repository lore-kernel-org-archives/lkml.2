Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1AXPHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:07:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AXPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pGDeO3FeyxQKLfQW00SkzEDi3ABhq42tRryaijTG8eD6rPIdAOMNnpMzwY1JNNRaC9
         b9a1vA/rMV7IB5OjB5jHqh2bH29S0qf+kCVmQ+aoS2LHt7Q3GcpjtGQqDS6ru97yLFDd
         iL9MqtBZ5imleW4pP1V8Ix/N/5FbiDpngBr3g=
Subject: Re: [PATCH v5] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1295872799-1637-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295872799-1637-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 16:07:42 +0100
Message-ID: <1295881662.2755.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 janvier 2011 à 20:39 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>


> +static int ftmac100_xmit(struct ftmac100 *priv, struct sk_buff *skb,
> +			 dma_addr_t map)
> +{
> +	struct net_device *netdev = priv->netdev;
> +	struct ftmac100_txdes *txdes;
> +	unsigned int len = (skb->len < ETH_ZLEN) ? ETH_ZLEN : skb->len;
> +
> +	txdes = ftmac100_current_txdes(priv);
> +	ftmac100_tx_pointer_advance(priv);
> +
> +	/* setup TX descriptor */
> +
> +	spin_lock(&priv->tx_lock);
> +	ftmac100_txdes_set_skb(txdes, skb);
> +	ftmac100_txdes_set_dma_addr(txdes, map);
> +
> +	ftmac100_txdes_set_first_segment(txdes);
> +	ftmac100_txdes_set_last_segment(txdes);
> +	ftmac100_txdes_set_txint(txdes);
> +	ftmac100_txdes_set_buffer_size(txdes, len);
> +
> +	priv->tx_pending++;
> +	if (priv->tx_pending == TX_QUEUE_ENTRIES) {
> +		if (net_ratelimit())
> +			netdev_info(netdev, "tx queue full\n");

Hmm, I guess you didnt tested your driver with a pktgen flood ;)

This 'netdev_info(netdev, "tx queue full\n");' is not necessary, since
its a pretty normal condition for a driver (to fill its TX ring buffer)

> +
> +		netif_stop_queue(netdev);
> +	}
> +
> +	/* start transmit */
> +	ftmac100_txdes_set_dma_own(txdes);
> +	spin_unlock(&priv->tx_lock);
> +
> +	ftmac100_txdma_start_polling(priv);
> +
> +	return NETDEV_TX_OK;
> +}


