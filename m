Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1EPJIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:08:23 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38235 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1EPJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <1305206878-18094-4-git-send-email-gg@slimlogic.co.uk>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
	<1305206878-18094-4-git-send-email-gg@slimlogic.co.uk>
Date: Mon, 16 May 2011 14:38:15 +0530
Message-ID: <BANLkTinrcQ-DRN-s+0sbJQ2=KRMtu+=hUg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] REGULATOR: TWL6025: add support to twl-regulator
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 6:57 PM, Graeme Gregory <gg@slimlogic.co.uk> wrote:
> Adding support for the twl6025. Major difference in the twl6025 is the
> group functionality has been removed from the chip so this affects how
> regulators are enabled and disabled.
>
> The names of the regulators also changed.
>
> The DCDCs of the 6025 are software controllable as well.
>
> Since V1
>
> Use the features variable passed via platform data instead of calling
> global function.
>
> Change the very switch like if statements to be a more readable
> switch statement.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/regulator/twl-regulator.c |  414 +++++++++++++++++++++++++++++++++---
>  1 files changed, 379 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 2a808c2..51f28cc 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -51,8 +51,13 @@ struct twlreg_info {
>        u16                     min_mV;
>        u16                     max_mV;
>
> +       u8                      flags;
> +
>        /* used by regulator core */
>        struct regulator_desc   desc;
> +
> +       /* chip specific features */
> +       unsigned long           features;
>  };
>
>
> @@ -70,6 +75,7 @@ struct twlreg_info {
>  #define VREG_TRANS             1
>  #define VREG_STATE             2
>  #define VREG_VOLTAGE           3
> +#define VREG_VOLTAGE_DCDC      4
>  /* TWL6030 Misc register offsets */
>  #define VREG_BC_ALL            1
>  #define VREG_BC_REF            2
> @@ -87,6 +93,17 @@ struct twlreg_info {
>  #define TWL6030_CFG_STATE_APP(v)       (((v) & TWL6030_CFG_STATE_APP_MASK) >>\
>                                                TWL6030_CFG_STATE_APP_SHIFT)
>
> +/* Flags for DCDC Voltage reading */
> +#define DCDC_OFFSET_EN         BIT(0)
> +#define DCDC_EXTENDED_EN       BIT(1)
> +
> +/* twl6025 SMPS EPROM values */
> +#define TWL6030_SMPS_OFFSET            0xB0
> +#define TWL6030_SMPS_MULT              0xB3
> +#define SMPS_MULTOFFSET_SMPS4  BIT(0)
> +#define SMPS_MULTOFFSET_VIO    BIT(1)
> +#define SMPS_MULTOFFSET_SMPS3  BIT(6)
> +
>  static inline int
>  twlreg_read(struct twlreg_info *info, unsigned slave_subgp, unsigned offset)
>  {
> @@ -144,11 +161,15 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
>        int                     grp, val;
>
> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> -       if (grp < 0)
> -               return grp;
> +       if (!(info->features & TWL6025_SUBCLASS)) {
> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> +               if (grp < 0)
> +                       return grp;
>
> -       grp &= P1_GRP_6030;
> +               grp &= P1_GRP_6030;
> +       } else {
> +               grp = 1;
> +       }
>
>        val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
>        val = TWL6030_CFG_STATE_APP(val);
> @@ -159,19 +180,22 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
>  static int twlreg_enable(struct regulator_dev *rdev)
>  {
>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> -       int                     grp;
> -       int                     ret;
> +       int                     grp = 0;
> +       int                     ret = 0;
>
> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> -       if (grp < 0)
> -               return grp;
> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS))) {
> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> +               if (grp < 0)
> +                       return grp;
>
> -       if (twl_class_is_4030())
> -               grp |= P1_GRP_4030;
> -       else
> -               grp |= P1_GRP_6030;
> +               if (twl_class_is_4030())
> +                       grp |= P1_GRP_4030;
> +               else
> +                       grp |= P1_GRP_6030;
>
> -       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_GRP, grp);
> +               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> +                                       VREG_GRP, grp);
> +       }
>
>        if (!ret && twl_class_is_6030())
>                ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
> @@ -186,29 +210,34 @@ static int twlreg_enable(struct regulator_dev *rdev)
>  static int twlreg_disable(struct regulator_dev *rdev)
>  {
>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> -       int                     grp;
> -       int                     ret;
> -
> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> -       if (grp < 0)
> -               return grp;
> -
> -       /* For 6030, set the off state for all grps enabled */
> -       if (twl_class_is_6030()) {
> -               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
> -                       (grp & (P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030)) <<
> -                               TWL6030_CFG_STATE_GRP_SHIFT |
> -                       TWL6030_CFG_STATE_OFF);
> +       int                     grp = 0;
> +       int                     ret = 0;
> +
> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS))) {
> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> +               if (grp < 0)
> +                       return grp;
> +
> +               /* For 6030, set the off state for all grps enabled */
> +               if (twl_class_is_6030()) {
> +                       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> +                                       VREG_STATE,
> +                                       (grp & (P1_GRP_6030 | P2_GRP_6030 |
> +                                       P3_GRP_6030)) <<
> +                                       TWL6030_CFG_STATE_GRP_SHIFT |
> +                                       TWL6030_CFG_STATE_OFF);
>                if (ret)
>                        return ret;
> -       }
> +               }
>
> -       if (twl_class_is_4030())
> -               grp &= ~(P1_GRP_4030 | P2_GRP_4030 | P3_GRP_4030);
> -       else
> -               grp &= ~(P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030);
> +               if (twl_class_is_4030())
> +                       grp &= ~(P1_GRP_4030 | P2_GRP_4030 | P3_GRP_4030);
> +               else
> +                       grp &= ~(P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030);
>
> -       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_GRP, grp);
> +               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> +                                       VREG_GRP, grp);
> +       }
>
>        /* Next, associate cleared grp in state register */
>        if (!ret && twl_class_is_6030())
> @@ -299,10 +328,11 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
>  static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
>  {
>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> -       int grp;
> +       int grp = 0;
>        int val;
>
> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
>
>        if (grp < 0)
>                return grp;
> @@ -594,6 +624,230 @@ static struct regulator_ops twl6030_fixed_resource = {
>        .get_status     = twl6030reg_get_status,
>  };
>
> +/*
> + * DCDC status and control
> + */
> +

<snip>

> +
> +static struct regulator_ops twldcdc_ops = {
> +       .list_voltage           = twl6030dcdc_list_voltage,
> +
> +       .set_voltage            = twl6030dcdc_set_voltage,
> +       .get_voltage_sel        = twl6030dcdc_get_voltage_sel,

These 3 dcdc related function is specific to twl6025, could you please rename it

> +
> +       .enable                 = twlreg_enable,
> +       .disable                = twlreg_disable,
> +       .is_enabled             = twl6030reg_is_enabled,
> +
> +       .set_mode               = twl6030reg_set_mode,
> +
> +       .get_status             = twl6030reg_get_status,

Can you define separate twl6025 specific regulator enable/disable/is_enabled
/set_mode and get_status function
This can improve readability, reduce the number of if
and improves maintainability of previous twl chips

> +};
> +
>  /*----------------------------------------------------------------------*/
>
>  #define TWL4030_FIXED_LDO(label, offset, mVolts, num, turnon_delay, \
> @@ -636,6 +890,22 @@ static struct regulator_ops twl6030_fixed_resource = {
>                }, \
>        }
>
> +#define TWL6025_ADJUSTABLE_LDO(label, offset, min_mVolts, max_mVolts, num, \
> +               remap_conf) { \
> +       .base = offset, \
> +       .id = num, \
> +       .min_mV = min_mVolts, \
> +       .max_mV = max_mVolts, \
> +       .remap = remap_conf, \
> +       .desc = { \
> +               .name = #label, \
> +               .id = TWL6025_REG_##label, \
> +               .n_voltages = ((max_mVolts - min_mVolts)/100) + 1, \
> +               .ops = &twl6030ldo_ops, \
> +               .type = REGULATOR_VOLTAGE, \
> +               .owner = THIS_MODULE, \
> +               }, \
> +       }
>
>  #define TWL_FIXED_LDO(label, offset, mVolts, num, turnon_delay, remap_conf, \
>                family, operations) { \
> @@ -667,6 +937,23 @@ static struct regulator_ops twl6030_fixed_resource = {
>                }, \
>        }
>
> +#define TWL6025_ADJUSTABLE_DCDC(label, offset, num, \
> +               remap_conf) { \
> +       .base = offset, \
> +       .id = num, \
> +       .min_mV = 600, \
> +       .max_mV = 2100, \
> +       .remap = remap_conf, \

remap is not used for twl6025?

> +       .desc = { \
> +               .name = #label, \
> +               .id = TWL6025_REG_##label, \
> +               .n_voltages = 63, \
