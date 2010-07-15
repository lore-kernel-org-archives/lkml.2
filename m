Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab0GOIyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:54:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47142 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab0GOIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:54:43 -0400
Subject: Re: [PATCH 7/12] wm8940: fix resource reclaim in wm8940_register 
 error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: axel.lin@gmail.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <AANLkTil_buBStfVy_L9iTgPrxosmSRFhNU1MbaXWJfMx@mail.gmail.com>
References: <1279162147.29294.2.camel@mola> <1279162893.29294.20.camel@mola>
	 <Pine.LNX.4.64.1007150855200.5310@axis700.grange>
	 <AANLkTil_buBStfVy_L9iTgPrxosmSRFhNU1MbaXWJfMx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 09:54:37 +0100
Message-ID: <1279184077.3072.21.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 15:42 +0800, Axel Lin wrote:

> 
> I agree that it is good to release resources at the same level,
> where they have been acquired.
> But I prefer to follow the maintainer/author's coding style.
> 
> For the changes in other drivers, I'd like to see Liam and Mark's comments.
> Or if the driver maintainers request it, I can fix it.

Fwiw, the soon to be merged ASoC multi-component branch simplifies the
codec probe() and remove() as follows (e.g. from I2C and SPI WM8750
codec) :-

static int wm8750_probe(struct snd_soc_codec *codec)
{
	struct wm8750_priv *wm8750 = snd_soc_codec_get_drvdata(codec);
	int reg, ret;

	codec->control_data = wm8750->control_data;
	ret = snd_soc_codec_set_cache_io(codec, 7, 9, wm8750->control_type);
	if (ret < 0) {
		printk(KERN_ERR "wm8750: failed to set cache I/O: %d\n", ret);
		return ret;
	}

	ret = wm8750_reset(codec);
	if (ret < 0) {
		printk(KERN_ERR "wm8750: failed to reset: %d\n", ret);
		return ret;
	}

	/* charge output caps */
	wm8750_set_bias_level(codec, SND_SOC_BIAS_STANDBY);



	snd_soc_add_controls(codec, wm8750_snd_controls,
				ARRAY_SIZE(wm8750_snd_controls));
	wm8750_add_widgets(codec);
	return ret;
}

static int wm8750_remove(struct snd_soc_codec *codec)
{
	wm8750_set_bias_level(codec, SND_SOC_BIAS_OFF);
	return 0;
}


#if defined(CONFIG_SPI_MASTER)
static int __devinit wm8750_spi_probe(struct spi_device *spi)
{
	struct wm8750_priv *wm8750;
	int ret;

	wm8750 = kzalloc(sizeof(struct wm8750_priv), GFP_KERNEL);
	if (wm8750 == NULL)
		return -ENOMEM;

	wm8750->control_data = spi;
	wm8750->control_type = SND_SOC_SPI;
	spi_set_drvdata(spi, wm8750);

	ret = snd_soc_register_codec(&spi->dev, spi->chip_select,
			&soc_codec_dev_wm8750, &wm8750_dai, 1);
	if (ret < 0)
		kfree(wm8750);
	return ret;
}

static int __devexit wm8750_spi_remove(struct spi_device *spi)
{
	snd_soc_unregister_codec(&spi->dev, spi->chip_select);
	kfree(spi_get_drvdata(spi));
	return 0;
}

static struct spi_driver wm8750_spi_driver = {
	.driver = {
		.name	= "wm8750 SPI Codec",
		.bus	= &spi_bus_type,
		.owner	= THIS_MODULE,
	},
	.probe		= wm8750_spi_probe,
	.remove		= __devexit_p(wm8750_spi_remove),
};
#endif /* CONFIG_SPI_MASTER */

#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
static __devinit int wm8750_i2c_probe(struct i2c_client *i2c,
				      const struct i2c_device_id *id)
{
	struct wm8750_priv *wm8750;
	int ret;

	wm8750 = kzalloc(sizeof(struct wm8750_priv), GFP_KERNEL);
	if (wm8750 == NULL)
		return -ENOMEM;

	i2c_set_clientdata(i2c, wm8750);
	wm8750->control_data = i2c;
	wm8750->control_type = SND_SOC_I2C;

	ret =  snd_soc_register_codec(&i2c->dev, i2c->addr,
			&soc_codec_dev_wm8750, &wm8750_dai, 1);
	if (ret < 0)
		kfree(wm8750);
	return ret;
}

static __devexit int wm8750_i2c_remove(struct i2c_client *client)
{
	snd_soc_unregister_codec(&client->dev, client->addr);
	kfree(i2c_get_clientdata(client));
	return 0;
}

static const struct i2c_device_id wm8750_i2c_id[] = {
	{ "wm8750", 0 },
	{ "wm8987", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, wm8750_i2c_id);

static struct i2c_driver wm8750_i2c_driver = {
	.driver = {
		.name = "wm8750 I2C Codec",
		.owner = THIS_MODULE,
	},
	.probe =    wm8750_i2c_probe,
	.remove =   __devexit_p(wm8750_i2c_remove),
	.id_table = wm8750_i2c_id,
};
#endif

static int __init wm8750_modinit(void)
{
	int ret = 0;
#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
	ret = i2c_add_driver(&wm8750_i2c_driver);
	if (ret != 0) {
		printk(KERN_ERR "Failed to register wm8750 I2C driver: %d\n",
		       ret);
	}
#endif
#if defined(CONFIG_SPI_MASTER)
	ret = spi_register_driver(&wm8750_spi_driver);
	if (ret != 0) {
		printk(KERN_ERR "Failed to register wm8750 SPI driver: %d\n",
		       ret);
	}
#endif
	return ret;
}
module_init(wm8750_modinit);

static void __exit wm8750_exit(void)
{
#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
	i2c_del_driver(&wm8750_i2c_driver);
#endif
#if defined(CONFIG_SPI_MASTER)
	spi_unregister_driver(&wm8750_spi_driver);
#endif
}
module_exit(wm8750_exit);


So while this patch series is useful (from a minor bug fix pov), it will
be overwritten shortly in the ASoC multi-component merge. Probably
delaying the multi-component merge too (since the changes are in the
same place).

Can we hold off this series for a week or two. I have one more update
for multi-component and if we don't have multi-component upstreamed in
that time frame we can apply this series.

Thanks

Liam 
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

