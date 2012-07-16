Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2GPIXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:23:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45081 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GPIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:23:21 -0400
Date: Mon, 16 Jul 2012 01:21:20 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Added support for power supply attribute
 sources
Message-ID: <20120716082119.GA26238@lizard>
References: <1340627842-31908-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340627842-31908-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ramakrishna,

On Mon, Jun 25, 2012 at 06:07:22PM +0530, Ramakrishna Pallala wrote:
> On some platforms one driver(or HW chip) may not be able to provide all
> the necessary attributes of the power supply connected to the platform or
> may provide very limited info which can be used by core/primary drivers.
> 
> For example a temperature sensor chip placed near the battery can be used
> to report battery ambient temperature but it does not makes sense to register
> sensor driver with power supply class. Or even a ADC driver or platform
> driver may report power supply properties like voltage/current or charging
> status but registering all those driver with power supply class is not a
> practical or ideal approach.
> 
> This patch adds the generic support to register the drivers as power
> supply attribute(properties) sources and adds an interface to read
> these attributes from power supply class drivers.

So, you would add power_supply_attributes_register() calls into ADC
drivers? This is not right.

The right approach would be to write a power supply driver that would
accept ADC device/channel (or just a callback) for getting needed
information to report.

I.e.

/*
 * Here I just made up adc_channel struct for simplicity of the
 * example; For real ADC dev, you really want to use Industrial IO
 * framework, i.e. include/linux/iio/iio.h.
 */
struct adc_channel {
	...
	int (*get_value)(struct *adc_channel);
};

struct adc_power_supply_platform_data {
	struct adc_channel *voltage;
	struct adc_channel *current;
};

And the "adc power supply" driver would then call:

...
case POWER_SUPPLY_PROP_CURRENT:
	prop->intval = voltage->get_value(voltage);
...

Sure, sometimes it's not only ADC, but sensors, regulators
and so forth. So pass all the devices to the power_supply driver,
and teach the driver to work with the facilities.

As an example of such a platform driver, see drivers/power/pda_power.c.
It is a generic driver for platforms with two power sources (AC/USB),
optinally connected to a battery.

[..]
> +struct power_supply_attr_query {
> +	enum power_supply_property property;
> +	enum power_supply_type type;
> +	/* variable to store result */
> +	union power_supply_propval res;
> +};
[...]
> +extern int power_supply_get_external_attr(
> +				struct power_supply_attr_query *query);

And even if we'd consider adding this feature, the interface seems
very limited. What if there are two, say, batteries?

I don't think it's the right approach, sorry.

Kind regards,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
