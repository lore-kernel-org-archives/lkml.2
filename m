Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1DMMs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:48:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49228 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1DMMs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MslNhjENQA1g1Cubn+tffxRaNj/MWuYkRm4Yq6FwZWStcDA+pI9UihY1zwe5+PnvfM
         UTv2mirG89WnzkZDz4dahAZach2+m3sTJ/FmGocYfz0cGSSqnQhfP1hAXfe1fi5mcIRv
         lSwjywe3Pa8vw4LQuLrAQYgPmz4PLBl+mJrok=
Date: Wed, 13 Apr 2011 16:48:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 4/11] Power: Battery module of DA9052 PMIC driver
Message-ID: <20110413124849.GA7530@oksana.dev.rtsoft.ru>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B61970D@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B61970D@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

Thanks for the driver.

Unfortunately, the patch is tabs/whitespace damaged.

On Wed, Apr 13, 2011 at 05:28:28PM +0530, Ashish Jangam wrote:
[...]
> +static s32 da9052_adc_read_ich(struct da9052 *da9052, u16 *data)
> +{
> +       uint ret = 0;
> +       ret = da9052_reg_read(da9052, DA9052_ICHG_AV_REG);
> +       if (ret < 0)

Hm. ret is uint, which is unsigned. It can't go negative.

> +               return ret;
> +       *data = (u16)ret;
> +       return ret;
> +}
[...]
> +static s32 da9052_adc_read_tbat(struct da9052 *da9052, u16 *data)
> +{
> +       uint ret = 0;

Add an empty line here. Plus, the '= 0' initializer isn't needed.

> +       ret = da9052_reg_read(da9052, DA9052_TBAT_RES_REG);
> +       if (ret < 0)
> +               return ret;

Empty line here.

> +       *data = (u16)ret;
> +       return ret;
> +}
> +
> +s32 da9052_adc_read_vbat(struct da9052 *da9052, u16 *data)
> +{
> +       s32 ret;
> +
> +       ret = da9052_adc_manual_read(da9052, DA9052_ADC_VBAT);
> +       if (ret == -EIO) {
> +               *data = 0;
> +               return ret;
> +       } else {

No need for 'else'.

> +               *data = ret;
> +               return 0;
> +       }
> +       return 0;
> +}
> +
> +static u16 filter_sample(u16 *buffer)
> +{
> +       u8 count;
> +       u16 tempvalue = 0;
> +       u16 ret;
> +
> +       if (buffer == NULL)
> +               return -EINVAL;

You call this function with buffer always allocated on the stack,
so there is no need for '== NULL' check.

> +
> +       for (count = 0; count < DA9052_FILTER_SIZE; count++)
> +               tempvalue = tempvalue + *(buffer + count);

I would really turn the 'count' into 'i'.

> +
> +       ret = tempvalue/DA9052_FILTER_SIZE;
> +       return ret;

return tempvalue/DA9052_FILTER_SIZE;

> +}
> +
> +static s32  da9052_bat_get_battery_temperature(struct da9052_charger_device
> +       *chg_device, u16 *buffer)

One more tab on that line please.

> +{
> +
> +       u8 count;
> +       u16 filterqueue[DA9052_FILTER_SIZE];
> +
> +       for (count = 0; count < DA9052_FILTER_SIZE; count++)
> +               if (da9052_adc_read_tbat(chg_device->da9052,
> +                       &filterqueue[count]))

Please add one more tab here.

> +                       return -EIO;
> +
> +       filterqueue[0] = filter_sample(filterqueue);
> +
> +       chg_device->bat_temp = filterqueue[0];
> +       *buffer = chg_device->bat_temp;
> +       return 0;
> +}
> +
> +static s32  da9052_bat_get_chg_current(struct da9052_charger_device

No need for two spaces.

> +       *chg_device, u16 *buffer)
> +{
> +       if (chg_device->status == POWER_SUPPLY_STATUS_DISCHARGING)
> +               return -EIO;
> +
> +       if (da9052_adc_read_ich(chg_device->da9052, buffer))
> +               return -EIO;
> +
> +       chg_device->chg_current = ichg_reg_to_mA(*buffer);
> +       *buffer = chg_device->chg_current;
> +
> +       return 0;
> +}
> +
> +s32  da9052_bat_get_battery_voltage(struct da9052_charger_device *chg_device,
> +u16 *buffer)

