Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1IENSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:18:36 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1195 "EHLO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753774Ab1IENSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:18:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 29850
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] ASoC: Allow codecs to provide their own regmap configuration
Date: Mon,  5 Sep 2011 15:18:01 +0200
Message-Id: <1315228682-1097-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1315228682-1097-1-git-send-email-lars@metafoo.de>
References: <1315228682-1097-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a codec can either do the whole regmap initialization on its own or
provide only the register and value bit size and let the core handle
initialization. This patch allows a codec to provide a complete regmap
configuration while still letting ASoC core handle the regmap initialization
and setup.

This is useful for cases where we want to specify more than just the register and
value bit size of the regmap configuration, for example read and write flag masks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/sound/soc.h |    3 +++
 sound/soc/soc-io.c  |   49 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 6da55a1..fcb0528 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -301,6 +301,9 @@ int snd_soc_codec_writable_register(struct snd_soc_codec *codec,
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control);
+int snd_soc_codec_regmap_init(struct snd_soc_codec *codec,
+			      struct regmap_config *config,
+			      enum snd_soc_control_type control);
 int snd_soc_cache_sync(struct snd_soc_codec *codec);
 int snd_soc_cache_init(struct snd_soc_codec *codec);
 int snd_soc_cache_exit(struct snd_soc_codec *codec);
diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index 66fcccd..abc55af 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -97,16 +97,7 @@ static int snd_soc_hw_bulk_write_raw(struct snd_soc_codec *codec,
  * @data_bits: Number of bits of data per register.
  * @control: Control bus used.
  *
- * Register formats are frequently shared between many I2C and SPI
- * devices.  In order to promote code reuse the ASoC core provides
- * some standard implementations of CODEC read and write operations
- * which can be set up using this function.
- *
- * The caller is responsible for allocating and initialising the
- * actual cache.
- *
- * Note that at present this code cannot be used by CODECs with
- * volatile registers.
+ * Legacy and convenience wrapper around snd_soc_codec_regmap_init
  */
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			       int addr_bits, int data_bits,
@@ -115,25 +106,43 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 	struct regmap_config config;
 
 	memset(&config, 0, sizeof(config));
+	config.reg_bits = addr_bits;
+	config.val_bits = data_bits;
+
+	return snd_soc_codec_regmap_init(codec, &config, control);
+}
+EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
+
+/**
+ * snd_soc_codec_init_regmap: Set up regmap for the CODEC I/O functions.
+ *
+ * @codec: CODEC to configure.
+ * @config: regmap configuration for the CODEC
+ * @control: Control bus used.
+ *
+ * Initializes regmap for the specified control bus and hooks it up to the
+ * CODEC I/O functions.
+ */
+int snd_soc_codec_regmap_init(struct snd_soc_codec *codec,
+			      struct regmap_config *config,
+			      enum snd_soc_control_type control)
+{
 	codec->write = hw_write;
 	codec->read = hw_read;
 	codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
 
-	config.reg_bits = addr_bits;
-	config.val_bits = data_bits;
-
 	switch (control) {
 #if defined(CONFIG_REGMAP_I2C) || defined(CONFIG_REGMAP_I2C_MODULE)
 	case SND_SOC_I2C:
 		codec->control_data = regmap_init_i2c(to_i2c_client(codec->dev),
-						      &config);
+						      config);
 		break;
 #endif
 
 #if defined(CONFIG_REGMAP_SPI) || defined(CONFIG_REGMAP_SPI_MODULE)
 	case SND_SOC_SPI:
 		codec->control_data = regmap_init_spi(to_spi_device(codec->dev),
-						      &config);
+						      config);
 		break;
 #endif
 
@@ -150,7 +159,7 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
+EXPORT_SYMBOL_GPL(snd_soc_codec_regmap_init);
 #else
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			       int addr_bits, int data_bits,
@@ -159,4 +168,12 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 	return -ENOTSUPP;
 }
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
+
+int snd_soc_codec_regmap_init(struct snd_soc_codec *codec,
+			      struct regmap_config *config,
+			      enum snd_soc_control_type control)
+{
+	return -ENOTSUPP;
+}
+EXPORT_SYMBOL_GPL(snd_soc_codec_regmap_init);
 #endif
-- 
1.7.2.5

