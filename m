Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0I2VmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:42:13 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:54887 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0I2VmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:42:11 -0400
X-ASG-Debug-ID: 1285796530-1e7499600001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Date: Wed, 29 Sep 2010 14:42:32 -0700
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Add max98088 CODEC driver
Subject: RE: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Topic: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Index: Actfh8XMSvcLQ8gjRNSEU7m/JI4begAjFJ/Q
Message-ID: <B2150E1E4418E1438554A300EA5040E40D46F2D8D8@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <20100929033757.GB29975@opensource.wolfsonmicro.com>
In-Reply-To: <20100929033757.GB29975@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2010 21:42:33.0164 (UTC) FILETIME=[394AB0C0:01CB601F]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1285796530
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010, Mark Brown wrote:
> On Tue, Sep 28, 2010 at 07:34:34PM -0700, Peter Hsiang wrote:
> 
> > +#define EQ_CFG_MAX 32
> 
> There doesn't seem to be any need to hard code a limit here?

Are you requiring the implementation be exactly the same way you did?

> 
> > +/*
> > + * For kernels compiled without unsigned long long int division
> > + */
> > +unsigned long long int ulldiv(unsigned long long int dividend,
> > +                             unsigned long long int divisor)
> 
> This is causing me some concern.  Even if it is required this does not
> look like something that should be part of a specific driver - what
> happens if some other driver needs the same thing?

You are more than welcome to use this in your driver as well :)
Just use it.  Sounds like you are suggesting to have it located in a
central location outside of the codec driver?
Would you like that in soc-core.c?  Let me know.