Broken indentation.

> +{
> +       u8 count;
> +       u16 filterqueue[DA9052_FILTER_SIZE];
> +
> +       for (count = 0; count < DA9052_FILTER_SIZE; count++)
> +               if (da9052_adc_read_vbat(chg_device->da9052,
> +                       &filterqueue[count]))
> +                       return -EIO;
> +
> +       filterqueue[0] = filter_sample(filterqueue);
> +
> +       chg_device->bat_voltage = volt_reg_to_mV(filterqueue[0]);
> +       *buffer = chg_device->bat_voltage;
> +       return 0;
> +}
> +
> +static void da9052_bat_status_update(struct da9052_charger_device
> +       *chg_device)
> +{
> +       u16 current_value = 0;

No need for this initializer as you check da9052_bat_get_chg_current()'s
return value.

> +       u16 buffer = 0;

Same here. Plus, shouldn't this be named 'voltage'?

> +       u8 regvalue = 0;

No need for the initializer.

> +       u8 old_status = chg_device->status;
> +       uint ret = 0;

No need for the initializer.

> +
> +       ret = da9052_reg_read(chg_device->da9052, DA9052_STATUS_A_REG);
> +       if (ret < 0)
> +               return;
> +       regvalue = (u8)ret;

No need for this cast.

> +
> +       ret = da9052_reg_read(chg_device->da9052, DA9052_STATUS_B_REG);
> +       if (ret < 0)
> +               return;
> +
> +       if ((regvalue & DA9052_STATUSA_DCINSEL)
> +                               && (regvalue & DA9052_STATUSA_DCINDET))
> +               chg_device->charger_type = DA9052_WALL_CHARGER;
> +       else if ((regvalue & DA9052_STATUSA_VBUSSEL)
> +                               && (regvalue & DA9052_STATUSA_VBUSDET)) {
> +               if (regvalue & DA9052_STATUSA_VDATDET)
> +                       chg_device->charger_type = DA9052_USB_CHARGER;
> +               else
> +                               chg_device->charger_type = DA9052_USB_HUB;
> +       } else {
> +               chg_device->charger_type = DA9052_NOCHARGER;
> +               chg_device->status = POWER_SUPPLY_STATUS_DISCHARGING;
> +       }
> +       if (chg_device->charger_type != DA9052_NOCHARGER) {
> +               if ((ret & DA9052_STATUSB_CHGEND) != 0)  {
> +                       if (da9052_bat_get_chg_current(chg_device,
> +                                                       &current_value))
> +                                       return;
> +                       if (current_value >= chg_device->chg_end_current)
> +                               chg_device->status =
> +                                       POWER_SUPPLY_STATUS_CHARGING;
> +                       else
> +                               chg_device->status =
> +                                       POWER_SUPPLY_STATUS_NOT_CHARGING;
> +               } else

Per coding style, 'else' needs braces here. I.e. should be '} else {'.

> +                       chg_device->status = POWER_SUPPLY_STATUS_CHARGING;
> +
> +               if (POWER_SUPPLY_STATUS_CHARGING == chg_device->status) {
> +                       if (ret != DA9052_STATUSB_CHGPRE) {
> +                               if (da9052_bat_get_battery_voltage(chg_device,
> +                                                               &buffer))
> +                                       return ;
> +                               if (buffer > (chg_device->bat_target_voltage -
> +                                       chg_device->charger_voltage_drop) &&
> +                                       (chg_device->cal_capacity >= 99))
> +                                       chg_device->status =
> +                                               POWER_SUPPLY_STATUS_FULL;
> +                       }
> +               }
> +       }
> +
> +       if (chg_device->illegal)
> +               chg_device->health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +       else if (chg_device->cal_capacity < chg_device->bat_capacity_limit_low)
> +               chg_device->health = POWER_SUPPLY_HEALTH_DEAD;
> +       else
> +               chg_device->health = POWER_SUPPLY_HEALTH_GOOD;
> +
> +       if (chg_device->status != old_status)
> +               power_supply_changed(&chg_device->psy);
> +       return;
> +}
> +
> +static s32 da9052_bat_suspend_charging(struct da9052_charger_device *chg_device)
> +{
> +       uint ret = 0;

No need for the initlizer.

> +
> +       if ((chg_device->status == POWER_SUPPLY_STATUS_DISCHARGING) ||
> +               (chg_device->status == POWER_SUPPLY_STATUS_NOT_CHARGING))

No need for the parenthesis. i.e. if (a == b || c == d).

> +               return 0;
> +
> +       ret = da9052_reg_read(chg_device->da9052, DA9052_INPUT_CONT_REG);

I would rename 'ret' to 'reg'. And would just write

> +       if (ret < 0)
> +               return ret;
> +
> +       ret = (ret | DA9052_INPUT_CONT_DCIN_SUSP);
> +       ret = (ret | DA9052_INPUT_CONT_VBUS_SUSP);

reg |= DA9052_INPUT_CONT_DCIN_SUSP;
reg |= DA9052_INPUT_CONT_VBUS_SUSP;

> +       ret = da9052_reg_write(chg_device->da9052, DA9052_INPUT_CONT_REG, ret);

return da9052_reg_write(chg_device->da9052, DA9052_INPUT_CONT_REG, reg);

> +
> +       return ret;
> +}
> +
> +u32 interpolated(u32 vbat_lower, u32  vbat_upper, u32  level_lower,
> +       u32  level_upper, u32 bat_voltage)

