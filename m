Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1BYJqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:46:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40083 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab1BYJqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l3/C1w7/QMo9LyvGUrVulEJ56K4lDABg5pyctiGoCrEGXU8JoI5m/vxEdTvbKdLqiX
         F5e+9PV3SWnM5sdEGJngN+1LmB3ZMNHx5nsFWtg5DnxcLJqLYI1ZWz1HhHGvCNr/IQ7Y
         uH1zzk5pcZPEyHDPL80Z1u3LuH6X9ry6Eowj4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
References: <1298535761.2814.1.camel@edumazet-laptop> <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
 <1298569179.2814.11.camel@edumazet-laptop> <1298569685.2814.16.camel@edumazet-laptop>
 <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 25 Feb 2011 17:45:40 +0800
Message-ID: <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
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

On Fri, Feb 25, 2011 at 10:32 AM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> On Fri, Feb 25, 2011 at 1:48 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Le jeudi 24 février 2011 à 18:39 +0100, Eric Dumazet a écrit :
>>> Le jeudi 24 février 2011 à 17:29 +0800, Po-Yu Chuang a écrit :
>>> > From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>> > +
>>> > +static bool ftmac100_rx_packet(struct ftmac100 *priv, int *processed)
>>> > +{
>>> > +   struct net_device *netdev = priv->netdev;
>>> > +   struct ftmac100_rxdes *rxdes;
>>> > +   struct sk_buff *skb;
>>> > +   struct page *page;
>>> > +   dma_addr_t map;
>>> > +   int length;
>>> > +
>>> > +   rxdes = ftmac100_rx_locate_first_segment(priv);
>>> > +   if (!rxdes)
>>> > +           return false;
>>> > +
>>> > +   if (unlikely(ftmac100_rx_packet_error(priv, rxdes))) {
>>> > +           ftmac100_rx_drop_packet(priv);
>>> > +           return true;
>>> > +   }
>>> > +
>>> > +   /*
>>> > +    * It is impossible to get multi-segment packets
>>> > +    * because we always provide big enough receive buffers.
>>> > +    */
>>> > +   if (unlikely(!ftmac100_rxdes_last_segment(rxdes)))
>>> > +           BUG();
>>> > +
>>> > +   /* start processing */
>>> > +   skb = netdev_alloc_skb_ip_align(netdev, ETH_HLEN);
>>>
>>> Oh I see... You should allocate a bigger head (say... 128 bytes)
>>>
>>> And copy in it up to 128 bytes of first part... this to avoid upper
>>> stack to reallocate skb head (because IP/TCP processing need to get
>>> their headers in skb head)
>>
>> Take a look at drivers/net/niu.c :
>>
>> #define RX_SKB_ALLOC_SIZE   128 + NET_IP_ALIGN
>>
>> static int niu_process_rx_pkt(...)
>> {
>>        ...
>>        skb = netdev_alloc_skb(np->dev, RX_SKB_ALLOC_SIZE);
>>        ...
>>        while (1) {
>>                ...
>>                niu_rx_skb_append(skb, page, off, append_size);
>>        }
>> }
>
> Oh I got it.
>
> I will try this and redo the benchmarking.

It's a little faster than v5 now. Thanks.
I will submit the current version later.

One more question just curious, why 128 bytes?

best regards,
Po-Yu Chuang
