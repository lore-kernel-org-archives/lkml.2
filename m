Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2LLVkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:40:19 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47652 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2LLVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:40:16 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>, Roland Stigge <stigge@antcom.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH 5/5] Input: Add ChromeOS EC keyboard driver
Date: Wed, 12 Dec 2012 13:33:48 -0800
Message-Id: <1355348028-19017-6-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1355348028-19017-1-git-send-email-sjg@chromium.org>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the key-matrix layer to interpret key scan information from the EC
and inject input based on the FDT-supplied key map. This driver registers
itself with the ChromeOS EC driver to perform communications.

Additional FDT bindings are provided to specify rows/columns and the
auto-repeat information.

Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 .../devicetree/bindings/input/cros-ec-keyb.txt     |   77 ++++
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/cros_ec_keyb.c              |  413 ++++++++++++++++++++
 4 files changed, 501 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
 create mode 100644 drivers/input/keyboard/cros_ec_keyb.c

diff --git a/Documentation/devicetree/bindings/input/cros-ec-keyb.txt b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
new file mode 100644
index 0000000..67f51d8
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/cros-ec-keyb.txt
@@ -0,0 +1,77 @@
+ChromeOS EC Keyboard
+
+Google's ChromeOS EC Keyboard is a simple matrix keyboard implemented on
+a separate EC (Embedded Controller) device. It provides a message for reading
+key scans from the EC. These are then converted into keycodes for processing
+by the kernel.
+
+Required properties:
+- compatible: "google,cros-ec-keyb"
+- google,key-rows: Number of keyboard rows (must be <= 8)
+- google,key-columns: Number of keyboard columns (must be <= 13)
+- google,repeat-delay-ms: Key repeat delay in milliseconds
+- google,repeat-rate-ms: Key repeat rate in milliseconds
+- linux.keymap: Key map as for matrix-keypad.txt
+
+Optional properties:
+- google,needs-ghost-filter: True to enable a ghost filter for the matrix
+keyboard. This is recommended if the EC does not have its own logic or
+hardware for this.
+
+
+Example:
+
+cros-ec-keyb {
+	compatible = "google,cros-ec-keyb";
+	google,key-rows = <8>;
+	google,key-columns = <13>;
+	google,repeat-delay-ms = <600>;
+	google,repeat-rate-ms = <60>;
+	google,needs-ghost-filter;
+	/*
+	 * Keymap entries take the form of 0xRRCCKKKK where
+	 * RR=Row CC=Column KKKK=Key Code
+	 * The values below are for a US keyboard layout and
+	 * are taken from the Linux driver. Note that the
+	 * 102ND key is not used for US keyboards.
+	 */
+	linux,keymap = <
+		/* CAPSLCK F1         B          F10     */
+		0x0001003a 0x0002003b 0x00030030 0x00040044
+		/* N       =          R_ALT      ESC     */
+		0x00060031 0x0008000d 0x000a0064 0x01010001
+		/* F4      G          F7         H       */
+		0x0102003e 0x01030022 0x01040041 0x01060023
+		/* '       F9         BKSPACE    L_CTRL  */
+		0x01080028 0x01090043 0x010b000e 0x0200001d
+		/* TAB     F3         T          F6      */
+		0x0201000f 0x0202003d 0x02030014 0x02040040
+		/* ]       Y          102ND      [       */
+		0x0205001b 0x02060015 0x02070056 0x0208001a
+		/* F8      GRAVE      F2         5       */
+		0x02090042 0x03010029 0x0302003c 0x03030006
+		/* F5      6          -          \       */
+		0x0304003f 0x03060007 0x0308000c 0x030b002b
+		/* R_CTRL  A          D          F       */
+		0x04000061 0x0401001e 0x04020020 0x04030021
+		/* S       K          J          ;       */
+		0x0404001f 0x04050025 0x04060024 0x04080027
+		/* L       ENTER      Z          C       */
+		0x04090026 0x040b001c 0x0501002c 0x0502002e
+		/* V       X          ,          M       */
+		0x0503002f 0x0504002d 0x05050033 0x05060032
+		/* L_SHIFT /          .          SPACE   */
+		0x0507002a 0x05080035 0x05090034 0x050B0039
+		/* 1       3          4          2       */
+		0x06010002 0x06020004 0x06030005 0x06040003
+		/* 8       7          0          9       */
+		0x06050009 0x06060008 0x0608000b 0x0609000a
+		/* L_ALT   DOWN       RIGHT      Q       */
+		0x060a0038 0x060b006c 0x060c006a 0x07010010
+		/* E       R          W          I       */
+		0x07020012 0x07030013 0x07040011 0x07050017
+		/* U       R_SHIFT    P          O       */
+		0x07060016 0x07070036 0x07080019 0x07090018
+		/* UP      LEFT    */
+		0x070b0067 0x070c0069>;
+};
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 7ccd652..eb16434 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -617,4 +617,14 @@ config KEYBOARD_W90P910
 	  To compile this driver as a module, choose M here: the
 	  module will be called w90p910_keypad.
 
