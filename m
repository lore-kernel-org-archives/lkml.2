Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2GYJfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:35:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39840 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2GYJfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:35:21 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] Input: omap4-keypad: Fix the probe error handling
Date: Wed, 25 Jul 2012 15:05:16 +0530
Message-ID: <1343208916-19149-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- pm_runtime_disable call is missed in some of the error cases
  fix the same.
- In the error path pm_runtime_put_sync is called after pm_runtime_disable
 fix the same.
- keypad_data->keymap free was missed in one of the error path fix it.

Also while at it call pm_runtime_put_sync after the register access in probe
instead of waiting for input registration etc.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c05f98c..17efede 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -310,6 +310,7 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		goto err_unmap;
 	}
 	rev = __raw_readl(keypad_data->base + OMAP4_KBD_REVISION);
+	pm_runtime_put_sync(&pdev->dev);
 	rev &= 0x03 << 30;
 	rev >>= 30;
 	switch (rev) {
@@ -325,14 +326,14 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Keypad reports unsupported revision %d", rev);
 		error = -EINVAL;
-		goto err_pm_put_sync;
+		goto err_unmap;
 	}
 
 	/* input device allocation */
 	keypad_data->input = input_dev = input_allocate_device();
 	if (!input_dev) {
 		error = -ENOMEM;
-		goto err_pm_put_sync;
+		goto err_unmap;
 	}
 
 	input_dev->name = pdev->name;
@@ -374,30 +375,27 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 			     "omap4-keypad", keypad_data);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register interrupt\n");
-		goto err_free_input;
+		goto err_free_keymap;
 	}
 
-	pm_runtime_put_sync(&pdev->dev);
 
 	error = input_register_device(keypad_data->input);
 	if (error < 0) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto err_pm_disable;
+		goto err_free_irq;
 	}
 
 	platform_set_drvdata(pdev, keypad_data);
 	return 0;
 
-err_pm_disable:
-	pm_runtime_disable(&pdev->dev);
+err_free_irq:
 	free_irq(keypad_data->irq, keypad_data);
 err_free_keymap:
 	kfree(keypad_data->keymap);
 err_free_input:
 	input_free_device(input_dev);
-err_pm_put_sync:
-	pm_runtime_put_sync(&pdev->dev);
 err_unmap:
+	pm_runtime_disable(&pdev->dev);
 	iounmap(keypad_data->base);
 err_release_mem:
 	release_mem_region(res->start, resource_size(res));
-- 
1.7.5.4

