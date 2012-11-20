Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2KTOFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:05:19 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:56540 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2KTOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:05:17 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/7] pinctrl: add function to retrieve range from pin
Date: Tue, 20 Nov 2012 15:04:50 +0100
Message-ID: <1353420290-18103-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a function to the pinctrl core to retrieve the GPIO
range associated with a certain pin for a certain controller.
This is needed when a pinctrl driver want to look up the
corresponding struct gpio_chip for a certain pin. As the
GPIO drivers can now create these ranges themselves, the
pinctrl driver no longer knows about all its associated GPIO
chips.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c          | 24 ++++++++++++++++++++++++
 include/linux/pinctrl/pinctrl.h |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 33af811..5cdee86 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -364,6 +364,30 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
 
 /**
+ * pinctrl_find_gpio_range_from_pin() - locate the GPIO range for a pin
+ * @pctldev: the pin controller device to look in
+ * @pin: a controller-local number to find the range for
+ */
+struct pinctrl_gpio_range *
+pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
+				 unsigned int pin)
+{
+	struct pinctrl_gpio_range *range = NULL;
+
+	/* Loop over the ranges */
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		/* Check if we're in the valid range */
+		if (pin >= range->pin_base &&
+		    pin < range->pin_base + range->npins) {
+			return range;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(pinctrl_find_gpio_range_from_pin);
+
+/**
  * pinctrl_remove_gpio_range() - remove a range of GPIOs fro a pin controller
  * @pctldev: pin controller device to remove the range from
  * @range: the GPIO range to remove
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 7dee9ac..04d6700 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -139,6 +139,9 @@ extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 
 extern struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 		struct pinctrl_gpio_range *range);
+extern struct pinctrl_gpio_range *
+pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
+				 unsigned int pin);
 
 #ifdef CONFIG_OF
 extern struct pinctrl_dev *of_pinctrl_get(struct device_node *np);
-- 
1.7.11.3

