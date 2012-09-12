Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2ILMqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:46:09 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:50344
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757788Ab2ILMqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:46:05 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdhbe9i1155h)
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
In-Reply-To: <20120912025709.GD9162@opensource.wolfsonmicro.com>
References: <1347375823.12329.14.camel@matrix>
	 <20120912025709.GD9162@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Sep 2012 18:26:18 +0530
Message-ID: <1347454578.23366.305.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 10:57 +0800, Mark Brown wrote:
> > +/* Digital MIC clock rate select */
> > +static const char * const da9055_dmic_clk_rate_txt[] = {
> > +	"3MHz", "1.5MHz"
> > +};
> > +
> > +static const struct soc_enum da9055_dmic_clk_rate =
> > +	SOC_ENUM_SINGLE(DA9055_MIC_CONFIG, 2, 2, da9055_dmic_clk_rate_txt);
> > +
> > +/* Digital MIC sample phase select */
> > +static const char * const da9055_dmic_phase_txt[] = {
> > +	"Sample on DMICCLK edges", "Sample between DMICCLK edges"
> > +};
> > +
> > +static const struct soc_enum da9055_dmic_phase =
> > +	SOC_ENUM_SINGLE(DA9055_MIC_CONFIG, 1, 2, da9055_dmic_phase_txt);
> > +
> > +/* Digital MIC channel select */
> > +static const char * const da9055_dmic_channel_select_txt[] = {
> > +	"Rising Left Falling Right", "Falling Left Rising Right"
> > +};
> 
> Why is any of this being exposed to userspace?  If this should be
> configured I'd expect it to be static platform data, not something that
> gets changed at runtime.
> 

These parameters are exposed considering the fact that DMIC itself is
not part of the codec. Codec only provides DMIC interface using which an
external DMIC can be attached. These parameters depend on the actual
DMIC hardware and hence kept configurable to allow runtime plug in of
any DMIC hardware. Doesn't it make sense to keep them runtime
configurable?


> 
> > +	/* In slave mode, there is only one set of divisors */
> > +	if (!da9055->master)
> > +		fout = 2822400;
> 
> Should check the user supplied this value

Can you explain which value / user supplied value you are referring to?
It is not quite clear to me.

>  - also, what happens if the
> user sets the device to slave mode after setting up the PLL?

Will add required checks in set_fmt().

> > +	/* Enable Mic Bias */
> > +	snd_soc_write(codec, DA9055_MIC_BIAS_CTRL, DA9055_MIC_BIAS_EN);
> 
> DAPM for this and most of the rest of this funciton.

I guess here a DAPM_SUPPLY widget should be used and its routing should
be part of machine driver instead of this codec driver, right?

For other things like input mixers, Headphone and Lineouts, DAPM is
already used to control power specific bits. The confusion is because
there are two separate control bits for these blocks. One bit is for
"Enabling" that block and other is for "Enabling Amplifier" of that
block.
e.g for headphone, one bit is for "output enable" while other is for
"output amplifier enable".

Chip designers have confirmed that "Amplifier Enable" bits are ones
which should be used for power management. This is the reason why
"Enable" bits are being set in probe() and "Amplifier Enable" bits are
being taken care by DAPM. May be I need to put enough comments in code
to clarify this.


