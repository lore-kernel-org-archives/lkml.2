Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab1AMS0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:26:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6772 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1AMS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:26:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 13 Jan 2011 10:26:04 -0800
From: riyer@nvidia.com
To: tsoni@codeaurora.org, dmitry.torokhov@gmail.com, pavel@ucw.cz,
        shubhrajyoti@ti.com, ccross@android.com, konkers@android.com
Cc: olof@lixom.net, achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
Date: Thu, 13 Jan 2011 10:27:28 -0800
Message-Id: <1294943248-18631-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

This patch adds support for the internal matrix keyboard controller for
Nvidia Tegra platforms.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
Changes Done -
Wrap the users field check within the mutex.
Remove the KBC_MAX_KEYS define and use existing KBC_MAX_KEY.
Patch v4 was named incorrectly as PATCH 1/1, so skipping ahead to PATCH v5.

 arch/arm/mach-tegra/include/mach/kbc.h |   61 +++
 drivers/input/keyboard/Kconfig         |   10 +
 drivers/input/keyboard/Makefile        |    1 +
 drivers/input/keyboard/tegra-kbc.c     |  634 ++++++++++++++++++++++++++++++++
 4 files changed, 706 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/kbc.h
 create mode 100644 drivers/input/keyboard/tegra-kbc.c

diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
new file mode 100644
index 0000000..029a468
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/kbc.h
@@ -0,0 +1,61 @@
+/*
+ * kbc.h
+ *
+ * Platform definitions for tegra-kbc keyboard input driver
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef ASMARM_ARCH_TEGRA_KBC_H
+#define ASMARM_ARCH_TEGRA_KBC_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+#define KBC_MAX_GPIO 24
+#define KBC_MAX_KPENT 8
+#else
+#define KBC_MAX_GPIO 20
+#define KBC_MAX_KPENT 7
+#endif
+
+#define KBC_MAX_ROW 16
+#define KBC_MAX_COL 8
+
+#define KBC_MAX_KEY (KBC_MAX_ROW*KBC_MAX_COL)
+
+struct tegra_kbc_pin_cfg {
+	bool is_row;
+	bool is_col;
+	unsigned char num;
+};
+
+struct tegra_kbc_wake_key {
+	u8 row:4;
+	u8 col:4;
+};
+
+struct tegra_kbc_platform_data {
+	unsigned int debounce_cnt;
+	unsigned int repeat_cnt;
+	int wake_cnt; /* 0:wake on any key >1:wake on wake_cfg */
+	int *keycode;
+	bool wakeup;
+	struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
+	struct tegra_kbc_wake_key *wake_cfg;
+};
+#endif
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 9cc488d..8be47da 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -327,6 +327,16 @@ config KEYBOARD_NEWTON
 	  To compile this driver as a module, choose M here: the
 	  module will be called newtonkbd.
 
+config KEYBOARD_TEGRA
+	tristate "NVIDIA Tegra internal matrix keyboard controller support"
+	depends on ARCH_TEGRA
+	help
+	  Say Y here if you want to use a matrix keyboard connected directly
+	  to the internal keyboard controller on Tegra SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tegra-kbc.
+
 config KEYBOARD_OPENCORES
 	tristate "OpenCores Keyboard Controller"
 	help
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 504b591..ac0dcb9 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_KEYBOARD_SH_KEYSC)		+= sh_keysc.o
 obj-$(CONFIG_KEYBOARD_STMPE)		+= stmpe-keypad.o
 obj-$(CONFIG_KEYBOARD_STOWAWAY)		+= stowaway.o
 obj-$(CONFIG_KEYBOARD_SUNKBD)		+= sunkbd.o
