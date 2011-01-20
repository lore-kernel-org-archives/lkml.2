Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1ATPlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:41:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54309 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab1ATPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:41:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WiVLZs9re64jvEk2YtodyxdvzoNM0v1DHFOyEDTNSBRT6woWw9LogSIDBIVewK4h2I
         az7FPlJSjUTX0WioUcmEISo583miwPHpVzSlah4fmCfuzKUduGU2UIWM7gNsA0MevFBB
         AapTqT4Av90aM+tQ3KdgHgxk9M6jiYNVYIxPk=
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 16:41:45 +0100
Message-ID: <1295538105.2825.308.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 20 janvier 2011 à 23:30 +0800, Po-Yu Chuang a écrit :

> +static bool ftmac100_tx_complete_packet(struct ftmac100 *priv)
> +{
> +	struct net_device *netdev = priv->netdev;
> +	struct ftmac100_txdes *txdes;
> +	struct sk_buff *skb;
> +	dma_addr_t map;
> +
> +	if (priv->tx_pending == 0)
> +		return false;
> +
> +	txdes = ftmac100_current_clean_txdes(priv);
> +
> +	if (ftmac100_txdes_owned_by_dma(txdes))
> +		return false;
> +
> +	skb = ftmac100_txdes_get_skb(txdes);
> +	map = ftmac100_txdes_get_dma_addr(txdes);
> +
> +	if (unlikely(ftmac100_txdes_excessive_collision(txdes) ||
> +		     ftmac100_txdes_late_collision(txdes))) {
> +		/*
> +		 * packet transmitted to ethernet lost due to late collision
> +		 * or excessive collision
> +		 */
> +		netdev->stats.tx_aborted_errors++;
> +	} else {
> +		netdev->stats.tx_packets++;
> +		netdev->stats.tx_bytes += skb->len;
> +	}
> +
> +	dma_unmap_single(priv->dev, map, skb_headlen(skb), DMA_TO_DEVICE);
> +
> +	dev_kfree_skb_irq(skb);
> +
> +	ftmac100_txdes_reset(txdes);
> +
> +	ftmac100_tx_clean_pointer_advance(priv);
> +
> +	priv->tx_pending--;
> +	netif_wake_queue(netdev);
> +
> +	return true;
> +}
> +
> +static void ftmac100_tx_complete(struct ftmac100 *priv)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	while (ftmac100_tx_complete_packet(priv))
> +		;
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
> +}
> +

I dont understand why you still block hard IRQS, after full NAPI
conversion.

Now you run from NAPI, and softirq handler, are you sure you still need
to block hard IRQ and tx_lock ?

It seems to me ftmac100_xmit() could only block softirqs (but they
already are blocked by caller), so you could use spin_lock() from
ftmac100_xmit()



