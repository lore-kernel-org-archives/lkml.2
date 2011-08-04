Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1HDQ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:56:41 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:21967
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab1HDQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:56:36 -0400
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzz8275ch8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E3ACF3F.4040106@freescale.com>
Date: Thu, 4 Aug 2011 11:56:31 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] of/address: Add of_iomap_nocache
References: <1312454196-31028-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1312454196-31028-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 05:36 AM, David Brown wrote:
> Add uncached mappings from devicetree nodes similar to regular io
> mappings.
>
> SPARC is coherent, so there this call is the same as regular of_iomap.
>
> Cc: David Miller<davem@davemloft.net>
> Signed-off-by: David Brown<davidb@codeaurora.org>
> ---
> v2 - Add implementation for SPARC
>
>   drivers/of/address.c       |   19 +++++++++++++++++++
>   include/linux/of_address.h |   10 ++++++++++
>   2 files changed, 29 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 72c33fb..9bee7f8 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -613,3 +613,22 @@ void __iomem *of_iomap(struct device_node *np, int index)
>   	return ioremap(res.start, resource_size(&res));
>   }
>   EXPORT_SYMBOL(of_iomap);
> +
> +/**
> + * of_iomap_nocache - Maps the memory mapped IO for a given
> + *                    device_node, using ioremap_nocache.
> + * @device:	the device whose io range will be mapped
> + * @index:	index of the io range
> + *
> + * Returns a pointer to the mapped memory
> + */
> +void __iomem *of_iomap_nocache(struct device_node *np, int index)
> +{
> +	struct resource res;
> +
> +	if (of_address_to_resource(np, index,&res))
> +		return NULL;
> +
> +	return ioremap_nocache(res.start, 1 + res.end - res.start);
> +}

resource_size()?

> +EXPORT_SYMBOL(of_iomap_nocache);
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 3118623..0e4734b 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -13,6 +13,16 @@ extern struct device_node *of_find_matching_node_by_address(
>   					u64 base_address);
>   extern void __iomem *of_iomap(struct device_node *device, int index);
>
> +#ifndef SPARC
> +extern void __iomem *of_iomap_nocache(struct device_node *device, int index);
> +#else
> +static inline void __iomem *of_iomap_nocache(struct device_node *device,
> +		int index)
> +{
> +	return of_iomap(device, index);
> +}
> +#endif

Why is sparc special?  It looks like it defines ioremap_nocache() as 
ioremap() just like powerpc and some others, so shouldn't the normal 
of_iomap_nocache just work?

-Scott

