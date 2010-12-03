Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0LCPGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:06:47 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:50643 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807Ab0LCPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:45 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: [PATCH 04/20] nomadik-gpio: allow sleep mode dir/pull to differ from normal mode
Date: Fri, 3 Dec 2010 20:35:37 +0530
Message-ID: <1291388753-14662-5-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

In the nomadik GPIO pin configuration, allow the sleep mode direction
and pull configurations to differ from the ones for the normal state.
PIN_SLPM_PULL_*, PIN_SLPM_INPUT, PIN_SLPM_OUTPUT* macros are provided
for this.

Since the hardware does not allow seperate configurations for sleep mode
and normal mode, this is implemented by having software remux the
configurations as necessary.

Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
---
 arch/arm/plat-nomadik/gpio.c                |   50 +++++++++++++++++--
 arch/arm/plat-nomadik/include/plat/pincfg.h |   70 +++++++++++++++++++++------
 2 files changed, 99 insertions(+), 21 deletions(-)

diff --git a/arch/arm/plat-nomadik/gpio.c b/arch/arm/plat-nomadik/gpio.c
index 85e6fd2..5fc8e4d 100644
--- a/arch/arm/plat-nomadik/gpio.c
+++ b/arch/arm/plat-nomadik/gpio.c
@@ -119,7 +119,7 @@ static void __nmk_gpio_make_output(struct nmk_gpio_chip *nmk_chip,
 }
 
 static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
