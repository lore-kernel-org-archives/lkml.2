Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1HZXLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:11:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51549 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1HZXLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <BD051D7C-AD4E-480D-A04D-5BCFC2EFAF69@marvell.com>
References: <BD051D7C-AD4E-480D-A04D-5BCFC2EFAF69@marvell.com>
Date: Sat, 27 Aug 2011 07:11:42 +0800
Message-ID: <CAN1soZxYu8M_i8zFET0k_6KTVumNSxMGWL2Yp7NFd05f_oSw9g@mail.gmail.com>
Subject: Re: [PATCH] power: max8925_power: Fix incorrect voltage and current calculation
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Philip Rakity <prakity@marvell.com>, David Woodhouse <dwmw2@infradead.org>,
        cbou@mail.ru
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 4:28 AM, Philip Rakity <prakity@marvell.com> wrote:
>
> The datasheet indicates a 12 bit value is returned for i2c
> registers for voltage and current.  Code was assuming 8 bits.
> But default for chip is 12 bit return value.
>
> Voltage is returned in 2mV units  -- adjust to return as uV
> per linux power spec
>
> Adjust current calculation to return units in uA
> *** NOT POSSIBLE TO VALIDATE THIS since my h/w does not have
> current hooked up to 8925 *****
>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---
>  drivers/power/max8925_power.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> index 29b5d2c..5e4e046 100644
> --- a/drivers/power/max8925_power.c
> +++ b/drivers/power/max8925_power.c
> @@ -190,7 +190,7 @@ static int start_measure(struct max8925_power_info *info, int type)
>        }
>
>        max8925_bulk_read(info->adc, meas_reg, 2, buf);
> -       ret = (buf[0] << 4) | (buf[1] >> 4);
> +       ret = ((buf[0]<<8) | buf[1]) >> 4;
>
>        return ret;
>  }
> @@ -210,7 +210,7 @@ static int max8925_ac_get_prop(struct power_supply *psy,
>                if (info->ac_online) {
>                        ret = start_measure(info, MEASURE_VCHG);
>                        if (ret >= 0) {
> -                               val->intval = ret << 1; /* unit is mV */
> +                               val->intval = ret * 2000;       /* unit is uV */
>                                goto out;
>                        }
>                }
> @@ -244,7 +244,7 @@ static int max8925_usb_get_prop(struct power_supply *psy,
>                if (info->usb_online) {
>                        ret = start_measure(info, MEASURE_VCHG);
>                        if (ret >= 0) {
> -                               val->intval = ret << 1; /* unit is mV */
> +                               val->intval = ret * 2000;       /* unit is uV */
>                                goto out;
>                        }
>                }
> @@ -268,7 +268,6 @@ static int max8925_bat_get_prop(struct power_supply *psy,
>                                union power_supply_propval *val)
>  {
>        struct max8925_power_info *info = dev_get_drvdata(psy->dev->parent);
> -       long long int tmp = 0;
>        int ret = 0;
>
>        switch (psp) {
> @@ -279,7 +278,7 @@ static int max8925_bat_get_prop(struct power_supply *psy,
>                if (info->bat_online) {
>                        ret = start_measure(info, MEASURE_VMBATT);
>                        if (ret >= 0) {
> -                               val->intval = ret << 1; /* unit is mV */
> +                               val->intval = ret * 2000;       /* unit is uV */
>                                ret = 0;
>                                break;
>                        }
> @@ -290,8 +289,8 @@ static int max8925_bat_get_prop(struct power_supply *psy,
>                if (info->bat_online) {
>                        ret = start_measure(info, MEASURE_ISNS);
>                        if (ret >= 0) {
> -                               tmp = (long long int)ret * 6250 / 4096 - 3125;
> -                               ret = (int)tmp;
> +                               /* assume r_sns is 0.02 */
> +                               ret = ((ret * 6250) - 3125) /* uA */;
>                                val->intval = 0;
>                                if (ret > 0)
>                                        val->intval = ret; /* unit is mA */
> --
> 1.7.6
>

Loop maintainer
