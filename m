Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1B1NS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:18:59 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46680 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab1B1NS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:18:58 -0500
Message-ID: <4D6BA118.9090304@metafoo.de>
Date: Mon, 28 Feb 2011 14:20:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>
Subject: Re: [PATCH] bq27x00: New property POWER_SUPPLY_PROP_CURRENT_MAX
References: <AANLkTimba0wqefAxwNP+ANiGgpbmHi60tci_8sg=Sdi7@mail.gmail.com>
In-Reply-To: <AANLkTimba0wqefAxwNP+ANiGgpbmHi60tci_8sg=Sdi7@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2011 01:02 PM, Pali Rohár wrote:
> This patch add support for reporting property POWER_SUPPLY_PROP_CURRENT_MAX
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> ---  a/drivers/power/bq27x00_battery.c	2011-02-27 12:14:56.000000000 +0100
> +++  b/drivers/power/bq27x00_battery.c	2011-02-27 12:55:33.000000000 +0100
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
>   * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
>   * Copyright (C) 2010-2011 Lars-Peter Clausen <lars@metafoo.de>
> + * Copyright (C) 2011 Pali Rohár <pali.rohar@gmail.com>
>   *
>   * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
>   *
> @@ -53,11 +54,13 @@
> 
>  #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
>  #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
> +#define BQ27000_REG_IMLC		0x7D /* Initial max load current */
>  #define BQ27000_FLAG_CHGS		BIT(7)
>  #define BQ27000_FLAG_FC			BIT(5)
> 
>  #define BQ27500_REG_SOC			0x2C
>  #define BQ27500_REG_DCAP		0x3C /* Design capacity */
> +#define BQ27500_REG_MLI			0x1E /* Max load current */
>  #define BQ27500_FLAG_DSC		BIT(0)
>  #define BQ27500_FLAG_FC			BIT(9)
> 
> @@ -90,6 +93,7 @@ struct bq27x00_device_info {
> 
>  	struct bq27x00_reg_cache cache;
>  	int charge_design_full;
> +	int current_max;
> 
>  	unsigned long last_update;
>  	struct delayed_work work;
> @@ -106,6 +110,7 @@ static enum power_supply_property bq27x0
>  	POWER_SUPPLY_PROP_PRESENT,
>  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>  	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_MAX,
>  	POWER_SUPPLY_PROP_CAPACITY,
>  	POWER_SUPPLY_PROP_TEMP,
>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
> @@ -220,6 +225,32 @@ static int bq27x00_battery_read_ilmd(str
>  }
> 
>  /*
> + * Return the battery Initial max load current in µA
> + * Or < 0 if something fails.
> + */
> +static int bq27x00_battery_read_imlc(struct bq27x00_device_info *di)
> +{
> +	int imlc;
> +
> +	if (di->chip == BQ27500)
> +		imlc = bq27x00_read(di, BQ27500_REG_MLI, false);
> +	else
> +		imlc = bq27x00_read(di, BQ27000_REG_IMLC, true);
> +

According to the datasheet the MLI register contains an adaptive value which is
averaged each time the battery has been fully charged after previously being
discharged to less then 50%.
The IMLC register holds some preprogrammed value and is used to initialize the
MLI register upon a battery reset.
So with the current implementation you'll get different results for
bq27000/bq27200 and bq27500.

Furthermore I'm not sure if the CURRENT_MAX property actually makes sense in
the context of a battery.
There is no entry for the CURRENT_MAX property in
Documentation/power/power_supply. But according to the commit message of the
commit adding that property I would assume that it is supposed to be used for
chargers to indicate the maximum current that can be drawn from it. (Adding the
author of that commit to Cc).

- Lars

> +	if (imlc < 0) {
> +		dev_err(di->dev, "error reading initial max load current\n");
> +		return imlc;
> +	}
> +
> +	if (di->chip == BQ27500)
> +		imlc *= 1000;
> +	else
> +		imlc = imlc * 457000 / BQ27000_RS;
> +
> +	return imlc;
> +}
> +
> +/*
>   * Return the battery Cycle count total
>   * Or < 0 if something fails.
>   */
> @@ -275,6 +306,10 @@ static void bq27x00_update(struct bq27x0
>  		/* We only have to read charge design full once */
>  		if (di->charge_design_full <= 0)
>  			di->charge_design_full = bq27x00_battery_read_ilmd(di);
> +
> +		/* We only have to read current design max once */
> +		if (di->current_max <= 0)
> +			di->current_max = bq27x00_battery_read_imlc(di);
>  	}
> 
>  	/* Ignore current_now which is a snapshot of the current battery state
> @@ -469,6 +504,9 @@ static int bq27x00_battery_get_property(
>  	case POWER_SUPPLY_PROP_CURRENT_NOW:
>  		ret = bq27x00_battery_current(di, val);
>  		break;
> +	case POWER_SUPPLY_PROP_CURRENT_MAX:
> +		ret = bq27x00_simple_value(di->current_max, val);
> +		break;
>  	case POWER_SUPPLY_PROP_CAPACITY:
>  		ret = bq27x00_simple_value(di->cache.capacity, val);
>  		break;
> 
> 

