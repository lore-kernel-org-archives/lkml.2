Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab1DLRho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:37:44 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1145 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1757225Ab1DLRhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:37:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/5] ASoC: JZ4740: qi_lb60: Use gpio_request_array to request and setup gpios
Date: Tue, 12 Apr 2011 19:31:04 +0200
Message-Id: <1302629465-21315-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the qi_lb60 setup code to use gpio_request_array instead of
manually calling gpio_request and gpio_direction_output for each gpio.
Doing so makes the code a bit more compact.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/jz4740/qi_lb60.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/sound/soc/jz4740/qi_lb60.c b/sound/soc/jz4740/qi_lb60.c
index 875abc9..8c4e84b 100644
--- a/sound/soc/jz4740/qi_lb60.c
+++ b/sound/soc/jz4740/qi_lb60.c
@@ -96,6 +96,11 @@ static struct snd_soc_card qi_lb60 = {
 
 static struct platform_device *qi_lb60_snd_device;
 
+static const struct gpio qi_lb60_gpios[] = {
+	{ QI_LB60_SND_GPIO, GPIOF_OUT_INIT_LOW, "SND" },
+	{ QI_LB60_AMP_GPIO, GPIOF_OUT_INIT_LOW, "AMP" },
+};
+
 static int __init qi_lb60_init(void)
 {
 	int ret;
@@ -105,23 +110,12 @@ static int __init qi_lb60_init(void)
 	if (!qi_lb60_snd_device)
 		return -ENOMEM;
 
-	ret = gpio_request(QI_LB60_SND_GPIO, "SND");
+	ret = gpio_request_array(qi_lb60_gpios, ARRAY_SIZE(qi_lb60_gpios));
 	if (ret) {
-		pr_err("qi_lb60 snd: Failed to request SND GPIO(%d): %d\n",
-				QI_LB60_SND_GPIO, ret);
+		pr_err("qi_lb60 snd: Failed to request gpios: %d\n", ret);
 		goto err_device_put;
 	}
 
-	ret = gpio_request(QI_LB60_AMP_GPIO, "AMP");
-	if (ret) {
-		pr_err("qi_lb60 snd: Failed to request AMP GPIO(%d): %d\n",
-				QI_LB60_AMP_GPIO, ret);
-		goto err_gpio_free_snd;
-	}
-
-	gpio_direction_output(QI_LB60_SND_GPIO, 0);
-	gpio_direction_output(QI_LB60_AMP_GPIO, 0);
-
 	platform_set_drvdata(qi_lb60_snd_device, &qi_lb60);
 
 	ret = platform_device_add(qi_lb60_snd_device);
@@ -134,10 +128,8 @@ static int __init qi_lb60_init(void)
 
 err_unset_pdata:
 	platform_set_drvdata(qi_lb60_snd_device, NULL);
-/*err_gpio_free_amp:*/
-	gpio_free(QI_LB60_AMP_GPIO);
-err_gpio_free_snd:
-	gpio_free(QI_LB60_SND_GPIO);
+/*err_gpio_free_array:*/
+	gpio_free_array(qi_lb60_gpios, ARRAY_SIZE(qi_lb60_gpios));
 err_device_put:
 	platform_device_put(qi_lb60_snd_device);
 
@@ -147,9 +139,8 @@ module_init(qi_lb60_init);
 
 static void __exit qi_lb60_exit(void)
 {
-	gpio_free(QI_LB60_AMP_GPIO);
-	gpio_free(QI_LB60_SND_GPIO);
 	platform_device_unregister(qi_lb60_snd_device);
+	gpio_free_array(qi_lb60_gpios, ARRAY_SIZE(qi_lb60_gpios));
 }
 module_exit(qi_lb60_exit);
 
-- 
1.7.2.5

