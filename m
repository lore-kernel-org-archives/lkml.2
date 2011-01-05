Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1AEIgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:36:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1AEIgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:36:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6216"; a="69106497"
Message-ID: <4D242D9D.5060305@codeaurora.org>
Date: Wed, 05 Jan 2011 14:06:45 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: riyer@nvidia.com
CC: ccross@android.com, konkers@android.com, olof@lixom.net, achew@nvidia.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
References: <1294189382-13657-1-git-send-email-riyer@nvidia.com>
In-Reply-To: <1294189382-13657-1-git-send-email-riyer@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rakesh,

On 1/5/2011 6:33 AM, riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
> 
> This patch adds support for the internal matrix keyboard controller for
> Nvidia Tegra platforms.
> 
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>

Thanks for the patch. Few comments.

> ---
>  arch/arm/mach-tegra/include/mach/kbc.h |   61 +++
>  drivers/input/keyboard/Kconfig         |    9 +
>  drivers/input/keyboard/Makefile        |    1 +
>  drivers/input/keyboard/tegra-kbc.c     |  691 ++++++++++++++++++++++++++++++++
>  4 files changed, 762 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/include/mach/kbc.h
>  create mode 100755 drivers/input/keyboard/tegra-kbc.c

Wrong mode of file.

> 
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
> new file mode 100644
> index 0000000..d1ef7fc
> --- /dev/null
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -0,0 +1,61 @@
> +/*
> + * arch/arm/mach-tegra/include/mach/kbc.h

no paths please

> + *
> + * Platform definitions for tegra-kbc keyboard input driver
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#ifndef ASMARM_ARCH_TEGRA_KBC_H
> +#define ASMARM_ARCH_TEGRA_KBC_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> +#define KBC_MAX_GPIO 24
> +#define KBC_MAX_KPENT 8
> +#else
> +#define KBC_MAX_GPIO 20
> +#define KBC_MAX_KPENT 7
> +#endif
> +
> +#define KBC_MAX_ROW 16
> +#define KBC_MAX_COL 8
> +
> +#define KBC_MAX_KEY (KBC_MAX_ROW*KBC_MAX_COL)
> +
> +struct tegra_kbc_pin_cfg {
> +	bool is_row;
> +	bool is_col;
> +	unsigned char num;
> +};
> +
> +struct tegra_kbc_wake_key {
> +	u8 row:4;
> +	u8 col:4;
> +};
> +
> +struct tegra_kbc_platform_data {
> +	unsigned int debounce_cnt;
> +	unsigned int repeat_cnt;
> +	int wake_cnt; /* 0:wake on any key >1:wake on wake_cfg */
> +	int *plain_keycode;
> +	int *fn_keycode;
> +	struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
> +	struct tegra_kbc_wake_key *wake_cfg;
> +};
> +#endif
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 9cc488d..d582159 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -327,6 +327,15 @@ config KEYBOARD_NEWTON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called newtonkbd.
>  
> +config KEYBOARD_TEGRA
> +	boolean "NVIDIA Tegra internal matrix keyboard controller support"

This needs to be tristate. 

> +	depends on ARCH_TEGRA
> +	help
> +	  Say Y here if you want to use a matrix keyboard connected directly
> +	  to the internal keyboard controller on Tegra SoCs
> +
> +	  If unsure, say Y.
> +

once you are adding tristate above, you need to put text like when this selected
as module etc; please refer other Kconfig options text.

> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> new file mode 100755
> index 0000000..0924d60
> --- /dev/null
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -0,0 +1,691 @@
> +/*
> + * drivers/input/keyboard/tegra-kbc.c

no paths please

> +
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +#include <linux/kthread.h>

are you using anything related to thread? please audit this list of header 
files includes and remove the one which are not used.

> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <mach/clk.h>
> +#include <mach/kbc.h>
> +
> +#define KBC_CONTROL_0	0
> +#define KBC_INT_0	4
> +#define KBC_ROW_CFG0_0	8
> +#define KBC_COL_CFG0_0	0x18
> +#define KBC_INIT_DLY_0	0x28
> +#define KBC_RPT_DLY_0	0x2c
> +#define KBC_KP_ENT0_0	0x30
> +#define KBC_KP_ENT1_0	0x34
> +#define KBC_ROW0_MASK_0	0x38
> +
> +#define res_size(res)	((res)->end - (res)->start + 1)

Use resource_size

> +
> +struct tegra_kbc {
> +	void __iomem *mmio;
> +	struct input_dev *idev;
> +	int irq;
> +	unsigned int wake_enable_rows;
> +	unsigned int wake_enable_cols;
> +	spinlock_t lock;
> +	unsigned int repoll_time;
> +	unsigned long cp_dly;
> +	int fifo[KBC_MAX_KPENT];
> +	struct tegra_kbc_platform_data *pdata;

const

> +	int *plain_keycode;
> +	int *fn_keycode;
> +	struct hrtimer timer;
> +	struct clk *clk;
> +};
> +
> +static int plain_kbd_keycode[] = {
> +	/*
> +	 * Row 0 Unused, Unused, 'W', 'S', 'A', 'Z', Unused, Function,
> +	 * Row 1 Unused, Unused, Unused, Unused, Unused, Unused, Unused, Menu
> +	 * Row 2 Unused, Unused, Unused, Unused, Unused, Unused, Alt, Alt2
> +	 * Row 3 '5', '4', 'R', 'E', 'F', 'D', 'X', Unused,
> +	 * Row 4 '7', '6', 'T', 'H', 'G', 'V', 'C', SPACEBAR,
> +	 * Row 5 '9', '8', 'U', 'Y', 'J', 'N', 'B', '|\',
> +	 * Row 6 Minus, '0', 'O', 'I', 'L', 'K', '<', M,
> +	 * Row 7 Unused, '+', '}]', '#', Unused, Unused, Unused, Menu,
> +	 * Row 8 Unused, Unused, Unused, Unused, SHIFT, SHIFT, Unused, Unused,
> +	 * Row 9 Unused, Unused, Unused, Unused, Unused, Ctrl, Unused, Ctrl,
> +	 * Row A Unused, Unused, Unused, Unused, Unused, Unused, Unused, Unused,
> +	 * Row B '{[', 'P', '"', ':;', '/?, '>', Unused, Unused,
> +	 * Row C 'F10', 'F9', 'BckSpc', '3', '2', Up, Prntscr, Pause
> +	 * Row D INS, DEL, Unused, Pgup, PgDn, right, Down, Left,
> +	 * Row E F11, F12, F8, 'Q', F4, F3, '1', F7,
> +	 * Row F ESC, '~', F5, TAB, F1, F2, CAPLOCK, F6,
> +	 */
> +	KEY_RESERVED, KEY_RESERVED, KEY_W, KEY_S,
> +		KEY_A, KEY_Z, KEY_RESERVED, KEY_FN,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RIGHTALT, KEY_LEFTALT,
> +	KEY_5, KEY_4, KEY_R, KEY_E,
> +		KEY_F, KEY_D, KEY_X, KEY_RESERVED,
> +	KEY_7, KEY_6, KEY_T, KEY_H,
> +		KEY_G, KEY_V, KEY_C, KEY_SPACE,
> +	KEY_9, KEY_8, KEY_U, KEY_Y,
> +		KEY_J, KEY_N, KEY_B, KEY_BACKSLASH,
> +	KEY_MINUS, KEY_0, KEY_O, KEY_I,
> +		KEY_L, KEY_K, KEY_COMMA, KEY_M,
> +	KEY_RESERVED, KEY_EQUAL, KEY_RIGHTBRACE, KEY_ENTER,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RIGHTSHIFT, KEY_LEFTSHIFT, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RIGHTCTRL, KEY_RESERVED, KEY_LEFTCTRL,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_LEFTBRACE, KEY_P, KEY_APOSTROPHE, KEY_SEMICOLON,
> +		KEY_SLASH, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
> +	KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
> +		KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,
> +	KEY_INSERT, KEY_DELETE, KEY_RESERVED, KEY_PAGEUP,
> +		KEY_PAGEDOWN, KEY_RIGHT, KEY_DOWN, KEY_LEFT,
> +	KEY_F11, KEY_F12, KEY_F8, KEY_Q,
> +		KEY_F4, KEY_F3, KEY_1, KEY_F7,
> +	KEY_ESC, KEY_GRAVE, KEY_F5, KEY_TAB,
> +		KEY_F1, KEY_F2, KEY_CAPSLOCK, KEY_F6
> +};
> +
> +static int fn_kbd_keycode[] = {
> +	/*
> +	 * Row 0 Unused, Unused, 'W', 'S', 'A', 'Z', Unused, Function,
> +	 * Row 1 Special, Unused, Unused, Unused, Unused, Unused, Unused, Menu
> +	 * Row 2 Unused, Unused, Unused, Unused, Unused, Unused, Alt, Alt2
> +	 * Row 3 '5', '4', 'R', 'E', 'F', 'D', 'X', Unused,
> +	 * Row 4 '7', '6', 'T', 'H', 'G', 'V', 'C', SPACEBAR,
> +	 * Row 5 '9', '8', 'U', 'Y', 'J', 'N', 'B', '|\',
> +	 * Row 6 Minus, '0', 'O', 'I', 'L', 'K', '<', M,
> +	 * Row 7 Unused, '+', '}]', '#', Unused, Unused, Unused, Menu,
> +	 * Row 8 Unused, Unused, Unused, Unused, SHIFT, SHIFT, Unused, Unused,
> +	 * Row 9 Unused, Unused, Unused, Unused, Unused, Ctrl, Unused, Control,
> +	 * Row A Unused, Unused, Unused, Unused, Unused, Unused, Unused, Unused,
> +	 * Row B '{[', 'P', '"', ':;', '/?, '>', Unused, Unused,
> +	 * Row C 'F10', 'F9', 'BckSpc', '3', '2', 'Up, Prntscr, Pause
> +	 * Row D INS, DEL, Unused, Pgup, PgDn, right, Down, Left,
> +	 * Row E F11, F12, F8, 'Q', F4, F3, '1', F7,
> +	 * Row F ESC, '~', F5, TAB, F1, F2, CAPLOCK, F6,
> +	 */
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_7, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_9, KEY_8, KEY_4, KEY_RESERVED,
> +		KEY_1, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_SLASH, KEY_6, KEY_5,
> +		KEY_3, KEY_2, KEY_RESERVED, KEY_0,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_KPASTERISK, KEY_RESERVED, KEY_KPMINUS,
> +		KEY_KPPLUS, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_RESERVED, KEY_VOLUMEUP, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_HOME,
> +		KEY_END, KEY_BRIGHTNESSUP, KEY_VOLUMEDOWN, KEY_BRIGHTNESSDOWN,
> +	KEY_NUMLOCK, KEY_SCROLLLOCK, KEY_MUTE, KEY_RESERVED,
> +		KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> +		KEY_QUESTION, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED
> +};
> +
> +static int tegra_kbc_keycode(struct tegra_kbc *kbc, int r, int c, bool fn_key)
> +{
> +	if (!fn_key)
> +		return kbc->plain_keycode[(r * KBC_MAX_COL) + c];
> +	else
> +		return kbc->fn_keycode[(r * KBC_MAX_COL) + c];
> +}
> +
> +#ifdef CONFIG_PM
> +static int tegra_kbc_open(struct input_dev *dev);
> +static void tegra_kbc_close(struct input_dev *dev);
> +static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter);
> +

