Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2GILXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:23:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59780 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab2GILW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:22:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Defer failed gpio requests by default
Date: Mon,  9 Jul 2012 12:22:56 +0100
Message-Id: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since users must be explicitly provided with a GPIO number in order to
request one the overwhelmingly common case for failing to request will
be that the required GPIO driver has not yet registered and we should
therefore defer until it has registered.

In order to avoid having to code this logic in individual drivers have
gpio_request() return -EPROBE_DEFER when failing to look up the GPIO.
Drivers which don't want this behaviour can override it if they desire.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 120b2a0..de0213c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1186,7 +1186,7 @@ int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
-	int			status = -EINVAL;
+	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
-- 
1.7.10