Broken indentation, broken spacing.

> +{
> +       s32 temp;

Empty line here please.

> +       temp = ((level_upper - level_lower) * 1000)/(vbat_upper - vbat_lower);
> +       temp = level_lower + (((bat_voltage - vbat_lower) * temp)/1000);

Spaces around '/'.

> +
> +       return temp;
> +}
> +
> +s32 capture_first_correct_vbat_sample(struct da9052_charger_device *chg_device,
> +u16 *battery_voltage)

Indentation.

> +{
> +       static u8 count;

Huh, static? Why?

> +       s32 ret = 0;

No need for this initializer.

> +       u32 temp_data = 0;

No need for the initializer. Please check all the cases of unneeded
initializer across the driver.

[...]
> +s32 da9052_bat_level_update(struct da9052_charger_device *chg_device)
> +{
> +       u16 bat_temperature;
> +       u16 bat_voltage;
> +       u32 vbat_lower, vbat_upper, level_upper, level_lower, level;

u32 vbat_lower;
u32 vbat_upper;
...

Each on its own line please.

> +       u8 access_index = 0;
> +       u8 index = 0, ret;
> +       u8 flag = 0;
> +
> +       ret = 0;
> +       vbat_lower = 0;
> +       vbat_upper = 0;
> +       level_upper = 0;
> +       level_lower = 0;
> +
> +       ret = check_hystersis(chg_device, &bat_voltage);
> +       if (ret)
> +               return ret;
> +
> +       ret = da9052_bat_get_battery_temperature(chg_device,
> +               &bat_temperature);
> +       if (ret)
> +               return ret;
> +
> +       for (index = 0; index < (DA9052_NO_OF_LOOKUP_TABLE-1); index++) {
> +               if (bat_temperature <= temperature_lookup_ref[0]) {
> +                       access_index = 0;
> +                       break;
> +               } else if (bat_temperature >
> +                       temperature_lookup_ref[DA9052_NO_OF_LOOKUP_TABLE]){

Missing space between ) and {.

> +                               access_index = DA9052_NO_OF_LOOKUP_TABLE - 1;
> +                       break;
> +               } else if ((bat_temperature >= temperature_lookup_ref[index]) &&
> +                       (bat_temperature >= temperature_lookup_ref[index+1])) {

Broken indentation.

> +                       access_index = select_temperature(index,
> +                               bat_temperature);
> +                       break;
> +               }
> +       }
> +       if (bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
> +               chg_device->cal_capacity = 100;
> +               return 0;
> +       }
> +       if (bat_voltage <= vbat_vs_capacity_look_up[access_index]
> +               [DA9052_LOOK_UP_TABLE_SIZE-1][0]){
> +                       chg_device->cal_capacity = 0;
> +                       return 0;
> +       }
> +       flag = 0;
> +
> +       for (index = 0; index < (DA9052_LOOK_UP_TABLE_SIZE-1); index++) {
> +               if ((bat_voltage <=
> +               vbat_vs_capacity_look_up[access_index][index][0]) &&
> +               (bat_voltage >=
> +               vbat_vs_capacity_look_up[access_index][index+1][0])) {
> +                       vbat_upper =
> +                       vbat_vs_capacity_look_up[access_index][index][0];
> +                       vbat_lower =
> +                       vbat_vs_capacity_look_up[access_index][index+1][0];
> +                       level_upper =
> +                       vbat_vs_capacity_look_up[access_index][index][1];
> +                       level_lower =
> +                       vbat_vs_capacity_look_up[access_index][index+1][1];
> +                       flag = 1;
> +                       break;
> +               }
> +       }
> +       if (!flag)
> +               return -EIO;
> +
> +       level = interpolated(vbat_lower, vbat_upper, level_lower,
> +               level_upper, bat_voltage);
> +       chg_device->cal_capacity = level;
> +       return 0;
> +}
> +
> +static irqreturn_t da9052_tbat_irq(int irq, void *data)
> +{
> +       struct da9052_charger_device *chg_device =
> +                                       (struct da9052_charger_device *)data;
> +
> +       chg_device->health = POWER_SUPPLY_HEALTH_OVERHEAT;
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int da9052_bat_get_property(struct power_supply *psy,
> +                               enum power_supply_property psp,
> +                               union power_supply_propval *val)
> +{
> +       struct da9052_charger_device *chg_device =
> +       container_of(psy, struct da9052_charger_device, psy);
> +
> +       if (chg_device->illegal &&  psp != POWER_SUPPLY_PROP_PRESENT)
> +               return -ENODEV;
> +
> +       switch (psp) {
> +       case POWER_SUPPLY_PROP_STATUS:
> +               val->intval = chg_device->status;
> +               break;
> +       case POWER_SUPPLY_PROP_ONLINE:
> +               val->intval =
> +                       (chg_device->charger_type == DA9052_NOCHARGER) ? 0 : 1;

No need for '? 0 : 1'. Just !=.

> +               break;
> +       case POWER_SUPPLY_PROP_PRESENT:
> +               val->intval = chg_device->illegal;
> +               break;
> +       case POWER_SUPPLY_PROP_HEALTH:
> +               val->intval = chg_device->health;
> +               break;
> +       case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
> +               val->intval = chg_device->bat_target_voltage * 1000;
> +               break;
> +       case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
> +               val->intval = chg_device->bat_volt_cutoff * 1000;
> +               break;
> +       case POWER_SUPPLY_PROP_VOLTAGE_AVG:
> +               val->intval = chg_device->bat_voltage * 1000;
> +               break;
> +       case POWER_SUPPLY_PROP_CURRENT_AVG:
> +               val->intval = chg_device->chg_current * 1000;
> +               break;
> +       case POWER_SUPPLY_PROP_CAPACITY:
> +               val->intval = chg_device->cal_capacity;
> +               break;
> +       case POWER_SUPPLY_PROP_TEMP:
> +               val->intval = bat_temp_reg_to_C(chg_device->bat_temp);
> +               break;
> +       case POWER_SUPPLY_PROP_TECHNOLOGY:
> +               val->intval = chg_device->technology;
> +               break;
> +       default:
> +               return -EINVAL;
> +       break;
> +       }
> +       return 0;
> +}
> +
> +
> +static u8 detect_illegal_battery(struct da9052_charger_device *chg_device)
> +{
> +       u16 buffer = 0;
> +       s32  ret = 0;
> +
> +       ret = da9052_bat_get_battery_temperature(chg_device, &buffer);
> +       if (ret)
> +               return ret;
> +
> +       if (buffer > chg_device->bat_with_no_resistor)
> +               chg_device->illegal = 1;
> +       else
> +               chg_device->illegal = 0;
> +
> +       if (chg_device->illegal)
> +               da9052_bat_suspend_charging(chg_device);
> +
> +       return chg_device->illegal;
> +}
> +
> +void da9052_update_bat_properties(struct da9052_charger_device *chg_device)
> +{
> +       da9052_bat_status_update(chg_device);
> +       da9052_bat_level_update(chg_device);
> +}
> +
> +static void da9052_bat_external_power_changed(struct power_supply *psy)
> +{
> +       struct da9052_charger_device *chg_device =
> +       container_of(psy, struct da9052_charger_device, psy);
> +
> +       cancel_delayed_work(&chg_device->monitor_work);
> +       queue_delayed_work(chg_device->monitor_wqueue,
> +                               &chg_device->monitor_work, HZ/10);
> +}
> +
> +static void da9052_bat_work(struct work_struct *work)
> +{
> +       struct da9052_charger_device *chg_device = container_of(work,
> +               struct da9052_charger_device, monitor_work.work);
> +       da9052_update_bat_properties(chg_device);
> +       queue_delayed_work(chg_device->monitor_wqueue,
> +                       &chg_device->monitor_work, HZ * 8);
> +}
> +
> +static enum power_supply_property da9052_bat_props[] = {
> +       POWER_SUPPLY_PROP_STATUS,
> +       POWER_SUPPLY_PROP_ONLINE,
> +       POWER_SUPPLY_PROP_PRESENT,
> +       POWER_SUPPLY_PROP_HEALTH,
> +       POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> +       POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> +       POWER_SUPPLY_PROP_VOLTAGE_AVG,
> +       POWER_SUPPLY_PROP_CURRENT_AVG,
> +       POWER_SUPPLY_PROP_CAPACITY,
> +       POWER_SUPPLY_PROP_TEMP,
> +       POWER_SUPPLY_PROP_TECHNOLOGY,
> +};
> +
> +static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
> +{
> +       struct da9052_charger_device *chg_device;

Instead of the long 'chg_device' I would suggest to use just 'chg' name
in the driver.

> +       uint reg_data = 0;
> +       int ret;
> +
> +       chg_device = kzalloc(sizeof(*chg_device), GFP_KERNEL);
> +       if (!chg_device)
> +               return -ENOMEM;
> +
> +       chg_device->da9052 = dev_get_drvdata(pdev->dev.parent);
> +       chg_device->tbat_irq = platform_get_irq_byname(pdev, "TBAT");
> +
> +       platform_set_drvdata(pdev, chg_device);
> +       chg_device->psy.name                    = "da9052-bat";
> +       chg_device->psy.type                    = POWER_SUPPLY_TYPE_BATTERY;
> +       chg_device->psy.properties              = da9052_bat_props;
> +       chg_device->psy.num_properties          = ARRAY_SIZE(da9052_bat_props);
> +       chg_device->psy.get_property            = da9052_bat_get_property;
> +       chg_device->psy.external_power_changed  =
> +                                       da9052_bat_external_power_changed;
> +       chg_device->psy.use_for_apm             = 1;
> +       chg_device->charger_type                = DA9052_NOCHARGER;
> +       chg_device->status                      = POWER_SUPPLY_STATUS_UNKNOWN;
> +       chg_device->health                      = POWER_SUPPLY_HEALTH_UNKNOWN;
> +       chg_device->technology                  = POWER_SUPPLY_TECHNOLOGY_LION;
> +       chg_device->bat_with_no_resistor        = 62;
> +       chg_device->bat_capacity_limit_low      = 4;
> +       chg_device->bat_capacity_limit_high     = 70;
> +       chg_device->bat_capacity_full           = 100;
> +       chg_device->bat_volt_cutoff             = 2800;
> +       chg_device->vbat_first_valid_detect_iteration = 3;
> +       chg_device->hysteresis_window_size      = 1;
> +       chg_device->chg_hysteresis_const        = 89;
> +       chg_device->hysteresis_reading_interval = 1000;
> +       chg_device->hysteresis_no_of_reading    = 10;
> +
> +       ret = da9052_reg_read(chg_device->da9052, DA9052_CHG_CONT_REG);
> +       if (ret < 0)
> +               goto err_charger_init;
> +       chg_device->charger_voltage_drop = bat_drop_reg_to_mV(ret &&
> +                                                       DA9052_CHG_CONT_TCTR);
> +       chg_device->bat_target_voltage =
> +                       bat_reg_to_mV(ret && DA9052_CHG_CONT_VCHG_BAT);
> +
> +       ret = da9052_reg_read(chg_device->da9052, DA9052_ICHG_END_REG);
> +       if (ret < 0)
> +               goto err_charger_init;
> +       chg_device->chg_end_current = ichg_reg_to_mA(reg_data);
> +
> +       bat_hysteresis.upper_limit      = 0;
> +       bat_hysteresis.lower_limit      = 0;
> +       bat_hysteresis.hys_flag         = 0;
> +       chg_device->illegal             = 0;
> +       detect_illegal_battery(chg_device);
> +
> +       ret =
> +               request_threaded_irq(chg_device->da9052->irq_base

Weird indentation.

> +                                       + chg_device->tbat_irq,
> +                                       NULL, da9052_tbat_irq,
> +                                       IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +                                       "TBAT", chg_device);
> +       if (ret != 0) {

Just 'if (ret)'.

> +               dev_err(chg_device->da9052->dev,
> +                       "Failed to register DA9052 TBAT irq, %d\n", ret);
> +               goto err_charger_init;
> +       }

[...]
> --- linux-2.6.38.2/include/linux/mfd/da9052/bat.h       1970-01-01 05:00:00.000000000 +0500
> +++ wrk_linux-2.6.38.2/include/linux/mfd/da9052/bat.h   2011-04-13 13:26:32.000000000 +0500
> @@ -0,0 +1,227 @@
[...]
[...]
> +static inline  u8 ichg_mA_to_reg(u16 value) { return (value/4); }
> +static inline  u16 ichg_reg_to_mA(u8 value) { return ((value*3900)/1000); }
> +static inline u8 iset_mA_to_reg(u16 iset_value)
> +               {\

As this is function, you don't need \ at the end of the lines.

> +               if ((70 <= iset_value) && (iset_value <= 120)) \
> +                       return (iset_value-70)/10; \
> +               else if ((400 <= iset_value) && (iset_value <= 700)) \
> +                       return ((iset_value-400)/50)+6; \
> +               else if ((900 <= iset_value) && (iset_value <= 1300)) \
> +                       return ((iset_value-900)/200)+13; else return 0;
> +               }
> +
> +#endif /* __LINUX_MFD_DA9052_BAT_H */

Plus, I doubt that you need the header file at all (as you don't
seem to use platform_data). If you really want to split some
definitions from the code, move the header into the drivers/power/.


Bottom line: please shape the driver to strictly conform to the coding
style, get rid of all unneeded code/initializers/casts, be careful with
types, and try make the code readable, i.e. use shorter names for local
variables, i.e. 'i' instead of 'count' or 'index', 'j' instead of
'access_index', 'chg' instead of 'charger_dev', etc.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
