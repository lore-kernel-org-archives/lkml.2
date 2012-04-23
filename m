Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2DWLaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:30:52 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:45075 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab2DWLav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:30:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/9 v2] gpio/nomadik: use ioremap() instead of static mappings
Date: Mon, 23 Apr 2012 13:30:32 +0200
Message-ID: <1335180632-21381-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We were using a custom io_p2v() (physical-to-virtual) translation
macro, but it's fully possible to just ioremap() this memory
now, so skip use of static addresses altogether.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-nomadik.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 7b45d88..bddc3dd 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -28,7 +28,6 @@
 
 #include <plat/pincfg.h>
 #include <plat/gpio-nomadik.h>
-#include <mach/hardware.h>
 #include <asm/gpio.h>
 
 /*
@@ -1139,6 +1138,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	struct resource *res;
 	struct clk *clk;
 	int secondary_irq;
+	void __iomem *base;
 	int irq;
 	int ret;
 
@@ -1169,10 +1169,16 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		goto out;
 	}
 
+	base = ioremap(res->start, resource_size(res));
+	if (!base) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
 	clk = clk_get(&dev->dev, NULL);
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
-		goto out_release;
+		goto out_unmap;
 	}
 
 	nmk_chip = kzalloc(sizeof(*nmk_chip), GFP_KERNEL);
@@ -1186,7 +1192,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	 */
 	nmk_chip->bank = dev->id;
 	nmk_chip->clk = clk;
-	nmk_chip->addr = io_p2v(res->start);
+	nmk_chip->addr = base;
 	nmk_chip->chip = nmk_gpio_template;
 	nmk_chip->parent_irq = irq;
 	nmk_chip->secondary_parent_irq = secondary_irq;
@@ -1226,6 +1232,8 @@ out_free:
 out_clk:
 	clk_disable(clk);
 	clk_put(clk);
+out_unmap:
+	iounmap(base);
 out_release:
 	release_mem_region(res->start, resource_size(res));
 out:
-- 
1.7.9.2

