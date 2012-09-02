Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2IBKWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:22:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2IBKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:21:28 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] unicore32: pwm: Use managed resource allocations
Date: Sun,  2 Sep 2012 12:21:12 +0200
Message-Id: <1346581273-7041-6-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:vXyF3/fm+CdZQ6/ZjURXtvHLJPdblz08XrnQcVjtRbf
 nYkdu1F+VJ9W9rl+lU3RdKYpKEkFh6wpeyw//MJekZJX70lja/
 PDM0+JmP+hdhsw+7EYrVWraGdlgbcmA08LE5hC+oZeWUECY1dr
 UIivP3Tgo7qw+0/6ChOJMl1MdYBFnTDeTPvL6iCGTu4d5Of8xz
 0toPXD+njJzXgq3ngpo7xLZLbm4nmuwN45epuX1f+m1liw8hjE
 TnUQGSukPNx72cilUmNqnDxF4O1gtHkXdjteW20tSJY2MnNEIA
 2bf7pPyG3ATZCgDP+S1ETXMrOZY1BtPzHDDSEysC3h3i4yvpj7
 EFm0p2DpzESLsgIqtlAdzgsazXUU6b59zsXmqcWsHD9CHVOxGs
 XxZIyNRgOSCojC1+KLpsPhJxG96lzmEmDzCHrHowa5ZsFxhdcW
 O8T7X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit uses the managed resource allocation functions to simplify
the cleanup paths on error and removal.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/unicore32/kernel/pwm.c | 47 +++++++++------------------------------------
 1 file changed, 9 insertions(+), 38 deletions(-)

diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
index d0cdfc0..795c1ba 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -164,19 +164,17 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
 	struct resource *r;
-	int ret = 0;
 
-	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	pwm = devm_kzalloc(&pdev->dev, sizeof(struct pwm_device), GFP_KERNEL);
 	if (pwm == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
-	pwm->clk = clk_get(NULL, "OST_CLK");
-	if (IS_ERR(pwm->clk)) {
-		ret = PTR_ERR(pwm->clk);
-		goto err_free;
-	}
+	pwm->clk = devm_clk_get(&pdev->dev, "OST_CLK");
+	if (IS_ERR(pwm->clk))
+		return PTR_ERR(pwm->clk);
+
 	pwm->clk_enabled = 0;
 
 	pwm->use_count = 0;
@@ -186,41 +184,21 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
-		ret = -ENODEV;
-		goto err_free_clk;
-	}
-
-	r = request_mem_region(r->start, resource_size(r), pdev->name);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "failed to request memory resource\n");
-		ret = -EBUSY;
-		goto err_free_clk;
+		return -ENODEV;
 	}
 
-	pwm->base = ioremap_nocache(r->start, resource_size(r));
-	if (pwm->base == NULL) {
-		dev_err(&pdev->dev, "failed to remap memory resource\n");
-		ret = -EADDRNOTAVAIL;
-		goto err_release_mem;
-	}
+	pwm->base = devm_request_and_ioremap(&pdev->dev, r);
+	if (pwm->base == NULL)
+		return -EADDRNOTAVAIL;
 
 	__add_pwm(pwm);
 	platform_set_drvdata(pdev, pwm);
 	return 0;
-
-err_release_mem:
-	release_mem_region(r->start, resource_size(r));
-err_free_clk:
-	clk_put(pwm->clk);
-err_free:
-	kfree(pwm);
-	return ret;
 }
 
 static int __devexit pwm_remove(struct platform_device *pdev)
 {
 	struct pwm_device *pwm;
-	struct resource *r;
 
 	pwm = platform_get_drvdata(pdev);
 	if (pwm == NULL)
@@ -230,13 +208,6 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 	list_del(&pwm->node);
 	mutex_unlock(&pwm_lock);
 
-	iounmap(pwm->base);
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, resource_size(r));
-
-	clk_put(pwm->clk);
-	kfree(pwm);
 	return 0;
 }
 
-- 
1.7.12

