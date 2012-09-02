Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2IBKV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:21:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab2IBKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:21:21 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] unicore32: pwm: Remove unnecessary indirection
Date: Sun,  2 Sep 2012 12:21:10 +0200
Message-Id: <1346581273-7041-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:PZTbRrnBjgrJvnC22IwZ3YYh2OpVGgvMCx3gsHG+qdF
 DQ0PpXO+fsSnEe30zzU+D9K1XINOuT65r4HsosVEFMwa2Yuld6
 +Fl5Ha47CJAFX0Z/NFj+P9qNbaDp+nLFywXAvL7ep6m8uTR84X
 +iTOy4tXnBEErQTjBpTVJ9NA+ONl72nyx4WiPerXs9WImFHpHN
 py22bn81cE2NL9YPNOA/mF14TwGUS78gaV/lZBwyy1Sz+5dKfS
 zq+ol+/64rqw3+VTzQpMx2HTNqd+/BKTg3dsZuokC1FL6YFSVu
 6WQiwjwfjSVFFt70v+l58Byh21TgjLwCHybqibbiXFDA5dZf14
 ab/MDOY83gArTmAqshHbWY2LFxPxj/b6ZcYbkpgAovk5Cf1iGt
 Szl5WpQ6C5KYJbO4Eqtffm1RhnEXMdz2uk5mcCPDxzg3uCkRG5
 RscPO
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
index 22a7098..d0cdfc0 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -160,8 +160,7 @@ static inline void __add_pwm(struct pwm_device *pwm)
 	mutex_unlock(&pwm_lock);
 }
 
-static struct pwm_device *pwm_probe(struct platform_device *pdev,
-		unsigned int pwm_id, struct pwm_device *parent_pwm)
+static int __devinit pwm_probe(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
 	struct resource *r;
@@ -170,7 +169,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	pwm->clk = clk_get(NULL, "OST_CLK");
@@ -181,7 +180,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 	pwm->clk_enabled = 0;
 
 	pwm->use_count = 0;
-	pwm->pwm_id = pwm_id;
+	pwm->pwm_id = pdev->id;
 	pwm->pdev = pdev;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -207,7 +206,7 @@ static struct pwm_device *pwm_probe(struct platform_device *pdev,
 
 	__add_pwm(pwm);
 	platform_set_drvdata(pdev, pwm);
-	return pwm;
+	return 0;
 
 err_release_mem:
 	release_mem_region(r->start, resource_size(r));
@@ -215,17 +214,7 @@ err_free_clk:
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
@@ -255,7 +244,7 @@ static struct platform_driver puv3_pwm_driver = {
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

