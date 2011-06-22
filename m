Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab1FVSqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:46:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34012 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758606Ab1FVSqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:46:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/8] ASoC: Use new register map API for ASoC generic physical I/O
Date: Wed, 22 Jun 2011 19:45:49 +0100
Message-Id: <1308768353-19372-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the ASoC specific physical I/O code and replace it with calls
into the regmap API. The bulk write code can only be used safely if all
regmap calls are locked with the CODEC lock, we need to add bulk support
to the regmap API or replace the code with an open coded loop (though
currently it has no users...).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/sound/soc.h |    2 +
 sound/soc/Kconfig   |    1 +
 sound/soc/soc-io.c  |  316 ++++-----------------------------------------------
 3 files changed, 28 insertions(+), 291 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 6424b10..40436b8 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -19,6 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/regmap.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/control.h>
@@ -570,6 +571,7 @@ struct snd_soc_codec {
 	const void *reg_def_copy;
 	const struct snd_soc_cache_ops *cache_ops;
 	struct mutex cache_rw_mutex;
+	int val_bytes;
 
 	/* dapm */
 	struct snd_soc_dapm_context dapm;
diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 8224db5..32e5fd4 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -7,6 +7,7 @@ menuconfig SND_SOC
 	select SND_PCM
 	select AC97_BUS if SND_SOC_AC97_BUS
 	select SND_JACK if INPUT=y || INPUT=SND
+	select REGMAP
 	---help---
 
 	  If you want ASoC support, you should say Y here and also to the
diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index cca490c..5607cb6 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -13,26 +13,13 @@
 
 #include <linux/i2c.h>
 #include <linux/spi/spi.h>
+#include <linux/regmap.h>
 #include <sound/soc.h>
 
 #include <trace/events/asoc.h>
 
-#ifdef CONFIG_SPI_MASTER
-static int do_spi_write(void *control, const char *data, int len)
-{
-	struct spi_device *spi = control;
-	int ret;
-
-	ret = spi_write(spi, data, len);
-	if (ret < 0)
-		return ret;
-
-	return len;
-}
-#endif
-
-static int do_hw_write(struct snd_soc_codec *codec, unsigned int reg,
-		       unsigned int value, const void *data, int len)
+static int hw_write(struct snd_soc_codec *codec, unsigned int reg,
+		    unsigned int value)
 {
 	int ret;
 
@@ -49,13 +36,7 @@ static int do_hw_write(struct snd_soc_codec *codec, unsigned int reg,
 		return 0;
 	}
 
-	ret = codec->hw_write(codec->control_data, data, len);
-	if (ret == len)
-		return 0;
-	if (ret < 0)
-		return ret;
-	else
-		return -EIO;
+	return regmap_write(codec->control_data, reg, value);
 }
 
 static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
@@ -69,8 +50,11 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
 		if (codec->cache_only)
 			return -1;
 
-		BUG_ON(!codec->hw_read);
-		return codec->hw_read(codec, reg);
+		ret = regmap_read(codec->control_data, reg, &val);
+		if (ret == 0)
+			return val;
+		else
+			return ret;
 	}
 
 	ret = snd_soc_cache_read(codec, reg, &val);
@@ -79,183 +63,18 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
 	return val;
 }
 
