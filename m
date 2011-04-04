Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1DDICB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:02:01 -0400
Received: from router.aksignal.cz ([188.175.113.102]:45794 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1DDIB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:01:59 -0400
Message-ID: <4D997AF2.5040601@aksignal.cz>
Date: Mon, 04 Apr 2011 10:01:54 +0200
From: =?ISO-8859-2?Q?Prchal_Ji=F8=ED?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: ASoc: new functions snd_soc_7_8_*
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B1AFD.5060508@aksignal.cz> <20110402082604.GE21737@sirena.org.uk>
In-Reply-To: <20110402082604.GE21737@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is separated generic part of previous patch.
It contains read and write functions for codecs which communicate via SPI with 7bit register address, 1 LSB is
read/write and 2nd byte data.

Dne 2.4.2011 10:26, Mark Brown napsal(a):
>> +/* special functions for codecs with 7 bit register address and LSB read/write (like TLV320AIC3X) */
>> +static unsigned int snd_soc_7_8_read(struct snd_soc_codec *codec,
>> +				     unsigned int reg)
>> +{
>> +	int ret;
>> +	unsigned int val;
> 
> This won't apply against the current kernel and should be a separate
> patch, it's a generic thing rather than part of the CODEC driver.
> --
> To unsubscribe from this list: send the line "unsubscribe alsa-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/soc-cache.c
linux-2.6.38-patch/sound/soc/soc-cache.c
--- linux-2.6.38-vanilla/sound/soc/soc-cache.c	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/soc-cache.c	2011-03-24 09:23:00.984373772 +0100
@@ -99,6 +99,58 @@ static int snd_soc_4_12_spi_write(void *
 #define snd_soc_4_12_spi_write NULL
 #endif

+/* special functions for codecs with 7 bit register address and LSB read/write (like TLV320AIC3X) */
+static unsigned int snd_soc_7_8_read(struct snd_soc_codec *codec,
+				     unsigned int reg)
+{
+	int ret;
+	unsigned int val;
+
+	if (reg >= codec->driver->reg_cache_size ||
+		snd_soc_codec_volatile_register(codec, reg)) {
+			if (codec->cache_only)
+				return -1;
+
+			BUG_ON(!codec->hw_read);
+			return codec->hw_read(codec, ((reg << 1) | 1));
+	}
+
+	ret = snd_soc_cache_read(codec, reg, &val);
+	if (ret < 0)
+		return -1;
+	return val;
+}
+
+static int snd_soc_7_8_write(struct snd_soc_codec *codec, unsigned int reg,
+			     unsigned int value)
+{
+	u8 data[2];
+	int ret;
+
+	data[0] = (reg << 1);
+	data[1] = value;
+
+	if (!snd_soc_codec_volatile_register(codec, reg) &&
+		reg < codec->driver->reg_cache_size) {
+		ret = snd_soc_cache_write(codec, reg, value);
+		if (ret < 0)
+			return -1;
+	}
+
+	if (codec->cache_only) {
+		codec->cache_sync = 1;
+		return 0;
+	}
+
+	ret = codec->hw_write(codec->control_data, data, 2);
+	if (ret == 2)
+		return 0;
+	if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
 static unsigned int snd_soc_7_9_read(struct snd_soc_codec *codec,
 				     unsigned int reg)
 {
@@ -661,6 +713,11 @@ static struct {
 		.spi_write = snd_soc_4_12_spi_write,
 	},
 	{
+		.addr_bits = 7, .data_bits = 8,
+		.write = snd_soc_7_8_write, .read = snd_soc_7_8_read,
+		.spi_write = snd_soc_8_8_spi_write,
+	},
+	{
 		.addr_bits = 7, .data_bits = 9,
 		.write = snd_soc_7_9_write, .read = snd_soc_7_9_read,
 		.spi_write = snd_soc_7_9_spi_write,
