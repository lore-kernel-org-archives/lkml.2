Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0KYHHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:07:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54826 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KYHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OiogYbJhY43uEmd1O2xlrTqKIwma9Cf3oEyP1AP67euXy72H1pENcmPcwS5hXTZ8KX
         QqqurZGYkgytmkRNt2Ig11zVADCxYGyGuVUPeq73a9XS0SpICS2pU6YnrDe1BfmFByjN
         6KtN5Ph73T+w7Ics64KIdIEBLW8fJ5GltZzqc=
Subject: [PATCH 7/8] ASoC: imx-ssi: fix resource leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:13:09 +0800
Message-Id: <1290669189.30158.20.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix imx_ssi_probe() error path and imx_ssi_remove() to properly free
allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/imx/imx-ssi.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/soc/imx/imx-ssi.c b/sound/soc/imx/imx-ssi.c
index ad21f81..30894ea 100644
--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -679,8 +679,11 @@ static int imx_ssi_probe(struct platform_device *pdev)
 	}
 
 	ssi->soc_platform_pdev_fiq = platform_device_alloc("imx-fiq-pcm-audio", pdev->id);
-	if (!ssi->soc_platform_pdev_fiq)
+	if (!ssi->soc_platform_pdev_fiq) {
+		ret = -ENOMEM;
 		goto failed_pdev_fiq_alloc;
+	}
+
 	platform_set_drvdata(ssi->soc_platform_pdev_fiq, ssi);
 	ret = platform_device_add(ssi->soc_platform_pdev_fiq);
 	if (ret) {
@@ -689,8 +692,11 @@ static int imx_ssi_probe(struct platform_device *pdev)
 	}
 
 	ssi->soc_platform_pdev = platform_device_alloc("imx-pcm-audio", pdev->id);
-	if (!ssi->soc_platform_pdev)
+	if (!ssi->soc_platform_pdev) {
+		ret = -ENOMEM;
 		goto failed_pdev_alloc;
+	}
+
 	platform_set_drvdata(ssi->soc_platform_pdev, ssi);
 	ret = platform_device_add(ssi->soc_platform_pdev);
 	if (ret) {
@@ -703,6 +709,7 @@ static int imx_ssi_probe(struct platform_device *pdev)
 failed_pdev_add:
 	platform_device_put(ssi->soc_platform_pdev);
 failed_pdev_alloc:
+	platform_device_del(ssi->soc_platform_pdev_fiq);
 failed_pdev_fiq_add:
 	platform_device_put(ssi->soc_platform_pdev_fiq);
 failed_pdev_fiq_alloc:
@@ -726,8 +733,8 @@ static int __devexit imx_ssi_remove(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct imx_ssi *ssi = platform_get_drvdata(pdev);
 
-	platform_device_del(ssi->soc_platform_pdev);
-	platform_device_put(ssi->soc_platform_pdev);
+	platform_device_unregister(ssi->soc_platform_pdev);
+	platform_device_unregister(ssi->soc_platform_pdev_fiq);
 
 	snd_soc_unregister_dai(&pdev->dev);
 
-- 
1.7.2



