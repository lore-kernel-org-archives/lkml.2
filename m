Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2KNIh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:37:56 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61277 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2KNIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:37:55 -0500
Message-ID: <1352882265.12579.2.camel@phoenix>
Subject: [PATCH] pinctrl: plgpio: Call clk_disable_unprepare only if
 clk_prepare_enable is called
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Nov 2012 16:37:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allows clk_get() failure, and still work without it.
This patch adds !IS_ERR(plgpio->clk) checking in plgpio_request() error path
so we only call clk_disable_unprepare() if clk_prepare_enable() is called.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 1044ad3..cf6d9c2 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -243,7 +243,8 @@ static int plgpio_request(struct gpio_chip *chip, unsigned offset)
 	return 0;
 
 err1:
-	clk_disable_unprepare(plgpio->clk);
+	if (!IS_ERR(plgpio->clk))
+		clk_disable_unprepare(plgpio->clk);
 err0:
 	pinctrl_free_gpio(gpio);
 	return ret;
-- 
1.7.9.5



