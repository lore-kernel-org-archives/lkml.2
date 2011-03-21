Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1CUB0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 21:26:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33160 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab1CUB0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 21:26:21 -0400
Date: Mon, 21 Mar 2011 12:26:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20110321122615.8a639909.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/mach-ux500/board-mop500-regulators.c and
arch/arm/mach-ux500/board-mop500.c between commits d1de85a23144
("mach-ux500: add a few AB8500 regulator consumers v3") and a71b819b6edf
("mach-ux500: platform data for SFH7741 proximity sensor driver") from
Linus' tree and commit 00423735a08e ("mach-ux500: configure board for the
TPS61052 regulator v2") from the mfd tree.

I fixed them up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ux500/board-mop500-regulators.c
index 875c91b,0825012..0000000
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@@ -13,55 -13,30 +13,79 @@@
  #include <linux/regulator/ab8500.h>
  #include "board-mop500-regulators.h"
  
+ /*
+  * TPS61052 regulator
+  */
+ static struct regulator_consumer_supply tps61052_vaudio_consumers[] = {
+ 	/*
+ 	 * Boost converter supply to raise voltage on audio speaker, this
+ 	 * is actually connected to three pins, VInVhfL (left amplifier)
+ 	 * VInVhfR (right amplifier) and VIntDClassInt - all three must
+ 	 * be connected to the same voltage.
+ 	 */
+ 	REGULATOR_SUPPLY("vintdclassint", "ab8500-codec.0"),
+ };
+ 
+ struct regulator_init_data tps61052_regulator = {
+ 	.constraints = {
+ 		.name = "vaudio-hf",
+ 		.min_uV = 4500000,
+ 		.max_uV = 4500000,
+ 		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+ 	},
+ 	.num_consumer_supplies = ARRAY_SIZE(tps61052_vaudio_consumers),
+ 	.consumer_supplies = tps61052_vaudio_consumers,
+ };
+ 
 +static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
 +	/* External displays, connector on board 2v5 power supply */
 +	REGULATOR_SUPPLY("vaux12v5", "mcde.0"),
 +	/* SFH7741 proximity sensor */
 +	REGULATOR_SUPPLY("vcc", "gpio-keys.0"),
 +	/* BH1780GLS ambient light sensor */
 +	REGULATOR_SUPPLY("vcc", "2-0029"),
 +	/* lsm303dlh accelerometer */
 +	REGULATOR_SUPPLY("vdd", "3-0018"),
 +	/* lsm303dlh magnetometer */
 +	REGULATOR_SUPPLY("vdd", "3-001e"),
 +	/* Rohm BU21013 Touchscreen devices */
 +	REGULATOR_SUPPLY("avdd", "3-005c"),
 +	REGULATOR_SUPPLY("avdd", "3-005d"),
 +	/* Synaptics RMI4 Touchscreen device */
 +	REGULATOR_SUPPLY("vdd", "3-004b"),
 +};
 +
 +static struct regulator_consumer_supply ab8500_vaux2_consumers[] = {
 +	/* On-board eMMC power */
 +	REGULATOR_SUPPLY("vmmc", "sdi4"),
 +	/* AB8500 audio codec */
 +	REGULATOR_SUPPLY("vcc-N2158", "ab8500-codec.0"),
 +};
 +
 +static struct regulator_consumer_supply ab8500_vaux3_consumers[] = {
 +	/* External MMC slot power */
 +	REGULATOR_SUPPLY("vmmc", "sdi0"),
 +};
 +
 +static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 +	/* TV-out DENC supply */
 +	REGULATOR_SUPPLY("vtvout", "ab8500-denc.0"),
 +	/* Internal general-purpose ADC */
 +	REGULATOR_SUPPLY("vddadc", "ab8500-gpadc.0"),
 +};
 +
 +static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
 +	/* SoC core supply, no device */
 +	REGULATOR_SUPPLY("v-intcore", NULL),
 +	/* USB Transciever */
 +	REGULATOR_SUPPLY("vddulpivio18", "ab8500-usb.0"),
 +};
 +
 +static struct regulator_consumer_supply ab8500_vana_consumers[] = {
 +	/* External displays, connector on board, 1v8 power supply */
 +	REGULATOR_SUPPLY("vsmps2", "mcde.0"),
 +};
 +
  /* AB8500 regulators */
  struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
  	/* supplies to the display/camera */
diff --cc arch/arm/mach-ux500/board-mop500.c
index 8790d98,1e75d7e..0000000
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@@ -21,9 -20,7 +21,10 @@@
  #include <linux/spi/spi.h>
  #include <linux/mfd/ab8500.h>
  #include <linux/mfd/tc3589x.h>
 +#include <linux/leds-lp5521.h>
 +#include <linux/input.h>
 +#include <linux/gpio_keys.h>
+ #include <linux/mfd/tps6105x.h>
  
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
@@@ -65,7 -104,26 +66,16 @@@ struct platform_device ab8500_device = 
  	.resource = ab8500_resources,
  };
  
 -static struct pl022_ssp_controller ssp0_platform_data = {
 -	.bus_id = 0,
 -	/* pl022 not yet supports dma */
 -	.enable_dma = 0,
 -	/* on this platform, gpio 31,142,144,214 &
 -	 * 224 are connected as chip selects
 -	 */
 -	.num_chipselect = 5,
 -};
 -
  /*
+  * TPS61052
+  */
+ 
+ static struct tps6105x_platform_data mop500_tps61052_data = {
+ 	.mode = TPS6105X_MODE_VOLTAGE,
+ 	.regulator_data = &tps61052_regulator,
+ };
+ 
+ /*
   * TC35892
   */
  
@@@ -85,60 -143,14 +95,64 @@@ static struct tc3589x_platform_data mop
  	.irq_base	= MOP500_EGPIO_IRQ_BASE,
  };
  
 +static struct lp5521_led_config lp5521_pri_led[] = {
 +       [0] = {
 +	       .chan_nr = 0,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +       [1] = {
 +	       .chan_nr = 1,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +       [2] = {
 +	       .chan_nr = 2,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +};
 +
 +static struct lp5521_platform_data __initdata lp5521_pri_data = {
 +       .label = "lp5521_pri",
 +       .led_config     = &lp5521_pri_led[0],
 +       .num_channels   = 3,
 +       .clock_mode     = LP5521_CLOCK_EXT,
 +};
 +
 +static struct lp5521_led_config lp5521_sec_led[] = {
 +       [0] = {
 +	       .chan_nr = 0,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +       [1] = {
 +	       .chan_nr = 1,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +       [2] = {
 +	       .chan_nr = 2,
 +	       .led_current = 0x2f,
 +	       .max_current = 0x5f,
 +       },
 +};
 +
 +static struct lp5521_platform_data __initdata lp5521_sec_data = {
 +       .label = "lp5521_sec",
 +       .led_config     = &lp5521_sec_led[0],
 +       .num_channels   = 3,
 +       .clock_mode     = LP5521_CLOCK_EXT,
 +};
 +
  static struct i2c_board_info mop500_i2c0_devices[] = {
  	{
+ 		I2C_BOARD_INFO("tps61052", 0x33),
+ 		.platform_data  = &mop500_tps61052_data,
+ 	},
+ 	{
  		I2C_BOARD_INFO("tc3589x", 0x42),
 -		.irq            = NOMADIK_GPIO_TO_IRQ(217),
 +		.irq		= NOMADIK_GPIO_TO_IRQ(217),
  		.platform_data  = &mop500_tc35892_data,
  	},
  };
