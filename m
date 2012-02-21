Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2BULRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:17:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:38238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2BULRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:17:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110338907"
Date: Tue, 21 Feb 2012 12:17:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, eric.miao@linaro.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH v4 1/2] mfd: Add anatop mfd driver
Message-ID: <20120221111705.GV5387@sortiz-mobl>
References: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
 <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I didn't get patch #2, so I don't get to see how the read/write functions ar
eused for example.

On Thu, Feb 09, 2012 at 04:51:25AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.
A few comments here:



> +static u32 anatop_read(struct anatop *adata, u32 addr, int bit_shift, int bits)
> +{
> +	u32 val;
> +	int mask;
> +	if (bits == 32)
> +		mask = 0xff;
> +	else
> +		mask = (1 << bits) - 1;
> +
> +	val = ioread32(adata->ioreg+addr);
> +	val = (val >> bit_shift) & mask;
> +	return val;
> +}
> +
> +static void anatop_write(struct anatop *adata, u32 addr, int bit_shift,
> +			 int bits, u32 data)
> +{
> +	u32 val;
> +	int mask;
> +	if (bits == 32)
> +		mask = 0xff;
> +	else
> +		mask = (1 << bits) - 1;
> +
> +	val = ioread32(adata->ioreg+addr) & ~(mask << bit_shift);
> +	iowrite32((data << bit_shift) | val, adata->ioreg);
> +}
Don't you need some sort of read/write atomic routine as well ? Locking would
be needed then...


> +static const struct of_device_id of_anatop_regulator_match[] = {
> +	{
> +		.compatible = "fsl,anatop-regulator",
> +	},
> +	{
> +		.compatible = "fsl,anatop-thermal",
> +	},
> +	{ },
> +};
> +
> +static int of_anatop_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	u64 ofaddr;
> +	u64 ofsize;
> +	void *ioreg;
> +	struct anatop *drvdata;
> +	int ret = 0;
> +	const __be32 *rval;
> +
> +	rval = of_get_address(np, 0, &ofsize, NULL);
> +	if (rval)
> +		ofaddr = be32_to_cpu(*rval);
> +	else
> +		return -EINVAL;
> +
> +	ioreg = ioremap(ofaddr, ofsize);
> +	if (!ioreg)
> +		return -EINVAL;
> +	drvdata = devm_kzalloc(dev, sizeof(struct anatop), GFP_KERNEL);
> +	if (!drvdata)
> +		return -EINVAL;
> +	drvdata->ioreg = ioreg;
> +	drvdata->read = anatop_read;
> +	drvdata->write = anatop_write;
> +	platform_set_drvdata(pdev, drvdata);
> +	of_platform_bus_probe(np, of_anatop_regulator_match, dev);
> +	return ret;
> +}
So it seems that your driver here does nothing but extending your device tree
definition. Correct me if I'm wrong, aren't you trying to fix a broken device
tree definition here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
