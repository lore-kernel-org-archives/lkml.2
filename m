Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2GVRT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 13:19:57 -0400
Received: from svenfoo.org ([82.94.215.22]:44269 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2GVRT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 13:19:56 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2012 13:19:55 EDT
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] gpiolib: fix chip->base handling in of_gpio_simple_xlate()
Date: Sun, 22 Jul 2012 19:10:52 +0200
Message-Id: <1342977052-7880-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_gpio_simple_xlate() is called for each chip when a GPIO is looked up.
When registering several chips off the same DT node (with different pin
offsets) however, the lookup fails as the GPIO number passed in to
of_gpio_simple_xlate() is likely higher than the chip's ->ngpio value.

Fix that by taking into account the chip's ->base value, and return the
relative offset of the pin inside the chip.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>
---

I'm currently porting the PXA pieces over to DT, and stumbled over what
looks like an obvious bug to me. Correct me if I'm mistaken, but I see
no reason why one shouldn't be able to instanciate several GPIO chips
from a single DT node.

Thanks,
Daniel

 drivers/gpio/gpiolib-of.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d18068a..51bc232 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -147,13 +147,13 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
 	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
 		return -EINVAL;
 
-	if (gpiospec->args[0] >= gc->ngpio)
+	if (gpiospec->args[0] >= gc->ngpio + gc->base)
 		return -EINVAL;
 
 	if (flags)
 		*flags = gpiospec->args[1];
 
-	return gpiospec->args[0];
+	return gpiospec->args[0] - gc->base;
 }
 EXPORT_SYMBOL(of_gpio_simple_xlate);
 
-- 
1.7.10.4

