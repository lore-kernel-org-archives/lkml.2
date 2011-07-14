Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1GNT75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:59:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1GNT7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:59:43 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 3/3] mcp23s08: add i2c support
Date: Thu, 14 Jul 2011 21:59:28 +0200
Message-Id: <1310673568-30577-4-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c bindings for the mcp230xx devices. This is quite a lot simpler
than the spi ones as there's no funky sub addressing done (one struct
i2c_client per struct gpio_chip).

The mcp23s08_platform_data structure is reused for i2c, even though
only a single mcp23s08_chip_info structure is needed.

To make the platform data bus independent, the setup/teardown prototypes
are slightly changed, so the bus specific struct (spi_device / i2c_client)
is passed as a void pointer instead.

There's no in-tree users of these callbacks.

To use, simply fill out a platform_data structure and pass it in
i2c_board_info, E.G.:

static const struct mcp23s08_platform_data mcp23017_data = {
	.chip[0] = {
		.pullups = 0x00ff,
	},
	.base = 240,
};

static struct i2c_board_info __initdata i2c_devs[] = {
	{ I2C_BOARD_INFO("mcp23017", 0x20),
	  .platform_data = &smartview_mcp23017_data, },
	...
};

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/gpio/Kconfig         |    7 +-
 drivers/gpio/mcp23s08.c      |  184 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/mcp23s08.h |    4 +-
 3 files changed, 186 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2967002..cf8a491 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -398,10 +398,11 @@ config GPIO_MAX7301
 	  GPIO driver for Maxim MAX7301 SPI-based GPIO expander.
 
 config GPIO_MCP23S08
-	tristate "Microchip MCP23Sxx I/O expander"
-	depends on SPI_MASTER
+	tristate "Microchip MCP23xxx I/O expander"
+	depends on SPI_MASTER || I2C
 	help
-	  SPI driver for Microchip MCP23S08/MPC23S17 I/O expanders.
+	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
+	  I/O expanders.
 	  This provides a GPIO interface supporting inputs and outputs.
 
 config GPIO_MC33880
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index 1494347..5914018 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -1,11 +1,12 @@
 /*
- * mcp23s08.c - SPI gpio expander driver
+ * mcp23s08.c - SPI/I2C gpio expander driver
  */
 
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/gpio.h>
+#include <linux/i2c.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/mcp23s08.h>
 #include <linux/slab.h>
@@ -16,13 +17,13 @@
  */
 #define MCP_TYPE_S08	0
 #define MCP_TYPE_S17	1
+#define MCP_TYPE_008	2
+#define MCP_TYPE_017	3
 
 /* Registers are all 8 bits wide.
  *
  * The mcp23s17 has twice as many bits, and can be configured to work
  * with either 16 bit registers or with two adjacent 8 bit banks.
- *
- * Also, there are I2C versions of both chips.
  */
 #define MCP_IODIR	0x00		/* init/reset:  all ones */
 #define MCP_IPOL	0x01
@@ -73,6 +74,72 @@ struct mcp23s08_driver_data {
 	struct mcp23s08		chip[];
 };
 
+/*----------------------------------------------------------------------*/
+
+#ifdef CONFIG_I2C
+
+static int mcp23008_read(struct mcp23s08 *mcp, unsigned reg)
+{
+	return i2c_smbus_read_byte_data(mcp->data, reg);
+}
+
+static int mcp23008_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
+{
+	return i2c_smbus_write_byte_data(mcp->data, reg, val);
+}
+
+static int
+mcp23008_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
+{
+	while (n--) {
+		int ret = mcp23008_read(mcp, reg++);
+		if (ret < 0)
+			return ret;
+		*vals++ = ret;
+	}
+
+	return 0;
+}
+
+static int mcp23017_read(struct mcp23s08 *mcp, unsigned reg)
+{
+	return i2c_smbus_read_word_data(mcp->data, reg << 1);
+}
+
+static int mcp23017_write(struct mcp23s08 *mcp, unsigned reg, unsigned val)
+{
+	return i2c_smbus_write_word_data(mcp->data, reg << 1, val);
+}
+
+static int
+mcp23017_read_regs(struct mcp23s08 *mcp, unsigned reg, u16 *vals, unsigned n)
+{
+	while (n--) {
+		int ret = mcp23017_read(mcp, reg++);
+		if (ret < 0)
+			return ret;
+		*vals++ = ret;
+	}
+
+	return 0;
+}
+
+static const struct mcp23s08_ops mcp23008_ops = {
+	.read		= mcp23008_read,
+	.write		= mcp23008_write,
+	.read_regs	= mcp23008_read_regs,
+};
+
+static const struct mcp23s08_ops mcp23017_ops = {
+	.read		= mcp23017_read,
+	.write		= mcp23017_write,
+	.read_regs	= mcp23017_read_regs,
+};
+
+#endif /* CONFIG_I2C */
+
+/*----------------------------------------------------------------------*/
+
 #ifdef CONFIG_SPI_MASTER
 
 static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
