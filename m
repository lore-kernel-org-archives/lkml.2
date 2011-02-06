Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1BFXDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:03:17 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1071 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753851Ab1BFXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:03:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 15254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/7] ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI registration
Date: Mon,  7 Feb 2011 00:04:22 +0100
Message-Id: <1297033463-14577-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two issues with the bluethooth DAI registration:
* The DAI has to be registered only after the sound device has been added.

* Currently the DAI is registered with snd_soc_register_dai which causes it to
  be named after the device it was registered for. Which is in this case the
  "soc-audio" device. (Ab)use snd_soc_register_dais which causes the DAI to be
  named after the DAI driver, which is what we want in this case.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/samsung/neo1973_gta02_wm8753.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index 62d2f39..a82779b 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -391,32 +391,31 @@ static int __init neo1973_gta02_init(void)
 	if (!neo1973_gta02_snd_device)
 		return -ENOMEM;
 
-	/* register bluetooth DAI here */
-	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
-	if (ret)
-		goto err_put_device;
-
 	platform_set_drvdata(neo1973_gta02_snd_device, &neo1973_gta02);
 	ret = platform_device_add(neo1973_gta02_snd_device);
+	if (ret) {
+		platform_device_del(neo1973_gta02_snd_device);
+		return ret;
+	}
 
+	/* register bluetooth DAI here */
+	ret = snd_soc_register_dais(&neo1973_gta02_snd_device->dev, &bt_dai, 1);
 	if (ret)
-		goto err_unregister_dai;
+		goto err_unregister_device;
 
 	ret = gpio_request_array(neo1973_gta02_gpios,
 				ARRAY_SIZE(neo1973_gta02_gpios));
 	if (ret) {
 		pr_err("gta02_wm8753: Failed to request gpio\n");
-		goto err_del_device;
+		goto err_unregister_dai;
 	}
 
 	return 0;
 
-err_del_device:
-	platform_device_del(neo1973_gta02_snd_device);
 err_unregister_dai:
 	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
-err_put_device:
-	platform_device_put(neo1973_gta02_snd_device);
+err_unregister_device:
+	platform_device_unregister(neo1973_gta02_snd_device);
 	return ret;
 }
 module_init(neo1973_gta02_init);
@@ -424,7 +423,7 @@ module_init(neo1973_gta02_init);
 static void __exit neo1973_gta02_exit(void)
 {
 	gpio_free_array(neo1973_gta02_gpios, ARRAY_SIZE(neo1973_gta02_gpios));
-	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
+	snd_soc_unregister_dais(&neo1973_gta02_snd_device->dev);
 	platform_device_unregister(neo1973_gta02_snd_device);
 }
 module_exit(neo1973_gta02_exit);
-- 
1.7.2.3

