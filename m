Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2KLLai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:30:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2KLLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:30:36 -0500
Date: Mon, 12 Nov 2012 12:30:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
In-Reply-To: <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
Message-ID: <Pine.LNX.4.64.1211121132170.29665@axis700.grange>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7Rbyi3plh4tO9HmSqIpf/4NedHitQ+50ypwNS+2jnGU
 4ggocCte2XKNB//C2sMuN4TGKRSpOCV6g3Q08XpCTyUlROgxyF
 ge79e6jNlDhQcpUzPECJzBg7QFfut8JhJnomhT/meE0la8kDPn
 KfYIAq4RnbcB2k10YlBnz8Y2rYFFAft3ZrwEptP7w/KYRfmnUY
 ndThgCYeZuIb+B0wemO6UDqRDgq401axNe/vkFM3KGe0Efn115
 7ICsj0F1Kn2k0brVfu1GZBp6FefrzD9wf8XlrX5z37GgBWDNmK
 SKuWU6utIopGEtdKguS7gTOCOmk0FE5h5Zl8d82Y4ABqnEre+a
 YkRAyFdhi1NXZVaB3qiNpRVvIHtHr1E3BaG5+cskhKFg3Q5/4F
 CKXYlLu3bytZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman

Thanks for submitting these paches! A couple of minor comments below.

On Sun, 11 Nov 2012, Laxman Dewangan wrote:

> TPS80031/ TPS80032 Fully Integrated Power Management with Power
> Path and Battery Charger. The device provides five configurable
> step-down converters, 11 general purpose LDOs, USB OTG Module,
> ADC, RTC, 2 PWM, System Voltage Regulator/Battery Charger with
> Power Path from USB, 32K clock generator.
> 
> Add the mfd core driver for TPS80031/TPS80032.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1: 
> - remove the volatle api.
> - add regmap irq regardless of client->irq.
> - Correct the irq cleanups.
> - remove usage of irq_base.
> - remove suspend/resume
> - Correct acroym and ES nomenclature.
> 
> Changes from V2:
> - Merged regulator specific header file change on this patch.
> 
>  drivers/mfd/Kconfig          |   14 +
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/tps80031.c       |  545 ++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps80031.h |  632 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1192 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/tps80031.c
>  create mode 100644 include/linux/mfd/tps80031.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 637bcdf..a1caf81 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -244,6 +244,20 @@ config MFD_TPS65912_SPI
>  	  If you say yes here you get support for the TPS65912 series of
>  	  PM chips with SPI interface.
>  
> +config MFD_TPS80031
> +	bool "TI TPS80031/TPS80032 Power Management chips"
> +	depends on I2C && GENERIC_HARDIRQS
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select IRQ_DOMAIN
> +	help
> +	  If you say yes here you get support for the Texas Instruments
> +	  TPS80031/ TPS80032 Fully Integrated Power Management with Power
> +	  Path and Battery Charger. The device provides five configurable
> +	  step-down converters, 11 general purpose LDOs, USB OTG Module,
> +	  ADC, RTC, 2 PWM, System Voltage Regulator/Battery Charger with
> +	  Power Path from USB, 32K clock generator.
> +
>  config MENELAUS
>  	bool "Texas Instruments TWL92330/Menelaus PM chip"
>  	depends on I2C=y && ARCH_OMAP2
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 296817c..3595f2d 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -57,6 +57,7 @@ tps65912-objs                   := tps65912-core.o tps65912-irq.o
>  obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
>  obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
>  obj-$(CONFIG_MFD_TPS65912_SPI)  += tps65912-spi.o
> +obj-$(CONFIG_MFD_TPS80031)	+= tps80031.o
>  obj-$(CONFIG_MENELAUS)		+= menelaus.o
>  
>  obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
> diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
> new file mode 100644
> index 0000000..55088e7
> --- /dev/null
> +++ b/drivers/mfd/tps80031.c
> @@ -0,0 +1,545 @@
> +/*
> + * tps80031-regulator.c -- TI TPS80031/TPS80032 mfd core driver.

Looks like a copy-paste to me:-)

> + *
> + * MFD core driver for TI TPS80031/TPS80032 Fully Integrated
> + * Power Management with Power Path and Battery Charger
> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * Author: Laxman Dewangan <ldewangan@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307, USA
> + */
> +
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/tps80031.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>

mutex.h doesn't seem to be needed?

> +#include <linux/pm.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>

[snip]

