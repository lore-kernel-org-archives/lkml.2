Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab1ENQ1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:27:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42416 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753421Ab1ENQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:27:03 -0400
Date: Sat, 14 May 2011 09:27:06 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCHv2 4/4] tps65912: add regulator driver
Message-ID: <20110514162705.GG2791@opensource.wolfsonmicro.com>
References: <BANLkTi=xj_eskCt5BT3pThy6pSBhGNsMTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=xj_eskCt5BT3pThy6pSBhGNsMTA@mail.gmail.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 01:44:05PM -0500, Margarita Olaya wrote:
> The tps65912 consist of 4 DCDCs and 10 LDOs. The output voltages can be
> configured by the SPI or I2C interface, they are meant to supply power
> to the main processor and other components.
> 
> Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>

A few fairly minor issues, and one thing that I just want you to
confirm...

> +static int tps65912_set_mode(struct regulator_dev *dev, unsigned int mode)
> +{
> +	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> +	struct tps65912 *mfd = pmic->mfd;
> +	int pwm_mode, eco, reg1, reg2, reg1_val, reg2_val;
> +	int id = rdev_get_id(dev);
> +
> +	switch (id) {
> +	case TPS65912_REG_DCDC1:
> +		reg1 = TPS65912_DCDC1_CTRL;
> +		reg2 = TPS65912_DCDC1_AVS;
> +		break;

A helper function for this switch statement might be useful, it's used
by both get and set mode calls.

> +static int tps65912_set_voltage_ldo(struct regulator_dev *dev,
> +						unsigned selector)
> +{
> +	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> +	struct tps65912 *mfd = pmic->mfd;
> +	int id = rdev_get_id(dev), reg, value;
> +
> +	reg = tps65912_get_ldo_sel_register(pmic, id);
> +	value = tps65912_reg_read(mfd, reg);
> +	value &= 0xC0;
> +	return tps65912_reg_write(mfd, reg, selector | value);
> +}

I *think* the register only contains things for this regulator so you
don't need locking beyond the lock the regulator API guarantees you but
if that's not the case you'd need to ensure nothing could jump into the
middle of the read/modify/write cycle.

A comment would help.
