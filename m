Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1AXI01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 03:26:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1AXI00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 03:26:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=caIp0d4xxj+ifd6BHVMGBQPnvwUbljPgi4o7NGfPbxsRBk12N4flVREFgv8p+P+FuB
         b3dSUi238O/utIpX0vQ7KU+aSHAiig7wf5zs6Er8JAzuL2N3BMHZtl7/MORLTD84WAJJ
         ho634eX2rGlrgoObSHE8nxEdyfoTr+QSel/Jw=
MIME-Version: 1.0
In-Reply-To: <AANLkTikpu05V92T+YvuHW+jcTH-Bu2t6=HoQn5OR3ZhX@mail.gmail.com>
References: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
 <1295596533-1748-1-git-send-email-ratbert.chuang@gmail.com> <AANLkTikpu05V92T+YvuHW+jcTH-Bu2t6=HoQn5OR3ZhX@mail.gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Mon, 24 Jan 2011 16:26:03 +0800
Message-ID: <AANLkTinsWVHj6qdSS-_ztztcNPHAkwZQnimPbjzvcHb2@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michał,

2011/1/21 Michał Mirosław <mirqus@gmail.com>:
> 2011/1/21 Po-Yu Chuang <ratbert.chuang@gmail.com>:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
>> MII.  This driver has been working on some ARM/NDS32 SoC's including
>> Faraday A320 and Andes AG101.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> [...]
>> +static void ftmac100_txdes_reset(struct ftmac100_txdes *txdes)
>> +{
>> +       /* clear all except end of ring bit */
>> +       txdes->txdes0 = 0;
>> +       txdes->txdes1 &= FTMAC100_TXDES1_EDOTR;
>> +       txdes->txdes2 = 0;
>> +       txdes->txdes3 = 0;
>> +}
>
> This also probably needs cpu_to_le32().

Ah, I missed that. Fixed.

> [...]
>> +static void ftmac100_free_buffers(struct ftmac100 *priv)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < RX_QUEUE_ENTRIES; i += 2) {
>> +               struct ftmac100_rxdes *rxdes = &priv->descs->rxdes[i];
>> +               dma_addr_t d = ftmac100_rxdes_get_dma_addr(rxdes);
>> +               void *page = ftmac100_rxdes_get_va(rxdes);
>> +
>> +               if (d)
>> +                       dma_unmap_single(priv->dev, d, PAGE_SIZE,
>> +                                        DMA_FROM_DEVICE);
>> +
>> +               if (page != NULL)
>> +                       free_page((unsigned long)page);
>> +       }
>> +
> [...]
>
>> +static int ftmac100_alloc_buffers(struct ftmac100 *priv)
>> +{
>> +       int i;
>> +
>> +       priv->descs = dma_alloc_coherent(priv->dev,
>> +                                        sizeof(struct ftmac100_descs),
>> +                                        &priv->descs_dma_addr,
>> +                                        GFP_KERNEL | GFP_DMA);
>> +       if (priv->descs == NULL)
>> +               return -ENOMEM;
>> +
>> +       memset(priv->descs, 0, sizeof(struct ftmac100_descs));
>> +
>> +       /* initialize RX ring */
>> +
>> +       ftmac100_rxdes_set_end_of_ring(&priv->descs->rxdes[RX_QUEUE_ENTRIES - 1]);
>> +
>> +       for (i = 0; i < RX_QUEUE_ENTRIES; i += 2) {
>> +               struct ftmac100_rxdes *rxdes = &priv->descs->rxdes[i];
>> +               void *page;
>> +               dma_addr_t d;
>> +
>> +               page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
>> +               if (page == NULL)
>> +                       goto err;
>> +
>> +               d = dma_map_single(priv->dev, page, PAGE_SIZE, DMA_FROM_DEVICE);
>> +               if (unlikely(dma_mapping_error(priv->dev, d))) {
>> +                       free_page((unsigned long)page);
>> +                       goto err;
>> +               }
>> +
>> +               /*
>> +                * The hardware enforces a sub-2K maximum packet size, so we
>> +                * put two buffers on every hardware page.
>> +                */
>> +               ftmac100_rxdes_set_va(rxdes, page);
>> +               ftmac100_rxdes_set_va(rxdes + 1, page + PAGE_SIZE / 2);
>> +
>> +               ftmac100_rxdes_set_dma_addr(rxdes, d);
>> +               ftmac100_rxdes_set_dma_addr(rxdes + 1, d + PAGE_SIZE / 2);
>> +
>> +               ftmac100_rxdes_set_buffer_size(rxdes, RX_BUF_SIZE);
>> +               ftmac100_rxdes_set_buffer_size(rxdes + 1, RX_BUF_SIZE);
>> +
>> +               ftmac100_rxdes_set_dma_own(rxdes);
>> +               ftmac100_rxdes_set_dma_own(rxdes + 1);
>> +       }
> [...]
>
> Did you test this? This looks like it will result in double free after
> packet RX, as you are giving the same page (referenced once) to two
> distinct RX descriptors, that may be assigned different packets.

Yes, this is tested.

> Since your not implementing any RX offloads, you might just allocate
> fresh skb's with alloc_skb() and store skb pointer in rxdes3. Since

rxdes3 does not store virtual address of an skb.
It stores the address of the buffer allocated while open() and freed
only when stop().
The data in that buffer will be memcpy()ed to an skb allocated in
ftmac100_rx_packet().
No double free happens.

> hardware doesn't touch it, you can skip cpu_to_le32()/le32_to_cpu()
> there (leave a comment, though).

Agree. Thanks.

> Unless this needs to work for ISA devices, you should drop GFP_DMA
> allocation flag.

Ben mentioned about this in the previous mail. I thought that it is OK
to keep GFP_DMA
on ARM platform, but since you point out this flag is for ISA, I will drop it.

best regards,
Po-Yu Chuang