I don't understand why these are here, why can't we re-arrange them in such
a way that above is not required.

> +static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(&pdev->dev)) {
> +		tegra_kbc_setup_wakekeys(kbc, true);
> +		enable_irq_wake(kbc->irq);
> +		/* Forcefully clear the interrupt status */
> +		writel(0x7, kbc->mmio + KBC_INT_0);
> +		msleep(30);
> +	} else {
> +		tegra_kbc_close(kbc->idev);

May be you want to use input_dev->mutex here before making this decision and avoid
race between open and close with suspend/resume.

> +
> +static void tegra_kbc_report_keys(struct tegra_kbc *kbc, int *fifo)
> +{
> +	int curr_fifo[KBC_MAX_KPENT];
> +	int rows_val[KBC_MAX_KPENT], cols_val[KBC_MAX_KPENT];
> +	u32 kp_ent_val[(KBC_MAX_KPENT + 3) / 4];
> +	u32 *kp_ents = kp_ent_val;
> +	u32 kp_ent = 0;
> +	unsigned long flags;
> +	int i, j, valid = 0;
> +	bool fn = false;
> +
> +	local_irq_save(flags);
> +	for (i = 0; i < ARRAY_SIZE(kp_ent_val); i++)
> +		kp_ent_val[i] = readl(kbc->mmio + KBC_KP_ENT0_0 + (i*4));
> +	local_irq_restore(flags);

could you please explain why this disabling required? why can't we use spinlock?

> +
> +	valid = 0;
> +	for (i = 0; i < KBC_MAX_KPENT; i++) {
> +		if (!(i&3))
> +			kp_ent = *kp_ents++;
> +
> +		if (kp_ent & 0x80) {
> +			cols_val[valid] = kp_ent & 0x7;
> +			rows_val[valid++] = (kp_ent >> 3) & 0xf;
> +		}
> +		kp_ent >>= 8;
> +	}
> +
> +	for (i = 0; i < valid; i++) {
> +		int k = tegra_kbc_keycode(kbc, rows_val[i], cols_val[i], false);
> +		if (k == KEY_FN) {
> +			fn = true;
> +			break;
> +		}
> +	}
> +
> +	j = 0;
> +	for (i = 0; i < valid; i++) {
> +		int k = tegra_kbc_keycode(kbc, rows_val[i], cols_val[i], fn);
> +		if (likely(k != -1))
> +			curr_fifo[j++] = k;
> +	}
> +	valid = j;
> +
> +	for (i = 0; i < KBC_MAX_KPENT; i++) {
> +		if (fifo[i] == -1)
> +			continue;
> +		for (j = 0; j < valid; j++) {
> +			if (curr_fifo[j] == fifo[i]) {
> +				curr_fifo[j] = -1;
> +				break;
> +			}
> +		}
> +		if (j == valid) {
> +			input_report_key(kbc->idev, fifo[i], 0);
> +			fifo[i] = -1;
> +		}
> +	}
> +	for (j = 0; j < valid; j++) {
> +		if (curr_fifo[j] == -1)
> +			continue;
> +		for (i = 0; i < KBC_MAX_KPENT; i++) {
> +			if (fifo[i] == -1)
> +				break;
> +		}
> +		if (i != KBC_MAX_KPENT) {
> +			fifo[i] = curr_fifo[j];
> +			input_report_key(kbc->idev, fifo[i], 1);
> +		} else
> +			WARN_ON(1);
> +	}
> +}
> +
> +static enum hrtimer_restart tegra_kbc_key_repeat_timer(struct hrtimer *handle)
> +{
> +	struct tegra_kbc *kbc;
> +	unsigned long flags;
> +	u32 val;
> +	int i;
> +
> +	kbc = container_of(handle, struct tegra_kbc, timer);
> +
> +	val = (readl(kbc->mmio + KBC_INT_0) >> 4) & 0xf;
> +	if (val) {
> +		unsigned long dly;
> +
> +		tegra_kbc_report_keys(kbc, kbc->fifo);
> +
> +		dly = ((val == 1) ? kbc->repoll_time : 1) * 1000000;
> +		hrtimer_start(&kbc->timer, ktime_set(0, dly), HRTIMER_MODE_REL);
> +	} else {
> +		/* release any pressed keys and exit the loop */
> +		for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++) {
> +			if (kbc->fifo[i] == -1)
> +				continue;
> +			input_report_key(kbc->idev, kbc->fifo[i], 0);
> +			kbc->fifo[i] = -1;
> +		}
> +
> +		/* All keys are released so enable the keypress interrupt */
> +		spin_lock_irqsave(&kbc->lock, flags);
> +		val = readl(kbc->mmio + KBC_CONTROL_0);
> +		val |= (1<<3);
> +		writel(val, kbc->mmio + KBC_CONTROL_0);
> +		spin_unlock_irqrestore(&kbc->lock, flags);
> +	}
> +	return HRTIMER_NORESTART;
> +}
> +
> +static void tegra_kbc_close(struct input_dev *dev)
> +{
> +	struct tegra_kbc *kbc = input_get_drvdata(dev);
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&kbc->lock, flags);
> +	val = readl(kbc->mmio + KBC_CONTROL_0);
> +	val &= ~1;
> +	writel(val, kbc->mmio + KBC_CONTROL_0);
> +	spin_unlock_irqrestore(&kbc->lock, flags);
> +
> +	clk_disable(kbc->clk);
> +}
> +
> +static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
> +{
> +	int i;
> +	unsigned int rst_val;
> +
> +	BUG_ON(kbc->pdata->wake_cnt > KBC_MAX_KEY);
> +	rst_val = (filter && kbc->pdata->wake_cnt) ? ~0 : 0;
> +
> +	for (i = 0; i < KBC_MAX_ROW; i++)
> +		writel(rst_val, kbc->mmio+KBC_ROW0_MASK_0+i*4);
> +
> +	if (filter) {
> +		for (i = 0; i < kbc->pdata->wake_cnt; i++) {
> +			u32 val, addr;
> +			addr = kbc->pdata->wake_cfg[i].row*4 + KBC_ROW0_MASK_0;
> +			val = readl(kbc->mmio + addr);
> +			val &= ~(1<<kbc->pdata->wake_cfg[i].col);
> +			writel(val, kbc->mmio + addr);
> +		}
> +	}
> +}

