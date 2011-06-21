Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1FUOmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:42:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48260 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1FUOkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:00 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 08/18] mfd: twl6040: Add initial support
Date: Tue, 21 Jun 2011 16:39:06 +0300
Message-ID: <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Misael Lopez Cruz <misael.lopez@ti.com>

TWL6040 IC provides analog high-end audio codec functions for
handset applications. It contains several audio analog inputs
and outputs as well as vibrator support. It's connected to the
host processor via PDM interface for audio data communication.
The audio modules are controlled by internal registers that
can be accessed by I2C and PDM interface.

TWL6040 MFD will be registered as a child of TWL-CORE, and will
have two children of its own: twl6040-codec and twl6040-vibra.

This driver is based on TWL4030 and WM8350 MFD drivers.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/plat-omap/include/plat/irqs.h |   12 +-
 drivers/mfd/Kconfig                    |    6 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/twl-core.c                 |    5 +-
 drivers/mfd/twl6040-core.c             |  602 ++++++++++++++++++++++++++++++++
 drivers/mfd/twl6040-irq.c              |  205 +++++++++++
 include/linux/i2c/twl.h                |    1 +
 include/linux/mfd/twl6040.h            |  261 ++++++++++++++
 8 files changed, 1088 insertions(+), 5 deletions(-)
 create mode 100644 drivers/mfd/twl6040-core.c
 create mode 100644 drivers/mfd/twl6040-irq.c
 create mode 100644 include/linux/mfd/twl6040.h

diff --git a/arch/arm/plat-omap/include/plat/irqs.h b/arch/arm/plat-omap/include/plat/irqs.h
index 5a25098..2cfba51 100644
--- a/arch/arm/plat-omap/include/plat/irqs.h
+++ b/arch/arm/plat-omap/include/plat/irqs.h
@@ -407,11 +407,19 @@
 #endif
 #define TWL6030_IRQ_END		(TWL6030_IRQ_BASE + TWL6030_BASE_NR_IRQS)
 
+#define TWL6040_CODEC_IRQ_BASE	TWL6030_IRQ_END
+#ifdef CONFIG_TWL6040_CODEC
+#define TWL6040_CODEC_NR_IRQS	6
+#else
+#define TWL6040_CODEC_NR_IRQS	0
+#endif
+#define TWL6040_CODEC_IRQ_END	(TWL6040_CODEC_IRQ_BASE + TWL6040_CODEC_NR_IRQS)
+
 /* Total number of interrupts depends on the enabled blocks above */
-#if (TWL4030_GPIO_IRQ_END > TWL6030_IRQ_END)
+#if (TWL4030_GPIO_IRQ_END > TWL6040_CODEC_IRQ_END)
 #define TWL_IRQ_END 		TWL4030_GPIO_IRQ_END
 #else
-#define TWL_IRQ_END		TWL6030_IRQ_END
+#define TWL_IRQ_END		TWL6040_CODEC_IRQ_END
 #endif
 
 /* GPMC related */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 30f3536..169df9f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -255,6 +255,12 @@ config TWL6030_PWM
 	  Say yes here if you want support for TWL6030 PWM.
 	  This is used to control charging LED brightness.
 
+config TWL6040_CORE
+	bool
+	depends on TWL4030_CORE && GENERIC_HARDIRQS
+	select MFD_CORE
+	default n
+
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 77cb99a..eda1340 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
 obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
+obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
 
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f9d7880..a2eddc7 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -110,7 +110,7 @@
 #endif
 
 #if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
-	defined(CONFIG_SND_SOC_TWL6040) || defined(CONFIG_SND_SOC_TWL6040_MODULE)
+	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
 #define twl_has_codec()	true
 #else
 #define twl_has_codec()	false
