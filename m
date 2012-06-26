Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2FZESs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:18:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47827 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2FZESr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:18:47 -0400
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, samsung-soc@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] gpio: samsung: add flags specifier to device-tree binding
Date: Mon, 25 Jun 2012 21:18:21 -0700
Message-Id: <1340684301-16836-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a flags field to the gpio specifier for Samsung. I didn't
want to add yet another field in the already quite long specifier, so
I decided to compress it together with the Pull Up/Down settings instead.

This is needed to, for example, have a gpio-keys input that is active low.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 Documentation/devicetree/bindings/gpio/gpio-samsung.txt | 9 +++++----
 drivers/gpio/gpio-samsung.c                             | 5 ++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
index 8f50fe5..c873e80 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-samsung.txt
@@ -11,14 +11,15 @@ Required properties:
      <[phandle of the gpio controller node]
       [pin number within the gpio controller]
       [mux function]
-      [pull up/down]
+      [flags and pull up/down]
       [drive strength]>
 
   Values for gpio specifier:
   - Pin number: is a value between 0 to 7.
-  - Pull Up/Down: 0 - Pull Up/Down Disabled.
-                  1 - Pull Down Enabled.
-                  3 - Pull Up Enabled.
+  - Flags and Pull Up/Down: 0 - Pull Up/Down Disabled.
+                            1 - Pull Down Enabled.
+                            3 - Pull Up Enabled.
+          Bit 16 (0x00010000) - Input is active low.
   - Drive Strength: 0 - 1x,
                     1 - 3x,
                     2 - 2x,
diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index b6453d0..92f7b2b 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2681,11 +2681,14 @@ static int exynos_gpio_xlate(struct gpio_chip *gc,
 
 	if (s3c_gpio_cfgpin(pin, S3C_GPIO_SFN(gpiospec->args[1])))
 		pr_warn("gpio_xlate: failed to set pin function\n");
-	if (s3c_gpio_setpull(pin, gpiospec->args[2]))
+	if (s3c_gpio_setpull(pin, gpiospec->args[2] & 0xffff))
 		pr_warn("gpio_xlate: failed to set pin pull up/down\n");
 	if (s5p_gpio_set_drvstr(pin, gpiospec->args[3]))
 		pr_warn("gpio_xlate: failed to set pin drive strength\n");
 
+	if (flags)
+		*flags = gpiospec->args[2] >> 16;
+
 	return gpiospec->args[0];
 }
 
-- 
1.7.10.1.488.g05fbf7a

