Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0ILS51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0ILS5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lzJ+8smqKSOFvlSUnxaWt5hjigChiskcmTgqMZFcPev1fDhNOV9LlC3ChI0zNpn28+
         SFT2BATejLvjK3A34ysWDZJbhnTIEuY/ew/FF+y6Jl+9rhx9R3K3ZW72HRb+91UXMn3j
         QTVVBdUfT8Hc0q75SVUCHhXfS7/rYrnKWPtnY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: stmpe: fix error path
Date: Sun, 12 Sep 2010 22:57:19 +0400
Message-Id: <1284317840-5131-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free allocated memory.  Call stmpe_disable() if it was enabled.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.
 Maybe It needs better error path.

 drivers/gpio/stmpe-gpio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index 65b9960..6e28afa 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -317,11 +317,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 
 	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	ret = stmpe_gpio_irq_init(stmpe_gpio);
 	if (ret)
-		goto out_free;
+		goto out_disable;
 
 	ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
 				   "stmpe-gpio", stmpe_gpio);
@@ -347,6 +347,8 @@ out_freeirq:
 	free_irq(irq, stmpe_gpio);
 out_removeirq:
 	stmpe_gpio_irq_remove(stmpe_gpio);
+out_disable:
+	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 out_free:
 	kfree(stmpe_gpio);
 	return ret;
-- 
1.7.0.4

