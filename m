Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JIS5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:57:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57785 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2JIS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:57:36 -0400
Date: Tue, 9 Oct 2012 14:58:22 -0400
From: Matt Porter <mporter@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 03/13] ARM: edma: add DT and runtime PM support for
 AM335x
Message-ID: <20121009185822.GA13724@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-4-git-send-email-mporter@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EA8A860@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA8A860@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:53:06AM +0000, Hebbar, Gururaja wrote:
> On Thu, Sep 20, 2012 at 20:13:36, Porter, Matt wrote:
> > Adds support for parsing the TI EDMA DT data into the required
> > EDMA private API platform data.
> > 
> > Calls runtime PM API only in the DT case in order to unidle the
> > associated hwmods on AM335x.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/common/edma.c           |  252 ++++++++++++++++++++++++++++++++++++--
> >  arch/arm/include/asm/mach/edma.h |    8 +-
> >  2 files changed, 244 insertions(+), 16 deletions(-)
> 
> The binding documentation should be updated along with the driver
> change that does introduce the binding. You could just merged patch #4
> and #5.

Hi Gururaja,

Sorry I missed these comments for this long...

I've been asked by maintainers to keep the binding separate in other
drivers. It is documentation that is independent of the driver in
any case...I'll move the binding before this implementation though.

> > diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> > index 001d268..f337f81 100644
> > --- a/arch/arm/common/edma.c
> > +++ b/arch/arm/common/edma.c
> > @@ -24,6 +24,13 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#include <linux/edma.h>
> > +#include <linux/err.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/pm_runtime.h>
> >  
> >  #include <asm/mach/edma.h>
> >  
> > @@ -1366,30 +1373,236 @@ void edma_clear_event(unsigned channel)
> >  EXPORT_SYMBOL(edma_clear_event);
> >  
> >  /*-----------------------------------------------------------------------*/
> > +static int edma_of_read_u32_to_s8_array(const struct device_node *np,
> > +					 const char *propname, s8 *out_values,
> > +					 size_t sz)
> > +{
> > +	struct property *prop = of_find_property(np, propname, NULL);
> > +	const __be32 *val;
> > +
> > +	if (!prop)
> > +		return -EINVAL;
> > +	if (!prop->value)
> > +		return -ENODATA;
> > +	if ((sz * sizeof(u32)) > prop->length)
> > +		return -EOVERFLOW;
> > +
> > +	val = prop->value;
> > +
> > +	while (sz--)
> > +		*out_values++ = (s8)(be32_to_cpup(val++) & 0xff);
> > +
> > +	/* Terminate it */
> > +	*out_values++ = -1;
> > +	*out_values++ = -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> > +					 const char *propname, s16 *out_values,
> > +					 size_t sz)
> > +{
> > +	struct property *prop = of_find_property(np, propname, NULL);
> > +	const __be32 *val;
> > +
> > +	if (!prop)
> > +		return -EINVAL;
> > +	if (!prop->value)
> > +		return -ENODATA;
> > +	if ((sz * sizeof(u32)) > prop->length)
> > +		return -EOVERFLOW;
> > +
> > +	val = prop->value;
> > +
> > +	while (sz--)
> > +		*out_values++ = (s16)(be32_to_cpup(val++) & 0xffff);
> > +
> > +	/* Terminate it */
> > +	*out_values++ = -1;
> > +	*out_values++ = -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int edma_of_parse_dt(struct device *dev,
> > +			    struct device_node *node,
> > +			    struct edma_soc_info *pdata)
> > +{
> > +	int ret = 0;
> > +	u32 value;
> > +	struct property *prop;
> > +	size_t sz;
> > +	struct edma_rsv_info *rsv_info;
> > +	s16 (*rsv_chans)[2], (*rsv_slots)[2];
> > +	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
> > +
> > +	ret = of_property_read_u32(node, "dma-channels", &value);
> > +	if (ret < 0)
> > +		return ret;
> > +	pdata->n_channel = value;
> > +
> > +	ret = of_property_read_u32(node, "ti,edma-regions", &value);
> > +	if (ret < 0)
> > +		return ret;
> > +	pdata->n_region = value;
> > +
> > +	ret = of_property_read_u32(node, "ti,edma-slots", &value);
> > +	if (ret < 0)
> > +		return ret;
> > +	pdata->n_slot = value;
> > +
> > +	pdata->n_cc = 1;
> > +	/* This is unused */
> > +	pdata->n_tc = 3;
> > +
> > +	rsv_info =
> > +		devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
> > +	if (!rsv_info)
> > +		return -ENOMEM;
> > +	pdata->rsv = rsv_info;
> > +
> > +	/* Build the reserved channel/slots arrays */
> > +	prop = of_find_property(node, "ti,edma-reserved-channels", &sz);
> > +	if (!prop)
> > +		return -EINVAL;
> > +
> > +	rsv_chans =
> > +		devm_kzalloc(dev, sz/sizeof(s16) + 2*sizeof(s16), GFP_KERNEL);
> > +	if (!rsv_chans)
> > +		return -ENOMEM;
> > +	pdata->rsv->rsv_chans = rsv_chans;
> > +
> > +	ret = edma_of_read_u32_to_s16_array(node, "ti,edma-reserved-channels",
> > +					    (s16 *)rsv_chans, sz/sizeof(u32));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	prop = of_find_property(node, "ti,edma-reserved-slots", &sz);
> > +	if (!prop)
> > +		return -EINVAL;
> > +
> 
> Binding Documentation mentions edma-reserved-[channels/slots] as optional. 
> But here the code returns as error if they are not found. Kindly reconfirm
> 
> >From patch-set 5/13
> 
> +Optional properties:
> +- ti,edma-reserved-channels: List of reserved channel regions
> +- ti,edma-reserved-slots: List of reserved slot regions

Good catch, the binding documentation is correct and I will fix my
implementation to match.

> > +	rsv_slots = devm_kzalloc(dev,
> > +				 sz/sizeof(s16) + 2*sizeof(s16),
> > +				 GFP_KERNEL);
> > +	if (!rsv_slots)
> > +		return -ENOMEM;
> > +	pdata->rsv->rsv_slots = rsv_slots;
> > +
> > +	ret = edma_of_read_u32_to_s16_array(node,
> > +					    "ti,edma-reserved-slots",
> > +					    (s16 *)rsv_slots,
> > +					    sz/sizeof(u32));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	prop = of_find_property(node, "ti,edma-queue-tc-map", &sz);
> > +	if (!prop)
> > +		return -EINVAL;
> > +
> > +	queue_tc_map = devm_kzalloc(dev,
> > +				    sz/sizeof(s8) + 2*sizeof(s8),
> > +				    GFP_KERNEL);
> > +	if (!rsv_slots)
> > +		return -ENOMEM;
> > +	pdata->queue_tc_mapping = queue_tc_map;
> > +
> > +	ret = edma_of_read_u32_to_s8_array(node,
> > +					   "ti,edma-queue-tc-map",
> > +					   (s8 *)queue_tc_map,
> > +					   sz/sizeof(u32));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	prop = of_find_property(node, "ti,edma-queue-priority-map", &sz);
> > +	if (!prop)
> > +		return -EINVAL;
> > +
> > +	queue_priority_map = devm_kzalloc(dev,
> > +					  sz/sizeof(s8) + 2*sizeof(s8),
> > +					  GFP_KERNEL);
> > +	if (!rsv_slots)
> > +		return -ENOMEM;
> > +	pdata->queue_priority_mapping = queue_priority_map;
> > +
> > +	ret = edma_of_read_u32_to_s8_array(node,
> > +					   "ti,edma-queue-tc-map",
> > +					   (s8 *)queue_priority_map,
> > +					   sz/sizeof(u32));
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = of_property_read_u32(node, "ti,edma-default-queue", &value);
> > +	if (ret < 0)
> > +		return ret;
> > +	pdata->default_queue = value;
> > +
> > +	return ret;
> > +}
> > +
> > +static struct of_dma_filter_info edma_filter_info = {
> > +	.filter_fn = edma_filter_fn,
> > +};
> >  
> >  static int __init edma_probe(struct platform_device *pdev)
> >  {
> >  	struct edma_soc_info	**info = pdev->dev.platform_data;
> > -	const s8		(*queue_priority_mapping)[2];
> > -	const s8		(*queue_tc_mapping)[2];
> > +	s8			(*queue_priority_mapping)[2];
> > +	s8			(*queue_tc_mapping)[2];
> >  	int			i, j, off, ln, found = 0;
> >  	int			status = -1;
> > -	const s16		(*rsv_chans)[2];
> > -	const s16		(*rsv_slots)[2];
> > +	s16			(*rsv_chans)[2];
> > +	s16			(*rsv_slots)[2];
> 
> What is the significance of the number "2" in all above members?

Those should all be EDMA_MAX_CC, as that is the significance. I 
will address that. Incidentally, this is expected to be short-lived
after Davinci ASoC is fully converted to dmaengine. One of the
big problems in the private EDMA API driver from an implementation
POV is that the driver attempt to encompass all channel controller
instances in a single device match. This results in this legacy
pdata structure that we adopt for compatibility. As part of folding
this into drivers/dma/edma.c, we'll have a device instance per
channel controller that will nicely clean this up. Not to mention
all the unused code we'll remove.

> >  	int			irq[EDMA_MAX_CC] = {0, 0};
> >  	int			err_irq[EDMA_MAX_CC] = {0, 0};
> >  	struct resource		*r[EDMA_MAX_CC] = {NULL};
> > +	struct resource		res[EDMA_MAX_CC];
> >  	resource_size_t		len[EDMA_MAX_CC];
> >  	char			res_name[10];
> >  	char			irq_name[10];
> > +	struct device_node	*node = pdev->dev.of_node;
> > +	struct device		*dev = &pdev->dev;
> > +	struct edma_soc_info	*pdata;
> > +
> > +	if (node) {
> > +		int ret;
> > +		pdata = devm_kzalloc(dev,
> > +				     sizeof(struct edma_soc_info),
> > +				     GFP_KERNEL);
> > +		edma_of_parse_dt(dev, node, pdata);
> > +		info = &pdata;
> > +		dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> > +		of_dma_controller_register(dev->of_node,
> > +					   of_dma_simple_xlate,
> > +					   &edma_filter_info);
> > +		pm_runtime_enable(dev);
> > +		ret = pm_runtime_get_sync(dev);
> > +		if (IS_ERR_VALUE(ret)) {
> > +			dev_err(dev, "pm_runtime_get_sync() failed\n");
> > +			return ret;
> > +		}
> > +	}
> >  
> >  	if (!info)
> >  		return -ENODEV;
> >  
> >  	for (j = 0; j < EDMA_MAX_CC; j++) {
> > -		sprintf(res_name, "edma_cc%d", j);
> > -		r[j] = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> > +		if (node) {
> > +			int err;
> > +			err = of_address_to_resource(node, 0, &res[j]);
> > +			if (err) {
> > +				dev_err(dev,
> > +					"unable to find 'reg' property\n");
> > +				return -EIO;
> > +			}
> > +			r[j] = &res[j];
> > +
> > +		} else {
> > +			sprintf(res_name, "edma_cc%d", j);
> > +			r[j] = platform_get_resource_byname(pdev,
> > +						IORESOURCE_MEM,
> >  						res_name);
> > +		}
> >  		if (!r[j] || !info[j]) {
> >  			if (found)
> >  				break;
> > @@ -1465,8 +1678,12 @@ static int __init edma_probe(struct platform_device *pdev)
> >  			}
> >  		}
> >  
> > -		sprintf(irq_name, "edma%d", j);
> > -		irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +		if (node)
> > +			irq[j] = irq_of_parse_and_map(node, 0);
> > +		else {
> > +			sprintf(irq_name, "edma%d", j);
> > +			irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +		}
> >  		edma_cc[j]->irq_res_start = irq[j];
> >  		status = request_irq(irq[j], dma_irq_handler, 0, "edma",
> >  					&pdev->dev);
> > @@ -1476,8 +1693,12 @@ static int __init edma_probe(struct platform_device *pdev)
> >  			goto fail;
> >  		}
> >  
> > -		sprintf(irq_name, "edma%d_err", j);
> > -		err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +		if (node)
> > +			err_irq[j] = irq_of_parse_and_map(node, 2);
> > +		else {
> > +			sprintf(irq_name, "edma%d_err", j);
> > +			err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +		}
> >  		edma_cc[j]->irq_res_end = err_irq[j];
> >  		status = request_irq(err_irq[j], dma_ccerr_handler, 0,
> >  					"edma_error", &pdev->dev);
> > @@ -1538,9 +1759,17 @@ fail1:
> >  	return status;
> >  }
> >  
> > +static const struct of_device_id edma_of_ids[] = {
> > +	{ .compatible = "ti,edma3", },
> > +	{}
> > +};
> >  
> >  static struct platform_driver edma_driver = {
> > -	.driver.name	= "edma",
> > +	.driver = {
> > +		.name	= "edma",
> > +		.of_match_table = edma_of_ids,
> 
> Won't this fail/warn when CONFIG_OF not selected/enabled?

No. of_match_table is no longer dependent on CONFIG_OF

> > +	},
> > +	.probe = edma_probe,
> >  };
> >  
> >  static int __init edma_init(void)
> > @@ -1548,4 +1777,3 @@ static int __init edma_init(void)
> >  	return platform_driver_probe(&edma_driver, edma_probe);
> >  }
> >  arch_initcall(edma_init);
> > -
> 
> Stray change I believe.

