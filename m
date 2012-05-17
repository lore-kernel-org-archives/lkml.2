Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582Ab2EQUEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:04:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55881 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab2EQUEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:04:32 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/3] gpio/lpc32xx: Fixup of_xlate for core changes
Date: Thu, 17 May 2012 14:04:20 -0600
Message-Id: <1337285060-31919-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
References: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

I've reworked the of_xlate code for gpios in a way that I'm happier with, but it is untested.  Can you try it out with this patch to your code and make sure it works properly for you?  You can roll this change into your patch if it works.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpio-lpc32xx.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index d42bf6c..6ea7b38 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -464,18 +464,15 @@ void __init lpc32xx_gpio_init(void)
 {
 }
 
-static int lpc32xx_of_xlate(struct gpio_chip **gc,
+static int lpc32xx_of_xlate(struct gpio_chip *gc,
 			    const struct of_phandle_args *gpiospec, u32 *flags)
 {
-	u32 bank;
-	if (WARN_ON(gpiospec->args_count < 3))
+	/* Is this the correct bank? */
+	u32 bank = gpiospec->args[0];
+	if ((bank > ARRAY_SIZE(lpc32xx_gpiochip) ||
+	    (gc != &lpc32xx_gpiochip[bank].chip))
 		return -EINVAL;
 
-	bank = gpiospec->args[0];
-	if (WARN_ON(bank > 5))
-		return -EINVAL;
-
-	*gc = &lpc32xx_gpiochip[bank].chip;
 	if (flags)
 		*flags = gpiospec->args[2];
 	return gpiospec->args[1];
-- 
1.7.9.5

