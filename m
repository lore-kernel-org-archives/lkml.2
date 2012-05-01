Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2EAQ63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:58:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33089 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2EAQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:58:28 -0400
Date: Tue, 1 May 2012 17:58:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        Chiwoong byun <woong.byun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] MFD : add MAX77686 mfd driver
Message-ID: <20120501165825.GA3264@sirena.org.uk>
References: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335776022-4571-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 05:53:42PM +0900, Jonghwa Lee wrote:

> +	if (irq_src & MAX77686_IRQSRC_RTC) {
> +#ifdef CONFIG_RTC_DRV_MAX77686
> +		ret = max77686_read_reg(max77686->rtc, MAX77686_RTC_INT,
> +					 &irq_reg[RTC_INT]);
> +#else
> +		ret = -ENODEV;
> +#endif

Why is this in an ifdef?  It's not really idiomatic to do this and if
the interrupt is never requested presumably everything should be fine.

> +int max77686_irq_resume(struct max77686_dev *max77686)
> +{
> +	if (max77686->irq && max77686->irq_base)
> +		max77686_irq_thread(max77686->irq_base, max77686);
> +	return 0;
> +}

Why is this needed?  I'd expect the parent IRQ controller to notice if
the device is asserting an interrupt when it resumes.

> +int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +{
> +	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
> +	int ret;
> +
> +	mutex_lock(&max77686->iolock);
> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	mutex_unlock(&max77686->iolock);
> +	if (ret < 0)
> +		return ret;

It would be much better to use regmap for the register I/O since this is
a PMIC and at least the regulator framework (possibly others soon) are
starting to abstract things out using it.  It also gets you things like
the debugfs dumps of the register map and so on easily.

> +	} else
> +		dev_info(max77686->dev, "device found\n");

This isn't relly adding much - can you log a chip revision or anything?

> +#ifdef CONFIG_RTC_DRV_MAX77686
> +	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
> +	i2c_set_clientdata(max77686->rtc, max77686);
> +#endif

Again, it's very odd that this is conditional.
