Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0FCX55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:57:57 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37429 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab0FCX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:57:55 -0400
Message-ID: <4C084155.5010503@metafoo.de>
Date: Fri, 04 Jun 2010 01:57:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 20/26] alsa: ASoC: Add JZ4740 codec driver
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505950-17334-4-git-send-email-lars@metafoo.de> <20100603174953.GH2762@rakim.wolfsonmicro.main>
In-Reply-To: <20100603174953.GH2762@rakim.wolfsonmicro.main>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Mark Brown wrote:
> On Wed, Jun 02, 2010 at 09:12:26PM +0200, Lars-Peter Clausen wrote:
>
>   
>> This patch adds support for the JZ4740 internal codec.
>>     
>
> This looks very good, there are some issues but nothing too major.  I
> may be repeating some things others have said but hopefully not too
> much.
>
>   
>>  snd-soc-wm9712-objs := wm9712.o
>>  snd-soc-wm9713-objs := wm9713.o
>>  snd-soc-wm-hubs-objs := wm_hubs.o
>> +snd-soc-jz4740-codec-objs := jz4740-codec.o
>>     
>
> Keep the devices sorted in both Makefile and Kconfig.
>
>   
>> +static int jz4740_codec_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
>> +{
>> +	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
>> +	case SND_SOC_DAIFMT_CBM_CFM:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>>     
>
> This does nothing except validate some parameters.  Is there actually an
> externally visible DAI for this CODEC?  If it's just integrated into the
> SoC and there's nothing to configure then just omit the DAI
> configuration since it's not even useful to document the signal format.
>   
Nope, there is no externally visible DAI for the codec, but internally
it is connected through the i2s controller of the JZ4740 which supports
different operating modes. And if you'll do
"snd_soc_dai_set_fmt(codec_dai, BOARD_DAIFMT);
snd_soc_dai_set_fmt(cpu_dai, BOARD_DAIFMT);" with a wrong dai format it
will be noticed.
>> +	.capture = {
>> +		.stream_name = "Capture",
>> +		.channels_min = 2,
>> +		.channels_max = 2,
>> +		.rates = SNDRV_PCM_RATE_8000_48000,
>> +		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S8,
>>     
>
> You listed an 18 bit format in hw_params - one or other of this and
> hw_params is presumably out of date.
>   
In theory the codec supports 18 bit for playback, but the i2s controller
requires it to be 32 bit aligned, while alsa appears to have only
support for a 24 bit aligned 18 bit format(Correct me if I'm wrong). So
I dropped it, I'll remove the whole format check in hw_params as Liam
suggested.
>> +static int jz4740_codec_set_bias_level(struct snd_soc_codec *codec,
>> +	enum snd_soc_bias_level level)
>> +{
>> +
>> +	if (codec->bias_level == SND_SOC_BIAS_OFF && level != SND_SOC_BIAS_OFF) {
>> +		snd_soc_update_bits(codec, JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_RESET, JZ4740_CODEC_1_RESET);
>> +		udelay(2);
>>     
>
> I'd expect to see this as part of the _OFF in the main switch
> statement.
>   
Uhm, actually this code path is taken when switching from _OFF to
another state. If it is guaranteed that _OFF is always followed by a
certain other state I could put the reset code in its part of the switch
statement.
>   
>> +	switch (level) {
>> +	case SND_SOC_BIAS_ON:
>> +		snd_soc_update_bits(codec, JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_VREF_DISABLE |
>> +			JZ4740_CODEC_1_VREF_AMP_DISABLE |
>> +			JZ4740_CODEC_1_HEADPHONE_POWER_DOWN_M |
>> +			JZ4740_CODEC_1_VREF_LOW_CURRENT |
>> +			JZ4740_CODEC_1_VREF_HIGH_CURRENT,
>> +			0);
>>     
>
> This looks suspiciously like you should be using DAPM for the headphone
> at least, though if there's only headphone out that's possibly not worth
> it.  Also, are you sure that you want both low and high current VREF
> configuring here?  I'm not clear what these settings do but the way
> they're being managed both here and in _PREPARE seems odd.
>   
Hm, I'll take a look.
>   
>> +	codec = &jz4740_codec->codec;
>> +
>> +	codec->dev		= &pdev->dev;
>> +	codec->name		= "jz-codec";
>>     
>
> Seems a bit odd to use the part number in some places and not others.
>   
I renamed the driver from jz-codec to jz4740-codec shortly before
submitting it after I realized that the codec component on other jz47xx
chips is completely different. Seems like I missed the codec name.

Thanks for reviewing the patch
- Lars

