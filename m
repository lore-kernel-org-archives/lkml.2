Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1GOCec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:34:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49819 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753683Ab1GOCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:34:30 -0400
Date: Fri, 15 Jul 2011 09:57:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v1 04/11]Power: DA9052 battery driver
Message-ID: <20110715005749.GA2760@opensource.wolfsonmicro.com>
References: <1310633828.284.88.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310633828.284.88.camel@L-0532.kpit.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:27:08PM +0530, ashishj3 wrote:

> +static inline int volt_reg_to_mV(int value)
> +		{ return ((value*1000) / 512) + 2500; }
> +static inline int ichg_reg_to_mA(int value)
> +		{ return ((value * 3900) / 1000); }

It'd be better to use the standard coding style for this stuff.

> +static int da9052_battery_read_temperature(struct da9052_battery *battery,
> +					    int *bat_temp)
> +{
> +	int count, avg_value[DA9052_AVERAGE_SIZE];
> +
> +	for (count = 0; count < DA9052_AVERAGE_SIZE; count++)
> +		avg_value[count] = da9052_adc_temperature_read(battery->da9052);
> +		if (avg_value[count] < 0)
> +			return avg_value[count];
> +
> +	*bat_temp = da9052_average_calcuation(avg_value);
> +
> +	return 0;
> +}

Don't do this, just return the reading let something higher up the stack
figure out if it needs to take an average reading.  Probably userspace.
This isn't specific to this device, if we need to do something in the
kernel it should be a core feature but I'd expect userspace can do a
better job by looking at longer term trends.

> +static struct power_supply template_battery = {
> +	.name		= "da9052-bat",
> +	.type		= POWER_SUPPLY_TYPE_BATTERY,
> +	.properties	= da9052_bat_props,
> +	.num_properties	= ARRAY_SIZE(da9052_bat_props),
> +	.get_property	= da9052_bat_get_property,
> +	.use_for_apm	= 1,
> +};

Hrm, use_for_apm isn't typically set by embedded battery drivers so
probably shouldn't be set by this one.  We should figure out some better
way to set this, perhaps board specific, if it's needed.
