Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1CGCpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:45:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1CGCpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:45:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=asTanNNIez4Fh6XhxbwEJTqIxJpxWvBTl9xL4KOhFTxYnnAZRuR2XNWiqgq0QtNeC+
         Nv1mzXZtpLthgbotrEkbtYpCcEo6rg6OgHSkHi30EkNtYI4b4xC9ipnyrBZI0jv5NbY6
         d3JGI6OXIALR8bhTXj/clGhmpl3f0oGpi5xpo=
MIME-Version: 1.0
In-Reply-To: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 6 Mar 2011 21:44:49 -0500
Message-ID: <AANLkTinGyn8tujw-TrLibuDuj_Xqb4_YEPfLPFUy4WdO@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
To: cliff.cai@analog.com
Cc: broonie@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 20:11,  <cliff.cai@analog.com> wrote:
> +#define ADAU1701_FIRMWARE "SigmaDSP_fw.bin"

this probably needs to be more specific.  like "adau1701.bin".
otherwise it makes it a pain to work with diff codecs in the same
system.

> +static int adau1701_write_register(struct snd_soc_codec *codec,
> +       u16 reg_address, u8 length, u32 value)
> +{
> +       int ret;
> +       int count = length + 2; /*data plus 16bit register address*/
> +       u8 buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
> +
> +       if (length == 0)
> +               return -1;
> +       buf[0] = (reg_address >> 8) & 0xFF;

should be a blank line after that return

> +       buf[1] = reg_address & 0xFF;
> +       if (length == 1)
> +               buf[2] = value & 0xFF;
> +       else if (length == 2) {
> +               buf[2] = (value >> 8) & 0xFF;
> +               buf[3] = value & 0xFF;
> +       } else if (length == 3) {
> +               buf[2] = (value >> 16) & 0xFF;
> +               buf[3] = (value >> 8) & 0xFF;
> +               buf[4] = value & 0xFF;
> +       }

i think the buf[8] init forces gcc to generate bad code, and seems to
be useless.  shouldnt the code have an "else" brace to return -1 if
length is greater than 3, and then change the decl to "u8 buf[5];" ?

also, all these 0xFF masks are useless -- you're assigning it to a u8
which implies bit truncation

> +       ret = i2c_master_send(codec->control_data, buf, count);
> +
> +       return ret;
> +
> +}

the whole "int ret" seems kind of useless in this func.  just return
the i2c_master_send and drop the ret var completely.  and drop the
blank link after the return.

> +/*
> + * read ADAU1701 hw register
> + */
> +static u32 adau1701_read_register(struct snd_soc_codec *codec,
> +       u16 reg_address, u8 length)
> +{
> +       u8 addr[2];
> +       u8 buf[2];
> +       u32 value = 0;
> +       int ret;
> +
> +       if (reg_address < ADAU1701_FIRSTREG)
> +               reg_address = reg_address + ADAU1701_FIRSTREG;
> +
> +       if ((reg_address < ADAU1701_FIRSTREG) || (reg_address > ADAU1701_LASTREG))
> +               return -EIO;

this func has "u32" for ret, and you return the raw register value
below.  but here you try returning -EIO.  shouldnt it be "int" so the
caller can check for "< 0" ?

> +       addr[0] = (reg_address >> 8) & 0xFF;
> +       addr[1] = reg_address & 0xFF;
> +
> +       /* write the 2byte read address */
> +       ret = i2c_master_send(codec->control_data, addr, 2);
> +       if (ret)
> +               return ret;
> +
> +       if (length == 1) {
> +               if (i2c_master_recv(codec->control_data, buf, 1) != 1)
> +                       return -EIO;
> +               value = buf[0];
> +       } else if (length == 2) {
> +               if (i2c_master_recv(codec->control_data, buf, 2) != 2)
> +                       return -EIO;

seems like this can be combined into one simple code block where you
replace "1" and '2" with "length"

> +static int adau1701_setprogram(struct snd_soc_codec *codec)
> +{
> +       int ret = 0;
> +
> +       ret = process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE);
> +
> +       return ret;
> +}

seems like this should be one statement -- a simple return

> +static int adau1701_set_bias_level(struct snd_soc_codec *codec,
> +                                enum snd_soc_bias_level level)
> +{
> +       u16 reg;
> +       switch (level) {
> +       case SND_SOC_BIAS_ON:
> +               reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
> +               reg &= ~(AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
> +                        AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD);
> +               adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
> +               break;
> +       case SND_SOC_BIAS_PREPARE:
> +               break;
> +       case SND_SOC_BIAS_STANDBY:
> +               break;
> +       case SND_SOC_BIAS_OFF:
> +               /* everything off, dac mute, inactive */
> +               reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
> +               reg |= AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
> +                        AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD;
> +               adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);

error checking missing on the read_register() call

> +               break;
> +
> +       }

drop the blank line before the brace

> +struct snd_soc_dai_driver adau1701_dai = {
> +       .name = "ADAU1701",

i think the standard is to use all lower case

> +static int adau1701_suspend(struct snd_soc_codec *codec, pm_message_t state)
> +{
> +       adau1701_set_bias_level(codec, SND_SOC_BIAS_OFF);
> +       return 0;
> +}
> +
> +static int adau1701_resume(struct snd_soc_codec *codec)
> +{
> +       adau1701_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> +       return 0;
> +}
> ...
> +static int adau1701_remove(struct snd_soc_codec *codec)
> +{
> +       adau1701_set_bias_level(codec, SND_SOC_BIAS_OFF);
> +       return 0;
> +}

why not return set_bias_level ?

> +static int adau1701_reg_init(struct snd_soc_codec *codec)
> ...
> +               printk(KERN_ERR "Loading program data failed\n");

dev_err

> +struct snd_soc_codec_driver soc_codec_dev_adau1701 = {

static

> +static __devinit int adau1701_i2c_probe(struct i2c_client *i2c,
> +                             const struct i2c_device_id *id)
> +{
> +       struct adau1701_priv *adau1701;
> +       int ret = 0;
> +
> +       adau1701 = kzalloc(sizeof(struct adau1701_priv), GFP_KERNEL);

sizeof(*adau1701)

> +static int __init adau1701_modinit(void)
> +{
> +       int ret;
> +
> +       ret = i2c_add_driver(&adau1701_i2c_driver);
> +       if (ret != 0) {
> +               printk(KERN_ERR "Failed to register adau1701 I2C driver: %d\n",
> +                      ret);
> +       }

uesless braces, and should be pr_err

> +MODULE_DESCRIPTION("ASoC ADAU1701 SigmaDSP driver");
> +MODULE_AUTHOR("Cliff Cai");
> +MODULE_LICENSE("GPL");

MODULE_ALIAS() ?

> +++ b/sound/soc/codecs/adau1701.h
> ...
> +#define        AUXADCE_AAEN            (1 << 15)
> +#define OSCIPOW_OPD            (0x04)
> +#define        DACSET_DACEN            (1)

looks like you got "#define<tab>" junk in here
-mike
