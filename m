Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1BXRjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:39:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BXRjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:39:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T8jbDPn8NpKkZrcuyLz1sKC27PweBjKpW5OGWl7RTJ1op3swsG5icyG4OMlxwjUN6a
         qWg2VU1ZT8XxWFcB5SYfHSyTUF9MpqNnFd2mlMHH2ib0iZhmA/2DYJzfZGSWV6fgED5o
         /1zmqPyqoyUQdRALYOGwSuBsuE36WOHkrVyNI=
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
References: <1298535761.2814.1.camel@edumazet-laptop>
	 <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 18:39:39 +0100
Message-ID: <1298569179.2814.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 février 2011 à 17:29 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 


> +
> +static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
> +{
> +	struct net_device *netdev = priv->netdev;
> +	struct ftmac100_rxdes *rxdes;
> +	struct sk_buff *skb;
> +	struct page *page;
> +	dma_addr_t map;
> +	int length;
> +
> +	rxdes = ftmac100_rx_locate_first_segment(priv);
> +	if (!rxdes)
> +		return false;
> +
> +	if (unlikely(ftmac100_rx_packet_error(priv, rxdes))) {
> +		ftmac100_rx_drop_packet(priv);
> +		return true;
> +	}
> +
> +	/*
> +	 * It is impossible to get multi-segment packets
> +	 * because we always provide big enough receive buffers.
> +	 */
> +	if (unlikely(!ftmac100_rxdes_last_segment(rxdes)))
> +		BUG();
> +
> +	/* start processing */
> +	skb = netdev_alloc_skb_ip_align(netdev, ETH_HLEN);

Oh I see... You should allocate a bigger head (say... 128 bytes)

And copy in it up to 128 bytes of first part... this to avoid upper
stack to reallocate skb head (because IP/TCP processing need to get
their headers in skb head)

> +	if (unlikely(!skb)) {
> +		if (net_ratelimit())
> +			netdev_err(netdev, "rx skb alloc failed\n");
> +
> +		ftmac100_rx_drop_packet(priv);
> +		return true;
> +	}
> +
> +	if (unlikely(ftmac100_rxdes_multicast(rxdes)))
> +		netdev->stats.multicast++;
> +
> +	map = ftmac100_rxdes_get_dma_addr(rxdes);
> +	dma_unmap_page(priv->dev, map, RX_BUF_SIZE, DMA_FROM_DEVICE);
> +
> +	length = ftmac100_rxdes_frame_length(rxdes);
> +	page = ftmac100_rxdes_get_page(rxdes);
> +	skb_fill_page_desc(skb, 0, page, 0, length);
> +	skb->len += length;
> +	skb->data_len += length;
> +	skb->truesize += length;
> +	__pskb_pull_tail(skb, ETH_HLEN);
> +
> +	ftmac100_alloc_rx_page(priv, rxdes);
> +
> +	ftmac100_rx_pointer_advance(priv);
> +
> +	skb->protocol = eth_type_trans(skb, netdev);
> +
> +	netdev->stats.rx_packets++;
> +	netdev->stats.rx_bytes += skb->len;
> +
> +	/* push packet to protocol stack */
> +	netif_receive_skb(skb);
> +
> +	(*processed)++;
> +	return true;
> +}
> +

