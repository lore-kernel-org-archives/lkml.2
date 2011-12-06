Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1LFLbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:31:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LFLbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:31:32 -0500
Date: Tue, 6 Dec 2011 11:31:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pali Roh??r <pali.rohar@gmail.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] mfd: add bq2415x charger driver
Message-ID: <20111206113131.GE17194@sirena.org.uk>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com>
X-Cookie: Garbage In, Gospel Out
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 12:35:41AM +0200, Felipe Contreras wrote:

> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -925,6 +925,9 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
>  		I2C_BOARD_INFO("bq27200", 0x55),
>  	},
>  #endif
> +	{
> +		I2C_BOARD_INFO("bq24150", 0x6b),
> +	},

Clearly this is orthogonal.

> +static inline int bq2415x_i2c_read(struct i2c_client *cli, u8 reg)
> +{
> +	return i2c_smbus_read_byte_data(cli, reg);
> +}
> +
> +static inline int bq2415x_i2c_write(struct i2c_client *cli, u8 reg, u8 val)
> +{
> +	return i2c_smbus_write_byte_data(cli, reg, val);
> +}

regmap might be useful here (it's got an update bits operation and
cache).

> +static int bq2415x_set_current_limit(struct i2c_client *cli,
> +		int min_uA, int max_uA)
> +{
> +	int res;
> +
> +	res = bq2415x_i2c_read(cli, BQ2415X_GEN_CTL);
> +	if (res < 0)
> +		return res;
> +
> +	res &= ~BQ2415X_IIN_LIMIT_UNLIM_MASK;
> +
> +	if (min_uA >= BQ2415X_IIN_LIMIT_100 && max_uA < BQ2415X_IIN_LIMIT_500)
> +		;
> +	else if (min_uA >= BQ2415X_IIN_LIMIT_500 && max_uA < BQ2415X_IIN_LIMIT_800)
> +		res |= BQ2415X_IIN_LIMIT_500_MASK;
> +	else if (min_uA >= BQ2415X_IIN_LIMIT_800 && max_uA < BQ2415X_IIN_LIMIT_UNLIM)
> +		res |= BQ2415X_IIN_LIMIT_800_MASK;
> +	else if (min_uA >= BQ2415X_IIN_LIMIT_UNLIM)
> +		res |= BQ2415X_IIN_LIMIT_UNLIM_MASK;
> +	else
> +		return -EINVAL;
> +
> +	return bq2415x_i2c_write(cli, BQ2415X_GEN_CTL, res);
> +}

This is the sort of stuff that people were pushing through the regulator
API (and you have cloned the interface...) in order to allow a separate
bit of code to pick the current limits.  At the minute it looks like
you're hard coding the settings, the regulator API would at least let
you punt those to machines with fixed configurations and provides a hook
for anything which does want to play with the configuration at runtime.
Don't know if there's a better API, but it does seem like this is a
general thing for chargers and should therefore go through a generic
API.

On the other hand if you just set limits and let the charger get on with
its thing and run autonomously starting, stopping and fast charging by
itself then a power supply driver seems like a good fit - just provide
the upper limits as platform data or something and watch it go.

Either way it doesn't really seem like this device has multiple
functions...
