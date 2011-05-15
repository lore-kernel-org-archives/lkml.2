Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab1EORCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:02:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39425 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760155Ab1EORB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:01:59 -0400
Date: Sun, 15 May 2011 10:01:59 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCHv3 4/4] tps65912: add regulator driver
Message-ID: <20110515170158.GA11579@opensource.wolfsonmicro.com>
References: <BANLkTimqHbToRUuA7Krj_n1HBah3hhXODw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimqHbToRUuA7Krj_n1HBah3hhXODw@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 04:30:49PM -0500, Margarita Olaya wrote:
> The tps65912 consiste of 4 DCDCs and 10 LDOs. The output voltages can be
> configured by the SPI or I2C interface, they are meant to supply power
> to the main processor and other components.

Looks pretty good

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though a few things that you could fix incrementally:

> +static unsigned int tps65912_get_mode(struct regulator_dev *dev)
> +{
> +	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> +	struct tps65912 *mfd = pmic->mfd;
> +	int pwm_mode, eco, mode = 0, id = rdev_get_id(dev);
> +
> +	switch (id) {
> +	case TPS65912_REG_DCDC1:
> +		pwm_mode = tps65912_reg_read(mfd, TPS65912_DCDC1_CTRL);
> +		eco = tps65912_reg_read(mfd, TPS65912_DCDC1_AVS);
> +		break;

This switch statement for the lookup could be factored out into a
separate function for sharing with set.

> +static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
> +{
> +	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> +	struct tps65912 *mfd = pmic->mfd;
> +	int id = rdev_get_id(dev), voltage = 0, range;
> +	int opvsel = 0, avsel = 0, sr, vsel;

You'd save code in this function if you made it into a get_voltage_sel()
- a large chunk of it is a selector to voltage lookup.

> +static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
> +{
> +	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> +	struct tps65912 *mfd = pmic->mfd;
> +	int id = rdev_get_id(dev);
> +	int vsel = 0;
> +	u8 reg;
> +
> +	reg = tps65912_get_ldo_sel_register(pmic, id);
> +	vsel = tps65912_reg_read(mfd, reg);
> +	vsel &= 0x3F;
> +
> +	return tps65912_vsel_to_uv_ldo(vsel);

This is just an open coded get_voltage_sel().
