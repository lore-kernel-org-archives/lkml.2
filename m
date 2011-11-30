Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1K3Fsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:48:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60645 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1K3Fs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <1322569736-16782-1-git-send-email-tomoya.rohm@gmail.com>
References: <1322569736-16782-1-git-send-email-tomoya.rohm@gmail.com>
Date: Wed, 30 Nov 2011 14:48:27 +0900
Message-ID: <CANKRQngFHniB=WxFaDL6Q12L6QBMQZ_bNTYdSErNcNzSAZnQwQ@mail.gmail.com>
Subject: Re: [PATCH v4] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark and Peter,

> On Tue, Nov 29, 2011 at 03:38:00PM +0100, Lars-Peter Clausen wrote:>>> Also this doesn't make much sense:>> +     {"Input Mux", "Analog MIC in", "MICBIAS"},>> +     {"Input Mux", "Digital MIC in", "MICBIAS"},
Let me discuss about intercon settings.

Anticipated routes are like below.
 Analog MIC(single ended) -> PGA -> ADC -> SAI
 Analog MIC(differential) -> PGA -> ADC -> SAI
 Digital MIC -> SAI
 SAI -> DAC -> SPOUT
 SAI -> DAC -> LOUT
 LINEIN -> SPOUT

So, I set like below.
Please give us your opinion.

/* ML26124 configuration */
static const DECLARE_TLV_DB_SCALE(digital_tlv, -7150, 50, 0);
static const DECLARE_TLV_DB_SCALE(alclvl, -2250, 150, 0);
static const DECLARE_TLV_DB_SCALE(mingain, -1200, 600, 0);
static const DECLARE_TLV_DB_SCALE(maxgain, -675, 600, 0);
static const DECLARE_TLV_DB_SCALE(boost_vol, -1200, 75, 0);
static const DECLARE_TLV_DB_SCALE(ngth, -7650, 150, 0);

static const char * const ml26124_companding[] = {"16bit PCM", "u-law",
						  "A-law"};
static const struct soc_enum ml26124_adc_companding_enum
	= SOC_ENUM_SINGLE(ML26124_SAI_TRANS_CTL, 6, 3, ml26124_companding);
static const struct soc_enum ml26124_dac_companding_enum
	= SOC_ENUM_SINGLE(ML26124_SAI_RCV_CTL, 6, 3, ml26124_companding);

