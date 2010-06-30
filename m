Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0F3Oxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:53:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50436 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753630Ab0F3Oxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:53:45 -0400
Date: Wed, 30 Jun 2010 15:53:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: DaVinci: Added support for cpu clocking I2S
Message-ID: <20100630145342.GE3634@rakim.wolfsonmicro.main>
References: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
 <20100628103030.GB14247@rakim.wolfsonmicro.main>
 <AANLkTimedG3X-rQbZvS6QfxUGkPIAtCgliI0xWknmNA9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimedG3X-rQbZvS6QfxUGkPIAtCgliI0xWknmNA9@mail.gmail.com>
X-Cookie: I'm also against BODY-SURFING!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:17:40AM +0200, Raffaele Recalcati wrote:
> 2010/6/28 Mark Brown <broonie@opensource.wolfsonmicro.com>

> > It's still very hard to understand what this patch is supposed to do.
> > As previously mentioned this would probably be a lot clearer if you
> > split this into multiple patches, for example one adding support for the
> > fast clock mode, one adding support for selecting the pin used for any
> > external clock and then further patches with any other changes.

> Looking at other paches, they are simpler than mine.

The big problem is you're just making some general (and not particularly
clear) statements about features without saying anything concrete about
what the patch actually does - is there a bug being fixed, a feature
implemented, or what?  

> > >     Added audio playback support with [frame sync master - clock master]
> > mode
> > >     and with [frame sync master - clock slave].

> > What are these modes - which clock are you talking about?

> McBSP i2s interface to external codec.

Perhaps you mean the bit clock on the I2S interface?  There are multiple
clocks on the actual I2S link itself, and often people lump in the
master clock for the I2S interface into the interface itself.

> > >        i2s_fast_clock switch can be used to have better approximate or
> > >        symmetric waveforms.

> > Why would someone choose not to use this?

> I was not sure if symmetric waveform can be a must.
> In general I think it is better a non symmetric, but better approximate,
> waveform.
> Anyway, it is better to have the possibility to choose in my opinion,
> because I have not so much experience in i2s communication.

If I understand this correctly when you say "approximate" what you mean
is "approximate clock rate" so the tradeoff is between the accuracy of
the rate generated and the duty cycle of the output signal?

> > > +     /* To be used when cpu gets clock from extenal pin */
> > > +     int clk_input_pin;

> > How would one use this?

> looking at 2.5 Clock, Frames, and Data in
> you can select MCBSP_CLKS or other input clock pins.

You need to put this in the comments.

> > > +static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
> > > +                             int div_id, int div)
> > > +{
> > > +     struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
> > > +     int srgr;
> > > +
> > > +     dev->clk_div = div;
> > > +     return 0;
> > > +}

> > I would add a clock ID here in case someone wants to configure another
> > clock in the patch.

> Can you explain better,
> please?

You need to require a value for div_id.

> > I'd also expect this to be doing a clk_get() using the struct device for
> > the DAI so that the driver can function even if the clock tree for a new..
> > SoC is different.

> Sorry, I don't understand, can you explain me better?

clk_get() takes two parameters, a struct device and a name.  You should
be using a clock specified in terms of a particular device, not one with
a NULL pointer for the struct device.

> > > +             freq = 122000000; /* FIXME ask to Texas */

> > ...this presumably ought to be in an else clause (or perhaps just not
> > using this clocking at all if you can't find the clock?).

> freq is used to obtain clk_div.
> The real problem is that, as explained in the manual, it is not clear its
> value.
> I hope someone can help!!

I would very strongly expect that the division would be from the clock
rate of the source clock which you can obtain by using clk_get().
