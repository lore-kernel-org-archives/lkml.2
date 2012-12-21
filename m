Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2LUQHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:07:04 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44192 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2LUQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:06:58 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 11:06:57 EST
MIME-Version: 1.0
In-Reply-To: <1355794293.5681.3.camel@phoenix>
References: <1355794210.5681.1.camel@phoenix>
	<1355794293.5681.3.camel@phoenix>
Date: Fri, 21 Dec 2012 23:58:58 +0800
Message-ID: <CAN1soZz=5pT5fzShq3v86G3k=J5Qzz2VCS_Z-ssu9i_3P2FLLQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: 88pm8607: Use apply_[reg|bit] with regmap
 based voltage_sel operations
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:31 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/88pm8607.c |   43 ++++++++++++------------------------------
>  1 file changed, 12 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
> index 2b55711..9ebdf8c 100644
> --- a/drivers/regulator/88pm8607.c
> +++ b/drivers/regulator/88pm8607.c
> @@ -30,8 +30,6 @@ struct pm8607_regulator_info {
>         unsigned int    *vol_table;
>         unsigned int    *vol_suspend;
>
> -       int     update_reg;
> -       int     update_bit;
>         int     slope_double;
>  };
>
> @@ -222,29 +220,6 @@ static int pm8607_list_voltage(struct regulator_dev *rdev, unsigned index)
>         return ret;
>  }
>
> -static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
> -{
> -       struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
> -       uint8_t val;
> -       int ret;
> -
> -       val = (uint8_t)(selector << (ffs(rdev->desc->vsel_mask) - 1));
> -
> -       ret = pm860x_set_bits(info->i2c, rdev->desc->vsel_reg,
> -                             rdev->desc->vsel_mask, val);
> -       if (ret)
> -               return ret;
> -       switch (info->desc.id) {
> -       case PM8607_ID_BUCK1:
> -       case PM8607_ID_BUCK3:
> -               ret = pm860x_set_bits(info->i2c, info->update_reg,
> -                                     1 << info->update_bit,
> -                                     1 << info->update_bit);
> -               break;
> -       }
> -       return ret;
> -}
> -
>  static int pm8606_preg_enable(struct regulator_dev *rdev)
>  {
>         struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
> @@ -276,7 +251,7 @@ static int pm8606_preg_is_enabled(struct regulator_dev *rdev)
>
>  static struct regulator_ops pm8607_regulator_ops = {
>         .list_voltage   = pm8607_list_voltage,
> -       .set_voltage_sel = pm8607_set_voltage_sel,
> +       .set_voltage_sel = regulator_set_voltage_sel_regmap,
>         .get_voltage_sel = regulator_get_voltage_sel_regmap,
>         .enable = regulator_enable_regmap,
>         .disable = regulator_disable_regmap,
> @@ -313,11 +288,11 @@ static struct regulator_ops pm8606_preg_ops = {
>                 .n_voltages = ARRAY_SIZE(vreg##_table),                 \
>                 .vsel_reg = PM8607_##vreg,                              \
>                 .vsel_mask = ARRAY_SIZE(vreg##_table) - 1,              \
> +               .apply_reg = PM8607_##ureg,                             \
> +               .apply_bit = (ubit),                                    \
>                 .enable_reg = PM8607_##ereg,                            \
>                 .enable_mask = 1 << (ebit),                             \
>         },                                                              \
> -       .update_reg     = PM8607_##ureg,                                \
> -       .update_bit     = (ubit),                                       \
>         .slope_double   = (0),                                          \
>         .vol_table      = (unsigned int *)&vreg##_table,                \
>         .vol_suspend    = (unsigned int *)&vreg##_suspend_table,        \
> @@ -343,9 +318,15 @@ static struct regulator_ops pm8606_preg_ops = {
>  }
>
>  static struct pm8607_regulator_info pm8607_regulator_info[] = {
> -       PM8607_DVC(BUCK1, GO, 0, SUPPLIES_EN11, 0),
> -       PM8607_DVC(BUCK2, GO, 1, SUPPLIES_EN11, 1),
> -       PM8607_DVC(BUCK3, GO, 2, SUPPLIES_EN11, 2),
> +       PM8607_DVC(BUCK1, GO, BIT(0), SUPPLIES_EN11, 0),
> +       /*
> +        * BUCK2 is designed to control voltage of CP domain.
> +        * Linux only runs in AP side, so we don't need to control BUCK2 in AP
> +        * side. Thus set the apply bit to be 0 instead of BIT(1) to avoid
> +        * updating apply_bit for BUCK2.
> +        */
> +       PM8607_DVC(BUCK2, GO, 0, SUPPLIES_EN11, 1),
Since update bit is already defined in GO register of PM8607, it seems
better to
define it as BIT(1) in this register. Otherwise, the comment is so strange.

I'm sorry on this since I didn't look at your patch carefully in the
first round. Please
help to change it as
      PM8607_DVC(BUCK2, GO, BIT(1), SUPPLIES_EN11, 1).

Since I messed it with the implementation of set_voltage_sel() api.

For others, Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

> +       PM8607_DVC(BUCK3, GO, BIT(2), SUPPLIES_EN11, 2),
>
>         PM8607_LDO(1,         LDO1, 0, SUPPLIES_EN11, 3),
>         PM8607_LDO(2,         LDO2, 0, SUPPLIES_EN11, 4),
> --
> 1.7.9.5
>
>
>
