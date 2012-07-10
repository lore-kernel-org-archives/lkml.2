Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2GJLjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:39:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38786 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062Ab2GJLjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:39:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm5110: Initial support for the WM5110
Date: Tue, 10 Jul 2012 12:37:58 +0100
Message-Id: <1341920279-7760-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341920279-7760-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341920279-7760-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM5110 is a highly-integrated low-power audio system for smartphones,
tablets and other portable audio devices. It combines an advanced DSP
feature set with a flexible, high-performance audio hub CODEC.

The support is based on the Arizona core driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig               |    6 +++
 drivers/mfd/Makefile              |    3 ++
 drivers/mfd/arizona-core.c        |   24 +++++++++++
 drivers/mfd/arizona-i2c.c         |    6 +++
 drivers/mfd/arizona-irq.c         |    6 +++
 drivers/mfd/arizona-spi.c         |    6 +++
 drivers/mfd/arizona.h             |    7 ++++
 include/linux/mfd/arizona/core.h  |   79 +++++++++++++++++++++----------------
 include/linux/mfd/arizona/pdata.h |    4 +-
 9 files changed, 105 insertions(+), 36 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fa267d4..481f3bb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -550,6 +550,12 @@ config MFD_WM5102
 	help
 	  Support for Wolfson Microelectronics WM5102 low power audio SoC
 
+config MFD_WM5110
+	bool "Support Wolfson Microelectronics WM5110"
+	depends on MFD_ARIZONA
+	help
+	  Support for Wolfson Microelectronics WM5110 low power audio SoC
+
 config MFD_WM8400
 	bool "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 09674a9..d352585 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -33,6 +33,9 @@ obj-$(CONFIG_MFD_ARIZONA_SPI)	+= arizona-spi.o
 ifneq ($(CONFIG_MFD_WM5102),n)
 obj-$(CONFIG_MFD_ARIZONA)	+= wm5102-tables.o
 endif
+ifneq ($(CONFIG_MFD_WM5110),n)
+obj-$(CONFIG_MFD_ARIZONA)	+= wm5110-tables.o
+endif
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
 wm831x-objs			+= wm831x-auxadc.o
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index b35680d..6e70d3d 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -273,6 +273,14 @@ static struct mfd_cell wm5102_devs[] = {
 	{ .name = "wm5102-codec" },
 };
 
