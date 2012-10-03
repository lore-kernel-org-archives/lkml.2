Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2JCCYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:24:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2JCCYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:24:09 -0400
Message-ID: <1349231038.6191.1.camel@phoenix>
Subject: [PATCH] extcon: max77693: Fix max77693_muic_probe error handling
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 03 Oct 2012 10:23:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below issues:
1. If request_threaded_irq() fails, current code does not free all requested
   irqs.
2. Add missing extcon_dev_unregister() in error path if failed to read revision
   number.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/extcon/extcon-max77693.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index e0ed622..9928c63 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -696,12 +696,8 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 				IRQF_ONESHOT, muic_irq->name, info);
 		if (ret) {
 			dev_err(&pdev->dev,
-				"failed: irq request (IRQ: %d,"
-				" error :%d)\n",
+				"failed: irq request (IRQ: %d, error :%d)\n",
 				muic_irq->irq, ret);
-
-			for (i = i - 1; i >= 0; i--)
-				free_irq(muic_irq->virq, info);
 			goto err_irq;
 		}
 	}
@@ -726,7 +722,7 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		goto err_read_reg;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -738,9 +734,13 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 
 	return ret;
 
+err_read_reg:
+	extcon_dev_unregister(info->edev);
 err_extcon:
 	kfree(info->edev);
 err_irq:
+	while (--i >= 0)
+		free_irq(muic_irqs[i].virq, info);
 err_regmap:
 	kfree(info);
 err_kfree:
-- 
1.7.9.5



