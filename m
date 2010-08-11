Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0HKCGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:06:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:49569 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab0HKCGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:06:24 -0400
Date: Wed, 11 Aug 2010 11:06:00 +0900
To: khc@pm.waw.pl
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <m3sk2m433u.fsf@intrepid.localdomain>
References: <m3sk2m433u.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100811110448S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Aug 2010 11:06:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010 22:36:21 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> 6fee48cd330c68332f9712bc968d934a1a84a32a broke
> pci_set_consistent_dma_mask() on IXP4xx and most probably PXA. Affected
> devices are e.g. IDE controller (CS5536-based: disk inaccessible) and
> e1000 ethernet ("Detected Tx Unit Hang").

Sorry about that.

> The attached patch makes it work again, though I'm not sure it's the
> best solution.

I think that we should avoid adding "#ifdef CONFIG_DMABOUNCE" to a
generic place.

Why the above patch breaks dmabounce.c? We can't set dev->coherent_dma_mask?


> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ca32ed7..bd2a7d3 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -129,6 +129,14 @@ static inline u64 dma_get_mask(struct device *dev)
>  
>  static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
>  {
> +#ifdef CONFIG_DMABOUNCE
> +	if (dev->archdata.dmabounce) {
> +		if (mask >= ISA_DMA_THRESHOLD)
> +			return 0;
> +		else
> +			return -EIO;
> +	}
> +#endif
>  	if (!dma_supported(dev, mask))
>  		return -EIO;
>  	dev->coherent_dma_mask = mask;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
