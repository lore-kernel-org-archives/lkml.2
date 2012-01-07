Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2AGRrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 12:47:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1860 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2AGRrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 12:47:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 07 Jan 2012 09:47:03 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Sat, 7 Jan 2012 23:16:55 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczMpSLf+2g4NcxBTb+tKcG/YidCJgAuzzdg
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
In-Reply-To: <20120106185755.GC2893@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Saturday, January 07, 2012 12:28 AM, Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] wrote
> Please fix your mailer to word wrap in less than 80 columns.  I've
> reflowed your text for legibility.
> 
> > > > +	/* Configure the output discharge path */
> > > > +	st = tps62360_reg_modify_bits(tps, REG_RAMPCTRL, BIT(2), BIT(2));
> > > > +	if (st < 0)
> > > > +		dev_err(tps->dev, "%s() fails in updating reg %d\n",
> > > > +			__func__, REG_RAMPCTRL);
> > > > +}
> 
> > > I rather suspect that if this is worth doing it's also worth doing over
> > > suspend...
> 
> > The discharge path should be only enabled when the output voltage will
> > go to 0.  If it stay in non-zero voltage and enabling discharge path
> > will consume more power.  In suspend, it is not necessarily that
> > voltage output will be 0 and hence it should not be enabled. In
> > shutdown all power goes off from pmu and hence it is worth to enable
> > discharge path for quick fall of output voltage.
> 
> Why is shutdown particularly special in this regard, and surely the
> hardware is capable of automatically disabling the discharge while the
> regulator is enabled?
> 
> Though frankly it seems rather broken if the hardware doesn't
> automatically remove the clamp when
>
The enable through external input line does not remove the clamp.
It need to do the reset of the pmu chip (through power off) to
remove the clamp automatically. The fast discharging is require
in shutdown if we want to again power ON device quickly.

Personally, I would like to have this piece of code as it is
configurable from platform data and does not hurt if someone does not set.

If it really blocks the patch to go through then I will remove it.
 
> > > > + * @vsel: Select the voltage id register.
> 
> > > What's this?
> 
> > There is 4 sets of voltage configuration register for voltage output.
> > The power on reset values for this registers are different and
> > selection of the voltage configuration register is done by 2 pins of
> > the pmu chip which is board dependent.  Based on board connection, it
> > need to be program the desired voltage configuration Register to
> > achieve the desired output.
> 
> Ah, you've misunderstood this functionality.  The reason regulators have
> these pin based register selections is that they'll be connected to
> GPIOs so that we can change voltages quickly without having to take the
> cost of I2C I/O.
> 
> For all practical purposes it's reasonable to assume that if vsel is
> fixed to anything rather than being connected to GPIOs it'll be
> connected to ground.
> 
> The other thing is that the naming is really unclear.

In my board it is tied to fix input and does not change. Also it is
tied such that it should output the voltage which is require by
system be default without any i2c programming. The default output
is 0.96V, 1.4V, 1.16V and 1.16V and VSEL0/1 which decides the voltage
selection is tied to high.

I think I should  go with your suggestion to allow the VSEL0/1 to be
dynamically changeable. If I implement this then client need to provide
4 sets of the regulator init data to register regulator. Each will have
different sets of consumer. Client will get regulator for all sets of
consumer and sets the appropriate voltage around optimum performance/
operating mode. And later on client will just change gpio to select
proper VSELs and so result will be changing output voltage without i2c.

If above is OK then I can push the next patch. My approach will be:

In the platform data, I will take 4 sets of regulator_init_data
corresponding to VSEL0/1. If client is not interested in all and tied
to fixed high/low, he will just pass NULL to unused index and proper
information to used option.

The 4 regulator (if all reg init data is passed, ignore the NULL
data) will get registered in probe of the driver.
The information flow will be such that the corresponding voltage
register will be selected as per the consumer which is passed with
corresponding regulator init data for configuration.


