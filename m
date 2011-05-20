Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab1ETOtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:49:24 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35382 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab1ETOtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <1305743570-12074-2-git-send-email-gg@slimlogic.co.uk>
References: <1305743570-12074-1-git-send-email-gg@slimlogic.co.uk>
	<1305743570-12074-2-git-send-email-gg@slimlogic.co.uk>
Date: Fri, 20 May 2011 20:19:21 +0530
Message-ID: <BANLkTi=jccSDyG9R2pESN9XCwnViLh5tpg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] REGULATOR: TWL6025: add support to twl-regulator
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, linux@slimlogic.co.uk, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 12:02 AM, Graeme Gregory <gg@slimlogic.co.uk> wrote:
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
> Since V2
>
> twl6025 doesn't use remap so remove it from the macros.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/regulator/twl-regulator.c |  410 +++++++++++++++++++++++++++++++++---
>  1 files changed, 375 insertions(+), 35 deletions(-)
>

<snip>

> +
> +static int twl6030dcdc_list_voltage(struct regulator_dev *rdev, unsigned index)
> +{
> +       struct twlreg_info      *info = rdev_get_drvdata(rdev);
> +
> +       int voltage = 0;
> +
> +       switch (info->flags) {
> +       case 0:
> +               switch (index) {
> +               case 0:
> +                       voltage = 0;
> +                       break;
> +               case 58:

Not sure if hex 0x3A is better here, TRM gives in binary though.

> +                       voltage = 1350 * 1000;
> +                       break;
> +               case 59:
> +                       voltage = 1500 * 1000;
> +                       break;
> +               case 60:
> +                       voltage = 1800 * 1000;
> +                       break;
> +               case 61:
> +                       voltage = 1900 * 1000;
> +                       break;
> +               case 62:
> +                       voltage = 2100 * 1000;
> +                       break;
> +               default:
> +                       voltage = (600000 + (12500 * (index - 1)));
> +               }
> +               break;
> +       case DCDC_OFFSET_EN:
> +               switch (index) {
> +               case 0:
> +                       voltage = 0;
> +                       break;
> +               case 58:
> +                       voltage = 1350 * 1000;
> +                       break;
> +               case 59:
> +                       voltage = 1500 * 1000;
> +                       break;
> +               case 60:
> +                       voltage = 1800 * 1000;
> +                       break;
> +               case 61:
> +                       voltage = 1900 * 1000;
> +                       break;
> +               case 62:
> +                       voltage = 2100 * 1000;
> +                       break;
> +               default:
> +                       voltage = (700000 + (12500 * (index - 1)));

Between DCDC_OFFSET_EN and case 0
700000 and 600000 is the only difference,
can it be handled via additional 100000 in case DCDC_OFFSET_EN?
like
+	case DCDC_OFFSET_EN:
	voltage = 100000;
	/* fall through */
+	case 0:
	voltage += (600000 + (12500 * (index - 1)));

> +               }
> +               break;
> +       case DCDC_EXTENDED_EN:
> +               switch (index) {
> +               case 0:
> +                       voltage = 0;
> +                       break;
> +               case 58:
> +                       voltage = 2084 * 1000;
> +                       break;
> +               case 59:
> +                       voltage = 2315 * 1000;
> +                       break;
> +               case 60:
> +                       voltage = 2778 * 1000;
> +                       break;
> +               case 61:
> +                       voltage = 2932 * 1000;
> +                       break;
> +               case 62:
> +                       voltage = 3241 * 1000;
> +                       break;
> +               default:
> +                       voltage = (1852000 + (38600 * (index - 1)));
> +               }
> +               break;
> +       case DCDC_OFFSET_EN|DCDC_EXTENDED_EN:

space between |

> +               switch (index) {

> +
> +static int
> +twl6030dcdc_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
> +                       unsigned int *selector)
> +{
> +       struct twlreg_info      *info = rdev_get_drvdata(rdev);
> +       int     vsel = 0;
> +
> +       switch (info->flags) {
> +       case 0:
> +               if (min_uV == 0)
> +                       vsel = 0;
> +               else if ((min_uV >= 600000) && (max_uV <= 1300000)) {
> +                       vsel = (min_uV - 600000) / 125;
> +                       if (vsel % 100)
> +                               vsel += 100;
> +                       vsel /= 100;
> +                       vsel++;
> +               }
> +               /* Values 1..57 for vsel are linear and can be calculated
> +                * values 58..62 are non linear.
> +                */
> +               else if ((min_uV > 1900000) && (max_uV >= 2100000))
> +                       vsel = 62;
> +               else if ((min_uV > 1800000) && (max_uV >= 1900000))
> +                       vsel = 61;
> +               else if ((min_uV > 1500000) && (max_uV >= 1800000))
> +                       vsel = 60;
> +               else if ((min_uV > 1350000) && (max_uV >= 1500000))
> +                       vsel = 59;
> +               else if ((min_uV > 1300000) && (max_uV >= 1350000))
> +                       vsel = 58;
> +               else
> +                       return -EINVAL;
> +               break;
> +       case DCDC_OFFSET_EN:
> +               if (min_uV == 0)
> +                       vsel = 0;
> +               else if ((min_uV >= 700000) && (max_uV <= 1420000)) {
> +                       vsel = (min_uV - 600000) / 125;

s/600000/700000 ?

> +                       if (vsel % 100)
> +                               vsel += 100;
> +                       vsel /= 100;
> +                       vsel++;
> +               }

> +static struct regulator_ops twldcdc_ops = {
> +       .list_voltage           = twl6030dcdc_list_voltage,
> +
> +       .set_voltage            = twl6030dcdc_set_voltage,
> +       .get_voltage_sel        = twl6030dcdc_get_voltage_sel,

In 6030 TRM, dcdc is mentioned as SMPS
Is it different it in 6025 TRM?
