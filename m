Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1EROcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:32:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49724 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab1EROcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:32:23 -0400
Subject: Re: [PATCH v2 3/4] REGULATOR: TWL6025: add support to twl-regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: "T Krishnamoorthy, Balaji" <balajitk@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com, balbi@ti.com,
        broonie@opensource.wolfsonmicro.com
In-Reply-To: <4DD3D4EE.8010403@slimlogic.co.uk>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk>
	 <1305206878-18094-4-git-send-email-gg@slimlogic.co.uk>
	 <BANLkTinrcQ-DRN-s+0sbJQ2=KRMtu+=hUg@mail.gmail.com>
	 <4DD3D4EE.8010403@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 15:32:14 +0100
Message-ID: <1305729134.3295.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 15:17 +0100, Graeme Gregory wrote:
> On 16/05/2011 10:08, T Krishnamoorthy, Balaji wrote:
> > On Thu, May 12, 2011 at 6:57 PM, Graeme Gregory <gg@slimlogic.co.uk> wrote:
> >> Adding support for the twl6025. Major difference in the twl6025 is the
> >> group functionality has been removed from the chip so this affects how
> >> regulators are enabled and disabled.
> >>
> >> The names of the regulators also changed.
> >>
> >> The DCDCs of the 6025 are software controllable as well.
> >>
> >> Since V1
> >>
> >> Use the features variable passed via platform data instead of calling
> >> global function.
> >>
> >> Change the very switch like if statements to be a more readable
> >> switch statement.
> >>
> >> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> >> ---
> >>  drivers/regulator/twl-regulator.c |  414 +++++++++++++++++++++++++++++++++---
> >>  1 files changed, 379 insertions(+), 35 deletions(-)
> >>
> >> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> >> index 2a808c2..51f28cc 100644
> >> --- a/drivers/regulator/twl-regulator.c
> >> +++ b/drivers/regulator/twl-regulator.c
> >> @@ -51,8 +51,13 @@ struct twlreg_info {
> >>        u16                     min_mV;
> >>        u16                     max_mV;
> >>
> >> +       u8                      flags;
> >> +
> >>        /* used by regulator core */
> >>        struct regulator_desc   desc;
> >> +
> >> +       /* chip specific features */
> >> +       unsigned long           features;
> >>  };
> >>
> >>
> >> @@ -70,6 +75,7 @@ struct twlreg_info {
> >>  #define VREG_TRANS             1
> >>  #define VREG_STATE             2
> >>  #define VREG_VOLTAGE           3
> >> +#define VREG_VOLTAGE_DCDC      4
> >>  /* TWL6030 Misc register offsets */
> >>  #define VREG_BC_ALL            1
> >>  #define VREG_BC_REF            2
> >> @@ -87,6 +93,17 @@ struct twlreg_info {
> >>  #define TWL6030_CFG_STATE_APP(v)       (((v) & TWL6030_CFG_STATE_APP_MASK) >>\
> >>                                                TWL6030_CFG_STATE_APP_SHIFT)
> >>
> >> +/* Flags for DCDC Voltage reading */
> >> +#define DCDC_OFFSET_EN         BIT(0)
> >> +#define DCDC_EXTENDED_EN       BIT(1)
> >> +
> >> +/* twl6025 SMPS EPROM values */
> >> +#define TWL6030_SMPS_OFFSET            0xB0
> >> +#define TWL6030_SMPS_MULT              0xB3
> >> +#define SMPS_MULTOFFSET_SMPS4  BIT(0)
> >> +#define SMPS_MULTOFFSET_VIO    BIT(1)
> >> +#define SMPS_MULTOFFSET_SMPS3  BIT(6)
> >> +
> >>  static inline int
> >>  twlreg_read(struct twlreg_info *info, unsigned slave_subgp, unsigned offset)
> >>  {
> >> @@ -144,11 +161,15 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
> >>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> >>        int                     grp, val;
> >>
> >> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> -       if (grp < 0)
> >> -               return grp;
> >> +       if (!(info->features & TWL6025_SUBCLASS)) {
> >> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> +               if (grp < 0)
> >> +                       return grp;
> >>
> >> -       grp &= P1_GRP_6030;
> >> +               grp &= P1_GRP_6030;
> >> +       } else {
> >> +               grp = 1;
> >> +       }
> >>
> >>        val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
> >>        val = TWL6030_CFG_STATE_APP(val);
> >> @@ -159,19 +180,22 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
> >>  static int twlreg_enable(struct regulator_dev *rdev)
> >>  {
> >>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> >> -       int                     grp;
> >> -       int                     ret;
> >> +       int                     grp = 0;
> >> +       int                     ret = 0;
> >>
> >> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> -       if (grp < 0)
> >> -               return grp;
> >> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS))) {
> >> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> +               if (grp < 0)
> >> +                       return grp;
> >>
> >> -       if (twl_class_is_4030())
> >> -               grp |= P1_GRP_4030;
> >> -       else
> >> -               grp |= P1_GRP_6030;
> >> +               if (twl_class_is_4030())
> >> +                       grp |= P1_GRP_4030;
> >> +               else
> >> +                       grp |= P1_GRP_6030;
> >>
> >> -       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_GRP, grp);
> >> +               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> >> +                                       VREG_GRP, grp);
> >> +       }
> >>
> >>        if (!ret && twl_class_is_6030())
> >>                ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
> >> @@ -186,29 +210,34 @@ static int twlreg_enable(struct regulator_dev *rdev)
> >>  static int twlreg_disable(struct regulator_dev *rdev)
> >>  {
> >>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> >> -       int                     grp;
> >> -       int                     ret;
> >> -
> >> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> -       if (grp < 0)
> >> -               return grp;
> >> -
> >> -       /* For 6030, set the off state for all grps enabled */
> >> -       if (twl_class_is_6030()) {
> >> -               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_STATE,
> >> -                       (grp & (P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030)) <<
> >> -                               TWL6030_CFG_STATE_GRP_SHIFT |
> >> -                       TWL6030_CFG_STATE_OFF);
> >> +       int                     grp = 0;
> >> +       int                     ret = 0;
> >> +
> >> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS))) {
> >> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> +               if (grp < 0)
> >> +                       return grp;
> >> +
> >> +               /* For 6030, set the off state for all grps enabled */
> >> +               if (twl_class_is_6030()) {
> >> +                       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> >> +                                       VREG_STATE,
> >> +                                       (grp & (P1_GRP_6030 | P2_GRP_6030 |
> >> +                                       P3_GRP_6030)) <<
> >> +                                       TWL6030_CFG_STATE_GRP_SHIFT |
> >> +                                       TWL6030_CFG_STATE_OFF);
> >>                if (ret)
> >>                        return ret;
> >> -       }
> >> +               }
> >>
> >> -       if (twl_class_is_4030())
> >> -               grp &= ~(P1_GRP_4030 | P2_GRP_4030 | P3_GRP_4030);
> >> -       else
> >> -               grp &= ~(P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030);
> >> +               if (twl_class_is_4030())
> >> +                       grp &= ~(P1_GRP_4030 | P2_GRP_4030 | P3_GRP_4030);
> >> +               else
> >> +                       grp &= ~(P1_GRP_6030 | P2_GRP_6030 | P3_GRP_6030);
> >>
> >> -       ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER, VREG_GRP, grp);
> >> +               ret = twlreg_write(info, TWL_MODULE_PM_RECEIVER,
> >> +                                       VREG_GRP, grp);
> >> +       }
> >>
> >>        /* Next, associate cleared grp in state register */
> >>        if (!ret && twl_class_is_6030())
> >> @@ -299,10 +328,11 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
> >>  static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
> >>  {
> >>        struct twlreg_info      *info = rdev_get_drvdata(rdev);
> >> -       int grp;
> >> +       int grp = 0;
> >>        int val;
> >>
> >> -       grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >> +       if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
> >> +               grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
> >>
> >>        if (grp < 0)
> >>                return grp;
> >> @@ -594,6 +624,230 @@ static struct regulator_ops twl6030_fixed_resource = {
> >>        .get_status     = twl6030reg_get_status,
> >>  };
> >>
> >> +/*
> >> + * DCDC status and control
> >> + */
> >> +
> > <snip>
> >
> >> +
> >> +static struct regulator_ops twldcdc_ops = {
> >> +       .list_voltage           = twl6030dcdc_list_voltage,
> >> +
> >> +       .set_voltage            = twl6030dcdc_set_voltage,
> >> +       .get_voltage_sel        = twl6030dcdc_get_voltage_sel,
> > These 3 dcdc related function is specific to twl6025, could you please rename it
> >
> I beleive they should be applicable to all twl6030 series regulators.
> The DCDCs are just not currently in use by twl6030 part of the driver. I
> have no hardware to verify funtion here either. But as I beleive they
> are generic for the series Id prefer to keep the name as is.
> 
> >> +
> >> +       .enable                 = twlreg_enable,
> >> +       .disable                = twlreg_disable,
> >> +       .is_enabled             = twl6030reg_is_enabled,
> >> +
> >> +       .set_mode               = twl6030reg_set_mode,
> >> +
> >> +       .get_status             = twl6030reg_get_status,
> > Can you define separate twl6025 specific regulator enable/disable/is_enabled
> > /set_mode and get_status function
> > This can improve readability, reduce the number of if
> > and improves maintainability of previous twl chips
> >
> Word from my discussions with the regulator maintainer on this is he
> would prefer them to remain as they are.

Yeah, if the functionality is the same between twl6030 and twl6025 then
we should not duplicate any code here by adding new functions.

Liam