-static int snd_soc_4_12_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u16 data;
-
-	data = cpu_to_be16((reg << 12) | (value & 0xffffff));
-
-	return do_hw_write(codec, reg, value, &data, 2);
-}
-
-static int snd_soc_7_9_write(struct snd_soc_codec *codec, unsigned int reg,
-			     unsigned int value)
-{
-	u16 data;
-
-	data = cpu_to_be16((reg << 9) | (value & 0x1ff));
-
-	return do_hw_write(codec, reg, value, &data, 2);
-}
-
-static int snd_soc_8_8_write(struct snd_soc_codec *codec, unsigned int reg,
-			     unsigned int value)
-{
-	u8 data[2];
-
-	reg &= 0xff;
-	data[0] = reg;
-	data[1] = value & 0xff;
-
-	return do_hw_write(codec, reg, value, data, 2);
-}
-
-static int snd_soc_8_16_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u8 data[3];
-	u16 val = cpu_to_be16(value);
-
-	data[0] = reg;
-	memcpy(&data[1], &val, sizeof(val));
-
-	return do_hw_write(codec, reg, value, data, 3);
-}
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int do_i2c_read(struct snd_soc_codec *codec,
-				void *reg, int reglen,
-				void *data, int datalen)
-{
-	struct i2c_msg xfer[2];
-	int ret;
-	struct i2c_client *client = codec->control_data;
-
-	/* Write register */
-	xfer[0].addr = client->addr;
-	xfer[0].flags = 0;
-	xfer[0].len = reglen;
-	xfer[0].buf = reg;
-
-	/* Read data */
-	xfer[1].addr = client->addr;
-	xfer[1].flags = I2C_M_RD;
-	xfer[1].len = datalen;
-	xfer[1].buf = data;
-
-	ret = i2c_transfer(client->adapter, xfer, 2);
-	if (ret == 2)
-		return 0;
-	else if (ret < 0)
-		return ret;
-	else
-		return -EIO;
-}
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_8_8_read_i2c(struct snd_soc_codec *codec,
-					 unsigned int r)
-{
-	u8 reg = r;
-	u8 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 1, &data, 1);
-	if (ret < 0)
-		return 0;
-	return data;
-}
-#else
-#define snd_soc_8_8_read_i2c NULL
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_8_16_read_i2c(struct snd_soc_codec *codec,
-					  unsigned int r)
-{
-	u8 reg = r;
-	u16 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 1, &data, 2);
-	if (ret < 0)
-		return 0;
-	return (data >> 8) | ((data & 0xff) << 8);
-}
-#else
-#define snd_soc_8_16_read_i2c NULL
-#endif
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_16_8_read_i2c(struct snd_soc_codec *codec,
-					  unsigned int r)
-{
-	u16 reg = r;
-	u8 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 2, &data, 1);
-	if (ret < 0)
-		return 0;
-	return data;
-}
-#else
-#define snd_soc_16_8_read_i2c NULL
-#endif
-
-static int snd_soc_16_8_write(struct snd_soc_codec *codec, unsigned int reg,
-			      unsigned int value)
-{
-	u8 data[3];
-	u16 rval = cpu_to_be16(reg);
-
-	memcpy(data, &rval, sizeof(rval));
-	data[2] = value;
-
-	return do_hw_write(codec, reg, value, data, 3);
-}
-
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-static unsigned int snd_soc_16_16_read_i2c(struct snd_soc_codec *codec,
-					   unsigned int r)
-{
-	u16 reg = cpu_to_be16(r);
-	u16 data;
-	int ret;
-
-	ret = do_i2c_read(codec, &reg, 2, &data, 2);
-	if (ret < 0)
-		return 0;
-	return be16_to_cpu(data);
-}
-#else
-#define snd_soc_16_16_read_i2c NULL
-#endif
-
-static int snd_soc_16_16_write(struct snd_soc_codec *codec, unsigned int reg,
-			       unsigned int value)
-{
-	u16 data[2];
-
-	data[0] = cpu_to_be16(reg);
-	data[1] = cpu_to_be16(value);
-
-	return do_hw_write(codec, reg, value, data, sizeof(data));
-}
-
 /* Primitive bulk write support for soc-cache.  The data pointed to by
- * `data' needs to already be in the form the hardware expects
- * including any leading register specific data.  Any data written
- * through this function will not go through the cache as it only
- * handles writing to volatile or out of bounds registers.
+ * `data' needs to already be in the form the hardware expects.  Any
+ * data written through this function will not go through the cache as
+ * it only handles writing to volatile or out of bounds registers.
+ *
+ * This is currently only supported for devices using the regmap API
+ * wrappers.
  */
