Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1KXX24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:28:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45297 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1KXX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:28:55 -0500
Date: Fri, 25 Nov 2011 03:28:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>
Subject: Re: [PATCH 04/11] Power: DA9052 Battery driver v4
Message-ID: <20111124232849.GA28145@oksana.dev.rtsoft.ru>
References: <1321608249.10344.25.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321608249.10344.25.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:54:09PM +0530, Ashish Jangam wrote:
> Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
> for definitions and methods.
> 
> Tested on Samsung SMDK6410 board with DA9052-BC and DA9053-BA evaluation boards.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---

Ashish,

Much thanks for your work! The code itself looks OK to me. But there are
some issues regarding readability and coding style. No big deal, but
please consider fixing.

[...]

[..]
> +static int da9052_battery_check_status(struct da9052_battery *battery,
> +					int *status)
> +{
> +	uint8_t v[2] = {0, 0};
> +	uint8_t bat_status, chg_end;

In kernel code we try to use 'uXX' types. I.e. u8 here.

> +	int ret, chg_current, chg_end_current;

Each declaration should be on its own line.

int ret;
int chr_current;

> +
> +	ret = da9052_group_read(battery->da9052, DA9052_STATUS_A_REG, 2, v);
> +	if (ret < 0)
> +		return ret;
> +
> +	bat_status = v[0];
> +	chg_end = v[1];
> +
> +	/* Preference to WALL(DCIN) charger unit */
> +	if (((bat_status & DA9052_STATUSA_DCINSEL) &&
> +	     (bat_status & DA9052_STATUSA_DCINDET))
> +	    ||
> +	    ((bat_status & DA9052_STATUSA_VBUSSEL) &&
> +	     (bat_status & DA9052_STATUSA_VBUSDET))
> +	   ) {

I can't parse it.

Maybe

bool dcinsel = bat_status & DA9052_STATUSA_DCINSEL;
bool dcindet = bat_status & DA9052_STATUSA_DCINDET;
bool vbussel = bat_status & DA9052_STATUSA_VBUSSEL;
bool vbusdet = bat_status & DA9052_STATUSA_VBUSDET;
bool dc = dcinsel && dcindet;
bool vbus = vbussel && vbusdet;

if (dc || vbus) {
	...
} else if (dcindet || vbusdet) {
	...
} else {
	...
}

Note that it does not add a single line of code, but things become
much more readable.

> +		battery->charger_type = DA9052_CHARGER;
> +
> +		/* If charging end flag is set and Charging current is greater
> +		 * than charging end limit then battery is charging
> +		*/
> +		if ((chg_end & DA9052_STATUSB_CHGEND) != 0) {
> +			ret = da9052_battery_read_current(battery,
> +							  &chg_current);
> +			if (ret < 0)
> +				return ret;
> +			ret = da9052_battery_read_end_current(battery,
> +							      &chg_end_current);
> +			if (ret < 0)
> +				return ret;
> +
> +			if (chg_current >= chg_end_current)
> +				battery->status = POWER_SUPPLY_STATUS_CHARGING;
> +			else
> +				battery->status =
> +					POWER_SUPPLY_STATUS_NOT_CHARGING;
> +		}
> +		/* If Charging end flag is cleared then battery is charging */
> +		else
> +			battery->status = POWER_SUPPLY_STATUS_CHARGING;
> +	} else if (bat_status & DA9052_STATUSA_DCINDET ||
> +		  bat_status & DA9052_STATUSA_VBUSDET) {
> +			battery->charger_type = DA9052_CHARGER;
> +			battery->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +	} else {
> +		battery->charger_type = DA9052_NOCHARGER;
> +		battery->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +	}
> +
> +	if (status != NULL)
> +		*status = battery->status;
> +	return 0;
> +}

[...]
> +unsigned char select_temperature(unsigned char temp_index, int bat_temperature)
> +{
> +	int temp_temperature;
> +
> +	temp_temperature = (temperature_lookup_ref[temp_index] +
> +			    temperature_lookup_ref[temp_index + 1]) / 2;
> +
> +	if (bat_temperature >= temp_temperature) {
> +		temp_index += 1;
> +		return temp_index;
> +	} else

should be "} else {", per coding style.

> +		return temp_index;
> +}
> +
> +static int da9052_battery_read_capacity(struct da9052_battery *battery,
> +					 int *capacity)
> +{
> +	int bat_temperature, bat_voltage;
> +	int vbat_lower, vbat_upper, level_upper, level_lower;
> +	int ret, flag, index, access_index = 0;
> +
> +	ret = da9052_battery_read_volt(battery, &bat_voltage);
> +	if (ret < 0)
> +		return ret;
> +
> +	bat_temperature = da9052_adc_temperature_read(battery->da9052);
> +	if (bat_temperature < 0)
> +		return bat_temperature;
> +
> +	for (index = 0; index < (DA9052_NO_OF_LOOKUP_TABLE - 1); index++) {
> +		if (bat_temperature <= temperature_lookup_ref[0]) {
> +			access_index = 0;
> +			break;
> +		} else if (bat_temperature >
> +			   temperature_lookup_ref[DA9052_NO_OF_LOOKUP_TABLE]) {
> +				access_index = DA9052_NO_OF_LOOKUP_TABLE - 1;
> +			break;
> +		} else if ((bat_temperature >= temperature_lookup_ref[index]) &&
> +			   (bat_temperature >= temperature_lookup_ref[index + 1]
> +			    )) {

Braces placement is weird. The longer identifiers you use, the less
columns you have. Maybe try to use shorter variable names?

> +				access_index = select_temperature(index,
> +					       bat_temperature);
> +			break;
> +		}
> +	}
> +	if (bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
> +		*capacity = 100;
> +		return 0;
> +	}
> +	if (bat_voltage <= vbat_vs_capacity_look_up[access_index]
> +		[DA9052_LOOK_UP_TABLE_SIZE - 1][0]) {
> +			*capacity = 0;
> +			return 0;
> +	}
> +	flag = 0;
> +
> +	for (index = 0; index < (DA9052_LOOK_UP_TABLE_SIZE-1); index++) {
> +		if ((bat_voltage <=
> +		     vbat_vs_capacity_look_up[access_index][index][0]) &&
> +		    (bat_voltage >=
> +		     vbat_vs_capacity_look_up[access_index][index + 1][0])) {
> +			vbat_upper =
> +			vbat_vs_capacity_look_up[access_index][index][0];
> +			vbat_lower =
> +			vbat_vs_capacity_look_up[access_index][index + 1][0];
> +			level_upper =
> +			vbat_vs_capacity_look_up[access_index][index][1];
> +			level_lower =
> +			vbat_vs_capacity_look_up[access_index][index + 1][1];
> +			flag = 1;
> +			break;

I can't parse it.

You don't have to use 24-character variable name to document your
code. For example, you can rename vbat_vs_capacity_look_up to "vc_tbl"
and just add a comment that the table is used to lookup voltage via
capacity.

s/vbat_vs_capacity_look_up/vc_tbl/g
s/access_index/i/g
s/index/j/g

[...]
> +static irqreturn_t da9052_bat_irq(int irq, void *data)
> +{
> +	struct da9052_battery *battery = (struct da9052_battery *)data;

Needless cast.


Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
