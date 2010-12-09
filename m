Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0LIUfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:35:22 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33601 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756388Ab0LIUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:35:18 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: [RFC][PATCH v2 0/3] slower spi-gpio
Date: Thu,  9 Dec 2010 15:34:53 -0500
Message-Id: <cover.1291925752.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This a continuation of the previous RFC [1]; we are interested in running a
bitbanged SPI bus with a limited rate of transfer, including the delay between
CS assertion and the beginning of data transfer. We also would like to do this 
with the GPIOs on an IO expander.

The following three changes have been identified so far as being required to 
achieve this. spidelay() must be implemented, the delay specified in
controller_state should be honoured when a transfer begins and finally the 
_cansleep gpio set functions should be used so that GPIOs on an expander can
be used. 

This is alot of compile-time functionality switching though. I wonder if this
kind of patching of spi-gpio would be acceptable or not; given the recent
events in polled gpio-keys I feel that maybe a new 'spi-gpio-limited' driver 
might be preferred.

[1] http://article.gmane.org/gmane.linux.kernel/1065748

Ben Gardiner (3):
  [RFC] spi-gpio: implement spidelay() for platforms that configure
    SLOWER_SPI_GPIO
  [RFC] spi_bitbang : get nsecs delay from cs during transfer
  [RFC] spi-gpio: use _cansleep when CONFIG_SLOWER_SPI_GPIO is defined

 drivers/spi/Kconfig       |   17 +++++++++++++++++
 drivers/spi/spi_bitbang.c |   15 +++++++++------
 drivers/spi/spi_gpio.c    |   18 +++++++++++++++---
 3 files changed, 41 insertions(+), 9 deletions(-)

---

Changes since v1:
 * rebased to  2.6.37-rc5
 * introduced patch 2/3 and 3/3

This time around I tested the changes by registering a spi-gpio bus intance
on the user DIP switches of the da850evm baseboard which are connected to a 
pca953x-compatible I2C gpio expander. Then I did a few 
'echo hello > /dev/spidev0.0' commands and checked the behaviour of the bus
on a scope. I was unable to test the speed of this bus without the patchset
this time since using the GPIOs on the expander requires patch 3/3. I found 
that the SCLK speed was roughly 300Hz where 500Hz was requested.

Here is a snip of the board-setup code that registers the spi-gpio bus:

static struct spi_gpio_platform_data bb_spi_gpio_pdata = {
	.sck		= -1 /* assigned at runtime */,
	.mosi		= -1 /* assigned at runtime */,
	.miso		= -1 /* assigned at runtime */,
	.num_chipselect = 1,
};

static struct platform_device bb_spi_gpio = {
	.name		= "spi_gpio",
	.id		= 0,
	.dev		= {
		.platform_data	= &bb_spi_gpio_pdata,
	},
};

static struct spi_board_info bb_spi_devices[] = {
	{
		.modalias	= "spidev",
		.max_speed_hz	= 500,
		.bus_num	= 0,
		.chip_select	= 0,
		.mode		= SPI_MODE_0,
		.controller_data = (void *) -1 /* assigned at runtime */,
	},
};

static int bb_spi_gpio_init(unsigned gpio)
{
	int ret;

	bb_spi_gpio_pdata.sck = gpio + DA850_EVM_BB_EXP_USER_SW1;
	bb_spi_gpio_pdata.mosi = gpio + DA850_EVM_BB_EXP_USER_SW2;
	bb_spi_gpio_pdata.miso = -1 /* nothing connected ATM */;

	bb_spi_devices[0].controller_data = (void *) gpio +
						DA850_EVM_BB_EXP_USER_SW3;

	ret = spi_register_board_info(bb_spi_devices,
					ARRAY_SIZE(bb_spi_devices));
	if (ret) {
		pr_warning("could not register spi devices");
		goto spi_gpio_fail_devices;
	}

	ret = platform_device_register(&bb_spi_gpio);
	if (ret) {
		pr_warning("could not register spi-gpio driver instance");
		goto spi_gpio_fail_bus;
	}

	return 0;
spi_gpio_fail_bus:
	/* no unregister board info function available*/
spi_gpio_fail_devices:
	return ret;
}

static int da850_evm_bb_expander_setup(struct i2c_client *client,
						unsigned gpio, unsigned ngpio,
						void *c)
{
	int ret;

	/*
	 * Register the switches and pushbutton on the baseboard as a gpio-keys
	 * device.
	 */
	da850_evm_bb_keys_init(gpio);
	ret = platform_device_register(&da850_evm_bb_keys_device);
	if (ret) {
		pr_warning("Could not register baseboard GPIO expander keys");
		goto io_exp_setup_sw_fail;
	}

	da850_evm_bb_leds_init(gpio);
	ret = platform_device_register(&da850_evm_bb_leds_device);
	if (ret) {
		pr_warning("Could not register baseboard GPIO expander LEDS");
		goto io_exp_setup_leds_fail;
	}

	ret = bb_spi_gpio_init(gpio);
	if (ret) {
		pr_warning("Could not register spi-gpio bus");
		goto io_exp_setup_spi_fail;
	}

	return 0;

io_exp_setup_spi_fail:
	platform_device_unregister(&da850_evm_bb_leds_device);
io_exp_setup_leds_fail:
	platform_device_unregister(&da850_evm_bb_keys_device);
io_exp_setup_sw_fail:
	return ret;
}
