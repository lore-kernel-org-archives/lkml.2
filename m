Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0LIUfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:35:12 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33712 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756388Ab0LIUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:35:05 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: [RFC][PATCH v2 3/3] spi-gpio: use _cansleep when CONFIG_SLOWER_SPI_GPIO is defined
Date: Thu,  9 Dec 2010 15:34:56 -0500
Message-Id: <986eb10f4a662940f631235efa4b679acdcdab80.1291925752.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291925752.git.bengardiner@nanometrics.ca>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca> <cover.1291925752.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When users have elected to enable delays in the spi-gpio driver, use the
_cansleep variant of gpio_set_value. This allows the use of GPIOs on an
IO expander.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>

---

changes since v1:
 * none; new in v2

I was testing the slowed-down spio-gpio driver on a I2C pca953x expander
when I noticed the WARNs that the spio-gpio driver was calling into the
I2C expander drivers gpio_set functions without using the _cansleep
variant. This patch removes all the warnings except for one on startup
when the spi-gpio instance is registered:

BUG: scheduling while atomic: swapper/1/0x00000002
Modules linked in:
[<c002f79c>] (unwind_backtrace+0x0/0xec) from [<c02859f8>] (schedule+0x74/0x408)
[<c02859f8>] (schedule+0x74/0x408) from [<c028653c>] (schedule_timeout+0x1d4/0x214)
[<c028653c>] (schedule_timeout+0x1d4/0x214) from [<c02861f4>] (wait_for_common+0xf0/0x1b8)
[<c02861f4>] (wait_for_common+0xf0/0x1b8) from [<c01e8c50>] (i2c_davinci_xfer+0x1ec/0x304)
[<c01e8c50>] (i2c_davinci_xfer+0x1ec/0x304) from [<c01e6e40>] (i2c_transfer+0xc4/0x120)
[<c01e6e40>] (i2c_transfer+0xc4/0x120) from [<c01e72dc>] (i2c_smbus_xfer+0x3ac/0x4ec)
[<c01e72dc>] (i2c_smbus_xfer+0x3ac/0x4ec) from [<c01e7610>] (i2c_smbus_write_word_data+0x38/0x40)
[<c01e7610>] (i2c_smbus_write_word_data+0x38/0x40) from [<c018a8ec>] (pca953x_write_reg+0x38/0x64)
[<c018a8ec>] (pca953x_write_reg+0x38/0x64) from [<c018a954>] (pca953x_gpio_set_value+0x3c/0x48)
[<c018a954>] (pca953x_gpio_set_value+0x3c/0x48) from [<c0189868>] (gpio_set_value_cansleep+0x30/0x38)
[<c0189868>] (gpio_set_value_cansleep+0x30/0x38) from [<c01d81d8>] (spi_bitbang_setup+0xb4/0x104)
[<c01d81d8>] (spi_bitbang_setup+0xb4/0x104) from [<c01d88d4>] (spi_gpio_setup+0x6c/0xa0)
[<c01d88d4>] (spi_gpio_setup+0x6c/0xa0) from [<c01d74d4>] (spi_setup+0x48/0x50)
[<c01d74d4>] (spi_setup+0x48/0x50) from [<c01d7754>] (spi_add_device+0xa0/0x118)
[<c01d7754>] (spi_add_device+0xa0/0x118) from [<c01d784c>] (spi_new_device+0x80/0xa4)
[<c01d784c>] (spi_new_device+0x80/0xa4) from [<c01d7890>] (spi_match_master_to_boardinfo+0x20/0x40)
[<c01d7890>] (spi_match_master_to_boardinfo+0x20/0x40) from [<c01d7974>] (spi_register_master+0xc4/0x10c)
[<c01d7974>] (spi_register_master+0xc4/0x10c) from [<c01d7d54>] (spi_bitbang_start+0x11c/0x154)
[<c01d7d54>] (spi_bitbang_start+0x11c/0x154) from [<c001b640>] (spi_gpio_probe+0x1ac/0x23c)
[<c001b640>] (spi_gpio_probe+0x1ac/0x23c) from [<c01be7d8>] (platform_drv_probe+0x18/0x1c)
[<c01be7d8>] (platform_drv_probe+0x18/0x1c) from [<c01bd950>] (driver_probe_device+0xb0/0x16c)
[<c01bd950>] (driver_probe_device+0xb0/0x16c) from [<c01bda6c>] (__driver_attach+0x60/0x84)
[<c01bda6c>] (__driver_attach+0x60/0x84) from [<c01bd194>] (bus_for_each_dev+0x44/0x74)
[<c01bd194>] (bus_for_each_dev+0x44/0x74) from [<c01bcae4>] (bus_add_driver+0xa8/0x228)
[<c01bcae4>] (bus_add_driver+0xa8/0x228) from [<c01bdd3c>] (driver_register+0xa8/0x134)
[<c01bdd3c>] (driver_register+0xa8/0x134) from [<c01bea44>] (platform_driver_probe+0x18/0x98)
[<c01bea44>] (platform_driver_probe+0x18/0x98) from [<c002a430>] (do_one_initcall+0xc8/0x1a4)
[<c002a430>] (do_one_initcall+0xc8/0x1a4) from [<c00083cc>] (kernel_init+0x94/0x14c)
[<c00083cc>] (kernel_init+0x94/0x14c) from [<c002b99c>] (kernel_thread_exit+0x0/0x8)
---
 drivers/spi/spi_gpio.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index b31fddd..537ce13 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -78,6 +78,12 @@ struct spi_gpio {
 
 #define GENERIC_BITBANG	/* vs tight inlines */
 
+#if defined(CONFIG_SLOWER_SPI_GPIO)
+#define spi_gpio_gpio_set_value gpio_set_value_cansleep
+#else
+#define spi_gpio_gpio_set_value gpio_set_value
+#endif
+
 /* all functions referencing these symbols must define pdata */
 #define SPI_MISO_GPIO	((pdata)->miso)
 #define SPI_MOSI_GPIO	((pdata)->mosi)
@@ -105,12 +111,12 @@ spi_to_pdata(const struct spi_device *spi)
 
 static inline void setsck(const struct spi_device *spi, int is_on)
 {
-	gpio_set_value(SPI_SCK_GPIO, is_on);
+	spi_gpio_gpio_set_value(SPI_SCK_GPIO, is_on);
 }
 
 static inline void setmosi(const struct spi_device *spi, int is_on)
 {
-	gpio_set_value(SPI_MOSI_GPIO, is_on);
+	spi_gpio_gpio_set_value(SPI_MOSI_GPIO, is_on);
 }
 
 static inline int getmiso(const struct spi_device *spi)
@@ -222,7 +228,8 @@ static void spi_gpio_chipselect(struct spi_device *spi, int is_active)
 
 	if (cs != SPI_GPIO_NO_CHIPSELECT) {
 		/* SPI is normally active-low */
-		gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
+		spi_gpio_gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ?
+							is_active : !is_active);
 	}
 }
 
-- 
1.7.0.4

