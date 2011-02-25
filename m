Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1BYCdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:33:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42030 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1BYCdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MnGoXCrd0cSpMhGg9jHxBNS/iaDQ7HFQNp0WgQ3UoCbqlIDCw/VPZG2AiKyMQz4t9j
         gwauq97HGkEa+3i6d9pWfDpeSiMZmyUrxoVjjndkZvD7iJAXgJ4JjrOGHh/2hk33E7K6
         JMXDvD4LbN61ZCEWfYo0xzAuZ3C+jwKDYv7v4=
MIME-Version: 1.0
In-Reply-To: <1298569685.2814.16.camel@edumazet-laptop>
References: <1298535761.2814.1.camel@edumazet-laptop> <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
 <1298569179.2814.11.camel@edumazet-laptop> <1298569685.2814.16.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 25 Feb 2011 10:32:55 +0800
Message-ID: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, Feb 25, 2011 at 1:48 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 24 février 2011 à 18:39 +0100, Eric Dumazet a écrit :
>> Le jeudi 24 février 2011 à 17:29 +0800, Po-Yu Chuang a écrit :
>> > From: Po-Yu Chuang <ratbert@faraday-tech.com>
>> > +
>> > +static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
>> > +{
>> > +   struct net_device *netdev = priv->netdev;
>> > +   struct ftmac100_rxdes *rxdes;
>> > +   struct sk_buff *skb;
>> > +   struct page *page;
>> > +   dma_addr_t map;
>> > +   int length;
>> > +
>> > +   rxdes = ftmac100_rx_locate_first_segment(priv);
>> > +   if (!rxdes)
>> > +           return false;
>> > +
>> > +   if (unlikely(ftmac100_rx_packet_error(priv, rxdes))) {
>> > +           ftmac100_rx_drop_packet(priv);
>> > +           return true;
>> > +   }
>> > +
>> > +   /*
>> > +    * It is impossible to get multi-segment packets
>> > +    * because we always provide big enough receive buffers.
>> > +    */
>> > +   if (unlikely(!ftmac100_rxdes_last_segment(rxdes)))
>> > +           BUG();
>> > +
>> > +   /* start processing */
>> > +   skb = netdev_alloc_skb_ip_align(netdev, ETH_HLEN);
>>
>> Oh I see... You should allocate a bigger head (say... 128 bytes)
>>
>> And copy in it up to 128 bytes of first part... this to avoid upper
>> stack to reallocate skb head (because IP/TCP processing need to get
>> their headers in skb head)
>
> Take a look at drivers/net/niu.c :
>
> #define RX_SKB_ALLOC_SIZE   128 + NET_IP_ALIGN
>
> static int niu_process_rx_pkt(...)
> {
>        ...
>        skb = netdev_alloc_skb(np->dev, RX_SKB_ALLOC_SIZE);
>        ...
>        while (1) {
>                ...
>                niu_rx_skb_append(skb, page, off, append_size);
>        }
> }

Oh I got it.

I will try this and redo the benchmarking.

Thanks,
Po-Yu Chuang