> 
> > +/*
> > + * The INx1 and INx2 PGAs share a power control signal.
> > + * This function OR's the two power events to keep an unpowered INx
> > + * from turning off it's counterpart.
> > + * The control names are used to identify the PGA.
> > + */
> 
> This...
> 
> > +       if (strncmp(w->name, "INA1", 4) == 0) {
> > +               pga = INA1_PGA_BIT;
> > +               mask = INA1_PGA_BIT | INA2_PGA_BIT;
> 
> ...doesn't seem to correspond to this, at least with the normal way mask
> is used.  Apart from anything else it looks like you have individual
> mask bits for each of the INx1 and INx2 PGAs (since you can define mask
> bits for each of them).  It would be much clearer if the code made it
> obvious that these aren't register bits but rather that you're storing
> the data in a register-like bitfield in a variable.  I can't help but
> think that a reference count would be much clearer.

There are more than one way to solve a problem, and they all can be
correct.
Would additional comments to clarify that this is not register bits
satisfy your requirement?

> 
> > +       if (event == SND_SOC_DAPM_POST_PMU) {
> > +               /* ON */
> > +               *state |= pga;
> > +
> > +               /* Turn on, avoiding unnecessary writes */
> > +               val = snd_soc_read(codec, w->reg);
> > +               if (!(val & (1 << w->shift))) {
> > +                       val |= (1 << w->shift);
> > +                       snd_soc_write(codec, w->reg, val);
> > +               }
> 
> snd_soc_update_bits() will suppress unwanted register writes.

>From the comments sounds like it resemble snd_soc_update_bits.
The code logic here is different from snd_soc_update_bits,
and therefore snd_soc_update_bits can not be used for this
like you suggested.

> > +
> > +static const unsigned int ex_mode_table[] = {
> > +       0x00,           /* disabled */
> > +       (0<<4)|3,       /* 100Hz */
> > +       (1<<4)|0,       /* 400Hz */
> > +       (2<<4)|0,       /* 600Hz */
> > +       (3<<4)|0,       /* 800Hz */
> > +       (4<<4)|0,       /* 1000Hz */
> > +       (1<<4)|1,       /* 200-400Hz */
> > +       (2<<4)|2,       /* 400-600Hz */
> > +       (3<<4)|2,       /* 400-800Hz */
> > +};
> 
> You should add value muxes like we have for DAPM.

Please clarify what you mean by referencing the specific 
code usage case in the dapm source module.

> 
> > +static const char *max98088_extmic[] = {
> > +       "Off",
> > +       "MIC1",
> > +       "MIC2",
> > +};
> 
> > +static const struct soc_enum max98088_extmic_enum[] = {
> > +       SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(max98088_extmic), max98088_extmic),
> > +};
> 
> This looks like it should be in DAPM.

This has nothing to do with power management.  
I guess you were confused by the word "Off" in the options list.
The "Off" case means the input for external mic is not used,
i.e. disconnected.  It does not power up or down anything.

> 
> > +static int max98088_mic1pre_set(struct snd_kcontrol *kcontrol,
> > +                               struct snd_ctl_elem_value *ucontrol)
> > +{
> > +       struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
> > +       struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
> > +       unsigned int *mode = &max98088->mic1pre;
> > +       int sel = ucontrol->value.integer.value[0];
> > +
> > +       if (sel >= ARRAY_SIZE(max98088_micpre))
> > +               return -EINVAL;
> > +
> > +       *mode = ucontrol->value.integer.value[0];
> > +       return 0;
> > +}
> 
> I'd expect that some action would be taken when the value is set here.
> All this does is set a variable, changing the control will have no
> effect.

The register field works like this:
00 = preamp disabled
01 = 0dB
10 = 20dB
11 = 30dB
So the gain and the power setting are in the same bit field.
DAPM owns the power control.  Here the user settings are stored,
and they get picked up by DAPM.

> 
> > +static int max98088_hp_event(struct snd_soc_dapm_widget *w,
> > +                            struct snd_kcontrol *kcontrol, int event)
> > +{
> > +       struct snd_soc_codec *codec = w->codec;
> > +       u16 status;
> > +
> > +       BUG_ON(event != SND_SOC_DAPM_PRE_PMD);
> > +
> > +       /* powering down headphone gracefully */
> > +       status = snd_soc_read(codec, M98088_REG_4D_PWR_EN_OUT);
> > +       if ((status & M98088_HPEN) == M98088_HPEN) {
> > +               max98088_hw_write(codec, M98088_REG_4D_PWR_EN_OUT,
> > +                       (status & ~M98088_HPEN));
> > +       }
> > +       schedule_timeout(msecs_to_jiffies(20));
> 
> This looks rather like it should just be a post event implementing a
> timeout?

This needs to work as a pre event.

> 
> > +       if (rate != cdata->rate) {
> > +               /* set DAI1 SR1 value for the DSP; FREQ1:0=anyclock */
> > +               if (rate_value(rate, &regval))
> > +                       return -EINVAL;
> > +
> > +               snd_soc_write(codec, M98088_REG_11_DAI1_CLKMODE, regval);
> > +               cdata->rate = rate;
> > +       }
> 
> Just use snd_soc_update_bits() to suppress unneeded writes.  Many of the
> operaations have this issue.

The full value for this register is accounted for here and so there
is no need to use snd_soc_update_bits for this case.

> 
> > +               & M98088_DAI_MAS) {
> > +               if (max98088->sysclk == 0)
> > +                       return -EINVAL;
> 
> You should print an error here so users can tell what went wrong.

Yes thank you.

> 
> > +       case SND_SOC_BIAS_STANDBY:
> > +               max98088_sync_cache(codec);
> > +               snd_soc_update_bits(codec, M98088_REG_4C_PWR_EN_IN,
> > +                               M98088_MBEN, M98088_MBEN);
> > +               break;
> 
> Do you really want to sync the cache *every* time you go into standby?

The sync_cache function itself will just return if the
codec->cache_sync flag is cleared from the first time it ran.
You do the exact same thing in your codec driver...
What is the change that you are suggesting?

> 
> > +module_init(max98088_init);
> 
> Normally this would be next to the function it references.

Is this a new formatting style of the kernel now all across,
or is this a personal preference?
Not a problem, I can change it.  Just that I find a huge number 
of drivers in the kernel having the module_init and module_exit 
together at the very end.

