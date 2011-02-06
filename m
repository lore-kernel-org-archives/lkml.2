Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1BFXEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:04:13 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1144 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753778Ab1BFXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:03:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 15254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] ASoC: neo1973_wm8753: Move lm4857 specefic code to its own module
Date: Mon,  7 Feb 2011 00:04:18 +0100
Message-Id: <1297033463-14577-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the code for the lm4857 AMP from the neo1973_wm8753 sound
board driver to its own module.
The lm4857 is a generic AMP IC and not specific to the neo1973.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/Kconfig           |    3 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/lm4857.c          |  236 ++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/lm4857.h          |   23 ++++
 sound/soc/samsung/Kconfig          |    1 +
 sound/soc/samsung/lm4857.h         |   32 -----
 sound/soc/samsung/neo1973_wm8753.c |  195 +-----------------------------
 7 files changed, 267 insertions(+), 225 deletions(-)
 create mode 100644 sound/soc/codecs/lm4857.c
 create mode 100644 sound/soc/codecs/lm4857.h
 delete mode 100644 sound/soc/samsung/lm4857.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index e239345..3e10344 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -338,6 +338,9 @@ config SND_SOC_WM9713
 	tristate
 
 # Amp
+config SND_SOC_LM4857
+	tristate
+
 config SND_SOC_MAX9877
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index ae10507..87ce9bd 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -75,6 +75,7 @@ snd-soc-wm-hubs-objs := wm_hubs.o
 snd-soc-jz4740-codec-objs := jz4740.o
 
 # Amp
+snd-soc-lm4857-objs := lm4857.o
 snd-soc-max9877-objs := max9877.o
 snd-soc-tpa6130a2-objs := tpa6130a2.o
 snd-soc-wm2000-objs := wm2000.o
@@ -157,6 +158,7 @@ obj-$(CONFIG_SND_SOC_WM9713)	+= snd-soc-wm9713.o
 obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
 
 # Amp
+obj-$(CONFIG_SND_SOC_LM4857)	+= snd-soc-lm4857.o
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
 obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
 obj-$(CONFIG_SND_SOC_WM2000)	+= snd-soc-wm2000.o
