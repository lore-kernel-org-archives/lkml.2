Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0I2Dht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:37:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47187 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751462Ab0I2Dhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:37:47 -0400
Date: Tue, 28 Sep 2010 20:37:58 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100929033757.GB29975@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 07:34:34PM -0700, Peter Hsiang wrote:

> +#define EQ_CFG_MAX 32

There doesn't seem to be any need to hard code a limit here?

> +static int max98088_hw_write(struct snd_soc_codec *codec, unsigned int reg,
> +                            unsigned int value)
> +{
> +       u8 data[2];
> +
> +       data[0] = reg;
> +       data[1] = value;
> +       if (codec->hw_write(codec->control_data, data, 2) == 2)
> +               return 0;
> +       else
> +               return -EIO;
> +}

As previously discussed you should use the soc-cache code here.

> +/*
> + * For kernels compiled without unsigned long long int division
> + */
> +unsigned long long int ulldiv(unsigned long long int dividend,
> +                             unsigned long long int divisor)

This is causing me some concern.  Even if it is required this does not
look like something that should be part of a specific driver - what
happens if some other driver needs the same thing?

> +/*
> + * The INx1 and INx2 PGAs share a power control signal.
> + * This function OR's the two power events to keep an unpowered INx
> + * from turning off it's counterpart.
> + * The control names are used to identify the PGA.
> + */

This...

> +       if (strncmp(w->name, "INA1", 4) == 0) {
> +               pga = INA1_PGA_BIT;
> +               mask = INA1_PGA_BIT | INA2_PGA_BIT;

...doesn't seem to correspond to this, at least with the normal way mask
is used.  Apart from anything else it looks like you have individual
mask bits for each of the INx1 and INx2 PGAs (since you can define mask
bits for each of them).  It would be much clearer if the code made it
obvious that these aren't register bits but rather that you're storing
the data in a register-like bitfield in a variable.  I can't help but
think that a reference count would be much clearer.

> +       if (event == SND_SOC_DAPM_POST_PMU) {
> +               /* ON */
> +               *state |= pga;
> +
> +               /* Turn on, avoiding unnecessary writes */
> +               val = snd_soc_read(codec, w->reg);
> +               if (!(val & (1 << w->shift))) {
> +                       val |= (1 << w->shift);
> +                       snd_soc_write(codec, w->reg, val);
> +               }

snd_soc_update_bits() will suppress unwanted register writes.

> +       }
> +
> +       return;
> +}

No need for return statements at the end of void functions.

> +
> +static const unsigned int ex_mode_table[] = {
> +       0x00,           /* disabled */
> +       (0<<4)|3,       /* 100Hz */
> +       (1<<4)|0,       /* 400Hz */
> +       (2<<4)|0,       /* 600Hz */
> +       (3<<4)|0,       /* 800Hz */
> +       (4<<4)|0,       /* 1000Hz */
> +       (1<<4)|1,       /* 200-400Hz */
> +       (2<<4)|2,       /* 400-600Hz */
> +       (3<<4)|2,       /* 400-800Hz */
> +};

You should add value muxes like we have for DAPM.

> +static const char *max98088_micpre[] = {
> +       "0dB",
> +       "20dB",
> +       "30dB",
> +};

> +static const struct soc_enum max98088_micpre_enum[] = {
> +       SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(max98088_micpre), max98088_micpre),
> +};

This should be a TLV control, not an enum.

> +static const char *max98088_extmic[] = {
> +       "Off",
> +       "MIC1",
> +       "MIC2",
> +};

> +static const struct soc_enum max98088_extmic_enum[] = {
> +       SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(max98088_extmic), max98088_extmic),
> +};

This looks like it should be in DAPM.

> +static int max98088_mic1pre_set(struct snd_kcontrol *kcontrol,
> +                               struct snd_ctl_elem_value *ucontrol)
> +{
> +       struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
> +       struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
> +       unsigned int *mode = &max98088->mic1pre;
> +       int sel = ucontrol->value.integer.value[0];
> +
> +       if (sel >= ARRAY_SIZE(max98088_micpre))
> +               return -EINVAL;
> +
> +       *mode = ucontrol->value.integer.value[0];
> +       return 0;
> +}

