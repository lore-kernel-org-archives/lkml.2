Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab1CIKMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:12:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45498 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757090Ab1CIKMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:12:24 -0500
Date: Wed, 9 Mar 2011 10:12:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Cliff Cai <cliffcai.sh@gmail.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [alsa-devel] [PATCH] Add driver for Analog Devices ADAU1701
 SigmaDSP
Message-ID: <20110309101221.GC6923@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTinmbJWAoFPPT9aNrJQ+E+eb-3a1F_cV-d2J3YGj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinmbJWAoFPPT9aNrJQ+E+eb-3a1F_cV-d2J3YGj@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:04:03PM +0800, Cliff Cai wrote:
> On Mon, Mar 7, 2011 at 7:41 PM, Mark Brown
> > On Mon, Mar 07, 2011 at 09:11:42AM +0800, cliff.cai@analog.com wrote:

> > It loooks like the register length is hard coded in every location that
> > the register is referenced. ?This doesn't seem ideal - it'd be much
> > nicer to have the register I/O functions work this out without the
> > callers needing to.

> I'm afraid it's not easy to do so.

What's the issue?  I'd expect something like a lookup table or switch
statement going from register to register length - I'd be surprised if
it were any more complicated than getting all the callers right.

> >> +static int adau1701_pcm_prepare(struct snd_pcm_substream *substream,
> >> +                             struct snd_soc_dai *dai)
> >> +{
> >> +     struct snd_soc_codec *codec = dai->codec;
> >> +     int reg = 0;

> >> +     reg = SEROCTL_MASTER | SEROCTL_OBF16 | SEROCTL_OLF1024;
> >> +     adau1701_write_register(codec, ADAU1701_SEROCTL, 2, reg);

> >> +     return 0;
> >> +}

> > This looks like some of it is DAI format and word length configuration?

> no,it makes the processor work in master mode.and output bit clock and
> frame clock.

This controls the CODEC, not the CPU?  Master/slave should be controlled
by set_dai_fmt() rather than being hard coded.

> >> +static void adau1701_shutdown(struct snd_pcm_substream *substream,
> >> +                           struct snd_soc_dai *dai)
> >> +{
> >> +     struct snd_soc_codec *codec = dai->codec;

> >> +     adau1701_write_register(codec, ADAU1701_SEROCTL, 2, 0);
> >> +}

> > I suspect this isn't going to work for simultaneous playback and capture
> > - it's not clear what the code does but I'd guess it will stop things
> > completely.

> this SigmaDSP doesn't support duplex operation,it can choose either
> ADCs or serial port as input source.

The driver should be enforcing this constraint, then.

> >> +static int adau1701_set_bias_level(struct snd_soc_codec *codec,
> >> +                              enum snd_soc_bias_level level)
> >> +{
> >> +     u16 reg;
> >> +     switch (level) {
> >> +     case SND_SOC_BIAS_ON:
> >> +             reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
> >> +             reg &= ~(AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
> >> +                      AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD);
> >> +             adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);

> > You were also updating some of the same register bits in the mute
> > function.  This looks buggy.

> the processor has no switchs to mute or unmute ADCS/DACs,only thing we
> can do is turning them off or on.

If mute can't be implemented don't implement it.  Right now the code is
clearly not going to do what's expected as you've got two different bits
of code trying to control the same thing - at least one set of register
updates isn't going to do anything?

> >> +     ret = adau1701_setprogram(codec);
> >> +     if (ret < 0) {
> >> +             printk(KERN_ERR "Loading program data failed\n");
> >> +             goto error;
> >> +     }
> >> +     reg = DSPCTRL_DAM | DSPCTRL_ADM;
> >> +     adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
> >> +     reg = 0x08;
> >> +     adau1701_write_register(codec, ADAU1701_DSPRES, 1, reg);

> > Should these DSP configuations things be part of downloading firmware?

> these configurations above loading firmware mainly used to avoid pops/clicks
> and cleanup some registers in the DSP core.

Right, but is this something that's always useful when loading firmware
(in which case the firmware load should just wrap it up so it always
happens)?

> >> +     adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, 0);
> >> +     reg = AUXADCE_AAEN;
> >> +     adau1701_write_register(codec, ADAU1701_AUXADCE, 2, reg);
> >> +     reg = DACSET_DACEN;
> >> +     adau1701_write_register(codec, ADAU1701_DACSET, 2, reg);
> >> +     reg = DSPCTRL_DAM | DSPCTRL_ADM | DSPCTRL_CR;
> >> +     adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
> >> +     /* Power-up the oscillator */
> >> +     adau1701_write_register(codec, ADAU1701_OSCIPOW, 2, 0);

> > This looks like it's all power management which I'd expect to see
> > handled in either the bias management functions or ideally DAPM.  It
> > also appears that the oscillator is an optional feature so it should be
> > used conditionally.

> the processor can receive MCLK either from external clock source or
> crystal oscillator,
> currently we use the on board crystal,and it can't be turned
> off,otherwise the whole chip will be in an unpredicted status,
> only output clocks can be disabled.

That's specific to your board design, though.  Another board design
might use a different clocking setup.
