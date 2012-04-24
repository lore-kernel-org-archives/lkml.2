Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2DXHjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:39:47 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:60891 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706Ab2DXHjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:39:46 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/9 v3] gpio/nomadik: use ioremap() instead of static mappings
Date: Tue, 24 Apr 2012 09:39:27 +0200
Message-ID: <1335253167-31905-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/gpio/gpio-nomadik.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 7b45d88..b35eb25 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -28,8 +28,6 @@
 
 #include <plat/pincfg.h>
 #include <plat/gpio-nomadik.h>
-#include <mach/hardware.h>
-#include <asm/gpio.h>
 
 /*
  * The GPIO module in the Nomadik family of Systems-on-Chip is an
@@ -1139,6 +1137,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	struct resource *res;
 	struct clk *clk;
 	int secondary_irq;
+	void __iomem *base;
 	int irq;
 	int ret;
 
@@ -1169,10 +1168,16 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
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
@@ -1186,7 +1191,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	 */
 	nmk_chip->bank = dev->id;
 	nmk_chip->clk = clk;
-	nmk_chip->addr = io_p2v(res->start);
+	nmk_chip->addr = base;
 	nmk_chip->chip = nmk_gpio_template;
 	nmk_chip->parent_irq = irq;
 	nmk_chip->secondary_parent_irq = secondary_irq;
@@ -1226,6 +1231,8 @@ out_free:
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

