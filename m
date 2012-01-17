Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2AQTzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:55:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49212 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2AQTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:55:32 -0500
Date: Tue, 17 Jan 2012 19:55:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen2@diasemi.com>
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
Message-ID: <20120117195530.GB31854@sirena.org.uk>
References: <1326806951.3542.342.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326806951.3542.342.camel@dhruva>
X-Cookie: Edwin Meese made me wear CORDOVANS!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:59:11PM +0530, Ashish Jangam wrote:

> +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> +	if (ret < 0) {
> +		dev_err(onkey->da9052->dev,
> +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> +			ret);
> +		ret = 1;
> +	} else {
> +		ret = ret & DA9052_EVENTB_ENONKEY;
> +		input_report_key(onkey->input, KEY_POWER, ret);
> +		input_sync(onkey->input);
> +	}
> +
> +	if (ret)
> +		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));

Why not just schedule the work directly?  The use of ret took a bit of
thinking about to follow.

> +
> +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> +{
> +	struct da9052_onkey *onkey;
> +	int error;
> +
> +	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
> +	if (!onkey) {
> +		dev_err(&pdev->dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}

devm_kzalloc()

> +	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");
> +	if (onkey->irq < 0) {
> +		error = -ENXIO;

platform_get_irq_byname() returned an error code, you should
normallypass it back.

> +	error = request_threaded_irq(onkey->da9052->irq_base + onkey->irq, NULL,
> +				     da9052_onkey_irq,

This looks buggy, the resource should have the IRQ you need directly in
it.  The MFD core can do this for the chip core driver when it registers
children.

> +static int __init da9052_onkey_init(void)
> +{
> +	return platform_driver_register(&da9052_onkey_driver);
> +}
> +module_init(da9052_onkey_init);
> +
> +static void __exit da9052_onkey_exit(void)
> +{
> +	platform_driver_unregister(&da9052_onkey_driver);
> +}
> +module_exit(da9052_onkey_exit);

Use module_platform_driver.
