Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2KHNmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:42:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65516 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KHNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:42:17 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] Input: spear-keyboard: Add clk_{un}prepare() support
Date: Thu,  8 Nov 2012 19:10:48 +0530
Message-Id: <27d9eea3815593df228c85958096bc14d7985e7e.1352381962.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
In-Reply-To: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

clk_{un}prepare is mandatory for platforms using common clock framework. Because
for SPEAr we don't do anything in clk_{un}prepare() calls, just call them ones
in probe/remove.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/input/keyboard/spear-keyboard.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 1d24fb2..9792924 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -245,6 +245,10 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
 		goto err_free_mem;
 	}
 
+	error = clk_prepare(kbd->clk);
+	if (error)
+		goto err_free_mem;
+
 	input_dev->name = "Spear Keyboard";
 	input_dev->phys = "keyboard/input0";
 	input_dev->dev.parent = &pdev->dev;
@@ -259,7 +263,7 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
 					   kbd->keycodes, input_dev);
 	if (error) {
 		dev_err(&pdev->dev, "Failed to build keymap\n");
-		goto err_free_mem;
+		goto err_unprepare_clk;
 	}
 
 	if (kbd->rep)
@@ -272,13 +276,13 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
 			"keyboard", kbd);
 	if (error) {
 		dev_err(&pdev->dev, "request_irq fail\n");
-		goto err_free_mem;
+		goto err_unprepare_clk;
 	}
 
 	error = input_register_device(input_dev);
 	if (error) {
 		dev_err(&pdev->dev, "Unable to register keyboard device\n");
-		goto err_free_mem;
+		goto err_unprepare_clk;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -286,6 +290,8 @@ static int __devinit spear_kbd_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_unprepare_clk:
+	clk_unprepare(kbd->clk);
 err_free_mem:
 	input_free_device(input_dev);
 
@@ -297,6 +303,7 @@ static int __devexit spear_kbd_remove(struct platform_device *pdev)
 	struct spear_kbd *kbd = platform_get_drvdata(pdev);
 
 	input_unregister_device(kbd->input);
+	clk_unprepare(kbd->clk);
 
 	device_init_wakeup(&pdev->dev, 0);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.12.rc2.18.g61b472e

