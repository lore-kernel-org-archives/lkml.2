Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1ANFiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:38:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1ANFiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UjvOdcOKOds+zd4k84/QPrnel4UKn4RzBSS9d20S2sY+3yQIDo43ggmID47EL9Qo7n
         cQnZFPIPGAjcWjRTevlRt6euhWjT6YCQ7e3GR6stbQFZntibgJGCVJH/k8EvrAx5+vQe
         DbEKpFWftqbub69KhtTW/jkGEZrWANZ2puoio=
MIME-Version: 1.0
In-Reply-To: <1294927387.3044.76.camel@localhost>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com> <1294927387.3044.76.camel@localhost>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 14 Jan 2011 13:37:40 +0800
Message-ID: <AANLkTimNekxXpovXOHW1eNvvdzMfLyhOyum44AKMOmDj@mail.gmail.com>
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ben,

On Thu, Jan 13, 2011 at 10:03 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Thu, 2011-01-13 at 19:49 +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
>> MII.  This driver has been working on some ARM/NDS32 SoC including
>> Faraday A320 and Andes AG101.
> [...]
>> +#define USE_NAPI
>
> All new network drivers should use NAPI only, so please remove the
> definition of USE_NAPI and change the conditional code to use NAPI
> always.

OK, fixed.

> [...]
>> +     struct net_device_stats stats;
>
> There is a net_device_stats structure in the net_device structure; you
> should normally use that instead of adding another one.

OK, fixed.

> [...]
>> +static int ftmac100_reset(struct ftmac100 *priv)
>> +{
>> +     struct device *dev = &priv->netdev->dev;
>> +     unsigned long flags;
>> +     int i;
>> +
>> +     /* NOTE: reset clears all registers */
>> +
>> +     spin_lock_irqsave(&priv->hw_lock, flags);
>> +     iowrite32(FTMAC100_MACCR_SW_RST, priv->base + FTMAC100_OFFSET_MACCR);
>> +     spin_unlock_irqrestore(&priv->hw_lock, flags);
>> +
>> +     for (i = 0; i < 5; i++) {
>> +             int maccr;
>> +
>> +             spin_lock_irqsave(&priv->hw_lock, flags);
>> +             maccr = ioread32(priv->base + FTMAC100_OFFSET_MACCR);
>> +             spin_unlock_irqrestore(&priv->hw_lock, flags);
>> +             if (!(maccr & FTMAC100_MACCR_SW_RST)) {
>> +                     /*
>> +                      * FTMAC100_MACCR_SW_RST cleared does not indicate
>> +                      * that hardware reset completed (what the f*ck).
>> +                      * We still need to wait for a while.
>> +                      */
>> +                     usleep_range(500, 1000);
>
> Sleeping here means this must be running in process context.  But you
> used spin_lock_irqsave() above which implies you're not sure what the
> context is.  One of these must be wrong.
>
> I wonder whether hw_lock is even needed; you seem to acquire and release
> it around each PIO (read or write).  This should be unnecessary since
> each PIO is atomic.

OK, fixed.

> I think you can also get rid of rx_lock; it's only used in the RX data
> path which is already serialised by NAPI.

OK, fixed.

> [...]
>> +     netdev->last_rx = jiffies;
>
> Don't set last_rx; the networking core takes care of it now.

OK, fixed.

>> +     priv->stats.rx_packets++;
>> +     priv->stats.rx_bytes += skb->len;
>
> This should be done earlier, so that these stats include packets that
> are dropped for any reason.

OK, fixed.

> [...]
>> +     netdev->trans_start = jiffies;
>
> Don't set trans_start; the networking core takes care of it now.

OK, fixed.

> [...]
>> +     priv->descs = dma_alloc_coherent(priv->dev,
>> +             sizeof(struct ftmac100_descs), &priv->descs_dma_addr,
>> +             GFP_KERNEL | GFP_DMA);
>
> On x86, GFP_DMA means the memory must be within the ISA DMA range
> (< 16 MB).  I don't know quite what it means on ARM but it may not be
> what you want.

On ARM, all 4G address space can be used by DMA (at least for all the
hardwares I have ever used). All memory pages are in DMA zone AFAIK.
I put GFP_DMA here just to be safe if there were any constraints.

By checking drivers in drivers/net/arm/, ep93xx_eth.c also uses this flag,
so I guess this is acceptable?

> [...]
>> +     if (status & (FTMAC100_INT_XPKT_OK | FTMAC100_INT_XPKT_LOST)) {
>> +             /*
>> +              * FTMAC100_INT_XPKT_OK:
>> +              *       packet transmitted to ethernet successfully
>> +              *
>> +              * FTMAC100_INT_XPKT_LOST:
>> +              *      packet transmitted to ethernet lost due to late
>> +              *      collision or excessive collision
>> +              */
>> +             ftmac100_tx_complete(priv);
>> +     }
>
> TX completions should also be handled through NAPI if possible.

OK, I'll study how to do that.

> [...]
>> +     priv->rx_pointer = 0;
>> +     priv->tx_clean_pointer = 0;
>> +     priv->tx_pointer = 0;
>> +     spin_lock_init(&priv->hw_lock);
>> +     spin_lock_init(&priv->rx_lock);
>> +     spin_lock_init(&priv->tx_lock);
>
> These locks should be initialised in your probe function.

OK, fixed.

> [...]
>> +     unregister_netdev(netdev);
>
> There should be a netif_napi_del() before this.

OK, fixed.

> A general comment: please use netdev_err(), netdev_info() etc. for
> logging.  This ensures that both the platform device address and the
> network device name appears in the log messages.

OK, fixed.

Thanks a lot for your detailed review. I'll submit a new version ASAP.

Thanks,
Po-Yu Chuang
