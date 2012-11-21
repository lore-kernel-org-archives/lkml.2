Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2KUGeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 01:34:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2KUGeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 01:34:07 -0500
Message-ID: <1353479636.20245.2.camel@phoenix>
Subject: [PATCH] gpiolib: Fix use after free in gpiochip_add_pin_range
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 14:33:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is introduced by commit 9ab6e988
"gpiolib: return any error code from range creation".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This patch is against LinusW's linux-pinctrl tree, for-next branch.
Axel
 drivers/gpio/gpiolib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 317ff04..8370214 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1201,6 +1201,7 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 			   unsigned int npins)
 {
 	struct gpio_pin_range *pin_range;
+	int ret;
 
 	pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
 	if (!pin_range) {
@@ -1219,10 +1220,11 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 	pin_range->pctldev = pinctrl_find_and_add_gpio_range(pinctl_name,
 			&pin_range->range);
 	if (IS_ERR(pin_range->pctldev)) {
+		ret = PTR_ERR(pin_range->pctldev);
 		pr_err("%s: GPIO chip: could not create pin range\n",
 		       chip->label);
 		kfree(pin_range);
-		return PTR_ERR(pin_range->pctldev);
+		return ret;
 	}
 	pr_debug("%s: GPIO chip: created GPIO range %d->%d ==> PIN %d->%d\n",
 		 chip->label, offset, offset + npins - 1,
-- 
1.7.9.5



