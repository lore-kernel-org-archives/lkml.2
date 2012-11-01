Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584Ab2KAOUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:20:38 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:48634 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761540Ab2KAOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:20:34 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/2] Input: nomadik-ske-keypad - start using the apb_pclk
Date: Thu, 1 Nov 2012 15:20:02 +0100
Message-ID: <1351779602-13818-3-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Previously this clock was handled internally by the clockdriver,
but now this is separate clk. So we need take care of it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/input/keyboard/nomadik-ske-keypad.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 95dcc9b..a1a9375 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -67,6 +67,7 @@ struct ske_keypad {
 	const struct ske_keypad_platform_data *board;
 	unsigned short keymap[SKE_KPD_NUM_ROWS * SKE_KPD_NUM_COLS];
 	struct clk *clk;
+	struct clk *pclk;
 	spinlock_t ske_keypad_lock;
 };
 
@@ -271,11 +272,18 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 		goto err_free_mem_region;
 	}
 
+	keypad->pclk = clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(keypad->pclk)) {
+		dev_err(&pdev->dev, "failed to get pclk\n");
+		error = PTR_ERR(keypad->pclk);
+		goto err_iounmap;
+	}
+
 	keypad->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(keypad->clk)) {
 		dev_err(&pdev->dev, "failed to get clk\n");
 		error = PTR_ERR(keypad->clk);
-		goto err_iounmap;
+		goto err_pclk;
 	}
 
 	input->id.bustype = BUS_HOST;
@@ -294,10 +302,16 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	if (!plat->no_autorepeat)
 		__set_bit(EV_REP, input->evbit);
 
+	error = clk_prepare_enable(keypad->pclk);
+	if (error) {
+		dev_err(&pdev->dev, "Failed to prepare/enable pclk\n");
+		goto err_clk;
+	}
+
 	error = clk_prepare_enable(keypad->clk);
 	if (error) {
 		dev_err(&pdev->dev, "Failed to prepare/enable clk\n");
-		goto err_clk;
+		goto err_pclk_disable;
 	}
 
 
@@ -336,8 +350,12 @@ err_free_irq:
 	free_irq(keypad->irq, keypad);
 err_clk_disable:
 	clk_disable_unprepare(keypad->clk);
+err_pclk_disable:
+	clk_disable_unprepare(keypad->pclk);
 err_clk:
 	clk_put(keypad->clk);
+err_pclk:
+	clk_put(keypad->pclk);
 err_iounmap:
 	iounmap(keypad->reg_base);
 err_free_mem_region:
-- 
1.7.10

