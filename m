Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BXRwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:52:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35593 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1BXRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:52:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KKtSgt0ol2FrBR/9QsN/FekClkcOKg0o1QQtZsBMLFC1r5OOszvDPQ9oAKyHQ6PVqM
         z8uXKt5l9FlzPMWrzfVbkJvRMHbKGNpTAFIRJ0VFWD9+iEM5DRdnOGLUGgn1zBNnkHrX
         DJ3OJfiD/evBY2oHI5dCBY0qW7+CS4InwH33Q=
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1298569179.2814.11.camel@edumazet-laptop>
References: <1298535761.2814.1.camel@edumazet-laptop>
	 <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298569179.2814.11.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 18:48:05 +0100
Message-ID: <1298569685.2814.16.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 février 2011 à 18:39 +0100, Eric Dumazet a écrit :
> Le jeudi 24 février 2011 à 17:29 +0800, Po-Yu Chuang a écrit :
> > From: Po-Yu Chuang <ratbert@faraday-tech.com>
> > 
> 
> 
> > +
> > +static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
> > +{
> > +	struct net_device *netdev = priv->netdev;
> > +	struct ftmac100_rxdes *rxdes;
> > +	struct sk_buff *skb;
> > +	struct page *page;
> > +	dma_addr_t map;
> > +	int length;
> > +
> > +	rxdes = ftmac100_rx_locate_first_segment(priv);
> > +	if (!rxdes)
> > +		return false;
> > +
> > +	if (unlikely(ftmac100_rx_packet_error(priv, rxdes))) {
> > +		ftmac100_rx_drop_packet(priv);
> > +		return true;
> > +	}
> > +
> > +	/*
> > +	 * It is impossible to get multi-segment packets
> > +	 * because we always provide big enough receive buffers.
> > +	 */
> > +	if (unlikely(!ftmac100_rxdes_last_segment(rxdes)))
> > +		BUG();
> > +
> > +	/* start processing */
> > +	skb = netdev_alloc_skb_ip_align(netdev, ETH_HLEN);
> 
> Oh I see... You should allocate a bigger head (say... 128 bytes)
> 
> And copy in it up to 128 bytes of first part... this to avoid upper
> stack to reallocate skb head (because IP/TCP processing need to get
> their headers in skb head)

Take a look at drivers/net/niu.c :

#define RX_SKB_ALLOC_SIZE   128 + NET_IP_ALIGN

static int niu_process_rx_pkt(...)
{
	...
	skb = netdev_alloc_skb(np->dev, RX_SKB_ALLOC_SIZE);
	...
	while (1) {
	 	...
		niu_rx_skb_append(skb, page, off, append_size);
	}
}