I'd expect that some action would be taken when the value is set here.
All this does is set a variable, changing the control will have no
effect.

> +static int max98088_hp_event(struct snd_soc_dapm_widget *w,
> +                            struct snd_kcontrol *kcontrol, int event)
> +{
> +       struct snd_soc_codec *codec = w->codec;
> +       u16 status;
> +
> +       BUG_ON(event != SND_SOC_DAPM_PRE_PMD);
> +
> +       /* powering down headphone gracefully */
> +       status = snd_soc_read(codec, M98088_REG_4D_PWR_EN_OUT);
> +       if ((status & M98088_HPEN) == M98088_HPEN) {
> +               max98088_hw_write(codec, M98088_REG_4D_PWR_EN_OUT,
> +                       (status & ~M98088_HPEN));
> +       }
> +       schedule_timeout(msecs_to_jiffies(20));

This looks rather like it should just be a post event implementing a
timeout?

> +       if (rate != cdata->rate) {
> +               /* set DAI1 SR1 value for the DSP; FREQ1:0=anyclock */
> +               if (rate_value(rate, &regval))
> +                       return -EINVAL;
> +
> +               snd_soc_write(codec, M98088_REG_11_DAI1_CLKMODE, regval);
> +               cdata->rate = rate;
> +       }

Just use snd_soc_update_bits() to suppress unneeded writes.  Many of the
operaations have this issue.

> +               & M98088_DAI_MAS) {
> +               if (max98088->sysclk == 0)
> +                       return -EINVAL;

You should print an error here so users can tell what went wrong.

> +               switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
> +               case SND_SOC_DAIFMT_I2S:
> +                       reg14val |= M98088_DAI_DLY;
> +                       break;
> +               case SND_SOC_DAIFMT_LEFT_J:
> +                       reg14msk |= M98088_DAI_DLY;
> +                       break;

This looks fishy - in one case you set the value, in another format you
set the mask, both to the same bitfield.   I'd expect the mask of bits
being updated to stay constant, but you seem to be treating the mask as
meaning bits to be cleared.  I rather suspect you'll run into problems
if you test this.

> +       case SND_SOC_BIAS_STANDBY:
> +               max98088_sync_cache(codec);
> +               snd_soc_update_bits(codec, M98088_REG_4C_PWR_EN_IN,
> +                               M98088_MBEN, M98088_MBEN);
> +               break;

Do you really want to sync the cache *every* time you go into standby?

> +
> +       case SND_SOC_BIAS_OFF:
> +               snd_soc_update_bits(codec, M98088_REG_4C_PWR_EN_IN,
> +                               M98088_MBEN, 0);
> +#ifdef CONFIG_REGULATOR
> +               codec->cache_sync = 1;
> +#endif

Why the ifdef?

> +
> +       /* Build an array of texts for the enum API. The number
> +        * of texts is likely fewer than the number of configurations
> +        * due to multiple sample rates for the same text name. */
> +       cdata->eq_textcnt = 0;
> +       for (i = 0; i < pdata->eq1_cfgcnt; i++) {

It might be nice to give credit to the drivers you've based your work on :)

> +       max98088_set_bias_level(codec, SND_SOC_BIAS_OFF);
> +
> +       /* Sync reg_cache with the hardware */
> +       for (i = 0; i < M98088_REG_CNT; i++) {
> +               if (i == M98088_REG_51_PWR_SYS)
> +                       continue;
> +
> +               if (!max98088_access[i].writable)
> +                       continue;
> +
> +               max98088_hw_write(codec, i, cache[i]);
> +       }

This appears to duplicate the register sync in your bias management.

> +static struct i2c_driver max98088_i2c_driver = {
> +       .driver = {
> +               .name = "max98088-codec",

Drop the -codec from the name.

> +module_init(max98088_init);

Normally this would be next to the function it references.

> +struct max98088_setup_data {
> +       unsigned short i2c_address;
> +};

This should be removed.
