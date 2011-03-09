Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1CIHEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:04:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1CIHEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCJVePacjAqx6W5cGnXRXBaH1Vo4YFn1Az7SG6CLYWEOI6SOF2wVsB6Pygd1UNAxTg
         ruHJOrQxko6cjXD7TTPpiJcjXakqg463vg98bONJuHoGGfh6f5PAhnyCf61haW9Pu0dA
         9kZ7pLSq3VDUmWljUrG1/0O7BwXyY472f+mwk=
MIME-Version: 1.0
In-Reply-To: <20110307114142.GB13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
	<20110307114142.GB13471@opensource.wolfsonmicro.com>
Date: Wed, 9 Mar 2011 15:04:03 +0800
Message-ID: <AANLkTinmbJWAoFPPT9aNrJQ+E+eb-3a1F_cV-d2J3YGj@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] Add driver for Analog Devices ADAU1701 SigmaDSP
From: Cliff Cai <cliffcai.sh@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 7:41 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Mar 07, 2011 at 09:11:42AM +0800, cliff.cai@analog.com wrote:
>
>> From: Cliff Cai <cliff.cai@analog.com>
>
>> ADAU1701 is an SigmaDSP processor,it supports I2S audio interface.
>
> As with previous submissions from you guys this won't compile with
> current ASoC versions.  All new driver code submitted for mainline
> should be submitted against the development versions of the trees you're
> submitting against, in general -next contains everything relevant.
>
>> It needs to include "linux/sigma.h" which is still in Andrew Morton's
>> tree.
>
> Is this needed by other trees?  I can't apply this driver until it's
> merged into ASoC via some means.  I guess it'll go in during the merge
> window, though, and you do need to respin.
>
>>       select SND_SOC_PCM3008
>>       select SND_SOC_SPDIF
>>       select SND_SOC_SSM2602 if I2C
>> +     select SND_SOC_ADAU1701 if I2C
>>       select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
>>       select SND_SOC_TLV320AIC23 if I2C
>
> This presumably also needs to select the DSP API otherwise it's not
> going to build.
>
> As ever, keep the Kconfig and Makefile sorted.
>
>> +#define AUDIO_NAME "adau1701"
>> +#define ADAU1701_VERSION "0.10"
>
> These aren't referenced anywhere, remove them.
>
>> +/*
>> + * Write a ADAU1701 register,since the register length is from 1 to 5,
>> + * So, use our own read/write functions instead of snd_soc_read/write.
>> + */
>> +static int adau1701_write_register(struct snd_soc_codec *codec,
>> +     u16 reg_address, u8 length, u32 value)
>> +{
>
> It loooks like the register length is hard coded in every location that
> the register is referenced.  This doesn't seem ideal - it'd be much
> nicer to have the register I/O functions work this out without the
> callers needing to.

I'm afraid it's not easy to do so.

>> +static int adau1701_pcm_prepare(struct snd_pcm_substream *substream,
>> +                             struct snd_soc_dai *dai)
>> +{
>> +     struct snd_soc_codec *codec = dai->codec;
>> +     int reg = 0;
>> +
>> +     reg = SEROCTL_MASTER | SEROCTL_OBF16 | SEROCTL_OLF1024;
>> +     adau1701_write_register(codec, ADAU1701_SEROCTL, 2, reg);
>> +
>> +     return 0;
>> +}
>
> This looks like some of it is DAI format and word length configuration?

no,it makes the processor work in master mode.and output bit clock and
frame clock.

>> +static void adau1701_shutdown(struct snd_pcm_substream *substream,
>> +                           struct snd_soc_dai *dai)
>> +{
>> +     struct snd_soc_codec *codec = dai->codec;
>> +
>> +     adau1701_write_register(codec, ADAU1701_SEROCTL, 2, 0);
>> +}
>
> I suspect this isn't going to work for simultaneous playback and capture
> - it's not clear what the code does but I'd guess it will stop things
> completely.

this SigmaDSP doesn't support duplex operation,it can choose either
ADCs or serial port as input source.
>> +static int adau1701_set_dai_fmt(struct snd_soc_dai *codec_dai,
>> +             unsigned int fmt)
>> +{
>> +     struct snd_soc_codec *codec = codec_dai->codec;
>> +     u32 reg = 0;
>> +
>> +     reg = adau1701_read_register(codec, ADAU1701_SERITL1, 1);
>> +     /* interface format */
>> +     switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
>> +     case SND_SOC_DAIFMT_I2S:
>> +             break;
>> +     case SND_SOC_DAIFMT_LEFT_J:
>> +             reg |= SERITL1_LEFTJ;
>> +             break;
>> +     /* TODO: support TDM */
>
> I'd expect that the I2S case should be clearing a bitmask.
>
>> +     default:
>> +             return 0;
>> +     }
>
> Return an error if you don't support something.  The same issue applies
> elsewhere in the function.
>
>> +static int adau1701_set_bias_level(struct snd_soc_codec *codec,
>> +                              enum snd_soc_bias_level level)
>> +{
>> +     u16 reg;
>> +     switch (level) {
>> +     case SND_SOC_BIAS_ON:
>> +             reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
>> +             reg &= ~(AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
>> +                      AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD);
>> +             adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
>
> You were also updating some of the same register bits in the mute
> function.  This looks buggy.

the processor has no switchs to mute or unmute ADCS/DACs,only thing we
can do is turning them off or on.

>> +             break;
>> +     case SND_SOC_BIAS_PREPARE:
>> +             break;
>> +     case SND_SOC_BIAS_STANDBY:
>> +             break;
>> +     case SND_SOC_BIAS_OFF:
>> +             /* everything off, dac mute, inactive */
>> +             reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
>> +             reg |= AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
>> +                      AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD;
>> +             adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
>> +             break;
>
> It's very odd that the code only does anything in _OFF or _ON - what
> exactly are these updates doing?
>
>> +             .rates = ADAU1701_RATES,
>> +             .formats = ADAU1701_FORMATS,
>> +     },
>> +     .ops = &adau1701_dai_ops,
>> +};
>> +EXPORT_SYMBOL_GPL(adau1701_dai);
>
> This is not required.
>
>> +static ssize_t adau1371_dsp_load(struct device *dev,
>> +                               struct device_attribute *attr,
>> +                               const char *buf, size_t count)
>> +{
>> +     int ret = 0;
>> +     struct adau1701_priv *adau1701 = dev_get_drvdata(dev);
>> +     struct snd_soc_codec *codec = adau1701->codec;
>> +     ret = adau1701_setprogram(codec);
>> +     if (ret)
>> +             return ret;
>> +     else
>> +             return count;
>> +}
>> +static DEVICE_ATTR(dsp, 0644, NULL, adau1371_dsp_load);
>
> You're marking the file as supporting both read and write but only
> providing write functionality, and the write functionality totally
> ignores the written data.
>
> More generally this doesn't seem like a great interface - apparently the
> device requries that firmware be loaded but the whole firmware load
> process isn't at all joined up with the driver code meaning that the
> application layer has to figure out when firmware needs to be reloaded,
> there's no understanding on the part of the driver of what the firmware
> on the device is doing or how it's glued into the audio subsystem.
>
>> +     ret = adau1701_setprogram(codec);
>> +     if (ret < 0) {
>> +             printk(KERN_ERR "Loading program data failed\n");
>> +             goto error;
>> +     }
>> +     reg = DSPCTRL_DAM | DSPCTRL_ADM;
>> +     adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
>> +     reg = 0x08;
>> +     adau1701_write_register(codec, ADAU1701_DSPRES, 1, reg);
>
> Should these DSP configuations things be part of downloading firmware?

these configurations above loading firmware mainly used to avoid pops/clicks
and cleanup some registers in the DSP core.

>> +     adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, 0);
>> +     reg = AUXADCE_AAEN;
>> +     adau1701_write_register(codec, ADAU1701_AUXADCE, 2, reg);
>> +     reg = DACSET_DACEN;
>> +     adau1701_write_register(codec, ADAU1701_DACSET, 2, reg);
>> +     reg = DSPCTRL_DAM | DSPCTRL_ADM | DSPCTRL_CR;
>> +     adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
>> +     /* Power-up the oscillator */
>> +     adau1701_write_register(codec, ADAU1701_OSCIPOW, 2, 0);
>
> This looks like it's all power management which I'd expect to see
> handled in either the bias management functions or ideally DAPM.  It
> also appears that the oscillator is an optional feature so it should be
> used conditionally.

the processor can receive MCLK either from external clock source or
crystal oscillator,
currently we use the on board crystal,and it can't be turned
off,otherwise the whole chip will be in an unpredicted status,
only output clocks can be disabled.

>> +     struct adau1701_priv *adau1701 = snd_soc_codec_get_drvdata(codec);
>> +
>> +     adau1701->codec = codec;
>
> You don't actually ever seem to reference the codec pointer you're
> storing, perhaps just loose it?
>
>> +/* Bit fields */
>> +#define DSPCTRL_CR           (1 << 2)
>> +#define DSPCTRL_DAM          (1 << 3)
>> +#define DSPCTRL_ADM          (1 << 4)
>> +#define DSPCTRL_IST          (1 << 5)
>> +#define DSPCTRL_IFCW         (1 << 6)
>> +#define DSPCTRL_GPCW         (1 << 7)
>> +#define DSPCTRL_AACW         (1 << 8)
>
> These and the other bitfield definitions in the header should all be
> namespaced.
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>
