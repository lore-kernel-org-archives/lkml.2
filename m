Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2EFD1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 23:27:24 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:42545 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2EFD1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 23:27:23 -0400
Date: Sat, 5 May 2012 20:25:54 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] smb347_charger: cleaned battery power supply attributes
Message-ID: <20120506032554.GG29576@lizard>
References: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 09:33:54PM +0530, Ramakrishna Pallala wrote:
> CURRENT_NOW and VOLTAGE_NOW should be instantaneous readings
> from power supply(ex: battery).
> 
> smb347 charger driver reports charge voltage for VOLTAGE_NOW
> and charge current for CURRENT_NOW attributes which are not
> instantaneous readings.

Em. While charging, I guess charge current == instantaneous battery
current? Should we then report it in such cases? And while discharging
and not charging, assuming that HW can't report the real battery
current flow, we can return some fancy errno code, like ENODATA?

Thanks,

> This patch removes the battery VOLTAGE_NOW and CURRENT_NOW
> properties from the driver and also removes hw_to_current()
> which is not required anymore.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  drivers/power/smb347-charger.c |   49 ----------------------------------------
>  1 files changed, 0 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
> index cf31b31..09d19d2 100644
> --- a/drivers/power/smb347-charger.c
> +++ b/drivers/power/smb347-charger.c
> @@ -195,14 +195,6 @@ static const unsigned int ccc_tbl[] = {
>  	1200000,
>  };
>  
> -/* Convert register value to current using lookup table */
> -static int hw_to_current(const unsigned int *tbl, size_t size, unsigned int val)
> -{
> -	if (val >= size)
> -		return -EINVAL;
> -	return tbl[val];
> -}
> -
>  /* Convert current to register value using lookup table */
>  static int current_to_hw(const unsigned int *tbl, size_t size, unsigned int val)
>  {
> @@ -891,7 +883,6 @@ static int smb347_battery_get_property(struct power_supply *psy,
>  	struct smb347_charger *smb =
>  			container_of(psy, struct smb347_charger, battery);
>  	const struct smb347_charger_platform_data *pdata = smb->pdata;
> -	unsigned int v;
>  	int ret;
>  
>  	ret = smb347_update_ps_status(smb);
> @@ -943,44 +934,6 @@ static int smb347_battery_get_property(struct power_supply *psy,
>  		val->intval = pdata->battery_info.voltage_max_design;
>  		break;
>  
> -	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> -		if (!smb347_is_ps_online(smb))
> -			return -ENODATA;
> -		ret = regmap_read(smb->regmap, STAT_A, &v);
> -		if (ret < 0)
> -			return ret;
> -
> -		v &= STAT_A_FLOAT_VOLTAGE_MASK;
> -		if (v > 0x3d)
> -			v = 0x3d;
> -
> -		val->intval = 3500000 + v * 20000;
> -		break;
> -
> -	case POWER_SUPPLY_PROP_CURRENT_NOW:
> -		if (!smb347_is_ps_online(smb))
> -			return -ENODATA;
> -
> -		ret = regmap_read(smb->regmap, STAT_B, &v);
> -		if (ret < 0)
> -			return ret;
> -
> -		/*
> -		 * The current value is composition of FCC and PCC values
> -		 * and we can detect which table to use from bit 5.
> -		 */
> -		if (v & 0x20) {
> -			val->intval = hw_to_current(fcc_tbl,
> -						    ARRAY_SIZE(fcc_tbl),
> -						    v & 7);
> -		} else {
> -			v >>= 3;
> -			val->intval = hw_to_current(pcc_tbl,
> -						    ARRAY_SIZE(pcc_tbl),
> -						    v & 7);
> -		}
> -		break;
> -
>  	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
>  		val->intval = pdata->battery_info.charge_full_design;
>  		break;
> @@ -1002,8 +955,6 @@ static enum power_supply_property smb347_battery_properties[] = {
>  	POWER_SUPPLY_PROP_TECHNOLOGY,
>  	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>  	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> -	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> -	POWER_SUPPLY_PROP_CURRENT_NOW,
>  	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>  	POWER_SUPPLY_PROP_MODEL_NAME,
>  };
> -- 
> 1.7.0.4

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
