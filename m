Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1EPVZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:25:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50204 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1EPVZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:25:39 -0400
Date: Mon, 16 May 2011 22:25:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 1/3] ASoC: Asahi Kasei AK4641 codec
	driver
Message-ID: <20110516212533.GA2570@sirena.org.uk>
References: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru> <1305579805-15617-2-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305579805-15617-2-git-send-email-mad_soft@inbox.ru>
X-Cookie: An idle mind is worth two in the bush.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 01:03:23AM +0400, Dmitry Artamonow wrote:
> A driver for the AK4641 codec used in iPAQ hx4700 and Glofiish M800
> among others.

This looks pretty good - a few small issues realting to the use of old
APIs and coding standards below but nothing serious.

> +static int ak4641_sync(struct snd_soc_codec *codec)
> +{
> +	u8 *cache = codec->reg_cache;
> +	int i, r = 0;
> +
> +	for (i = 0; i < AK4641_CACHEREGNUM; i++)
> +		r |= snd_soc_write(codec, i, cache[i]);
> +
> +	return r;
> +};

You should be able to use snd_soc_cache_sync() instead of open coding
this.  There's also a stray ; in there.

> +
> +static int ak4641_add_widgets(struct snd_soc_codec *codec)
> +{
> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
> +	snd_soc_dapm_new_controls(dapm, ak4641_dapm_widgets,
> +				  ARRAY_SIZE(ak4641_dapm_widgets));
> +
> +	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
> +
> +	snd_soc_dapm_new_widgets(dapm);
> +	return 0;

You should be able to convert these to data based init using the
dapm_widgets and dapm_routes fields in the CODEC driver.

> +	u8 mode2 = snd_soc_read(codec, AK4641_MODE2) & ~(0x3 << 5);

Use snd_soc_update_bits() to do a read/modify/write cycle rather than
open coding it - it's clearer and will save writing when there's no
change.  A similar thing applies in several of the other DAI operations
and set_bias_level().
