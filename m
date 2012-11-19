Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2KSCmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:42:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53336 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2KSCmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:42:21 -0500
Date: Sun, 18 Nov 2012 18:39:09 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com
Subject: Re: [PATCH 5/7] power_supply: Introduce Power Supply charging
 framework
Message-ID: <20121119023909.GA28463@lizard.sbx05977.paloaca.wayport.net>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
 <1350578646-3315-6-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350578646-3315-6-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:14:04PM +0530, Jenny TC wrote:
> The Power Supply charging framework connects multiple subsystems
> to do charging in a generic way. The subsystems involves power_supply,
> extcon, and thermal. With this the charging is handled in a generic way.
[...]
> +void power_supply_trigger_charging_handler(struct power_supply *psy)
> +{
> +	int i;
> +	struct power_supply *psb = NULL;
> +
> +	if (!psy_chrgr.is_cable_evt_reg)
> +		return;
> +
> +	if (is_trigger_charging_algo(psy)) {

if (!is_trigger_charging_algo(psy))
	return;

> +		if (IS_BATTERY(psy)) {
> +			if (trigger_algo(psy))
> +				enable_supplied_by_charging(psy, false);
> +			else
> +				enable_supplied_by_charging(psy, true);
> +
> +		} else if (IS_CHARGER(psy)) {
> +			for (i = 0; i < psy->num_supplicants; i++) {
> +				psb =
> +				    power_supply_get_by_name(psy->
> +							     supplied_to[i]);
> +
> +				if (psb && IS_BATTERY(psb) && IS_PRESENT(psb)) {
> +					if (trigger_algo(psb)) {
> +						disable_charging(psy);
> +						break;
> +					} else if (IS_CHARGING_CAN_BE_ENABLED
> +								(psy)) {
> +						enable_charging(psy);
> +					}
> +				}
> +			}
> +		}
> +
> +	}
> +}
[...]
> @@ -0,0 +1,165 @@
> +#include <linux/power_supply.h>
> +
> +#ifndef __POWER_SUPPLY_CHARGER_H__
> +

No need for this empty line.

> +#define __POWER_SUPPLY_CHARGER_H__
> +
> +struct batt_props {
> +	struct list_head node;
> +	const char *name;
> +	unsigned long voltage_now;
> +	long current_now;
> +	int temperature;
> +	long status;
> +};
> +
> +struct charger_props {
> +	struct list_head node;
> +	const char *name;
> +	bool present;
> +	bool status;
> +	bool online;
> +	unsigned long cable;
> +};
> +
> +struct charging_algo {

I guess it's better to prefix these w/ psy_ or power_.

> +	struct list_head node;
> +	unsigned int chrg_prof_type;
> +	char *name;
> +	int (*get_next_cc_cv)(struct batt_props, struct ps_batt_chg_prof,
> +				unsigned long *cc, unsigned long *cv);
> +};
> +
> +extern int power_supply_register_charging_algo(struct charging_algo *);
> +extern int power_supply_unregister_charging_algo(struct charging_algo *);
> +
> +static inline int set_ps_int_property(struct power_supply *psy,
> +				      enum power_supply_property psp,
> +				      int prop_val)
> +{
> +
> +	union power_supply_propval val;
> +
> +	val.intval = prop_val;
> +	return psy->set_property(psy, psp, &val);
> +}
> +
> +static inline int get_ps_int_property(struct power_supply *psy,
> +				      enum power_supply_property psp)
> +{
> +	union power_supply_propval val;
> +
> +	psy->get_property(psy, psp, &val);
> +	return val.intval;
> +}
> +
> +#define enable_charging(psy) \
> +		({if ((CABLE_TYPE(psy) != POWER_SUPPLY_CHARGER_TYPE_NONE) &&\
> +			!IS_CHARGING_ENABLED(psy)) \
> +		set_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGING,\
> +					true);\
> +		enable_charger(psy); })
> +#define disable_charging(psy) \
> +		({if ((CABLE_TYPE(psy) != POWER_SUPPLY_CHARGER_TYPE_NONE) &&\
> +				IS_CHARGING_ENABLED(psy)) \
> +		set_ps_int_property(psy,\
> +				POWER_SUPPLY_PROP_ENABLE_CHARGING, false); })
> +
> +#define enable_charger(psy) \
> +		set_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGER, true)
> +#define disable_charger(psy) \
> +		set_ps_int_property(psy,\
> +				POWER_SUPPLY_PROP_ENABLE_CHARGER, false)
> +
> +#define set_cc(psy, cc) \
> +		set_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_CURRENT, cc)
> +
> +#define set_cv(psy, cv) \
> +		set_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_VOLTAGE, cv)
> +
> +#define set_inlmt(psy, inlmt) \
> +		set_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT, inlmt)
> +#define SET_MAX_CC(psy, max_cc) \
> +		set_ps_int_property(psy,\
> +				POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT, max_cc)
> +#define switch_cable(psy, new_cable) \
> +		set_ps_int_property(psy,\
> +				POWER_SUPPLY_PROP_CABLE_TYPE, new_cable)
> +
> +#define CV(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_VOLTAGE)
> +#define CC(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_CURRENT)
> +#define INLMT(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT)
> +#define MAX_CC(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT)
> +#define MAX_CV(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_MAX_CHARGE_VOLTAGE)
> +#define VOLTAGE_NOW(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
> +#define CURRENT_NOW(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
> +#define STATUS(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
> +#define TEMPERATURE(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
> +#define BATTERY_TYPE(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
> +#define PRIORITY(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_PRIORITY)
> +#define CABLE_TYPE(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_CABLE_TYPE)
> +
> +#define IS_CHARGING_ENABLED(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGING)
> +#define IS_CHARGER_ENABLED(psy) \
> +		get_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGER)
> +#define IS_BATTERY(psy) (psy->type == POWER_SUPPLY_TYPE_BATTERY)
> +#define IS_CHARGER(psy) (psy->type == POWER_SUPPLY_TYPE_USB ||\
> +				psy->type == POWER_SUPPLY_TYPE_USB_CDP || \
> +			psy->type == POWER_SUPPLY_TYPE_USB_DCP ||\
> +			psy->type == POWER_SUPPLY_TYPE_USB_ACA)

