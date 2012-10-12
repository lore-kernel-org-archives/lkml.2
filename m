Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2JLN1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:27:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:48912 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab2JLN1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="155507997"
Message-ID: <1350047732.10584.155.camel@smile>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
In-Reply-To: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	 <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
Date: Fri, 12 Oct 2012 16:27:19 +0300
Content-Transfer-Encoding: 
X-Mailer: Evolution 3.4.3-1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 11:14 +0530, Viresh Kumar wrote: 
> dw_dmac driver already supports device tree but it used to have its platform
> data passed the non-DT way.
Another portion of comments.

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

> +static struct dw_dma_platform_data *
> +__devinit dw_dma_parse_dt(struct platform_device *pdev)
> +{
> +	struct device_node *sn, *cn, *np = pdev->dev.of_node;
> +	struct dw_dma_platform_data *pdata;
> +	struct dw_dma_slave *sd;
> +	u32 count, val, arr[4];
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "Missing DT data\n");
> +		return NULL;
> +	}
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;
> +
> +	if (of_property_read_u32(np, "nr_channels", &pdata->nr_channels))
> +		return NULL;
> +
> +	if (of_property_read_bool(np, "is_private"))
> +		pdata->is_private = true;
> +
> +	if (!of_property_read_u32(np, "chan_allocation_order",
> +				&val))
Fits one line?

> +		pdata->chan_allocation_order = (unsigned char)val;
do we really need explicit casting here?

> +
> +	if (!of_property_read_u32(np, "chan_priority", &val))
> +		pdata->chan_priority = (unsigned char)val;
ditto

> +
> +	if (!of_property_read_u32(np, "block_size", &val))
> +		pdata->block_size = (unsigned short)val;
ditto 
> +
> +	if (!of_property_read_u32(np, "nr_masters", &val)) {
> +		if (val > 4)
I thought once that we might introduce constant like #define
DW_MAX_AHB_MASTERS 4. It seems a bit useless because hw is designed for
that number anyway, but maybe you have another opinion. 

> +			return NULL;
> +
> +		pdata->nr_masters = (unsigned char)val;
> +	}
> +
> +	if (!of_property_read_u32_array(np, "data_width", arr,
> +				pdata->nr_masters))
> +		for (count = 0; count < pdata->nr_masters; count++)
> +			pdata->data_width[count] = arr[count];
Ah, it would be nice to have of_property_read_u8_array and so on...

> +
> +	/* parse slave data */
> +	sn = of_find_node_by_name(np, "slave_info");
> +	if (!sn)
> +		return pdata;
> +
> +	count = 0;
> +	/* calculate number of slaves */
> +	for_each_child_of_node(sn, cn)
> +		count++;

of.h: static inline int of_get_child_count(const struct device_node *np)


> +
> +	if (!count)
> +		return NULL;
> +
> +	sd = devm_kzalloc(&pdev->dev, sizeof(*sd) * count, GFP_KERNEL);
> +	if (!sd)
> +		return NULL;
> +
> +	count = 0;
> +	for_each_child_of_node(sn, cn) {
> +		of_property_read_string(cn, "bus_id", &sd[count].bus_id);
> +		of_property_read_u32(cn, "cfg_hi", &sd[count].cfg_hi);
> +		of_property_read_u32(cn, "cfg_lo", &sd[count].cfg_lo);
> +		if (!of_property_read_u32(cn, "src_master", &val))
> +			sd[count].src_master = (u8)val;
Explicit casting?

> +
> +		if (!of_property_read_u32(cn, "dst_master", &val))
> +			sd[count].dst_master = (u8)val;
ditto 
> +
> +		sd[count].dma_dev = &pdev->dev;
> +		count++;
> +	}

what about to define sd as sd[0]; in the platform_data structure and
then use smth like following

struct ... *sd = pdata->sd;
for_each... {
sd->... = ;
sd++;
}

it will probably require to split this part in a separate function and
calculate count of slave_info children before pdata memory allocation.


> +
> +	pdata->sd = sd;
> +	pdata->sd_count = count;
> +
> +	return pdata;
> +}

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
