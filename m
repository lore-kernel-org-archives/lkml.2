Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1LMJNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:13:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47542 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1LMJM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:12:57 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH RESEND] gpio: mpc8xxx: don't allow input-only pins to be output for MPC5121
Date: Tue, 13 Dec 2011 10:12:48 +0100
Message-Id: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 5121-custom reject if an input-only pin is requested to be output
(see 18.3.1.1 in the refman). Also, rewrite mach-specific quirk setup to
consume less lines which scales better.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/gpio/gpio-mpc8xxx.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index ec3fcf0..25dc736 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -115,6 +115,14 @@ static int mpc8xxx_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int mpc5121_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	/* GPIO 28..31 are input only on MPC5121 */
+	if (gpio >= 28)
+		return -EINVAL;
+
+	return mpc8xxx_gpio_dir_out(gc, gpio, val);
+}
 static int mpc8xxx_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	struct of_mm_gpio_chip *mm = to_of_mm_gpio_chip(gc);
@@ -340,11 +348,10 @@ static void __init mpc8xxx_add_controller(struct device_node *np)
 	mm_gc->save_regs = mpc8xxx_gpio_save_regs;
 	gc->ngpio = MPC8XXX_GPIO_PINS;
 	gc->direction_input = mpc8xxx_gpio_dir_in;
-	gc->direction_output = mpc8xxx_gpio_dir_out;
-	if (of_device_is_compatible(np, "fsl,mpc8572-gpio"))
-		gc->get = mpc8572_gpio_get;
-	else
-		gc->get = mpc8xxx_gpio_get;
+	gc->direction_output = of_device_is_compatible(np, "fsl,mpc5121-gpio") ?
+		mpc5121_gpio_dir_out : mpc8xxx_gpio_dir_out;
+	gc->get = of_device_is_compatible(np, "fsl,mpc8572-gpio") ?
+		mpc8572_gpio_get : mpc8xxx_gpio_get;
 	gc->set = mpc8xxx_gpio_set;
 	gc->to_irq = mpc8xxx_gpio_to_irq;
 
-- 
1.7.7.1

