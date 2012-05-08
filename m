Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2EHJrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:47:35 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:47580 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab2EHJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:47:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/12] pinctrl/nomadik: break out single GPIO debug function
Date: Tue, 8 May 2012 11:44:38 +0200
Message-ID: <1336470278-23553-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Break out the code displaying the status of a single pin so we
can use the same code in the pinctrl debug function.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |  105 ++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 94e3d0a..d9e41c9 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -943,14 +943,16 @@ static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 
 #include <linux/seq_file.h>
 
-static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+static void nmk_gpio_dbg_show_one(struct seq_file *s, struct gpio_chip *chip,
+				  unsigned offset, unsigned gpio)
 {
-	int mode;
-	unsigned		i;
-	unsigned		gpio = chip->base;
-	int			is_out;
+	const char *label = gpiochip_is_requested(chip, offset);
 	struct nmk_gpio_chip *nmk_chip =
 		container_of(chip, struct nmk_gpio_chip, chip);
+	int mode;
+	bool is_out;
+	bool pull;
+	u32 bit = 1 << offset;
 	const char *modes[] = {
 		[NMK_GPIO_ALT_GPIO]	= "gpio",
 		[NMK_GPIO_ALT_A]	= "altA",
@@ -959,56 +961,63 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	};
 
 	clk_enable(nmk_chip->clk);
-
-	for (i = 0; i < chip->ngpio; i++, gpio++) {
-		const char *label = gpiochip_is_requested(chip, i);
-		bool pull;
-		u32 bit = 1 << i;
-
-		is_out = readl(nmk_chip->addr + NMK_GPIO_DIR) & bit;
-		pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
-		mode = nmk_gpio_get_mode(gpio);
-		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
-			gpio, label ?: "(none)",
-			is_out ? "out" : "in ",
-			chip->get
-				? (chip->get(chip, i) ? "hi" : "lo")
-				: "?  ",
-			(mode < 0) ? "unknown" : modes[mode],
-			pull ? "pull" : "none");
-
-		if (label && !is_out) {
-			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_to_desc(irq);
-
-			/* This races with request_irq(), set_irq_type(),
-			 * and set_irq_wake() ... but those are "rare".
-			 */
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-				u32 bitmask = nmk_gpio_get_bitmask(gpio);
-
-				if (nmk_chip->edge_rising & bitmask)
-					trigger = "edge-rising";
-				else if (nmk_chip->edge_falling & bitmask)
-					trigger = "edge-falling";
-				else
-					trigger = "edge-undefined";
-
-				seq_printf(s, " irq-%d %s%s",
-					irq, trigger,
-					irqd_is_wakeup_set(&desc->irq_data)
-						? " wakeup" : "");
-			}
+	is_out = !!(readl(nmk_chip->addr + NMK_GPIO_DIR) & bit);
+	pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
+	mode = nmk_gpio_get_mode(gpio);
+
+	seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
+		   gpio, label ?: "(none)",
+		   is_out ? "out" : "in ",
+		   chip->get
+		   ? (chip->get(chip, offset) ? "hi" : "lo")
+		   : "?  ",
+		   (mode < 0) ? "unknown" : modes[mode],
+		   pull ? "pull" : "none");
+
+	if (label && !is_out) {
+		int		irq = gpio_to_irq(gpio);
+		struct irq_desc	*desc = irq_to_desc(irq);
+
+		/* This races with request_irq(), set_irq_type(),
+		 * and set_irq_wake() ... but those are "rare".
+		 */
+		if (irq >= 0 && desc->action) {
+			char *trigger;
+			u32 bitmask = nmk_gpio_get_bitmask(gpio);
+
+			if (nmk_chip->edge_rising & bitmask)
+				trigger = "edge-rising";
+			else if (nmk_chip->edge_falling & bitmask)
+				trigger = "edge-falling";
+			else
+				trigger = "edge-undefined";
+
+			seq_printf(s, " irq-%d %s%s",
+				   irq, trigger,
+				   irqd_is_wakeup_set(&desc->irq_data)
+				   ? " wakeup" : "");
 		}
+	}
+	clk_disable(nmk_chip->clk);
+}
+
+static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	unsigned		i;
+	unsigned		gpio = chip->base;
 
+	for (i = 0; i < chip->ngpio; i++, gpio++) {
+		nmk_gpio_dbg_show_one(s, chip, i, gpio);
 		seq_printf(s, "\n");
 	}
-
-	clk_disable(nmk_chip->clk);
 }
 
 #else
+static inline void nmk_gpio_dbg_show_one(struct seq_file *s,
+					 struct gpio_chip *chip,
+					 unsigned offset, unsigned gpio)
+{
+}
 #define nmk_gpio_dbg_show	NULL
 #endif
 
-- 
1.7.9.2