could you please explain this functionality in detail? Are you making only selectable
keys to be able to wakeup system and not all?

> +
> +static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
> +{
> +	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
> +	int i;
> +
> +	for (i = 0; i < KBC_MAX_GPIO; i++) {
> +		u32 row_cfg, col_cfg;
> +		u32 r_shift = 5 * (i%6);
> +		u32 c_shift = 4 * (i%8);
> +		u32 r_mask = 0x1f << r_shift;
> +		u32 c_mask = 0xf << c_shift;
> +		u32 r_offs = (i / 6) * 4 + KBC_ROW_CFG0_0;
> +		u32 c_offs = (i / 8) * 4 + KBC_COL_CFG0_0;
> +
> +		row_cfg = readl(kbc->mmio + r_offs);
> +		col_cfg = readl(kbc->mmio + c_offs);
> +
> +		row_cfg &= ~r_mask;
> +		col_cfg &= ~c_mask;
> +
> +		if (pdata->pin_cfg[i].is_row)
> +			row_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << r_shift;
> +		else if (pdata->pin_cfg[i].is_col)
> +			col_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << c_shift;
> +
> +		writel(row_cfg, kbc->mmio + r_offs);
> +		writel(col_cfg, kbc->mmio + c_offs);
> +	}
> +}
> +
> +static int tegra_kbc_open(struct input_dev *dev)
> +{
> +	struct tegra_kbc *kbc = input_get_drvdata(dev);
> +	unsigned long flags;
> +	u32 val = 0;
> +
> +	clk_enable(kbc->clk);
> +
> +	/* Reset the KBC controller to clear all previous status.*/
> +	tegra_periph_reset_assert(kbc->clk);
> +	udelay(100);
> +	tegra_periph_reset_deassert(kbc->clk);
> +	udelay(100);
> +
> +	tegra_kbc_config_pins(kbc);
> +	tegra_kbc_setup_wakekeys(kbc, false);
> +
> +	writel(kbc->pdata->repeat_cnt, kbc->mmio + KBC_RPT_DLY_0);
> +
> +	val = kbc->pdata->debounce_cnt << 4;
> +	val |= 1<<14; /* fifo interrupt threshold = 1 entry */
> +	val |= 1<<3;  /* interrupt on FIFO threshold reached */
> +	val |= 1;     /* enable */
> +	writel(val, kbc->mmio + KBC_CONTROL_0);
> +
> +	/* Compute the delay(ns) from interrupt mode to continuous polling mode
> +	 * so the timer routine is scheduled appropriately. */
> +	val = readl(kbc->mmio + KBC_INIT_DLY_0);
> +	kbc->cp_dly = (val & 0xfffff) * 32 * 1000;
> +
> +	/* atomically clear out any remaining entries in the key FIFO
> +	 * and enable keyboard interrupts */
> +	spin_lock_irqsave(&kbc->lock, flags);
> +	while (1) {
> +		val = readl(kbc->mmio + KBC_INT_0);
> +		val >>= 4;
> +		if (val) {
> +			val = readl(kbc->mmio + KBC_KP_ENT0_0);
> +			val = readl(kbc->mmio + KBC_KP_ENT1_0);
> +		} else {
> +			break;
> +		}
> +	}
> +	writel(0x7, kbc->mmio + KBC_INT_0);
> +	spin_unlock_irqrestore(&kbc->lock, flags);
> +
> +	return 0;
> +}
> +
> +
> +static int __devexit tegra_kbc_remove(struct platform_device *pdev)
> +{
> +	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> +	struct resource *res;
> +
> +	free_irq(kbc->irq, pdev);
> +	hrtimer_cancel(&kbc->timer);
> +	clk_disable(kbc->clk);
> +	clk_put(kbc->clk);
> +
> +	input_unregister_device(kbc->idev);
> +	input_free_device(kbc->idev);

input_free_device is not required after input_unregister_device.

> +	iounmap(kbc->mmio);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(res->start, res_size(res));
> +
> +	kfree(kbc);
> +	return 0;
> +}
> +
> +static irqreturn_t tegra_kbc_isr(int irq, void *args)
> +{
> +	struct tegra_kbc *kbc = args;
> +	u32 val, ctl;
> +
> +	/* until all keys are released, defer further processing to
> +	 * the polling loop in tegra_kbc_key_repeat */
> +	ctl = readl(kbc->mmio + KBC_CONTROL_0);
> +	ctl &= ~(1<<3);
> +	writel(ctl, kbc->mmio + KBC_CONTROL_0);
> +
> +	/* quickly bail out & reenable interrupts if the interrupt source
> +	 * wasn't fifo count threshold */
> +	val = readl(kbc->mmio + KBC_INT_0);
> +	writel(val, kbc->mmio + KBC_INT_0);
> +
> +	if (!(val & (1<<2))) {
> +		ctl |= 1<<3;
> +		writel(ctl, kbc->mmio + KBC_CONTROL_0);
> +		return IRQ_HANDLED;
> +	}
> +
> +	/* Schedule timer to run when hardware is in continuous polling mode. */
> +	hrtimer_start(&kbc->timer, ktime_set(0, kbc->cp_dly), HRTIMER_MODE_REL);

why can't we use the setup_timer and friends? do you really need hrtimers?

> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit tegra_kbc_probe(struct platform_device *pdev)
> +{
> +	struct tegra_kbc *kbc;
> +	struct tegra_kbc_platform_data *pdata = pdev->dev.platform_data;

const 

> +	struct resource *res;
> +	int irq;
> +	int err;
> +	int rows[KBC_MAX_ROW];
> +	int cols[KBC_MAX_COL];
> +	int i, j;
> +	int nr = 0;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
> +	if (!kbc)
> +		return -ENOMEM;
> +
> +	kbc->pdata = pdata;
> +	kbc->irq = -EINVAL;
> +
> +	memset(rows, 0, sizeof(rows));
> +	memset(cols, 0, sizeof(cols));
> +
> +	kbc->idev = input_allocate_device();
> +	if (!kbc->idev) {
> +		err = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get I/O memory\n");
> +		err = -ENXIO;
> +		goto fail;
> +	}
> +	res = request_mem_region(res->start, res_size(res), pdev->name);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to request I/O memory\n");
> +		err = -EBUSY;
> +		goto fail;
> +	}
> +	kbc->mmio = ioremap(res->start, res_size(res));
> +	if (!kbc->mmio) {
> +		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> +		err = -ENXIO;
> +		goto fail;
> +	}
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "failed to get keypad IRQ\n");
> +		err = -ENXIO;
> +		goto fail;
> +	}
> +	kbc->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR_OR_NULL(kbc->clk)) {
> +		dev_err(&pdev->dev, "failed to get keypad clock\n");
> +		err = (kbc->clk) ? PTR_ERR(kbc->clk) : -ENODEV;
> +		kbc->clk = NULL;
> +		goto fail;
> +	}
> +
> +	platform_set_drvdata(pdev, kbc);
> +
> +	kbc->idev->name = pdev->name;
> +	input_set_drvdata(kbc->idev, kbc);
> +	kbc->idev->id.bustype = BUS_HOST;
> +	kbc->idev->open = tegra_kbc_open;
> +	kbc->idev->close = tegra_kbc_close;
> +	kbc->idev->dev.parent = &pdev->dev;
> +	spin_lock_init(&kbc->lock);
> +
> +	for (i = 0; i < KBC_MAX_GPIO; i++) {
> +		if (pdata->pin_cfg[i].is_row && pdata->pin_cfg[i].is_col) {
> +			dev_err(&pdev->dev, "invalid pin configuration data\n");
> +			err = -EINVAL;
> +			goto fail;
> +		}
> +
> +		if (pdata->pin_cfg[i].is_row) {
> +			if (pdata->pin_cfg[i].num >= KBC_MAX_ROW) {
> +				dev_err(&pdev->dev, "invalid row number\n");
> +				err = -EINVAL;
> +				goto fail;
> +			}
> +			rows[pdata->pin_cfg[i].num] = 1;
> +			nr++;
> +		} else if (pdata->pin_cfg[i].is_col) {
> +			if (pdata->pin_cfg[i].num >= KBC_MAX_COL) {
> +				dev_err(&pdev->dev, "invalid column number\n");
> +				err = -EINVAL;
> +				goto fail;
> +			}
> +			cols[pdata->pin_cfg[i].num] = 1;
> +		}
> +	}
> +	kbc->wake_enable_rows = 0;
> +	kbc->wake_enable_cols = 0;
> +
> +	for (i = 0; i < pdata->wake_cnt; i++) {
> +		kbc->wake_enable_rows |= (1 << kbc->pdata->wake_cfg[i].row);
> +		kbc->wake_enable_cols |= (1 << kbc->pdata->wake_cfg[i].col);
> +	}
> +
> +	pdata->debounce_cnt = min_t(unsigned int, pdata->debounce_cnt, 0x3fful);
> +	kbc->repoll_time = 5 + (16+pdata->debounce_cnt)*nr + pdata->repeat_cnt;
> +	kbc->repoll_time = (kbc->repoll_time + 31) / 32;
> +
> +	kbc->idev->evbit[0] = BIT_MASK(EV_KEY);
> +
> +	/* Override the default keycodes with the board supplied ones. */
> +	if (pdata->plain_keycode) {
> +		kbc->plain_keycode = pdata->plain_keycode;
> +		kbc->fn_keycode = pdata->fn_keycode;
> +	} else {
> +		kbc->plain_keycode = plain_kbd_keycode;
> +		kbc->fn_keycode = fn_kbd_keycode;
> +	}
> +
> +	for (i = 0; i < KBC_MAX_COL; i++) {
> +		if (!cols[i])
> +			continue;
> +		for (j = 0; j < KBC_MAX_ROW; j++) {
> +			int keycode;
> +
> +			if (!rows[j])
> +				continue;
> +
> +			/* enable all the mapped keys. */
> +			keycode = tegra_kbc_keycode(kbc, j, i, false);
> +			if (keycode != -1)
> +				set_bit(keycode, kbc->idev->keybit);
> +
> +			keycode = tegra_kbc_keycode(kbc, j, i, true);
> +			if (keycode != -1)
> +				set_bit(keycode, kbc->idev->keybit);
> +		}
> +	}
> +
> +	hrtimer_init(&kbc->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	kbc->timer.function = tegra_kbc_key_repeat_timer;
> +	/* Initialize the FIFO to invalid entries */
> +	for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++)
> +		kbc->fifo[i] = -1;
> +
> +	/* keycode FIFO needs to be read atomically; leave local
> +	 * interrupts disabled when handling KBC interrupt */
> +	err = request_irq(irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
> +		pdev->name, kbc);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to request keypad IRQ\n");
> +		goto fail;
> +	}
> +	kbc->irq = irq;
> +
> +	err = input_register_device(kbc->idev);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to register input device\n");
> +		goto fail;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, 1);