+config KEYBOARD_CROS_EC
+	tristate "ChromeOS EC keyboard"
+	select INPUT_MATRIXKMAP
+	help
+	  Say Y here to enable the matrix keyboard used by ChromeOS devices
+	  and implemented on the ChromeOS EC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cros_ec_keyb.
+
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 44e7600..61b739c 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_KEYBOARD_AMIGA)		+= amikbd.o
 obj-$(CONFIG_KEYBOARD_ATARI)		+= atakbd.o
 obj-$(CONFIG_KEYBOARD_ATKBD)		+= atkbd.o
 obj-$(CONFIG_KEYBOARD_BFIN)		+= bf54x-keys.o
+obj-$(CONFIG_KEYBOARD_CROS_EC)		+= cros_ec_keyb.o
 obj-$(CONFIG_KEYBOARD_DAVINCI)		+= davinci_keyscan.o
 obj-$(CONFIG_KEYBOARD_EP93XX)		+= ep93xx_keypad.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
new file mode 100644
index 0000000..d7dc9f3
--- /dev/null
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -0,0 +1,413 @@
+/*
+ * ChromeOS EC keyboard driver
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver uses the Chrome OS EC byte-level message-based protocol for
+ * communicating the keyboard state (which keys are pressed) from a keyboard EC
+ * to the AP over some bus (such as i2c, lpc, spi).  The EC does debouncing,
+ * but everything else (including deghosting) is done here.  The main
+ * motivation for this is to keep the EC firmware as simple as possible, since
+ * it cannot be easily upgraded and EC flash/IRAM space is relatively
+ * expensive.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/input/matrix_keypad.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+
+/*
+ * @rows: Number of rows in the keypad
+ * @cols: Number of columns in the keypad
+ * @row_shift: log2 or number of rows, rounded up
+ * @keymap_data: Matrix keymap data used to convert to keyscan values
+ * @ghost_filter: true to enable the matrix key-ghosting filter
+ * @old_state: Previous state of the keyboard matrix (used to calc deltas)
+ * @dev: Device pointer
+ * @idev: Input device
+ * @ec: Top level ChromeOS device to use to talk to EC
+ * @event_notifier: interrupt event notifier for transport devices
+ * @wake_notifier: wake notfier for client devices (e.g. keyboard). This
+ *	indicates to sub-drivers that we have woken up from resume but we
+ *	were not a wakeup source.
+ */
+struct cros_ec_keyb {
+	int rows;
+	int cols;
+	int row_shift;
+	const struct matrix_keymap_data *keymap_data;
+	bool ghost_filter;
+	/*
+	 * old_state[matrix code] is 1 when the most recent (valid)
+	 * communication with the keyboard indicated that the key at row/col
+	 * was in the pressed state.
+	 */
+	uint8_t *old_state;
+
+	struct device *dev;
+	struct input_dev *idev;
+	struct cros_ec_device *ec;
+	struct notifier_block notifier;
+	struct notifier_block wake_notifier;
+};
+
+
+/*
+ * Sends a single key event to the input layer.
+ */
+static inline void cros_ec_keyb_send_key_event(struct cros_ec_keyb *ckdev,
+				int row, int col, int pressed)
+{
+	struct input_dev *idev = ckdev->idev;
+	int code = MATRIX_SCAN_CODE(row, col, ckdev->row_shift);
+	const unsigned short *keycodes = idev->keycode;
+
+	input_report_key(idev, keycodes[code], pressed);
+}
+
+/*
+ * Returns true when there is at least one combination of pressed keys that
+ * results in ghosting.
+ */
+static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, uint8_t *buf)
+{
+	int col, row;
+	int mask;
+	int pressed_in_row[ckdev->rows];
+	int row_has_teeth[ckdev->rows];
+
+	memset(pressed_in_row, '\0', sizeof(pressed_in_row));
+	memset(row_has_teeth, '\0', sizeof(row_has_teeth));
+	/*
+	 * Ghosting happens if for any pressed key X there are other keys
+	 * pressed both in the same row and column of X as, for instance,
+	 * in the following diagram:
+	 *
+	 * . . Y . g .
+	 * . . . . . .
+	 * . . . . . .
+	 * . . X . Z .
+	 *
+	 * In this case only X, Y, and Z are pressed, but g appears to be
+	 * pressed too (see Wikipedia).
+	 *
+	 * We can detect ghosting in a single pass (*) over the keyboard state
+	 * by maintaining two arrays.  pressed_in_row counts how many pressed
+	 * keys we have found in a row.  row_has_teeth is true if any of the
+	 * pressed keys for this row has other pressed keys in its column.  If
+	 * at any point of the scan we find that a row has multiple pressed
+	 * keys, and at least one of them is at the intersection with a column
+	 * with multiple pressed keys, we're sure there is ghosting.
+	 * Conversely, if there is ghosting, we will detect such situation for
+	 * at least one key during the pass.
+	 *
+	 * (*) This looks linear in the number of keys, but it's not.  We can
+	 * cheat because the number of rows is small.
+	 */
+	for (row = 0; row < ckdev->rows; row++) {
+		mask = 1 << row;
+		for (col = 0; col < ckdev->cols; col++) {
+			if (buf[col] & mask) {
+				pressed_in_row[row] += 1;
+				row_has_teeth[row] |= buf[col] & ~mask;
+				if (pressed_in_row[row] > 1 &&
+				    row_has_teeth[row]) {
+					/* ghosting */
+					dev_dbg(ckdev->dev,
+						"ghost found at: r%d c%d,"
+						" pressed %d, teeth 0x%x\n",
+						row, col, pressed_in_row[row],
+						row_has_teeth[row]);
+					return true;
+				}
+			}
+		}
+	}
+	return false;
+}
+
+/*
+ * Compares the new keyboard state to the old one and produces key
+ * press/release events accordingly.  The keyboard state is 13 bytes (one byte
+ * per column)
+ */
+static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
+			 uint8_t *kb_state, int len)
+{
+	int col, row;
+	int new_state;
+	int num_cols;
+
+	num_cols = len;
+
+	if (ckdev->ghost_filter && cros_ec_keyb_has_ghosting(ckdev, kb_state)) {
+		/*
+		 * Simple-minded solution: ignore this state. The obvious
+		 * improvement is to only ignore changes to keys involved in
+		 * the ghosting, but process the other changes.
+		 */
+		dev_dbg(ckdev->dev, "ghosting found\n");
+		return;
+	}
+
+	for (col = 0; col < ckdev->cols; col++) {
+		for (row = 0; row < ckdev->rows; row++) {
+			int code = MATRIX_SCAN_CODE(row, col, ckdev->row_shift);
+
+			new_state = kb_state[col] & (1 << row);
+			if (!!new_state != ckdev->old_state[code]) {
+				dev_dbg(ckdev->dev,
+					"changed: [r%d c%d]: byte %02x\n",
+					row, col, new_state);
+			}
+			if (new_state && !ckdev->old_state[code]) {
+				/* key press */
+				cros_ec_keyb_send_key_event(ckdev, row, col, 1);
+				ckdev->old_state[code] = 1;
+			} else if (!new_state && ckdev->old_state[code]) {
+				/* key release */
+				cros_ec_keyb_send_key_event(ckdev, row, col, 0);
+				ckdev->old_state[code] = 0;
+			}
+		}
+	}
+	input_sync(ckdev->idev);
+}
+
+static int cros_ec_keyb_open(struct input_dev *dev)
+{
+	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
+	int ret;
+
+	ret = blocking_notifier_chain_register(&ckdev->ec->event_notifier,
+						&ckdev->notifier);
+	if (ret)
+		return ret;
+	ret = blocking_notifier_chain_register(&ckdev->ec->wake_notifier,
+						&ckdev->wake_notifier);
+	if (ret) {
+		blocking_notifier_chain_unregister(
+			&ckdev->ec->event_notifier, &ckdev->notifier);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void cros_ec_keyb_close(struct input_dev *dev)
+{
+	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
+
+	blocking_notifier_chain_unregister(&ckdev->ec->event_notifier,
+					   &ckdev->notifier);
+	blocking_notifier_chain_unregister(&ckdev->ec->wake_notifier,
+					   &ckdev->wake_notifier);
+}
+
+static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
+{
+	return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
+					  kb_state, ckdev->cols);
+}
+
+static int cros_ec_keyb_work(struct notifier_block *nb,
+		     unsigned long state, void *_notify)
+{
+	int ret;
+	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
+						    notifier);
+	uint8_t kb_state[ckdev->cols];
+
+	ret = cros_ec_keyb_get_state(ckdev, kb_state);
+	if (ret >= 0)
+		cros_ec_keyb_process(ckdev, kb_state, ret);
+
+	return NOTIFY_DONE;
+}
+
+/* On resume, clear any keys in the buffer */
+static int cros_ec_keyb_clear_keyboard(struct notifier_block *nb,
+			       unsigned long state, void *_notify)
+{
+	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
+						    wake_notifier);
+	uint8_t old_state[ckdev->cols];
+	uint8_t new_state[ckdev->cols];
+	unsigned long duration;
+	int i, ret;
+
+	/*
+	 * Keep reading until we see that the scan state does not change.
+	 * That indicates that we are done.
+	 *
+	 * Assume that the EC keyscan buffer is at most 32 deep.
+	 */
+	duration = jiffies;
+	ret = cros_ec_keyb_get_state(ckdev, new_state);
+	for (i = 1; !ret && i < 32; i++) {
+		memcpy(old_state, new_state, sizeof(old_state));
+		ret = cros_ec_keyb_get_state(ckdev, new_state);
+		if (0 == memcmp(old_state, new_state, sizeof(old_state)))
+			break;
+	}
+	duration = jiffies - duration;
+	dev_info(ckdev->dev, "Discarded %d keyscan(s) in %dus\n", i,
+		jiffies_to_usecs(duration));
+
+	return 0;
+}
+
+static const struct of_device_id cros_ec_kbc_of_match[] = {
+	{ .compatible = "google,cros-ec-keyb", },
+	{ },
+};
+
+static int __devinit cros_ec_keyb_probe(struct platform_device *pdev)
+{
+	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
+	struct device *dev = ec->dev;
+	struct cros_ec_keyb *ckdev = NULL;
+	struct input_dev *idev = NULL;
+	struct device_node *np;
+	u32 value;
+	int err;
+
+	np = of_find_matching_node(NULL, cros_ec_kbc_of_match);
+	if (!np) {
+		dev_err(dev, "no device tree data\n");
+		return -EINVAL;
+	}
+
+	ckdev = kzalloc(sizeof(*ckdev), GFP_KERNEL);
+	if (!ckdev) {
+		dev_err(dev, "cannot allocate memory for ckdev\n");
+		return -ENOMEM;
+	}
+	idev = input_allocate_device();
+	if (!idev) {
+		err = -ENOMEM;
+		dev_err(dev, "cannot allocate memory for input device\n");
+		goto fail_alloc_dev;
+	}
+
+	ckdev->ec = ec;
+	ckdev->notifier.notifier_call = cros_ec_keyb_work;
+	ckdev->wake_notifier.notifier_call = cros_ec_keyb_clear_keyboard;
+	ckdev->dev = dev;
+	dev_set_drvdata(&pdev->dev, ckdev);
+
+	idev->name = ec->get_name(ec);
+	idev->phys = ec->get_phys_name(ec);
+	__set_bit(EV_REP, idev->evbit);
+
+	idev->id.bustype = BUS_VIRTUAL;
+	idev->id.version = 1;
+	idev->id.product = 0;
+	idev->dev.parent = &pdev->dev;
+	pdev->dev.of_node = np;
+	idev->open = cros_ec_keyb_open;
+	idev->close = cros_ec_keyb_close;
+
+	of_property_read_u32(np, "google,key-rows", &ckdev->rows);
+	of_property_read_u32(np, "google,key-columns", &ckdev->cols);
+	if (!ckdev->rows || !ckdev->cols) {
+		dev_err(dev, "number of keypad rows/columns not specified\n");
+		err = -EINVAL;
+		goto fail_props;
+	}
+	ckdev->ghost_filter = of_property_read_bool(np,
+					"google,needs-ghost-filter");
+
+	err = matrix_keypad_build_keymap(NULL, NULL, ckdev->rows, ckdev->cols,
+					 NULL, idev);
+	if (err) {
+		dev_err(dev, "cannot build key matrix\n");
+		goto fail_matrix;
+	}
+
+	ckdev->row_shift = get_count_order(ckdev->cols);
+	ckdev->old_state = kzalloc(idev->keycodemax, GFP_KERNEL);
+	if (!ckdev->old_state) {
+		dev_err(dev, "Cannot allocate memory for old_state\n");
+		err = -ENOMEM;
+		goto fail_old_state;
+	}
+
+	input_set_capability(idev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(idev, ckdev);
+	ckdev->idev = idev;
+	err = input_register_device(ckdev->idev);
+	if (err) {
+		dev_err(dev, "cannot register input device\n");
+		goto fail_register;
+	}
+
+	/*
+	 * We must change the delay after device registration, or else the
+	 * input layer assumes that the driver does its own autorepeat.
+	 */
+	if (!of_property_read_u32(np, "google,repeat-delay-ms", &value))
+		ckdev->idev->rep[REP_DELAY] = value;
+	if (!of_property_read_u32(np, "google,repeat-rate-ms", &value)) {
+		ckdev->idev->rep[REP_PERIOD] = value;
+		__set_bit(EV_REP, idev->evbit);
+	}
+
+	return 0;
+
+fail_register:
+	kfree(ckdev->old_state);
+fail_old_state:
+	kfree(idev->keycode);
+fail_matrix:
+fail_props:
+	input_free_device(idev);
+fail_alloc_dev:
+	kfree(ckdev);
+	return err;
+}
+
+static int __devexit cros_ec_keyb_remove(struct platform_device *pdev)
+{
+	struct cros_ec_keyb *ckdev = dev_get_drvdata(&pdev->dev);
+	struct input_dev *idev = ckdev->idev;
+
+	/* I believe we leak a matrix_keymap here */
+	input_unregister_device(idev);
+	kfree(ckdev->old_state);
+	kfree(idev->keycode);
+	input_free_device(idev);
+	kfree(ckdev);
+
+	return 0;
+}
+
+static struct platform_driver cros_ec_keyb_driver = {
+	.probe = cros_ec_keyb_probe,
+	.remove = cros_ec_keyb_remove,
+	.driver = {
+		.name = "cros-ec-keyb",
+	},
+};
+
+module_platform_driver(cros_ec_keyb_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ChromeOS EC keyboard driver");
+MODULE_ALIAS("platform:cros-ec-keyb");
-- 
1.7.7.3

