Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2HEXHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:07:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HEXHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:07:39 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
Date: Sun,  5 Aug 2012 16:03:34 -0700
Message-Id: <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120805230238.GA1663@lizard>
References: <20120805230238.GA1663@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver uses platform-specific mxc_set_irq_fiq() with the VIRQ cookie
passed to it, so it's pretty clear that the driver is absolutely sure
that the FIQ is routed via platform-specific IC, and that the cookie can
be used to mask/unmask FIQs. So, let's switch to the genirq routines,
since we're about to remove FIQ-specific variants.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 sound/soc/fsl/imx-pcm-fiq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
index ee27ba3..993e37d 100644
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
1.7.10.4

