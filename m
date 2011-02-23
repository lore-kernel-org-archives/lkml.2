Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1BWEe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49850 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1BWEeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:25 -0500
Subject: [RFC PATCH 09/15] dt/sound: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:21 -0700
Message-ID: <20110223043421.20795.32153.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/sound.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 sound/soc/fsl/fsl_dma.c          |    9 ++++-----
 sound/soc/fsl/fsl_ssi.c          |    9 ++++-----
 sound/soc/fsl/mpc5200_dma.c      |   24 +++++++++++-------------
 sound/soc/fsl/mpc5200_psc_ac97.c |    9 ++++-----
 sound/soc/fsl/mpc5200_psc_i2s.c  |    9 ++++-----
 sound/sparc/amd7930.c            |    8 ++++----
 sound/sparc/cs4231.c             |   16 ++++++++--------
 sound/sparc/dbri.c               |    8 ++++----
 8 files changed, 43 insertions(+), 49 deletions(-)

diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 4cf98c0..15dac0f 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -896,8 +896,7 @@ static struct snd_pcm_ops fsl_dma_ops = {
 	.pointer	= fsl_dma_pointer,
 };
 
-static int __devinit fsl_soc_dma_probe(struct platform_device *pdev,
-				       const struct of_device_id *match)
+static int __devinit fsl_soc_dma_probe(struct platform_device *pdev)
  {
 	struct dma_object *dma;
 	struct device_node *np = pdev->dev.of_node;
@@ -979,7 +978,7 @@ static const struct of_device_id fsl_soc_dma_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, fsl_soc_dma_ids);
 
