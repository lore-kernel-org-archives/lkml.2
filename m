Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0IALOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:14:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38664 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752379Ab0IALOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:14:16 -0400
Date: Wed, 1 Sep 2010 12:14:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
Message-ID: <20100901111432.GE17548@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40D469C123B@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C123B@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:08:30PM -0700, Peter Hsiang wrote:
> This patch adds the MAX98088 CODEC driver.

The major issue with this is that the driver needs to be updated to
current ASoC versions - you should always be working against the trees
that are in linux-next for new drivers.  For ASoC you should be looking
at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git

> Signed-off-by: Peter Hsiang <peter.hsiang at maxim-ic.com>

Please write your e-mail address properly - it'll end up in the git logs
anyway.  It'd also be nice to credit your sources when you've taken code
from other drivers :)

> +#define EQ_CFG_MAX 32

> +/* Speaker excursion limiter filter response configurations */
> +#define EX_CFG_MAX 32

Multiple definitions of this.

> +       /* Set receiver_mode to:
> +        * 0 = amplifier output, or
> +        * 1 = LINE level output
> +        */
> +       unsigned int receiver_mode;

Better to use bools or bitfields.

> +       /* Bypass option for INA to MIC1 connection
> +        * 0 = normal setting
> +        * 1 = bypass enabled
> +        */
> +       unsigned int ina_to_mic1_bypass;
> +
> +       /* Bypass option for MIC1 to MIC2 connection

What are these - they sound like something I'd expect to be configurable
at runtime?

> @@ -28,6 +28,7 @@ config SND_SOC_ALL_CODECS
>         select SND_SOC_DA7210 if I2C
>         select SND_SOC_JZ4740 if SOC_JZ4740
>         select SND_SOC_MAX9877 if I2C
> +       select SND_SOC_MAX98088 if I2C

The sorting should be lexical.

> +/*
> + * Read the MAX98088 I2C register space
> + * Note: this driver source code is backward compatible to kernel
> + * version 2.6.32.
> + */
> +static unsigned int max98088_read(struct snd_soc_codec *codec,
> +                                 unsigned int reg)

Just use soc-cache.  Compatibility code for older kernels isn't really
acceptable for mainline due to the increased maintainance burden and it
will at best result in a driver that doesn't work as well as possible.

> +       client = (struct i2c_client *)codec->control_data;

No need to cast away from void.

> +/*
> + * For kernels compiled without unsigned long long int division
> + */
> +unsigned long long int ulldiv(unsigned long long int dividend,
> +                             unsigned long long int divisor)
> +{
> +       unsigned long long int quotient = 0;
> +       int shift = 1;
> +
> +       if (divisor == 0)
> +               return 0;
> +
> +       /* result is 1.0 if divisor and dividend are equal */
> +       if (divisor == dividend)
> +               return 1;
> +
> +       /* Normalize divisor */
> +       while (!(divisor & 0x8000000000000000ULL)) {
> +               divisor <<= 1;
> +               ++shift;
> +       }
> +
> +       /* Shift and subtract */
> +       while (shift--) {
> +               quotient <<= 1;
> +
> +               if (divisor <= dividend) {
> +                       dividend -= divisor;
> +                       ++quotient;
> +               }
> +               divisor >>= 1;
> +       }
> +
> +       /* Round up */
> +       if (dividend > divisor)
> +               ++quotient;
> +
> +       return quotient;
> +}

