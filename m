Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1ETW2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:28:50 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:53907 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab1ETW2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:28:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] gpio/nomadik: show all pins in debug
Date: Sat, 21 May 2011 00:05:30 +0200
Message-ID: <1305929130-9114-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Useful to check the status of the runtime pin muxing.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
[Squashed, modified to use chip-internal IRQ trigger state]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-nomadik.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index f49748e..e6d62b9 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -815,20 +815,43 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		bool pull;
 		u32 bit = 1 << i;
 
-		if (!label)
-			continue;
-
 		is_out = readl(nmk_chip->addr + NMK_GPIO_DIR) & bit;
 		pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
 		mode = nmk_gpio_get_mode(gpio);
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
-			gpio, label,
+			gpio, label ?: "(none)",
 			is_out ? "out" : "in ",
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ",
 			(mode < 0) ? "unknown" : modes[mode],
 			pull ? "pull" : "none");
+
+		if (label && !is_out) {
+			int		irq = gpio_to_irq(gpio);
+			struct irq_desc	*desc = irq_to_desc(irq);
+
+			/* This races with request_irq(), set_irq_type(),
+			 * and set_irq_wake() ... but those are "rare".
+			 */
+			if (irq >= 0 && desc->action) {
+				char *trigger;
+				u32 bitmask = nmk_gpio_get_bitmask(gpio);
+
+				if (nmk_chip->edge_rising & bitmask)
+					trigger = "edge-rising";
+				else if (nmk_chip->edge_falling & bitmask)
+					trigger = "edge-falling";
+				else
+					trigger = "edge-undefined";
+
+				seq_printf(s, " irq-%d %s%s",
+					irq, trigger,
+					irqd_is_wakeup_set(&desc->irq_data)
+						? " wakeup" : "");
+			}
+		}
+
 		seq_printf(s, "\n");
 	}
 }
-- 
1.7.3.2

