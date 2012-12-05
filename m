Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2LEJtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:49:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44204 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2LEJtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:49:51 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH] gpio: twl4030: Correct status reporting when the GPIO is used as output
Date: Wed, 5 Dec 2012 10:49:45 +0100
Message-ID: <1354700985-4453-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the GPIO is configured as output we need to read the GPIODATAOUT*
register to get correct information. When the GPIO is output the GPIODATAIN*
registers report 0 all the time (no feedback from output path).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index 55b4fe4..e7aa620 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -191,13 +191,19 @@ static int twl4030_get_gpio_datain(int gpio)
 	u8 d_bnk = gpio >> 3;
 	u8 d_off = gpio & 0x7;
 	u8 base = 0;
+	int direction;
 	int ret = 0;
 
 	if (unlikely((gpio >= TWL4030_GPIO_MAX)
 		|| !(gpio_usage_count & BIT(gpio))))
 		return -EPERM;
 
-	base = REG_GPIODATAIN1 + d_bnk;
+	direction = gpio_twl4030_read(REG_GPIODATADIR1 + d_bnk);
+	if (direction > 0 && (direction >> d_off) & 0x1)
+		base = REG_SETGPIODATAOUT1 + d_bnk;
+	else
+		base = REG_GPIODATAIN1 + d_bnk;
+
 	ret = gpio_twl4030_read(base);
 	if (ret > 0)
 		ret = (ret >> d_off) & 0x1;
-- 
1.8.0

