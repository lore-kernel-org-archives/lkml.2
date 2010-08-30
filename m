Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0H3Hvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:51:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60354 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0H3Hvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:51:44 -0400
Date: Mon, 30 Aug 2010 16:51:42 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [RFC PATCH] GPIO: add control of powerdown modes and pull-up/down
 configurations.
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Message-id: <1283154702-23008-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.6.3.3
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Aug 2010 07:51:42.0420 (UTC)
 FILETIME=[2F8A5140:01CB4818]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This GPIO framework patch adds the control on the powerdown mode and
pull-up/down configurations. Some architectures have "powerdown mode"
registers that configure the behaviors of GPIO ports when the processor
is in a powerdown state (such as suspend-to-mem) and pull-up/down
resister configurations. We add controls over such values in gpiolib.c.

Besides, the generic GPIO has not considered setting port modes other than
input and output. However, some chips have more modes (including
"external interrupts", "clock input", "clock output", and others), which
require additional modes implemented out of this framework. Although we
may generalize all these modes into input and output, the control register
settings often have more than two modes and require various values for
"direction" or "mode". For power-savings in mobile processors, power-down
mode configurations and pull-up/down settings are critical.

Your comments are very welcomed.

Thanks,
MyungJoo

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpio/gpiolib.c     |  216 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   32 +++++++
 include/linux/gpio.h       |   21 +++++
 3 files changed, 269 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21da9c1..de8b650 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1465,6 +1465,222 @@ fail:
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
 
+int gpio_direction_set(unsigned gpio, int mode, int value)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set_direction)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(chip->can_sleep);
+
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
+	status = chip->set_direction(chip, gpio, mode, value);
+	if (status == 0)
+		switch (mode) {
+		case GPIOCFG_OUTPUT:
+			set_bit(FLAG_IS_OUT, &desc->flags);
+			break;
+		default:
+			clear_bit(FLAG_IS_OUT, &desc->flags);
+		};
+
+lose:
+	return status;
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_direction_set);
+
+int gpio_pull_cfg(unsigned gpio, int pull)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set_pull)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(chip->can_sleep);
+
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
+	status = chip->set_pull(chip, gpio, pull);
+
+lose:
+	return status;
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_pull_cfg);
+
+int gpio_powerdown_direction_set(unsigned gpio, int mode, int value)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set_powerdown_direction)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(chip->can_sleep);
+
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
+	status = chip->set_powerdown_direction(chip, gpio, mode, value);
+
+lose:
+	return status;
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_powerdown_direction_set);
+
+int gpio_powerdown_pull_cfg(unsigned gpio, int pull)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set_powerdown_pull)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(chip->can_sleep);
+
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
+	status = chip->set_powerdown_pull(chip, gpio, pull);
+
+lose:
+	return status;
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_powerdown_pull_cfg);
+
 /**
  * gpio_set_debounce - sets @debounce time for a @gpio
  * @gpio: the gpio to set debounce time
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c7376bf..196d110 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -33,6 +33,14 @@ struct seq_file;
 struct module;
 struct device_node;
 
+#define GPIOCFG_INPUT			(0x0)
+#define GPIOCFG_OUTPUT			(0x1)
+#define GPIOCFG_SFN(x)			(x)
+
+#define GPIOPULL_NONE			(0x0)
+#define GPIOPULL_DOWN			(0x1)
+#define GPIOPULL_UP			(0x2)
+
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
@@ -47,6 +55,18 @@ struct device_node;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @set_direction: configures signal "offset" as mode (GPIOCFG_*), or returns
+ *	error. GPIOCFG_SFN(x) is used to set other special functions including
+ *	but not limited to "external interrupt", "keep state for powerdown",
+ *	and others. For "OUTPUT" direction, value is also used. Otherwise,
+ *	value can be ignored.
+ * @set_pull: configures pulldown/pullup setting of "offset" as pull
+ *	(GPIOPULL_*), or returns error.
+ * @set_powerdown_direction: configures signal "offset" as mode (GPIOCFG_*) at
+ *	powerdown state (such as sleep), or returns error. For "OUTPUT"
+ *	direction, value can be also used.
+ * @set_powerdown_pull: configures pulldown/pullup settting of "offset" at
+ *	powerdown state (such as sleep) as pull (GPIOPULL_*), or returns error.
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
@@ -97,6 +117,18 @@ struct gpio_chip {
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
+	int			(*set_direction)(struct gpio_chip *chip,
+						unsigned offset, int mode,
+						int value);
+	int			(*set_pull)(struct gpio_chip *chip,
+						unsigned offset, int pull);
+	int			(*set_powerdown_direction)(
+						struct gpio_chip *chip,
+						unsigned offset, int mode,
+						int value);
+	int			(*set_powerdown_pull)(struct gpio_chip *chip,
+						unsigned offset, int pull);
+
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 03f616b..02057dc 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -51,6 +51,27 @@ static inline int gpio_direction_output(unsigned gpio, int value)
 	return -ENOSYS;
 }
 
+static inline int gpio_direction_set(unsigned gpio, int mode, int value)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_pull_cfg(unsigned gpio, int pull)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_powerdown_direction_set(unsigned gpio,
+		int mode, int value)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_powerdown_pull_cfg(unsigned gpio, int pull)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
 {
 	return -ENOSYS;
-- 
1.6.3.3

