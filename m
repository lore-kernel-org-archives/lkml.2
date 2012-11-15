Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab2KOEyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:54:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab2KOEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:54:34 -0500
Message-ID: <1352955266.6793.4.camel@phoenix>
Subject: [PATCH 3/4] pinctrl: at91: Prevent NULL dereference if
 of_match_device returns NULL
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Nov 2012 12:54:26 +0800
In-Reply-To: <1352955096.6793.1.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_match_device() may return NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-at91.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 8490a55..32006c8 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -829,13 +829,18 @@ static int __devinit at91_pinctrl_probe_dt(struct platform_device *pdev,
 	uint32_t *tmp;
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *child;
+	const struct of_device_id *match;
 
 	if (!np)
 		return -ENODEV;
 
+	match = of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
+	if (!match)
+		return -ENODEV;
+
 	info->dev = &pdev->dev;
-	info->ops = (struct at91_pinctrl_mux_ops*)
-		of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
+	info->ops = (struct at91_pinctrl_mux_ops *) match->data;
+
 	at91_pinctrl_child_count(info, np);
 
 	if (info->nbanks < 1) {
@@ -1359,6 +1364,7 @@ static struct of_device_id at91_gpio_of_match[] __devinitdata = {
 static int __devinit at91_gpio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
 	struct resource *res;
 	struct at91_gpio_chip *at91_chip = NULL;
 	struct gpio_chip *chip;
@@ -1399,8 +1405,11 @@ static int __devinit at91_gpio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	at91_chip->ops = (struct at91_pinctrl_mux_ops*)
-		of_match_device(at91_gpio_of_match, &pdev->dev)->data;
+	match = of_match_device(at91_gpio_of_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
+
+	at91_chip->ops = (struct at91_pinctrl_mux_ops *) match->data;
 	at91_chip->pioc_virq = irq;
 	at91_chip->pioc_idx = alias_idx;
 
-- 
1.7.9.5



