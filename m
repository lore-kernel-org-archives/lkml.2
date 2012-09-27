Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2I0DcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:32:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37415 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2I0DcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:32:17 -0400
Date: Wed, 26 Sep 2012 20:29:24 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 11/57] power: Recharge condition not optimal for battery
Message-ID: <20120927032924.GF8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-12-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-12-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:08AM -0600, mathieu.poirier@linaro.org wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> Today the battery recharge is determined with a voltage threshold. This
> voltage threshold is only valid when the battery is relaxed. In charging
> algorithm the voltage read is the loaded battery voltage and no
> compensation is done to get the relaxed voltage. When maintenance
> charging is not selected, this makes the recharging condition to almost
> immediately activate when there is a discharge present on the battery.
> 
> Depending on which vendor the battery comes from this behavior can wear
> out the battery much faster than normal.
> 
> The fuelgauge driver is responsible to monitor the actual battery
> capacity and is able to estimate the remaining capacity. It is better to
> use the remaining capacity as a limit to determine when battery should
> be recharged.
> 
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
[...]
> @@ -2092,6 +2212,9 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
>  						break;
>  					di->flags.charging = false;
>  					di->flags.fully_charged = false;
> +					if (di->bat->capacity_scaling)
> +						ab8500_fg_update_cap_scalers
> +									(di);

The fact that you need to wrap lines in this strange way is just an
evidence that this function needs some refactorings to lower indentation
level.

[...]
> +		} else {
> +			/* Maintenance A */
> +			if (di->maint_state == MAINT_A &&
> +					di->batt_data.volt <
> +					di->bat->bat_type[di->bat->batt_id].
> +					maint_a_vol_lvl) {
> +				abx500_chargalg_state_to(di,
> +						STATE_MAINTENANCE_A_INIT);
> +			}
> +			/* Maintenance B */
> +			else if (di->maint_state == MAINT_B &&
> +					di->batt_data.volt <
> +					di->bat->bat_type[di->bat->batt_id].
> +					maint_b_vol_lvl)  {
> +				abx500_chargalg_state_to(di,
> +						STATE_MAINTENANCE_B_INIT);
> +			}

I understand that the logic is complex, but things are really really
unreadable and incomprehensible.

Can we make it more nicer by putting some love into the code:

struct something_bat *bat = di->bat;
int maint_a_volt = bat->bat_type[bat->batt_id].maint_a_vol_lvl;
int maint_b_volt = bat->bat_type[bat->batt_id].maint_b_vol_lvl;
int cur_volt = di->batt_data.volt;
bool maint_a = di->maint_state == MAINT_A;
bool maint_b = di->maint_state == MAINT_B;
int state;

if (maint_a && cur_volt < maint_a_volt)
	state = STATE_MAINTENANCE_A_INIT;
else if (maint_b && cur_volt < main_b_volt)
	state = STATE_MAINTENANCE_B_INIT;
else
	break;

abx500_chargalg_state_to(di, state);

(And this is across all the driver...)

At least this way I can actually understand what it does (and without
comments).

I'm OK with a patch on top of this series (since rebasing the whole thing
on top of the changed code would probably create tons of conflicts), but
something has to be done with this.

Thanks,
Anton.
