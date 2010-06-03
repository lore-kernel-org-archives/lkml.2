Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0FCQ7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:59:06 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49340 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab0FCQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:59:02 -0400
Message-ID: <4C07DF34.7030401@metafoo.de>
Date: Thu, 03 Jun 2010 18:58:28 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [RFC][PATCH 20/26] alsa: ASoC: Add JZ4740 codec
 driver
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>         <1275505950-17334-4-git-send-email-lars@metafoo.de> <1275568334.3593.92.camel@odin>
In-Reply-To: <1275568334.3593.92.camel@odin>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Wed, 2010-06-02 at 21:12 +0200, Lars-Peter Clausen wrote:
>   
>> This patch adds support for the JZ4740 internal codec.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>> Cc: alsa-devel@alsa-project.org
>> ---
>>  sound/soc/codecs/Kconfig        |    4 +
>>  sound/soc/codecs/Makefile       |    2 +
>>  sound/soc/codecs/jz4740-codec.c |  502 +++++++++++++++++++++++++++++++++++++++
>>  sound/soc/codecs/jz4740-codec.h |   20 ++
>>  4 files changed, 528 insertions(+), 0 deletions(-)
>>  create mode 100644 sound/soc/codecs/jz4740-codec.c
>>  create mode 100644 sound/soc/codecs/jz4740-codec.h
>>     
>
> no need for code in file name here.
>
>   
>> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
>> index 31ac553..b8008df 100644
>> --- a/sound/soc/codecs/Kconfig
>> +++ b/sound/soc/codecs/Kconfig
>> @@ -23,6 +23,7 @@ config SND_SOC_ALL_CODECS
>>  	select SND_SOC_AK4671 if I2C
>>  	select SND_SOC_CQ0093VC if MFD_DAVINCI_VOICECODEC
>>  	select SND_SOC_CS4270 if I2C
>> +	select SND_SOC_JZ4740 if SOC_JZ4740
>>  	select SND_SOC_MAX9877 if I2C
>>  	select SND_SOC_DA7210 if I2C
>>  	select SND_SOC_PCM3008
>> @@ -269,6 +270,9 @@ config SND_SOC_WM9712
>>  config SND_SOC_WM9713
>>  	tristate
>>  
>> +config SND_SOC_JZ4740_CODEC
>> +	tristate
>> +
>>  # Amp
>>  config SND_SOC_MAX9877
>>  	tristate
>> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
>> index 91429ea..4c7ee31 100644
>> --- a/sound/soc/codecs/Makefile
>> +++ b/sound/soc/codecs/Makefile
>> @@ -56,6 +56,7 @@ snd-soc-wm9705-objs := wm9705.o
>>  snd-soc-wm9712-objs := wm9712.o
>>  snd-soc-wm9713-objs := wm9713.o
>>  snd-soc-wm-hubs-objs := wm_hubs.o
>> +snd-soc-jz4740-codec-objs := jz4740-codec.o
>>  
>>     
>
> Please use the same format here
>
>   
>>  # Amp
>>  snd-soc-max9877-objs := max9877.o
>> @@ -121,6 +122,7 @@ obj-$(CONFIG_SND_SOC_WM9705)	+= snd-soc-wm9705.o
>>  obj-$(CONFIG_SND_SOC_WM9712)	+= snd-soc-wm9712.o
>>  obj-$(CONFIG_SND_SOC_WM9713)	+= snd-soc-wm9713.o
>>  obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
>> +obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
>>  
>>     
>
> ditto.
>   
Ok, I agree, but the Kconfig symbol should keep the "CODEC" in it,
otherwise it would clash with the JZ4740 ASoC platform support.
>   
>>  # Amp
>>  obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
>> diff --git a/sound/soc/codecs/jz4740-codec.c b/sound/soc/codecs/jz4740-codec.c
>> new file mode 100644
>> index 0000000..6e4b741
>> --- /dev/null
>> +++ b/sound/soc/codecs/jz4740-codec.c
>> @@ -0,0 +1,502 @@
>> + [...]
>> +static const struct snd_kcontrol_new jz4740_codec_controls[] = {
>> +	SOC_SINGLE("Master Playback Volume", JZ4740_REG_CODEC_2,
>> +			JZ4740_CODEC_2_HEADPHONE_VOLUME_OFFSET, 3, 0),
>> +	SOC_SINGLE("Capture Volume", JZ4740_REG_CODEC_2,
>> +			JZ4740_CODEC_2_INPUT_VOLUME_OFFSET, 31, 0),
>>     
>
> Is this the master capture volume ?
>   
Hm, yes.
>   
>> +	SOC_SINGLE("Master Playback Switch", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_HEADPHONE_DISABLE_OFFSET, 1, 1),
>> +	SOC_SINGLE("Mic Capture Volume", JZ4740_REG_CODEC_2,
>> +			JZ4740_CODEC_2_MIC_BOOST_GAIN_OFFSET, 3, 0),
>> +};
>> +
>> +static const struct snd_kcontrol_new jz4740_codec_output_controls[] = {
>> +	SOC_DAPM_SINGLE("Bypass Switch", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_SW1_ENABLE_OFFSET, 1, 0),
>> +	SOC_DAPM_SINGLE("DAC Switch", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_SW2_ENABLE_OFFSET, 1, 0),
>> +};
>> +
>> +static const struct snd_kcontrol_new jz4740_codec_input_controls[] = {
>> +	SOC_DAPM_SINGLE("Line Capture Switch", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_LINE_ENABLE_OFFSET, 1, 0),
>> +	SOC_DAPM_SINGLE("Mic Capture Switch", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_MIC_ENABLE_OFFSET, 1, 0),
>> +};
>> +
>> +static const struct snd_soc_dapm_widget jz4740_codec_dapm_widgets[] = {
>> +	SND_SOC_DAPM_ADC("ADC", "Capture", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_ADC_ENABLE_OFFSET, 0),
>> +	SND_SOC_DAPM_DAC("DAC", "Playback", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_DAC_ENABLE_OFFSET, 0),
>> +
>> +	SND_SOC_DAPM_MIXER("Output Mixer", JZ4740_REG_CODEC_1,
>> +			JZ4740_CODEC_1_HEADPHONE_POWER_DOWN_OFFSET, 1,
>> +			jz4740_codec_output_controls,
>> +			ARRAY_SIZE(jz4740_codec_output_controls)),
>> +
>> +	SND_SOC_DAPM_MIXER_NAMED_CTL("Input Mixer", SND_SOC_NOPM, 0, 0,
>> +			jz4740_codec_input_controls,
>> +			ARRAY_SIZE(jz4740_codec_input_controls)),
>> +	SND_SOC_DAPM_MIXER("Line Input", SND_SOC_NOPM, 0, 0, NULL, 0),
>> +
>> +	SND_SOC_DAPM_OUTPUT("LOUT"),
>> +	SND_SOC_DAPM_OUTPUT("ROUT"),
>> +
>> +	SND_SOC_DAPM_INPUT("MIC"),
>> +	SND_SOC_DAPM_INPUT("LIN"),
>> +	SND_SOC_DAPM_INPUT("RIN"),
>> +};
>> +
>> +static const struct snd_soc_dapm_route jz4740_codec_dapm_routes[] = {
>> +
>> +	{"Line Input", NULL, "LIN"},
>> +	{"Line Input", NULL, "RIN"},
>> +
>> +	{"Input Mixer", "Line Capture Switch", "Line Input"},
>> +	{"Input Mixer", "Mic Capture Switch", "MIC"},
>> +
>> +	{"ADC", NULL, "Input Mixer"},
>> +
>> +	{"Output Mixer", "Bypass Switch", "Input Mixer"},
>> +	{"Output Mixer", "DAC Switch", "DAC"},
>> +
>> +	{"LOUT", NULL, "Output Mixer"},
>> +	{"ROUT", NULL, "Output Mixer"},
>> +};
>> +
>> +static int jz4740_codec_hw_params(struct snd_pcm_substream *substream,
>> +	struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
>> +{
>> +	uint32_t val;
>> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
>> +	struct snd_soc_device *socdev = rtd->socdev;
>> +	struct snd_soc_codec *codec = socdev->card->codec;
>> +
>> +	switch (params_format(params)) {
>> +	case SNDRV_PCM_FORMAT_S8:
>> +	case SNDRV_PCM_FORMAT_S16_LE:
>> +	case SNDRV_PCM_FORMAT_S18_3LE:
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +		break;
>> +	}
>>     
>
> The PCM format check is not required here as core checks this.
>   
Ok.
>> + [...]
>
> Thanks
>
> Liam
>   

Thanks for reviewing
- Lars
