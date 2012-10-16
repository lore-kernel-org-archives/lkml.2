Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2JPT2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:28:12 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44877 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab2JPT2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:28:07 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/7] gpio/tc3589x: convert to use the simple irqdomain
Date: Tue, 16 Oct 2012 21:22:10 +0200
Message-Id: <1350415330-2673-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The special checks for whether we have a base IRQ offset or not
is surplus if we use the simple IRQ domain. The IRQ offset
zero will be interpreted as a linear domain case.

Plus this makes sure we allocate descriptors where need be, or
warn if they are preallocated with SPARSE_IRQ.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-tc3589x.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index 1e48317..8e7290e 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -292,17 +292,9 @@ static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio,
 {
 	int base = tc3589x_gpio->irq_base;
 
-	if (base) {
-		tc3589x_gpio->domain = irq_domain_add_legacy(
-			NULL, tc3589x_gpio->chip.ngpio, base,
-			0, &tc3589x_irq_ops, tc3589x_gpio);
-	}
-	else {
-		tc3589x_gpio->domain = irq_domain_add_linear(
-			np, tc3589x_gpio->chip.ngpio,
-			&tc3589x_irq_ops, tc3589x_gpio);
-	}
-
+	tc3589x_gpio->domain = irq_domain_add_simple(np,
+			tc3589x_gpio->chip.ngpio, base, &tc3589x_irq_ops,
+			tc3589x_gpio);
 	if (!tc3589x_gpio->domain) {
 		dev_err(tc3589x_gpio->dev, "Failed to create irqdomain\n");
 		return -ENOSYS;
-- 
1.7.11.7

