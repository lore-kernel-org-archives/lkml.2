Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2KTF3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:29:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32908 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:10 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 5/7] extcon: max77693: Fix incorrect error check and return value
Date: Tue, 20 Nov 2012 10:52:41 +0530
Message-Id: <1353388963-23761-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_create_mapping() returns 0 if it fails to provide a valid irq number.
'ret' needs to be updated with a negative error code before returning from
probe to signal probe failure. While at it, also corrected the 'virq' type to
unsigned from signed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index a17d0d9..2a0f397 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -686,11 +686,13 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	/* Support irq domain for MAX77693 MUIC device */
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
 		struct max77693_muic_irq *muic_irq = &muic_irqs[i];
-		int virq = 0;
+		unsigned int virq = 0;
 
 		virq = irq_create_mapping(max77693->irq_domain, muic_irq->irq);
-		if (!virq)
+		if (!virq) {
+			ret = -EINVAL;
 			goto err_irq;
+		}
 		muic_irq->virq = virq;
 
 		ret = request_threaded_irq(virq, NULL,
@@ -702,8 +704,6 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 				" error :%d)\n",
 				muic_irq->irq, ret);
 
-			for (i = i - 1; i >= 0; i--)
-				free_irq(muic_irq->virq, info);
 			goto err_irq;
 		}
 	}
@@ -768,6 +768,8 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 err_extcon:
 	kfree(info->edev);
 err_irq:
+	while (--i >= 0)
+		free_irq(muic_irqs[i].virq, info);
 err_regmap:
 	kfree(info);
 err_kfree:
-- 
1.7.4.1

