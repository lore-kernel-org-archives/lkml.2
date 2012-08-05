Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2HEXHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:07:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39721 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HEXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:07:06 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 3/9] [media] mx1_camera: Don't use {en,dis}able_fiq() calls
Date: Sun,  5 Aug 2012 16:03:33 -0700
Message-Id: <1344207819-3415-3-git-send-email-anton.vorontsov@linaro.org>
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
 drivers/media/video/mx1_camera.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index d2e6f82..1536d09 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -801,7 +801,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	set_fiq_regs(&regs);
 
 	mxc_set_irq_fiq(irq, 1);
-	enable_fiq(irq);
+	enable_irq(irq);
 
 	pcdev->soc_host.drv_name	= DRIVER_NAME;
 	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
@@ -817,7 +817,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_irq:
-	disable_fiq(irq);
+	disable_irq(irq);
 	mxc_set_irq_fiq(irq, 0);
 	release_fiq(&fh);
 exit_free_dma:
@@ -842,7 +842,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	imx_dma_free(pcdev->dma_chan);
-	disable_fiq(pcdev->irq);
+	disable_irq(pcdev->irq);
 	mxc_set_irq_fiq(pcdev->irq, 0);
 	release_fiq(&fh);
 
-- 
1.7.10.4

