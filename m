Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2JQMkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:40:49 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:43953 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756846Ab2JQMho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:44 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 08/15 v5] gpio-pca953x: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:40 +0200
Message-Id: <1350477107-26512-9-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-pca953x driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-pca953x.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-pca953x.c
+++ linux-2.6/drivers/gpio/gpio-pca953x.c
@@ -300,6 +300,68 @@ exit:
 	mutex_unlock(&chip->i2c_lock);
 }
 
+static unsigned long pca953x_gpio_get_block(struct gpio_chip *gc,
+					    unsigned long mask)
+{
+	struct pca953x_chip *chip;
+	u32 reg_val;
+	int ret, offset = 0;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	mutex_lock(&chip->i2c_lock);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_INPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_IN;
+		break;
+	}
+	ret = pca953x_read_reg(chip, offset, &reg_val);
+	mutex_unlock(&chip->i2c_lock);
+	if (ret < 0) {
+		/* NOTE:  diagnostic already emitted; that's all we should
+		 * do unless gpio_*_value_cansleep() calls become different
+		 * from their nonsleeping siblings (and report faults).
+		 */
+		return 0;
+	}
+
+	return reg_val & mask;
+}
+
+static void pca953x_gpio_set_block(struct gpio_chip *gc, unsigned long mask,
+				   unsigned long values)
+{
+	struct pca953x_chip *chip;
+	u32 reg_val;
+	int ret, offset = 0;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+
+	mutex_lock(&chip->i2c_lock);
+
+	reg_val = chip->reg_output & ~mask;
+	reg_val |= values & mask;
+
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_OUTPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_OUT;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
+	if (ret)
+		goto exit;
+
+	chip->reg_output = reg_val;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+}
+
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
 	struct gpio_chip *gc;
@@ -310,6 +372,8 @@ static void pca953x_setup_gpio(struct pc
 	gc->direction_output = pca953x_gpio_direction_output;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
+	gc->get_block = pca953x_gpio_get_block;
+	gc->set_block = pca953x_gpio_set_block;
 	gc->can_sleep = 1;
 
 	gc->base = chip->gpio_start;