> +/*
> + * Load equalizer DSP coefficient configurations registers
> + */
> +void m98088_eq_band(struct snd_soc_codec *codec, unsigned int dai,
> +                   unsigned int band, u16 *coefs)
> +{
> +       unsigned int eq_reg;
> +       unsigned int i;
> +
> +       if (band > 4)
> +               return;
> +
> +       if (dai > 1)
> +               return;

These look like they should be BUG_ON().

> +/*
> + * Excursion limiter modes
> + */
> +static const char *max98088_ex_mode[] = {
> +       "Off",
> +       "100Hz",
> +       "400Hz",
> +       "600Hz",
> +       "800Hz",
> +       "1000Hz",
> +       "200-400Hz",
> +       "400-600Hz",
> +       "400-800Hz",
> +       "user-400Hz",
> +       "user-600Hz",
> +       "user-800Hz",
> +       "user-1000Hz"

These user options look very suspicous.

> +static int max98088_ex_mode_set(struct snd_kcontrol *kcontrol,
> +                               struct snd_ctl_elem_value *ucontrol)
> +{
> +       struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
> +       struct max98088_priv *max98088 = codec->private_data;
> +       unsigned int *mode = &max98088->ex_mode;
> +
> +       *mode = ucontrol->value.integer.value[0];
> +
> +       if (*mode <= ARRAY_SIZE(ex_mode_table))
> +               max98088_write(codec, M98088_REG_41_SPKDHP,
> +                       ex_mode_table[*mode]);

Report the error if there's an invalid input.

> +static const char *max98088_hp_spk_mute[] = {"disable", "enable"};
> +static const struct soc_enum max98088_hp_spk_mute_enum[] = {
> +       SOC_ENUM_SINGLE_EXT(2, max98088_hp_spk_mute),

Why are you doing this rather than just using a standard switch control?
Even if there's a reason to not use one of the standard register
controls this should be presented to the application layer as a switch
rather than as an enumeration.

The same issue applies to the other outputs.

> +static const char *max98088_dcblk[] =  {"Off", "On"};
> +static const struct soc_enum max98088_dcblk_enum[] = {
> +       SOC_ENUM_SINGLE(M98088_REG_20_DAI2_FILTERS, 0, 2, max98088_dcblk),
> +};

Again, present a switch to userspace.

> +       SOC_DOUBLE_R("Headphone volume", M98088_REG_39_LVL_HP_L,
> +               M98088_REG_3A_LVL_HP_R, 0, 31, 0),

Volume, not volume.

> +       SOC_SINGLE("MIC1 gain", M98088_REG_35_LVL_MIC1, 0, 31, 1),
> +       SOC_SINGLE("MIC2 gain", M98088_REG_36_LVL_MIC2, 0, 31, 1),

> +       SOC_SINGLE("MIC1 pre", M98088_REG_35_LVL_MIC1, 5, 3, 0),
> +       SOC_SINGLE("MIC2 pre", M98088_REG_36_LVL_MIC2, 5, 3, 0),
> +
> +       SOC_SINGLE("INA gain", M98088_REG_37_LVL_INA, 0, 7, 1),
> +       SOC_SINGLE("INB gain", M98088_REG_38_LVL_INB, 0, 7, 1),

These should all be named " Volume", as should all your other " gain" or
" pre" controls.

> +       SOC_SINGLE("EQ1 switch", M98088_REG_49_CFG_LEVEL, 0, 1, 0),
> +       SOC_SINGLE("EQ2 switch", M98088_REG_49_CFG_LEVEL, 1, 1, 0),

Capitalise switch.

> +/* Left speaker mixer switch */
> +static const struct snd_kcontrol_new max98088_left_speaker_mixer_controls[] = {
> +       SOC_DAPM_SINGLE("Left DAC1", M98088_REG_2B_MIX_SPK_LEFT, 7, 1, 0),

All of these should be " Switch".

> +static int max98088_hp_event(struct snd_soc_dapm_widget *w,
> +                            struct snd_kcontrol *kcontrol, int event)
> +{
> +       struct snd_soc_codec *codec = w->codec;
> +       u16 status;
> +
> +       BUG_ON(event != SND_SOC_DAPM_PRE_PMD);
> +
> +       /* powering down headphone gracefully */
> +       status = max98088_read(codec, M98088_REG_4D_PWR_EN_OUT);
> +       if ((status & M98088_HPEN) == M98088_HPEN) {
> +               max98088_hw_write(codec, M98088_REG_4D_PWR_EN_OUT,
> +                       (status & ~M98088_HPEN));
> +       }
> +       schedule_timeout_interruptible(msecs_to_jiffies(20));

This should be non-interruptible since there's no handling of any actual
interruptions.

> +/* DAPM AUDIO_MAP: */
> +static const struct snd_soc_dapm_route audio_map[] = {
> +       /* Left headphone output mixer */
> +       {"Left HP Mixer", "Left DAC1", "DACL1"},
> +       {"Left HP Mixer", "Left DAC2", "DACL2"},
> +       {"Left HP Mixer", "Right DAC1", "DACR1"},
> +       {"Left HP Mixer", "Right DAC2", "DACR2"},
> +       {"Left HP Mixer", "MIC1", "Mic Bias"},
> +       {"Left HP Mixer", "MIC2", "Mic Bias"},

This looks wrong - I'd expect this to be switching the microphone input
to the mixer, not the bias.  Mixing the bias in would just present a DC
level which isn't going to be great.  Similarly for all your other
microphone input switching.

> +               /* DAI clock master/slave wrt the codec */
> +               switch (fmt & SND_SOC_DAIFMT_CBS_CFS) {

You should be using the masks for your switch statements.  Using
specific values is at best harder to read and at worst will lead to
false positives.  This applies to all your comparisons in this function.

> +                       /* BCI: normal bclk (rise) */
> +                       /* WCI: invert frame */
> +                       snd_soc_update_bits(codec, M98088_REG_14_DAI1_FORMAT,
> +                               M98088_DAI_BCI, M98088_DAI_WCI);
> +                       break;
> +               case SND_SOC_DAIFMT_IB_NF:
> +                       /* BCI: invert bclk (fall) */
> +                       /* WCI: normal frame */
> +                       snd_soc_update_bits(codec, M98088_REG_14_DAI1_FORMAT,
> +                               M98088_DAI_WCI, M98088_DAI_BCI);

This code (and most of the other update_bits() usages round here) looks
wrong - I'd expect to see a constant bitmask being supplied as the mask
argument then the value changing to set different values.

> +               max98088_write(codec, M98088_REG_16_DAI1_IOCFG,
> +                       (1<<6) |  /* SEL : map DAI1 to S1 */
> +                       (0<<5) |  /* LTEN : ADC->DAC loop-through enable */
> +                       (0<<4) |  /* LBEN : loopback (0=disable, 1=enable) */
> +                       (0<<3) |  /* DMONO : DAC SDIN (0=stereo, 1=mono) */

These look like things that should be configured by the user, especially
LTEN.

> +                       (0<<2) |  /* HIZOFF : ADC SDOUT (0=HiZ, 1=Drive) */
> +                       (1<<1) |  /* SDOEN : serial data out ENABLE */
> +                       (1<<0));  /* SDIEN : serial data in ENABLE */

These look like they ought to be DAPM widgets for the AIF.

> +static int max98088_dai_set_sysclk(struct snd_soc_dai *dai,
> +                                  int clk_id, unsigned int freq, int dir)
> +{
> +       struct snd_soc_codec *codec = dai->codec;
> +       struct max98088_priv *max98088 = codec->private_data;
> +
> +       if (freq != max98088->sysclk) {

It would be clearer to just return in this case so you don't have so
much indentation.

> +               /* If codec is currently running, toggle reset */
> +               if (max98088_read(codec, M98088_REG_51_PWR_SYS)
> +                       & M98088_SHDNRUN) {
> +                       snd_soc_update_bits(codec, M98088_REG_51_PWR_SYS,
> +                               M98088_SHDNRUN, 0);
> +                       snd_soc_update_bits(codec, M98088_REG_51_PWR_SYS,
> +                               0, M98088_SHDNRUN);

Will this reset the whole chip?

> +static inline int rate_index(int rate)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(rate_table); i++) {
> +               if (rate_table[i].rate >= rate)
> +                       return i;
> +       }
> +       return 0;

This won't indicate if there's a failure to find a match.

> +       /* data 16/24 bit width */
> +       switch (params_format(params)) {
> +       case SNDRV_PCM_FORMAT_S16_LE:
> +               /* WS: 16bit */
> +               snd_soc_update_bits(codec, M98088_REG_14_DAI1_FORMAT,
> +                       M98088_DAI_WS, 0);
> +               break;
> +       case SNDRV_PCM_FORMAT_S24_LE:
> +               /* WS: 24bit */
> +               snd_soc_update_bits(codec, M98088_REG_14_DAI1_FORMAT,
> +                       0, M98088_DAI_WS);
> +               break;
> +       }

Again, your snd_soc_update_bits() usage seems confused.  You're also not
checking for invalid inputs.  There are other instances of this in the
driver, I'll not comment them all.

> +       snd_soc_update_bits(codec, M98088_REG_51_PWR_SYS, M98088_SHDNRUN, 0);
> +
> +       if (rate != cdata->rate) {
> +               /* set DAI1 SR1 value for the DSP; FREQ1:0=anyclock */
> +               reg11val = (rate_table[rate_index(rate)].sr1 << 4) | 0;
> +               max98088_write(codec, M98088_REG_11_DAI1_CLKMODE, reg11val);
> +               cdata->rate = rate;

Just directly use snd_soc_update_bits() - it will suppress null changes.

> +       /* Configure NI when operating as master */
> +       if (max98088_read(codec, M98088_REG_14_DAI1_FORMAT)
> +               & M98088_DAI_MAS) {
> +               BUG_ON(max98088->sysclk == 0);

BUG_ON() is unfriendly here - this is a machine driver configuration
error and normally BUG_ON() would be an internal error in the driver.
Better error reporting please.

> +static int max98088_set_bias_level(struct snd_soc_codec *codec,
> +                                 enum snd_soc_bias_level level)
> +{
> +       switch (level) {
> +       case SND_SOC_BIAS_ON:
> +               max98088_write(codec, M98088_REG_51_PWR_SYS, M98088_SHDNRUN);
> +               break;
> +
> +       case SND_SOC_BIAS_PREPARE:
> +               max98088_write(codec, M98088_REG_51_PWR_SYS, M98088_SHDNRUN);
> +               break;

Drop the _ON cacse if it's the same.  Also, how will this interact with
the management of SHDNRUN in hw_params()?

> +       case SND_SOC_BIAS_STANDBY:
> +               max98088_sync_cache(codec);
> +               max98088_write(codec, M98088_REG_51_PWR_SYS,
> +                       M98088_SHDNRUN|M98088_PWRSV);
> +               break;

Do you really want to sync the cache every time we drop into standby?

> +       /* Configure digital mic / external mic */
> +       /* Digital mic needs REG_15 OSR1=1 */
> +       regval = ((0<<6) | /* digital mic clock freq = PCLK/8 */
> +                 (0<<5) | /* DIGMICL enable */
> +                 (0<<4) | /* DIGMICR enable */
> +                 (0<<0)); /* external mic enable */

These look like they ought to be managed via DAPM?
