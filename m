Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab2KENzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:55:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44266 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2KENzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:55:44 -0500
Message-ID: <1352123739.14769.8.camel@phoenix>
Subject: [PATCH] pinctrl: samsung: Add ifdef CONFIG_OF_GPIO guard for
 gc->of_node
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 21:55:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error when !CONFIG_OF_GPIO.

  CC      drivers/pinctrl/pinctrl-samsung.o
drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_pinctrl_parse_dt_pins':
drivers/pinctrl/pinctrl-samsung.c:557:19: warning: unused variable 'prop' [-Wunused-variable]
drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_gpiolib_register':
drivers/pinctrl/pinctrl-samsung.c:797:5: error: 'struct gpio_chip' has no member named 'of_node'
make[2]: *** [drivers/pinctrl/pinctrl-samsung.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2

This patch also removes unused variable 'prop' to silence the build warning.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-samsung.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index fc34cac..8ea9735 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -554,7 +554,6 @@ static int __devinit samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
 			unsigned int **pin_list, unsigned int *npins)
 {
 	struct device *dev = &pdev->dev;
-	struct property *prop;
 	struct pinctrl_pin_desc const *pdesc = pctl->pins;
 	unsigned int idx = 0, cnt;
 	const char *pin_name;
@@ -794,7 +793,9 @@ static int __devinit samsung_gpiolib_register(struct platform_device *pdev,
 		gc->base = ctrl->base + bank->pin_base;
 		gc->ngpio = bank->nr_pins;
 		gc->dev = &pdev->dev;
+#if defined(CONFIG_OF_GPIO)
 		gc->of_node = bank->of_node;
+#endif
 		gc->label = bank->name;
 
 		ret = gpiochip_add(gc);
-- 
1.7.9.5



