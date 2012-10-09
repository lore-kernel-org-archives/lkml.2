Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2JIKxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:53:13 -0400
Received: from [65.55.88.13] ([65.55.88.13]:7822 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab2JIKxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:53:10 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: Re: [Patch v2 2/7] Regulator: DA9055 Regulator driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED38A84E78@KCHJEXMB03.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED38A84E78@KCHJEXMB03.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 9 Oct 2012 16:30:16 +0530
Message-ID: <1349780416.5244.39.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 15:37 +0530, Mark Brown wrote:
> On Mon, Oct 08, 2012 at 07:00:39PM +0530, Ashish Jangam wrote:
> 
> Mostly OK, but there's a few issues including yet more reimplementation
> of framework features.
> 
> > +static int da9055_list_voltage(struct regulator_dev *rdev,
> > +				unsigned int selector)
> > +{
> > +	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9055_regulator_info *info = regulator->info;
> > +	int volt_uV;
> > +
> > +	volt_uV = (selector * info->step_uV) + info->min_uV;
> > +
> > +	if (volt_uV > info->max_uV)
> > +		return -EINVAL;
> > +
> > +	return volt_uV;
> > +}
> 
> This is regulator_list_voltage_linear()
Agree.
> 
> > +static int da9055_map_voltage(struct regulator_dev *rdev,
> > +			      int min_uV, int max_uV)
> > +{
> > +	struct da9055_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9055_regulator_info *info = regulator->info;
> > +	int ret, sel;
> > +
> > +	ret = verify_range(info, min_uV, max_uV);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (min_uV < info->min_uV)
> > +		min_uV = info->min_uV;
> > +
> > +	sel = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
> > +
> > +	ret = da9055_list_voltage(rdev, sel);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return sel;
> > +}
> 
> This is regulator_map_voltage_linear().
Agree.
> 
> > +             int gpio = pdata->gpio_base + pdata->gpio_ren[id];
> 
> > +		sprintf(name, "DA9055 REG %d STATE", id);
> 
> snprintf().
> 
> > +		/* Set the GPIO I/P pin for controlling the regulator state. */
> > +		ret = devm_gpio_request_one(config->dev, gpio, GPIOF_DIR_IN,
> > +					    name);
> > +		if (ret < 0)
> > +			goto err;
> 
> We never actually appear to use this GPIO anywhere...  why are we
> requesting it?
DA9055 regulator changes its state by detecting the rising/failing edge at
GPI DA9055. Therefore we just need to set the DA9055 GPIO direction to input.
>   Also, why is the ability to read the regulator state via
> a GPIO associated with controlling it via a GPIO, it's unusual for these
> things to be tied together.
> 
There is no connection between state just to differentiate between two strings/labels.
If required I can change the string.


