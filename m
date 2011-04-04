Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1DDHt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:49:56 -0400
Received: from router.aksignal.cz ([188.175.113.102]:34377 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1DDHty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:49:54 -0400
Message-ID: <4D99781D.3030807@aksignal.cz>
Date: Mon, 04 Apr 2011 09:49:49 +0200
From: =?ISO-8859-2?Q?Prchal_Ji=F8=ED?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org
CC: vbarinov@embeddedalley.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and
 clock on GPIO2 or BCLK
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B1AFD.5060508@aksignal.cz> <20110402082604.GE21737@sirena.org.uk>
In-Reply-To: <20110402082604.GE21737@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dne 2.4.2011 10:26, Mark Brown napsal(a):
> On Thu, Mar 24, 2011 at 11:20:45AM +0100, Prchal Ji?? wrote:
>> Hi,
>> this patch ads SPI communication for codecs TLV320AIC3X and clock input on GPIO2 or BCLK.
>> Tested on TLV320AIC3106 and AT91SAM9260.
>> TODO: Set the model in SPI probe the right way. I don't know how.
> 
> Register two SPI drivers with different names.
???

>> This codec communicates on SPI in 1st byte: 7 MSB is register address, 1 LSB is read/write, 2nd byte data. For this
>> reason there is new functions in soc-cache.c snd_soc_7_8_*.
> 
> This looks mostly good but there's some cleanups needed, mostly from
> extra stuff which snuck in there, and you need to rebase against current
> code.
What cleanup? I copy functions snd_soc_8_8_* and made change to 7_8.

> As covered in SubmittingPatches you should always CC maintainers on
> patches.
Who is maintainer? I didn't find anyone, so I CC to author.

>>  config SND_SOC_AD73311
>>  	tristate
>> -
>> +
> 
> Random whitespace change, should be removed.
Yes.

>>   * Author:      Vladimir Barinov, <vbarinov@embeddedalley.com>
>> + *              Jiri Prchal, <jiri.prchal@aksignal.cz
> 
> If you're going to do this you probably want a > in there.
OK

>>  {
>>  	struct snd_soc_codec *codec = codec_dai->codec;
>>  	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
>> +	u8 data;
>> +
>> +	/* set external clock on GPIO2 or BCLK */
>> +	data = snd_soc_read(codec, AIC3X_CLKGEN_CTRL_REG);
>> +	data &= 0x0f;
>> +	data |= ((clk_id << PLLCLK_IN_SHIFT) | (clk_id << CLKDIV_IN_SHIFT));
>> +	snd_soc_write(codec, AIC3X_CLKGEN_CTRL_REG, data);
> 
> This looks like an unrelated change which is specific to your board.
> You should add an interface for configuring this functionality .
No, it's for all, who uses other clock source. Interface is standard function:
	/* Set the codec system clock for DAC and ADC */
	ret = snd_soc_dai_set_sysclk(codec_dai,
				     CLKIN_BCLK, cdu_audio[i].codecclk,
				     SND_SOC_CLOCK_IN);

>>  	if (ret != 0) {
>> -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
>> +		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);
> 
> Why are you decapitalising th estart of the sentance here?
Corrected.

>> +static struct spi_driver aic3x_spi_driver = {
>> +	.driver = {
>> +		.name	= "tlv320aic3x-codec",
>> +		.owner	= THIS_MODULE,
> 
> Remove the -codec from the driver name.
Why? In I2C part it must be there, so should it be same?

>> +/* special functions for codecs with 7 bit register address and LSB read/write (like TLV320AIC3X) */
>> +static unsigned int snd_soc_7_8_read(struct snd_soc_codec *codec,
>> +				     unsigned int reg)
>> +{
>> +	int ret;
>> +	unsigned int val;
> 
> This won't apply against the current kernel and should be a separate
> patch, it's a generic thing rather than part of the CODEC driver.
I split it to another PATCH.

> --
> To unsubscribe from this list: send the line "unsubscribe alsa-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/Kconfig
linux-2.6.38-patch/sound/soc/codecs/Kconfig
--- linux-2.6.38-vanilla/sound/soc/codecs/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/codecs/Kconfig	2011-04-04 08:30:12.115356779 +0200
@@ -37,7 +37,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TLV320AIC23 if I2C
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
-	select SND_SOC_TLV320AIC3X if I2C
+	select SND_SOC_TLV320AIC3X if SND_SOC_I2C_AND_SPI
 	select SND_SOC_TPA6130A2 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.c
linux-2.6.38-patch/sound/soc/codecs/tlv320aic3x.c
--- linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/codecs/tlv320aic3x.c	2011-04-04 08:31:33.521844547 +0200
@@ -2,7 +2,9 @@
  * ALSA SoC TLV320AIC3X codec driver
  *
  * Author:      Vladimir Barinov, <vbarinov@embeddedalley.com>
+ *              Jiri Prchal, <jiri.prchal@aksignal.cz>
  * Copyright:   (C) 2007 MontaVista Software, Inc., <source@mvista.com>
+ *              (C) 2011 AK signal Brno
  *
  * Based on sound/soc/codecs/wm8753.c by Liam Girdwood
  *
@@ -42,6 +44,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/spi/spi.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -864,9 +867,15 @@ static int aic3x_hw_params(struct snd_pc
 		snd_soc_write(codec, AIC3X_PLL_PROGA_REG, reg | PLL_ENABLE);
 	}

-	/* Route Left DAC to left channel input and
-	 * right DAC to right channel input */
-	data = (LDAC2LCH | RDAC2RCH);
+	/* If is stereo: Route Left DAC to left channel input and
+	 * right DAC to right channel input
+	 * else mono: route left input to both DAC
+	 */
+	if (params_channels(params) == 2)
+		data = (LDAC2LCH | RDAC2RCH);
+	else
+		data = (LDAC2LCH | RDAC2LCH);
+
 	data |= (fsref == 44100) ? FSREF_44100 : FSREF_48000;
 	if (params_rate(params) >= 64000)
 		data |= DUAL_RATE_MODE;
@@ -984,6 +993,13 @@ static int aic3x_set_dai_sysclk(struct s
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
+	u8 data;
+
+	/* set external clock on GPIO2 or BCLK */
+	data = snd_soc_read(codec, AIC3X_CLKGEN_CTRL_REG);
+	data &= 0x0f;
+	data |= ((clk_id << PLLCLK_IN_SHIFT) | (clk_id << CLKDIV_IN_SHIFT));
+	snd_soc_write(codec, AIC3X_CLKGEN_CTRL_REG, data);

 	aic3x->sysclk = freq;
 	return 0;
@@ -1371,7 +1387,10 @@ static int aic3x_probe(struct snd_soc_co
 	aic3x->codec = codec;
 	codec->dapm.idle_bias_off = 1;

-	ret = snd_soc_codec_set_cache_io(codec, 8, 8, aic3x->control_type);
+	if (aic3x->control_type == SND_SOC_I2C)
+		ret = snd_soc_codec_set_cache_io(codec, 8, 8, aic3x->control_type);
+	else
+		ret = snd_soc_codec_set_cache_io(codec, 7, 8, aic3x->control_type);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
@@ -1472,6 +1491,54 @@ static struct snd_soc_codec_driver soc_c
 	.resume = aic3x_resume,
 };

+#if defined(CONFIG_SPI_MASTER)
+static int aic3x_spi_probe(struct spi_device *spi)
+{
+	struct aic3x_pdata *pdata = spi->dev.platform_data;
+	struct aic3x_priv *aic3x;
+	int ret;
+
+	aic3x = kzalloc(sizeof(struct aic3x_priv), GFP_KERNEL);
+	if (aic3x == NULL) {
+		dev_err(&spi->dev, "failed to create private data\n");
+		return -ENOMEM;
+	}
+
+	aic3x->control_type = SND_SOC_SPI;
+	spi_set_drvdata(spi, aic3x);
+
+	if (pdata) {
+		aic3x->gpio_reset = pdata->gpio_reset;
+		aic3x->setup = pdata->setup;
+	} else {
+		aic3x->gpio_reset = -1;
+	}
+
+	aic3x->model = AIC3X_MODEL_3X;
+
+	ret = snd_soc_register_codec(&spi->dev, &soc_codec_dev_aic3x, &aic3x_dai, 1);
+	if (ret < 0)
+		kfree(aic3x);
+	return ret;
+}
+
+static int __devexit aic3x_spi_remove(struct spi_device *spi)
+{
+	snd_soc_unregister_codec(&spi->dev);
+	kfree(spi_get_drvdata(spi));
+	return 0;
+}
+
+static struct spi_driver aic3x_spi_driver = {
+	.driver = {
+		.name	= "tlv320aic3x-codec",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aic3x_spi_probe,
+	.remove		= __devexit_p(aic3x_spi_remove),
+};
+#endif /* CONFIG_SPI_MASTER */
+
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 /*
  * AIC3X 2 wire address can be up to 4 devices with device addresses
@@ -1557,6 +1624,13 @@ static int __init aic3x_modinit(void)
 		       ret);
 	}
 #endif
+#if defined(CONFIG_SPI_MASTER)
+	ret = spi_register_driver(&aic3x_spi_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "Failed to register AIC3X SPI driver: %d\n",
+		       ret);
+	}
+#endif
 	return ret;
 }
 module_init(aic3x_modinit);
@@ -1566,6 +1640,9 @@ static void __exit aic3x_exit(void)
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	i2c_del_driver(&aic3x_i2c_driver);
 #endif
+#if defined(CONFIG_SPI_MASTER)
+	spi_unregister_driver(&aic3x_spi_driver);
+#endif
 }
 module_exit(aic3x_exit);

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.h
linux-2.6.38-patch/sound/soc/codecs/tlv320aic3x.h
--- linux-2.6.38-vanilla/sound/soc/codecs/tlv320aic3x.h	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/codecs/tlv320aic3x.h	2011-03-25 12:15:06.620049184 +0100
@@ -163,6 +163,10 @@
 #define DUAL_RATE_MODE		((1 << 5) | (1 << 6))
 #define LDAC2LCH		(0x1 << 3)
 #define RDAC2RCH		(0x1 << 1)
+#define LDAC2RCH		(0x2 << 3)
+#define RDAC2LCH		(0x2 << 1)
+#define LDAC2MONOMIX		(0x3 << 3)
+#define RDAC2MONOMIX		(0x3 << 1)

 /* PLL registers bitfields */
 #define PLLP_SHIFT		0
@@ -178,6 +182,13 @@
 #define PLL_CLKIN_SHIFT		4
 #define MCLK_SOURCE		0x0
 #define PLL_CLKDIV_SHIFT	0
+#define PLLCLK_IN_SHIFT		4
+#define CLKDIV_IN_SHIFT		6
+/* clock in source */
+#define CLKIN_MCLK		0
+#define CLKIN_GPIO2		1
+#define CLKIN_BCLK		2
+

 /* Software reset register bits */
 #define SOFT_RESET		0x80
