Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0CZBDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:03:41 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:56626 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0CZBDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UAmBktPQ0nGUxeNSg2ncJBJ6QxUxaaBszSI7GggzySToBn4ubmATVZMnNsoWiAcr7Q
         ZlaFbfmkF5P2AirMaAFSTSsJd6ZCTQbvxoNAatsBaHnRmil8CNqcFIbRo+OlpyUNqhGP
         jvvlcggI35wRqjUI3uJflQG0eniTrcWPBFHGU=
MIME-Version: 1.0
In-Reply-To: <20100304135738C.fujita.tomonori@lab.ntt.co.jp>
References: <4B8F213B.40603@gmail.com>
	 <20100304135738C.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 25 Mar 2010 19:03:37 -0600
Message-ID: <51f3faa71003251803q7ccec5d5x82bc277c590e2848@mail.gmail.com>
Subject: Re: [PATCH RFC] fix problems with NETIF_F_HIGHDMA in networking 
	drivers v2
From: Robert Hancock <hancockrwd@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 10:58 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 03 Mar 2010 20:55:55 -0600
> Robert Hancock <hancockrwd@gmail.com> wrote:
>
>> Many networking drivers have issues with the use of the NETIF_F_HIGHDMA flag.
>> This flag actually indicates whether or not the device/driver can handle
>> skbs located in high memory (as opposed to lowmem). If the flag isn't set and
>> the skb is located in highmem, it needs to be copied.
>> There are two problems with this flag:
>>
>> -Many drivers only set the flag when they detect they can use 64-bit DMA,
>> since otherwise they could receive DMA addresses that they can't handle
>> (which on platforms without IOMMU/SWIOTLB support is fatal). This means that if
>> 64-bit support isn't available, even buffers located below 4GB will get copied
>> unnecessarily.
>>
>> -Some drivers set the flag even though they can't actually handle 64-bit DMA,
>> which would mean that on platforms without IOMMU/SWIOTLB they would get a DMA
>> mapping error if the memory they received happened to be located above 4GB.
>>
>> In order to fix this problem, the existing NETIF_F_HIGHDMA flag is split into
>> two new flags:
>>
>> NETIF_F_DMA_HIGH - indicates if the driver can do DMA to highmem at all
>> NETIF_F_DMA_64BIT - indicates the driver can do DMA to 64-bit memory
>
> Why can't you use dev->dma_mask here like the following?
>
> Then you can fix drivers that use the NETIF_F_HIGHDMA flag to indicate
> that they don't support 64bit DMA.
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index bcc490c..b15f94b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -129,6 +129,7 @@
>  #include <linux/jhash.h>
>  #include <linux/random.h>
>  #include <trace/events/napi.h>
> +#include <linux/pci.h>
>
>  #include "net-sysfs.h"
>
> @@ -1787,14 +1788,21 @@ static inline int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
>  {
>  #ifdef CONFIG_HIGHMEM
>        int i;
> +       if (!(dev->features & NETIF_F_HIGHDMA)) {
> +               for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
> +                       if (PageHighMem(skb_shinfo(skb)->frags[i].page))
> +                               return 1;
> +       }
>
> -       if (dev->features & NETIF_F_HIGHDMA)
> -               return 0;
> -
> -       for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
> -               if (PageHighMem(skb_shinfo(skb)->frags[i].page))
> -                       return 1;
> +       if (PCI_DMA_BUS_IS_PHYS) {
> +               struct device *pdev = dev->dev.parent;
>
> +               for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +                       dma_addr_t addr = page_to_phys(skb_shinfo(skb)->frags[i].page);
> +                       if (!pdev->dma_mask || addr + PAGE_SIZE - 1 > *pdev->dma_mask)
> +                               return 1;
> +               }
> +       }
>  #endif
>        return 0;
>  }
>

This seems like it could be a reasonable approach. The only thing is
that in this code you're returning 1 if the parent device has no DMA
mask set. Wouldn't it make more sense to return 0 in this case? I'm
assuming that in that situation it's a virtual device not backed by
any hardware and there should be no DMA mask restriction...
