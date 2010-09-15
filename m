Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0IOCLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:11:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60941 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0IOCLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:11:36 -0400
Date: Wed, 15 Sep 2010 12:11:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the sound-asoc tree with the genesis
 tree
Message-Id: <20100915121128.d8fbc4bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
drivers/video/sh_mobile_hdmi.c between commit
6de9edd5bde0cdfea12e9948690e53ec669c3018 ("fbdev: sh_mobile_hdmi:
implement locking") from the genesis tree and commits
1d6be338c11ddc1e58915ab85e19b0f6cbc10782 ("ASoC: Add sh_mobile_hdmi sound
support") and ec4e5ccd4b8be576f9cd8bfc3cb8651565ed87ef ("fbdev:
sh_mobile_hdmi: add new label for sound error path") from the sound-asoc
tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/sh_mobile_hdmi.c
index 4d6ab86,ef989d9..0000000
--- a/drivers/video/sh_mobile_hdmi.c
+++ b/drivers/video/sh_mobile_hdmi.c
@@@ -227,8 -224,60 +229,60 @@@ static u8 hdmi_read(struct sh_hdmi *hdm
  	return ioread8(hdmi->base + reg);
  }
  
+ /*
+  *	HDMI sound
+  */
+ static unsigned int sh_hdmi_snd_read(struct snd_soc_codec *codec,
+ 				     unsigned int reg)
+ {
+ 	struct sh_hdmi *hdmi = snd_soc_codec_get_drvdata(codec);
+ 
+ 	return hdmi_read(hdmi, reg);
+ }
+ 
+ static int sh_hdmi_snd_write(struct snd_soc_codec *codec,
+ 			     unsigned int reg,
+ 			     unsigned int value)
+ {
+ 	struct sh_hdmi *hdmi = snd_soc_codec_get_drvdata(codec);
+ 
+ 	hdmi_write(hdmi, value, reg);
+ 	return 0;
+ }
+ 
+ static struct snd_soc_dai_driver sh_hdmi_dai = {
+ 	.name = "sh_mobile_hdmi-hifi",
+ 	.playback = {
+ 		.stream_name = "Playback",
+ 		.channels_min = 2,
+ 		.channels_max = 8,
+ 		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100  |
+ 			 SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200  |
+ 			 SNDRV_PCM_RATE_96000 | SNDRV_PCM_RATE_176400 |
+ 			 SNDRV_PCM_RATE_192000,
+ 		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+ 	},
+ };
+ 
+ static int sh_hdmi_snd_probe(struct snd_soc_codec *codec)
+ {
+ 	dev_info(codec->dev, "SH Mobile HDMI Audio Codec");
+ 
+ 	return 0;
+ }
+ 
+ static struct snd_soc_codec_driver soc_codec_dev_sh_hdmi = {
+ 	.probe		= sh_hdmi_snd_probe,
+ 	.read		= sh_hdmi_snd_read,
+ 	.write		= sh_hdmi_snd_write,
+ };
+ 
+ /*
+  *	HDMI video
+  */
+ 
  /* External video parameter settings */
 -static void hdmi_external_video_param(struct sh_hdmi *hdmi)
 +static void sh_hdmi_external_video_param(struct sh_hdmi *hdmi)
  {
  	struct fb_var_screeninfo *var = &hdmi->var;
  	u16 htotal, hblank, hdelay, vtotal, vblank, vdelay, voffset;
@@@ -1041,7 -964,11 +1114,12 @@@ static int __init sh_hdmi_probe(struct 
  		return -ENOMEM;
  	}
  
+ 	ret =  snd_soc_register_codec(&pdev->dev,
+ 			&soc_codec_dev_sh_hdmi, &sh_hdmi_dai, 1);
+ 	if (ret < 0)
+ 		goto esndreg;
+ 
 +	mutex_init(&hdmi->mutex);
  	hdmi->dev = &pdev->dev;
  
  	hdmi->hdmi_clk = clk_get(&pdev->dev, "ick");
@@@ -1109,7 -1053,9 +1187,9 @@@ ereqreg
  erate:
  	clk_put(hdmi->hdmi_clk);
  egetclk:
 +	mutex_destroy(&hdmi->mutex);
+ 	snd_soc_unregister_codec(&pdev->dev);
+ esndreg:
  	kfree(hdmi);
  
  	return ret;
@@@ -1120,19 -1066,17 +1200,21 @@@ static int __exit sh_hdmi_remove(struc
  	struct sh_mobile_hdmi_info *pdata = pdev->dev.platform_data;
  	struct sh_hdmi *hdmi = platform_get_drvdata(pdev);
  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 +	struct sh_mobile_lcdc_board_cfg	*board_cfg = &pdata->lcd_chan->board_cfg;
  	int irq = platform_get_irq(pdev, 0);
  
+ 	snd_soc_unregister_codec(&pdev->dev);
+ 
 -	pdata->lcd_chan->board_cfg.display_on = NULL;
 -	pdata->lcd_chan->board_cfg.display_off = NULL;
 -	pdata->lcd_chan->board_cfg.board_data = NULL;
 +	board_cfg->display_on = NULL;
 +	board_cfg->display_off = NULL;
 +	board_cfg->board_data = NULL;
 +	board_cfg->owner = NULL;
  
 +	/* No new work will be scheduled, wait for running ISR */
  	free_irq(irq, hdmi);
 -	pm_runtime_disable(&pdev->dev);
 +	/* Wait for already scheduled work */
  	cancel_delayed_work_sync(&hdmi->edid_work);
 +	pm_runtime_disable(&pdev->dev);
  	clk_disable(hdmi->hdmi_clk);
  	clk_put(hdmi->hdmi_clk);
  	iounmap(hdmi->base);
