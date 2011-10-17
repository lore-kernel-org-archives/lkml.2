Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1JQLxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1JQLxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/6] mach-ux500: pass parent pointer to each platform device
Date: Mon, 17 Oct 2011 12:52:53 +0100
Message-Id: <1318852378-14180-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a means for any device within ux500
platform code to allocate its own parent. This is particularly
prudent with the introduction of /sys/devices/socX, as a
device can now proclaim to be integral part of an SoC, rather
than a more generic platform device. Latter patches make good
use of this functionality.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-sdi.c   |   30 +++---
 arch/arm/mach-ux500/board-mop500.c       |   62 ++++++-----
 arch/arm/mach-ux500/board-mop500.h       |    6 +-
 arch/arm/mach-ux500/board-u5500-sdi.c    |    4 +-
 arch/arm/mach-ux500/board-u5500.c        |   23 +++--
 arch/arm/mach-ux500/cpu-db5500.c         |   18 ++--
 arch/arm/mach-ux500/cpu-db8500.c         |   16 ++--
 arch/arm/mach-ux500/devices-common.c     |   13 ++-
 arch/arm/mach-ux500/devices-common.h     |   39 ++++---
 arch/arm/mach-ux500/devices-db5500.h     |  116 ++++++++++++---------
 arch/arm/mach-ux500/devices-db8500.h     |  166 +++++++++++++++++-------------
 arch/arm/mach-ux500/dma-db5500.c         |    3 +-
 arch/arm/mach-ux500/include/mach/setup.h |    4 +-
 arch/arm/mach-ux500/include/mach/usb.h   |    4 +-
 arch/arm/mach-ux500/usb.c                |    4 +-
 15 files changed, 286 insertions(+), 222 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 6826fae..a36f00d 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -98,7 +98,7 @@ static struct mmci_platform_data mop500_sdi0_data = {
 #endif
 };
 
-static void sdi0_configure(void)
+static void sdi0_configure(struct device *parent)
 {
 	int ret;
 
@@ -118,17 +118,17 @@ static void sdi0_configure(void)
 
 	/* Add the device, force v2 to subrevision 1 */
 	if (cpu_is_u8500v2())
-		db8500_add_sdi0(&mop500_sdi0_data, 0x10480180);
+		db8500_add_sdi0(parent, &mop500_sdi0_data, 0x10480180);
 	else
-		db8500_add_sdi0(&mop500_sdi0_data, 0);
+		db8500_add_sdi0(parent, &mop500_sdi0_data, 0);
 }
 
-void mop500_sdi_tc35892_init(void)
+void mop500_sdi_tc35892_init(struct device *parent)
 {
 	mop500_sdi0_data.gpio_cd = GPIO_SDMMC_CD;
 	sdi0_en = GPIO_SDMMC_EN;
 	sdi0_vsel = GPIO_SDMMC_1V8_3V_SEL;
-	sdi0_configure();
+	sdi0_configure(parent);
 }
 
 /*
@@ -206,7 +206,7 @@ static struct mmci_platform_data mop500_sdi4_data = {
 #endif
 };
 
-void __init mop500_sdi_init(void)
+void __init mop500_sdi_init(struct device *parent)
 {
 	u32 periphid = 0;
 
@@ -217,10 +217,10 @@ void __init mop500_sdi_init(void)
 	if (!cpu_is_u8500v10())
 		mop500_sdi2_data.capabilities |= MMC_CAP_MMC_HIGHSPEED;
 
-	db8500_add_sdi2(&mop500_sdi2_data, periphid);
+	db8500_add_sdi2(parent, &mop500_sdi2_data, periphid);
 
 	/* On-board eMMC */
-	db8500_add_sdi4(&mop500_sdi4_data, periphid);
+	db8500_add_sdi4(parent, &mop500_sdi4_data, periphid);
 
 	/*
 	 * On boards with the TC35892 GPIO expander, sdi0 will finally
@@ -229,35 +229,35 @@ void __init mop500_sdi_init(void)
 	 */
 }
 
-void __init snowball_sdi_init(void)
+void __init snowball_sdi_init(struct device *parent)
 {
 	u32 periphid = 0x10480180;
 
 	mop500_sdi2_data.capabilities |= MMC_CAP_MMC_HIGHSPEED;
 
 	/* On-board eMMC */
-	db8500_add_sdi4(&mop500_sdi4_data, periphid);
+	db8500_add_sdi4(parent, &mop500_sdi4_data, periphid);
 
 	mop500_sdi0_data.gpio_cd = SNOWBALL_SDMMC_CD_GPIO;
 	mop500_sdi0_data.cd_invert = true;
 	sdi0_en = SNOWBALL_SDMMC_EN_GPIO;
 	sdi0_vsel = SNOWBALL_SDMMC_1V8_3V_GPIO;
-	sdi0_configure();
+	sdi0_configure(parent);
 }
 