@@ -331,6 +398,20 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
 		break;
 #endif /* CONFIG_SPI_MASTER */
 
+#ifdef CONFIG_I2C
+	case MCP_TYPE_008:
+		mcp->ops = &mcp23008_ops;
+		mcp->chip.ngpio = 8;
+		mcp->chip.label = "mcp23008";
+		break;
+
+	case MCP_TYPE_017:
+		mcp->ops = &mcp23017_ops;
+		mcp->chip.ngpio = 16;
+		mcp->chip.label = "mcp23017";
+		break;
+#endif /* CONFIG_I2C */
+
 	default:
 		dev_err(dev, "invalid device type (%d)\n", type);
 		return -EINVAL;
@@ -389,6 +470,93 @@ fail:
 	return status;
 }
 
+/*----------------------------------------------------------------------*/
+
+#ifdef CONFIG_I2C
+
+static int __devinit mcp230xx_probe(struct i2c_client *client,
+				    const struct i2c_device_id *id)
+{
+	struct mcp23s08_platform_data *pdata;
+	struct mcp23s08 *mcp;
+	int status;
+
+	pdata = client->dev.platform_data;
+	if (!pdata || !gpio_is_valid(pdata->base)) {
+		dev_dbg(&client->dev, "invalid or missing platform data\n");
+		return -EINVAL;
+	}
+
+	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
+	if (!mcp)
+		return -ENOMEM;
+
+	status = mcp23s08_probe_one(mcp, &client->dev, client, client->addr,
+				    id->driver_data, pdata->base,
+				    pdata->chip[0].pullups);
+	if (status)
+		goto fail;
+
+	i2c_set_clientdata(client, mcp);
+
+	if (pdata->setup) {
+		status = pdata->setup(client, pdata->base, mcp->chip.ngpio,
+				      pdata->context);
+		if (status < 0)
+			dev_dbg(&client->dev, "setup --> %d\n", status);
+	}
+
+	return 0;
+
+fail:
+	kfree(mcp);
+
+	return status;
+}
+
+static int __devexit mcp230xx_remove(struct i2c_client *client)
+{
+	struct mcp23s08_platform_data *pdata = client->dev.platform_data;
+	struct mcp23s08 *mcp = i2c_get_clientdata(client);
+	int status;
+
+	if (pdata->teardown) {
+		status = pdata->teardown(client, pdata->base, mcp->chip.ngpio,
+					 pdata->context);
+		if (status < 0) {
+			dev_err(&client->dev, "teardown --> %d\n", status);
+			return status;
+		}
+	}
+
+	status = gpiochip_remove(&mcp->chip);
+	if (status == 0)
+		kfree(mcp);
+
+	return status;
+}
+
+static const struct i2c_device_id mcp230xx_id[] = {
+	{ "mcp23008", MCP_TYPE_008 },
+	{ "mcp23017", MCP_TYPE_017 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, mcp230xx_id);
+
+static struct i2c_driver mcp230xx_driver = {
+	.driver = {
+		.name	= "mcp230xx",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mcp230xx_probe,
+	.remove		= __devexit_p(mcp230xx_remove),
+	.id_table	= mcp230xx_id,
+};
+
+#endif /* CONFIG_I2C */
+
+/*----------------------------------------------------------------------*/
+
 #ifdef CONFIG_SPI_MASTER
 
 static int mcp23s08_probe(struct spi_device *spi)
@@ -537,9 +705,13 @@ static int __init mcp23s08_init(void)
 		return ret;
 #endif /* CONFIG_SPI_MASTER */
 
+#ifdef CONFIG_I2C
+	ret = i2c_add_driver(&mcp230xx_driver);
+#endif /* CONFIG_I2C */
+
 	return ret;
 }
-/* register after spi postcore initcall and before
+/* register after spi/i2c postcore initcall and before
  * subsys initcalls that may rely on these GPIOs
  */
 subsys_initcall(mcp23s08_init);
@@ -550,6 +722,10 @@ static void __exit mcp23s08_exit(void)
 	spi_unregister_driver(&mcp23s08_driver);
 #endif /* CONFIG_SPI_MASTER */
 
+#ifdef CONFIG_I2C
+	i2c_del_driver(&mcp230xx_driver);
+#endif /* CONFIG_I2C */
+
 }
 module_exit(mcp23s08_exit);
 
diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
index c42cff8..2eb4fc1 100644
--- a/include/linux/spi/mcp23s08.h
+++ b/include/linux/spi/mcp23s08.h
@@ -25,10 +25,10 @@ struct mcp23s08_platform_data {
 
 	void		*context;	/* param to setup/teardown */
 
-	int		(*setup)(struct spi_device *spi,
+	int		(*setup)(void *data,
 					int gpio, unsigned ngpio,
 					void *context);
-	int		(*teardown)(struct spi_device *spi,
+	int		(*teardown)(void *data,
 					int gpio, unsigned ngpio,
 					void *context);
 };
-- 
1.7.5.4

