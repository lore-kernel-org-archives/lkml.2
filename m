Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2KWJM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:12:27 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64205 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab2KWJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:12:21 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v2] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Date: Fri, 23 Nov 2012 10:12:13 +0100
Message-Id: <1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20121123081307.GA4529@opensource.wolfsonmicro.com>
References: <20121123081307.GA4529@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a broken make rule, sound/soc/fsl/imx-pcm-dma.c or
sound/soc/fsl/imx-pcm-fiq.c (whatever is selected via Kconfig) will
not be compiled into imx-pcm.o when building as module, i.e.:
CONFIG_SND_SOC_IMX_PCM=m
CONFIG_SND_SOC_IMX_PCM_DMA=m
resulting in a non-functional sound driver.

This gives the error messages:
| imx-sgtl5000 sound.1: platform imx-pcm-audio not registered
| imx-sgtl5000 sound.1: snd_soc_register_card failed (-517)
| platform sound.1: Driver imx-sgtl5000 requests probe deferral
when loading the driver instead of what's to be expected:
| imx-sgtl5000 sound.1:  sgtl5000 <-> 63fcc000.ssi mapping ok

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/fsl/Makefile |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index 515ba66..afd3479 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -30,14 +30,18 @@ obj-$(CONFIG_SND_MPC52xx_SOC_EFIKA) += efika-audio-fabric.o
 # i.MX Platform Support
 snd-soc-imx-ssi-objs := imx-ssi.o
 snd-soc-imx-audmux-objs := imx-audmux.o
+snd-soc-imx-pcm-objs := imx-pcm.o
+ifneq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),)
+	snd-soc-imx-pcm-objs += imx-pcm-fiq.o
+endif
+ifneq ($(CONFIG_SND_SOC_IMX_PCM_DMA),)
+	snd-soc-imx-pcm-objs += imx-pcm-dma.o
+endif
 
 obj-$(CONFIG_SND_SOC_IMX_SSI) += snd-soc-imx-ssi.o
 obj-$(CONFIG_SND_SOC_IMX_AUDMUX) += snd-soc-imx-audmux.o
 
 obj-$(CONFIG_SND_SOC_IMX_PCM) += snd-soc-imx-pcm.o
-snd-soc-imx-pcm-y := imx-pcm.o
-snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_FIQ) += imx-pcm-fiq.o
-snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_DMA) += imx-pcm-dma.o
 
 # i.MX Machine Support
 snd-soc-eukrea-tlv320-objs := eukrea-tlv320.o
-- 
1.7.2.5

