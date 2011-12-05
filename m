Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1LEJdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:33:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34046 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1LEJdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:33:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111202153401.GX8245@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
Date: Mon, 5 Dec 2011 18:33:03 +0900
Message-ID: <CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
Subject: Re: [PATCH v2] soc/lapis: add machine driver
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Dec 02, 2011 at 06:45:15PM +0900, Tomoya MORINAGA wrote:
>
>> +#define CODEC_DEV_ADDR 0x1A
>> +static struct i2c_board_info ioh_hwmon_info[] = {
>> +     {I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR + 1)},
>> +     {I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR + 2)},
>> +     {I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR + 3)},
>> +     {I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR + 4)},
>> +     {I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR + 5)},
>> +     {I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
>
> This looks completely wrong.  I'd not expect to see any I2C_BOARD_INFO
> usage at all in a machine driver (that should be done by whatever
> enumerates the system as a whole)
Do you mean machine driver must not use I2C_BOARD_INFO ? Is this true ?
Grepping I2C_BOARD_INFO at sound/soc,  the following drivers use
I2C_BOARD_INFO.
pxa/raumfeld.c: I2C_BOARD_INFO("max9485", 0x63),
pxa/magician.c:         I2C_BOARD_INFO("uda1380", 0x18),
s6000/s6105-ipcam.c:    { I2C_BOARD_INFO("tlv320aic33", 0x18), }

> and I'm not clear what the intended
> effect of the above is - the names look like the names of I2C
> controllers...
You are right.
"ioh_i2c-0" must be "ml26124".


>
>> +static int ml7213_startup(struct snd_pcm_substream *substream)
>> +{
>> +     struct snd_soc_pcm_runtime *rtd = substream->private_data;
>> +     struct snd_soc_codec *codec = rtd->codec;
>> +     struct i2c_client *i2c;
>> +     struct i2c_adapter *adapter;
>> +
>> +     mutex_lock(&codec->mutex);
>> +
>> +     adapter = i2c_get_adapter(1);
>> +     if (!adapter)
>> +             return -ENODEV;
>> +
>> +     i2c = i2c_new_device(adapter, &ioh_hwmon_info[substream->number]);
>> +     if (!i2c) {
>> +             mutex_unlock(&codec->mutex);
>> +             return -1;
>> +     }
>> +     i2c_put_adapter(adapter);
>> +     mutex_unlock(&codec->mutex);
>
> No, this is definitely wrong - we certainly shouldn't be registering new
> devices whenever someone starts an audio stream.  I'm struggling to
> understand what the intended effect is though.
Do you mean this registering must be at xx_init processing ?
OK, I'll move this processing into init().

>> +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
>> +                             SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>> +     if (ret < 0)
>> +             return ret;
>
> Use the dai_fmt field in the dai_link to set this.
Sorry, I can't understand your saying.
Let me know in more detail.

>
>> +MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
>> +MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
>> +MODULE_LICENSE("GPL");
>
> Should have MODULE_ALIAS too.
Do you mean machine driver should have MODULE_ALIAS ?
Grepping  MODULE_ALIAS at sound/soc, it seems MODULE_ALIAS is used in
platform driver only like below.
pxa/pxa2xx-i2s.c:MODULE_ALIAS("platform:pxa2xx-i2s");

Does machine driver need like "MODULE_ALIAS("machine:ml7213CRB")" ?

Thanks in advance

tomoya
