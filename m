Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2IRIYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:24:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IRIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:24:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] unicore32: pwm: Remove unnecessary indirection
Date: Tue, 18 Sep 2012 10:23:51 +0200
Message-Id: <1347956633-15667-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:9n4HPYXXNfPmfHe9/WICfqPfqqnEEftgeWpgzKEEuJu
 0ScDow8K7+s8WXvlis7jtBxdtgcgItUBHLdW/+lPC47iHWSt+H
 ccK/aroyjAYo0pMZa7CYjUV5e5UaFq0X3icMBGBjEn3UL8gGdS
 Oub7GXurJguqrkKa3lATACnR2oL0h0BsaKcwBom5vrJtapMZ5U
 FVCYl42kTq15wXUIflDDXvyQlmWUpA71eexZl+wfUzPIpzfb3T
 MwRg0YZo3XB7mhZmHEgLJX1l/EUVrevTri1J+79lxejxzKrYky
 A9sCj9CvYkzhaUnxmbRaALH8utubrgXdGFaaM9UPq/zz27in/2
 8L0E38wEXXygsgFBPxFaAKuTUUDNE7QhwmSjeeOi9URvjI+ayM
 53PT0J6k73ljQXyH0QPBpzXTNyA7jSNNHT6CODj1FYO0s3KmyS
 HbIKt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling the actual probing function through a proxy isn't required and
makes the code needlessly complex.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/unicore32/kernel/pwm.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
index 012c54a..7e23470 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -156,8 +156,7 @@ static inline void __add_pwm(struct pwm_device *pwm)
 	mutex_unlock(&pwm_lock);
 }
 
-static struct pwm_device *pwm_probe(struct platform_device *pdev,
-		unsigned int pwm_id, struct pwm_device *parent_pwm)
+static int __devinit pwm_probe(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
 	struct resource *r;
@@ -166,7 +165,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	pwm->clk = clk_get(NULL, "OST_CLK");
@@ -177,7 +176,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 	pwm->clk_enabled = 0;
 
 	pwm->use_count = 0;
-	pwm->pwm_id = pwm_id;
+	pwm->pwm_id = pdev->id;
 	pwm->pdev = pdev;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -203,7 +202,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 
 	__add_pwm(pwm);
 	platform_set_drvdata(pdev, pwm);
-	return pwm;
+	return 0;
 
 err_release_mem:
 	release_mem_region(r->start, resource_size(r));
@@ -211,17 +210,7 @@ err_free_clk:
 	clk_put(pwm->clk);
 err_free:
 	kfree(pwm);
-	return ERR_PTR(ret);
-}
-
-static int __devinit puv3_pwm_probe(struct platform_device *pdev)
-{
-	struct pwm_device *pwm = pwm_probe(pdev, pdev->id, NULL);
-
-	if (IS_ERR(pwm))
-		return PTR_ERR(pwm);
-
-	return 0;
+	return ret;
 }
 
 static int __devexit pwm_remove(struct platform_device *pdev)
@@ -251,7 +240,7 @@ static struct platform_driver puv3_pwm_driver = {
 	.driver		= {
 		.name	= "PKUnity-v3-PWM",
 	},
-	.probe		= puv3_pwm_probe,
+	.probe		= pwm_probe,
 	.remove		= __devexit_p(pwm_remove),
 };
 module_platform_driver(puv3_pwm_driver);
-- 
1.7.12

