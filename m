Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab1FVMsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:48:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47701 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab1FVMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:48:24 -0400
Date: Wed, 22 Jun 2011 13:48:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: Add initial S5M8751 support
Message-ID: <20110622124820.GD23666@sirena.org.uk>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com> <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308722037-6966-3-git-send-email-sbkim73@samsung.com>
X-Cookie: Is it clean in other dimensions?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 02:53:56PM +0900, Sangbeom Kim wrote:
> The WM8994 is a advanced PMIC with AUdio DAC
> Since it includes regulators, Battery charger, audio dac,
> it is represented as a multi-function device,
> though the functionality will be provided by the each driver.

I think you may have cut'n'pasted bits of this changelog from somewhere
else without doing all the updates you meant to :)

> +	if (event1 & S5M8751_MASK_PWRKEY1B)
> +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY1B);
> +
> +	if (event1 & S5M8751_MASK_PWRKEY2B)
> +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY2B);
> +
> +	if (event1 & S5M8751_MASK_PWRKEY3)
> +		s5m8751_irq_call_handler(s5m8751, S5M8751_IRQ_PWRKEY3);

This looks like the IRQ handler code doesn't need to understand the
specific events, it can just loop over the registers and fire off
interrupts based on the bit numbers.

As I said for the first patch this should all be using genirq.

> +static irqreturn_t s5m8751_irq(int irq, void *data)
> +{
> +	struct s5m8751 *s5m8751 = data;
> +
> +	disable_irq_nosync(irq);
> +	schedule_work(&s5m8751->irq_work);
> +
> +	return IRQ_HANDLED;
> +}

Use a threaded IRQ handler.

> +int s5m8751_device_init(struct s5m8751 *s5m8751, int irq,
> +			struct s5m8751_platform_data *pdata)
> +{
> +	int ret = -EINVAL;
> +	u8 chip_id;
> +
> +	if (pdata->init) {
> +		ret = pdata->init(s5m8751);
> +		if (ret != 0) {
> +			dev_err(s5m8751->dev,
> +			 "Platform init() failed: %d\n", ret);
> +			goto err;
> +		}
> +	}
> +
> +	s5m8751_reg_read(s5m8751, S5M8751_CHIP_ID, &chip_id);
> +	if (!chip_id)
> +		dev_info(s5m8751->dev, "Found S5M8751 device\n");
> +	else {
> +		dev_info(s5m8751->dev, "Didn't Find S5M8751 device\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}

I'd really expect the init() callback to run after we've checked that
we can talk to the device.
