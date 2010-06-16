Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab0FPWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:09:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60079 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753517Ab0FPWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:09:54 -0400
Date: Wed, 16 Jun 2010 23:10:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jesse.marroquin@maxim-ic.com
Cc: lrg@slimlogic.co.uk, perex@perex.cz, tiwai@suse.de,
       peter.ujfalusi@nokia.com, barry.song@analog.com,
       jy0922.shim@samsung.com, morimoto.kuninori@renesas.com,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Peter Hsiang <peter.hsiang@maxim-ic.com>
Subject: Re: [PATCH] ASoC: Add max9888 CODEC driver
Message-ID: <20100616221003.GA13765@opensource.wolfsonmicro.com>
References: <1276713657-27858-1-git-send-email-jesse.marroquin@maxim-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276713657-27858-1-git-send-email-jesse.marroquin@maxim-ic.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 01:40:57PM -0500, jesse.marroquin@maxim-ic.com wrote:
> From: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
> 
> This patch adds max9888 CODEC driver.

So, the major comment I have here is that this driver feels very much
like it's fighting with the standard APIs for things rather than working
with them more than it should - there's an awful lot of open coded stuff
that I can't see a real need for here (and if there is a need it should
be factored out of the driver), and some things that are just straight
reimplementations of standard kernel functionality.

More detailed comments as I go through:

>  	select SND_SOC_WM9712 if SND_SOC_AC97_BUS
>  	select SND_SOC_WM9713 if SND_SOC_AC97_BUS
> +	select SND_SOC_MAX9888 if I2C
>          help

Keep the entries in this file and the Makefile sorted.

> +#define AUDIO_NAME		"MAX9888"
> +#define MAX9888_DRIVER_VERSION	"1.0"

In general version numbers in the kernel code are bad karma - they tend
to just bitrot with the version number of the kernel being the only
signifgcant bit.

