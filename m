Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2B2Xvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:51:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36774 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577Ab2B2Xvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:51:52 -0500
Date: Wed, 29 Feb 2012 23:51:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120229235147.GM8295@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrXiCraHbXeog9mY"
Content-Disposition: inline
In-Reply-To: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nrXiCraHbXeog9mY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 23, 2012 at 02:46:49PM +0900, Tomoya MORINAGA wrote:

> +	SOC_SINGLE_TLV("Playback Limitter Min Input Volume",
> +			ML26124_PL_MAXMIN_GAIN, 0, 7, 0, mingain),

Limiter.

> +	SOC_SINGLE("Zero Cross Comparator Switch", ML26124_PW_ZCCMP_PW_MNG, 1,
> +		    1, 0),

Usually just "ZC Switch".

> +	SOC_SINGLE("Digital Switch", ML26124_DVOL_CTL, 4, 1, 0),

This should probably be Digital Playback Switch so it lines up with the
volume control in the UIs (and the Volume controls should be Digital X
Volume).

> +static int ml26124_update_bits(struct snd_soc_codec *codec, unsigned short reg,
> +				unsigned int mask, unsigned int value)

Why are you open coding this in your driver?  There is no point in
replicating subsystem functionality.

> +if (!priv)
> +	return -1;
> +

Coding style and return real error codes (though this looks like it
should never happen).

> +static int ml26124_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
> +				  int div_id, int div)
> +{
> +	struct snd_soc_codec *codec = codec_dai->codec;
> +
> +	switch (div_id) {
> +	case ML26124_MCLK:
> +		ml26124_update_bits(codec, ML26124_CLK_CTL,
> +				      BIT(0) | BIT(1), div);
> +		break;

Why can't the driver calculate this automatically given the MCLK?

> +	case SND_SOC_BIAS_ON:
> +		pr_debug("%s: level=ON priv=%p\n", __func__, priv);

There's already more than enough logging in the subsystem for this.

> +		/* VMID ON */
> +		ml26124_update_bits(codec, ML26124_PW_REF_PW_MNG,
> +				    ML26124_VMID, ML26124_VMID);
> +		msleep(500);

This looks like it should be _STANDBY - usually VMID must be on to power
everything else.

> +static int ml26124_pcm_trigger(struct snd_pcm_substream *substream,
> +			      int cmd, struct snd_soc_dai *codec_dai)
> +{
> +	struct snd_soc_codec *codec = codec_dai->codec;
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_STOP:
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +		ml26124_update_bits(codec, ML26124_REC_PLYBAK_RUN, 0x3,
> +				    0);

I'm not sure you've tested this, you can't do I2C I/O from atomic
context and trigger is atomic.  What does this control actually do?

> +		return 0;
> +		break;

Duplicate return and break here.

> +static int ml26124_resume(struct snd_soc_codec *codec)
> +{
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +
> +	regcache_sync(priv->regmap);
> +	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);

Setting the bias level will duplicate the sync.

> +static int ml26124_probe(struct snd_soc_codec *codec)
> +{
> +	int ret;
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +	codec->control_data = priv->regmap;
> +
> +	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);
> +	if (ret < 0) {
> +		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> +		return ret;
> +	}

You're mixing regmap API usage and ASoC level I2C, this should be
_REGMAP.

> +/* power down chip */
> +static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {

This comment is misplaced.

> +static struct i2c_driver ml26124_i2c_driver = {
> +	.driver = {
> +		.name = "ml26124-codec",

No -codec, the device only does one thing.

> +static int __init ml26124_modinit(void)
> +{
> +	int ret;
> +
> +	ret = i2c_add_driver(&ml26124_i2c_driver);
> +	if (ret != 0)

module_i2c_driver().

--nrXiCraHbXeog9mY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTroNAAoJEBus8iNuMP3dAHIP/jSeCNB0RBqGItgXtjrGJ7W/
oVdRvpOQj8/mfLvXXbS/ThzJDob+N8FAUmuB3RgljO2YdO28EygsbhYIu85z4lRF
A03SXkZGM5GVrP3mVYw2uw10U2R750mrVuyg+Z6f6kqYzM6nXYW7aBo21mXWscEa
2CCTxP6mR8FaxMwClh1iNsWNzizvjEJmYzbi2Yn2Eur7mwGWOLYCYIH9CDXlM+cT
zGXVkucvNIkHZcbQWNDkx3IZvDBtx/gQaTDlUxyrK4m9v5F6hTDhtp/8SOu3fq7f
VNNL+5fH6FZyRR6h0pwwPPYl+4QKOWQgYqdIc7CUnfoP+NintHuQmTlva9hkDXS8
IH6O7r8FJpRXngWJYSpLCKWPhnBaCCH7qzn5yGXyp8IxcQFQvGQlfUV4/uP3TCPJ
b03K/J9je82W4m9G+l5e8xGV7TqflCaPF3mRF+Iz56lA5GKzkosn1qPxp9CQZrfk
wj6lKxpcKnYfEapi3QpEmtcx6/yMa6N6WRxRib54DEASwmIFnx6HC4lmAFfyxLfO
8g4QGXT8TBAMIH2C6tl4aIDTY+oig1Fi2RaelbGCFKrj3lJaZvXO+la9JE+bED4k
pNCClsDKCkYNusoP7osnLz2SXeiB6Gn493iqlTH5sq5LGTxmESSmDz7RbfZD0Iam
TUB4mcloBlWHM913m8P1
=vEDs
-----END PGP SIGNATURE-----

--nrXiCraHbXeog9mY--