+static struct mfd_cell wm5110_devs[] = {
+	{ .name = "arizona-extcon" },
+	{ .name = "arizona-gpio" },
+	{ .name = "arizona-micsupp" },
+	{ .name = "arizona-pwm" },
+	{ .name = "wm5110-codec" },
+};
+
 int __devinit arizona_dev_init(struct arizona *arizona)
 {
 	struct device *dev = arizona->dev;
@@ -291,6 +299,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 
 	switch (arizona->type) {
 	case WM5102:
+	case WM5110:
 		for (i = 0; i < ARRAY_SIZE(wm5102_core_supplies); i++)
 			arizona->core_supplies[i].supply
 				= wm5102_core_supplies[i];
@@ -379,6 +388,17 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		ret = wm5102_patch(arizona);
 		break;
 #endif
+#ifdef CONFIG_MFD_WM5110
+	case 0x5110:
+		type_name = "WM5110";
+		if (arizona->type != WM5110) {
+			dev_err(arizona->dev, "WM5110 registered as %d\n",
+				arizona->type);
+			arizona->type = WM5110;
+		}
+		ret = wm5110_patch(arizona);
+		break;
+#endif
 	default:
 		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
 		goto err_reset;
@@ -494,6 +514,10 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		ret = mfd_add_devices(arizona->dev, -1, wm5102_devs,
 				      ARRAY_SIZE(wm5102_devs), NULL, 0);
 		break;
+	case WM5110:
+		ret = mfd_add_devices(arizona->dev, -1, wm5110_devs,
+				      ARRAY_SIZE(wm5102_devs), NULL, 0);
+		break;
 	}
 
 	if (ret != 0) {
diff --git a/drivers/mfd/arizona-i2c.c b/drivers/mfd/arizona-i2c.c
index fe19d11..570c4b4 100644
--- a/drivers/mfd/arizona-i2c.c
+++ b/drivers/mfd/arizona-i2c.c
@@ -35,6 +35,11 @@ static __devinit int arizona_i2c_probe(struct i2c_client *i2c,
 		regmap_config = &wm5102_i2c_regmap;
 		break;
 #endif
+#ifdef CONFIG_MFD_WM5110
+	case WM5110:
+		regmap_config = &wm5110_i2c_regmap;
+		break;
+#endif
 	default:
 		dev_err(&i2c->dev, "Unknown device type %ld\n",
 			id->driver_data);
@@ -69,6 +74,7 @@ static int __devexit arizona_i2c_remove(struct i2c_client *i2c)
 
 static const struct i2c_device_id arizona_i2c_id[] = {
 	{ "wm5102", WM5102 },
+	{ "wm5110", WM5110 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, arizona_i2c_id);
diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 17d20c0..98ac345 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -164,6 +164,12 @@ int arizona_irq_init(struct arizona *arizona)
 		irq = &wm5102_irq;
 		break;
 #endif
+#ifdef CONFIG_MFD_WM5110
+	case WM5110:
+		aod = &wm5110_aod;
+		irq = &wm5110_irq;
+		break;
+#endif
 	default:
 		BUG_ON("Unknown Arizona class device" == NULL);
 		return -EINVAL;
diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index f4bedaf..df2e5a8 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -35,6 +35,11 @@ static int __devinit arizona_spi_probe(struct spi_device *spi)
 		regmap_config = &wm5102_spi_regmap;
 		break;
 #endif
+#ifdef CONFIG_MFD_WM5110
+	case WM5110:
+		regmap_config = &wm5110_spi_regmap;
+		break;
+#endif
 	default:
 		dev_err(&spi->dev, "Unknown device type %ld\n",
 			id->driver_data);
@@ -69,6 +74,7 @@ static int __devexit arizona_spi_remove(struct spi_device *spi)
 
 static const struct spi_device_id arizona_spi_ids[] = {
 	{ "wm5102", WM5102 },
+	{ "wm5110", WM5110 },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, arizona_spi_ids);
diff --git a/drivers/mfd/arizona.h b/drivers/mfd/arizona.h
index 1c9f333..9798ae5 100644
--- a/drivers/mfd/arizona.h
+++ b/drivers/mfd/arizona.h
@@ -20,11 +20,18 @@ struct wm_arizona;
 
 extern const struct regmap_config wm5102_i2c_regmap;
 extern const struct regmap_config wm5102_spi_regmap;
+
+extern const struct regmap_config wm5110_i2c_regmap;
+extern const struct regmap_config wm5110_spi_regmap;
+
 extern const struct dev_pm_ops arizona_pm_ops;
 
 extern const struct regmap_irq_chip wm5102_aod;
 extern const struct regmap_irq_chip wm5102_irq;
 
+extern const struct regmap_irq_chip wm5110_aod;
+extern const struct regmap_irq_chip wm5110_irq;
+
 int arizona_dev_init(struct arizona *arizona);
 int arizona_dev_exit(struct arizona *arizona);
 int arizona_irq_init(struct arizona *arizona);
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 3ef32b4..dd231ac 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -22,6 +22,7 @@
 
 enum arizona_type {
 	WM5102 = 1,
+	WM5110 = 2,
 };
 
 #define ARIZONA_IRQ_GP1                    0
@@ -33,40 +34,49 @@ enum arizona_type {
 #define ARIZONA_IRQ_JD_FALL                6
 #define ARIZONA_IRQ_JD_RISE                7
 #define ARIZONA_IRQ_DSP1_RAM_RDY           8
-#define ARIZONA_IRQ_DSP_IRQ1               9
-#define ARIZONA_IRQ_DSP_IRQ2              10
-#define ARIZONA_IRQ_SPK_SHUTDOWN_WARN     11
-#define ARIZONA_IRQ_SPK_SHUTDOWN          12
-#define ARIZONA_IRQ_MICDET                13
-#define ARIZONA_IRQ_HPDET                 14
-#define ARIZONA_IRQ_WSEQ_DONE             15
-#define ARIZONA_IRQ_DRC2_SIG_DET          16
-#define ARIZONA_IRQ_DRC1_SIG_DET          17
-#define ARIZONA_IRQ_ASRC2_LOCK            18
-#define ARIZONA_IRQ_ASRC1_LOCK            19
-#define ARIZONA_IRQ_UNDERCLOCKED          20
-#define ARIZONA_IRQ_OVERCLOCKED           21
-#define ARIZONA_IRQ_FLL2_LOCK             22
-#define ARIZONA_IRQ_FLL1_LOCK             23
-#define ARIZONA_IRQ_CLKGEN_ERR            24
-#define ARIZONA_IRQ_CLKGEN_ERR_ASYNC      25
-#define ARIZONA_IRQ_ASRC_CFG_ERR          26
-#define ARIZONA_IRQ_AIF3_ERR              27
-#define ARIZONA_IRQ_AIF2_ERR              28
-#define ARIZONA_IRQ_AIF1_ERR              29
-#define ARIZONA_IRQ_CTRLIF_ERR            30
-#define ARIZONA_IRQ_MIXER_DROPPED_SAMPLES 31
-#define ARIZONA_IRQ_ASYNC_CLK_ENA_LOW     32
-#define ARIZONA_IRQ_SYSCLK_ENA_LOW        33
-#define ARIZONA_IRQ_ISRC1_CFG_ERR         34
-#define ARIZONA_IRQ_ISRC2_CFG_ERR         35
-#define ARIZONA_IRQ_BOOT_DONE             36
-#define ARIZONA_IRQ_DCS_DAC_DONE          37
-#define ARIZONA_IRQ_DCS_HP_DONE           38
-#define ARIZONA_IRQ_FLL2_CLOCK_OK         39
-#define ARIZONA_IRQ_FLL1_CLOCK_OK         40
-
-#define ARIZONA_NUM_IRQ                   41
+#define ARIZONA_IRQ_DSP2_RAM_RDY           9
+#define ARIZONA_IRQ_DSP3_RAM_RDY          10
+#define ARIZONA_IRQ_DSP4_RAM_RDY          11
+#define ARIZONA_IRQ_DSP_IRQ1              12
+#define ARIZONA_IRQ_DSP_IRQ2              13
+#define ARIZONA_IRQ_DSP_IRQ3              14
+#define ARIZONA_IRQ_DSP_IRQ4              15
+#define ARIZONA_IRQ_DSP_IRQ5              16
+#define ARIZONA_IRQ_DSP_IRQ6              17
+#define ARIZONA_IRQ_DSP_IRQ7              18
+#define ARIZONA_IRQ_DSP_IRQ8              19
+#define ARIZONA_IRQ_SPK_SHUTDOWN_WARN     20
+#define ARIZONA_IRQ_SPK_SHUTDOWN          21
+#define ARIZONA_IRQ_MICDET                22
+#define ARIZONA_IRQ_HPDET                 23
+#define ARIZONA_IRQ_WSEQ_DONE             24
+#define ARIZONA_IRQ_DRC2_SIG_DET          25
+#define ARIZONA_IRQ_DRC1_SIG_DET          26
+#define ARIZONA_IRQ_ASRC2_LOCK            27
+#define ARIZONA_IRQ_ASRC1_LOCK            28
+#define ARIZONA_IRQ_UNDERCLOCKED          29
+#define ARIZONA_IRQ_OVERCLOCKED           30
+#define ARIZONA_IRQ_FLL2_LOCK             31
+#define ARIZONA_IRQ_FLL1_LOCK             32
+#define ARIZONA_IRQ_CLKGEN_ERR            33
+#define ARIZONA_IRQ_CLKGEN_ERR_ASYNC      34
+#define ARIZONA_IRQ_ASRC_CFG_ERR          35
+#define ARIZONA_IRQ_AIF3_ERR              36
+#define ARIZONA_IRQ_AIF2_ERR              37
+#define ARIZONA_IRQ_AIF1_ERR              38
+#define ARIZONA_IRQ_CTRLIF_ERR            39
+#define ARIZONA_IRQ_MIXER_DROPPED_SAMPLES 40
+#define ARIZONA_IRQ_ASYNC_CLK_ENA_LOW     41
+#define ARIZONA_IRQ_SYSCLK_ENA_LOW        42
+#define ARIZONA_IRQ_ISRC1_CFG_ERR         43
+#define ARIZONA_IRQ_ISRC2_CFG_ERR         44
+#define ARIZONA_IRQ_BOOT_DONE             45
+#define ARIZONA_IRQ_DCS_DAC_DONE          46
+#define ARIZONA_IRQ_DCS_HP_DONE           47
+#define ARIZONA_IRQ_FLL2_CLOCK_OK         48
+#define ARIZONA_IRQ_FLL1_CLOCK_OK         49
+
+#define ARIZONA_NUM_IRQ                   50
 
 struct arizona {
 	struct regmap *regmap;
@@ -99,5 +109,6 @@ void arizona_free_irq(struct arizona *arizona, int irq, void *data);
 int arizona_set_irq_wake(struct arizona *arizona, int irq, int on);
 
 int wm5102_patch(struct arizona *arizona);
+int wm5110_patch(struct arizona *arizona);
 
 #endif
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 68ff91a..7ab4429 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -49,7 +49,7 @@
 #define ARIZONA_32KZ_MCLK2 2
 #define ARIZONA_32KZ_NONE  3
 
-#define ARIZONA_MAX_INPUT 3
+#define ARIZONA_MAX_INPUT 4
 
 #define ARIZONA_DMIC_MICVDD   0
 #define ARIZONA_DMIC_MICBIAS1 1
@@ -60,7 +60,7 @@
 #define ARIZONA_INMODE_SE   1
 #define ARIZONA_INMODE_DMIC 2
 
-#define ARIZONA_MAX_OUTPUT 5
+#define ARIZONA_MAX_OUTPUT 6
 
 #define ARIZONA_MAX_PDM_SPK 2
 
-- 
1.7.10

