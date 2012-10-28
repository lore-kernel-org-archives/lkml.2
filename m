Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2J1LMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:12:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56732 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2J1LMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:12:35 -0400
Message-ID: <508D12DC.8010400@ti.com>
Date: Sun, 28 Oct 2012 16:41:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH v3 05/16] ARM: edma: add AM33XX crossbar event support
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-6-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-6-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 6:56 PM, Matt Porter wrote:
> Adds support for the per-EDMA channel event mux. This is required
> for any peripherals using DMA crossbar mapped events.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/common/edma.c             |   63 +++++++++++++++++++++++++++++++++++-
>  include/linux/platform_data/edma.h |    1 +
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 6d2a590..b761b7a 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1425,6 +1425,53 @@ static int edma_of_read_u32_to_s16_array(const struct device_node *np,
>  	return 0;
>  }
>  
> +static int edma_xbar_event_map(struct device *dev,
> +			       struct device_node *node,
> +			       struct edma_soc_info *pdata, int len)
> +{
> +	int ret = 0;
> +	int i;
> +	struct resource res;
> +	void *xbar;
> +	s16 (*xbar_chans)[2];
> +	u32 shift, offset, mux;
> +
> +	xbar_chans = devm_kzalloc(dev,
> +				  len/sizeof(s16) + 2*sizeof(s16),
> +				  GFP_KERNEL);
> +	if (!xbar_chans)
> +		return -ENOMEM;
> +
> +	ret = of_address_to_resource(node, 1, &res);
> +	if (IS_ERR_VALUE(ret))
> +		return -EIO;
> +
> +	xbar = devm_ioremap(dev, res.start, resource_size(&res));
> +	if (!xbar)
> +		return -EIO;

-ENOMEM is more appropiate for ioremap failures.

> +
> +	ret = edma_of_read_u32_to_s16_array(node,
> +					    "ti,edma-xbar-event-map",
> +					    (s16 *)xbar_chans,
> +					    len/sizeof(u32));
> +	if (IS_ERR_VALUE(ret))
> +		return -EIO;
> +
> +	for (i = 0; xbar_chans[i][0] != -1; i++) {
> +		shift = (xbar_chans[i][1] % 4) * 8;
> +		offset = xbar_chans[i][1] >> 2;
> +		offset <<= 2;
> +		mux = __raw_readl((void *)((u32)xbar + offset));

Dont use __raw* variants of io accessors. There will be ordering issues
on ARMv7.

> +		mux &= (~(0xff << shift));
> +		mux |= (xbar_chans[i][0] << shift);

Unnecessary parens above.

> +		__raw_writel(mux, (void *)((u32)xbar + offset));
> +	}
> +
> +	pdata->xbar_chans = xbar_chans;
> +
> +	return 0;
> +}
> +
>  static int edma_of_parse_dt(struct device *dev,
>  			    struct device_node *node,
>  			    struct edma_soc_info *pdata)
> @@ -1453,7 +1500,6 @@ static int edma_of_parse_dt(struct device *dev,
>  	pdata->n_slot = value;
>  
>  	pdata->n_cc = 1;
> -	/* This is unused */

The comment should have not been part of 4/16?

Thanks,
Sekhar
