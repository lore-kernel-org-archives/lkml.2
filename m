Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2KEPpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:45:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2KEPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:45:06 -0500
Message-ID: <1352130296.13561.1.camel@phoenix>
Subject: [PATCH v2] pinctrl: samsung: Add ifdef CONFIG_OF_GPIO guard for
 gc->of_node
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 23:44:56 +0800
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

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2:
Don't remove the prop variable.
It is used in of_property_for_each_string() when CONFIG_OF_GPIO is enabled.

 drivers/pinctrl/pinctrl-samsung.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index fc34cac..f798b4d 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -794,7 +794,9 @@ static int __devinit samsung_gpiolib_register(struct platform_device *pdev,
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



