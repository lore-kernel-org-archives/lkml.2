Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab2JSKxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:53:53 -0400
Received: from mail.df.lth.se ([194.47.250.12]:21803 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2JSKxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:53:52 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4 v2] gpio/tc3589x: convert to use the simple irqdomain
Date: Fri, 19 Oct 2012 12:53:45 +0200
Message-Id: <1350644025-31517-1-git-send-email-linus.walleij@linaro.org>
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
ChangeLog v1->v2: add a comment that explains what is going on,
  it fooled me so it could fool somebody else too.
---
 drivers/gpio/gpio-tc3589x.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index 1e48317..8c8447c 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -292,17 +292,15 @@ static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio,
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
+	/*
+	 * If this results in a linear domain, irq_create_mapping() will
+	 * take care of allocating IRQ descriptors at runtime. When a base
+	 * is provided, the IRQ descriptors will be allocated when the
+	 * domain is instantiated.
+	 */
+	tc3589x_gpio->domain = irq_domain_add_simple(np,
+			tc3589x_gpio->chip.ngpio, base, &tc3589x_irq_ops,
+			tc3589x_gpio);
 	if (!tc3589x_gpio->domain) {
 		dev_err(tc3589x_gpio->dev, "Failed to create irqdomain\n");
 		return -ENOSYS;
-- 
1.7.11.7

