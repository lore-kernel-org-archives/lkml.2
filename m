Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2IRIY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:24:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2IRIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:24:13 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Qin Rui <qinrui@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] unicore32: pwm: Use managed resource allocations
Date: Tue, 18 Sep 2012 10:23:52 +0200
Message-Id: <1347956633-15667-5-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:pwHU16HPcQxMngHQvb4x5vJJW4DMVA+TUsqXTkCYIF0
 pV4YwDohiTzeYAST7RR+3/zp0vbuuRsJfsPqKkCU5z6POXOPIB
 PtO6IiFo7g5EhP1KoeEh/QISVDLPabnu+Lieg4s7QMmln9UNZ0
 CPhQNaxVBZMN26wNxrjHJj8zv26+p9f1xw4PdmZKCvV0yK5xxl
 xqlnLtx/LaexJJWKDZZpoaSx61VYxywvNYy3PbdDa+Bcw5m5fe
 owkSgG6yKDk5QiUcE2mGeyIe8INhqMNQq1voDSkgPu7sg+kJkQ
 iPWQ3Ei/eT1y9K59Eu8wt8lrBAMn5cV916fZyt2N3uOpN7eoW5
 0zb+8EIqg9/T72NBd8fh3+0bMuQ+7Y7PrOFNV3OyW1WqPt+cKZ
 IcF3Sxd6ycqjIaQnikOMgGVZ4WbarGf5j2ieCPZmutm64nf133
 mUWob
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
index 7e23470..724e860 100644
--- a/arch/unicore32/kernel/pwm.c
+++ b/arch/unicore32/kernel/pwm.c
@@ -160,19 +160,17 @@ static int __devinit pwm_probe(struct platform_device *pdev)
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
@@ -182,41 +180,21 @@ static int __devinit pwm_probe(struct platform_device *pdev)
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
@@ -226,13 +204,6 @@ static int __devexit pwm_remove(struct platform_device *pdev)
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

