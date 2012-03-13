Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab2CMXOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:14:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7426 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760410Ab2CMXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:14:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Mar 2012 16:14:29 -0700
Subject: Re: [PATCH] ASoC: max98095: add jack detection
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Peter Hsiang <cdefgab1288@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120313230939.GO3177@opensource.wolfsonmicro.com>
References: <1331667848-8168-1-git-send-email-rklein@nvidia.com>
	 <20120313230939.GO3177@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 16:15:24 -0700
Message-ID: <1331680524.9410.11.camel@rklein-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 16:09 -0700, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Mar 13, 2012 at 12:44:08PM -0700, Rhyland Klein wrote:
> 
> > This change adds the logic to support using the jack detect mechanism built
> > in to the codec to detect both when a jack was inserted and what type of
> > jack is present.
> 
> This looks mostly good, a few things below.
> 
> > @@ -51,6 +52,9 @@ struct max98095_priv {
> >  	u8 lin_state;
> >  	unsigned int mic1pre;
> >  	unsigned int mic2pre;
> > +	int irq;
> 
> You can just get the irq from the I2C device.

Right, will do.

> 
> > +	if (max98095->headphone_jack == max98095->mic_jack)
> > +		snd_soc_jack_report(max98095->headphone_jack,
> > +					hp_report | mic_report,
> > +					SND_JACK_HEADSET);
> > +	else {
> 
> Braces on both sides of the if for clarity.

will do. 

> 
> > +static irqreturn_t max98095_jack_handler(int irq, void *data)
> > +{
> > +	struct snd_soc_codec *codec = data;
> > +	int ret;
> > +
> > +	ret = max98095_report_jack(codec);
> > +
> > +	return ret ? IRQ_NONE : IRQ_HANDLED;
> 
> There is no point in having a separate function here, this function has
> no contents.  Just inline it.  Please also avoid the use of the ternery
> operator.

will do.

> 
> > +	/* configure jack detection: slew is calculated as 4 * (delay + 1)
> > +	 * The default is 24 (0x18) to get 100ms delay.
> > +	 */
> > +	ret = snd_soc_write(codec, M98095_08E_JACK_DC_SLEW,
> > +				M98095_DEFAULT_SLEW_DELAY);
> > +	if (ret < 0) {
> > +		dev_err(codec->dev, "Failed to cfg auto detect %d\n", ret);
> > +		return ret;
> > +	}
> 
> Platform data?

As of now there isn't. But that does make sense to support. Will add.

> 
> > +	enable_irq(max98095->irq);
> 
> You shouldn't be fiddling around with enable_irq() and disable_irq().
> Why are you doing this?

this can be removed.

> 
> * Unknown Key
> * 0x6E30FDDD

Thanks for quick review,
Rhyland


