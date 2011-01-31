Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1AaSNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:13:34 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51473 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab1AaSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:13:32 -0500
Message-ID: <4D46FC2A.6010402@metafoo.de>
Date: Mon, 31 Jan 2011 19:15:06 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Some fixes
References: <20110131135417.GC3883@oksana.dev.rtsoft.ru>
In-Reply-To: <20110131135417.GC3883@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 02:54 PM, Anton Vorontsov wrote:
> The same is for this patch.
> 
> Comments, Reviewed-by or Acked-by?
> 
> p.s. FWIW, I already asked Pali to factor out bq27x00_battery_time()
>      fix to a separate patch.
> 

Hi

I have a larger series pending which adds support for the bq27000 chip and polling to
the bq27x00 driver. Since this series does some refactoring of the bq27x00 driver, it
might make sense to rebase this (and the other) patch ontop of that series instead of
the other way around.

I'll try to send it in later today or tomorrow. For now you can take a look at it at
http://git.metafoo.de/?p=linux-2.6;a=shortlog;h=refs/heads/bq27x00-for-upstream

- Lars

> ----- Forwarded message from Pali Rohár <pali.rohar@gmail.com> -----
> 
> Date: Wed, 26 Jan 2011 21:42:39 +0100
> From: Pali Rohár <pali.rohar@gmail.com>
> To: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Subject: Re: [PATCH] bq27x00_battery
> 
> This patch fix reporting correct (devided by resistor sense) values on
> bq27000/bq27200 batteries.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> 
> --- a/drivers/power/bq27x00_battery.c	2011-01-26 21:30:40.000000000 +0100
> +++ b/drivers/power/bq27x00_battery.c	2011-01-26 21:32:34.000000000 +0100
> @@ -37,10 +37,11 @@
>  #define BQ27x00_REG_TTF			0x18
>  #define BQ27x00_REG_TTECP		0x26
> 
> +#define BQ27000_RS			20 /* Resistor sense */
>  #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
>  #define BQ27000_FLAG_CHGS		BIT(7)
> 
> -#define BQ27500_REG_SOC			0x2c
> +#define BQ27500_REG_SOC			0x2C
>  #define BQ27500_FLAG_DSC		BIT(0)
>  #define BQ27500_FLAG_FC			BIT(9)
> 
> @@ -112,7 +113,7 @@ static int bq27x00_battery_temperature(s
>  }
> 
>  /*
> - * Return the battery Voltage in milivolts
> + * Return the battery Voltage in µV
>   * Or < 0 if something fails.
>   */
>  static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
> @@ -130,7 +131,7 @@ static int bq27x00_battery_voltage(struc
>  }
> 
>  /*
> - * Return the battery average current
> + * Return the battery average current in µA
>   * Note that current can be negative signed as well
>   * Or 0 if something fails.
>   */
> @@ -149,6 +150,7 @@ static int bq27x00_battery_current(struc
>  	if (di->chip == BQ27500) {
>  		/* bq27500 returns signed value */
>  		curr = (int)(s16)curr;
> +		curr *= 1000;
>  	} else {
>  		ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
>  		if (ret < 0) {
> @@ -159,9 +161,10 @@ static int bq27x00_battery_current(struc
>  			dev_dbg(di->dev, "negative current!\n");
>  			curr = -curr;
>  		}
> +		curr = curr * 3570 / BQ27000_RS;
>  	}
> 
> -	return curr * 1000;
> +	return curr;
>  }
> 
>  /*
> @@ -233,7 +236,7 @@ static int bq27x00_battery_time(struct b
>  	}
> 
>  	if (tval == 65535)
> -		return -ENODATA;
> +		tval = 0;
> 
>  	val->intval = tval * 60;
>  	return 0;
> 
> ----- End forwarded message -----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
