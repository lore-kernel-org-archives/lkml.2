Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2CEQGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:06:51 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36562 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2CEQGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:06:47 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v3 1/3] ARM: OMAP1: ams-delta: set up regulator over modem reset GPIO pin
Date: Mon,  5 Mar 2012 17:05:10 +0100
Message-Id: <1330963512-20413-2-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Amstrad Delta on-board latch2 bit named MODEM_NRESET, now available
as a GPIO pin AMS_DELTA_GPIO_PIN_NMODEM_RESET, is used to power up/down
(bring into/out of a reset state) two distinct on-board devices
simultaneously: the modem, and the voice codec. As a consequence, that
bit is, or can be, manipulated concurrently by two drivers, or their
platform provided hooks.

Instead of updating those drivers to use the gpiolib API as a new method
of controlling the MODEM_NRESET pin state, like it was done to other
drivers accessing latch2 pins, and still being vulnerable to potential
concurrency conflicts, or trying to solve that sharing issue with a
custom piece of code, set up a fixed regulator device on top of that
GPIO pin, with the intention of updating both drivers to manipulate that
regulator, not the GPIO pin directly.

Before the ASoC driver is updated and the modem platform data expanded
with a power management callback for switching its power, the
ams_delta_latch_write() function, which still provides the old API for
accessing latch2 functionality from not updated drivers, is modified to
toggle the regulator instead of the MODEM_NRESET GPIO pin.  A helper
function provided for balancing the regulator enable/disable operations,
together with the consumer data needed for tracking the regulator state,
will be removed once the drivers are updated.

Depends on patch series "ARM: OMAP1: ams-delta: replace custom I/O with
GPIO".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
v2 -> v3 changes:
* fix section mismatch isue.

Changes against initial version:
* rename consumer setup elements to match their final, modem only
  related purpose,
* initialize the regulator pointer and mutex before first use, then
  omit testing that pointer against NULL value

 arch/arm/mach-omap1/Kconfig           |    2 +
 arch/arm/mach-omap1/board-ams-delta.c |  104 +++++++++++++++++++++++++++++++--
 2 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 5b1edba..4b6a774 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -157,6 +157,8 @@ config MACH_AMS_DELTA
 	select FIQ
 	select GPIO_GENERIC_PLATFORM
 	select LEDS_GPIO_REGISTER
+	select REGULATOR
+	select REGULATOR_FIXED_VOLTAGE
 	help
 	  Support for the Amstrad E3 (codename Delta) videophone. Say Y here
 	  if you have such a device.
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index ce50fe1..949997c 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -18,7 +18,11 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/leds.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/fixed.h>
+#include <linux/regulator/machine.h>
 #include <linux/serial_8250.h>
 #include <linux/export.h>
 
@@ -237,11 +241,6 @@ static const struct gpio latch_gpios[] __initconst = {
 		.label	= "scard_cmdvcc",
 	},
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "modem_nreset",
-	},
-	{
 		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "modem_codec",
@@ -258,6 +257,71 @@ static const struct gpio latch_gpios[] __initconst = {
 	},
 };
 
+static struct regulator_consumer_supply modem_nreset_consumers[] = {
+	REGULATOR_SUPPLY("RESET#", "serial8250.1"),
+	REGULATOR_SUPPLY("POR", "cx20442-codec"),
+};
+
+static struct regulator_init_data modem_nreset_data = {
+	.constraints		= {
+		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
+		.boot_on		= 1,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(modem_nreset_consumers),
+	.consumer_supplies	= modem_nreset_consumers,
+};
+
+static struct fixed_voltage_config modem_nreset_config = {
+	.supply_name		= "modem_nreset",
+	.microvolts		= 3300000,
+	.gpio			= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
+	.startup_delay		= 25000,
+	.enable_high		= 1,
+	.enabled_at_boot	= 1,
+	.init_data		= &modem_nreset_data,
+};
+
+static struct platform_device modem_nreset_device = {
+	.name	= "reg-fixed-voltage",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &modem_nreset_config,
+	},
+};
+
+struct modem_private_data {
+	struct regulator *regulator;
+	struct {
+		struct mutex lock;
+		bool enabled;
+	} consumer;
+};
+
+static int regulator_toggle(struct modem_private_data *priv, bool enable)
+{
+	int err = 0;
+
+	mutex_lock(&priv->consumer.lock);
+	if (IS_ERR(priv->regulator)) {
+		err = PTR_ERR(priv->regulator);
+	} else if (enable) {
+		if (!priv->consumer.enabled) {
+			err = regulator_enable(priv->regulator);
+			priv->consumer.enabled = true;
+		}
+	} else {
+		if (priv->consumer.enabled) {
+			err = regulator_disable(priv->regulator);
+			priv->consumer.enabled = false;
+		}
+	}
+	mutex_unlock(&priv->consumer.lock);
+
+	return err;
+}
+
+static struct modem_private_data modem_priv;
+
 void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
 {
 	int bit = 0;
@@ -266,7 +330,10 @@ void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
 	for (; bit < ngpio; bit++, bitpos = bitpos << 1) {
 		if (!(mask & bitpos))
 			continue;
-		gpio_set_value(base + bit, (value & bitpos) != 0);
+		else if (base + bit == AMS_DELTA_GPIO_PIN_MODEM_NRESET)
+			regulator_toggle(&modem_priv, (value & bitpos) != 0);
+		else
+			gpio_set_value(base + bit, (value & bitpos) != 0);
 	}
 }
 EXPORT_SYMBOL(ams_delta_latch_write);
@@ -496,6 +563,12 @@ static int __init late_init(void)
 
 	platform_add_devices(late_devices, ARRAY_SIZE(late_devices));
 
+	err = platform_device_register(&modem_nreset_device);
+	if (err) {
+		pr_err("Couldn't register the modem regulator device\n");
+		return err;
+	}
+
 	omap_cfg_reg(M14_1510_GPIO2);
 	ams_delta_modem_ports[0].irq =
 			gpio_to_irq(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
@@ -507,6 +580,10 @@ static int __init late_init(void)
 	}
 	gpio_direction_input(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
 
+	/* Initialize the modem_nreset regulator consumer before use */
+	mutex_init(&modem_priv.consumer.lock);
+	modem_priv.regulator = ERR_PTR(-ENODEV);
+
 	ams_delta_latch2_write(
 		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
 		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
@@ -514,8 +591,23 @@ static int __init late_init(void)
 	err = platform_device_register(&ams_delta_modem_device);
 	if (err)
 		goto gpio_free;
+
+	/*
+	 * Once the modem device is registered, the modem_nreset
+	 * regulator can be requested on behalf of that device.
+	 * The regulator is used via ams_delta_latch_write()
+	 * by the modem and ASoC drivers until updated.
+	 */
+	modem_priv.regulator = regulator_get(&ams_delta_modem_device.dev,
+			"RESET#");
+	if (IS_ERR(modem_priv.regulator)) {
+		err = PTR_ERR(modem_priv.regulator);
+		goto unregister;
+	}
 	return 0;
 
+unregister:
+	platform_device_unregister(&ams_delta_modem_device);
 gpio_free:
 	gpio_free(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
 	return err;
-- 
1.7.3.4

