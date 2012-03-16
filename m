Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031878Ab2CPNjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:39:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37246 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761162Ab2CPNiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:22 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>
Subject: [PATCH 2/2] Input: omap-keypad: dynamically handle register offsets
Date: Fri, 16 Mar 2012 19:09:19 +0530
Message-ID: <1331905159-11255-3-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
References: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: G, Manjunath Kondaiah <manjugk@ti.com>

Keypad controller register offsets are different for omap4
and omap5. Handle these offsets through static mapping and
assign these mappings during run time.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/input/keyboard/Kconfig        |    6 +-
 drivers/input/keyboard/omap4-keypad.c |  122 ++++++++++++++++++++++++++------
 2 files changed, 102 insertions(+), 26 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 1379daa..09d7d0b 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -510,10 +510,10 @@ config KEYBOARD_OMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-keypad.
 
-config KEYBOARD_OMAP4
-	tristate "TI OMAP4 keypad support"
+config KEYBOARD_OMAP4+
+	tristate "TI OMAP4+ keypad support"
 	help
-	  Say Y here if you want to use the OMAP4 keypad.
+	  Say Y here if you want to use the OMAP4+ keypad.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap4-keypad.
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index e809ac0..6872495 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -68,6 +68,11 @@
 
 #define OMAP4_MASK_IRQSTATUSDISABLE	0xFFFF
 
+enum {
+	KBD_REVISION_OMAP4 = 0,
+	KBD_REVISION_OMAP5,
+};
+
 struct omap4_keypad {
 	struct input_dev *input;
 
@@ -76,11 +81,79 @@ struct omap4_keypad {
 
 	unsigned int rows;
 	unsigned int cols;
+	unsigned int revision;
 	unsigned int row_shift;
 	unsigned char key_state[8];
 	unsigned short keymap[];
 };
 
+static int kbd_read_irqstatus(struct omap4_keypad *keypad_data, u32 offset)
+{
+	if (keypad_data->revision == KBD_REVISION_OMAP4)
+		return __raw_readl(keypad_data->base + offset);
+	else if (keypad_data->revision == KBD_REVISION_OMAP5)
+		return __raw_readl(keypad_data->base + offset + 0x0c);
+
+	return -ENODEV;
+}
+
+static int kbd_write_irqstatus(struct omap4_keypad *keypad_data,
+						u32 offset, u32 value)
+{
+	if (keypad_data->revision == KBD_REVISION_OMAP4)
+		return __raw_writel(value, keypad_data->base + offset);
+	else if (keypad_data->revision == KBD_REVISION_OMAP5)
+		return __raw_writel(value, keypad_data->base + offset + 0x0c);
+
+	return -ENODEV;
+}
+
+static int kbd_write_irqenable(struct omap4_keypad *keypad_data,
+						u32 offset, u32 value)
+{
+	if (keypad_data->revision == KBD_REVISION_OMAP4)
+		return __raw_writel(value, keypad_data->base + offset);
+	else if (keypad_data->revision == KBD_REVISION_OMAP5)
+		return __raw_writel(value, keypad_data->base + offset + 0x0c);
+
+	return -ENODEV;
+}
+
+static int kbd_readl(struct omap4_keypad *keypad_data, u32 offset)
+{
+	if (keypad_data->revision == KBD_REVISION_OMAP4)
+		return __raw_readl(keypad_data->base + offset);
+	else if (keypad_data->revision == KBD_REVISION_OMAP5)
+		return __raw_readl(keypad_data->base + offset + 0x10);
+
+	return -ENODEV;
+}
+
+static void kbd_writel(struct omap4_keypad *keypad_data, u32 offset, u32 value)
+{
+	if (keypad_data->revision == KBD_REVISION_OMAP4)
+		__raw_writel(value, keypad_data->base + offset);
+	else if (keypad_data->revision == KBD_REVISION_OMAP5)
+		__raw_writel(value, keypad_data->base + offset + 0x10);
+}
+
+static int kbd_read_revision(struct omap4_keypad *keypad_data, u32 offset)
+{
+	int reg;
+	reg = __raw_readl(keypad_data->base + offset);
+	reg &= 0x03 << 30;
+	reg >>= 30;
+
+	switch (reg) {
+	case 1:
+		return KBD_REVISION_OMAP5;
+	case 0:
+		return KBD_REVISION_OMAP4;
+	default:
+		return -ENODEV;
+	}
+}
+
 /* Interrupt handler */
 static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 {
@@ -91,12 +164,11 @@ static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 	u32 *new_state = (u32 *) key_state;
 
 	/* Disable interrupts */
-	__raw_writel(OMAP4_VAL_IRQDISABLE,
-		     keypad_data->base + OMAP4_KBD_IRQENABLE);
+	kbd_write_irqenable(keypad_data, OMAP4_KBD_IRQENABLE,
+						OMAP4_VAL_IRQDISABLE);
 
-	*new_state = __raw_readl(keypad_data->base + OMAP4_KBD_FULLCODE31_0);
-	*(new_state + 1) = __raw_readl(keypad_data->base
-						+ OMAP4_KBD_FULLCODE63_32);
+	*new_state = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE31_0);
+	*(new_state + 1) = kbd_readl(keypad_data, OMAP4_KBD_FULLCODE63_32);
 
 	for (row = 0; row < keypad_data->rows; row++) {
 		changed = key_state[row] ^ keypad_data->key_state[row];
@@ -121,12 +193,13 @@ static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
 		sizeof(keypad_data->key_state));
 
 	/* clear pending interrupts */
-	__raw_writel(__raw_readl(keypad_data->base + OMAP4_KBD_IRQSTATUS),
-			keypad_data->base + OMAP4_KBD_IRQSTATUS);
+	kbd_write_irqstatus(keypad_data, OMAP4_KBD_IRQSTATUS,
+			kbd_read_irqstatus(keypad_data, OMAP4_KBD_IRQSTATUS));
 
 	/* enable interrupts */
-	__raw_writel(OMAP4_DEF_IRQENABLE_EVENTEN | OMAP4_DEF_IRQENABLE_LONGKEY,
-			keypad_data->base + OMAP4_KBD_IRQENABLE);
+	kbd_write_irqenable(keypad_data, OMAP4_KBD_IRQENABLE,
+			OMAP4_DEF_IRQENABLE_EVENTEN |
+				OMAP4_DEF_IRQENABLE_LONGKEY);
 
 	return IRQ_HANDLED;
 }