-			     pin_cfg_t cfg)
+			     pin_cfg_t cfg, bool sleep)
 {
 	static const char *afnames[] = {
 		[NMK_GPIO_ALT_GPIO]	= "GPIO",
@@ -145,11 +145,34 @@ static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
 	int output = PIN_DIR(cfg);
 	int val = PIN_VAL(cfg);
 
-	dev_dbg(nmk_chip->chip.dev, "pin %d: af %s, pull %s, slpm %s (%s%s)\n",
-		pin, afnames[af], pullnames[pull], slpmnames[slpm],
+	dev_dbg(nmk_chip->chip.dev, "pin %d [%#lx]: af %s, pull %s, slpm %s (%s%s)\n",
+		pin, cfg, afnames[af], pullnames[pull], slpmnames[slpm],
 		output ? "output " : "input",
 		output ? (val ? "high" : "low") : "");
 
+	if (sleep) {
+		int slpm_pull = PIN_SLPM_PULL(cfg);
+		int slpm_output = PIN_SLPM_DIR(cfg);
+		int slpm_val = PIN_SLPM_VAL(cfg);
+
+		/*
+		 * The SLPM_* values are normal values + 1 to allow zero to
+		 * mean "same as normal".
+		 */
+		if (slpm_pull)
+			pull = slpm_pull - 1;
+		if (slpm_output)
+			output = slpm_output - 1;
+		if (slpm_val)
+			val = slpm_val - 1;
+
+		dev_dbg(nmk_chip->chip.dev, "pin %d: sleep pull %s, dir %s, val %s\n",
+			pin,
+			slpm_pull ? pullnames[pull] : "same",
+			slpm_output ? (output ? "output" : "input") : "same",
+			slpm_val ? (val ? "high" : "low") : "same");
+	}
+
 	if (output)
 		__nmk_gpio_make_output(nmk_chip, offset, val);
 	else {
@@ -175,7 +198,7 @@ static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
  * side-effects.  The gpio can be manipulated later using standard GPIO API
  * calls.
  */
-int nmk_config_pin(pin_cfg_t cfg)
+int nmk_config_pin(pin_cfg_t cfg, bool sleep)
 {
 	struct nmk_gpio_chip *nmk_chip;
 	int gpio = PIN_NUM(cfg);
@@ -186,7 +209,7 @@ int nmk_config_pin(pin_cfg_t cfg)
 		return -EINVAL;
 
 	spin_lock_irqsave(&nmk_chip->lock, flags);
-	__nmk_config_pin(nmk_chip, gpio - nmk_chip->chip.base, cfg);
+	__nmk_config_pin(nmk_chip, gpio - nmk_chip->chip.base, cfg, sleep);
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 
 	return 0;
@@ -207,7 +230,7 @@ int nmk_config_pins(pin_cfg_t *cfgs, int num)
 	int i;
 
 	for (i = 0; i < num; i++) {
-		int ret = nmk_config_pin(cfgs[i]);
+		ret = nmk_config_pin(cfgs[i], false);
 		if (ret)
 			break;
 	}
@@ -216,6 +239,21 @@ int nmk_config_pins(pin_cfg_t *cfgs, int num)
 }
 EXPORT_SYMBOL(nmk_config_pins);
 
+int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < num; i++) {
+		ret = nmk_config_pin(cfgs[i], true);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nmk_config_pins_sleep);
+
 /**
  * nmk_gpio_set_slpm() - configure the sleep mode of a pin
  * @gpio: pin number
diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
index 8c5ae3f..05a3936 100644
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ b/arch/arm/plat-nomadik/include/plat/pincfg.h
@@ -19,16 +19,22 @@
  *	bit  9..10 - Alternate Function Selection
  *	bit 11..12 - Pull up/down state
  *	bit     13 - Sleep mode behaviour
- *	bit     14 - (sleep mode) Direction
- *	bit     15 - (sleep mode) Value (if output)
+ *	bit     14 - Direction
+ *	bit     15 - Value (if output)
+ *	bit 16..18 - SLPM pull up/down state
+ *	bit 19..20 - SLPM direction
+ *	bit 21..22 - SLPM Value (if output)
  *
  * to facilitate the definition, the following macros are provided
  *
  * PIN_CFG_DEFAULT - default config (0):
  *		     pull up/down = disabled
  *		     sleep mode = input/wakeup
- *		     (sleep mode) direction = input
- *		     (sleep mode) value = low
+ *		     direction = input
+ *		     value = low
+ *		     SLPM direction = same as normal
+ *		     SLPM pull = same as normal
+ *		     SLPM value = same as normal
  *
  * PIN_CFG	   - default config with alternate function
  * PIN_CFG_PULL	   - default config with alternate function and pull up/down
@@ -75,30 +81,64 @@ typedef unsigned long pin_cfg_t;
 #define PIN_VAL_LOW		(0 << PIN_VAL_SHIFT)
 #define PIN_VAL_HIGH		(1 << PIN_VAL_SHIFT)
 
-/* Shortcuts.  Use these instead of separate DIR and VAL.  */
-#define PIN_INPUT		PIN_DIR_INPUT
+#define PIN_SLPM_PULL_SHIFT	16
+#define PIN_SLPM_PULL_MASK	(0x7 << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL(x)	\
+	(((x) & PIN_SLPM_PULL_MASK) >> PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_NONE	\
+	((1 + NMK_GPIO_PULL_NONE) << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_UP	\
+	((1 + NMK_GPIO_PULL_UP) << PIN_SLPM_PULL_SHIFT)
+#define PIN_SLPM_PULL_DOWN	\
+	((1 + NMK_GPIO_PULL_DOWN) << PIN_SLPM_PULL_SHIFT)
+
+#define PIN_SLPM_DIR_SHIFT	19
+#define PIN_SLPM_DIR_MASK	(0x3 << PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR(x)		\
+	(((x) & PIN_SLPM_DIR_MASK) >> PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR_INPUT	((1 + 0) << PIN_SLPM_DIR_SHIFT)
+#define PIN_SLPM_DIR_OUTPUT	((1 + 1) << PIN_SLPM_DIR_SHIFT)
+
+#define PIN_SLPM_VAL_SHIFT	21
+#define PIN_SLPM_VAL_MASK	(0x3 << PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL(x)		\
+	(((x) & PIN_SLPM_VAL_MASK) >> PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL_LOW	((1 + 0) << PIN_SLPM_VAL_SHIFT)
+#define PIN_SLPM_VAL_HIGH	((1 + 1) << PIN_SLPM_VAL_SHIFT)
+
+/* Shortcuts.  Use these instead of separate DIR, PULL, and VAL.  */
+#define PIN_INPUT_PULLDOWN	(PIN_DIR_INPUT | PIN_PULL_DOWN)
+#define PIN_INPUT_PULLUP	(PIN_DIR_INPUT | PIN_PULL_UP)
+#define PIN_INPUT_NOPULL	(PIN_DIR_INPUT | PIN_PULL_NONE)
 #define PIN_OUTPUT_LOW		(PIN_DIR_OUTPUT | PIN_VAL_LOW)
 #define PIN_OUTPUT_HIGH		(PIN_DIR_OUTPUT | PIN_VAL_HIGH)
 
-/*
- * These are the same as the ones above, but should make more sense to the
- * reader when seen along with a setting a pin to AF mode.
- */
-#define PIN_SLPM_INPUT		PIN_INPUT
-#define PIN_SLPM_OUTPUT_LOW	PIN_OUTPUT_LOW
-#define PIN_SLPM_OUTPUT_HIGH	PIN_OUTPUT_HIGH
+#define PIN_SLPM_INPUT_PULLDOWN	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_DOWN)
+#define PIN_SLPM_INPUT_PULLUP	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_UP)
+#define PIN_SLPM_INPUT_NOPULL	(PIN_SLPM_DIR_INPUT | PIN_SLPM_PULL_NONE)
+#define PIN_SLPM_OUTPUT_LOW	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_LOW)
+#define PIN_SLPM_OUTPUT_HIGH	(PIN_SLPM_DIR_OUTPUT | PIN_SLPM_VAL_HIGH)
 
-#define PIN_CFG_DEFAULT		(PIN_PULL_NONE | PIN_SLPM_INPUT)
+#define PIN_CFG_DEFAULT		(0)
 
 #define PIN_CFG(num, alt)		\
 	(PIN_CFG_DEFAULT |\
 	 (PIN_NUM(num) | PIN_##alt))
 
+#define PIN_CFG_INPUT(num, alt, pull)		\
+	(PIN_CFG_DEFAULT |\
+	 (PIN_NUM(num) | PIN_##alt | PIN_INPUT_##pull))
+
+#define PIN_CFG_OUTPUT(num, alt, val)		\
+	(PIN_CFG_DEFAULT |\
+	 (PIN_NUM(num) | PIN_##alt | PIN_OUTPUT_##val))
+
 #define PIN_CFG_PULL(num, alt, pull)	\
 	((PIN_CFG_DEFAULT & ~PIN_PULL_MASK) |\
 	 (PIN_NUM(num) | PIN_##alt | PIN_PULL_##pull))
 
-extern int nmk_config_pin(pin_cfg_t cfg);
+extern int nmk_config_pin(pin_cfg_t cfg, bool sleep);
 extern int nmk_config_pins(pin_cfg_t *cfgs, int num);
+extern int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num);
 
 #endif
-- 
1.7.2.dirty

