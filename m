Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1LZMbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 07:31:16 -0500
Received: from d1.icnet.pl ([212.160.220.21]:55736 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab1LZMbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 07:31:12 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Date: Mon, 26 Dec 2011 13:30:22 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl> <1324681944-19067-5-git-send-email-jkrzyszt@tis.icnet.pl> <20111226110348.GB8722@opensource.wolfsonmicro.com>
In-Reply-To: <20111226110348.GB8722@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112261330.22783.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 of December 2011 at 12:03:49, Mark Brown wrote:
> On Sat, Dec 24, 2011 at 12:12:24AM +0100, Janusz Krzysztofik wrote:
> 
> > +struct regulator_consumer_data {
> > +	struct mutex lock;
> > +	struct regulator *regulator;
> > +	bool enabled;
> > +};
> > +
> > +static int regulator_toggle(struct regulator_consumer_data *consumer,
> > +		bool enable)
> > +{
> > +	int err = 0;
> > +
> > +	if (!consumer->regulator)
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&consumer->lock);
> > +	if (IS_ERR(consumer->regulator)) {
> > +		err = PTR_ERR(consumer->regulator);
> > +	} else if (enable) {
> > +		if (!consumer->enabled) {
> > +			err = regulator_enable(consumer->regulator);
> > +			consumer->enabled = true;
> > +		}
> > +	} else {
> > +		if (consumer->enabled) {
> > +			err = regulator_disable(consumer->regulator);
> > +			consumer->enabled = false;
> > +		}
> > +	}
> > +	mutex_unlock(&consumer->lock);
> > +
> > +	return err;
> > +}
> > +
> 
> Why's this code not been dropped and what is it for?

It is, and will be, used by another regulator consumer, the modem. The 
device is controlled by the generic serial8250 driver, extended with a 
custom .pm hook which enables/disables the regulator. The above code, 
temporarily shared with the ASoC device before updated, is now just 
moved down the board file where the modem related bits are located (see 
patch 3/4).

Any hints like that for the codec driver?

Thanks,
Janusz