@@ -139,16 +212,19 @@ static int omap4_keypad_open(struct input_dev *input)
 
 	disable_irq(keypad_data->irq);
 
-	__raw_writel(OMAP4_VAL_FUNCTIONALCFG,
-			keypad_data->base + OMAP4_KBD_CTRL);
-	__raw_writel(OMAP4_VAL_DEBOUNCINGTIME,
-			keypad_data->base + OMAP4_KBD_DEBOUNCINGTIME);
-	__raw_writel(OMAP4_VAL_IRQDISABLE,
-			keypad_data->base + OMAP4_KBD_IRQSTATUS);
-	__raw_writel(OMAP4_DEF_IRQENABLE_EVENTEN | OMAP4_DEF_IRQENABLE_LONGKEY,
-			keypad_data->base + OMAP4_KBD_IRQENABLE);
-	__raw_writel(OMAP4_DEF_WUP_EVENT_ENA | OMAP4_DEF_WUP_LONG_KEY_ENA,
-			keypad_data->base + OMAP4_KBD_WAKEUPENABLE);
+	keypad_data->revision = kbd_read_revision(keypad_data,
+			OMAP4_KBD_REVISION);
+	kbd_writel(keypad_data, OMAP4_KBD_CTRL,
+			OMAP4_VAL_FUNCTIONALCFG);
+	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
+			OMAP4_VAL_DEBOUNCINGTIME);
+	kbd_write_irqstatus(keypad_data, OMAP4_KBD_IRQSTATUS,
+			OMAP4_VAL_IRQDISABLE);
+	kbd_write_irqenable(keypad_data, OMAP4_KBD_IRQENABLE,
+			OMAP4_DEF_IRQENABLE_EVENTEN |
+				OMAP4_DEF_IRQENABLE_LONGKEY);
+	kbd_writel(keypad_data, OMAP4_KBD_WAKEUPENABLE,
+			OMAP4_DEF_WUP_EVENT_ENA | OMAP4_DEF_WUP_LONG_KEY_ENA);
 
 	enable_irq(keypad_data->irq);
 
@@ -162,12 +238,12 @@ static void omap4_keypad_close(struct input_dev *input)
 	disable_irq(keypad_data->irq);
 
 	/* Disable interrupts */
-	__raw_writel(OMAP4_VAL_IRQDISABLE,
-		     keypad_data->base + OMAP4_KBD_IRQENABLE);
+	kbd_write_irqenable(keypad_data, OMAP4_KBD_IRQENABLE,
+			OMAP4_VAL_IRQDISABLE);
 
 	/* clear pending interrupts */
-	__raw_writel(__raw_readl(keypad_data->base + OMAP4_KBD_IRQSTATUS),
-			keypad_data->base + OMAP4_KBD_IRQSTATUS);
+	kbd_write_irqstatus(keypad_data, OMAP4_KBD_IRQSTATUS,
+			kbd_read_irqstatus(keypad_data, OMAP4_KBD_IRQSTATUS));
 
 	enable_irq(keypad_data->irq);
 
-- 
1.7.1