-static struct of_platform_driver fsl_soc_dma_driver = {
+static struct platform_driver fsl_soc_dma_driver = {
 	.driver = {
 		.name = "fsl-pcm-audio",
 		.owner = THIS_MODULE,
@@ -993,12 +992,12 @@ static int __init fsl_soc_dma_init(void)
 {
 	pr_info("Freescale Elo DMA ASoC PCM Driver\n");
 
-	return of_register_platform_driver(&fsl_soc_dma_driver);
+	return platform_driver_register(&fsl_soc_dma_driver);
 }
 
 static void __exit fsl_soc_dma_exit(void)
 {
-	of_unregister_platform_driver(&fsl_soc_dma_driver);
+	platform_driver_unregister(&fsl_soc_dma_driver);
 }
 
 module_init(fsl_soc_dma_init);
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 4cc167a..313e0cc 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -624,8 +624,7 @@ static void make_lowercase(char *s)
 	}
 }
 
-static int __devinit fsl_ssi_probe(struct platform_device *pdev,
-				   const struct of_device_id *match)
+static int __devinit fsl_ssi_probe(struct platform_device *pdev)
 {
 	struct fsl_ssi_private *ssi_private;
 	int ret = 0;
@@ -774,7 +773,7 @@ static const struct of_device_id fsl_ssi_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, fsl_ssi_ids);
 
-static struct of_platform_driver fsl_ssi_driver = {
+static struct platform_driver fsl_ssi_driver = {
 	.driver = {
 		.name = "fsl-ssi-dai",
 		.owner = THIS_MODULE,
@@ -788,12 +787,12 @@ static int __init fsl_ssi_init(void)
 {
 	printk(KERN_INFO "Freescale Synchronous Serial Interface (SSI) ASoC Driver\n");
 
-	return of_register_platform_driver(&fsl_ssi_driver);
+	return platform_driver_register(&fsl_ssi_driver);
 }
 
 static void __exit fsl_ssi_exit(void)
 {
-	of_unregister_platform_driver(&fsl_ssi_driver);
+	platform_driver_unregister(&fsl_ssi_driver);
 }
 
 module_init(fsl_ssi_init);
diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index f92dca0..fff695c 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -368,8 +368,7 @@ static struct snd_soc_platform_driver mpc5200_audio_dma_platform = {
 	.pcm_free	= &psc_dma_free,
 };
 
-static int mpc5200_hpcd_probe(struct of_device *op,
-		const struct of_device_id *match)
+static int mpc5200_hpcd_probe(struct of_device *op)
 {
 	phys_addr_t fifo;
 	struct psc_dma *psc_dma;
@@ -511,32 +510,31 @@ static int mpc5200_hpcd_remove(struct of_device *op)
 }
 
 static struct of_device_id mpc5200_hpcd_match[] = {
-	{
-		.compatible = "fsl,mpc5200-pcm",
-	},
+	{ .compatible = "fsl,mpc5200-pcm", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mpc5200_hpcd_match);
 
-static struct of_platform_driver mpc5200_hpcd_of_driver = {
-	.owner		= THIS_MODULE,
-	.name		= "mpc5200-pcm-audio",
-	.match_table    = mpc5200_hpcd_match,
+static struct platform_driver mpc5200_hpcd_of_driver = {
 	.probe		= mpc5200_hpcd_probe,
 	.remove		= mpc5200_hpcd_remove,
+	.dev = {
+		.owner		= THIS_MODULE,
+		.name		= "mpc5200-pcm-audio",
+		.of_match_table    = mpc5200_hpcd_match,
+	}
 };
 
 static int __init mpc5200_hpcd_init(void)
 {
-	return of_register_platform_driver(&mpc5200_hpcd_of_driver);
+	return platform_driver_register(&mpc5200_hpcd_of_driver);
 }
+module_init(mpc5200_hpcd_init);
 
 static void __exit mpc5200_hpcd_exit(void)
 {
-	of_unregister_platform_driver(&mpc5200_hpcd_of_driver);
+	platform_driver_unregister(&mpc5200_hpcd_of_driver);
 }
-
-module_init(mpc5200_hpcd_init);
 module_exit(mpc5200_hpcd_exit);
 
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
diff --git a/sound/soc/fsl/mpc5200_psc_ac97.c b/sound/soc/fsl/mpc5200_psc_ac97.c
index 40acc8e..ad36b09 100644
--- a/sound/soc/fsl/mpc5200_psc_ac97.c
+++ b/sound/soc/fsl/mpc5200_psc_ac97.c
@@ -272,8 +272,7 @@ static struct snd_soc_dai_driver psc_ac97_dai[] = {
  * - Probe/remove operations
  * - OF device match table
  */
-static int __devinit psc_ac97_of_probe(struct platform_device *op,
-				      const struct of_device_id *match)
+static int __devinit psc_ac97_of_probe(struct platform_device *op)
 {
 	int rc;
 	struct snd_ac97 ac97;
@@ -316,7 +315,7 @@ static struct of_device_id psc_ac97_match[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(of, psc_ac97_match);
 
-static struct of_platform_driver psc_ac97_driver = {
+static struct platform_driver psc_ac97_driver = {
 	.probe = psc_ac97_of_probe,
 	.remove = __devexit_p(psc_ac97_of_remove),
 	.driver = {
@@ -332,13 +331,13 @@ static struct of_platform_driver psc_ac97_driver = {
  */
 static int __init psc_ac97_init(void)
 {
-	return of_register_platform_driver(&psc_ac97_driver);
+	return platform_driver_register(&psc_ac97_driver);
 }
 module_init(psc_ac97_init);
 
 static void __exit psc_ac97_exit(void)
 {
-	of_unregister_platform_driver(&psc_ac97_driver);
+	platform_driver_unregister(&psc_ac97_driver);
 }
 module_exit(psc_ac97_exit);
 
diff --git a/sound/soc/fsl/mpc5200_psc_i2s.c b/sound/soc/fsl/mpc5200_psc_i2s.c
index 9018fa5..87cf2a5 100644
--- a/sound/soc/fsl/mpc5200_psc_i2s.c
+++ b/sound/soc/fsl/mpc5200_psc_i2s.c
@@ -150,8 +150,7 @@ static struct snd_soc_dai_driver psc_i2s_dai[] = {{
  * - Probe/remove operations
  * - OF device match table
  */
-static int __devinit psc_i2s_of_probe(struct platform_device *op,
-				      const struct of_device_id *match)
+static int __devinit psc_i2s_of_probe(struct platform_device *op)
 {
 	int rc;
 	struct psc_dma *psc_dma;
@@ -213,7 +212,7 @@ static struct of_device_id psc_i2s_match[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(of, psc_i2s_match);
 
-static struct of_platform_driver psc_i2s_driver = {
+static struct platform_driver psc_i2s_driver = {
 	.probe = psc_i2s_of_probe,
 	.remove = __devexit_p(psc_i2s_of_remove),
 	.driver = {
@@ -229,13 +228,13 @@ static struct of_platform_driver psc_i2s_driver = {
  */
 static int __init psc_i2s_init(void)
 {
-	return of_register_platform_driver(&psc_i2s_driver);
+	return platform_driver_register(&psc_i2s_driver);
 }
 module_init(psc_i2s_init);
 
 static void __exit psc_i2s_exit(void)
 {
-	of_unregister_platform_driver(&psc_i2s_driver);
+	platform_driver_unregister(&psc_i2s_driver);
 }
 module_exit(psc_i2s_exit);
 
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index f8bcfc3..ad7d4d7 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -1002,7 +1002,7 @@ static int __devinit snd_amd7930_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit amd7930_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit amd7930_sbus_probe(struct platform_device *op)
 {
 	struct resource *rp = &op->resource[0];
 	static int dev_num;
@@ -1064,7 +1064,7 @@ static const struct of_device_id amd7930_match[] = {
 	{},
 };
 
-static struct of_platform_driver amd7930_sbus_driver = {
+static struct platform_driver amd7930_sbus_driver = {
 	.driver = {
 		.name = "audio",
 		.owner = THIS_MODULE,
@@ -1075,7 +1075,7 @@ static struct of_platform_driver amd7930_sbus_driver = {
 
 static int __init amd7930_init(void)
 {
-	return of_register_platform_driver(&amd7930_sbus_driver);
+	return platform_driver_register(&amd7930_sbus_driver);
 }
 
 static void __exit amd7930_exit(void)
@@ -1092,7 +1092,7 @@ static void __exit amd7930_exit(void)
 
 	amd7930_list = NULL;
 
-	of_unregister_platform_driver(&amd7930_sbus_driver);
+	platform_driver_unregister(&amd7930_sbus_driver);
 }
 
 module_init(amd7930_init);
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index c276086..0e618f8 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -1856,7 +1856,7 @@ static int __devinit snd_cs4231_sbus_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit cs4231_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit cs4231_sbus_probe(struct platform_device *op)
 {
 	struct resource *rp = &op->resource[0];
 	struct snd_card *card;
@@ -2048,7 +2048,7 @@ static int __devinit snd_cs4231_ebus_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit cs4231_ebus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit cs4231_ebus_probe(struct platform_device *op)
 {
 	struct snd_card *card;
 	int err;
@@ -2072,16 +2072,16 @@ static int __devinit cs4231_ebus_probe(struct platform_device *op, const struct
 }
 #endif
 
-static int __devinit cs4231_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit cs4231_probe(struct platform_device *op)
 {
 #ifdef EBUS_SUPPORT
 	if (!strcmp(op->dev.of_node->parent->name, "ebus"))
-		return cs4231_ebus_probe(op, match);
+		return cs4231_ebus_probe(op);
 #endif
 #ifdef SBUS_SUPPORT
 	if (!strcmp(op->dev.of_node->parent->name, "sbus") ||
 	    !strcmp(op->dev.of_node->parent->name, "sbi"))
-		return cs4231_sbus_probe(op, match);
+		return cs4231_sbus_probe(op);
 #endif
 	return -ENODEV;
 }
@@ -2108,7 +2108,7 @@ static const struct of_device_id cs4231_match[] = {
 
 MODULE_DEVICE_TABLE(of, cs4231_match);
 
-static struct of_platform_driver cs4231_driver = {
+static struct platform_driver cs4231_driver = {
 	.driver = {
 		.name = "audio",
 		.owner = THIS_MODULE,
@@ -2120,12 +2120,12 @@ static struct of_platform_driver cs4231_driver = {
 
 static int __init cs4231_init(void)
 {
-	return of_register_platform_driver(&cs4231_driver);
+	return platform_driver_register(&cs4231_driver);
 }
 
 static void __exit cs4231_exit(void)
 {
-	of_unregister_platform_driver(&cs4231_driver);
+	platform_driver_unregister(&cs4231_driver);
 }
 
 module_init(cs4231_init);
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 39cd5d6..73f9cba 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2592,7 +2592,7 @@ static void snd_dbri_free(struct snd_dbri *dbri)
 				  (void *)dbri->dma, dbri->dma_dvma);
 }
 
-static int __devinit dbri_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit dbri_probe(struct platform_device *op)
 {
 	struct snd_dbri *dbri;
 	struct resource *rp;
@@ -2686,7 +2686,7 @@ static const struct of_device_id dbri_match[] = {
 
 MODULE_DEVICE_TABLE(of, dbri_match);
 
-static struct of_platform_driver dbri_sbus_driver = {
+static struct platform_driver dbri_sbus_driver = {
 	.driver = {
 		.name = "dbri",
 		.owner = THIS_MODULE,
@@ -2699,12 +2699,12 @@ static struct of_platform_driver dbri_sbus_driver = {
 /* Probe for the dbri chip and then attach the driver. */
 static int __init dbri_init(void)
 {
-	return of_register_platform_driver(&dbri_sbus_driver);
+	return platform_driver_register(&dbri_sbus_driver);
 }
 
 static void __exit dbri_exit(void)
 {
-	of_unregister_platform_driver(&dbri_sbus_driver);
+	platform_driver_unregister(&dbri_sbus_driver);
 }
 
 module_init(dbri_init);

