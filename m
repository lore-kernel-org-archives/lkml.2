Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2KWAxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:53:39 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44645 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab2KWAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:53:36 -0500
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 04/10] ASoC: imx: Don't use {en,dis}able_fiq() calls
Date: Thu, 22 Nov 2012 16:49:57 -0800
Message-Id: <1353631803-4853-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver uses platform-specific mxc_set_irq_fiq() with the VIRQ cookie
passed to it, so it's pretty clear that the driver is absolutely sure
that the FIQ is routed via platform-specific IC, and that the cookie can
be used to mask/unmask FIQs. So, let's switch to the genirq routines,
since we're about to remove FIQ-specific variants.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/fsl/imx-pcm-fiq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
index 22c6130..8f1a4a6 100644
--- a/sound/soc/fsl/imx-pcm-fiq.c
+++ b/sound/soc/fsl/imx-pcm-fiq.c
@@ -139,7 +139,7 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		hrtimer_start(&iprtd->hrt, ns_to_ktime(iprtd->poll_time_ns),
 		      HRTIMER_MODE_REL);
 		if (++fiq_enable == 1)
-			enable_fiq(imx_pcm_fiq);
+			enable_irq(imx_pcm_fiq);
 
 		break;
 
@@ -149,7 +149,7 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		atomic_set(&iprtd->running, 0);
 
 		if (--fiq_enable == 0)
-			disable_fiq(imx_pcm_fiq);
+			disable_irq(imx_pcm_fiq);
 
 		break;
 	default:
-- 
1.8.0