-void __init hrefv60_sdi_init(void)
+void __init hrefv60_sdi_init(struct device *parent)
 {
 	u32 periphid = 0x10480180;
 
 	mop500_sdi2_data.capabilities |= MMC_CAP_MMC_HIGHSPEED;
 
-	db8500_add_sdi2(&mop500_sdi2_data, periphid);
+	db8500_add_sdi2(parent, &mop500_sdi2_data, periphid);
 
 	/* On-board eMMC */
-	db8500_add_sdi4(&mop500_sdi4_data, periphid);
+	db8500_add_sdi4(parent, &mop500_sdi4_data, periphid);
 
 	mop500_sdi0_data.gpio_cd = HREFV60_SDMMC_CD_GPIO;
 	sdi0_en = HREFV60_SDMMC_EN_GPIO;
 	sdi0_vsel = HREFV60_SDMMC_1V8_3V_GPIO;
-	sdi0_configure();
+	sdi0_configure(parent);
 }
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 4d75b0d..2d4a7de 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -224,7 +224,12 @@ static struct tps6105x_platform_data mop500_tps61052_data = {
 
 static void mop500_tc35892_init(struct tc3589x *tc3589x, unsigned int base)
 {
-	mop500_sdi_tc35892_init();
+	struct device *parent = NULL;
+#if 0
+	/* FIXME: Is the sdi actually part of tc3589x? */
+	parent = tc3589x->dev;
+#endif
+	mop500_sdi_tc35892_init(parent);
 }
 
 static struct tc3589x_gpio_platform_data mop500_tc35892_gpio_data = {
@@ -351,12 +356,12 @@ U8500_I2C_CONTROLLER(1, 0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
 U8500_I2C_CONTROLLER(2,	0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
 U8500_I2C_CONTROLLER(3,	0xe, 1, 8, 100000, 200, I2C_FREQ_MODE_FAST);
 
-static void __init mop500_i2c_init(void)
+static void __init mop500_i2c_init(struct device *parent)
 {
-	db8500_add_i2c0(&u8500_i2c0_data);
-	db8500_add_i2c1(&u8500_i2c1_data);
-	db8500_add_i2c2(&u8500_i2c2_data);
-	db8500_add_i2c3(&u8500_i2c3_data);
+	db8500_add_i2c0(parent, &u8500_i2c0_data);
+	db8500_add_i2c1(parent, &u8500_i2c1_data);
+	db8500_add_i2c2(parent, &u8500_i2c2_data);
+	db8500_add_i2c3(parent, &u8500_i2c3_data);
 }
 
 static struct gpio_keys_button mop500_gpio_keys[] = {
@@ -449,9 +454,9 @@ static struct pl022_ssp_controller ssp0_platform_data = {
 	.num_chipselect = 5,
 };
 
-static void __init mop500_spi_init(void)
+static void __init mop500_spi_init(struct device *parent)
 {
-	db8500_add_ssp0(&ssp0_platform_data);
+	db8500_add_ssp0(parent, &ssp0_platform_data);
 }
 
 #ifdef CONFIG_STE_DMA40
@@ -585,11 +590,11 @@ static struct amba_pl011_data uart2_plat = {
 #endif
 };
 
-static void __init mop500_uart_init(void)
+static void __init mop500_uart_init(struct device *parent)
 {
-	db8500_add_uart0(&uart0_plat);
-	db8500_add_uart1(&uart1_plat);
-	db8500_add_uart2(&uart2_plat);
+	db8500_add_uart0(parent, &uart0_plat);
+	db8500_add_uart1(parent, &uart1_plat);
+	db8500_add_uart2(parent, &uart2_plat);
 }
 
 static struct platform_device *snowball_platform_devs[] __initdata = {
@@ -601,21 +606,22 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
 
 static void __init mop500_init_machine(void)
 {
+	struct device *parent = NULL;
 	int i2c0_devs;
 
 	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
 
-	u8500_init_devices();
+	parent = u8500_init_devices();
 
 	mop500_pins_init();
 
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
-	mop500_i2c_init();
-	mop500_sdi_init();
-	mop500_spi_init();
-	mop500_uart_init();
+	mop500_i2c_init(parent);
+	mop500_sdi_init(parent);
+	mop500_spi_init(parent);
+	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 
@@ -629,19 +635,20 @@ static void __init mop500_init_machine(void)
 
 static void __init snowball_init_machine(void)
 {
+	struct device *parent = NULL;
 	int i2c0_devs;
 
-	u8500_init_devices();
+	parent = u8500_init_devices();
 
 	snowball_pins_init();
 
 	platform_add_devices(snowball_platform_devs,
 			ARRAY_SIZE(snowball_platform_devs));
 
-	mop500_i2c_init();
-	snowball_sdi_init();
-	mop500_spi_init();
-	mop500_uart_init();
+	mop500_i2c_init(parent);
+	snowball_sdi_init(parent);
+	mop500_spi_init(parent);
+	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
@@ -654,6 +661,7 @@ static void __init snowball_init_machine(void)
 
 static void __init hrefv60_init_machine(void)
 {
+	struct device *parent = NULL;
 	int i2c0_devs;
 
 	/*
@@ -663,17 +671,17 @@ static void __init hrefv60_init_machine(void)
 	 */
 	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
 
-	u8500_init_devices();
+	parent = u8500_init_devices();
 
 	hrefv60_pins_init();
 
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
-	mop500_i2c_init();
-	mop500_sdi_init();
-	mop500_spi_init();
-	mop500_uart_init();
+	mop500_i2c_init(parent);
+	mop500_sdi_init(parent);
+	mop500_spi_init(parent);
+	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index de18a2a..d011da2 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -39,9 +39,9 @@
 
 struct i2c_board_info;
 
-extern void mop500_sdi_init(void);
-extern void snowball_sdi_init(void);
-extern void mop500_sdi_tc35892_init(void);
+extern void mop500_sdi_init(struct device *parent);
+extern void snowball_sdi_init(struct device *parent);
+extern void mop500_sdi_tc35892_init(struct device *parent);
 void __init mop500_u8500uib_init(void);
 void __init mop500_stuib_init(void);
 void __init mop500_pins_init(void);
diff --git a/arch/arm/mach-ux500/board-u5500-sdi.c b/arch/arm/mach-ux500/board-u5500-sdi.c
index 739fb4c..3c70e97 100644
--- a/arch/arm/mach-ux500/board-u5500-sdi.c
+++ b/arch/arm/mach-ux500/board-u5500-sdi.c
@@ -66,9 +66,9 @@ static struct mmci_platform_data u5500_sdi0_data = {
 #endif
 };
 
-void __init u5500_sdi_init(void)
+void __init u5500_sdi_init(struct device *parent)
 {
 	nmk_config_pins(u5500_sdi_pins, ARRAY_SIZE(u5500_sdi_pins));
 
-	db5500_add_sdi0(&u5500_sdi0_data);
+	db5500_add_sdi0(parent, &u5500_sdi0_data);
 }
diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 5c9e665..3196b40a 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -96,9 +96,9 @@ static struct i2c_board_info __initdata u5500_i2c2_devices[] = {
 	},
 };
 
-static void __init u5500_i2c_init(void)
+static void __init u5500_i2c_init(struct device *parent)
 {
-	db5500_add_i2c2(&u5500_i2c2_data);
+	db5500_add_i2c2(parent, &u5500_i2c2_data);
 	i2c_register_board_info(2, ARRAY_AND_SIZE(u5500_i2c2_devices));
 }
 
@@ -125,20 +125,23 @@ static struct platform_device *u5500_platform_devices[] __initdata = {
 	&ab5500_device,
 };
 
-static void __init u5500_uart_init(void)
+static void __init u5500_uart_init(struct device *parent)
 {
-	db5500_add_uart0(NULL);
-	db5500_add_uart1(NULL);
-	db5500_add_uart2(NULL);
+	db5500_add_uart0(parent, NULL);
+	db5500_add_uart1(parent, NULL);
+	db5500_add_uart2(parent, NULL);
 }
 
 static void __init u5500_init_machine(void)
 {
-	u5500_init_devices();
+	struct device *parent = NULL;
+
+	parent = u5500_init_devices();
 	nmk_config_pins(u5500_pins, ARRAY_SIZE(u5500_pins));
-	u5500_i2c_init();
-	u5500_sdi_init();
-	u5500_uart_init();
+
+	u5500_i2c_init(parent);
+	u5500_sdi_init(parent);
+	u5500_uart_init(parent);
 
 	platform_add_devices(u5500_platform_devices,
 		ARRAY_SIZE(u5500_platform_devices));
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index e532c32..3995284 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -174,13 +174,13 @@ static resource_size_t __initdata db5500_gpio_base[] = {
 	U5500_GPIOBANK7_BASE,
 };
 
-static void __init db5500_add_gpios(void)
+static void __init db5500_add_gpios(struct device *parent)
 {
 	struct nmk_gpio_platform_data pdata = {
 		/* No custom data yet */
 	};
 
-	dbx500_add_gpios(ARRAY_AND_SIZE(db5500_gpio_base),
+	dbx500_add_gpios(parent, ARRAY_AND_SIZE(db5500_gpio_base),
 			 IRQ_DB5500_GPIO0, &pdata);
 }
 
@@ -220,13 +220,17 @@ static int usb_db5500_tx_dma_cfg[] = {
 	DB5500_DMA_DEV38_USB_OTG_OEP_8
 };
 
-void __init u5500_init_devices(void)
+struct device* __init u5500_init_devices(void)
 {
-	db5500_add_gpios();
-	db5500_dma_init();
-	db5500_add_rtc();
-	db5500_add_usb(usb_db5500_rx_dma_cfg, usb_db5500_tx_dma_cfg);
+	/* FIXME: First parameter to be a real parent. */
+	db5500_add_gpios(NULL);
+	db5500_dma_init(NULL);
+	db5500_add_rtc(NULL);
+	db5500_add_usb(NULL, usb_db5500_rx_dma_cfg, usb_db5500_tx_dma_cfg);
 
 	platform_add_devices(db5500_platform_devs,
 			     ARRAY_SIZE(db5500_platform_devs));
+
+	/* FIXME: Return value to be a real parent. */
+	return NULL;
 }
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 4598b06..375171e 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -153,7 +153,7 @@ static resource_size_t __initdata db8500_gpio_base[] = {
 	U8500_GPIOBANK8_BASE,
 };
 
-static void __init db8500_add_gpios(void)
+static void __init db8500_add_gpios(struct device *parent)
 {
 	struct nmk_gpio_platform_data pdata = {
 		/* No custom data yet */
@@ -162,7 +162,7 @@ static void __init db8500_add_gpios(void)
 	if (cpu_is_u8500v2())
 		pdata.supports_sleepmode = true;
 
-	dbx500_add_gpios(ARRAY_AND_SIZE(db8500_gpio_base),
+	dbx500_add_gpios(parent, ARRAY_AND_SIZE(db8500_gpio_base),
 			 IRQ_DB8500_GPIO0, &pdata);
 }
 
@@ -191,17 +191,19 @@ static int usb_db8500_tx_dma_cfg[] = {
 /*
  * This function is called from the board init
  */
-void __init u8500_init_devices(void)
+struct device* __init u8500_init_devices(void)
 {
 	if (cpu_is_u8500ed())
 		dma40_u8500ed_fixup();
 
-	db8500_add_rtc();
-	db8500_add_gpios();
-	db8500_add_usb(usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
+	/* FIXME: First parameter to be a real parent. */
+	db8500_add_rtc(NULL);
+	db8500_add_gpios(NULL);
+	db8500_add_usb(NULL, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
 
 	platform_device_register_simple("cpufreq-u8500", -1, NULL, 0);
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
-	return ;
+	/* FIXME: Return value to be a real parent. */
+	return NULL;
 }
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index 13a4ce0..51fd658 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -20,8 +20,9 @@
 #include "devices-common.h"
 
 struct amba_device *
-dbx500_add_amba_device(const char *name, resource_size_t base,
-		       int irq, void *pdata, unsigned int periphid)
+dbx500_add_amba_device(struct device *parent, const char *name,
+		       resource_size_t base, int irq, void *pdata,
+		       unsigned int periphid)
 {
 	struct amba_device *dev;
 	int ret;
@@ -109,7 +110,7 @@ dbx500_add_platform_device_4k1irq(const char *name, int id,
 }
 
 static struct platform_device *
-dbx500_add_gpio(int id, resource_size_t addr, int irq,
+dbx500_add_gpio(struct device *parent, int id, resource_size_t addr, int irq,
 		struct nmk_gpio_platform_data *pdata)
 {
 	struct resource resources[] = {
@@ -130,8 +131,8 @@ dbx500_add_gpio(int id, resource_size_t addr, int irq,
 				pdata, sizeof(*pdata));
 }
 
-void dbx500_add_gpios(resource_size_t *base, int num, int irq,
-		      struct nmk_gpio_platform_data *pdata)
+void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
+		      int irq, struct nmk_gpio_platform_data *pdata)
 {
 	int first = 0;
 	int i;
@@ -141,6 +142,6 @@ void dbx500_add_gpios(resource_size_t *base, int num, int irq,
 		pdata->first_irq = NOMADIK_GPIO_TO_IRQ(first);
 		pdata->num_gpio = 32;
 
-		dbx500_add_gpio(i, base[i], irq, pdata);
+		dbx500_add_gpio(parent, i, base[i], irq, pdata);
 	}
 }
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 7825705..f8adff8 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -9,7 +9,7 @@
 #define __DEVICES_COMMON_H
 
 extern struct amba_device *
-dbx500_add_amba_device(const char *name, resource_size_t base,
+dbx500_add_amba_device(struct device *parent, const char *name, resource_size_t base,
 		       int irq, void *pdata, unsigned int periphid);
 
 extern struct platform_device *
@@ -20,43 +20,46 @@ dbx500_add_platform_device_4k1irq(const char *name, int id,
 struct spi_master_cntlr;
 
 static inline struct amba_device *
-dbx500_add_msp_spi(const char *name, resource_size_t base, int irq,
+dbx500_add_msp_spi(struct device *parent, const char *name,
+		   resource_size_t base, int irq,
 		   struct spi_master_cntlr *pdata)
 {
-	return dbx500_add_amba_device(name, base, irq, pdata, 0);
+	return dbx500_add_amba_device(parent, name, base, irq,
+				      pdata, 0);
 }
 
 static inline struct amba_device *
-dbx500_add_spi(const char *name, resource_size_t base, int irq,
-	       struct spi_master_cntlr *pdata,
+dbx500_add_spi(struct device *parent, const char *name, resource_size_t base,
+	       int irq, struct spi_master_cntlr *pdata,
 	       u32 periphid)
 {
-	return dbx500_add_amba_device(name, base, irq, pdata, periphid);
+	return dbx500_add_amba_device(parent, name, base, irq,
+				      pdata, periphid);
 }
 
 struct mmci_platform_data;
 
 static inline struct amba_device *
-dbx500_add_sdi(const char *name, resource_size_t base, int irq,
-	       struct mmci_platform_data *pdata,
-	       u32 periphid)
+dbx500_add_sdi(struct device *parent, const char *name, resource_size_t base,
+	       int irq, struct mmci_platform_data *pdata, u32 periphid)
 {
-	return dbx500_add_amba_device(name, base, irq, pdata, periphid);
+	return dbx500_add_amba_device(parent, name, base, irq,
+				      pdata, periphid);
 }
 
 struct amba_pl011_data;
 
 static inline struct amba_device *
-dbx500_add_uart(const char *name, resource_size_t base, int irq,
-		struct amba_pl011_data *pdata)
+dbx500_add_uart(struct device *parent, const char *name, resource_size_t base,
+		int irq, struct amba_pl011_data *pdata)
 {
-	return dbx500_add_amba_device(name, base, irq, pdata, 0);
+	return dbx500_add_amba_device(parent, name, base, irq, pdata, 0);
 }
 
 struct nmk_i2c_controller;
 
 static inline struct platform_device *
-dbx500_add_i2c(int id, resource_size_t base, int irq,
+dbx500_add_i2c(struct device *parent, int id, resource_size_t base, int irq,
 	       struct nmk_i2c_controller *pdata)
 {
 	return dbx500_add_platform_device_4k1irq("nmk-i2c", id, base, irq,
@@ -74,14 +77,14 @@ dbx500_add_msp_i2s(int id, resource_size_t base, int irq,
 }
 
 static inline struct amba_device *
-dbx500_add_rtc(resource_size_t base, int irq)
+dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
 {
-	return dbx500_add_amba_device("rtc-pl031", base, irq, NULL, 0);
+	return dbx500_add_amba_device(parent, "rtc-pl031", base, irq, NULL, 0);
 }
 
 struct nmk_gpio_platform_data;
 
-void dbx500_add_gpios(resource_size_t *base, int num, int irq,
-		      struct nmk_gpio_platform_data *pdata);
+void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
+		      int irq, struct nmk_gpio_platform_data *pdata);
 
 #endif
diff --git a/arch/arm/mach-ux500/devices-db5500.h b/arch/arm/mach-ux500/devices-db5500.h
index 0c4bccd..e709555 100644
--- a/arch/arm/mach-ux500/devices-db5500.h
+++ b/arch/arm/mach-ux500/devices-db5500.h
@@ -10,70 +10,90 @@
 
 #include "devices-common.h"
 
-#define db5500_add_i2c1(pdata) \
-	dbx500_add_i2c(1, U5500_I2C1_BASE, IRQ_DB5500_I2C1, pdata)
-#define db5500_add_i2c2(pdata) \
-	dbx500_add_i2c(2, U5500_I2C2_BASE, IRQ_DB5500_I2C2, pdata)
-#define db5500_add_i2c3(pdata) \
-	dbx500_add_i2c(3, U5500_I2C3_BASE, IRQ_DB5500_I2C3, pdata)
+#define db5500_add_i2c1(parent, pdata) \
+	dbx500_add_i2c(parent, 1, U5500_I2C1_BASE, IRQ_DB5500_I2C1, pdata)
+#define db5500_add_i2c2(parent, pdata) \
+	dbx500_add_i2c(parent, 2, U5500_I2C2_BASE, IRQ_DB5500_I2C2, pdata)
+#define db5500_add_i2c3(parent, pdata) \
+	dbx500_add_i2c(parent, 3, U5500_I2C3_BASE, IRQ_DB5500_I2C3, pdata)
 
-#define db5500_add_msp0_i2s(pdata) \
-	dbx500_add_msp_i2s(0, U5500_MSP0_BASE, IRQ_DB5500_MSP0, pdata)
-#define db5500_add_msp1_i2s(pdata) \
-	dbx500_add_msp_i2s(1, U5500_MSP1_BASE, IRQ_DB5500_MSP1, pdata)
-#define db5500_add_msp2_i2s(pdata) \
-	dbx500_add_msp_i2s(2, U5500_MSP2_BASE, IRQ_DB5500_MSP2, pdata)
+#define db5500_add_msp0_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp0", U5500_MSP0_BASE, \
+			   IRQ_DB5500_MSP0, pdata)
+#define db5500_add_msp1_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp1", U5500_MSP1_BASE, \
+			   IRQ_DB5500_MSP1, pdata)
+#define db5500_add_msp2_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp2", U5500_MSP2_BASE, \
+			   IRQ_DB5500_MSP2, pdata)
 
-#define db5500_add_msp0_spi(pdata) \
-	dbx500_add_msp_spi("msp0", U5500_MSP0_BASE, IRQ_DB5500_MSP0, pdata)
-#define db5500_add_msp1_spi(pdata) \
-	dbx500_add_msp_spi("msp1", U5500_MSP1_BASE, IRQ_DB5500_MSP1, pdata)
-#define db5500_add_msp2_spi(pdata) \
-	dbx500_add_msp_spi("msp2", U5500_MSP2_BASE, IRQ_DB5500_MSP2, pdata)
+#define db5500_add_msp0_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp0", U5500_MSP0_BASE, \
+			  IRQ_DB5500_MSP0, pdata)
+#define db5500_add_msp1_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp1", U5500_MSP1_BASE, \
+			  IRQ_DB5500_MSP1, pdata)
+#define db5500_add_msp2_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp2", U5500_MSP2_BASE, \
+			  IRQ_DB5500_MSP2, pdata)
 
-#define db5500_add_rtc() \
-	dbx500_add_rtc(U5500_RTC_BASE, IRQ_DB5500_RTC);
+#define db5500_add_rtc(parent) \
+	dbx500_add_rtc(parent, U5500_RTC_BASE, IRQ_DB5500_RTC);
 
-#define db5500_add_usb(rx_cfg, tx_cfg) \
-	ux500_add_usb(U5500_USBOTG_BASE, IRQ_DB5500_USBOTG, rx_cfg, tx_cfg)
+#define db5500_add_usb(parent, rx_cfg, tx_cfg) \
+	ux500_add_usb(parent, U5500_USBOTG_BASE, \
+		      IRQ_DB5500_USBOTG, rx_cfg, tx_cfg)
 
-#define db5500_add_sdi0(pdata) \
-	dbx500_add_sdi("sdi0", U5500_SDI0_BASE, IRQ_DB5500_SDMMC0, pdata, \
+#define db5500_add_sdi0(parent, pdata) \
+	dbx500_add_sdi(parent, "sdi0", U5500_SDI0_BASE, \
+		       IRQ_DB5500_SDMMC0, pdata,	\
 		       0x10480180)
-#define db5500_add_sdi1(pdata) \
-	dbx500_add_sdi("sdi1", U5500_SDI1_BASE, IRQ_DB5500_SDMMC1, pdata, \
+#define db5500_add_sdi1(parent, pdata) \
+	dbx500_add_sdi(parent, "sdi1", U5500_SDI1_BASE, \
+		       IRQ_DB5500_SDMMC1, pdata,	\
 		       0x10480180)
-#define db5500_add_sdi2(pdata) \
-	dbx500_add_sdi("sdi2", U5500_SDI2_BASE, IRQ_DB5500_SDMMC2, pdata \
+#define db5500_add_sdi2(parent, pdata) \
+	dbx500_add_sdi(parent, "sdi2", U5500_SDI2_BASE, \
+		       IRQ_DB5500_SDMMC2, pdata		\
 		       0x10480180)
-#define db5500_add_sdi3(pdata) \
-	dbx500_add_sdi("sdi3", U5500_SDI3_BASE, IRQ_DB5500_SDMMC3, pdata \
+#define db5500_add_sdi3(parent, pdata) \
+	dbx500_add_sdi(parent, "sdi3", U5500_SDI3_BASE, \
+		       IRQ_DB5500_SDMMC3, pdata		\
 		       0x10480180)
-#define db5500_add_sdi4(pdata) \
-	dbx500_add_sdi("sdi4", U5500_SDI4_BASE, IRQ_DB5500_SDMMC4, pdata \
+#define db5500_add_sdi4(parent, pdata) \
+	dbx500_add_sdi(parent, "sdi4", U5500_SDI4_BASE, \
+		       IRQ_DB5500_SDMMC4, pdata		\
 		       0x10480180)
 
 /* This one has a bad peripheral ID in the U5500 silicon */
-#define db5500_add_spi0(pdata) \
-	dbx500_add_spi("spi0", U5500_SPI0_BASE, IRQ_DB5500_SPI0, pdata, \
+#define db5500_add_spi0(parent, pdata) \
+	dbx500_add_spi(parent, "spi0", U5500_SPI0_BASE, \
+		       IRQ_DB5500_SPI0, pdata,		\
 		       0x10080023)
-#define db5500_add_spi1(pdata) \
-	dbx500_add_spi("spi1", U5500_SPI1_BASE, IRQ_DB5500_SPI1, pdata, \
+#define db5500_add_spi1(parent, pdata) \
+	dbx500_add_spi(parent, "spi1", U5500_SPI1_BASE, \
+		       IRQ_DB5500_SPI1, pdata,		\
 		       0x10080023)
-#define db5500_add_spi2(pdata) \
-	dbx500_add_spi("spi2", U5500_SPI2_BASE, IRQ_DB5500_SPI2, pdata \
+#define db5500_add_spi2(parent, pdata) \
+	dbx500_add_spi(parent, "spi2", U5500_SPI2_BASE, \
+		       IRQ_DB5500_SPI2, pdata		\
 		       0x10080023)
-#define db5500_add_spi3(pdata) \
-	dbx500_add_spi("spi3", U5500_SPI3_BASE, IRQ_DB5500_SPI3, pdata \
+#define db5500_add_spi3(parent, pdata) \
+	dbx500_add_spi(parent, "spi3", U5500_SPI3_BASE, \
+		       IRQ_DB5500_SPI3, pdata		\
 		       0x10080023)
 
-#define db5500_add_uart0(plat) \
-	dbx500_add_uart("uart0", U5500_UART0_BASE, IRQ_DB5500_UART0, plat)
-#define db5500_add_uart1(plat) \
-	dbx500_add_uart("uart1", U5500_UART1_BASE, IRQ_DB5500_UART1, plat)
-#define db5500_add_uart2(plat) \
-	dbx500_add_uart("uart2", U5500_UART2_BASE, IRQ_DB5500_UART2, plat)
-#define db5500_add_uart3(plat) \
-	dbx500_add_uart("uart3", U5500_UART3_BASE, IRQ_DB5500_UART3, plat)
+#define db5500_add_uart0(parent, plat) \
+	dbx500_add_uart(parent, "uart0", U5500_UART0_BASE, \
+			IRQ_DB5500_UART0, plat)
+#define db5500_add_uart1(parent, plat) \
+	dbx500_add_uart(parent, "uart1", U5500_UART1_BASE, \
+			IRQ_DB5500_UART1, plat)
+#define db5500_add_uart2(parent, plat) \
+	dbx500_add_uart(parent, "uart2", U5500_UART2_BASE, \
+			IRQ_DB5500_UART2, plat)
+#define db5500_add_uart3(parent, plat) \
+	dbx500_add_uart(parent, "uart3", U5500_UART3_BASE, \
+			IRQ_DB5500_UART3, plat)
 
 #endif
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index cbd4a9a..9bd08ad 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -14,7 +14,9 @@ struct ske_keypad_platform_data;
 struct pl022_ssp_controller;
 
 static inline struct platform_device *
-db8500_add_ske_keypad(struct ske_keypad_platform_data *pdata)
+db8500_add_ske_keypad(struct device *parent,
+		      struct ske_keypad_platform_data *pdata,
+		      size_t size)
 {
 	return dbx500_add_platform_device_4k1irq("nmk-ske-keypad", -1,
 						 U8500_SKE_BASE,
@@ -22,80 +24,100 @@ db8500_add_ske_keypad(struct ske_keypad_platform_data *pdata)
 }
 
 static inline struct amba_device *
-db8500_add_ssp(const char *name, resource_size_t base, int irq,
-	       struct pl022_ssp_controller *pdata)
+db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
+	       int irq, struct pl022_ssp_controller *pdata)
 {
-	return dbx500_add_amba_device(name, base, irq, pdata, 0);
+	return dbx500_add_amba_device(parent, name, base, irq, pdata, 0);
 }
 
 
-#define db8500_add_i2c0(pdata) \
-	dbx500_add_i2c(0, U8500_I2C0_BASE, IRQ_DB8500_I2C0, pdata)
-#define db8500_add_i2c1(pdata) \
-	dbx500_add_i2c(1, U8500_I2C1_BASE, IRQ_DB8500_I2C1, pdata)
-#define db8500_add_i2c2(pdata) \
-	dbx500_add_i2c(2, U8500_I2C2_BASE, IRQ_DB8500_I2C2, pdata)
-#define db8500_add_i2c3(pdata) \
-	dbx500_add_i2c(3, U8500_I2C3_BASE, IRQ_DB8500_I2C3, pdata)
-#define db8500_add_i2c4(pdata) \
-	dbx500_add_i2c(4, U8500_I2C4_BASE, IRQ_DB8500_I2C4, pdata)
-
-#define db8500_add_msp0_i2s(pdata) \
-	dbx500_add_msp_i2s(0, U8500_MSP0_BASE, IRQ_DB8500_MSP0, pdata)
-#define db8500_add_msp1_i2s(pdata) \
-	dbx500_add_msp_i2s(1, U8500_MSP1_BASE, IRQ_DB8500_MSP1, pdata)
-#define db8500_add_msp2_i2s(pdata) \
-	dbx500_add_msp_i2s(2, U8500_MSP2_BASE, IRQ_DB8500_MSP2, pdata)
-#define db8500_add_msp3_i2s(pdata) \
-	dbx500_add_msp_i2s(3, U8500_MSP3_BASE, IRQ_DB8500_MSP1, pdata)
-
-#define db8500_add_msp0_spi(pdata) \
-	dbx500_add_msp_spi("msp0", U8500_MSP0_BASE, IRQ_DB8500_MSP0, pdata)
-#define db8500_add_msp1_spi(pdata) \
-	dbx500_add_msp_spi("msp1", U8500_MSP1_BASE, IRQ_DB8500_MSP1, pdata)
-#define db8500_add_msp2_spi(pdata) \
-	dbx500_add_msp_spi("msp2", U8500_MSP2_BASE, IRQ_DB8500_MSP2, pdata)
-#define db8500_add_msp3_spi(pdata) \
-	dbx500_add_msp_spi("msp3", U8500_MSP3_BASE, IRQ_DB8500_MSP1, pdata)
-
-#define db8500_add_rtc() \
-	dbx500_add_rtc(U8500_RTC_BASE, IRQ_DB8500_RTC);
-
-#define db8500_add_usb(rx_cfg, tx_cfg) \
-	ux500_add_usb(U8500_USBOTG_BASE, IRQ_DB8500_USBOTG, rx_cfg, tx_cfg)
-
-#define db8500_add_sdi0(pdata, pid) \
-	dbx500_add_sdi("sdi0", U8500_SDI0_BASE, IRQ_DB8500_SDMMC0, pdata, pid)
-#define db8500_add_sdi1(pdata, pid) \
-	dbx500_add_sdi("sdi1", U8500_SDI1_BASE, IRQ_DB8500_SDMMC1, pdata, pid)
-#define db8500_add_sdi2(pdata, pid) \
-	dbx500_add_sdi("sdi2", U8500_SDI2_BASE, IRQ_DB8500_SDMMC2, pdata, pid)
-#define db8500_add_sdi3(pdata, pid) \
-	dbx500_add_sdi("sdi3", U8500_SDI3_BASE, IRQ_DB8500_SDMMC3, pdata, pid)
-#define db8500_add_sdi4(pdata, pid) \
-	dbx500_add_sdi("sdi4", U8500_SDI4_BASE, IRQ_DB8500_SDMMC4, pdata, pid)
-#define db8500_add_sdi5(pdata, pid) \
-	dbx500_add_sdi("sdi5", U8500_SDI5_BASE, IRQ_DB8500_SDMMC5, pdata, pid)
-
-#define db8500_add_ssp0(pdata) \
-	db8500_add_ssp("ssp0", U8500_SSP0_BASE, IRQ_DB8500_SSP0, pdata)
-#define db8500_add_ssp1(pdata) \
-	db8500_add_ssp("ssp1", U8500_SSP1_BASE, IRQ_DB8500_SSP1, pdata)
-
-#define db8500_add_spi0(pdata) \
-	dbx500_add_spi("spi0", U8500_SPI0_BASE, IRQ_DB8500_SPI0, pdata, 0)
-#define db8500_add_spi1(pdata) \
-	dbx500_add_spi("spi1", U8500_SPI1_BASE, IRQ_DB8500_SPI1, pdata, 0)
-#define db8500_add_spi2(pdata) \
-	dbx500_add_spi("spi2", U8500_SPI2_BASE, IRQ_DB8500_SPI2, pdata, 0)
-#define db8500_add_spi3(pdata) \
-	dbx500_add_spi("spi3", U8500_SPI3_BASE, IRQ_DB8500_SPI3, pdata, 0)
-
-#define db8500_add_uart0(pdata) \
-	dbx500_add_uart("uart0", U8500_UART0_BASE, IRQ_DB8500_UART0, pdata)
-#define db8500_add_uart1(pdata) \
-	dbx500_add_uart("uart1", U8500_UART1_BASE, IRQ_DB8500_UART1, pdata)
-#define db8500_add_uart2(pdata) \
-	dbx500_add_uart("uart2", U8500_UART2_BASE, IRQ_DB8500_UART2, pdata)
+#define db8500_add_i2c0(parent, pdata) \
+	dbx500_add_i2c(parent, 0, U8500_I2C0_BASE, IRQ_DB8500_I2C0, pdata)
+#define db8500_add_i2c1(parent, pdata) \
+	dbx500_add_i2c(parent, 1, U8500_I2C1_BASE, IRQ_DB8500_I2C1, pdata)
+#define db8500_add_i2c2(parent, pdata) \
+	dbx500_add_i2c(parent, 2, U8500_I2C2_BASE, IRQ_DB8500_I2C2, pdata)
+#define db8500_add_i2c3(parent, pdata) \
+	dbx500_add_i2c(parent, 3, U8500_I2C3_BASE, IRQ_DB8500_I2C3, pdata)
+#define db8500_add_i2c4(parent, pdata) \
+	dbx500_add_i2c(parent, 4, U8500_I2C4_BASE, IRQ_DB8500_I2C4, pdata)
+
+#define db8500_add_msp0_i2s(parent, pdata) \
+	dbx500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0, pdata)
+#define db8500_add_msp1_i2s(parent, pdata) \
+	dbx500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1, pdata)
+#define db8500_add_msp2_i2s(parent, pdata) \
+	dbx500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2, pdata)
+#define db8500_add_msp3_i2s(parent, pdata) \
+	dbx500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1, pdata)
+
+#define db8500_add_msp0_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp0", U8500_MSP0_BASE, \
+			   IRQ_DB8500_MSP0, pdata)
+#define db8500_add_msp1_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp1", U8500_MSP1_BASE, \
+			   IRQ_DB8500_MSP1, pdata)
+#define db8500_add_msp2_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp2", U8500_MSP2_BASE, \
+			   IRQ_DB8500_MSP2, pdata)
+#define db8500_add_msp3_spi(parent, pdata) \
+	dbx500_add_msp_spi(parent, "msp3", U8500_MSP3_BASE, \
+			   IRQ_DB8500_MSP1, pdata)
+
+#define db8500_add_rtc(parent) \
+	dbx500_add_rtc(parent, U8500_RTC_BASE, IRQ_DB8500_RTC);
+
+#define db8500_add_usb(parent, rx_cfg, tx_cfg) \
+	ux500_add_usb(parent, U8500_USBOTG_BASE, \
+		      IRQ_DB8500_USBOTG, rx_cfg, tx_cfg)
+
+#define db8500_add_sdi0(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi0", U8500_SDI0_BASE, \
+		       IRQ_DB8500_SDMMC0, pdata, pid)
+#define db8500_add_sdi1(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi1", U8500_SDI1_BASE, \
+		       IRQ_DB8500_SDMMC1, pdata, pid)
+#define db8500_add_sdi2(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi2", U8500_SDI2_BASE, \
+		       IRQ_DB8500_SDMMC2, pdata, pid)
+#define db8500_add_sdi3(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi3", U8500_SDI3_BASE, \
+		       IRQ_DB8500_SDMMC3, pdata, pid)
+#define db8500_add_sdi4(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi4", U8500_SDI4_BASE, \
+		       IRQ_DB8500_SDMMC4, pdata, pid)
+#define db8500_add_sdi5(parent, pdata, pid) \
+	dbx500_add_sdi(parent, "sdi5", U8500_SDI5_BASE, \
+		       IRQ_DB8500_SDMMC5, pdata, pid)
+
+#define db8500_add_ssp0(parent, pdata) \
+	db8500_add_ssp(parent, "ssp0", U8500_SSP0_BASE, \
+		       IRQ_DB8500_SSP0, pdata)
+#define db8500_add_ssp1(parent, pdata) \
+	db8500_add_ssp(parent, "ssp1", U8500_SSP1_BASE, \
+		       IRQ_DB8500_SSP1, pdata)
+
+#define db8500_add_spi0(parent, pdata) \
+	dbx500_add_spi(parent, "spi0", U8500_SPI0_BASE, \
+		       IRQ_DB8500_SPI0, pdata, 0)
+#define db8500_add_spi1(parent, pdata) \
+	dbx500_add_spi(parent, "spi1", U8500_SPI1_BASE, \
+		       IRQ_DB8500_SPI1, pdata, 0)
+#define db8500_add_spi2(parent, pdata) \
+	dbx500_add_spi(parent, "spi2", U8500_SPI2_BASE, \
+		       IRQ_DB8500_SPI2, pdata, 0)
+#define db8500_add_spi3(parent, pdata) \
+	dbx500_add_spi(parent, "spi3", U8500_SPI3_BASE, \
+		       IRQ_DB8500_SPI3, pdata, 0)
+
+#define db8500_add_uart0(parent, pdata) \
+	dbx500_add_uart(parent, "uart0", U8500_UART0_BASE, \
+			IRQ_DB8500_UART0, pdata)
+#define db8500_add_uart1(parent, pdata) \
+	dbx500_add_uart(parent, "uart1", U8500_UART1_BASE, \
+			IRQ_DB8500_UART1, pdata)
+#define db8500_add_uart2(parent, pdata) \
+	dbx500_add_uart(parent, "uart2", U8500_UART2_BASE, \
+			IRQ_DB8500_UART2, pdata)
 
 #endif
diff --git a/arch/arm/mach-ux500/dma-db5500.c b/arch/arm/mach-ux500/dma-db5500.c
index 1cfab68..41e9470 100644
--- a/arch/arm/mach-ux500/dma-db5500.c
+++ b/arch/arm/mach-ux500/dma-db5500.c
@@ -125,10 +125,11 @@ static struct platform_device dma40_device = {
 	.resource	= dma40_resources
 };
 
-void __init db5500_dma_init(void)
+void __init db5500_dma_init(struct device *parent)
 {
 	int ret;
 
+	dma40_device.dev.parent = parent;
 	ret = platform_device_register(&dma40_device);
 	if (ret)
 		dev_err(&dma40_device.dev, "unable to register device: %d\n", ret);
diff --git a/arch/arm/mach-ux500/include/mach/setup.h b/arch/arm/mach-ux500/include/mach/setup.h
index a7d363f..88e8d6b 100644
--- a/arch/arm/mach-ux500/include/mach/setup.h
+++ b/arch/arm/mach-ux500/include/mach/setup.h
@@ -23,9 +23,9 @@ extern void __init u8500_init_devices(void);
 
 extern void __init ux500_init_irq(void);
 
-extern void __init u5500_sdi_init(void);
+extern void __init u5500_sdi_init(struct device *parent);
 
-extern void __init db5500_dma_init(void);
+extern void __init db5500_dma_init(struct device *parent);
 
 /* We re-use nomadik_timer for this platform */
 extern void nmdk_timer_init(void);
diff --git a/arch/arm/mach-ux500/include/mach/usb.h b/arch/arm/mach-ux500/include/mach/usb.h
index d3739d4..4c1cc50 100644
--- a/arch/arm/mach-ux500/include/mach/usb.h
+++ b/arch/arm/mach-ux500/include/mach/usb.h
@@ -20,6 +20,6 @@ struct ux500_musb_board_data {
 	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
 };
 
-void ux500_add_usb(resource_size_t base, int irq, int *dma_rx_cfg,
-	int *dma_tx_cfg);
+void ux500_add_usb(struct device *parent, resource_size_t base,
+		   int irq, int *dma_rx_cfg, int *dma_tx_cfg);
 #endif
diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
index 0a01cbd..bef6a31 100644
--- a/arch/arm/mach-ux500/usb.c
+++ b/arch/arm/mach-ux500/usb.c
@@ -146,8 +146,8 @@ static inline void ux500_usb_dma_update_tx_ch_config(int *dst_dev_type)
 		musb_dma_tx_ch[idx].dst_dev_type = dst_dev_type[idx];
 }
 
-void ux500_add_usb(resource_size_t base, int irq, int *dma_rx_cfg,
-	int *dma_tx_cfg)
+void ux500_add_usb(struct device *parent, resource_size_t base, int irq,
+		   int *dma_rx_cfg, int *dma_tx_cfg)
 {
 	ux500_musb_device.resource[0].start = base;
 	ux500_musb_device.resource[0].end = base + SZ_64K - 1;
-- 
1.7.5.4

