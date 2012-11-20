Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2KTOFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:05:13 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:40353 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab2KTOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:04:55 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/7] gpiolib: return any error code from range creation
Date: Tue, 20 Nov 2012 15:04:42 +0100
Message-ID: <1353420282-18066-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

If we try to create a range for a certain GPIO chip and the
target pin controller is not yet available it may return
a probe deferral error code, so handle this all the way
our by checking the error code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a59d13d..317ff04 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1218,10 +1218,11 @@ int gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 	pin_range->range.npins = npins;
 	pin_range->pctldev = pinctrl_find_and_add_gpio_range(pinctl_name,
 			&pin_range->range);
-	if (!pin_range->pctldev) {
+	if (IS_ERR(pin_range->pctldev)) {
 		pr_err("%s: GPIO chip: could not create pin range\n",
 		       chip->label);
 		kfree(pin_range);
+		return PTR_ERR(pin_range->pctldev);
 	}
 	pr_debug("%s: GPIO chip: created GPIO range %d->%d ==> PIN %d->%d\n",
 		 chip->label, offset, offset + npins - 1,
-- 
1.7.11.3

