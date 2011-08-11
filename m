Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1HKJ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:27:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39424 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754282Ab1HKJ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:27:21 -0400
Date: Thu, 11 Aug 2011 18:27:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
Message-ID: <20110811092702.GA18454@opensource.wolfsonmicro.com>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
 <1312948364-2587-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312948364-2587-2-git-send-email-lars@metafoo.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 05:52:42AM +0200, Lars-Peter Clausen wrote:

> +static const char *adau1373_micbias_text[] = {
> +	"2.9 V",
> +	"2.2 V",
> +	"2.6 V",
> +	"1.8 V",
> +};

This should be controlled by platform data and/or the machine driver,
not interactively by the user.  With some microphone technologies there
is actually a risk of damage with higher micbiases.

> +	SOC_DOUBLE("AIF3 Playback Boost(+6dB)", ADAU1373_VOL_GAIN1, 4, 5, 1, 0),
> +	SOC_DOUBLE("AIF2 Playback Boost(+6dB)", ADAU1373_VOL_GAIN1, 2, 3, 1, 0),
> +	SOC_DOUBLE("AIF1 Playback Boost(+6dB)", ADAU1373_VOL_GAIN1, 0, 1, 1, 0),
> +	SOC_DOUBLE("AIF3 Capture Boost(+6dB)", ADAU1373_VOL_GAIN2, 4, 5, 1, 0),
> +	SOC_DOUBLE("AIF2 Capture Boost(+6dB)", ADAU1373_VOL_GAIN2, 2, 3, 1, 0),
> +	SOC_DOUBLE("AIF1 Capture Boost(+6dB)", ADAU1373_VOL_GAIN2, 0, 1, 1, 0),
> +	SOC_DOUBLE("DMIC Capture Boost(+6dB)", ADAU1373_VOL_GAIN3, 6, 7, 1, 0),
> +	SOC_DOUBLE("ADC Capture Boost(+6dB)", ADAU1373_VOL_GAIN3, 4, 5, 1, 0),
> +	SOC_DOUBLE("DAC2 Playback Boost(+6dB)", ADAU1373_VOL_GAIN3, 2, 3, 1, 0),
> +	SOC_DOUBLE("DAC1 Playback Boost(+6dB)", ADAU1373_VOL_GAIN3, 0, 1, 1, 0),
> +
> +	SOC_DOUBLE("Input1 Boost(+20dB)", ADAU1373_ADC_GAIN, 0, 4, 1, 0),
> +	SOC_DOUBLE("Input2 Boost(+20dB)", ADAU1373_ADC_GAIN, 1, 5, 1, 0),
> +	SOC_DOUBLE("Input3 Boost(+20dB)", ADAU1373_ADC_GAIN, 2, 6, 1, 0),
> +	SOC_DOUBLE("Input4 Boost(+20dB)", ADAU1373_ADC_GAIN, 3, 7, 1, 0),

All this stuff should be TLV.

> +	SOC_ENUM("Lineout1 Mono Stereo", adau1373_lineout1_mode_enum),
> +	SOC_ENUM("Speaker Mono Stereo", adau1373_speaker_mode_enum),

I'd expect these to be platform data/machine data rather than user
control?  The speaker wiring isn't going to vary dynamically...

> +	switch (freq / params_rate(params)) {
> +	case 1024: /* fs */
> +		div = 0;
> +		break;
> +	case 1536: /* 2/3 fs */
> +		div = 1;
> +		break;

These comments look inaccuate, fs is the sample rate so a divide of 1
would be fs.

> +static void adau1373_load_drc_settings(struct snd_soc_codec *codec,
> +	unsigned int nr, uint8_t *drc)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < 13; ++i)
> +		snd_soc_write(codec, ADAU1373_DRC(nr) + i, drc[i]);

ARRAY_SIZE() or a #define or something rather than a magic number.
