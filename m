Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1CVQBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:01:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53359 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1CVQB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:01:29 -0400
Date: Tue, 22 Mar 2011 17:00:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110322160055.GA22128@elte.hu>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
 <20110321153719.GA12325@elte.hu>
 <20110321155836.GE2570@opensource.wolfsonmicro.com>
 <20110321161102.GB23614@elte.hu>
 <20110321163849.GF2570@opensource.wolfsonmicro.com>
 <20110321164937.GA6381@elte.hu>
 <20110321165827.GG2570@opensource.wolfsonmicro.com>
 <20110322122436.GA6834@opensource.wolfsonmicro.com>
 <20110322083839.caab0520.randy.dunlap@oracle.com>
 <s5hk4frnog6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk4frnog6.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 22 Mar 2011 08:38:39 -0700,
> Randy Dunlap wrote:
> > 
> > On Tue, 22 Mar 2011 12:24:36 +0000 Mark Brown wrote:
> > 
> > > On Mon, Mar 21, 2011 at 04:58:27PM +0000, Mark Brown wrote:
> > > > That's the breakage, yes.  It should be very straightforward to make the
> > > > driver build no matter how CONFIG_REGULATOR is set.
> > > 
> > > And indeed it was - in the absence of any response from Zeng I've now
> > > sent a patch for review.
> > > --
> > 
> > Hi,
> > Where was the patch sent, please?
> 
> alsa-devel ML.  Attached below.
> 
> 
> Takashi
> 
> ===
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Subject: [alsa-devel] [PATCH] ASoC: Support !REGULATOR build for sgtl5000
> 
> The regulator is optional depending on board design.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/sgtl5000.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 1f7217f..ff29380 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -772,6 +772,7 @@ static int sgtl5000_pcm_hw_params(struct snd_pcm_substream *substream,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_REGULATOR
>  static int ldo_regulator_is_enabled(struct regulator_dev *dev)
>  {
>  	struct ldo_regulator *ldo = rdev_get_drvdata(dev);
> @@ -901,6 +902,19 @@ static int ldo_regulator_remove(struct snd_soc_codec *codec)
>  
>  	return 0;
>  }
> +#else
> +static int ldo_regulator_register(struct snd_soc_codec *codec,
> +				struct regulator_init_data *init_data,
> +				int voltage)
> +{
> +	return -EINVAL;
> +}
> +
> +static int ldo_regulator_remove(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}
> +#endif

Btw., ldo_regulator_remove() returns an int, but none of the call sites make 
use of the return value. Also, ldo_regulator_remove() can only ever return 0.

More importantly, it would be cleaner to wrap the !regulator case by making 
sgtl5000->ldo NULL (this should already be the case) and making 
regulator_unregister() available in the !REGULATOR case as well, as an inline 
stub.

If that is done then the #ifdef can be avoided altogether and the current code 
would just work out of box:

static int ldo_regulator_remove(struct snd_soc_codec *codec)
{
        struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
        struct ldo_regulator *ldo = sgtl5000->ldo;

        if (!ldo)
                return 0;

        regulator_unregister(ldo->dev);
        kfree(ldo->desc.name);
        kfree(ldo);

        return 0;
}

Thanks,

	Ingo
