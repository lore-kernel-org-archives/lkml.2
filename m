Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1KMTP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 14:15:26 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37298 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1KMTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 14:15:25 -0500
Subject: [PATCH] ASoC: davinci: drop SFFSDR_FPGA and CONFIG_SFFSDR_FPGA
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 20:15:14 +0100
Message-ID: <1321211714.20271.85.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 08bd168696 ("ASoC: Add driver for the Lyrtech SFFSDR board")
added a reference to a Kconfig symbol SFFSDR_FPGA. Commit ac37373b64
("ASoC: DaVinci: Fix SFFSDR compilation error.") added a macro
CONFIG_SFFSDR_FPGA. But there's no Kconfig symbol SFFSDR_FPGA and no
define of CONFIG_SFFSDR_FPGA. So the select of SFFSDR_FPGA is a nop. It
can be dropped. The checks for CONFIG_SFFSDR_FPGA can also be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested, as this needs (build, etc.) testing if we want to be
thorough. But I do not have the hardware and neither do I have the
needed toolchain at hand.

1) Note that there's no file named *plat-sffsdr/sffsdr-fpga.h in the
tree. Neither is there a function or a macro named
sffsdr_fpga_set_codec_fs. So defining CONFIG_SFFSDR_FPGA will never
work.

 sound/soc/davinci/Kconfig          |    1 -
 sound/soc/davinci/davinci-sffsdr.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index 9e11a14..6a91206 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -59,7 +59,6 @@ config SND_DAVINCI_SOC_SFFSDR
 	depends on SND_DAVINCI_SOC && MACH_SFFSDR
 	select SND_DAVINCI_SOC_I2S
 	select SND_SOC_PCM3008
-	select SFFSDR_FPGA
 	help
 	  Say Y if you want to add support for SoC audio on
 	  Lyrtech SFFSDR board.
diff --git a/sound/soc/davinci/davinci-sffsdr.c b/sound/soc/davinci/davinci-sffsdr.c
index 0fe558c..d650c2d 100644
--- a/sound/soc/davinci/davinci-sffsdr.c
+++ b/sound/soc/davinci/davinci-sffsdr.c
@@ -24,9 +24,6 @@
 
 #include <asm/dma.h>
 #include <asm/mach-types.h>
-#ifdef CONFIG_SFFSDR_FPGA
-#include <asm/plat-sffsdr/sffsdr-fpga.h>
-#endif
 
 #include <mach/edma.h>
 
@@ -53,13 +50,11 @@ static int sffsdr_hw_params(struct snd_pcm_substream *substream,
 	/* Fsref can be 32000, 44100 or 48000. */
 	fs = params_rate(params);
 
-#ifndef CONFIG_SFFSDR_FPGA
 	/* Without the FPGA module, the Fs is fixed at 44100 Hz */
 	if (fs != 44100) {
 		pr_debug("warning: only 44.1 kHz is supported without SFFSDR FPGA module\n");
 		return -EINVAL;
 	}
-#endif
 
 	/* set cpu DAI configuration */
 	ret = snd_soc_dai_set_fmt(cpu_dai, AUDIO_FORMAT);
@@ -68,11 +63,7 @@ static int sffsdr_hw_params(struct snd_pcm_substream *substream,
 
 	pr_debug("sffsdr_hw_params: rate = %d Hz\n", fs);
 
-#ifndef CONFIG_SFFSDR_FPGA
 	return 0;
-#else
-	return sffsdr_fpga_set_codec_fs(fs);
-#endif
 }
 
 static struct snd_soc_ops sffsdr_ops = {
-- 
1.7.4.4

