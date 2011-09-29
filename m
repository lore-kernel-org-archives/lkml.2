Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1I2XNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:13:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47391 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1I2XNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:13:51 -0400
Message-ID: <4E84FBA6.40600@gmail.com>
Date: Fri, 30 Sep 2011 09:13:42 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Subject: Re: [PATCH 1/2] ASoC: Add BUG() assertion if max98088_get_channel
 returns -EINVAL
References: <1317218471.8008.3.camel@phoenix> <4E83AA77.9040700@gmail.com> <20110929103413.GK3697@opensource.wolfsonmicro.com>
In-Reply-To: <20110929103413.GK3697@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/11 20:34, Mark Brown wrote:
> On Thu, Sep 29, 2011 at 09:15:03AM +1000, Ryan Mallon wrote:
>> On 29/09/11 00:01, Axel Lin wrote:
>>> The callers use the return value of max98088_get_channel as array index to
>>> access max98088->dai[] array.
>>> Add BUG() assertion for out of bound access of max98088->dai[] array.
>> BUG() is pretty heavy handed for a driver. Why not fix the problem
>> properly in the callers?
> There's nothing constructive that any of the callers can do with an
> error code - it's a clear bug in something (probably the driver) if we
> get called for a bad control.  Simply returning an error code isn't
> terribly helpful, it's very obscure what's gone wrong and why.  We at
> least need a log message.

How about something like this (untested) patch?
---
Make the max98088 codec controls[] array a static global and iterate
over it in max98088_get_channel rather than duplicating the hardcoded
strings. Add a warning if the channel name is not found and check for
the error value in the callers.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index ac65a2d..bc2b922 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1697,13 +1697,28 @@ static struct snd_soc_dai_driver max98088_dai[] = {
 }
 };
 
-static int max98088_get_channel(const char *name)
+static struct snd_kcontrol_new controls[] = {
+	SOC_ENUM_EXT("EQ1 Mode",
+		     max98088->eq_enum,
+		     max98088_get_eq_enum,
+		     max98088_put_eq_enum),
+	SOC_ENUM_EXT("EQ2 Mode",
+		     max98088->eq_enum,
+		     max98088_get_eq_enum,
+		     max98088_put_eq_enum),
+};
+
+static int max98088_get_channel(struct snd_soc_codec *codec, const char *name)
 {
-       if (strcmp(name, "EQ1 Mode") == 0)
-               return 0;
-       if (strcmp(name, "EQ2 Mode") == 0)
-               return 1;
-       return -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(controls); i++)
+		if (strcmp(name, controls[i].name) == 0)
+			return i;
+
+	/* Shouldn't happen */
+	dev_err(codec->dev, "Bad channel name '%s'\n", name);
+	return -EINVAL;
 }
 
 static void max98088_setup_eq1(struct snd_soc_codec *codec)
@@ -1807,10 +1822,13 @@ static int max98088_put_eq_enum(struct snd_kcontrol *kcontrol,
        struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
        struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
        struct max98088_pdata *pdata = max98088->pdata;
-       int channel = max98088_get_channel(kcontrol->id.name);
+       int channel = max98088_get_channel(codec, kcontrol->id.name);
        struct max98088_cdata *cdata;
        int sel = ucontrol->value.integer.value[0];
 
+       if (channel < 0)
+	       return channel;
+
        cdata = &max98088->dai[channel];
 
        if (sel >= pdata->eq_cfgcnt)
@@ -1835,9 +1853,12 @@ static int max98088_get_eq_enum(struct snd_kcontrol *kcontrol,
 {
        struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
        struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
-       int channel = max98088_get_channel(kcontrol->id.name);
+       int channel = max98088_get_channel(codec, kcontrol->id.name);
        struct max98088_cdata *cdata;
 
+       if (channel < 0)
+	       return channel;
+
        cdata = &max98088->dai[channel];
        ucontrol->value.enumerated.item[0] = cdata->eq_sel;
        return 0;
@@ -1853,17 +1874,6 @@ static void max98088_handle_eq_pdata(struct snd_soc_codec *codec)
        const char **t;
        int ret;
 
-       struct snd_kcontrol_new controls[] = {
-               SOC_ENUM_EXT("EQ1 Mode",
-                       max98088->eq_enum,
-                       max98088_get_eq_enum,
-                       max98088_put_eq_enum),
-               SOC_ENUM_EXT("EQ2 Mode",
-                       max98088->eq_enum,
-                       max98088_get_eq_enum,
-                       max98088_put_eq_enum),
-       };
-
        cfg = pdata->eq_cfg;
        cfgcnt = pdata->eq_cfgcnt;
 

