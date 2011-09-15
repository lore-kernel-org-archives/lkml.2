Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1IOChH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:37:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56029 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IOChF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:37:05 -0400
Subject: [PATCH v2] ASoC: samsung: Fix checking return value of clk_get
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Pellegrin <chripell@evolware.org>, Ben Dooks <ben@simtec.co.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 10:36:54 +0800
Message-ID: <1316054214.3496.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a pointer to the struct clk or an ERR_PTR().
This patch also use PTR_ERR() for return value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Christian Pellegrin <chripell@evolware.org>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
---
v2: Also use PTR_ERR() for return value.

 sound/soc/samsung/s3c2412-i2s.c     |    4 ++--
 sound/soc/samsung/s3c24xx-i2s.c     |    4 ++--
 sound/soc/samsung/s3c24xx_uda134x.c |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index 841ab14..7ab8e2c 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -69,10 +69,10 @@ static int s3c2412_i2s_probe(struct snd_soc_dai *dai)
 	s3c2412_i2s.dma_playback = &s3c2412_i2s_pcm_stereo_out;
 
 	s3c2412_i2s.iis_cclk = clk_get(dai->dev, "i2sclk");
-	if (s3c2412_i2s.iis_cclk == NULL) {
+	if (IS_ERR(s3c2412_i2s.iis_cclk)) {
 		pr_err("failed to get i2sclk clock\n");
 		iounmap(s3c2412_i2s.regs);
-		return -ENODEV;
+		return PTR_ERR(s3c2412_i2s.iis_cclk);
 	}
 
 	/* Set MPLL as the source for IIS CLK */
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index 63d8849..21c92e2 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -383,10 +383,10 @@ static int s3c24xx_i2s_probe(struct snd_soc_dai *dai)
 		return -ENXIO;
 
 	s3c24xx_i2s.iis_clk = clk_get(dai->dev, "iis");
-	if (s3c24xx_i2s.iis_clk == NULL) {
+	if (IS_ERR(s3c24xx_i2s.iis_clk)) {
 		pr_err("failed to get iis_clock\n");
 		iounmap(s3c24xx_i2s.regs);
-		return -ENODEV;
+		return PTR_ERR(s3c24xx_i2s.iis_clk);
 	}
 	clk_enable(s3c24xx_i2s.iis_clk);
 
diff --git a/sound/soc/samsung/s3c24xx_uda134x.c b/sound/soc/samsung/s3c24xx_uda134x.c
index dc9d551..65c1cfd 100644
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -66,17 +66,17 @@ static int s3c24xx_uda134x_startup(struct snd_pcm_substream *substream)
 	pr_debug("%s %d\n", __func__, clk_users);
 	if (clk_users == 0) {
 		xtal = clk_get(&s3c24xx_uda134x_snd_device->dev, "xtal");
-		if (!xtal) {
+		if (IS_ERR(xtal)) {
 			printk(KERN_ERR "%s cannot get xtal\n", __func__);
-			ret = -EBUSY;
+			ret = PTR_ERR(xtal);
 		} else {
 			pclk = clk_get(&s3c24xx_uda134x_snd_device->dev,
 				       "pclk");
-			if (!pclk) {
+			if (IS_ERR(pclk)) {
 				printk(KERN_ERR "%s cannot get pclk\n",
 				       __func__);
 				clk_put(xtal);
-				ret = -EBUSY;
+				ret = PTR_ERR(pclk);
 			}
 		}
 		if (!ret) {
-- 
1.7.4.1



