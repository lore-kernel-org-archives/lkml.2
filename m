Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2LNQVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:21:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37996 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2LNQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Yang QU <yang.qu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/21] gpio: ab8500: Update gpio ab8540 interrupt mapping
Date: Fri, 14 Dec 2012 16:19:37 +0000
Message-Id: <1355501979-1157-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Add some GPIOs used as interrupt on ab8540 and modify the setting
strategy of the interrupt line.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
Reviewed-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
Tested-by: Yang QU <yang.qu@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |   50 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 833d4c2..edc3037 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -98,6 +98,7 @@ enum ab8500_gpio_action {
 struct ab8500_gpio_irq_cluster {
 	int start;
 	int end;
+	int offset;
 };
 
 struct ab8500_gpio {
@@ -155,10 +156,12 @@ static struct ab8500_gpio_irq_cluster ab8505_irq_clusters[] = {
 
 /*
  * For AB8540 Only some GPIOs are interrupt capable:
+ *	GPIO43 to GPIO44
  *	GPIO51 to GPIO54
  */
 static struct ab8500_gpio_irq_cluster ab8540_irq_clusters[] = {
-	{.start = 50,  .end = 53}, /* GPIO numbers start from 1 */
+	{.start = 42,  .end = 43,  .offset = 2}, /* GPIO numbers start from 1 */
+	{.start = 50,  .end = 53},
 };
 
 
@@ -253,7 +256,7 @@ static int ab8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 			return base + offset - cluster->start;
 
 		/* Advance by the number of gpios in this cluster */
-		base += cluster->end - cluster->start + 1;
+		base += cluster->end + cluster->offset - cluster->start + 1;
 	}
 
 	return -EINVAL;
@@ -273,7 +276,12 @@ static unsigned int irq_to_rising(unsigned int irq)
 {
 	struct ab8500_gpio *ab8500_gpio = irq_get_chip_data(irq);
 	int offset = irq - ab8500_gpio->irq_base;
-	int new_irq = offset +  AB8500_INT_GPIO6R
+	int new_irq;
+	if (is_ab8540(ab8500_gpio->parent)) {
+		new_irq = offset * 2 +  AB8540_INT_GPIO43R
+			+ ab8500_gpio->parent->irq_base;
+	} else
+		new_irq = offset +  AB8500_INT_GPIO6R
 			+ ab8500_gpio->parent->irq_base;
 	return new_irq;
 }
@@ -282,8 +290,13 @@ static unsigned int irq_to_falling(unsigned int irq)
 {
 	struct ab8500_gpio *ab8500_gpio = irq_get_chip_data(irq);
 	int offset = irq - ab8500_gpio->irq_base;
-	int new_irq = offset +  AB8500_INT_GPIO6F
-			+  ab8500_gpio->parent->irq_base;
+	int new_irq;
+	if (is_ab8540(ab8500_gpio->parent)) {
+		new_irq = offset * 2 +  AB8540_INT_GPIO43F
+			+ ab8500_gpio->parent->irq_base;
+	} else
+		new_irq = offset +  AB8500_INT_GPIO6F
+			+ ab8500_gpio->parent->irq_base;
 	return new_irq;
 
 }
@@ -291,20 +304,33 @@ static unsigned int irq_to_falling(unsigned int irq)
 static unsigned int rising_to_irq(unsigned int irq, void *dev)
 {
 	struct ab8500_gpio *ab8500_gpio = dev;
-	int offset = irq - AB8500_INT_GPIO6R
-			- ab8500_gpio->parent->irq_base ;
-	int new_irq = offset + ab8500_gpio->irq_base;
+	int offset, new_irq;
+	if (is_ab8540(ab8500_gpio->parent)) {
+		offset = irq - AB8540_INT_GPIO43R
+			- ab8500_gpio->parent->irq_base;
+		new_irq = (offset >> 1) + ab8500_gpio->irq_base;
+	} else {
+		offset = irq - AB8500_INT_GPIO6R
+			- ab8500_gpio->parent->irq_base;
+		new_irq = offset + ab8500_gpio->irq_base;
+	}
 	return new_irq;
 }
 
 static unsigned int falling_to_irq(unsigned int irq, void *dev)
 {
 	struct ab8500_gpio *ab8500_gpio = dev;
-	int offset = irq - AB8500_INT_GPIO6F
-			- ab8500_gpio->parent->irq_base ;
-	int new_irq = offset + ab8500_gpio->irq_base;
+	int offset, new_irq;
+	if (is_ab8540(ab8500_gpio->parent)) {
+		offset = irq - AB8540_INT_GPIO43F
+			- ab8500_gpio->parent->irq_base;
+		new_irq = (offset >> 1) + ab8500_gpio->irq_base;
+	} else {
+		offset = irq - AB8500_INT_GPIO6F
+			- ab8500_gpio->parent->irq_base;
+		new_irq = offset + ab8500_gpio->irq_base;
+	}
 	return new_irq;
-
 }
 
 /*
-- 
1.7.9.5