I like these helpers. Don't hesitate to introduce them as much as you
like, they are useful and make the code more readable.

But can we make them generic and static inlines? Otherwise the helpers
themselves are not very readable. :)

static bool psy_is_charger(struct power_supply *psy)
{
	return ....
}

It's more lines of code, but the code is human-readable and maintainable.

And place them into include/linux/power_supply.h.

> +#define IS_ONLINE(psy) \
> +		(get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE) == 1)
> +#define IS_PRESENT(psy) \
> +		(get_ps_int_property(psy, POWER_SUPPLY_PROP_PRESENT) == 1)
> +#define IS_SUPPORTED_CABLE(psy, cable_type) \
> +		(psy->supported_cables & cable_type)
> +#define IS_CABLE_ACTIVE(status) \
> +	((status != EXTCON_CHRGR_CABLE_DISCONNECTED) ||\
> +			(status != EXTCON_CHRGR_CABLE_SUSPENDED))
> +
> +#define IS_CHARGER_PROP_CHANGED(prop, cache_prop)\
> +	((cache_prop.online != prop.online) || \
> +	(cache_prop.present != prop.present))
> +
> +#define IS_BAT_PROP_CHANGED(bat_prop, bat_cache)\
> +	((bat_cache.voltage_now != bat_prop.voltage_now) || \
> +	(bat_cache.current_now != bat_prop.current_now) || \
> +	(bat_cache.temperature != bat_prop.temperature))
> +
> +#define THROTTLE_ACTION(psy, state)\
> +		(((psy->throttle_states)+state)->throttle_action)
> +
> +#define MAX_THROTTLE_STATE(psy)\
> +		(get_ps_int_property(psy,\
> +			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX))
> +
> +#define CURRENT_THROTTLE_STATE(psy)\
> +		(get_ps_int_property(psy,\
> +			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT))
> +
> +#define CURRENT_THROTTLE_ACTION(psy)\
> +		THROTTLE_ACTION(psy, CURRENT_THROTTLE_STATE(psy))
> +
> +#define THROTTLE_CC_VALUE(psy, state)\
> +		(((psy->throttle_states)+state)->throttle_val)
> +
> +#define IS_CHARGING_CAN_BE_ENABLED(psy) \
> +	((CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGER)  &&\
> +	(CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGING))
> +#define IS_CHARGER_CAN_BE_ENABLED(psy) \
> +	(CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGER)
> +
> +#endif
> -- 
> 1.7.9.5
