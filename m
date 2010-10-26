Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab0JZUTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:19:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab0JZUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:18 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 12/12] davinci: add tnetv107x evm i2c eeprom device
Date: Tue, 26 Oct 2010 16:18:28 -0400
Message-Id: <1288124308-14999-13-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288124308-14999-1-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tnetv107x evm board has an I2C device connected on one of the SSP ports.
This patch adds board definitions for a GPIO based I2C master, as well as
definitions for the eeprom device on these boards.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   30 +++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index e7f413e..ff3d8dd 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -29,6 +29,9 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
+#include <linux/i2c.h>
+#include <linux/i2c/at24.h>
+#include <linux/i2c-gpio.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -45,6 +48,8 @@
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
 #define EVM_SPI_CS_GPIO		54
+#define EVM_I2C_SDA_GPIO	(SSP_GPIO_START + 0)
+#define EVM_I2C_SCL_GPIO	(SSP_GPIO_START + 1)
 #define EVM_BACKLIGHT_GPIO	(SSP_GPIO_START + 2)
 
 static int initialize_gpio(int gpio, char *desc)
@@ -367,6 +372,29 @@ static struct platform_device backlight_device = {
 	.dev.platform_data = (void *)EVM_BACKLIGHT_GPIO,
 };
 
+struct i2c_gpio_platform_data i2c_data = {
+	.sda_pin	= EVM_I2C_SDA_GPIO,
+	.scl_pin	= EVM_I2C_SCL_GPIO,
+};
+
+static struct platform_device i2c_device = {
+	.name		= "i2c-gpio",
+	.id		= 0,
+	.dev.platform_data = &i2c_data,
+};
+
+static struct at24_platform_data at24_config = {
+	.byte_len	= SZ_16K / 8,
+	.page_size	= 16,
+};
+
+static struct i2c_board_info i2c_info[] __initconst =  {
+	{
+		I2C_BOARD_INFO("24c16", 0x50),
+		.platform_data	= &at24_config,
+	},
+};
+
 static __init void tnetv107x_evm_board_init(void)
 {
 	davinci_cfg_reg_list(sdio1_pins);
@@ -376,8 +404,10 @@ static __init void tnetv107x_evm_board_init(void)
 	tnetv107x_devices_init(&evm_device_info);
 
 	platform_device_register(&backlight_device);
+	platform_device_register(&i2c_device);
 
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
+	i2c_register_board_info(0, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-- 
1.7.0.4