> +static int __devinit tps80031_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	struct tps80031_platform_data *pdata = client->dev.platform_data;
> +	struct tps80031 *tps80031;
> +	int ret;
> +	uint8_t es_version;
> +	uint8_t ep_ver;
> +	int i;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "tps80031 requires platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	tps80031 = devm_kzalloc(&client->dev, sizeof(*tps80031), GFP_KERNEL);
> +	if (!tps80031) {
> +		dev_err(&client->dev, "Malloc failed for tps80031\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < TPS_NUM_SLAVES; i++) {
> +		if (tps80031_slave_address[i] == client->addr)
> +			tps80031->clients[i] = client;
> +		else
> +			tps80031->clients[i] = i2c_new_dummy(client->adapter,
> +						tps80031_slave_address[i]);
> +		if (!tps80031->clients[i]) {
> +			dev_err(&client->dev, "can't attach client %d\n", i);
> +			ret = -ENOMEM;
> +			goto fail_client_reg;
> +		}
> +
> +		i2c_set_clientdata(tps80031->clients[i], tps80031);
> +		tps80031->regmap[i] = devm_regmap_init_i2c(tps80031->clients[i],
> +					&tps80031_regmap_configs[i]);
> +		if (IS_ERR(tps80031->regmap[i])) {
> +			ret = PTR_ERR(tps80031->regmap[i]);
> +			dev_err(&client->dev,
> +				"regmap %d init failed, err %d\n", i, ret);
> +			goto fail_client_reg;
> +		}
> +	}
> +
> +	ret = tps80031_read(&client->dev, SLAVE_ID3, TPS80031_JTAGVERNUM,
> +			&es_version);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Silicon version number read failed: %d\n", ret);
> +		goto fail_client_reg;
> +	}
> +
> +	ret = tps80031_read(&client->dev, SLAVE_ID3, TPS80031_EPROM_REV,
> +			&ep_ver);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Silicon eeprom version read failed: %d\n", ret);
> +		goto fail_client_reg;
> +	}
> +
> +	dev_info(&client->dev, "ES version 0x%02x and EPROM version 0x%02x\n",
> +					es_version, ep_ver);
> +	tps80031->es_version = es_version;
> +	tps80031->dev = &client->dev;
> +	i2c_set_clientdata(client, tps80031);
> +	tps80031->chip_info = id->driver_data;
> +
> +	ret = tps80031_irq_init(tps80031, client->irq, pdata->irq_base);
> +	if (ret) {
> +		dev_err(&client->dev, "IRQ init failed: %d\n", ret);
> +		goto fail_client_reg;
> +	}
> +
> +	tps80031_pupd_init(tps80031, pdata);
> +
> +	tps80031_init_ext_control(tps80031, pdata);
> +
> +	ret = mfd_add_devices(tps80031->dev, -1,
> +			tps80031_cell, ARRAY_SIZE(tps80031_cell),
> +			NULL, 0,
> +			regmap_irq_get_domain(tps80031->irq_data));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "mfd_add_devices failed: %d\n", ret);
> +		goto fail_mfd_add;
> +	}
> +
> +	if (pdata->use_power_off && !pm_power_off) {
> +		pm_power_off = tps80031_power_off;
> +		tps80031_power_off_dev = tps80031;

This is probably just a theoretical possibility, but after you have 
assigned pm_power_off above, it can already be called, whereas 
tps80031_power_off_dev is not yet set at that time. Wouldn't it be better 
to swap the two assignments?

> +	}
> +	return 0;
> +
> +fail_mfd_add:
> +	regmap_del_irq_chip(client->irq, tps80031->irq_data);
> +
> +fail_client_reg:
> +	for (i = 0; i < TPS_NUM_SLAVES; i++) {
> +		if (tps80031->clients[i] != client)

This "if" will also be entered for slaves, for which the initialisation 
loop didn't run or failed, in which case tps80031->clients[i] == NULL, and 
i2c_unregister_device() would Oops. Should this be

+		if (tps80031->clients[i] && tps80031->clients[i] != client)

instead?

> +			i2c_unregister_device(tps80031->clients[i]);
> +	}
> +	return ret;
> +}
> +
> +static int __devexit tps80031_remove(struct i2c_client *client)
> +{
> +	struct tps80031 *tps80031 = i2c_get_clientdata(client);
> +	int i;

Don't you have to set pm_power_off to NULL again, if it was set to 
tps80031_power_off?

> +
> +	mfd_remove_devices(tps80031->dev);
> +
> +	regmap_del_irq_chip(client->irq, tps80031->irq_data);
> +
> +	for (i = 0; i < TPS_NUM_SLAVES; i++) {
> +		if (tps80031->clients[i] != client)
> +			i2c_unregister_device(tps80031->clients[i]);
> +	}
> +	return 0;
> +}
> +
> +static const struct i2c_device_id tps80031_id_table[] = {
> +	{ "tps80031", TPS80031 },
> +	{ "tps80032", TPS80032 },
> +};
> +MODULE_DEVICE_TABLE(i2c, tps80031_id_table);
> +
> +static struct i2c_driver tps80031_driver = {
> +	.driver	= {
> +		.name	= "tps80031",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= tps80031_probe,
> +	.remove		= __devexit_p(tps80031_remove),
> +	.id_table	= tps80031_id_table,
> +};
> +
> +static int __init tps80031_init(void)
> +{
> +	return i2c_add_driver(&tps80031_driver);
> +}
> +subsys_initcall(tps80031_init);
> +
> +static void __exit tps80031_exit(void)
> +{
> +	i2c_del_driver(&tps80031_driver);
> +}
> +module_exit(tps80031_exit);
> +
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> +MODULE_DESCRIPTION("TPS80031 core driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/tps80031.h b/include/linux/mfd/tps80031.h
> new file mode 100644
> index 0000000..b8e1b4e
> --- /dev/null
> +++ b/include/linux/mfd/tps80031.h
> @@ -0,0 +1,632 @@
> +/*
> + * tps80031.c -- TI TPS80031 and TI TPS80032 PMIC driver.

name typo

> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * Author: Laxman Dewangan <ldewangan@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307, USA
> + */
> +
> +#ifndef __LINUX_MFD_TPS80031_H
> +#define __LINUX_MFD_TPS80031_H
> +
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +
> +/* Pull-ups/Pull-downs */
> +#define TPS80031_CFG_INPUT_PUPD1			0xF0
> +#define TPS80031_CFG_INPUT_PUPD2			0xF1
> +#define TPS80031_CFG_INPUT_PUPD3			0xF2
> +#define TPS80031_CFG_INPUT_PUPD4			0xF3
> +#define TPS80031_CFG_LDO_PD1				0xF4
> +#define TPS80031_CFG_LDO_PD2				0xF5
> +#define TPS80031_CFG_SMPS_PD				0xF6
> +
> +/* Real Time Clock */
> +#define TPS80031_SECONDS_REG				0x00
> +#define TPS80031_MINUTES_REG				0x01
> +#define TPS80031_HOURS_REG				0x02
> +#define TPS80031_DAYS_REG				0x03
> +#define TPS80031_MONTHS_REG				0x04
> +#define TPS80031_YEARS_REG				0x05
> +#define TPS80031_WEEKS_REG				0x06
> +#define TPS80031_ALARM_SECONDS_REG			0x08
> +#define TPS80031_ALARM_MINUTES_REG			0x09
> +#define TPS80031_ALARM_HOURS_REG			0x0A
> +#define TPS80031_ALARM_DAYS_REG				0x0B
> +#define TPS80031_ALARM_MONTHS_REG			0x0C
> +#define TPS80031_ALARM_YEARS_REG			0x0D
> +#define TPS80031_RTC_CTRL_REG				0x10
> +#define TPS80031_RTC_STATUS_REG				0x11
> +#define TPS80031_RTC_INTERRUPTS_REG			0x12
> +#define TPS80031_RTC_COMP_LSB_REG			0x13
> +#define TPS80031_RTC_COMP_MSB_REG			0x14
> +#define TPS80031_RTC_RESET_STATUS_REG			0x16
> +
> +/*PMC Master Module */
> +#define TPS80031_PHOENIX_START_CONDITION		0x1F
> +#define TPS80031_PHOENIX_MSK_TRANSITION			0x20
> +#define TPS80031_STS_HW_CONDITIONS			0x21
> +#define TPS80031_PHOENIX_LAST_TURNOFF_STS		0x22
> +#define TPS80031_VSYSMIN_LO_THRESHOLD			0x23
> +#define TPS80031_VSYSMIN_HI_THRESHOLD			0x24
> +#define TPS80031_PHOENIX_DEV_ON				0x25
> +#define TPS80031_STS_PWR_GRP_STATE			0x27
> +#define TPS80031_PH_CFG_VSYSLOW				0x28
> +#define TPS80031_PH_STS_BOOT				0x29
> +#define TPS80031_PHOENIX_SENS_TRANSITION		0x2A
> +#define TPS80031_PHOENIX_SEQ_CFG			0x2B
> +#define TPS80031_PRIMARY_WATCHDOG_CFG			0X2C
> +#define TPS80031_KEY_PRESS_DUR_CFG			0X2D
> +#define TPS80031_SMPS_LDO_SHORT_STS			0x2E
> +
> +/* PMC Slave Module - Broadcast */
> +#define TPS80031_BROADCAST_ADDR_ALL			0x31
> +#define TPS80031_BROADCAST_ADDR_REF			0x32
> +#define TPS80031_BROADCAST_ADDR_PROV			0x33
> +#define TPS80031_BROADCAST_ADDR_CLK_RST			0x34
> +
> +/* PMC Slave Module  SMPS Regulators */
> +#define TPS80031_SMPS4_CFG_TRANS			0x41
> +#define TPS80031_SMPS4_CFG_STATE			0x42
> +#define TPS80031_SMPS4_CFG_VOLTAGE			0x44
> +#define TPS80031_VIO_CFG_TRANS				0x47
> +#define TPS80031_VIO_CFG_STATE				0x48
> +#define TPS80031_VIO_CFG_FORCE				0x49
> +#define TPS80031_VIO_CFG_VOLTAGE			0x4A
> +#define TPS80031_VIO_CFG_STEP				0x48
> +#define TPS80031_SMPS1_CFG_TRANS			0x53
> +#define TPS80031_SMPS1_CFG_STATE			0x54
> +#define TPS80031_SMPS1_CFG_FORCE			0x55
> +#define TPS80031_SMPS1_CFG_VOLTAGE			0x56
> +#define TPS80031_SMPS1_CFG_STEP				0x57
> +#define TPS80031_SMPS2_CFG_TRANS			0x59
> +#define TPS80031_SMPS2_CFG_STATE			0x5A
> +#define TPS80031_SMPS2_CFG_FORCE			0x5B
> +#define TPS80031_SMPS2_CFG_VOLTAGE			0x5C
> +#define TPS80031_SMPS2_CFG_STEP				0x5D
> +#define TPS80031_SMPS3_CFG_TRANS			0x65
> +#define TPS80031_SMPS3_CFG_STATE			0x66
> +#define TPS80031_SMPS3_CFG_VOLTAGE			0x68
> +
> +/* PMC Slave Module  LDO Regulators */
> +#define TPS80031_VANA_CFG_TRANS				0x81
> +#define TPS80031_VANA_CFG_STATE				0x82
> +#define TPS80031_VANA_CFG_VOLTAGE			0x83
> +#define TPS80031_LDO2_CFG_TRANS				0x85
> +#define TPS80031_LDO2_CFG_STATE				0x86
> +#define TPS80031_LDO2_CFG_VOLTAGE			0x87
> +#define TPS80031_LDO4_CFG_TRANS				0x89
> +#define TPS80031_LDO4_CFG_STATE				0x8A
> +#define TPS80031_LDO4_CFG_VOLTAGE			0x8B
> +#define TPS80031_LDO3_CFG_TRANS				0x8D
> +#define TPS80031_LDO3_CFG_STATE				0x8E
> +#define TPS80031_LDO3_CFG_VOLTAGE			0x8F
> +#define TPS80031_LDO6_CFG_TRANS				0x91
> +#define TPS80031_LDO6_CFG_STATE				0x92
> +#define TPS80031_LDO6_CFG_VOLTAGE			0x93
> +#define TPS80031_LDOLN_CFG_TRANS			0x95
> +#define TPS80031_LDOLN_CFG_STATE			0x96
> +#define TPS80031_LDOLN_CFG_VOLTAGE			0x97
> +#define TPS80031_LDO5_CFG_TRANS				0x99
> +#define TPS80031_LDO5_CFG_STATE				0x9A
> +#define TPS80031_LDO5_CFG_VOLTAGE			0x9B
> +#define TPS80031_LDO1_CFG_TRANS				0x9D
> +#define TPS80031_LDO1_CFG_STATE				0x9E
> +#define TPS80031_LDO1_CFG_VOLTAGE			0x9F
> +#define TPS80031_LDOUSB_CFG_TRANS			0xA1
> +#define TPS80031_LDOUSB_CFG_STATE			0xA2
> +#define TPS80031_LDOUSB_CFG_VOLTAGE			0xA3
> +#define TPS80031_LDO7_CFG_TRANS				0xA5
> +#define TPS80031_LDO7_CFG_STATE				0xA6
> +#define TPS80031_LDO7_CFG_VOLTAGE			0xA7
> +
> +/* PMC Slave Module  External Control */
> +#define TPS80031_REGEN1_CFG_TRANS			0xAE
> +#define TPS80031_REGEN1_CFG_STATE			0xAF
> +#define TPS80031_REGEN2_CFG_TRANS			0xB1
> +#define TPS80031_REGEN2_CFG_STATE			0xB2
> +#define TPS80031_SYSEN_CFG_TRANS			0xB4
> +#define TPS80031_SYSEN_CFG_STATE			0xB5
> +
> +/* PMC Slave Module  Internal Control */
> +#define TPS80031_NRESPWRON_CFG_TRANS			0xB7
> +#define TPS80031_NRESPWRON_CFG_STATE			0xB8
> +#define TPS80031_CLK32KAO_CFG_TRANS			0xBA
> +#define TPS80031_CLK32KAO_CFG_STATE			0xBB
> +#define TPS80031_CLK32KG_CFG_TRANS			0xBD
> +#define TPS80031_CLK32KG_CFG_STATE			0xBE
> +#define TPS80031_CLK32KAUDIO_CFG_TRANS			0xC0
> +#define TPS80031_CLK32KAUDIO_CFG_STATE			0xC1
> +#define TPS80031_VRTC_CFG_TRANS				0xC3
> +#define TPS80031_VRTC_CFG_STATE				0xC4
> +#define TPS80031_BIAS_CFG_TRANS				0xC6
> +#define TPS80031_BIAS_CFG_STATE				0xC7
> +#define TPS80031_VSYSMIN_HI_CFG_TRANS			0xC9
> +#define TPS80031_VSYSMIN_HI_CFG_STATE			0xCA
> +#define TPS80031_RC6MHZ_CFG_TRANS			0xCC
> +#define TPS80031_RC6MHZ_CFG_STATE			0xCD
> +#define TPS80031_TMP_CFG_TRANS				0xCF
> +#define TPS80031_TMP_CFG_STATE				0xD0
> +
> +/* PMC Slave Module  resources assignment */
> +#define TPS80031_PREQ1_RES_ASS_A			0xD7
> +#define TPS80031_PREQ1_RES_ASS_B			0xD8
> +#define TPS80031_PREQ1_RES_ASS_C			0xD9
> +#define TPS80031_PREQ2_RES_ASS_A			0xDA
> +#define TPS80031_PREQ2_RES_ASS_B			0xDB
> +#define TPS80031_PREQ2_RES_ASS_C			0xDC
> +#define TPS80031_PREQ3_RES_ASS_A			0xDD
> +#define TPS80031_PREQ3_RES_ASS_B			0xDE
> +#define TPS80031_PREQ3_RES_ASS_C			0xDF
> +
> +/* PMC Slave Module  Miscellaneous */
> +#define TPS80031_SMPS_OFFSET				0xE0
> +#define TPS80031_SMPS_MULT				0xE3
> +#define TPS80031_MISC1					0xE4
> +#define TPS80031_MISC2					0xE5
> +#define TPS80031_BBSPOR_CFG				0xE6
> +#define TPS80031_TMP_CFG				0xE7
> +
> +/* Battery Charging Controller and Indicator LED */
> +#define TPS80031_CONTROLLER_CTRL2			0xDA
> +#define TPS80031_CONTROLLER_VSEL_COMP			0xDB
> +#define TPS80031_CHARGERUSB_VSYSREG			0xDC
> +#define TPS80031_CHARGERUSB_VICHRG_PC			0xDD
> +#define TPS80031_LINEAR_CHRG_STS			0xDE
> +#define TPS80031_CONTROLLER_INT_MASK			0xE0
> +#define TPS80031_CONTROLLER_CTRL1			0xE1
> +#define TPS80031_CONTROLLER_WDG				0xE2
> +#define TPS80031_CONTROLLER_STAT1			0xE3
> +#define TPS80031_CHARGERUSB_INT_STATUS			0xE4
> +#define TPS80031_CHARGERUSB_INT_MASK			0xE5
> +#define TPS80031_CHARGERUSB_STATUS_INT1			0xE6
> +#define TPS80031_CHARGERUSB_STATUS_INT2			0xE7
> +#define TPS80031_CHARGERUSB_CTRL1			0xE8
> +#define TPS80031_CHARGERUSB_CTRL2			0xE9
> +#define TPS80031_CHARGERUSB_CTRL3			0xEA
> +#define TPS80031_CHARGERUSB_STAT1			0xEB
> +#define TPS80031_CHARGERUSB_VOREG			0xEC
> +#define TPS80031_CHARGERUSB_VICHRG			0xED
> +#define TPS80031_CHARGERUSB_CINLIMIT			0xEE
> +#define TPS80031_CHARGERUSB_CTRLLIMIT1			0xEF
> +#define TPS80031_CHARGERUSB_CTRLLIMIT2			0xF0
> +#define TPS80031_LED_PWM_CTRL1				0xF4
> +#define TPS80031_LED_PWM_CTRL2				0xF5
> +
> +/* USB On-The-Go  */
> +#define TPS80031_BACKUP_REG				0xFA
> +#define TPS80031_USB_VENDOR_ID_LSB			0x00
> +#define TPS80031_USB_VENDOR_ID_MSB			0x01
> +#define TPS80031_USB_PRODUCT_ID_LSB			0x02
> +#define TPS80031_USB_PRODUCT_ID_MSB			0x03
> +#define TPS80031_USB_VBUS_CTRL_SET			0x04
> +#define TPS80031_USB_VBUS_CTRL_CLR			0x05
> +#define TPS80031_USB_ID_CTRL_SET			0x06
> +#define TPS80031_USB_ID_CTRL_CLR			0x07
> +#define TPS80031_USB_VBUS_INT_SRC			0x08
> +#define TPS80031_USB_VBUS_INT_LATCH_SET			0x09
> +#define TPS80031_USB_VBUS_INT_LATCH_CLR			0x0A
> +#define TPS80031_USB_VBUS_INT_EN_LO_SET			0x0B
> +#define TPS80031_USB_VBUS_INT_EN_LO_CLR			0x0C
> +#define TPS80031_USB_VBUS_INT_EN_HI_SET			0x0D
> +#define TPS80031_USB_VBUS_INT_EN_HI_CLR			0x0E
> +#define TPS80031_USB_ID_INT_SRC				0x0F
> +#define TPS80031_USB_ID_INT_LATCH_SET			0x10
> +#define TPS80031_USB_ID_INT_LATCH_CLR			0x11
> +#define TPS80031_USB_ID_INT_EN_LO_SET			0x12
> +#define TPS80031_USB_ID_INT_EN_LO_CLR			0x13
> +#define TPS80031_USB_ID_INT_EN_HI_SET			0x14
> +#define TPS80031_USB_ID_INT_EN_HI_CLR			0x15
> +#define TPS80031_USB_OTG_ADP_CTRL			0x16
> +#define TPS80031_USB_OTG_ADP_HIGH			0x17
> +#define TPS80031_USB_OTG_ADP_LOW			0x18
> +#define TPS80031_USB_OTG_ADP_RISE			0x19
> +#define TPS80031_USB_OTG_REVISION			0x1A
> +
> +/* Gas Gauge */
> +#define TPS80031_FG_REG_00				0xC0
> +#define TPS80031_FG_REG_01				0xC1
> +#define TPS80031_FG_REG_02				0xC2
> +#define TPS80031_FG_REG_03				0xC3
> +#define TPS80031_FG_REG_04				0xC4
> +#define TPS80031_FG_REG_05				0xC5
> +#define TPS80031_FG_REG_06				0xC6
> +#define TPS80031_FG_REG_07				0xC7
> +#define TPS80031_FG_REG_08				0xC8
> +#define TPS80031_FG_REG_09				0xC9
> +#define TPS80031_FG_REG_10				0xCA
> +#define TPS80031_FG_REG_11				0xCB
> +
> +/* General Purpose ADC */
> +#define TPS80031_GPADC_CTRL				0x2E
> +#define TPS80031_GPADC_CTRL2				0x2F
> +#define TPS80031_RTSELECT_LSB				0x32
> +#define TPS80031_RTSELECT_ISB				0x33
> +#define TPS80031_RTSELECT_MSB				0x34
> +#define TPS80031_GPSELECT_ISB				0x35
> +#define TPS80031_CTRL_P1				0x36
> +#define TPS80031_RTCH0_LSB				0x37
> +#define TPS80031_RTCH0_MSB				0x38
> +#define TPS80031_RTCH1_LSB				0x39
> +#define TPS80031_RTCH1_MSB				0x3A
> +#define TPS80031_GPCH0_LSB				0x3B
> +#define TPS80031_GPCH0_MSB				0x3C
> +
> +/* SIM, MMC and Battery Detection */
> +#define TPS80031_SIMDEBOUNCING				0xEB
> +#define TPS80031_SIMCTRL				0xEC
> +#define TPS80031_MMCDEBOUNCING				0xED
> +#define TPS80031_MMCCTRL				0xEE
> +#define TPS80031_BATDEBOUNCING				0xEF
> +
> +/* Vibrator Driver and PWMs */
> +#define TPS80031_VIBCTRL				0x9B
> +#define TPS80031_VIBMODE				0x9C
> +#define TPS80031_PWM1ON					0xBA
> +#define TPS80031_PWM1OFF				0xBB
> +#define TPS80031_PWM2ON					0xBD
> +#define TPS80031_PWM2OFF				0xBE
> +
> +/* Control Interface */
> +#define TPS80031_INT_STS_A				0xD0
> +#define TPS80031_INT_STS_B				0xD1
> +#define TPS80031_INT_STS_C				0xD2
> +#define TPS80031_INT_MSK_LINE_A				0xD3
> +#define TPS80031_INT_MSK_LINE_B				0xD4
> +#define TPS80031_INT_MSK_LINE_C				0xD5
> +#define TPS80031_INT_MSK_STS_A				0xD6
> +#define TPS80031_INT_MSK_STS_B				0xD7
> +#define TPS80031_INT_MSK_STS_C				0xD8
> +#define TPS80031_TOGGLE1				0x90
> +#define TPS80031_TOGGLE2				0x91
> +#define TPS80031_TOGGLE3				0x92
> +#define TPS80031_PWDNSTATUS1				0x93
> +#define TPS80031_PWDNSTATUS2				0x94
> +#define TPS80031_VALIDITY0				0x17
> +#define TPS80031_VALIDITY1				0x18
> +#define TPS80031_VALIDITY2				0x19
> +#define TPS80031_VALIDITY3				0x1A
> +#define TPS80031_VALIDITY4				0x1B
> +#define TPS80031_VALIDITY5				0x1C
> +#define TPS80031_VALIDITY6				0x1D
> +#define TPS80031_VALIDITY7				0x1E
> +
> +/* Version number related register */
> +#define TPS80031_JTAGVERNUM				0x87
> +#define TPS80031_EPROM_REV				0xDF
> +
> +/* GPADC Trimming Bits. */
> +#define TPS80031_GPADC_TRIM0				0xCC
> +#define TPS80031_GPADC_TRIM1				0xCD
> +#define TPS80031_GPADC_TRIM2				0xCE
> +#define TPS80031_GPADC_TRIM3				0xCF
> +#define TPS80031_GPADC_TRIM4				0xD0
> +#define TPS80031_GPADC_TRIM5				0xD1
> +#define TPS80031_GPADC_TRIM6				0xD2
> +#define TPS80031_GPADC_TRIM7				0xD3
> +#define TPS80031_GPADC_TRIM8				0xD4
> +#define TPS80031_GPADC_TRIM9				0xD5
> +#define TPS80031_GPADC_TRIM10				0xD6
> +#define TPS80031_GPADC_TRIM11				0xD7
> +#define TPS80031_GPADC_TRIM12				0xD8
> +#define TPS80031_GPADC_TRIM13				0xD9
> +#define TPS80031_GPADC_TRIM14				0xDA
> +#define TPS80031_GPADC_TRIM15				0xDB
> +#define TPS80031_GPADC_TRIM16				0xDC
> +#define TPS80031_GPADC_TRIM17				0xDD
> +#define TPS80031_GPADC_TRIM18				0xDE
> +
> +/* TPS80031_CONTROLLER_STAT1 bit fields */
> +#define CONTROLLER_STAT1_BAT_TEMP			0
> +#define CONTROLLER_STAT1_BAT_REMOVED			1
> +#define CONTROLLER_STAT1_VBUS_DET			2
> +#define CONTROLLER_STAT1_VAC_DET			3
> +#define CONTROLLER_STAT1_FAULT_WDG			4
> +#define CONTROLLER_STAT1_LINCH_GATED			6
> +/* TPS80031_CONTROLLER_INT_MASK bit filed */
> +#define CONTROLLER_INT_MASK_MVAC_DET			0
> +#define CONTROLLER_INT_MASK_MVBUS_DET			1
> +#define CONTROLLER_INT_MASK_MBAT_TEMP			2
> +#define CONTROLLER_INT_MASK_MFAULT_WDG			3
> +#define CONTROLLER_INT_MASK_MBAT_REMOVED		4
> +#define CONTROLLER_INT_MASK_MLINCH_GATED		5
> +
> +#define CHARGE_CONTROL_SUB_INT_MASK			0x3F
> +
> +/* TPS80031_PHOENIX_DEV_ON bit field */
> +#define DEVOFF						0x1

This header is going to be included by other drivers for various tps80031 
functions, so, I think, it is better to avoid names with a high conflict 
probability like "DEVOFF" and use the TPS80031_ prefix consistently for 
all symbols in the header. In fact, DEVOFF is not used in patch 2/2, only 
in 1/2, it also looks like it's not going to be interesting for any other 
functions, so, maybe just define in .c or even just use the numeric value 
directly.

> +
> +#define EXT_CONTROL_CFG_TRANS				0
> +#define EXT_CONTROL_CFG_STATE				1
> +
> +/* State register field */
> +#define STATE_OFF					0x00
> +#define STATE_ON					0x01
> +#define STATE_MASK					0x03
> +
> +/* Trans register field */
> +#define TRANS_ACTIVE_OFF				0x00
> +#define TRANS_ACTIVE_ON					0x01
> +#define TRANS_ACTIVE_MASK				0x03
> +#define TRANS_SLEEP_OFF					0x00
> +#define TRANS_SLEEP_ON					0x04
> +#define TRANS_SLEEP_MASK				0x0C
> +#define TRANS_OFF_OFF					0x00
> +#define TRANS_OFF_ACTIVE				0x10
> +#define TRANS_OFF_MASK					0x30
> +
> +#define EXT_PWR_REQ		(PWR_REQ_INPUT_PREQ1 | PWR_REQ_INPUT_PREQ2 | \
> +				PWR_REQ_INPUT_PREQ3)

Ditto for the above defines, "STATE_ON" is really pretty generic.

> +
> +/* TPS80031_BBSPOR_CFG bit field */
> +#define TPS80031_BBSPOR_CHG_EN				0x8
> +#define TPS80031_MAX_REGISTER				0xFF
> +
> +/* Supported chips */
> +enum chips {
> +	TPS80031 = 0x00000001,
> +	TPS80032 = 0x00000002,
> +};
> +
> +enum {
> +	TPS80031_INT_PWRON,
> +	TPS80031_INT_RPWRON,
> +	TPS80031_INT_SYS_VLOW,
> +	TPS80031_INT_RTC_ALARM,
> +	TPS80031_INT_RTC_PERIOD,
> +	TPS80031_INT_HOT_DIE,
> +	TPS80031_INT_VXX_SHORT,
> +	TPS80031_INT_SPDURATION,
> +	TPS80031_INT_WATCHDOG,
> +	TPS80031_INT_BAT,
> +	TPS80031_INT_SIM,
> +	TPS80031_INT_MMC,
> +	TPS80031_INT_RES,
> +	TPS80031_INT_GPADC_RT,
> +	TPS80031_INT_GPADC_SW2_EOC,
> +	TPS80031_INT_CC_AUTOCAL,
> +	TPS80031_INT_ID_WKUP,
> +	TPS80031_INT_VBUSS_WKUP,
> +	TPS80031_INT_ID,
> +	TPS80031_INT_VBUS,
> +	TPS80031_INT_CHRG_CTRL,
> +	TPS80031_INT_EXT_CHRG,
> +	TPS80031_INT_INT_CHRG,
> +	TPS80031_INT_RES2,
> +	TPS80031_INT_BAT_TEMP_OVRANGE,
> +	TPS80031_INT_BAT_REMOVED,
> +	TPS80031_INT_VBUS_DET,
> +	TPS80031_INT_VAC_DET,
> +	TPS80031_INT_FAULT_WDG,
> +	TPS80031_INT_LINCH_GATED,
> +
> +	/* Last interrupt id to get the end number */
> +	TPS80031_INT_NR,
> +};
> +
> +#define TPS_NUM_SLAVES					4
> +#define SLAVE_ID0					0
> +#define SLAVE_ID1					1
> +#define SLAVE_ID2					2
> +#define SLAVE_ID3					3
> +
> +#define I2C_ID0_ADDR					0x12
> +#define I2C_ID1_ADDR					0x48
> +#define I2C_ID2_ADDR					0x49
> +#define I2C_ID3_ADDR					0x4A

Ditto for the above defines. In general, I would really only place symbols 
here, that have to be used by function drivers.

> +
> +enum {
> +	TPS80031_REGULATOR_VIO,
> +	TPS80031_REGULATOR_SMPS1,
> +	TPS80031_REGULATOR_SMPS2,
> +	TPS80031_REGULATOR_SMPS3,
> +	TPS80031_REGULATOR_SMPS4,
> +	TPS80031_REGULATOR_VANA,
> +	TPS80031_REGULATOR_LDO1,
> +	TPS80031_REGULATOR_LDO2,
> +	TPS80031_REGULATOR_LDO3,
> +	TPS80031_REGULATOR_LDO4,
> +	TPS80031_REGULATOR_LDO5,
> +	TPS80031_REGULATOR_LDO6,
> +	TPS80031_REGULATOR_LDO7,
> +	TPS80031_REGULATOR_LDOLN,
> +	TPS80031_REGULATOR_LDOUSB,
> +	TPS80031_REGULATOR_VBUS,
> +	TPS80031_REGULATOR_REGEN1,
> +	TPS80031_REGULATOR_REGEN2,
> +	TPS80031_REGULATOR_SYSEN,
> +	TPS80031_REGULATOR_MAX,
> +};
> +
> +/* Different configurations for the rails */
> +enum {
> +	/* USBLDO input selection */
> +	USBLDO_INPUT_VSYS		= 0x00000001,
> +	USBLDO_INPUT_PMID		= 0x00000002,
> +
> +	/* LDO3 output mode */
> +	LDO3_OUTPUT_VIB			= 0x00000004,
> +
> +	/* VBUS configuration */
> +	VBUS_DISCHRG_EN_PDN		= 0x00000004,
> +	VBUS_SW_ONLY			= 0x00000008,
> +	VBUS_SW_N_ID			= 0x00000010,
> +};
> +
> +/* External controls requests */
> +enum tps80031_ext_control {
> +	PWR_REQ_INPUT_NONE	= 0x00000000,
> +	PWR_REQ_INPUT_PREQ1	= 0x00000001,
> +	PWR_REQ_INPUT_PREQ2	= 0x00000002,
> +	PWR_REQ_INPUT_PREQ3	= 0x00000004,
> +	PWR_OFF_ON_SLEEP	= 0x00000008,
> +	PWR_ON_ON_SLEEP		= 0x00000010,
> +};
> +
> +enum tps80031_pupd_pins {
> +	TPS80031_PREQ1 = 0,
> +	TPS80031_PREQ2A,
> +	TPS80031_PREQ2B,
> +	TPS80031_PREQ2C,
> +	TPS80031_PREQ3,
> +	TPS80031_NRES_WARM,
> +	TPS80031_PWM_FORCE,
> +	TPS80031_CHRG_EXT_CHRG_STATZ,
> +	TPS80031_SIM,
> +	TPS80031_MMC,
> +	TPS80031_GPADC_START,
> +	TPS80031_DVSI2C_SCL,
> +	TPS80031_DVSI2C_SDA,
> +	TPS80031_CTLI2C_SCL,
> +	TPS80031_CTLI2C_SDA,
> +};
> +
> +enum tps80031_pupd_settings {
> +	TPS80031_PUPD_NORMAL,
> +	TPS80031_PUPD_PULLDOWN,
> +	TPS80031_PUPD_PULLUP,
> +};
> +
> +struct tps80031 {
> +	struct device		*dev;

Need to forward-declare struct device.

> +	unsigned long		chip_info;
> +	int			es_version;
> +	struct i2c_client	*clients[TPS_NUM_SLAVES];

I think, you can drop i2c.h and just forward-declare struct i2c_client too.

> +	struct regmap		*regmap[TPS_NUM_SLAVES];
> +	struct regmap_irq_chip_data *irq_data;
> +};

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
