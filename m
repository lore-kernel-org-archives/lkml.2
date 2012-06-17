Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2FQKM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:12:26 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49170 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754615Ab2FQKMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:12:25 -0400
From: Roland Stigge <stigge@antcom.de>
To: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER if GPIO not yet available
Date: Sun, 17 Jun 2012 12:11:31 +0200
Message-Id: <1339927893-8842-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
respective GPIO is not (yet) available. This is useful if driver's probe()
functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
can be probed again later on.

The function still returns -EINVAL on other errors (parse error or node doesn't
exist). This way, the case of an optional/intentionally missing GPIO is handled
appropriately.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpiolib-of.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/gpio/gpiolib-of.c
+++ linux-2.6/drivers/gpio/gpiolib-of.c
@@ -62,7 +62,10 @@ static int of_gpiochip_find_and_xlate(st
 int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                            int index, enum of_gpio_flags *flags)
 {
-	struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
+	/* Return -EPROBE_DEFER to support probe() functions to be called
+	 * later when the GPIO actually becomes available
+	 */
+	struct gg_data gg_data = { .flags = flags, .out_gpio = -EPROBE_DEFER };
 	int ret;
 
 	/* .of_xlate might decide to not fill in the flags, so clear it. */
