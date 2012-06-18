Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2FRJDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:03:08 -0400
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1067 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755406Ab2FRJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:03:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31504
Message-ID: <4FDEEFA2.1030009@metafoo.de>
Date: Mon, 18 Jun 2012 11:06:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Saranya Gopal <saranya.gopal@intel.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00_battery: Add support for BQ27425 chip
References: <1339999840-12532-1-git-send-email-saranya.gopal@intel.com>
In-Reply-To: <1339999840-12532-1-git-send-email-saranya.gopal@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 08:10 AM, Saranya Gopal wrote:
> This patch adds support for BQ27425 (TI) chip. This
> chip is same as BQ27500 with few registers removed
> and register address map changed. The data sheet for
> this chip is publicly available at
> http://www.ti.com/product/bq27425-g1
> 
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> ---
>  drivers/power/Kconfig           |    7 +++
>  drivers/power/bq27x00_battery.c |   85 +++++++++++++++++++++++++++++---------
>  2 files changed, 72 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index e3a3b49..38f6807 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -157,6 +157,13 @@ config BATTERY_BQ27X00_PLATFORM
>  	help
>  	  Say Y here to enable support for batteries with BQ27000 (HDQ) chips.
>  
> +config BATTERY_BQ27425
> +	bool "BQ27425 support"
> +	depends on BATTERY_BQ27x00
> +	depends on BATTERY_BQ27X00_I2C

There shouldn't be a need for an additional Kconfig entry.

> +	help
> +	  Say Y here to enable support for batteries with BQ27425 (I2C) chip.
> +
>  config BATTERY_DA9030
>  	tristate "DA9030 battery driver"
>  	depends on PMIC_DA903X
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index f5d6d37..d22e415 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -22,6 +22,7 @@
>   * Datasheets:
>   * http://focus.ti.com/docs/prod/folders/print/bq27000.html
>   * http://focus.ti.com/docs/prod/folders/print/bq27500.html
> + * http://www.ti.com/product/bq27425-g1
>   */
>  
>  #include <linux/module.h>
> @@ -67,6 +68,14 @@
>  #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
>  #define BQ27500_FLAG_FC			BIT(9)
>  
> +#define BQ27425_REG_TEMP		0x02
> +#define BQ27425_REG_VOLT		0x04
> +#define BQ27425_REG_FLAGS		0x06
> +#define BQ27425_REG_NAC			0x08
> +#define BQ27425_REG_FCC			0x0E
> +#define BQ27425_REG_AI			0x10
> +#define BQ27425_REG_SOC			0x1C
> +
>  #define BQ27000_RS			20 /* Resistor sense */
>  
>  struct bq27x00_device_info;
> @@ -74,7 +83,7 @@ struct bq27x00_access_methods {
>  	int (*read)(struct bq27x00_device_info *di, u8 reg, bool single);
>  };
>  
> -enum bq27x00_chip { BQ27000, BQ27500 };
> +enum bq27x00_chip { BQ27000, BQ27500, BQ27425};
>  
>  struct bq27x00_reg_cache {
>  	int temperature;
> @@ -114,15 +123,17 @@ static enum power_supply_property bq27x00_battery_props[] = {
>  	POWER_SUPPLY_PROP_CAPACITY,
>  	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
>  	POWER_SUPPLY_PROP_TEMP,
> +#ifndef CONFIG_BATTERY_BQ27425

Nope, that won't work. If you have support for the bq27425 built-in you'll
also disable these properties for the other devices supported by this
driver. Add a second power_supply_property array for the bq27425 and assign
the appropriate array at run-time depending on the battery type.

>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
>  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
>  	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
> +	POWER_SUPPLY_PROP_CYCLE_COUNT,
> +	POWER_SUPPLY_PROP_ENERGY_NOW,
> +#endif
>  	POWER_SUPPLY_PROP_TECHNOLOGY,
>  	POWER_SUPPLY_PROP_CHARGE_FULL,
>  	POWER_SUPPLY_PROP_CHARGE_NOW,
>  	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
> -	POWER_SUPPLY_PROP_CYCLE_COUNT,
> -	POWER_SUPPLY_PROP_ENERGY_NOW,
>  };
>  
>  static unsigned int poll_interval = 360;
> @@ -150,6 +161,8 @@ static int bq27x00_battery_read_rsoc(struct bq27x00_device_info *di)
>  
>  	if (di->chip == BQ27500)
>  		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
> +	else if (di->chip == BQ27425)
> +		rsoc = bq27x00_read(di, BQ27425_REG_SOC, false);
>  	else
>  		rsoc = bq27x00_read(di, BQ27000_REG_RSOC, true);
>  
> @@ -174,7 +187,7 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
>  		return charge;
>  	}
>  
> -	if (di->chip == BQ27500)
> +	if (di->chip == BQ27500 || di->chip == BQ27425)
>  		charge *= 1000;
>  	else
>  		charge = charge * 3570 / BQ27000_RS;
> @@ -188,6 +201,8 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
>   */
>  static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
>  {
> +	if (di->chip == BQ27425)
> +		return bq27x00_battery_read_charge(di, BQ27425_REG_NAC);

Maybe it makes sense to provide a look-up table to do the register mapping
instead of all these if (BQ27425O) use regA else use regB.

>  	return bq27x00_battery_read_charge(di, BQ27x00_REG_NAC);
>  }
> [...]

> @@ -729,6 +773,7 @@ static int bq27x00_battery_remove(struct i2c_client *client)
>  static const struct i2c_device_id bq27x00_id[] = {
>  	{ "bq27200", BQ27000 },	/* bq27200 is same as bq27000, but with i2c */
>  	{ "bq27500", BQ27500 },
> +	{ "bq27425", BQ27425 },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(i2c, bq27x00_id);

