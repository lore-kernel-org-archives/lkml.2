Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0HaNNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:13:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41451 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0HaNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:13:29 -0400
Date: Tue, 31 Aug 2010 14:13:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rklein@nvidia.com
Cc: cbouatmailru@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, achew@nvidia.com
Subject: Re: [PATCH 1/1] power supply: add driver for TI BQ20Z75 gas gauge
	IC
Message-ID: <20100831131323.GA16671@sirena.org.uk>
References: <1282949443-8052-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282949443-8052-1-git-send-email-rklein@nvidia.com>
X-Cookie: Do not exceed recommended dosage.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 03:50:43PM -0700, rklein@nvidia.com wrote:

> +	case POWER_SUPPLY_PROP_STATUS:
> +	case POWER_SUPPLY_PROP_CYCLE_COUNT:
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +	case POWER_SUPPLY_PROP_TEMP:
> +	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
> +	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
> +	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
> +		for (count = 0; count < REG_MAX; count++) {
> +			if (psp == bq20z75_data[count].psp)
> +				break;
> +		}

Rather than using REG_MAX it'd seem safer to use ARRAY_SIZE() to make
sure you're within the array.

> +		if (bq20z75_get_battery_property(count, psp, val))
> +			return -EINVAL;
> +			break;

Indentation is messed up here.

> +	printk(KERN_INFO "%s: property = %d, value = %d\n", __func__,
> +		psp, val->intval);

Remove unconditional logging like this, make it dev_dbg() if you want to
keep it in so it's only visible when explicitly requested.

> +	bq20z75_device = kzalloc(sizeof(*bq20z75_device), GFP_KERNEL);
> +	if (!bq20z75_device)
> +		return -ENOMEM;
> +
> +memset(bq20z75_device, 0, sizeof(*bq20z75_device));

Indentation again.

> +/* any smbus transaction will wake up bq20z75 */
> +static int bq20z75_resume(struct i2c_client *client)
> +{
> +	return 0;
> +}

No need for null functions like this.

> +#if defined CONFIG_PM
> +	.suspend	= bq20z75_suspend,
> +	.resume		= bq20z75_resume,
> +#endif

The standard way to do this is with the suspend/resume functions -
#define them to NULL which turns their assignments into noops.

> +MODULE_AUTHOR("NVIDIA Graphics Pvt Ltd");

This only makes sense if it's an actual person (or other contact
address); there's already copyright statements on the file, the author
information is more there to help find someone who might know something
about the driver.
