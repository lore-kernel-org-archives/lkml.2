Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1LEWtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:49:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50242 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1LEWtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <af9ea8649257cedcdcc531ce918fa4fba5b4e4a7.1299679848.git.aliaksei.katovich@nokia.com>
References: <cover.1299679848.git.aliaksei.katovich@nokia.com>
	<af9ea8649257cedcdcc531ce918fa4fba5b4e4a7.1299679848.git.aliaksei.katovich@nokia.com>
Date: Tue, 6 Dec 2011 00:49:04 +0200
Message-ID: <CAMP44s1ddZnd0REBt9dQ8FWZ0a5K=bPJikNAVRP=9Zj8NAQn+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: bq2415x charger driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: aliaksei.katovich@nokia.com
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 4:48 PM,  <aliaksei.katovich@nokia.com> wrote:
> From: Aliaksei Katovich <aliaksei.katovich@nokia.com>
>
> Added driver to support TI bq24153/6 one-cell Li-Ion chargers.

I tried this driver and it didn't do anything. Some regulators are
registered, and I guess the right values are loaded, but that's all.

It doesn't get configured in any way, and I don't see the code for the
timer reset, without which the charging will stop right away (if it
had managed to start).

> +static inline int bq2415x_enable_otg(bool flag)
> +{
> +       int res;
> +
> +       res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_BAT_CTL);
> +       if (unlikely(res < 0))
> +               return res;
> +
> +       if (flag)
> +               res |= BQ2415X_OTG_EN;
> +       else
> +               res &= ~BQ2415X_OTG_EN;
> +
> +       return bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);

Wrong registry? BQ2415X_BAT_CTL.

> +}
> +
> +static inline int bq2415x_otg_high(bool flag)
> +{
> +       int res;
> +
> +       res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_BAT_CTL);
> +       if (unlikely(res < 0))
> +               return res;
> +
> +       if (flag)
> +               res |= BQ2415X_OTG_PL;
> +       else
> +               res &= ~BQ2415X_OTG_PL;
> +
> +       return bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);

Ditto.

> +/**
> + * bq2415x_exec - execute charger specific command
> + *
> + * Returns result of command execution upon success or negative otherwise
> + */
> +int bq2415x_exec(enum bq2415x_cmd cmd)

Who is supposed to call this? Why didn't you provide some examples?

> +static int
> +bq2415x_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
> +{
> +       int i, res;
> +       struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
> +
> +       i = bq2415x_vmap_index(max_uV, r->init.constraints.min_uV);
> +       if (i >= r->desc.n_voltages)
> +               return -EINVAL;
> +
> +       res = bq2415x_i2c_read(r->cli, r->reg);
> +       if (res < 0)
> +               return res;

The bit mask should be cleared beforehand, no? Otherwise the on bits
will remain that way.

> +       res |= bq2415x_vmap_calc(i, r->msk_summ, r->msk_mult);
> +       return bq2415x_i2c_write(r->cli, r->reg, res);
> +}

...

> +static int
> +bq2415x_set_current_limit(struct regulator_dev *rdev, int min_uA, int max_uA)
> +{
> +       int res;
> +       struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
> +
> +       res = bq2415x_i2c_read(r->cli, r->reg);
> +       if (res < 0)
> +               return res;
> +
> +       if (BQ2415X_IIN_LIMIT_100 <= min_uA && max_uA < BQ2415X_IIN_LIMIT_500)
> +               res &= ~BQ2415X_IIN_LIMIT_UNLIM_MASK;

I think these bits should always be cleared.

> +       else if (BQ2415X_IIN_LIMIT_500 <= min_uA &&
> +                       max_uA < BQ2415X_IIN_LIMIT_800)
> +               res |= BQ2415X_IIN_LIMIT_500_MASK;
> +       else if (BQ2415X_IIN_LIMIT_800 <= min_uA &&
> +                       max_uA < BQ2415X_IIN_LIMIT_UNLIM)
> +               res |= BQ2415X_IIN_LIMIT_800_MASK;
> +       else if (BQ2415X_IIN_LIMIT_UNLIM <= min_uA)
> +               res |= BQ2415X_IIN_LIMIT_UNLIM_MASK;
> +       else
> +               return -EINVAL;
> +
> +       return bq2415x_i2c_write(r->cli, r->reg, res);
> +}

> +/* regulator initialization */

...

> +static struct bq2415x_regulator bq2415x_regulator[] = {

I don't understand what these regulators are supposed to be doing, and
how other drivers are supposed to hook on them. Again, no examples.

Moreover, for example V_OREG is supposed to control the voltage from
3.5v to 4.4v, but you set the range from 20mv to 1260mv which is only
the additional voltage (and it starters from 0).

> +static void __init bq2415x_add_consumers(struct bq2415x_regulator *r,
> +                                        struct regulator_init_data *init)

I don't understand the purpose of this code at all.

> diff --git a/include/linux/mfd/bq2415x.h b/include/linux/mfd/bq2415x.h

There's no need for exporting a lot of this stuff.

-- 
Felipe Contreras