why can't this be configured as pdata? We may not need this to be always wakeup.

> +	return 0;
> +
> +fail:
> +	if (kbc->irq >= 0)
> +		free_irq(kbc->irq, pdev);
> +	if (kbc->idev)
> +		input_free_device(kbc->idev);
> +	if (kbc->clk)
> +		clk_put(kbc->clk);
> +	if (kbc->mmio)
> +		iounmap(kbc->mmio);
> +	kfree(kbc);
> +	return err;
> +}
> +
> +static struct platform_driver tegra_kbc_driver = {
> +	.probe		= tegra_kbc_probe,
> +	.remove		= tegra_kbc_remove,

__devexit_p

> +#ifdef CONFIG_PM
> +	.suspend	= tegra_kbc_suspend,
> +	.resume		= tegra_kbc_resume,
> +#endif
> +	.driver	= {
> +		.name	= "tegra-kbc"

.owner

> +	}
> +};
> +
> +static void __exit tegra_kbc_exit(void)
> +{
> +	platform_driver_unregister(&tegra_kbc_driver);
> +}
> +
> +static int __devinit tegra_kbc_init(void)

__init should do

> +{
> +	return platform_driver_register(&tegra_kbc_driver);
> +}
> +
> +module_exit(tegra_kbc_exit);
> +module_init(tegra_kbc_init);

I prefer to put init and exit with relevant functions.

> +
> +MODULE_DESCRIPTION("Tegra matrix keyboard controller driver");

MODULE_LICENSE, MODULE_AUTHOR, MODULE_ALIAS please.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
