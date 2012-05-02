Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2EBLtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:49:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43200 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab2EBLtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:49:45 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Defer failed gpio requests by default
Date: Wed,  2 May 2012 12:49:40 +0100
Message-Id: <1335959380-8209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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
index 566d012..b244b0c 100644
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

