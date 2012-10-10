Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2JJMif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:38:35 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:52381 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab2JJMid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:38:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/5] pinctrl/nomadik: allow to support several ranges per GPIO bank
Date: Wed, 10 Oct 2012 14:38:18 +0200
Message-ID: <1349872698-31245-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

With DB8500 the number of GPIO chips = number GPIO bank =
number of GPIO ranges.

With DB8540, a new GPIO range configuration is used, some GPIO
banks can have several GPIO ranges.

For example, DB8540 GPIO bank0 (GPIO0 to GPIO32) have 2 GPIO
ranges:
    - GPIO0 to GPIO17  : routed
    - GPIO18 to GPIO21 : hole
    - GPIO22 to GPIO28 : routed
    - GPIO29 to GPIO32 : hole

Previously, during nmk_pinctrl_probe(), all GPIO ranges were
parsed, as GPIO ranges are larger than the number of GPIO chips,
a warning occurs. This commit allows each bank to have several
GPIO ranges.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 334cd2f..e4d3778 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1837,11 +1837,11 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	 * need this to proceed.
 	 */
 	for (i = 0; i < npct->soc->gpio_num_ranges; i++) {
-		if (!nmk_gpio_chips[i]) {
+		if (!nmk_gpio_chips[npct->soc->gpio_ranges[i].id]) {
 			dev_warn(&pdev->dev, "GPIO chip %d not registered yet\n", i);
 			return -EPROBE_DEFER;
 		}
-		npct->soc->gpio_ranges[i].gc = &nmk_gpio_chips[i]->chip;
+		npct->soc->gpio_ranges[i].gc = &nmk_gpio_chips[npct->soc->gpio_ranges[i].id]->chip;
 	}
 
 	nmk_pinctrl_desc.pins = npct->soc->pins;
-- 
1.7.11.3