+obj-$(CONFIG_KEYBOARD_TEGRA)		+= tegra-kbc.o
 obj-$(CONFIG_KEYBOARD_TWL4030)		+= twl4030_keypad.o
 obj-$(CONFIG_KEYBOARD_XTKBD)		+= xtkbd.o
 obj-$(CONFIG_KEYBOARD_W90P910)		+= w90p910_keypad.o
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
new file mode 100644
index 0000000..02c8ece
--- /dev/null
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -0,0 +1,634 @@
+/*
+ * tegra-kbc.c
+ *
+ * Keyboard class input driver for the NVIDIA Tegra SoC internal matrix
+ * keyboard controller
+ *
+ * Copyright (c) 2009-2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <mach/clk.h>
+#include <mach/kbc.h>
+
+#define KBC_MAX_DEBOUNCE_CNT	0x3fful
+
+/* KBC row scan time and delay for beginning the row scan. */
+#define KBC_ROW_SCAN_TIME	16
+#define KBC_ROW_SCAN_DLY	5
+
+/* KBC uses a 32KHz clock so a cycle = 1/32Khz */
+#define KBC_CYCLE_USEC	32
+
+/* KBC Registers */
+
+/* KBC Control Register */
+#define KBC_CONTROL_0	0x0
+#define KBC_FIFO_TH_CNT_SHIFT(cnt)	(cnt << 14)
+#define KBC_DEBOUNCE_CNT_SHIFT(cnt)	(cnt << 4)
+#define KBC_CONTROL_FIFO_CNT_INT_EN	(1 << 3)
+#define KBC_CONTROL_KBC_EN		(1 << 0)
+
+/* KBC Interrupt Register */
+#define KBC_INT_0	0x4
+#define KBC_INT_FIFO_CNT_INT_STATUS	(1 << 2)
+
+#define KBC_ROW_CFG0_0	0x8
+#define KBC_COL_CFG0_0	0x18
+#define KBC_INIT_DLY_0	0x28
+#define KBC_RPT_DLY_0	0x2c
+#define KBC_KP_ENT0_0	0x30
+#define KBC_KP_ENT1_0	0x34
+#define KBC_ROW0_MASK_0	0x38
+
+struct tegra_kbc {
+	void __iomem *mmio;
+	struct input_dev *idev;
+	int irq;
+	unsigned int wake_enable_rows;
+	unsigned int wake_enable_cols;
+	spinlock_t lock;
+	unsigned int repoll_dly;
+	unsigned long cp_dly_jiffies;
+	int fifo[KBC_MAX_KPENT];
+	const struct tegra_kbc_platform_data *pdata;
+	int keycode[KBC_MAX_KEY];
+	struct timer_list timer;
+	struct clk *clk;
+};
+
+static int tegra_kbd_keycode[KBC_MAX_KEY] = {
+	KEY_RESERVED, KEY_RESERVED, KEY_W, KEY_S,
+		KEY_A, KEY_Z, KEY_RESERVED, KEY_FN,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+		KEY_RESERVED, KEY_RESERVED, KEY_RIGHTALT, KEY_LEFTALT,
+	KEY_5, KEY_4, KEY_R, KEY_E,
+		KEY_F, KEY_D, KEY_X, KEY_RESERVED,
+	KEY_7, KEY_6, KEY_T, KEY_H,
+		KEY_G, KEY_V, KEY_C, KEY_SPACE,
+	KEY_9, KEY_8, KEY_U, KEY_Y,
+		KEY_J, KEY_N, KEY_B, KEY_BACKSLASH,
+	KEY_MINUS, KEY_0, KEY_O, KEY_I,
+		KEY_L, KEY_K, KEY_COMMA, KEY_M,
+	KEY_RESERVED, KEY_EQUAL, KEY_RIGHTBRACE, KEY_ENTER,
+		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+		KEY_RIGHTSHIFT, KEY_LEFTSHIFT, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+		KEY_RESERVED, KEY_RIGHTCTRL, KEY_RESERVED, KEY_LEFTCTRL,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_LEFTBRACE, KEY_P, KEY_APOSTROPHE, KEY_SEMICOLON,
+		KEY_SLASH, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
+	KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
+		KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,
+	KEY_INSERT, KEY_DELETE, KEY_RESERVED, KEY_PAGEUP,
+		KEY_PAGEDOWN, KEY_RIGHT, KEY_DOWN, KEY_LEFT,
+	KEY_F11, KEY_F12, KEY_F8, KEY_Q,
+		KEY_F4, KEY_F3, KEY_1, KEY_F7,
+	KEY_ESC, KEY_GRAVE, KEY_F5, KEY_TAB,
+		KEY_F1, KEY_F2, KEY_CAPSLOCK, KEY_F6
+};
+
+static void tegra_kbc_report_keys(struct tegra_kbc *kbc, int *fifo)
+{
+	int curr_fifo[KBC_MAX_KPENT];
+	int rows_val[KBC_MAX_KPENT], cols_val[KBC_MAX_KPENT];
+	u32 kp_ent_val[(KBC_MAX_KPENT + 3) / 4];
+	u32 *kp_ents = kp_ent_val;
+	u32 kp_ent = 0;
+	unsigned long flags;
+	int i, j, valid = 0;
+
+	spin_lock_irqsave(&kbc->lock, flags);
+	for (i = 0; i < ARRAY_SIZE(kp_ent_val); i++)
+		kp_ent_val[i] = readl(kbc->mmio + KBC_KP_ENT0_0 + (i*4));
+	spin_unlock_irqrestore(&kbc->lock, flags);
+
+	valid = 0;
+	for (i = 0; i < KBC_MAX_KPENT; i++) {
+		if (!(i&3))
+			kp_ent = *kp_ents++;
+
+		if (kp_ent & 0x80) {
+			cols_val[valid] = kp_ent & 0x7;
+			rows_val[valid++] = (kp_ent >> 3) & 0xf;
+		}
+		kp_ent >>= 8;
+	}
+
+	j = 0;
+	for (i = 0; i < valid; i++) {
+		int k = kbc->keycode[(rows_val[i] * KBC_MAX_COL) + cols_val[i]];
+		if (likely(k != -1))
+			curr_fifo[j++] = k;
+	}
+	valid = j;
+
+	for (i = 0; i < KBC_MAX_KPENT; i++) {
+		if (fifo[i] == -1)
+			continue;
+		for (j = 0; j < valid; j++) {
+			if (curr_fifo[j] == fifo[i]) {
+				curr_fifo[j] = -1;
+				break;
+			}
+		}
+		if (j == valid) {
+			input_report_key(kbc->idev, fifo[i], 0);
+			fifo[i] = -1;
+		}
+	}
+	for (j = 0; j < valid; j++) {
+		if (curr_fifo[j] == -1)
+			continue;
+		for (i = 0; i < KBC_MAX_KPENT; i++) {
+			if (fifo[i] == -1)
+				break;
+		}
+		if (i != KBC_MAX_KPENT) {
+			fifo[i] = curr_fifo[j];
+			input_report_key(kbc->idev, fifo[i], 1);
+		} else
+			WARN_ON(1);
+	}
+}
+
+static void tegra_kbc_keypress_timer(unsigned long data)
+{
+	struct tegra_kbc *kbc = (struct tegra_kbc *)data;
+	unsigned long flags;
+	u32 val;
+	int i;
+
+	val = (readl(kbc->mmio + KBC_INT_0) >> 4) & 0xf;
+	if (val) {
+		unsigned long dly;
+
+		tegra_kbc_report_keys(kbc, kbc->fifo);
+
+		/* If more than one keys are pressed we need not wait
+		 * for the repoll delay. */
+		dly = (val == 1) ? kbc->repoll_dly : 1;
+		mod_timer(&kbc->timer, jiffies + msecs_to_jiffies(dly));
+	} else {
+		/* release any pressed keys and exit the loop */
+		for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++) {
+			if (kbc->fifo[i] == -1)
+				continue;
+			input_report_key(kbc->idev, kbc->fifo[i], 0);
+			kbc->fifo[i] = -1;
+		}
+
+		/* All keys are released so enable the keypress interrupt */
+		spin_lock_irqsave(&kbc->lock, flags);
+		val = readl(kbc->mmio + KBC_CONTROL_0);
+		val |= KBC_CONTROL_FIFO_CNT_INT_EN;
+		writel(val, kbc->mmio + KBC_CONTROL_0);
+		spin_unlock_irqrestore(&kbc->lock, flags);
+	}
+}
+
+static void tegra_kbc_close(struct input_dev *dev)
+{
+	struct tegra_kbc *kbc = input_get_drvdata(dev);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&kbc->lock, flags);
+	val = readl(kbc->mmio + KBC_CONTROL_0);
+	val &= ~1;
+	writel(val, kbc->mmio + KBC_CONTROL_0);
+	spin_unlock_irqrestore(&kbc->lock, flags);
+
+	clk_disable(kbc->clk);
+}
+
+static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
+{
+	int i;
+	unsigned int rst_val;
+
+	BUG_ON(kbc->pdata->wake_cnt > KBC_MAX_KEY);
+	rst_val = (filter && kbc->pdata->wake_cnt) ? ~0 : 0;
+
+	for (i = 0; i < KBC_MAX_ROW; i++)
+		writel(rst_val, kbc->mmio+KBC_ROW0_MASK_0+i*4);
+
+	if (filter) {
+		for (i = 0; i < kbc->pdata->wake_cnt; i++) {
+			u32 val, addr;
+			addr = kbc->pdata->wake_cfg[i].row*4 + KBC_ROW0_MASK_0;
+			val = readl(kbc->mmio + addr);
+			val &= ~(1<<kbc->pdata->wake_cfg[i].col);
+			writel(val, kbc->mmio + addr);
+		}
+	}
+}
+
+static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
+{
+	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
+	int i;
+
+	for (i = 0; i < KBC_MAX_GPIO; i++) {
+		u32 row_cfg, col_cfg;
+		u32 r_shift = 5 * (i%6);
+		u32 c_shift = 4 * (i%8);
+		u32 r_mask = 0x1f << r_shift;
+		u32 c_mask = 0xf << c_shift;
+		u32 r_offs = (i / 6) * 4 + KBC_ROW_CFG0_0;
+		u32 c_offs = (i / 8) * 4 + KBC_COL_CFG0_0;
+
+		row_cfg = readl(kbc->mmio + r_offs);
+		col_cfg = readl(kbc->mmio + c_offs);
+
+		row_cfg &= ~r_mask;
+		col_cfg &= ~c_mask;
+
+		if (pdata->pin_cfg[i].is_row)
+			row_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << r_shift;
+		else if (pdata->pin_cfg[i].is_col)
+			col_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << c_shift;
+
+		writel(row_cfg, kbc->mmio + r_offs);
+		writel(col_cfg, kbc->mmio + c_offs);
+	}
+}
+
+static int tegra_kbc_open(struct input_dev *dev)
+{
+	struct tegra_kbc *kbc = input_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int debounce_cnt;
+	u32 val = 0;
+
+	clk_enable(kbc->clk);
+
+	/* Reset the KBC controller to clear all previous status.*/
+	tegra_periph_reset_assert(kbc->clk);
+	udelay(100);
+	tegra_periph_reset_deassert(kbc->clk);
+	udelay(100);
+
+	tegra_kbc_config_pins(kbc);
+	tegra_kbc_setup_wakekeys(kbc, false);
+
+	writel(kbc->pdata->repeat_cnt, kbc->mmio + KBC_RPT_DLY_0);
+
+	/* Keyboard debounce count is maximum of 12 bits. */
+	debounce_cnt = kbc->pdata->debounce_cnt;
+	debounce_cnt = min_t(unsigned int, debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
+	val = KBC_DEBOUNCE_CNT_SHIFT(debounce_cnt);
+	val |= KBC_FIFO_TH_CNT_SHIFT(1); /* set fifo interrupt threshold to 1 */
+	val |= KBC_CONTROL_FIFO_CNT_INT_EN;  /* interrupt on FIFO threshold */
+	val |= KBC_CONTROL_KBC_EN;     /* enable */
+	writel(val, kbc->mmio + KBC_CONTROL_0);
+
+	/* Compute the delay(ns) from interrupt mode to continuous polling mode
+	 * so the timer routine is scheduled appropriately. */
+	val = readl(kbc->mmio + KBC_INIT_DLY_0);
+	kbc->cp_dly_jiffies = usecs_to_jiffies((val & 0xfffff) * 32);
+
+	/* atomically clear out any remaining entries in the key FIFO
+	 * and enable keyboard interrupts */
+	spin_lock_irqsave(&kbc->lock, flags);
+	while (1) {
+		val = readl(kbc->mmio + KBC_INT_0);
+		val >>= 4;
+		if (val) {
+			val = readl(kbc->mmio + KBC_KP_ENT0_0);
+			val = readl(kbc->mmio + KBC_KP_ENT1_0);
+		} else {
+			break;
+		}
+	}
+	writel(0x7, kbc->mmio + KBC_INT_0);
+	spin_unlock_irqrestore(&kbc->lock, flags);
+
+	return 0;
+}
+
+
+static int __devexit tegra_kbc_remove(struct platform_device *pdev)
+{
+	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	free_irq(kbc->irq, pdev);
+	del_timer_sync(&kbc->timer);
+	clk_disable(kbc->clk);
+	clk_put(kbc->clk);
+
+	input_unregister_device(kbc->idev);
+	iounmap(kbc->mmio);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(kbc);
+	return 0;
+}
+
+static irqreturn_t tegra_kbc_isr(int irq, void *args)
+{
+	struct tegra_kbc *kbc = args;
+	u32 val, ctl;
+
+	/* until all keys are released, defer further processing to
+	 * the polling loop in tegra_kbc_keypress_timer */
+	ctl = readl(kbc->mmio + KBC_CONTROL_0);
+	ctl &= ~KBC_CONTROL_FIFO_CNT_INT_EN;
+	writel(ctl, kbc->mmio + KBC_CONTROL_0);
+
+	/* quickly bail out & reenable interrupts if the fifo threshold count
+	 * interrupt wasn't the interrupt source */
+	val = readl(kbc->mmio + KBC_INT_0);
+	writel(val, kbc->mmio + KBC_INT_0);
+
+	if (!(val & KBC_INT_FIFO_CNT_INT_STATUS)) {
+		ctl |= KBC_CONTROL_FIFO_CNT_INT_EN;
+		writel(ctl, kbc->mmio + KBC_CONTROL_0);
+		return IRQ_HANDLED;
+	}
+
+	/* Schedule timer to run when hardware is in continuous polling mode. */
+	mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
+	return IRQ_HANDLED;
+}
+
+static int __devinit tegra_kbc_probe(struct platform_device *pdev)
+{
+	struct tegra_kbc *kbc;
+	const struct tegra_kbc_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *res;
+	int irq;
+	int err;
+	int rows[KBC_MAX_ROW];
+	int cols[KBC_MAX_COL];
+	int i, j;
+	int num_rows = 0;
+	unsigned int debounce_cnt;
+	unsigned int scan_time_rows;
+
+	if (!pdata)
+		return -EINVAL;
+
+	kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
+	if (!kbc)
+		return -ENOMEM;
+
+	kbc->pdata = pdata;
+	kbc->irq = -EINVAL;
+
+	memset(rows, 0, sizeof(rows));
+	memset(cols, 0, sizeof(cols));
+
+	kbc->idev = input_allocate_device();
+	if (!kbc->idev) {
+		err = -ENOMEM;
+		goto fail_allocateinput;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get I/O memory\n");
+		err = -ENXIO;
+		goto fail_memoryresource;
+	}
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		err = -EBUSY;
+		goto fail_memoryresource;
+	}
+	kbc->mmio = ioremap(res->start, resource_size(res));
+	if (!kbc->mmio) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		err = -ENXIO;
+		goto fail_memoryresource;
+	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get keyboard IRQ\n");
+		err = -ENXIO;
+		goto fail_keyboardresource;
+	}
+	kbc->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR_OR_NULL(kbc->clk)) {
+		dev_err(&pdev->dev, "failed to get keyboard clock\n");
+		err = (kbc->clk) ? PTR_ERR(kbc->clk) : -ENODEV;
+		kbc->clk = NULL;
+		goto fail_keyboardresource;
+	}
+
+	platform_set_drvdata(pdev, kbc);
+
+	kbc->idev->name = pdev->name;
+	input_set_drvdata(kbc->idev, kbc);
+	kbc->idev->id.bustype = BUS_HOST;
+	kbc->idev->open = tegra_kbc_open;
+	kbc->idev->close = tegra_kbc_close;
+	kbc->idev->dev.parent = &pdev->dev;
+	spin_lock_init(&kbc->lock);
+
+	for (i = 0; i < KBC_MAX_GPIO; i++) {
+		if (pdata->pin_cfg[i].is_row && pdata->pin_cfg[i].is_col) {
+			dev_err(&pdev->dev, "invalid pin configuration data\n");
+			err = -EINVAL;
+			goto fail_configurekeyboard;
+		}
+
+		if (pdata->pin_cfg[i].is_row) {
+			if (pdata->pin_cfg[i].num >= KBC_MAX_ROW) {
+				dev_err(&pdev->dev, "invalid row number\n");
+				err = -EINVAL;
+				goto fail_configurekeyboard;
+			}
+			rows[pdata->pin_cfg[i].num] = 1;
+			num_rows++;
+		} else if (pdata->pin_cfg[i].is_col) {
+			if (pdata->pin_cfg[i].num >= KBC_MAX_COL) {
+				dev_err(&pdev->dev, "invalid column number\n");
+				err = -EINVAL;
+				goto fail_configurekeyboard;
+			}
+			cols[pdata->pin_cfg[i].num] = 1;
+		}
+	}
+	kbc->wake_enable_rows = 0;
+	kbc->wake_enable_cols = 0;
+
+	for (i = 0; i < pdata->wake_cnt; i++) {
+		kbc->wake_enable_rows |= (1 << kbc->pdata->wake_cfg[i].row);
+		kbc->wake_enable_cols |= (1 << kbc->pdata->wake_cfg[i].col);
+	}
+
+	debounce_cnt = pdata->debounce_cnt;
+	debounce_cnt = min_t(unsigned int, debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
+
+	/* The time delay between two consecutive reads of the FIFO is the sum
+	 * of the repeat time and the time taken for scanning the rows.
+	 * There is an additional delay before the row scanning starts.
+	 * The repoll delay is computed in milliseconds. */
+	scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
+	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
+	kbc->repoll_dly = ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
+
+	kbc->idev->evbit[0] = BIT_MASK(EV_KEY);
+
+	/* Override the default keycodes with the board supplied ones. */
+	if (pdata->keycode)
+		memcpy(kbc->keycode, pdata->keycode, sizeof(kbc->keycode));
+	else
+		memcpy(kbc->keycode, tegra_kbd_keycode, sizeof(kbc->keycode));
+
+	kbc->idev->keycode = kbc->keycode;
+	kbc->idev->keycodesize = sizeof(kbc->keycode[0]);
+	kbc->idev->keycodemax = ARRAY_SIZE(kbc->keycode);
+
+	for (i = 0; i < KBC_MAX_COL; i++) {
+		if (!cols[i])
+			continue;
+		for (j = 0; j < KBC_MAX_ROW; j++) {
+			int keycode;
+
+			if (!rows[j])
+				continue;
+
+			/* enable all the mapped keys. */
+			keycode = kbc->keycode[(j * KBC_MAX_COL) + i];
+			if (keycode != -1)
+				set_bit(keycode, kbc->idev->keybit);
+
+		}
+	}
+
+	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
+	/* Initialize the FIFO to invalid entries */
+	for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++)
+		kbc->fifo[i] = -1;
+
+	/* keycode FIFO needs to be read atomically; leave local
+	 * interrupts disabled when handling KBC interrupt */
+	err = request_irq(irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
+		pdev->name, kbc);
+	if (err) {
+		dev_err(&pdev->dev, "failed to request keyboard IRQ\n");
+		goto fail_configurekeyboard;
+	}
+	kbc->irq = irq;
+
+	err = input_register_device(kbc->idev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto fail_registerinput;
+	}
+
+	device_init_wakeup(&pdev->dev, pdata->wakeup);
+	return 0;
+
+fail_registerinput:
+	free_irq(kbc->irq, pdev);
+fail_configurekeyboard:
+	clk_put(kbc->clk);
+fail_keyboardresource:
+	iounmap(kbc->mmio);
+fail_memoryresource:
+	input_free_device(kbc->idev);
+fail_allocateinput:
+	kfree(kbc);
+	return err;
+}
+
+#ifdef CONFIG_PM
+static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
+
+	if (device_may_wakeup(&pdev->dev)) {
+		tegra_kbc_setup_wakekeys(kbc, true);
+		enable_irq_wake(kbc->irq);
+		/* Forcefully clear the interrupt status */
+		writel(0x7, kbc->mmio + KBC_INT_0);
+		msleep(30);
+	} else {
+		mutex_lock(&kbc->idev->mutex);
+		if (kbc->idev->users)
+			tegra_kbc_close(kbc->idev);
+		mutex_unlock(&kbc->idev->mutex);
+	}
+
+	return 0;
+}
+
+static int tegra_kbc_resume(struct platform_device *pdev)
+{
+	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
+	int err = 0;
+
+	if (device_may_wakeup(&pdev->dev)) {
+		disable_irq_wake(kbc->irq);
+		tegra_kbc_setup_wakekeys(kbc, false);
+	} else {
+		mutex_lock(&kbc->idev->mutex);
+		if (kbc->idev->users)
+			err = tegra_kbc_open(kbc->idev);
+		mutex_unlock(&kbc->idev->mutex);
+	}
+
+	return err;
+}
+#endif
+
+static struct platform_driver tegra_kbc_driver = {
+	.probe		= tegra_kbc_probe,
+	.remove		= __devexit_p(tegra_kbc_remove),
+#ifdef CONFIG_PM
+	.suspend	= tegra_kbc_suspend,
+	.resume		= tegra_kbc_resume,
+#endif
+	.driver	= {
+		.name	= "tegra-kbc",
+		.owner  = THIS_MODULE,
+	}
+};
+
+static void __exit tegra_kbc_exit(void)
+{
+	platform_driver_unregister(&tegra_kbc_driver);
+}
+module_exit(tegra_kbc_exit);
+
+static int __init tegra_kbc_init(void)
+{
+	return platform_driver_register(&tegra_kbc_driver);
+}
+module_init(tegra_kbc_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rakesh Iyer <riyer@nvidia.com>");
+MODULE_DESCRIPTION("Tegra matrix keyboard controller driver");
+MODULE_ALIAS("platform:tegra-kbc");
-- 
1.7.0.4