checkpatch found that bad whitespace.

> > diff --git a/arch/arm/include/asm/mach/edma.h b/arch/arm/include/asm/mach/edma.h
> > index 7e84c90..ce5f6f8 100644
> > --- a/arch/arm/include/asm/mach/edma.h
> > +++ b/arch/arm/include/asm/mach/edma.h
> > @@ -237,8 +237,8 @@ void edma_resume(unsigned channel);
> >  
> >  struct edma_rsv_info {
> >  
> > -	const s16	(*rsv_chans)[2];
> > -	const s16	(*rsv_slots)[2];
> > +	s16		(*rsv_chans)[2];
> > +	s16		(*rsv_slots)[2];
> >  };
> >  
> >  /* platform_data for EDMA driver */
> > @@ -260,8 +260,8 @@ struct edma_soc_info {
> >  	/* Resource reservation for other cores */
> >  	struct edma_rsv_info	*rsv;
> >  
> > -	const s8	(*queue_tc_mapping)[2];
> > -	const s8	(*queue_priority_mapping)[2];
> > +	s8	(*queue_tc_mapping)[2];
> > +	s8	(*queue_priority_mapping)[2];
> >  };
> >  
> >  #endif
> > -- 
> > 1.7.9.5
> > 
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> > 
> 
> 
> Regards, 
> Gururaja
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
