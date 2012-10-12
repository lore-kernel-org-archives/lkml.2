Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab2JLN25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:28:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:18189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab2JLN2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:28:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="203725931"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
Thread-Topic: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
Thread-Index: AQHNqH1/4m+3vxUD3EiqzcH7Q9+iIA==
Date: Fri, 12 Oct 2012 13:28:43 +0000
Message-ID: <1350048519.10584.158.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	 <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
In-Reply-To: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.62]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EB5CA6FD0272640BF09A738D5796869@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9CDT2kK015790

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

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