@@ -824,10 +824,9 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	/* Phoenix codec driver is probed directly atm */
 	if (twl_has_codec() && pdata->audio && twl_class_is_6030()) {
 		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
-		child = add_child(sub_chip_id, "twl6040-codec",
+		child = add_child(sub_chip_id, "twl6040",
 				pdata->audio, sizeof(*pdata->audio),
 				false, 0, 0);
 		if (IS_ERR(child))
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
new file mode 100644
index 0000000..195613c
--- /dev/null
+++ b/drivers/mfd/twl6040-core.c
@@ -0,0 +1,602 @@
+/*
+ * MFD driver for TWL6040 audio device
+ *
+ * Authors:	Misael Lopez Cruz <misael.lopez@ti.com>
+ *		Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
+ *		Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * Copyright:	(C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/i2c/twl.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/twl6040.h>
+
+static struct platform_device *twl6040_dev;
+
+int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
+{
+	int ret;
+	u8 val = 0;
+
+	mutex_lock(&twl6040->io_mutex);
+	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	if (ret < 0) {
+		mutex_unlock(&twl6040->io_mutex);
+		return ret;
+	}
+	mutex_unlock(&twl6040->io_mutex);
+
+	return val;
+}
+EXPORT_SYMBOL(twl6040_reg_read);
+
+int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
+{
+	int ret;
+
+	mutex_lock(&twl6040->io_mutex);
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	mutex_unlock(&twl6040->io_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(twl6040_reg_write);
+
+int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
+{
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl6040->io_mutex);
+	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	if (ret)
+		goto out;
+
+	val |= mask;
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+out:
+	mutex_unlock(&twl6040->io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(twl6040_set_bits);
+
+int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
+{
+	int ret;
+	u8 val;
+
+	mutex_lock(&twl6040->io_mutex);
+	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	if (ret)
+		goto out;
+
+	val &= ~mask;
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+out:
+	mutex_unlock(&twl6040->io_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(twl6040_clear_bits);
+
+/* twl6040 codec manual power-up sequence */
+static int twl6040_power_up(struct twl6040 *twl6040)
+{
+	u8 ldoctl, ncpctl, lppllctl;
+	int ret;
+
+	/* enable high-side LDO, reference system and internal oscillator */
+	ldoctl = TWL6040_HSLDOENA | TWL6040_REFENA | TWL6040_OSCENA;
+	ret = twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+	if (ret)
+		return ret;
+	usleep_range(10000, 10500);
+
+	/* enable negative charge pump */
+	ncpctl = TWL6040_NCPENA;
+	ret = twl6040_reg_write(twl6040, TWL6040_REG_NCPCTL, ncpctl);
+	if (ret)
+		goto ncp_err;
+	usleep_range(1000, 1500);
+
+	/* enable low-side LDO */
+	ldoctl |= TWL6040_LSLDOENA;
+	ret = twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+	if (ret)
+		goto lsldo_err;
+	usleep_range(1000, 1500);
+
+	/* enable low-power PLL */
+	lppllctl = TWL6040_LPLLENA;
+	ret = twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+	if (ret)
+		goto lppll_err;
+	usleep_range(5000, 5500);
+
+	/* disable internal oscillator */
+	ldoctl &= ~TWL6040_OSCENA;
+	ret = twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+	if (ret)
+		goto osc_err;
+
+	return 0;
+
+osc_err:
+	lppllctl &= ~TWL6040_LPLLENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+lppll_err:
+	ldoctl &= ~TWL6040_LSLDOENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+lsldo_err:
+	ncpctl &= ~TWL6040_NCPENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_NCPCTL, ncpctl);
+ncp_err:
+	ldoctl &= ~(TWL6040_HSLDOENA | TWL6040_REFENA | TWL6040_OSCENA);
+	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+
+	return ret;
+}
+
+/* twl6040 manual power-down sequence */
+static void twl6040_power_down(struct twl6040 *twl6040)
+{
+	u8 ncpctl, ldoctl, lppllctl;
+
+	ncpctl = twl6040_reg_read(twl6040, TWL6040_REG_NCPCTL);
+	ldoctl = twl6040_reg_read(twl6040, TWL6040_REG_LDOCTL);
+	lppllctl = twl6040_reg_read(twl6040, TWL6040_REG_LPPLLCTL);
+
+	/* enable internal oscillator */
+	ldoctl |= TWL6040_OSCENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+	usleep_range(1000, 1500);
+
+	/* disable low-power PLL */
+	lppllctl &= ~TWL6040_LPLLENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+
+	/* disable low-side LDO */
+	ldoctl &= ~TWL6040_LSLDOENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+
+	/* disable negative charge pump */
+	ncpctl &= ~TWL6040_NCPENA;
+	twl6040_reg_write(twl6040, TWL6040_REG_NCPCTL, ncpctl);
+
+	/* disable high-side LDO, reference system and internal oscillator */
+	ldoctl &= ~(TWL6040_HSLDOENA | TWL6040_REFENA | TWL6040_OSCENA);
+	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
+}
+
+static irqreturn_t twl6040_naudint_handler(int irq, void *data)
+{
+	struct twl6040 *twl6040 = data;
+	u8 intid, status;
+
+	intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
+
+	if (intid & TWL6040_READYINT)
+		complete(&twl6040->ready);
+
+	if (intid & TWL6040_THINT) {
+		status = twl6040_reg_read(twl6040, TWL6040_REG_STATUS);
+		if (status & TWL6040_TSHUTDET) {
+			dev_warn(&twl6040_dev->dev,
+				 "Thermal shutdown, powering-off");
+			twl6040_power(twl6040, 0);
+		} else {
+			dev_warn(&twl6040_dev->dev,
+				 "Leaving thermal shutdown, powering-on");
+			twl6040_power(twl6040, 1);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int twl6040_power_up_completion(struct twl6040 *twl6040,
+				       int naudint)
+{
+	int time_left;
+	u8 intid;
+
+	time_left = wait_for_completion_timeout(&twl6040->ready,
+						msecs_to_jiffies(144));
+	if (!time_left) {
+		intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
+		if (!(intid & TWL6040_READYINT)) {
+			dev_err(&twl6040_dev->dev,
+				"timeout waiting for READYINT\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+int twl6040_power(struct twl6040 *twl6040, int on)
+{
+	int audpwron = twl6040->audpwron;
+	int naudint = twl6040->irq;
+	int ret = 0;
+
+	mutex_lock(&twl6040->mutex);
+
+	if (on) {
+		/* already powered-up */
+		if (twl6040->power_count++)
+			goto out;
+
+		if (gpio_is_valid(audpwron)) {
+			/* use AUDPWRON line */
+			gpio_set_value(audpwron, 1);
+			/* wait for power-up completion */
+			ret = twl6040_power_up_completion(twl6040, naudint);
+			if (ret) {
+				dev_err(&twl6040_dev->dev,
+					"automatic power-down failed\n");
+				twl6040->power_count = 0;
+				goto out;
+			}
+		} else {
+			/* use manual power-up sequence */
+			ret = twl6040_power_up(twl6040);
+			if (ret) {
+				dev_err(&twl6040_dev->dev,
+					"manual power-up failed\n");
+				twl6040->power_count = 0;
+				goto out;
+			}
+		}
+		twl6040->pll = TWL6040_LPPLL_ID;
+		twl6040->sysclk = 19200000;
+	} else {
+		/* already powered-down */
+		if (!twl6040->power_count) {
+			dev_err(&twl6040_dev->dev,
+				"device is already powered-off\n");
+			ret = -EPERM;
+			goto out;
+		}
+
+		if (--twl6040->power_count)
+			goto out;
+
+		if (gpio_is_valid(audpwron)) {
+			/* use AUDPWRON line */
+			gpio_set_value(audpwron, 0);
+
+			/* power-down sequence latency */
+			usleep_range(500, 700);
+		} else {
+			/* use manual power-down sequence */
+			twl6040_power_down(twl6040);
+		}
+		twl6040->pll = TWL6040_NOPLL_ID;
+		twl6040->sysclk = 0;
+	}
+
+out:
+	mutex_unlock(&twl6040->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(twl6040_power);
+
+int twl6040_is_powered(struct twl6040 *twl6040)
+{
+	return twl6040->power_count;
+}
+EXPORT_SYMBOL(twl6040_is_powered);
+
+int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
+		    unsigned int freq_in, unsigned int freq_out)
+{
+	u8 hppllctl, lppllctl;
+	int ret = 0;
+
+	mutex_lock(&twl6040->mutex);
+
+	hppllctl = twl6040_reg_read(twl6040, TWL6040_REG_HPPLLCTL);
+	lppllctl = twl6040_reg_read(twl6040, TWL6040_REG_LPPLLCTL);
+
+	switch (id) {
+	case TWL6040_LPPLL_ID:
+		/* low-power PLL divider */
+		switch (freq_out) {
+		case 17640000:
+			lppllctl |= TWL6040_LPLLFIN;
+			break;
+		case 19200000:
+			lppllctl &= ~TWL6040_LPLLFIN;
+			break;
+		default:
+			dev_err(&twl6040_dev->dev,
+				"freq_out %d not supported\n", freq_out);
+			ret = -EINVAL;
+			goto pll_out;
+		}
+		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+
+		switch (freq_in) {
+		case 32768:
+			lppllctl |= TWL6040_LPLLENA;
+			twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL,
+					  lppllctl);
+			mdelay(5);
+			lppllctl &= ~TWL6040_HPLLSEL;
+			twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL,
+					  lppllctl);
+			hppllctl &= ~TWL6040_HPLLENA;
+			twl6040_reg_write(twl6040, TWL6040_REG_HPPLLCTL,
+					  hppllctl);
+			break;
+		default:
+			dev_err(&twl6040_dev->dev,
+				"freq_in %d not supported\n", freq_in);
+			ret = -EINVAL;
+			goto pll_out;
+		}
+
+		twl6040->pll = TWL6040_LPPLL_ID;
+		break;
+	case TWL6040_HPPLL_ID:
+		/* high-performance PLL can provide only 19.2 MHz */
+		if (freq_out != 19200000) {
+			dev_err(&twl6040_dev->dev,
+				"freq_out %d not supported\n", freq_out);
+			ret = -EINVAL;
+			goto pll_out;
+		}
+
+		hppllctl &= ~TWL6040_MCLK_MSK;
+
+		switch (freq_in) {
+		case 12000000:
+			/* PLL enabled, active mode */
+			hppllctl |= TWL6040_MCLK_12000KHZ |
+				    TWL6040_HPLLENA;
+			break;
+		case 19200000:
+			/*
+			 * PLL disabled
+			 * (enable PLL if MCLK jitter quality
+			 *  doesn't meet specification)
+			 */
+			hppllctl |= TWL6040_MCLK_19200KHZ;
+			break;
+		case 26000000:
+			/* PLL enabled, active mode */
+			hppllctl |= TWL6040_MCLK_26000KHZ |
+				    TWL6040_HPLLENA;
+			break;
+		case 38400000:
+			/* PLL enabled, active mode */
+			hppllctl |= TWL6040_MCLK_38400KHZ |
+				    TWL6040_HPLLENA;
+			break;
+		default:
+			dev_err(&twl6040_dev->dev,
+				"freq_in %d not supported\n", freq_in);
+			ret = -EINVAL;
+			goto pll_out;
+		}
+
+		/* enable clock slicer to ensure input waveform is square */
+		hppllctl |= TWL6040_HPLLSQRENA;
+
+		twl6040_reg_write(twl6040, TWL6040_REG_HPPLLCTL, hppllctl);
+		usleep_range(500, 700);
+		lppllctl |= TWL6040_HPLLSEL;
+		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+		lppllctl &= ~TWL6040_LPLLENA;
+		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
+
+		twl6040->pll = TWL6040_HPPLL_ID;
+		break;
+	default:
+		dev_err(&twl6040_dev->dev, "unknown pll id %d\n", id);
+		ret = -EINVAL;
+		goto pll_out;
+	}
+
+	twl6040->sysclk = freq_out;
+
+pll_out:
+	mutex_unlock(&twl6040->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(twl6040_set_pll);
+
+enum twl6040_pll_id twl6040_get_pll(struct twl6040 *twl6040)
+{
+	return twl6040->pll;
+}
+EXPORT_SYMBOL(twl6040_get_pll);
+
+unsigned int twl6040_get_sysclk(struct twl6040 *twl6040)
+{
+	return twl6040->sysclk;
+}
+EXPORT_SYMBOL(twl6040_get_sysclk);
+
+static int __devinit twl6040_probe(struct platform_device *pdev)
+{
+	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
+	struct twl6040 *twl6040;
+	struct mfd_cell *cell = NULL;
+	int ret, children = 0;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data is missing\n");
+		return -EINVAL;
+	}
+
+	twl6040 = kzalloc(sizeof(struct twl6040), GFP_KERNEL);
+	if (!twl6040)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, twl6040);
+
+	twl6040_dev = pdev;
+	twl6040->dev = &pdev->dev;
+	twl6040->audpwron = pdata->audpwron_gpio;
+	twl6040->irq = pdata->naudint_irq;
+	twl6040->irq_base = pdata->irq_base;
+
+	mutex_init(&twl6040->mutex);
+	mutex_init(&twl6040->io_mutex);
+	init_completion(&twl6040->ready);
+
+	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
+
+	if (gpio_is_valid(twl6040->audpwron)) {
+		ret = gpio_request(twl6040->audpwron, "audpwron");
+		if (ret)
+			goto gpio1_err;
+
+		ret = gpio_direction_output(twl6040->audpwron, 0);
+		if (ret)
+			goto gpio2_err;
+	}
+
+	/* ERRATA: Automatic power-up is not possible in ES1.0 */
+	if (twl6040_get_rev(twl6040) == TWL6040_REV_ES1_0)
+		twl6040->audpwron = -EINVAL;
+
+	if (twl6040->irq) {
+		/* codec interrupt */
+		ret = twl6040_irq_init(twl6040);
+		if (ret)
+			goto gpio2_err;
+
+		ret = twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
+					  twl6040_naudint_handler, 0,
+					  "twl6040_irq_ready", twl6040);
+		if (ret) {
+			dev_err(twl6040->dev, "READY IRQ request failed: %d\n",
+				ret);
+			goto irq_err;
+		}
+	}
+
+	/* dual-access registers controlled by I2C only */
+	twl6040_set_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_I2CSEL);
+
+	if (pdata->codec) {
+		cell = &twl6040->cells[children];
+		cell->name = "twl6040-codec";
+		/* The codec expects the twl4030_audio_data as platform data */
+		cell->platform_data = pdata;
+		cell->pdata_size = sizeof(*pdata);
+		children++;
+	}
+
+	if (pdata->vibra) {
+		cell = &twl6040->cells[children];
+		cell->name = "twl6040-vibra";
+		cell->platform_data = pdata->vibra;
+		cell->pdata_size = sizeof(*pdata->vibra);
+		children++;
+	}
+
+	if (children) {
+		ret = mfd_add_devices(&pdev->dev, pdev->id, twl6040->cells,
+				      children, NULL, 0);
+		if (ret)
+			goto mfd_err;
+	} else {
+		dev_err(&pdev->dev, "No platform data found for children\n");
+		ret = -ENODEV;
+		goto mfd_err;
+	}
+
+	return 0;
+
+mfd_err:
+	if (twl6040->irq)
+		twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
+irq_err:
+	if (twl6040->irq)
+		twl6040_irq_exit(twl6040);
+gpio2_err:
+	if (gpio_is_valid(twl6040->audpwron))
+		gpio_free(twl6040->audpwron);
+gpio1_err:
+	platform_set_drvdata(pdev, NULL);
+	kfree(twl6040);
+	twl6040_dev = NULL;
+	return ret;
+}
+
+static int __devexit twl6040_remove(struct platform_device *pdev)
+{
+	struct twl6040 *twl6040 = platform_get_drvdata(pdev);
+
+	if (twl6040_is_powered(twl6040))
+		twl6040_power(twl6040, 0);
+
+	if (gpio_is_valid(twl6040->audpwron))
+		gpio_free(twl6040->audpwron);
+
+	twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
+
+	if (twl6040->irq)
+		twl6040_irq_exit(twl6040);
+
+	mfd_remove_devices(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(twl6040);
+	twl6040_dev = NULL;
+
+	return 0;
+}
+
+static struct platform_driver twl6040_driver = {
+	.probe		= twl6040_probe,
+	.remove		= __devexit_p(twl6040_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "twl6040",
+	},
+};
+
+static int __devinit twl6040_init(void)
+{
+	return platform_driver_register(&twl6040_driver);
+}
+module_init(twl6040_init);
+
+static void __devexit twl6040_exit(void)
+{
+	platform_driver_unregister(&twl6040_driver);
+}
+
+module_exit(twl6040_exit);
+
+MODULE_DESCRIPTION("TWL6040 MFD");
+MODULE_AUTHOR("Misael Lopez Cruz <misael.lopez@ti.com>");
+MODULE_AUTHOR("Jorge Eduardo Candelaria <jorge.candelaria@ti.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:twl6040");
diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
new file mode 100644
index 0000000..9380535
--- /dev/null
+++ b/drivers/mfd/twl6040-irq.c
@@ -0,0 +1,205 @@
+/*
+ * Interrupt controller support for TWL6040
+ *
+ * Author:     Misael Lopez Cruz <misael.lopez@ti.com>
+ *
+ * Copyright:   (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/twl6040.h>
+
+struct twl6040_irq_data {
+	int mask;
+	int status;
+};
+
+static struct twl6040_irq_data twl6040_irqs[] = {
+	{
+		.mask = TWL6040_THMSK,
+		.status = TWL6040_THINT,
+	},
+	{
+		.mask = TWL6040_PLUGMSK,
+		.status = TWL6040_PLUGINT | TWL6040_UNPLUGINT,
+	},
+	{
+		.mask = TWL6040_HOOKMSK,
+		.status = TWL6040_HOOKINT,
+	},
+	{
+		.mask = TWL6040_HFMSK,
+		.status = TWL6040_HFINT,
+	},
+	{
+		.mask = TWL6040_VIBMSK,
+		.status = TWL6040_VIBINT,
+	},
+	{
+		.mask = TWL6040_READYMSK,
+		.status = TWL6040_READYINT,
+	},
+};
+
+static inline
+struct twl6040_irq_data *irq_to_twl6040_irq(struct twl6040 *twl6040,
+					    int irq)
+{
+	return &twl6040_irqs[irq - twl6040->irq_base];
+}
+
+static void twl6040_irq_lock(struct irq_data *data)
+{
+	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&twl6040->irq_mutex);
+}
+
+static void twl6040_irq_sync_unlock(struct irq_data *data)
+{
+	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
+
+	/* write back to hardware any change in irq mask */
+	if (twl6040->irq_masks_cur != twl6040->irq_masks_cache) {
+		twl6040->irq_masks_cache = twl6040->irq_masks_cur;
+		twl6040_reg_write(twl6040, TWL6040_REG_INTMR,
+				  twl6040->irq_masks_cur);
+	}
+
+	mutex_unlock(&twl6040->irq_mutex);
+}
+
+static void twl6040_irq_enable(struct irq_data *data)
+{
+	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
+	struct twl6040_irq_data *irq_data = irq_to_twl6040_irq(twl6040,
+							       data->irq);
+
+	twl6040->irq_masks_cur &= ~irq_data->mask;
+}
+
+static void twl6040_irq_disable(struct irq_data *data)
+{
+	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
+	struct twl6040_irq_data *irq_data = irq_to_twl6040_irq(twl6040,
+							       data->irq);
+
+	twl6040->irq_masks_cur |= irq_data->mask;
+}
+
+static struct irq_chip twl6040_irq_chip = {
+	.name			= "twl6040",
+	.irq_bus_lock		= twl6040_irq_lock,
+	.irq_bus_sync_unlock	= twl6040_irq_sync_unlock,
+	.irq_enable		= twl6040_irq_enable,
+	.irq_disable		= twl6040_irq_disable,
+};
+
+static irqreturn_t twl6040_irq_thread(int irq, void *data)
+{
+	struct twl6040 *twl6040 = data;
+	u8 intid;
+	int i;
+
+	intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
+
+	/* apply masking and report (backwards to handle READYINT first) */
+	for (i = ARRAY_SIZE(twl6040_irqs) - 1; i >= 0; i--) {
+		if (twl6040->irq_masks_cur & twl6040_irqs[i].mask)
+			intid &= ~twl6040_irqs[i].status;
+		if (intid & twl6040_irqs[i].status)
+			handle_nested_irq(twl6040->irq_base + i);
+	}
+
+	/* ack unmasked irqs */
+	twl6040_reg_write(twl6040, TWL6040_REG_INTID, intid);
+
+	return IRQ_HANDLED;
+}
+
+int twl6040_irq_init(struct twl6040 *twl6040)
+{
+	int cur_irq, ret;
+	u8 val;
+
+	mutex_init(&twl6040->irq_mutex);
+
+	/* mask the individual interrupt sources */
+	twl6040->irq_masks_cur = TWL6040_ALLINT_MSK;
+	twl6040->irq_masks_cache = TWL6040_ALLINT_MSK;
+	twl6040_reg_write(twl6040, TWL6040_REG_INTMR, TWL6040_ALLINT_MSK);
+
+	if (!twl6040->irq) {
+		dev_warn(twl6040->dev,
+			 "no interrupt specified, no interrupts\n");
+		twl6040->irq_base = 0;
+		return 0;
+	}
+
+	if (!twl6040->irq_base) {
+		dev_err(twl6040->dev,
+			"no interrupt base specified, no interrupts\n");
+		return 0;
+	}
+
+	/* Register them with genirq */
+	for (cur_irq = twl6040->irq_base;
+	     cur_irq < twl6040->irq_base + ARRAY_SIZE(twl6040_irqs);
+	     cur_irq++) {
+		irq_set_chip_data(cur_irq, twl6040);
+		irq_set_chip_and_handler(cur_irq, &twl6040_irq_chip,
+					 handle_level_irq);
+		irq_set_nested_thread(cur_irq, 1);
+
+		/* ARM needs us to explicitly flag the IRQ as valid
+		 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		irq_set_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(twl6040->irq, NULL, twl6040_irq_thread,
+				   IRQF_ONESHOT, "twl6040", twl6040);
+	if (ret) {
+		dev_err(twl6040->dev, "failed to request IRQ %d: %d\n",
+			twl6040->irq, ret);
+		return ret;
+	}
+
+	/* reset interrupts */
+	val = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
+
+	/* interrupts cleared on write */
+	twl6040_clear_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_INTCLRMODE);
+
+	return 0;
+}
+EXPORT_SYMBOL(twl6040_irq_init);
+
+void twl6040_irq_exit(struct twl6040 *twl6040)
+{
+	if (twl6040->irq)
+		free_irq(twl6040->irq, twl6040);
+}
+EXPORT_SYMBOL(twl6040_irq_exit);
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index e0aba2b..ea5baa2 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -679,6 +679,7 @@ struct twl4030_audio_data {
 	/* twl6040 */
 	int audpwron_gpio;	/* audio power-on gpio */
 	int naudint_irq;	/* audio interrupt */
+	unsigned int irq_base;
 };
 
 struct twl4030_platform_data {
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
new file mode 100644
index 0000000..d384a01
--- /dev/null
+++ b/include/linux/mfd/twl6040.h
@@ -0,0 +1,261 @@
+/*
+ * MFD driver for twl6040
+ *
+ * Authors:     Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
+ *              Misael Lopez Cruz <misael.lopez@ti.com>
+ *
+ * Copyright:   (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __TWL6040_CODEC_H__
+#define __TWL6040_CODEC_H__
+
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+
+#define TWL6040_REG_ASICID		0x01
+#define TWL6040_REG_ASICREV		0x02
+#define TWL6040_REG_INTID		0x03
+#define TWL6040_REG_INTMR		0x04
+#define TWL6040_REG_NCPCTL		0x05
+#define TWL6040_REG_LDOCTL		0x06
+#define TWL6040_REG_HPPLLCTL		0x07
+#define TWL6040_REG_LPPLLCTL		0x08
+#define TWL6040_REG_LPPLLDIV		0x09
+#define TWL6040_REG_AMICBCTL		0x0A
+#define TWL6040_REG_DMICBCTL		0x0B
+#define TWL6040_REG_MICLCTL		0x0C
+#define TWL6040_REG_MICRCTL		0x0D
+#define TWL6040_REG_MICGAIN		0x0E
+#define TWL6040_REG_LINEGAIN		0x0F
+#define TWL6040_REG_HSLCTL		0x10
+#define TWL6040_REG_HSRCTL		0x11
+#define TWL6040_REG_HSGAIN		0x12
+#define TWL6040_REG_EARCTL		0x13
+#define TWL6040_REG_HFLCTL		0x14
+#define TWL6040_REG_HFLGAIN		0x15
+#define TWL6040_REG_HFRCTL		0x16
+#define TWL6040_REG_HFRGAIN		0x17
+#define TWL6040_REG_VIBCTLL		0x18
+#define TWL6040_REG_VIBDATL		0x19
+#define TWL6040_REG_VIBCTLR		0x1A
+#define TWL6040_REG_VIBDATR		0x1B
+#define TWL6040_REG_HKCTL1		0x1C
+#define TWL6040_REG_HKCTL2		0x1D
+#define TWL6040_REG_GPOCTL		0x1E
+#define TWL6040_REG_ALB			0x1F
+#define TWL6040_REG_DLB			0x20
+#define TWL6040_REG_TRIM1		0x28
+#define TWL6040_REG_TRIM2		0x29
+#define TWL6040_REG_TRIM3		0x2A
+#define TWL6040_REG_HSOTRIM		0x2B
+#define TWL6040_REG_HFOTRIM		0x2C
+#define TWL6040_REG_ACCCTL		0x2D
+#define TWL6040_REG_STATUS		0x2E
+
+#define TWL6040_CACHEREGNUM		(TWL6040_REG_STATUS + 1)
+
+#define TWL6040_VIOREGNUM		18
+#define TWL6040_VDDREGNUM		21
+
+/* INTID (0x03) fields */
+
+#define TWL6040_THINT			0x01
+#define TWL6040_PLUGINT			0x02
+#define TWL6040_UNPLUGINT		0x04
+#define TWL6040_HOOKINT			0x08
+#define TWL6040_HFINT			0x10
+#define TWL6040_VIBINT			0x20
+#define TWL6040_READYINT		0x40
+
+/* INTMR (0x04) fields */
+
+#define TWL6040_THMSK			0x01
+#define TWL6040_PLUGMSK			0x02
+#define TWL6040_HOOKMSK			0x08
+#define TWL6040_HFMSK			0x10
+#define TWL6040_VIBMSK			0x20
+#define TWL6040_READYMSK		0x40
+#define TWL6040_ALLINT_MSK		0x7B
+
+/* NCPCTL (0x05) fields */
+
+#define TWL6040_NCPENA			0x01
+#define TWL6040_NCPOPEN			0x40
+
+/* LDOCTL (0x06) fields */
+
+#define TWL6040_LSLDOENA		0x01
+#define TWL6040_HSLDOENA		0x04
+#define TWL6040_REFENA			0x40
+#define TWL6040_OSCENA			0x80
+
+/* HPPLLCTL (0x07) fields */
+
+#define TWL6040_HPLLENA			0x01
+#define TWL6040_HPLLRST			0x02
+#define TWL6040_HPLLBP			0x04
+#define TWL6040_HPLLSQRENA		0x08
+#define TWL6040_MCLK_12000KHZ		(0 << 5)
+#define TWL6040_MCLK_19200KHZ		(1 << 5)
+#define TWL6040_MCLK_26000KHZ		(2 << 5)
+#define TWL6040_MCLK_38400KHZ		(3 << 5)
+#define TWL6040_MCLK_MSK		0x60
+
+/* LPPLLCTL (0x08) fields */
+
+#define TWL6040_LPLLENA			0x01
+#define TWL6040_LPLLRST			0x02
+#define TWL6040_LPLLSEL			0x04
+#define TWL6040_LPLLFIN			0x08
+#define TWL6040_HPLLSEL			0x10
+
+/* HSLCTL (0x10) fields */
+
+#define TWL6040_HSDACMODEL		0x02
+#define TWL6040_HSDRVMODEL		0x08
+
+/* HSRCTL (0x11) fields */
+
+#define TWL6040_HSDACMODER		0x02
+#define TWL6040_HSDRVMODER		0x08
+
+/* VIBCTLL (0x18) fields */
+
+#define TWL6040_VIBENAL			0x01
+#define TWL6040_VIBCTRLL		0x04
+#define TWL6040_VIBCTRLLP		0x08
+#define TWL6040_VIBCTRLLN		0x10
+
+/* VIBDATL (0x19) fields */
+
+#define TWL6040_VIBDAT_MAX		0x64
+
+/* VIBCTLR (0x1A) fields */
+
+#define TWL6040_VIBENAR			0x01
+#define TWL6040_VIBCTRLR		0x04
+#define TWL6040_VIBCTRLRP		0x08
+#define TWL6040_VIBCTRLRN		0x10
+
+/* GPOCTL (0x1E) fields */
+
+#define TWL6040_GPO1			0x01
+#define TWL6040_GPO2			0x02
+#define TWL6040_GPO3			0x03
+
+/* ACCCTL (0x2D) fields */
+
+#define TWL6040_I2CSEL			0x01
+#define TWL6040_RESETSPLIT		0x04
+#define TWL6040_INTCLRMODE		0x08
+
+#define TWL6040_SYSCLK_SEL_LPPLL	1
+#define TWL6040_SYSCLK_SEL_HPPLL	2
+
+/* STATUS (0x2E) fields */
+
+#define TWL6040_PLUGCOMP		0x02
+#define TWL6040_VIBLOCDET		0x10
+#define TWL6040_VIBROCDET		0x20
+#define TWL6040_TSHUTDET                0x40
+
+#define TWL6040_CELLS			2
+
+#define TWL6040_REV_ES1_0		0x00
+#define TWL6040_REV_ES1_1		0x01
+#define TWL6040_REV_ES1_2		0x02
+
+#define TWL6040_IRQ_TH			0
+#define TWL6040_IRQ_PLUG		1
+#define TWL6040_IRQ_HOOK		2
+#define TWL6040_IRQ_HF			3
+#define TWL6040_IRQ_VIB			4
+#define TWL6040_IRQ_READY		5
+
+enum twl6040_pll_id {
+	TWL6040_NOPLL_ID,
+	TWL6040_LPPLL_ID,
+	TWL6040_HPPLL_ID,
+};
+
+struct twl6040 {
+	struct device *dev;
+	struct mutex mutex;
+	struct mutex io_mutex;
+	struct mutex irq_mutex;
+	struct mfd_cell cells[TWL6040_CELLS];
+	struct completion ready;
+
+	int audpwron;
+	int power_count;
+	int rev;
+
+	enum twl6040_pll_id pll;
+	unsigned int sysclk;
+
+	unsigned int irq;
+	unsigned int irq_base;
+	u8 irq_masks_cur;
+	u8 irq_masks_cache;
+};
+
+static inline int twl6040_get_rev(struct twl6040 *twl6040)
+{
+	return twl6040->rev;
+}
+
+static inline int twl6040_request_irq(struct twl6040 *twl6040, int irq,
+				      irq_handler_t handler,
+				      unsigned long irqflags,
+				      const char *name,
+				      void *data)
+{
+	if (!twl6040->irq_base)
+		return -EINVAL;
+
+	return request_threaded_irq(twl6040->irq_base + irq, NULL, handler,
+				    irqflags, name, data);
+}
+
+static inline void twl6040_free_irq(struct twl6040 *twl6040, int irq,
+				    void *data)
+{
+	if (!twl6040->irq_base)
+		return;
+
+	free_irq(twl6040->irq_base + irq, data);
+}
+
+int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg);
+int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg,
+		      u8 val);
+int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg,
+		     u8 mask);
+int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg,
+		       u8 mask);
+int twl6040_power(struct twl6040 *twl6040, int on);
+int twl6040_is_powered(struct twl6040 *twl6040);
+int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
+		    unsigned int freq_in, unsigned int freq_out);
+enum twl6040_pll_id twl6040_get_pll(struct twl6040 *twl6040);
+unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
+int twl6040_irq_init(struct twl6040 *twl6040);
+void twl6040_irq_exit(struct twl6040 *twl6040);
+
+#endif  /* End of __TWL6040_CODEC_H__ */
-- 
1.7.5.3

