Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1AXUWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:22:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61980 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1AXUWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vtj6OZYzqD0B+vWpf+CHD0DO3w9c9b7pAggqir3odI+r/aM3H5rxCsixpZK4juHw+t
         LL8mSLbqTiHSyxqSDmPD195pHo5UvxfXIPzDpd09MZr325VpmQsm4+TqO9z5TpBj6uz2
         +0+3GJ/tnYhIiwCzy1yZOcxNVHLW7wFT7EXb0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinsWVHj6qdSS-_ztztcNPHAkwZQnimPbjzvcHb2@mail.gmail.com>
References: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
	<1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com>
	<AANLkTikpu05V92T+YvuHW+jcTH-Bu2t6=HoQn5OR3ZhX@mail.gmail.com>
	<AANLkTinsWVHj6qdSS-_ztztcNPHAkwZQnimPbjzvcHb2@mail.gmail.com>
Date: Mon, 24 Jan 2011 21:22:03 +0100
Message-ID: <AANLkTimWuBfeYPOsOFpTiAGS5uHysevAHiOg0svBQ4zW@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 24 stycznia 2011 09:26 u¿ytkownik Po-Yu Chuang
<ratbert.chuang@gmail.com> napisa³:
> 2011/1/21 Micha³ Miros³aw <mirqus@gmail.com>:
>> 2011/1/21 Po-Yu Chuang <ratbert.chuang@gmail.com>:
>>> +static void ftmac100_free_buffers(struct ftmac100 *priv)
>>> +{
>>> +       int i;
>>> +
>>> +       for (i = 0; i < RX_QUEUE_ENTRIES; i += 2) {
>>> +               struct ftmac100_rxdes *rxdes = &priv->descs->rxdes[i];
>>> +               dma_addr_t d = ftmac100_rxdes_get_dma_addr(rxdes);
>>> +               void *page = ftmac100_rxdes_get_va(rxdes);
>>> +
>>> +               if (d)
>>> +                       dma_unmap_single(priv->dev, d, PAGE_SIZE,
>>> +                                        DMA_FROM_DEVICE);
>>> +
>>> +               if (page != NULL)
>>> +                       free_page((unsigned long)page);
>>> +       }
>>> +
>> [...]
>>
>>> +static int ftmac100_alloc_buffers(struct ftmac100 *priv)
>>> +{
>>> +       int i;
>>> +
>>> +       priv->descs = dma_alloc_coherent(priv->dev,
>>> +                                        sizeof(struct ftmac100_descs),
>>> +                                        &priv->descs_dma_addr,
>>> +                                        GFP_KERNEL | GFP_DMA);
>>> +       if (priv->descs == NULL)
>>> +               return -ENOMEM;
>>> +
>>> +       memset(priv->descs, 0, sizeof(struct ftmac100_descs));
>>> +
>>> +       /* initialize RX ring */
>>> +
>>> +       ftmac100_rxdes_set_end_of_ring(&priv->descs->rxdes[RX_QUEUE_ENTRIES - 1]);
>>> +
>>> +       for (i = 0; i < RX_QUEUE_ENTRIES; i += 2) {
>>> +               struct ftmac100_rxdes *rxdes = &priv->descs->rxdes[i];
>>> +               void *page;
>>> +               dma_addr_t d;
>>> +
>>> +               page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
>>> +               if (page == NULL)
>>> +                       goto err;
>>> +
>>> +               d = dma_map_single(priv->dev, page, PAGE_SIZE, DMA_FROM_DEVICE);
>>> +               if (unlikely(dma_mapping_error(priv->dev, d))) {
>>> +                       free_page((unsigned long)page);
>>> +                       goto err;
>>> +               }
>>> +
>>> +               /*
>>> +                * The hardware enforces a sub-2K maximum packet size, so we
>>> +                * put two buffers on every hardware page.
>>> +                */
>>> +               ftmac100_rxdes_set_va(rxdes, page);
>>> +               ftmac100_rxdes_set_va(rxdes + 1, page + PAGE_SIZE / 2);
>>> +
>>> +               ftmac100_rxdes_set_dma_addr(rxdes, d);
>>> +               ftmac100_rxdes_set_dma_addr(rxdes + 1, d + PAGE_SIZE / 2);
>>> +
>>> +               ftmac100_rxdes_set_buffer_size(rxdes, RX_BUF_SIZE);
>>> +               ftmac100_rxdes_set_buffer_size(rxdes + 1, RX_BUF_SIZE);
>>> +
>>> +               ftmac100_rxdes_set_dma_own(rxdes);
>>> +               ftmac100_rxdes_set_dma_own(rxdes + 1);
>>> +       }
>> [...]
>>
>> Did you test this? This looks like it will result in double free after
>> packet RX, as you are giving the same page (referenced once) to two
>> distinct RX descriptors, that may be assigned different packets.
>
> Yes, this is tested.
>
>> Since your not implementing any RX offloads, you might just allocate
>> fresh skb's with alloc_skb() and store skb pointer in rxdes3. Since
>
> rxdes3 does not store virtual address of an skb.
> It stores the address of the buffer allocated while open() and freed
> only when stop().
> The data in that buffer will be memcpy()ed to an skb allocated in
> ftmac100_rx_packet().
> No double free happens.

Ah, I blindly assumed that you're just appending the buffers to the
skb (using skb_fill_page_desc() and friends). Since you have to mark
descriptors for the device anyway, it might be faster to allocate new
skbs and map those as rx buffers (changing the descriptor's buffer
address after every RX) instead of keeping static buffer and copying
every time. (For small packets it wastes lot of memory, though - so
the right choice depends on the expected workload.)

Best Regards,
Micha³ Miros³aw