> +#ifdef MAX9888_DEBUG
> +#define dprintk(x...) printk(KERN_WARNING x)
> +#else
> +#define dprintk(x...)
> +#endif
> +
> +#define err(format, arg...) \
> +	printk(KERN_ERR AUDIO_NAME ": " format "\n" , ## arg)
> +
> +#define info(format, arg...) \
> +	printk(KERN_INFO AUDIO_NAME ": " format "\n" , ## arg)
> +
> +#define warn(format, arg...) \
> +	printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)

This stuff should all be using the standard dev_ macros (or pr_ ones
where no device is available).  Those give more informative output too.

> +/*
> + * Equalizer DSP filter coefficients generated from the evkit software tool
> + */

So, what happens if a user goes and uses this tool to generate their own
register settings?  The way the software is structured it's going to be
fairly involved for them to add additional configurations.  This all
looks like it ought to be implemented in a much more generic fashion
with a data table being parsed by the driver to give the coefficient
settings - at the minute pretty much everywhere the coefficient settings
are handled the set of possible settings is manually coded.

This would then mean that platform data could be supplied adding
additional settings to or replacing the default ones provided by the
driver.

> +/*
> + * Dynamic high pass excursion limiter filter coefficients.
> + * The coefficients define the user programmable frequency response for the
> + * excursion limiter.
> + * Use the PC evkit software to generate the coefficients and put it here.
> + */
> +static unsigned int param_ex_resp_a[] = { 0, 0, 0, 0, 0 };
> +static unsigned int param_ex_resp_b[] = { 0, 0, 0, 0, 0 };
> +static unsigned int param_ex_resp_c[] = { 0, 0, 0, 0, 0 };

This needs to be platform data, users should not have to modify the
driver code in order to use the device since obviously that's not
sustainable when the driver is shared by multiple boards.

> +/*
> + * Read the MAX9888 register space
> + */
> +static unsigned int max9888_read(struct snd_soc_codec *codec, unsigned int reg)
> +{

This looks like you can just use snd_soc_set_cache_io() and use the
standard register I/O functions.

> +/*
> + * The INx1 and INx2 PGA's share a power control signal.

Extra ' here.

> + * This function OR's the two power events to keep an unpowered INx
> + * from turning off it's counterpart.
> + * The control names are used to identify the PGA.

Some more comments about how you've actually implemented this might be a
little clearer.  One thing you might wish to consider which would
simplify this workaround is to have the individual PGAs have no power
management and use a SND_SOC_DAPM_SUPPLY for the actual register
control.  This will mean that you don't need to open code anything, DAPM
will do the power up for you.  It does mean the sequencing will be wrong
but since these are input PGAs you'll probably not experience any
negative side effects.

Actually, looking further down the driver where this is used I'm
confused about what you're doing here since all the users also have
their own individual power bits.

> + */
> +int max9888_pga_event(struct snd_soc_dapm_widget *w, struct snd_kcontrol *k,
> +			 int event)
> +{
> +	struct snd_soc_codec *codec = w->codec;
> +	unsigned int val;
> +	unsigned int pga;
> +	unsigned int mask;
> +	static int power_state;

This should be in the CODEC private data rather than a static - if
someone wants to put two of the chips down on one board no need to make
problems for them!

> +	if (w->reg != M9888_REG_4A_PWR_EN_IN)
> +		return -EINVAL;

I'd upgrade this to a BUG_ON(), if the driver is calling this with the
wrong register it's buggy.

> +		/* Turn on, avoiding unnecessary writes */
> +		val = max9888_read(codec, w->reg);
> +
> +		if (!(val & (1 << w->shift))) {
> +			val |= (1 << w->shift);
> +			max9888_write(codec, w->reg, val | MBEN);

You're looking for snd_soc_update_bits() here.

> +/*
> + * Define a few static eq settings
> + */
> +static const char *max9888_eq[] = {
> +	"voice", "music", "flat", "treble reduce", "loudness" };

The names should all be capitalised to work well in UIs.

> +static int max9888_eq1_value = MAX9888_EQ_FLAT;
> +static int max9888_eq2_value = MAX9888_EQ_FLAT;

Again, these should be CODEC private data rather than static.

> +static const char *max9888_ex_mode[] = {
> +	"disable",
> +	"100Hz",
> +	"400Hz",
> +	"600Hz",
> +	"800Hz",
> +	"1000Hz",
> +	"200-400Hz",
> +	"400-600Hz",
> +	"400-800Hz",
> +	"user-400Hz",
> +	"user-600Hz",
> +	"user-800Hz",
> +	"user-1000Hz"

If the user has specified modes I'd rather expect they'd just override
the standard settings.   Conversely, if the user hasn't specified modes
I'd not expect the driver to offer to use them.

> +/*
> + * Functions and control structures for loading
> + * static coefficients into the bi-quad filter.
> + *
> + * As it is the user has a choice of three filters - a, b, or c.
> + */
> +static const char *max9888_ex_resp[] = { "a", "b", "c" };

If there's no more meaningful name for the options it'd be nice to at
least include a comment explaining why we're just calling them A, B and
C.

> +static int max9888_ex1_resp_value = MAX9888_BIQUAD_A;
> +static int max9888_ex2_resp_value = MAX9888_BIQUAD_A;

Same comment as before about use of private data.

> +
> +/*
> + * Control mic1 analog amplifier circuit on/off, and gain
> + * Typical setting: register value of 0x7F for 30dB mic gain
> + */
> +void m9888_mic1_gain_control(struct snd_soc_codec *codec, unsigned int gain,
> +			     unsigned int power_on)

I really can't tell why this has been open coded - you probably just
need an appropraite TLV table.  If it needs to be open coded please
document why.

> +	/* power off the amplifier */
> +	if (power_on == 0) {

Is the power really controlled by the gain?  If so, why isn't this
hooked in to DAPM?

> +/*
> + * Set headphone output volume and mute setting
> + */
> +void headphone_set_volume(struct snd_soc_codec *codec, u8 vol, u8 mute)

Similar comments about open coding for this and all the other
set_volume() implementations - they all look even more standard than the
microphone PGAs so you should be able to code them in a much more
standard fashion.

> +/*
> + * configure speaker ALC
> + */
> +void m9888_speaker_ALC_control(struct snd_soc_codec *codec)
> +{
> +	/* compressor enable */
> +	max9888_write(codec, M9888_REG_41_SPKALC_COMP, (0 << 7) |
> +		      (7 << 4) | (0 << 3) | (0 << 0));

This and several of the other functions look like they can only ever set
one value - what's the purpose of these functions?

> +static const char *max9888_hp_spk_mute[] = { "disable", "enable" };
> +
> +static const struct soc_enum max9888_hp_spk_mute_enum[] = {
> +	SOC_ENUM_SINGLE_EXT(2, max9888_hp_spk_mute),
> +};

This is not how ALSA implements mute controls - you should have a
control with a name "Speaker Switch" (something Switch, anyway) almost
certainly using one of the standard register access macros.  See other
CODEC drivers for examples.

The same thing applies to all your other mute controls, all this mute
handling can probably be replaced with a single line of code for each of
the mutes.  This will also have the advantage of allowing individual
control of the channels.

> +static const struct soc_enum max9888_enum[] = {
> +	SOC_ENUM_SINGLE(M9888_REG_3A_LVL_RECEIVER, 7, 2, max9888_rx_mute),
> +	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 7, 2, max9888_fltr_mode),
> +	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 3, 2, max9888_highrate),
> +	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 0, 6, max9888_dai1_fltr),
> +	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 4, 6, max9888_dai1_fltr),
> +	SOC_ENUM_SINGLE(M9888_REG_20_DAI2_FILTERS, 3, 2, max9888_highrate),
> +	SOC_ENUM_SINGLE(M9888_REG_20_DAI2_FILTERS, 0, 2, max9888_dc_block),
> +	SOC_ENUM_SINGLE(M9888_REG_40_SPKDHP_THRESHOLD, 0, 8,
> +			max9888_exlimit_threshold)
> +};

Define individual static variables for each of these, indexing into a
table is very error prone and brings no benefit.

> +	/* analog output levels */
> +	SOC_DOUBLE_R("hp_vol", M9888_REG_38_LVL_HEADPHONE_L,
> +		     M9888_REG_39_LVL_HEADPHONE_R, 0, 31, 0),

This should be "Headphone Volume".  Pretty much all your controls have
naming problems - you should try to follow the guidlines in the kernel
in Documentation/sound/alsa/ControlNames.txt.  This will allow
applications to parse them and render them appropriately.  Since there's
so many errors here I'll not point out further ones.

> +	SND_SOC_DAPM_PGA_E("INA2 Input", M9888_REG_4A_PWR_EN_IN,
> +			       7, 0, NULL, 0, max9888_pga_event,
> +			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
> +
> +	SND_SOC_DAPM_PGA_E("INB1 Input", M9888_REG_4A_PWR_EN_IN,
> +			       6, 0, NULL, 0, max9888_pga_event,
> +			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),

Looking at this in conjunction with the event above things seem really
odd - you've got this event which implements shared power bits for
something, but all of these controls also have individually managed
power bits that are handled in the normal fashion.

> +/*
> + * Set bias level
> + */
> +static int max9888_set_bias_level(struct snd_soc_codec *codec,
> +				  enum snd_soc_bias_level level)
> +{
> +	switch (level) {
> +	case SND_SOC_BIAS_ON:
> +	case SND_SOC_BIAS_PREPARE:
> +	case SND_SOC_BIAS_STANDBY:
> +		max9888_write(codec, M9888_REG_4C_PWR_SYS, SHDN|JDWK);

You probably want to use snd_soc_update_bits() here (or just make _ON
and _PREPARE noops).

> +		break;
> +	case SND_SOC_BIAS_OFF:
> +		max9888_write(codec, M9888_REG_4C_PWR_SYS, JDWK);

It's a bit odd that you're enabling something in _OFF, especially
something that's enabled when the device is active - what does JDWK do?

> +int max9888_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +
> +	if (mute)
> +		max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
> +	else
> +		max9888_set_bias_level(codec, SND_SOC_BIAS_ON);
> +	return 0;
> +}

This is wrong - the bias management function should be managing the
global bias levels for the CODEC and the digital mute function should be
muting the digital audio interface.  One or both of these functions is
doing the wrong thing.

Note in particular that bypass paths need to work while the DAI is
muted.

> +		case SND_SOC_DAIFMT_CBS_CFM:
> +			/* codec clk slave & frm master */
> +		case SND_SOC_DAIFMT_CBM_CFS:
> +			/* codec clk master & frame slave */
> +			info("Clock mode unsupported");
> +			return -1;

You should return a real error code here, not a random negative number,
and the error message should be an error not an info statement.

> +		/* I2S or TDM */
> +		if ((fmt & SND_SOC_DAIFMT_I2S) == SND_SOC_DAIFMT_I2S)
> +			max9888->reg_14_val &= ~(1 << 2);
> +		else
> +			max9888->reg_14_val |= (1 << 2);

I don't think that comparison does what you wanted - look at what the
value of SND_SOC_DAIFMT_I2S is for one thing.

> +		max9888_write(codec, M9888_REG_14_DAI1_FORMAT,
> +			      max9888->reg_14_val);
> +
> +		max9888_write(codec, M9888_REG_15_DAI1_CLOCK,
> +			      (0 << 6) | (0 << 0));
> +
> +		max9888_write(codec, M9888_REG_16_DAI1_IOCFG,
> +			      (1 << 6) |
> +			      (0 << 5) |
> +			      (0 << 4) |
> +			      (0 << 3) | (0 << 2) | (1 << 1) | (1 << 0));
> +
> +		max9888_write(codec, M9888_REG_17_DAI1_TDM,
> +			      (0 << 6) | (1 << 4) | (0 << 0));

These statements unconditionally write some fixed magic numbers to some
registers.  That's a bit odd - if nothing else I'd expect that any
static configuration would be done once on system startup.

> + * Setup DAI2 format
> + */
> +static int max9888_dai2_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)

Similar comments apply to the above; it looks awfully like these can be
generalised.  I also note that while you have two DAIs here there's no
mention of them in your DAPM configuration - you have everything wired
directly to the DAC and ADC.  I'd not expect this to work terribly well
if someone tries to use both DAIs (see below for some more on this).

> +		} else {
> +			info("Invalid master clock frequency %u", freq);
> +			return 1;

dev_err() and return a proper error code.

> +		/* these registers writes take effect with SHDN cycle */
> +		if (max9888_read(codec, M9888_REG_4C_PWR_SYS) & 0x80) {
> +			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x00);
> +			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x80);

...and they do...?

> +/* DAI Voice mode 2 */
> +	{.name = "max9888 DAI1",
> +	 .id = 2,
> +	 .playback = {
> +		      .stream_name = "Voice Playback",
> +		      .channels_min = 1,
> +		      .channels_max = 1,
> +		      .rates = MAX9888_RATES,
> +		      .formats = MAX9888_FORMATS,},

So, Voice Playback isn't actually wired up to anything.  This means that
when you try to start playback from a voice stream nothing will actually
happen to power up any of the output paths, which probably isn't what's
wanted.

> +	 .capture = {
> +		     .stream_name = "Capture",
> +		     .channels_min = 1,
> +		     .channels_max = 1,
> +		     .rates = MAX9888_RATES,
> +		     .formats = MAX9888_FORMATS,},

This, on the other hand, uses the same name as the primary DAI so I'd
expect some confusion in DAPM if both are simultaneously active.

> +	/* Jack detection function only works well on Revision C */
> +	if (max9888->rev_version == MAX9888_REVC) {
> +		max9888_write(codec, M9888_REG_0F_IRQ_ENABLE, IJDET);
> +		max9888_write(codec, M9888_REG_49_CFG_JACKDET,
> +				JDETEN | JDEB_200ms);
> +		max9888_write(codec, M9888_REG_4C_PWR_SYS, JDWK);
> +	}

I see no support for jack detection in the driver...

> +	max9888_write(codec, M9888_REG_22_MIX_ADC_LEFT, MIX_MIC1 | MIX_INA1);
> +	max9888_write(codec, M9888_REG_23_MIX_ADC_RIGHT, MIX_MIC2 | MIX_INA1);
> +	max9888_write(codec, M9888_REG_21_MIX_DAC,
> +		      MIX_DAI1L_TO_DACL | MIX_DAI2L_TO_DACL | MIX_DAI1R_TO_DACR
> +		      | MIX_DAI2R_TO_DACR);
> +	max9888_write(codec, M9888_REG_29_MIX_SPEAKER,
> +		      MIX_LDAC_TO_SPL | MIX_RDAC_TO_SPR);
> +	max9888_write(codec, M9888_REG_27_MIX_HEADPHONE,
> +		      MIX_LDAC_TO_HPL | MIX_RDAC_TO_HPR);
> +
> +	headphone_set_volume(codec, 0x1f, 0);
> +	speaker_set_volume(codec, 0x1f, 0);
> +	m9888_mic1_gain_control(codec, 20, 1);
> +	m9888_mic2_gain_control(codec, 20, 1);

These should all use the chip defaults and allow the user to configure
things appropriately for their own system via the ALSA controls.  The
driver has to work with all boards using the device which means that
it's not possible to pick sane default setups.

> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

Is I2C control really optional?

> +/*
> + * gumstix i2c codec control layer
> + */

Cut'n'paste.

> +#define IJDET			(1<<1)

This needs to be namespaced.

> +#define M9888_REG_21_MIX_DAC		0x21
> +#define MIX_DAI1L_TO_DACL	(1<<7)
> +#define MIX_DAI1R_TO_DACL	(1<<6)
> +#define MIX_DAI2L_TO_DACL	(1<<5)
> +#define MIX_DAI2R_TO_DACL	(1<<4)
> +#define MIX_DAI1L_TO_DACR	(1<<3)
> +#define MIX_DAI1R_TO_DACR	(1<<2)
> +#define MIX_DAI2L_TO_DACR	(1<<1)
> +#define MIX_DAI2R_TO_DACR	(1<<0)

This too; all the individual register bit definitions in this header
have this problem.

> +#define HIGH_BYTE(w)			((w >> 8) & 0x00ff)
> +#define LOW_BYTE(w)			(w & 0x00ff)

I suspect there are standard defines for these.  If not there possibly
ought to be (and you have a namespace issue if defining locally).
