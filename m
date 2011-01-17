Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1AQUrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:47:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43878 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1AQUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IsFTFFQwgpUJ4kGwcRXnelgEPiXrm2V6ZOFhmHZ7qbrzcPidd218HulB0S4wZjXrj/
         IuinWJI39S1kPfFGSwB7BsqItwhLUie0JehH9Zw1R8tKMcBdWEvLrbOgKNwux/Jt2l3k
         dYFsSGchxh2q13+yFCf/tBGaCB+uzgTIv6ANQ=
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Po-Yu Chuang <ratbert.chuang@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ratbert@faraday-tech.com,
        joe@perches.com, dilinger@queued.net
In-Reply-To: <1295290718.6264.19.camel@bwh-desktop>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295285354.3335.10.camel@edumazet-laptop>
	 <1295290718.6264.19.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 21:39:32 +0100
Message-ID: <1295296772.3362.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 17 janvier 2011 à 18:58 +0000, Ben Hutchings a écrit :
> On Mon, 2011-01-17 at 18:29 +0100, Eric Dumazet wrote:
> > Le lundi 17 janvier 2011 à 17:21 +0800, Po-Yu Chuang a écrit :
> > 
> > 
> > > +static int ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
> > > +{
> > > +	struct net_device *netdev = priv->netdev;
> > > +	struct ftmac100_rxdes *rxdes;
> > > +	struct sk_buff *skb;
> > > +	int length;
> > > +	int copied = 0;
> > > +	int done = 0;
> > > +
> > > +	rxdes = ftmac100_rx_locate_first_segment(priv);
> > > +	if (!rxdes)
> > > +		return 0;
> > > +
> > > +	length = ftmac100_rxdes_frame_length(rxdes);
> > > +
> > > +	netdev->stats.rx_packets++;
> > > +	netdev->stats.rx_bytes += length;
> > > +
> > > +	if (unlikely(ftmac100_rx_packet_error(priv, rxdes))) {
> > > +		ftmac100_rx_drop_packet(priv);
> > > +		return 1;
> > > +	}
> > > +
> > > +	/* start processing */
> > > +	skb = netdev_alloc_skb_ip_align(netdev, length);
> > > +	if (unlikely(!skb)) {
> > > +		if (net_ratelimit())
> > > +			netdev_err(netdev, "rx skb alloc failed\n");
> > > +
> > > +		ftmac100_rx_drop_packet(priv);
> > > +		return 1;
> > > +	}
> > > +
> > 
> > Please dont increase rx_packets/rx_bytes before the
> > netdev_alloc_skb_ip_align().
> > 
> > In case of mem allocation failure, it would be better not pretending we
> > handled a packet.
> >
> > drivers/net/r8169.c for example does the rx_packets/rx_bytes only if
> > packet is delivered to upper stack.
> 
> That's news to me.  I specifically advised Po-Yu Chuang to increment
> these earlier because my understanding is that all packets/bytes should
> be counted.  And drivers which use hardware MAC stats will generally do
> that, so I really don't think it makes sense to make other drivers
> different deliberately.
> 

I see, but when one frame is dropped because of RX ring buffer
under/overflow we dont account for the lost packet/bytes.

Thats probably not very important, but would be good if all drivers
behave the same.