-static int snd_soc_hw_bulk_write_raw(struct snd_soc_codec *codec, unsigned int reg,
+static int snd_soc_hw_bulk_write_raw(struct snd_soc_codec *codec,
+				     unsigned int reg,
 				     const void *data, size_t len)
 {
-	int ret;
-
 	/* To ensure that we don't get out of sync with the cache, check
 	 * whether the base register is volatile or if we've directly asked
 	 * to bypass the cache.  Out of bounds registers are considered
@@ -266,66 +85,9 @@ static int snd_soc_hw_bulk_write_raw(struct snd_soc_codec *codec, unsigned int r
 	    && reg < codec->driver->reg_cache_size)
 		return -EINVAL;
 
-	switch (codec->control_type) {
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-	case SND_SOC_I2C:
-		ret = i2c_master_send(to_i2c_client(codec->dev), data, len);
-		break;
-#endif
-#if defined(CONFIG_SPI_MASTER)
-	case SND_SOC_SPI:
-		ret = spi_write(to_spi_device(codec->dev), data, len);
-		break;
-#endif
-	default:
-		BUG();
-	}
-
-	if (ret == len)
-		return 0;
-	if (ret < 0)
-		return ret;
-	else
-		return -EIO;
+	return regmap_raw_write(codec->control_data, reg, data, len);
 }
 
-static struct {
-	int addr_bits;
-	int data_bits;
-	int (*write)(struct snd_soc_codec *codec, unsigned int, unsigned int);
-	unsigned int (*read)(struct snd_soc_codec *, unsigned int);
-	unsigned int (*i2c_read)(struct snd_soc_codec *, unsigned int);
-} io_types[] = {
-	{
-		.addr_bits = 4, .data_bits = 12,
-		.write = snd_soc_4_12_write,
-	},
-	{
-		.addr_bits = 7, .data_bits = 9,
-		.write = snd_soc_7_9_write,
-	},
-	{
-		.addr_bits = 8, .data_bits = 8,
-		.write = snd_soc_8_8_write,
-		.i2c_read = snd_soc_8_8_read_i2c,
-	},
-	{
-		.addr_bits = 8, .data_bits = 16,
-		.write = snd_soc_8_16_write,
-		.i2c_read = snd_soc_8_16_read_i2c,
-	},
-	{
-		.addr_bits = 16, .data_bits = 8,
-		.write = snd_soc_16_8_write,
-		.i2c_read = snd_soc_16_8_read_i2c,
-	},
-	{
-		.addr_bits = 16, .data_bits = 16,
-		.write = snd_soc_16_16_write,
-		.i2c_read = snd_soc_16_16_read_i2c,
-	},
-};
-
 /**
  * snd_soc_codec_set_cache_io: Set up standard I/O functions.
  *
@@ -349,46 +111,18 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
-	int i;
+	struct regmap_config config;
 
-	for (i = 0; i < ARRAY_SIZE(io_types); i++)
-		if (io_types[i].addr_bits == addr_bits &&
-		    io_types[i].data_bits == data_bits)
-			break;
-	if (i == ARRAY_SIZE(io_types)) {
-		printk(KERN_ERR
-		       "No I/O functions for %d bit address %d bit data\n",
-		       addr_bits, data_bits);
-		return -EINVAL;
-	}
-
-	codec->write = io_types[i].write;
+	codec->write = hw_write;
 	codec->read = hw_read;
 	codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
 
-	switch (control) {
-	case SND_SOC_I2C:
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
-		codec->hw_write = (hw_write_t)i2c_master_send;
-#endif
-		if (io_types[i].i2c_read)
-			codec->hw_read = io_types[i].i2c_read;
-
-		codec->control_data = container_of(codec->dev,
-						   struct i2c_client,
-						   dev);
-		break;
+	config.reg_bits = addr_bits;
+	config.val_bits = data_bits;
 
-	case SND_SOC_SPI:
-#ifdef CONFIG_SPI_MASTER
-		codec->hw_write = do_spi_write;
-#endif
-
-		codec->control_data = container_of(codec->dev,
-						   struct spi_device,
-						   dev);
-		break;
-	}
+	codec->control_data = regmap_init(codec->dev, &config);
+	if (IS_ERR(codec->control_data))
+		return PTR_ERR(codec->control_data);
 
 	return 0;
 }
-- 
1.7.5.4