static const struct snd_kcontrol_new ml26124_snd_controls[] = {
	SOC_SINGLE_TLV("Capture Digital Volume", ML26124_RECORD_DIG_VOL, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("Digital Boost Volume", ML26124_DIGI_BOOST_VOL, 0,
			0x3f, 0, boost_vol),
	SOC_SINGLE_TLV("EQ Band0 Input Volume", ML26124_EQ_GAIN_BRAND0, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("EQ Band1 Input Volume", ML26124_EQ_GAIN_BRAND1, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("EQ Band2 Input Volume", ML26124_EQ_GAIN_BRAND2, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("EQ Band3 Input Volume", ML26124_EQ_GAIN_BRAND3, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("EQ Band4 Input Volume", ML26124_EQ_GAIN_BRAND4, 0,
			0xff, 1, digital_tlv),
	SOC_SINGLE_TLV("ALC Target Level", ML26124_ALC_TARGET_LEV, 0,
			0xf, 1, alclvl),
	SOC_SINGLE_TLV("ALC Min Input Volume", ML26124_ALC_MAXMIN_GAIN, 0,
			7, 0, mingain),
	SOC_SINGLE_TLV("ALC MAX Input Volume", ML26124_ALC_MAXMIN_GAIN, 4,
			7, 1, maxgain),
	SOC_SINGLE_TLV("Playback Limitter Min Input Volume",
			ML26124_PL_MAXMIN_GAIN, 0, 7, 0, mingain),
	SOC_SINGLE_TLV("Playback Limitter Max Input Volume",
			ML26124_PL_MAXMIN_GAIN, 4, 7, 1, maxgain),
	SOC_SINGLE_TLV("Playback Boost Volume", ML26124_PLYBAK_BOST_VOL, 0,
			0x3f, 0, boost_vol),
	SOC_SINGLE("DC High Pass Filter Switch", ML26124_FILTER_EN, 0, 1, 0),
	SOC_SINGLE("NOISE High Pass Filter Switch", ML26124_FILTER_EN, 1, 1, 0),
	SOC_SINGLE("Zero Cross Comparator Switch", ML26124_PW_ZCCMP_PW_MNG, 1,
		    1, 0),
	SOC_SINGLE("EQ BAND0 Switch", ML26124_FILTER_EN, 2, 1, 0),
	SOC_SINGLE("EQ BAND1 Switch", ML26124_FILTER_EN, 3, 1, 0),
	SOC_SINGLE("EQ BAND2 Switch", ML26124_FILTER_EN, 4, 1, 0),
	SOC_SINGLE("EQ BAND3 Switch", ML26124_FILTER_EN, 5, 1, 0),
	SOC_SINGLE("EQ BAND4 Switch", ML26124_FILTER_EN, 6, 1, 0),
	SOC_SINGLE("Play Limitter", ML26124_DVOL_CTL, 0, 1, 0),
	SOC_SINGLE("Capture Limitter", ML26124_DVOL_CTL, 1, 1, 0),
	SOC_SINGLE("Digital Volume Fade Switch", ML26124_DVOL_CTL, 3, 1, 0),
	SOC_SINGLE("Digital Switch", ML26124_DVOL_CTL, 4, 1, 0),
	SOC_ENUM("DAC Companding", ml26124_dac_companding_enum),
	SOC_ENUM("ADC Companding", ml26124_adc_companding_enum),
};

static const struct snd_kcontrol_new ml26124_output_mixer_controls[] = {
	SOC_DAPM_SINGLE("DAC Switch", ML26124_SPK_AMP_OUT, 1, 1, 0),
	SOC_DAPM_SINGLE("Line in", ML26124_SPK_AMP_OUT, 3, 1, 0),
	SOC_DAPM_SINGLE("PGA Switch", ML26124_SPK_AMP_OUT, 5, 1, 0),
};

/* Input mux */
static const char * const ml26124_input_select[] = {"Analog MIC SingleEnded in",
						    "Analog MIC Differential in"
						    "Digital MIC in"};

static const struct soc_enum ml26124_insel_enum =
	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 2, ml26124_input_select);

static const struct snd_kcontrol_new ml26124_input_mux_controls =
	SOC_DAPM_ENUM("Input Select", ml26124_insel_enum);

static const struct snd_kcontrol_new ml26124_line_control =
	SOC_DAPM_SINGLE("Switch", ML26124_PW_LOUT_PW_MNG, 1, 1, 0);

static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
	SND_SOC_DAPM_SUPPLY("MCLK", ML26124_CLK_EN, 0, 0, NULL, 0),
	SND_SOC_DAPM_SUPPLY("PLL", ML26124_CLK_EN, 1, 0, NULL, 0),
	SND_SOC_DAPM_MICBIAS("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0),
	SND_SOC_DAPM_MIXER("Output Mixer", ML26124_PW_SPAMP_PW_MNG, 0, 0,
			   &ml26124_output_mixer_controls[0],
			   ARRAY_SIZE(ml26124_output_mixer_controls)),
	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
	SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0,
			  &ml26124_input_mux_controls),
	SND_SOC_DAPM_SWITCH("Line Out Enable", SND_SOC_NOPM, 0, 0,
			     &ml26124_line_control),
	SND_SOC_DAPM_INPUT("MDIN"),
	SND_SOC_DAPM_INPUT("MIN"),
	SND_SOC_DAPM_INPUT("LIN"),
	SND_SOC_DAPM_OUTPUT("SPOUT"),
	SND_SOC_DAPM_OUTPUT("LOUT"),
};

static const struct snd_soc_dapm_route ml26124_intercon[] = {
	/* Supply */
	{"DAC", NULL, "MCLK"},
	{"ADC", NULL, "MCLK"},
	{"DAC", NULL, "PLL"},
	{"ADC", NULL, "PLL"},

	/* output mixer */
	{"Output Mixer", "PGA Switch", "PGA"},
	{"Output Mixer", "DAC Switch", "DAC"},
	{"Output Mixer", NULL, "Line in"},

	/* outputs */
	{"LOUT", "Line Out Enable", "Output Mixer"},
	{"SPOUT", NULL, "Output Mixer"},

	/* input */
	{"Input Mux", "Analog MIC SingleEnded in", "MIN"},
	{"Input Mux", "Analog MIC Differential in", "MIN"},
	{"Input Mux", "Digital MIC in", "MDIN"},
	{"ADC", "PGA", "Input Mux"},
};