diff --git a/sound/soc/codecs/lm4857.c b/sound/soc/codecs/lm4857.c
new file mode 100644
index 0000000..2d726c0
--- /dev/null
+++ b/sound/soc/codecs/lm4857.c
@@ -0,0 +1,236 @@
+/*
+ * LM4857 AMP driver
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC.
+ * Author: Graeme Gregory
+ *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+
+#include <sound/core.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/tlv.h>
+
+#include "lm4857.h"
+
+static struct {
+	struct i2c_client *i2c;
+	uint8_t regs[4];
+	uint8_t state;
+} lm4857 = {
+	.regs = {0x00, 0x40, 0x80, 0xC0},
+};
+
+/* The register offsets in the cache array */
+#define LM4857_MVOL 0
+#define LM4857_LVOL 1
+#define LM4857_RVOL 2
+#define LM4857_CTRL 3
+
+/* the shifts required to set these bits */
+#define LM4857_3D 5
+#define LM4857_WAKEUP 5
+#define LM4857_EPGAIN 4
+
+static void lm4857_write_regs(void)
+{
+	if (!lm4857.i2c)
+		return;
+
+	if (i2c_master_send(lm4857.i2c, lm4857.regs, 4) != 4)
+		dev_err(&lm4857.i2c->dev, "lm4857: i2c write failed\n");
+}
+
+static int lm4857_get_reg(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct soc_mixer_control *mc =
+		(struct soc_mixer_control *)kcontrol->private_value;
+	int reg = mc->reg;
+	int shift = mc->shift;
+	int mask = mc->max;
+
+	ucontrol->value.integer.value[0] = (lm4857.regs[reg] >> shift) & mask;
+	return 0;
+}
+
+static int lm4857_set_reg(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct soc_mixer_control *mc =
+		(struct soc_mixer_control *)kcontrol->private_value;
+	int reg = mc->reg;
+	int shift = mc->shift;
+	int mask = mc->max;
+
+	if (((lm4857.regs[reg] >> shift) & mask) ==
+		ucontrol->value.integer.value[0])
+		return 0;
+
+	lm4857.regs[reg] &= ~(mask << shift);
+	lm4857.regs[reg] |= ucontrol->value.integer.value[0] << shift;
+
+	lm4857_write_regs();
+
+	return 1;
+}
+
+static int lm4857_get_mode(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	uint8_t value = lm4857.regs[LM4857_CTRL] & 0x0F;
+
+	if (value)
+		value -= 5;
+
+	ucontrol->value.integer.value[0] = value;
+
+	return 0;
+}
+
+static int lm4857_set_mode(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	uint8_t value = ucontrol->value.integer.value[0];
+
+	if (value)
+		value += 5;
+
+	if ((lm4857.regs[LM4857_CTRL] & 0x0F) == value)
+		return 0;
+
+	lm4857.regs[LM4857_CTRL] &= 0xF0;
+	lm4857.regs[LM4857_CTRL] |= value;
+	lm4857_write_regs();
+	return 1;
+}
+
+static const char *lm4857_mode[] = {
+	"Off",
+	"Call Speaker",
+	"Stereo Speakers",
+	"Stereo Speakers + Headphones",
+	"Headphones"
+};
+
+static const struct soc_enum lm4857_mode_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(lm4857_mode), lm4857_mode),
+};
+
+static const DECLARE_TLV_DB_SCALE(stereo_tlv, -4050, 150, 0);
+static const DECLARE_TLV_DB_SCALE(mono_tlv, -3450, 150, 0);
+
+static const struct snd_kcontrol_new lm4857_controls[] = {
+	SOC_SINGLE_EXT_TLV("Amp Left Playback Volume", LM4857_LVOL, 0, 31, 0,
+		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
+	SOC_SINGLE_EXT_TLV("Amp Right Playback Volume", LM4857_RVOL, 0, 31, 0,
+		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
+	SOC_SINGLE_EXT_TLV("Amp Mono Playback Volume", LM4857_MVOL, 0, 31, 0,
+		lm4857_get_reg, lm4857_set_reg, mono_tlv),
+	SOC_ENUM_EXT("Amp Mode", lm4857_mode_enum[0],
+		lm4857_get_mode, lm4857_set_mode),
+	SOC_SINGLE_EXT("Amp Spk 3D Playback Switch", LM4857_LVOL, 5, 1, 0,
+		lm4857_get_reg, lm4857_set_reg),
+	SOC_SINGLE_EXT("Amp HP 3d Playback Switch", LM4857_RVOL, 5, 1, 0,
+		lm4857_get_reg, lm4857_set_reg),
+	SOC_SINGLE_EXT("Amp Fast Wakeup Playback Switch", LM4857_CTRL, 5, 1, 0,
+		lm4857_get_reg, lm4857_set_reg),
+	SOC_SINGLE_EXT("Amp Earpiece 6dB Playback Switch", LM4857_CTRL, 4, 1, 0,
+		lm4857_get_reg, lm4857_set_reg),
+};
+
+int lm4857_add_controls(struct snd_soc_codec *codec)
+{
+	return snd_soc_add_controls(codec, lm4857_controls,
+				ARRAY_SIZE(lm4857_controls));
+}
+EXPORT_SYMBOL_GPL(lm4857_add_controls);
+
+static int __devinit lm4857_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	lm4857.i2c = client;
+	lm4857_write_regs();
+	return 0;
+}
+
+static int __devexit lm4857_remove(struct i2c_client *client)
+{
+	lm4857.i2c = NULL;
+	return 0;
+}
+
+static void lm4857_shutdown(struct i2c_client *client)
+{
+	lm4857.regs[LM4857_CTRL] &= 0xF0;
+	lm4857_write_regs();
+}
+
+#ifdef CONFIG_PM
+
+static int lm4857_suspend(struct i2c_client *client, pm_message_t state)
+{
+	lm4857.state = lm4857.regs[LM4857_CTRL] & 0xF;
+
+	if (lm4857.state)
+		lm4857_shutdown(lm4857.i2c);
+
+	return 0;
+}
+
+static int lm4857_resume(struct i2c_client *dev)
+{
+	if (lm4857.state) {
+		lm4857.regs[LM4857_CTRL] |= (lm4857.state & 0x0F);
+		lm4857_write_regs();
+	}
+	return 0;
+}
+
+#else
+#define lm4857_suspend NULL
+#define lm4857_resume NULL
+#endif
+
+static const struct i2c_device_id lm4857_i2c_id[] = {
+	{ "lm4857", 0 },
+	{ }
+};
+
+static struct i2c_driver lm4857_i2c_driver = {
+	.driver = {
+		.name = "LM4857 I2C Amp",
+		.owner = THIS_MODULE,
+	},
+	.probe =          lm4857_probe,
+	.remove =         __devexit_p(lm4857_remove),
+	.suspend =        lm4857_suspend,
+	.resume	=         lm4857_resume,
+	.shutdown =       lm4857_shutdown,
+	.id_table =       lm4857_i2c_id,
+};
+
+static int __init lm4857_init(void)
+{
+	return i2c_add_driver(&lm4857_i2c_driver);
+}
+module_init(lm4857_init);
+
+static void __exit lm4857_exit(void)
+{
+	i2c_del_driver(&lm4857_i2c_driver);
+}
+module_exit(lm4857_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("LM4857 amplifier driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/lm4857.h b/sound/soc/codecs/lm4857.h
new file mode 100644
index 0000000..9b28457
--- /dev/null
+++ b/sound/soc/codecs/lm4857.h
@@ -0,0 +1,23 @@
+/*
+ * lm4857.h  --  ALSA Soc Audio Layer
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC.
+ * Author: Graeme Gregory
+ *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  Revision history
+ *    18th Jun 2007   Initial version.
+ */
+
+#ifndef LM4857_H_
+#define LM4857_H_
+
+int lm4857_add_controls(struct snd_soc_codec *codec);
+
+#endif /*LM4857_H_*/
+
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index a6a6b5f..ba78e26 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -39,6 +39,7 @@ config SND_SOC_SAMSUNG_NEO1973_WM8753
 	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA01
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
+	select SND_SOC_LM4857
 	help
 	  Say Y if you want to add support for SoC audio on smdk2440
 	  with the WM8753.
diff --git a/sound/soc/samsung/lm4857.h b/sound/soc/samsung/lm4857.h
deleted file mode 100644
index 0cf5b70..0000000
--- a/sound/soc/samsung/lm4857.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * lm4857.h  --  ALSA Soc Audio Layer
- *
- * Copyright 2007 Wolfson Microelectronics PLC.
- * Author: Graeme Gregory
- *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  Revision history
- *    18th Jun 2007   Initial version.
- */
-
-#ifndef LM4857_H_
-#define LM4857_H_
-
-/* The register offsets in the cache array */
-#define LM4857_MVOL 0
-#define LM4857_LVOL 1
-#define LM4857_RVOL 2
-#define LM4857_CTRL 3
-
-/* the shifts required to set these bits */
-#define LM4857_3D 5
-#define LM4857_WAKEUP 5
-#define LM4857_EPGAIN 4
-
-#endif /*LM4857_H_*/
-
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index 1ea6e61..21e85b0 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -17,11 +17,9 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/i2c.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
-#include <sound/tlv.h>
 
 #include <asm/mach-types.h>
 #include <mach/regs-clock.h>
@@ -33,12 +31,11 @@
 #include <plat/regs-iis.h>
 
 #include "../codecs/wm8753.h"
-#include "lm4857.h"
+#include "../codecs/lm4857.h"
 #include "dma.h"
 #include "s3c24xx-i2s.h"
 
 static struct snd_soc_card neo1973;
-static struct i2c_client *i2c;
 
 static int neo1973_hifi_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
@@ -213,83 +210,6 @@ static struct snd_soc_ops neo1973_voice_ops = {
 	.hw_free = neo1973_voice_hw_free,
 };
 
-static u8 lm4857_regs[4] = {0x00, 0x40, 0x80, 0xC0};
-
-static void lm4857_write_regs(void)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	if (i2c_master_send(i2c, lm4857_regs, 4) != 4)
-		printk(KERN_ERR "lm4857: i2c write failed\n");
-}
-
-static int lm4857_get_reg(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-	int reg = mc->reg;
-	int shift = mc->shift;
-	int mask = mc->max;
-
-	pr_debug("Entered %s\n", __func__);
-
-	ucontrol->value.integer.value[0] = (lm4857_regs[reg] >> shift) & mask;
-	return 0;
-}
-
-static int lm4857_set_reg(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-	int reg = mc->reg;
-	int shift = mc->shift;
-	int mask = mc->max;
-
-	if (((lm4857_regs[reg] >> shift) & mask) ==
-		ucontrol->value.integer.value[0])
-		return 0;
-
-	lm4857_regs[reg] &= ~(mask << shift);
-	lm4857_regs[reg] |= ucontrol->value.integer.value[0] << shift;
-	lm4857_write_regs();
-	return 1;
-}
-
-static int lm4857_get_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	u8 value = lm4857_regs[LM4857_CTRL] & 0x0F;
-
-	pr_debug("Entered %s\n", __func__);
-
-	if (value)
-		value -= 5;
-
-	ucontrol->value.integer.value[0] = value;
-	return 0;
-}
-
-static int lm4857_set_mode(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	u8 value = ucontrol->value.integer.value[0];
-
-	pr_debug("Entered %s\n", __func__);
-
-	if (value)
-		value += 5;
-
-	if ((lm4857_regs[LM4857_CTRL] & 0x0F) == value)
-		return 0;
-
-	lm4857_regs[LM4857_CTRL] &= 0xF0;
-	lm4857_regs[LM4857_CTRL] |= value;
-	lm4857_write_regs();
-	return 1;
-}
-
 static const struct snd_soc_dapm_widget wm8753_dapm_widgets[] = {
 	SND_SOC_DAPM_LINE("Audio Out", NULL),
 	SND_SOC_DAPM_LINE("GSM Line Out", NULL),
@@ -324,40 +244,6 @@ static const struct snd_soc_dapm_route dapm_routes[] = {
 	{"ACIN", NULL, "ACOP"},
 };
 
-static const char *lm4857_mode[] = {
-	"Off",
-	"Call Speaker",
-	"Stereo Speakers",
-	"Stereo Speakers + Headphones",
-	"Headphones"
-};
-
-static const struct soc_enum lm4857_mode_enum[] = {
-	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(lm4857_mode), lm4857_mode),
-};
-
-static const DECLARE_TLV_DB_SCALE(stereo_tlv, -4050, 150, 0);
-static const DECLARE_TLV_DB_SCALE(mono_tlv, -3450, 150, 0);
-
-static const struct snd_kcontrol_new wm8753_neo1973_controls[] = {
-	SOC_SINGLE_EXT_TLV("Amp Left Playback Volume", LM4857_LVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
-	SOC_SINGLE_EXT_TLV("Amp Right Playback Volume", LM4857_RVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, stereo_tlv),
-	SOC_SINGLE_EXT_TLV("Amp Mono Playback Volume", LM4857_MVOL, 0, 31, 0,
-		lm4857_get_reg, lm4857_set_reg, mono_tlv),
-	SOC_ENUM_EXT("Amp Mode", lm4857_mode_enum[0],
-		lm4857_get_mode, lm4857_set_mode),
-	SOC_SINGLE_EXT("Amp Spk 3D Playback Switch", LM4857_LVOL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp HP 3d Playback Switch", LM4857_RVOL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp Fast Wakeup Playback Switch", LM4857_CTRL, 5, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-	SOC_SINGLE_EXT("Amp Earpiece 6dB Playback Switch", LM4857_CTRL, 4, 1, 0,
-		lm4857_get_reg, lm4857_set_reg),
-};
-
 /*
  * This is an example machine initialisation for a wm8753 connected to a
  * neo1973 II. It is missing logic to detect hp/mic insertions and logic
@@ -391,8 +277,7 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_disable_pin(codec, "Call Mic");
 
 	/* add neo1973 specific controls */
-	err = snd_soc_add_controls(codec, wm8753_neo1973_controls,
-				ARRAY_SIZE(8753_neo1973_controls));
+	err = lm4857_add_controls(codec);
 	if (err < 0)
 		return err;
 
@@ -449,79 +334,6 @@ static struct snd_soc_card neo1973 = {
 	.num_links = ARRAY_SIZE(neo1973_dai),
 };
 
-static int lm4857_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	i2c = client;
-
-	lm4857_write_regs();
-	return 0;
-}
-
-static int lm4857_i2c_remove(struct i2c_client *client)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	i2c = NULL;
-
-	return 0;
-}
-
-static u8 lm4857_state;
-
-static int lm4857_suspend(struct i2c_client *dev, pm_message_t state)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	dev_dbg(&dev->dev, "lm4857_suspend\n");
-	lm4857_state = lm4857_regs[LM4857_CTRL] & 0xf;
-	if (lm4857_state) {
-		lm4857_regs[LM4857_CTRL] &= 0xf0;
-		lm4857_write_regs();
-	}
-	return 0;
-}
-
-static int lm4857_resume(struct i2c_client *dev)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	if (lm4857_state) {
-		lm4857_regs[LM4857_CTRL] |= (lm4857_state & 0x0f);
-		lm4857_write_regs();
-	}
-	return 0;
-}
-
-static void lm4857_shutdown(struct i2c_client *dev)
-{
-	pr_debug("Entered %s\n", __func__);
-
-	dev_dbg(&dev->dev, "lm4857_shutdown\n");
-	lm4857_regs[LM4857_CTRL] &= 0xf0;
-	lm4857_write_regs();
-}
-
-static const struct i2c_device_id lm4857_i2c_id[] = {
-	{ "neo1973_lm4857", 0 },
-	{ }
-};
-
-static struct i2c_driver lm4857_i2c_driver = {
-	.driver = {
-		.name = "LM4857 I2C Amp",
-		.owner = THIS_MODULE,
-	},
-	.suspend =        lm4857_suspend,
-	.resume	=         lm4857_resume,
-	.shutdown =       lm4857_shutdown,
-	.probe =          lm4857_i2c_probe,
-	.remove =         lm4857_i2c_remove,
-	.id_table =       lm4857_i2c_id,
-};
-
 static struct platform_device *neo1973_snd_device;
 
 static int __init neo1973_init(void)
@@ -548,8 +360,6 @@ static int __init neo1973_init(void)
 		return ret;
 	}
 
-	ret = i2c_add_driver(&lm4857_i2c_driver);
-
 	if (ret != 0)
 		platform_device_unregister(neo1973_snd_device);
 
@@ -560,7 +370,6 @@ static void __exit neo1973_exit(void)
 {
 	pr_debug("Entered %s\n", __func__);
 
-	i2c_del_driver(&lm4857_i2c_driver);
 	platform_device_unregister(neo1973_snd_device);
 }
 
-- 
1.7.2.3

