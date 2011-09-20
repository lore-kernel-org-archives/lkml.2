Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1ITRPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:15:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:37558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1ITRPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50745405"
Date: Tue, 20 Sep 2011 19:17:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 1/3] mfd: add Intel MSIC driver
Message-ID: <20110920171742.GU32263@sortiz-mobl>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
 <dfff721c25a64c9fe77d3b14772e0b3325f47ff9.1315399396.git.mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfff721c25a64c9fe77d3b14772e0b3325f47ff9.1315399396.git.mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Wed, Sep 07, 2011 at 04:06:50PM +0300, Mika Westerberg wrote:
> Add support for Intel MSIC chip found on Intel Medfield platforms. This
> chip embeds several subdevices: audio, ADC, GPIO, power button, etc. The
> driver creates platform device for each subdevice.
> 
> We also provide an MSIC register access API which should replace the more
> generic SCU IPC interface currently used. Existing drivers can choose
> whether they convert to this new API or stick with the SCU IPC interface.
Looks good overall, I just have a few comments/questions:


> +/*
> + * Other MSIC related devices which are not directly available via SFI DEVS
> + * table. 
Would that mean a broken firmware, or something else I'm missing ?
It looks odd.


> +/**
> + * intel_msic_reg_read - read a single MSIC register
> + * @reg: register to read
> + * @val: register value is placed here
> + *
> + * Read a single register from MSIC. Returns %0 on success and negative
> + * errno in case of failure.
> + *
> + * Function may sleep.
> + */
> +int intel_msic_reg_read(unsigned short reg, u8 *val)
> +{
> +	return intel_scu_ipc_ioread8(reg, val);
> +}
> +EXPORT_SYMBOL_GPL(intel_msic_reg_read);
> +
> +/**
> + * intel_msic_reg_write - write a single MSIC register
> + * @reg: register to write
> + * @val: value to write to that register
> + *
> + * Write a single MSIC register. Returns 0 on success and negative
> + * errno in case of failure.
> + *
> + * Function may sleep.
> + */
> +int intel_msic_reg_write(unsigned short reg, u8 val)
> +{
> +	return intel_scu_ipc_iowrite8(reg, val);
> +}
> +EXPORT_SYMBOL_GPL(intel_msic_reg_write);
What is the benefit of those wrappers since you're probably not going to get
rid of the SCU IPC APIs, right ? What's wrong with the subdevices using the
SCU IPC API directly ?


> +/**
> + * intel_msic_bulk_read - read an array of registers
> + * @reg: array of register addresses to read
> + * @buf: array where the read values are placed
> + * @count: number of registers to read
> + *
> + * Function reads @count registers from the MSIC using addresses passed in
> + * @reg. Read values are placed in @buf. Reads are performed atomically
> + * wrt. MSIC.
> + *
> + * Returns %0 in case of success and negative errno in case of failure.
> + *
> + * Function may sleep.
> + */
> +int intel_msic_bulk_read(unsigned short *reg, u8 *buf, size_t count)
> +{
> +	if (WARN_ON(count > SCU_IPC_RWBUF_LIMIT))
> +		return -EINVAL;
> +
> +	return intel_scu_ipc_readv(reg, buf, count);
> +}
> +EXPORT_SYMBOL_GPL(intel_msic_bulk_read);
> +
> +/**
> + * intel_msic_bulk_write - write an array of values to the MSIC registers
> + * @reg: array of registers to write
> + * @buf: values to write to each register
> + * @count: number of registers to write
> + *
> + * Function writes @count registers in @buf to MSIC. Writes are performed
> + * atomically wrt MSIC. Returns %0 in case of success and negative errno in
> + * case of failure.
> + *
> + * Function may sleep.
> + */
> +int intel_msic_bulk_write(unsigned short *reg, u8 *buf, size_t count)
> +{
> +	if (WARN_ON(count > SCU_IPC_RWBUF_LIMIT))
> +		return -EINVAL;
> +
> +	return intel_scu_ipc_writev(reg, buf, count);
> +}
> +EXPORT_SYMBOL_GPL(intel_msic_bulk_write);
The 2 routines above make more sense.



> +static int __devinit intel_msic_init_devices(struct intel_msic *msic)
> +{
> +	struct platform_device *pdev = msic->pdev;
> +	struct intel_msic_platform_data *pdata = pdev->dev.platform_data;
> +	int ret, i;
> +
> +	if (pdata->gpio) {
> +		struct mfd_cell *cell = &msic_devs[INTEL_MSIC_BLOCK_GPIO];
> +
> +		cell->platform_data = pdata->gpio;
> +		cell->pdata_size = sizeof(*pdata->gpio);
> +	}
> +
> +	if (pdata->ocd) {
> +		unsigned gpio = pdata->ocd->gpio;
> +
> +		ret = gpio_request_one(gpio, GPIOF_IN, "ocd_gpio");
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to register OCD GPIO\n");
> +			return ret;
> +		}
> +
> +		ret = gpio_to_irq(gpio);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "no IRQ number for OCD GPIO\n");
> +			gpio_free(gpio);
> +			return ret;
> +		}
> +
> +		/* Update the IRQ number for the OCD */
> +		pdata->irq[INTEL_MSIC_BLOCK_OCD] = ret;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(msic_devs); i++) {
> +		if (!pdata->irq[i])
> +			continue;
I would expect some sort of warning here since it would mean your platform
code defined a sub device platform data without giving you the right IRQ. And
afaiu, all of your sub devices must have one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
