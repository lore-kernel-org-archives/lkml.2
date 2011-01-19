Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1ASD27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:28:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9884 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1ASD25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:28:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 18 Jan 2011 19:28:30 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Tue, 18 Jan 2011 19:28:29 -0800
Subject: RE: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: Acu2zkt4b/i5B5/SSBmjSzmJcVkQ/gAujP3g
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A00807E@HQMAIL03.nvidia.com>
References: <1294943248-18631-1-git-send-email-riyer@nvidia.com>
 <20110118051216.GD23851@core.coreip.homeip.net>
In-Reply-To: <20110118051216.GD23851@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response as I was not working on it on Monday.

The patch as is did not work. I am debugging this currently.

Once I find a fix, can I resend all the driver code as one patch file? I will include your 2nd patch in it as well.

Secondly, the driver is a platform driver for Tegra platforms. The platform code needs some of the #defines to be present in kbc.h, so you will see some of the defines moved back to kbc.h from tegra-kbc.c

Thanks and Regards
Rakesh

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Monday, January 17, 2011 9:12 PM
> To: Rakesh Iyer
> Cc: tsoni@codeaurora.org; pavel@ucw.cz; shubhrajyoti@ti.com; ccross@android.com;
> konkers@android.com; olof@lixom.net; Andrew Chew; linux-tegra@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
>
> On Thu, Jan 13, 2011 at 10:27:28AM -0800, riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> >
> > This patch adds support for the internal matrix keyboard controller for
> > Nvidia Tegra platforms.
> >
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> > Changes Done -
> > Wrap the users field check within the mutex.
> > Remove the KBC_MAX_KEYS define and use existing KBC_MAX_KEY.
> > Patch v4 was named incorrectly as PATCH 1/1, so skipping ahead to PATCH v5.
> >
>
> As I said, we should tty to reused definitions from matrix_keypad for
> matrix keypads. Does the following still work for you?
>
> Thanks.
>
> --
> Dmitry
>
> Input: tegra-kbc - convert to use matrix-keypad definitions
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> and other miscellaneous rearrangements.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  arch/arm/mach-tegra/include/mach/kbc.h |   28 +
>  drivers/input/keyboard/tegra-kbc.c     |  679 ++++++++++++++++++--------------
>  2 files changed, 399 insertions(+), 308 deletions(-)
>
>
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-
> tegra/include/mach/kbc.h
> index 029a468..adb267f 100644
> --- a/arch/arm/mach-tegra/include/mach/kbc.h
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -1,6 +1,4 @@
>  /*
> - * kbc.h
> - *
>   * Platform definitions for tegra-kbc keyboard input driver
>   *
>   * Copyright (c) 2010, NVIDIA Corporation.
> @@ -24,23 +22,18 @@
>  #define ASMARM_ARCH_TEGRA_KBC_H
>
>  #include <linux/types.h>
> +#include <linux/input/matrix_keypad.h>
>
>  #ifdef CONFIG_ARCH_TEGRA_2x_SOC
> -#define KBC_MAX_GPIO 24
> -#define KBC_MAX_KPENT 8
> +#define KBC_MAX_GPIO 24
> +#define KBC_MAX_KPENT        8
>  #else
> -#define KBC_MAX_GPIO 20
> -#define KBC_MAX_KPENT 7
> +#define KBC_MAX_GPIO 20
> +#define KBC_MAX_KPENT        7
>  #endif
>
> -#define KBC_MAX_ROW 16
> -#define KBC_MAX_COL 8
> -
> -#define KBC_MAX_KEY (KBC_MAX_ROW*KBC_MAX_COL)
> -
>  struct tegra_kbc_pin_cfg {
>       bool is_row;
> -     bool is_col;
>       unsigned char num;
>  };
>
> @@ -52,10 +45,13 @@ struct tegra_kbc_wake_key {
>  struct tegra_kbc_platform_data {
>       unsigned int debounce_cnt;
>       unsigned int repeat_cnt;
> -     int wake_cnt; /* 0:wake on any key >1:wake on wake_cfg */
> -     int *keycode;
> -     bool wakeup;
> +
> +     unsigned int wake_cnt; /* 0:wake on any key >1:wake on wake_cfg */
> +     const struct tegra_kbc_wake_key *wake_cfg;
> +
>       struct tegra_kbc_pin_cfg pin_cfg[KBC_MAX_GPIO];
> -     struct tegra_kbc_wake_key *wake_cfg;
> +     const struct matrix_keymap_data *keymap_data;
> +
> +     bool wakeup;
>  };
>  #endif
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> index 02c8ece..a6ec3fc 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -1,6 +1,4 @@
>  /*
> - * tegra-kbc.c
> - *
>   * Keyboard class input driver for the NVIDIA Tegra SoC internal matrix
>   * keyboard controller
>   *
> @@ -32,7 +30,7 @@
>  #include <mach/clk.h>
>  #include <mach/kbc.h>
>
> -#define KBC_MAX_DEBOUNCE_CNT 0x3fful
> +#define KBC_MAX_DEBOUNCE_CNT 0x3ffu
>
>  /* KBC row scan time and delay for beginning the row scan. */
>  #define KBC_ROW_SCAN_TIME    16
> @@ -62,119 +60,201 @@
>  #define KBC_KP_ENT1_0        0x34
>  #define KBC_ROW0_MASK_0      0x38
>
> +#define KBC_MAX_ROW  16
> +#define KBC_MAX_COL  8
> +#define KBC_ROW_SHIFT        3
> +#define KBC_MAX_KEY  (KBC_MAX_ROW * KBC_MAX_COL)
> +
>  struct tegra_kbc {
>       void __iomem *mmio;
>       struct input_dev *idev;
> -     int irq;
> +     unsigned int irq;
>       unsigned int wake_enable_rows;
>       unsigned int wake_enable_cols;
>       spinlock_t lock;
>       unsigned int repoll_dly;
>       unsigned long cp_dly_jiffies;
> -     int fifo[KBC_MAX_KPENT];
>       const struct tegra_kbc_platform_data *pdata;
> -     int keycode[KBC_MAX_KEY];
> +     unsigned short keycode[KBC_MAX_KEY];
> +     unsigned short current_keys[KBC_MAX_KPENT];
> +     unsigned int num_pressed_keys;
>       struct timer_list timer;
>       struct clk *clk;
>  };
>
> -static int tegra_kbd_keycode[KBC_MAX_KEY] = {
> -     KEY_RESERVED, KEY_RESERVED, KEY_W, KEY_S,
> -             KEY_A, KEY_Z, KEY_RESERVED, KEY_FN,
> -     KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -             KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> -     KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -             KEY_RESERVED, KEY_RESERVED, KEY_RIGHTALT, KEY_LEFTALT,
> -     KEY_5, KEY_4, KEY_R, KEY_E,
> -             KEY_F, KEY_D, KEY_X, KEY_RESERVED,
> -     KEY_7, KEY_6, KEY_T, KEY_H,
> -             KEY_G, KEY_V, KEY_C, KEY_SPACE,
> -     KEY_9, KEY_8, KEY_U, KEY_Y,
> -             KEY_J, KEY_N, KEY_B, KEY_BACKSLASH,
> -     KEY_MINUS, KEY_0, KEY_O, KEY_I,
> -             KEY_L, KEY_K, KEY_COMMA, KEY_M,
> -     KEY_RESERVED, KEY_EQUAL, KEY_RIGHTBRACE, KEY_ENTER,
> -             KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_MENU,
> -     KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -             KEY_RIGHTSHIFT, KEY_LEFTSHIFT, KEY_RESERVED,
> KEY_RESERVED,
> -     KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -             KEY_RESERVED, KEY_RIGHTCTRL, KEY_RESERVED, KEY_LEFTCTRL,
> -     KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -             KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
> -     KEY_LEFTBRACE, KEY_P, KEY_APOSTROPHE, KEY_SEMICOLON,
> -             KEY_SLASH, KEY_DOT, KEY_RESERVED, KEY_RESERVED,
> -     KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
> -             KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,
> -     KEY_INSERT, KEY_DELETE, KEY_RESERVED, KEY_PAGEUP,
> -             KEY_PAGEDOWN, KEY_RIGHT, KEY_DOWN, KEY_LEFT,
> -     KEY_F11, KEY_F12, KEY_F8, KEY_Q,
> -             KEY_F4, KEY_F3, KEY_1, KEY_F7,
> -     KEY_ESC, KEY_GRAVE, KEY_F5, KEY_TAB,
> -             KEY_F1, KEY_F2, KEY_CAPSLOCK, KEY_F6
> +static const u32 tegra_kbc_default_keymap[] = {
> +     KEY(0, 2, KEY_W),
> +     KEY(0, 3, KEY_S),
> +     KEY(0, 4, KEY_A),
> +     KEY(0, 5, KEY_Z),
> +     KEY(0, 7, KEY_FN),
> +
> +     KEY(1, 7, KEY_MENU),
> +
> +     KEY(2, 6, KEY_RIGHTALT),
> +     KEY(2, 7, KEY_LEFTALT),
> +
> +     KEY(3, 0, KEY_5),
> +     KEY(3, 1, KEY_4),
> +     KEY(3, 2, KEY_R),
> +     KEY(3, 3, KEY_E),
> +     KEY(3, 4, KEY_F),
> +     KEY(3, 5, KEY_D),
> +     KEY(3, 6, KEY_X),
> +
> +     KEY(4, 0, KEY_7),
> +     KEY(4, 1, KEY_6),
> +     KEY(4, 2, KEY_T),
> +     KEY(4, 3, KEY_H),
> +     KEY(4, 4, KEY_G),
> +     KEY(4, 5, KEY_V),
> +     KEY(4, 6, KEY_C),
> +     KEY(4, 7, KEY_SPACE),
> +
> +     KEY(5, 0, KEY_9),
> +     KEY(5, 1, KEY_8),
> +     KEY(5, 2, KEY_U),
> +     KEY(5, 3, KEY_Y),
> +     KEY(5, 4, KEY_J),
> +     KEY(5, 5, KEY_N),
> +     KEY(5, 6, KEY_B),
> +     KEY(5, 7, KEY_BACKSLASH),
> +
> +     KEY(6, 0, KEY_MINUS),
> +     KEY(6, 1, KEY_0),
> +     KEY(6, 2, KEY_O),
> +     KEY(6, 3, KEY_I),
> +     KEY(6, 4, KEY_L),
> +     KEY(6, 5, KEY_K),
> +     KEY(6, 6, KEY_COMMA),
> +     KEY(6, 7, KEY_M),
> +
> +     KEY(7, 1, KEY_EQUAL),
> +     KEY(7, 2, KEY_RIGHTBRACE),
> +     KEY(7, 3, KEY_ENTER),
> +     KEY(7, 7, KEY_MENU),
> +
> +     KEY(8, 4, KEY_RIGHTSHIFT),
> +     KEY(8, 5, KEY_LEFTSHIFT),
> +
> +     KEY(9, 5, KEY_RIGHTCTRL),
> +     KEY(9, 7, KEY_LEFTCTRL),
> +
> +     KEY(11, 0, KEY_LEFTBRACE),
> +     KEY(11, 1, KEY_P),
> +     KEY(11, 2, KEY_APOSTROPHE),
> +     KEY(11, 3, KEY_SEMICOLON),
> +     KEY(11, 4, KEY_SLASH),
> +     KEY(11, 5, KEY_DOT),
> +
> +     KEY(12, 0, KEY_F10),
> +     KEY(12, 1, KEY_F9),
> +     KEY(12, 2, KEY_BACKSPACE),
> +     KEY(12, 3, KEY_3),
> +     KEY(12, 4, KEY_2),
> +     KEY(12, 5, KEY_UP),
> +     KEY(12, 6, KEY_PRINT),
> +     KEY(12, 7, KEY_PAUSE),
> +
> +     KEY(13, 0, KEY_INSERT),
> +     KEY(13, 1, KEY_DELETE),
> +     KEY(13, 3, KEY_PAGEUP),
> +     KEY(13, 4, KEY_PAGEDOWN),
> +     KEY(13, 5, KEY_RIGHT),
> +     KEY(13, 6, KEY_DOWN),
> +     KEY(13, 7, KEY_LEFT),
> +
> +     KEY(14, 0, KEY_F11),
> +     KEY(14, 1, KEY_F12),
> +     KEY(14, 2, KEY_F8),
> +     KEY(14, 3, KEY_Q),
> +     KEY(14, 4, KEY_F4),
> +     KEY(14, 5, KEY_F3),
> +     KEY(14, 6, KEY_1),
> +     KEY(14, 7, KEY_F7),
> +
> +     KEY(15, 0, KEY_ESC),
> +     KEY(15, 1, KEY_GRAVE),
> +     KEY(15, 2, KEY_F5),
> +     KEY(15, 3, KEY_TAB),
> +     KEY(15, 4, KEY_F1),
> +     KEY(15, 5, KEY_F2),
> +     KEY(15, 6, KEY_CAPSLOCK),
> +     KEY(15, 7, KEY_F6),
>  };
>
> -static void tegra_kbc_report_keys(struct tegra_kbc *kbc, int *fifo)
> -{
> -     int curr_fifo[KBC_MAX_KPENT];
> -     int rows_val[KBC_MAX_KPENT], cols_val[KBC_MAX_KPENT];
> -     u32 kp_ent_val[(KBC_MAX_KPENT + 3) / 4];
> -     u32 *kp_ents = kp_ent_val;
> -     u32 kp_ent = 0;
> -     unsigned long flags;
> -     int i, j, valid = 0;
> +static const struct matrix_keymap_data tegra_kbc_default_keymap_data = {
> +     .keymap         = tegra_kbc_default_keymap,
> +     .keymap_size    = ARRAY_SIZE(tegra_kbc_default_keymap),
> +};
>
> -     spin_lock_irqsave(&kbc->lock, flags);
> -     for (i = 0; i < ARRAY_SIZE(kp_ent_val); i++)
> -             kp_ent_val[i] = readl(kbc->mmio + KBC_KP_ENT0_0 + (i*4));
> -     spin_unlock_irqrestore(&kbc->lock, flags);
> +static void tegra_kbc_report_released_keys(struct input_dev *input,
> +                                        unsigned short old_keycodes[],
> +                                        unsigned int old_num_keys,
> +                                        unsigned short new_keycodes[],
> +                                        unsigned int new_num_keys)
> +{
> +     unsigned int i, j;
>
> -     valid = 0;
> -     for (i = 0; i < KBC_MAX_KPENT; i++) {
> -             if (!(i&3))
> -                     kp_ent = *kp_ents++;
> +     for (i = 0; i < old_num_keys; i++) {
> +             for (j = 0; j < new_num_keys; j++)
> +                     if (old_keycodes[i] == new_keycodes[j])
> +                             break;
>
> -             if (kp_ent & 0x80) {
> -                     cols_val[valid] = kp_ent & 0x7;
> -                     rows_val[valid++] = (kp_ent >> 3) & 0xf;
> -             }
> -             kp_ent >>= 8;
> +             if (j == new_num_keys)
> +                     input_report_key(input, old_keycodes[i], 0);
>       }
> +}
>
> -     j = 0;
> -     for (i = 0; i < valid; i++) {
> -             int k = kbc->keycode[(rows_val[i] * KBC_MAX_COL) + cols_val[i]];
> -             if (likely(k != -1))
> -                     curr_fifo[j++] = k;
> +static void tegra_kbc_report_pressed_keys(struct input_dev *input,
> +                                       unsigned char scancodes[],
> +                                       unsigned short keycodes[],
> +                                       unsigned int num_pressed_keys)
> +{
> +     unsigned int i;
> +
> +     for (i = 0; i < num_pressed_keys; i++) {
> +             input_event(input, EV_MSC, MSC_SCAN, scancodes[i]);
> +             input_report_key(input, keycodes[i], 1);
>       }
> -     valid = j;
> +}
> +
> +static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
> +{
> +     unsigned char scancodes[KBC_MAX_KPENT];
> +     unsigned short keycodes[KBC_MAX_KPENT];
> +     u32 val = 0;
> +     unsigned int i;
> +     unsigned int num_down = 0;
> +     unsigned long flags;
>
> +     spin_lock_irqsave(&kbc->lock, flags);
>       for (i = 0; i < KBC_MAX_KPENT; i++) {
> -             if (fifo[i] == -1)
> -                     continue;
> -             for (j = 0; j < valid; j++) {
> -                     if (curr_fifo[j] == fifo[i]) {
> -                             curr_fifo[j] = -1;
> -                             break;
> -                     }
> -             }
> -             if (j == valid) {
> -                     input_report_key(kbc->idev, fifo[i], 0);
> -                     fifo[i] = -1;
> -             }
> -     }
> -     for (j = 0; j < valid; j++) {
> -             if (curr_fifo[j] == -1)
> -                     continue;
> -             for (i = 0; i < KBC_MAX_KPENT; i++) {
> -                     if (fifo[i] == -1)
> -                             break;
> +             if ((i % 4) == 0)
> +                     val = readl(kbc->mmio + KBC_KP_ENT0_0 + (i * 4));
> +
> +             if (val & 0x80) {
> +                     unsigned int col = val & 0x07;
> +                     unsigned int row = (val >> 3) & 0x0f;
> +                     unsigned char scancode =
> +                             MATRIX_SCAN_CODE(row, col, KBC_ROW_SHIFT);
> +
> +                     scancodes[num_down] = scancode;
> +                     keycodes[num_down++] = kbc->keycode[scancode];
>               }
> -             if (i != KBC_MAX_KPENT) {
> -                     fifo[i] = curr_fifo[j];
> -                     input_report_key(kbc->idev, fifo[i], 1);
> -             } else
> -                     WARN_ON(1);
> +
> +             val >>= 8;
>       }
> +     spin_unlock_irqrestore(&kbc->lock, flags);
> +
> +     tegra_kbc_report_released_keys(kbc->idev,
> +                                    kbc->current_keys, kbc->num_pressed_keys,
> +                                    keycodes, num_down);
> +     tegra_kbc_report_pressed_keys(kbc->idev, scancodes, keycodes, num_down);
> +     input_sync(kbc->idev);
> +
> +     memcpy(kbc->current_keys, keycodes, sizeof(kbc->current_keys));
> +     kbc->num_pressed_keys = num_down;
>  }
>
>  static void tegra_kbc_keypress_timer(unsigned long data)
> @@ -182,26 +262,27 @@ static void tegra_kbc_keypress_timer(unsigned long data)
>       struct tegra_kbc *kbc = (struct tegra_kbc *)data;
>       unsigned long flags;
>       u32 val;
> -     int i;
> +     unsigned int i;
>
>       val = (readl(kbc->mmio + KBC_INT_0) >> 4) & 0xf;
>       if (val) {
>               unsigned long dly;
>
> -             tegra_kbc_report_keys(kbc, kbc->fifo);
> +             tegra_kbc_report_keys(kbc);
>
> -             /* If more than one keys are pressed we need not wait
> -              * for the repoll delay. */
> +             /*
> +              * If more than one keys are pressed we need not wait
> +              * for the repoll delay.
> +              */
>               dly = (val == 1) ? kbc->repoll_dly : 1;
>               mod_timer(&kbc->timer, jiffies + msecs_to_jiffies(dly));
>       } else {
> -             /* release any pressed keys and exit the loop */
> -             for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++) {
> -                     if (kbc->fifo[i] == -1)
> -                             continue;
> -                     input_report_key(kbc->idev, kbc->fifo[i], 0);
> -                     kbc->fifo[i] = -1;
> -             }
> +             /* Release any pressed keys and exit the polling loop */
> +             for (i = 0; i < kbc->num_pressed_keys; i++)
> +                     input_report_key(kbc->idev, kbc->current_keys[i], 0);
> +             input_sync(kbc->idev);
> +
> +             kbc->num_pressed_keys = 0;
>
>               /* All keys are released so enable the keypress interrupt */
>               spin_lock_irqsave(&kbc->lock, flags);
> @@ -212,38 +293,58 @@ static void tegra_kbc_keypress_timer(unsigned long data)
>       }
>  }
>
> -static void tegra_kbc_close(struct input_dev *dev)
> +static irqreturn_t tegra_kbc_isr(int irq, void *args)
>  {
> -     struct tegra_kbc *kbc = input_get_drvdata(dev);
> -     unsigned long flags;
> -     u32 val;
> +     struct tegra_kbc *kbc = args;
> +     u32 val, ctl;
>
> -     spin_lock_irqsave(&kbc->lock, flags);
> -     val = readl(kbc->mmio + KBC_CONTROL_0);
> -     val &= ~1;
> -     writel(val, kbc->mmio + KBC_CONTROL_0);
> -     spin_unlock_irqrestore(&kbc->lock, flags);
> +     /*
> +      * Until all keys are released, defer further processing to
> +      * the polling loop in tegra_kbc_keypress_timer
> +      */
> +     ctl = readl(kbc->mmio + KBC_CONTROL_0);
> +     ctl &= ~KBC_CONTROL_FIFO_CNT_INT_EN;
> +     writel(ctl, kbc->mmio + KBC_CONTROL_0);
>
> -     clk_disable(kbc->clk);
> +     /*
> +      * Quickly bail out & reenable interrupts if the fifo threshold
> +      * count interrupt wasn't the interrupt source
> +      */
> +     val = readl(kbc->mmio + KBC_INT_0);
> +     writel(val, kbc->mmio + KBC_INT_0);
> +
> +     if (val & KBC_INT_FIFO_CNT_INT_STATUS) {
> +             /*
> +              * Schedule timer to run when hardware is in continuous
> +              * polling mode.
> +              */
> +             mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
> +     } else {
> +             ctl |= KBC_CONTROL_FIFO_CNT_INT_EN;
> +             writel(ctl, kbc->mmio + KBC_CONTROL_0);
> +     }
> +
> +     return IRQ_HANDLED;
>  }
>
>  static void tegra_kbc_setup_wakekeys(struct tegra_kbc *kbc, bool filter)
>  {
> +     const struct tegra_kbc_platform_data *pdata = kbc->pdata;
>       int i;
>       unsigned int rst_val;
>
> -     BUG_ON(kbc->pdata->wake_cnt > KBC_MAX_KEY);
> -     rst_val = (filter && kbc->pdata->wake_cnt) ? ~0 : 0;
> +     BUG_ON(pdata->wake_cnt > KBC_MAX_KEY);
> +     rst_val = (filter && pdata->wake_cnt) ? ~0 : 0;
>
>       for (i = 0; i < KBC_MAX_ROW; i++)
> -             writel(rst_val, kbc->mmio+KBC_ROW0_MASK_0+i*4);
> +             writel(rst_val, kbc->mmio + KBC_ROW0_MASK_0 + i * 4);
>
>       if (filter) {
> -             for (i = 0; i < kbc->pdata->wake_cnt; i++) {
> +             for (i = 0; i < pdata->wake_cnt; i++) {
>                       u32 val, addr;
> -                     addr = kbc->pdata->wake_cfg[i].row*4 + KBC_ROW0_MASK_0;
> +                     addr = pdata->wake_cfg[i].row * 4 + KBC_ROW0_MASK_0;
>                       val = readl(kbc->mmio + addr);
> -                     val &= ~(1<<kbc->pdata->wake_cfg[i].col);
> +                     val &= ~(1 << pdata->wake_cfg[i].col);
>                       writel(val, kbc->mmio + addr);
>               }
>       }
> @@ -255,33 +356,31 @@ static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
>       int i;
>
>       for (i = 0; i < KBC_MAX_GPIO; i++) {
> -             u32 row_cfg, col_cfg;
> -             u32 r_shift = 5 * (i%6);
> -             u32 c_shift = 4 * (i%8);
> +             u32 r_shift = 5 * (i % 6);
> +             u32 c_shift = 4 * (i % 8);
>               u32 r_mask = 0x1f << r_shift;
> -             u32 c_mask = 0xf << c_shift;
> +             u32 c_mask = 0x0f << c_shift;
>               u32 r_offs = (i / 6) * 4 + KBC_ROW_CFG0_0;
>               u32 c_offs = (i / 8) * 4 + KBC_COL_CFG0_0;
> -
> -             row_cfg = readl(kbc->mmio + r_offs);
> -             col_cfg = readl(kbc->mmio + c_offs);
> +             u32 row_cfg = readl(kbc->mmio + r_offs);
> +             u32 col_cfg = readl(kbc->mmio + c_offs);
>
>               row_cfg &= ~r_mask;
>               col_cfg &= ~c_mask;
>
>               if (pdata->pin_cfg[i].is_row)
> -                     row_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << r_shift;
> -             else if (pdata->pin_cfg[i].is_col)
> -                     col_cfg |= ((pdata->pin_cfg[i].num<<1) | 1) << c_shift;
> +                     row_cfg |= ((pdata->pin_cfg[i].num << 1) | 1) << r_shift;
> +             else
> +                     col_cfg |= ((pdata->pin_cfg[i].num << 1) | 1) << c_shift;
>
>               writel(row_cfg, kbc->mmio + r_offs);
>               writel(col_cfg, kbc->mmio + c_offs);
>       }
>  }
>
> -static int tegra_kbc_open(struct input_dev *dev)
> +static int tegra_kbc_start(struct tegra_kbc *kbc)
>  {
> -     struct tegra_kbc *kbc = input_get_drvdata(dev);
> +     const struct tegra_kbc_platform_data *pdata = kbc->pdata;
>       unsigned long flags;
>       unsigned int debounce_cnt;
>       u32 val = 0;
> @@ -297,98 +396,120 @@ static int tegra_kbc_open(struct input_dev *dev)
>       tegra_kbc_config_pins(kbc);
>       tegra_kbc_setup_wakekeys(kbc, false);
>
> -     writel(kbc->pdata->repeat_cnt, kbc->mmio + KBC_RPT_DLY_0);
> +     writel(pdata->repeat_cnt, kbc->mmio + KBC_RPT_DLY_0);
>
>       /* Keyboard debounce count is maximum of 12 bits. */
> -     debounce_cnt = kbc->pdata->debounce_cnt;
> -     debounce_cnt = min_t(unsigned int, debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
> +     debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
>       val = KBC_DEBOUNCE_CNT_SHIFT(debounce_cnt);
>       val |= KBC_FIFO_TH_CNT_SHIFT(1); /* set fifo interrupt threshold to 1 */
>       val |= KBC_CONTROL_FIFO_CNT_INT_EN;  /* interrupt on FIFO threshold */
>       val |= KBC_CONTROL_KBC_EN;     /* enable */
>       writel(val, kbc->mmio + KBC_CONTROL_0);
>
> -     /* Compute the delay(ns) from interrupt mode to continuous polling mode
> -      * so the timer routine is scheduled appropriately. */
> +     /*
> +      * Compute the delay(ns) from interrupt mode to continuous polling
> +      * mode so the timer routine is scheduled appropriately.
> +      */
>       val = readl(kbc->mmio + KBC_INIT_DLY_0);
>       kbc->cp_dly_jiffies = usecs_to_jiffies((val & 0xfffff) * 32);
>
> -     /* atomically clear out any remaining entries in the key FIFO
> -      * and enable keyboard interrupts */
> +     kbc->num_pressed_keys = 0;
> +
> +     /*
> +      * Atomically clear out any remaining entries in the key FIFO
> +      * and enable keyboard interrupts.
> +      */
>       spin_lock_irqsave(&kbc->lock, flags);
>       while (1) {
>               val = readl(kbc->mmio + KBC_INT_0);
>               val >>= 4;
> -             if (val) {
> -                     val = readl(kbc->mmio + KBC_KP_ENT0_0);
> -                     val = readl(kbc->mmio + KBC_KP_ENT1_0);
> -             } else {
> +             if (!val)
>                       break;
> -             }
> +
> +             val = readl(kbc->mmio + KBC_KP_ENT0_0);
> +             val = readl(kbc->mmio + KBC_KP_ENT1_0);
>       }
>       writel(0x7, kbc->mmio + KBC_INT_0);
>       spin_unlock_irqrestore(&kbc->lock, flags);
>
> +     enable_irq(kbc->irq);
> +
>       return 0;
>  }
>
> -
> -static int __devexit tegra_kbc_remove(struct platform_device *pdev)
> +static void tegra_kbc_stop( struct tegra_kbc *kbc)
>  {
> -     struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> -     struct resource *res;
> +     unsigned long flags;
> +     u32 val;
>
> -     free_irq(kbc->irq, pdev);
> +     spin_lock_irqsave(&kbc->lock, flags);
> +     val = readl(kbc->mmio + KBC_CONTROL_0);
> +     val &= ~1;
> +     writel(val, kbc->mmio + KBC_CONTROL_0);
> +     spin_unlock_irqrestore(&kbc->lock, flags);
> +
> +     disable_irq(kbc->irq);
>       del_timer_sync(&kbc->timer);
> +
>       clk_disable(kbc->clk);
> -     clk_put(kbc->clk);
> +}
>
> -     input_unregister_device(kbc->idev);
> -     iounmap(kbc->mmio);
> -     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -     release_mem_region(res->start, resource_size(res));
> +static int tegra_kbc_open(struct input_dev *dev)
> +{
> +     struct tegra_kbc *kbc = input_get_drvdata(dev);
>
> -     kfree(kbc);
> -     return 0;
> +     return tegra_kbc_start(kbc);
>  }
>
> -static irqreturn_t tegra_kbc_isr(int irq, void *args)
> +static void tegra_kbc_close(struct input_dev *dev)
>  {
> -     struct tegra_kbc *kbc = args;
> -     u32 val, ctl;
> +     struct tegra_kbc *kbc = input_get_drvdata(dev);
>
> -     /* until all keys are released, defer further processing to
> -      * the polling loop in tegra_kbc_keypress_timer */
> -     ctl = readl(kbc->mmio + KBC_CONTROL_0);
> -     ctl &= ~KBC_CONTROL_FIFO_CNT_INT_EN;
> -     writel(ctl, kbc->mmio + KBC_CONTROL_0);
> +     return tegra_kbc_stop(kbc);
> +}
>
> -     /* quickly bail out & reenable interrupts if the fifo threshold count
> -      * interrupt wasn't the interrupt source */
> -     val = readl(kbc->mmio + KBC_INT_0);
> -     writel(val, kbc->mmio + KBC_INT_0);
> +static bool __devinit
> +tegra_kbc_check_pin_cfg(const struct tegra_kbc_platform_data *pdata,
> +                     struct device *dev, unsigned int *num_rows)
> +{
> +     int i;
>
> -     if (!(val & KBC_INT_FIFO_CNT_INT_STATUS)) {
> -             ctl |= KBC_CONTROL_FIFO_CNT_INT_EN;
> -             writel(ctl, kbc->mmio + KBC_CONTROL_0);
> -             return IRQ_HANDLED;
> +     *num_rows = 0;
> +
> +     for (i = 0; i < KBC_MAX_GPIO; i++) {
> +             const struct tegra_kbc_pin_cfg *pin_cfg = &pdata->pin_cfg[i];
> +
> +             if (pin_cfg->is_row) {
> +                     if (pin_cfg->num >= KBC_MAX_ROW) {
> +                             dev_err(dev,
> +                                     "pin_cfg[%d]: invalid row number %d\n",
> +                                     i, pin_cfg->num);
> +                             return false;
> +                     }
> +                     (*num_rows)++;
> +             } else {
> +                     if (pin_cfg->num >= KBC_MAX_COL) {
> +                             dev_err(dev,
> +                                     "pin_cfg[%d]: invalid column number %d\n",
> +                                     i, pin_cfg->num);
> +                             return false;
> +                     }
> +             }
>       }
>
> -     /* Schedule timer to run when hardware is in continuous polling mode. */
> -     mod_timer(&kbc->timer, jiffies + kbc->cp_dly_jiffies);
> -     return IRQ_HANDLED;
> +     return true;
>  }
>
>  static int __devinit tegra_kbc_probe(struct platform_device *pdev)
>  {
> -     struct tegra_kbc *kbc;
>       const struct tegra_kbc_platform_data *pdata = pdev->dev.platform_data;
> +     const struct matrix_keymap_data *keymap_data;
> +     struct tegra_kbc *kbc;
> +     struct input_dev *input_dev;
>       struct resource *res;
>       int irq;
>       int err;
> -     int rows[KBC_MAX_ROW];
> -     int cols[KBC_MAX_COL];
> -     int i, j;
> +     int i;
>       int num_rows = 0;
>       unsigned int debounce_cnt;
>       unsigned int scan_time_rows;
> @@ -396,173 +517,147 @@ static int __devinit tegra_kbc_probe(struct platform_device
> *pdev)
>       if (!pdata)
>               return -EINVAL;
>
> -     kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
> -     if (!kbc)
> -             return -ENOMEM;
> +     if (!tegra_kbc_check_pin_cfg(pdata, &pdev->dev, &num_rows))
> +             return -EINVAL;
>
> -     kbc->pdata = pdata;
> -     kbc->irq = -EINVAL;
> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +     if (!res) {
> +             dev_err(&pdev->dev, "failed to get I/O memory\n");
> +             return -ENXIO;
> +     }
>
> -     memset(rows, 0, sizeof(rows));
> -     memset(cols, 0, sizeof(cols));
> +     irq = platform_get_irq(pdev, 0);
> +     if (irq < 0) {
> +             dev_err(&pdev->dev, "failed to get keyboard IRQ\n");
> +             return -ENXIO;
> +     }
>
> -     kbc->idev = input_allocate_device();
> -     if (!kbc->idev) {
> +     kbc = kzalloc(sizeof(*kbc), GFP_KERNEL);
> +     input_dev = input_allocate_device();
> +     if (!kbc || !input_dev) {
>               err = -ENOMEM;
> -             goto fail_allocateinput;
> +             goto err_free_mem;
>       }
>
> -     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -     if (!res) {
> -             dev_err(&pdev->dev, "failed to get I/O memory\n");
> -             err = -ENXIO;
> -             goto fail_memoryresource;
> -     }
> +     kbc->pdata = pdata;
> +     kbc->idev = input_dev;
> +     kbc->irq = irq;
> +     spin_lock_init(&kbc->lock);
> +     setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> +
>       res = request_mem_region(res->start, resource_size(res), pdev->name);
>       if (!res) {
>               dev_err(&pdev->dev, "failed to request I/O memory\n");
>               err = -EBUSY;
> -             goto fail_memoryresource;
> +             goto err_free_mem;
>       }
> +
>       kbc->mmio = ioremap(res->start, resource_size(res));
>       if (!kbc->mmio) {
>               dev_err(&pdev->dev, "failed to remap I/O memory\n");
>               err = -ENXIO;
> -             goto fail_memoryresource;
> -     }
> -     irq = platform_get_irq(pdev, 0);
> -     if (irq < 0) {
> -             dev_err(&pdev->dev, "failed to get keyboard IRQ\n");
> -             err = -ENXIO;
> -             goto fail_keyboardresource;
> +             goto err_free_mem_region;
>       }
> +
>       kbc->clk = clk_get(&pdev->dev, NULL);
> -     if (IS_ERR_OR_NULL(kbc->clk)) {
> +     if (IS_ERR(kbc->clk)) {
>               dev_err(&pdev->dev, "failed to get keyboard clock\n");
> -             err = (kbc->clk) ? PTR_ERR(kbc->clk) : -ENODEV;
> -             kbc->clk = NULL;
> -             goto fail_keyboardresource;
> +             err = PTR_ERR(kbc->clk);
> +             goto err_iounmap;
>       }
>
> -     platform_set_drvdata(pdev, kbc);
> -
> -     kbc->idev->name = pdev->name;
> -     input_set_drvdata(kbc->idev, kbc);
> -     kbc->idev->id.bustype = BUS_HOST;
> -     kbc->idev->open = tegra_kbc_open;
> -     kbc->idev->close = tegra_kbc_close;
> -     kbc->idev->dev.parent = &pdev->dev;
> -     spin_lock_init(&kbc->lock);
> -
> -     for (i = 0; i < KBC_MAX_GPIO; i++) {
> -             if (pdata->pin_cfg[i].is_row && pdata->pin_cfg[i].is_col) {
> -                     dev_err(&pdev->dev, "invalid pin configuration data\n");
> -                     err = -EINVAL;
> -                     goto fail_configurekeyboard;
> -             }
> -
> -             if (pdata->pin_cfg[i].is_row) {
> -                     if (pdata->pin_cfg[i].num >= KBC_MAX_ROW) {
> -                             dev_err(&pdev->dev, "invalid row number\n");
> -                             err = -EINVAL;
> -                             goto fail_configurekeyboard;
> -                     }
> -                     rows[pdata->pin_cfg[i].num] = 1;
> -                     num_rows++;
> -             } else if (pdata->pin_cfg[i].is_col) {
> -                     if (pdata->pin_cfg[i].num >= KBC_MAX_COL) {
> -                             dev_err(&pdev->dev, "invalid column number\n");
> -                             err = -EINVAL;
> -                             goto fail_configurekeyboard;
> -                     }
> -                     cols[pdata->pin_cfg[i].num] = 1;
> -             }
> -     }
>       kbc->wake_enable_rows = 0;
>       kbc->wake_enable_cols = 0;
> -
>       for (i = 0; i < pdata->wake_cnt; i++) {
> -             kbc->wake_enable_rows |= (1 << kbc->pdata->wake_cfg[i].row);
> -             kbc->wake_enable_cols |= (1 << kbc->pdata->wake_cfg[i].col);
> +             kbc->wake_enable_rows |= (1 << pdata->wake_cfg[i].row);
> +             kbc->wake_enable_cols |= (1 << pdata->wake_cfg[i].col);
>       }
>
> -     debounce_cnt = pdata->debounce_cnt;
> -     debounce_cnt = min_t(unsigned int, debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
> -
> -     /* The time delay between two consecutive reads of the FIFO is the sum
> -      * of the repeat time and the time taken for scanning the rows.
> -      * There is an additional delay before the row scanning starts.
> -      * The repoll delay is computed in milliseconds. */
> +     /*
> +      * The time delay between two consecutive reads of the FIFO is
> +      * the sum of the repeat time and the time taken for scanning
> +      * the rows. There is an additional delay before the row scanning
> +      * starts. The repoll delay is computed in milliseconds.
> +      */
> +     debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
>       scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
>       kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
>       kbc->repoll_dly = ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
>
> -     kbc->idev->evbit[0] = BIT_MASK(EV_KEY);
> +     input_dev->name = pdev->name;
> +     input_dev->id.bustype = BUS_HOST;
> +     input_dev->dev.parent = &pdev->dev;
> +     input_dev->open = tegra_kbc_open;
> +     input_dev->close = tegra_kbc_close;
>
> -     /* Override the default keycodes with the board supplied ones. */
> -     if (pdata->keycode)
> -             memcpy(kbc->keycode, pdata->keycode, sizeof(kbc->keycode));
> -     else
> -             memcpy(kbc->keycode, tegra_kbd_keycode, sizeof(kbc->keycode));
> +     input_set_drvdata(input_dev, kbc);
>
> -     kbc->idev->keycode = kbc->keycode;
> -     kbc->idev->keycodesize = sizeof(kbc->keycode[0]);
> -     kbc->idev->keycodemax = ARRAY_SIZE(kbc->keycode);
> +     input_dev->evbit[0] = BIT_MASK(EV_KEY);
> +     input_set_capability(input_dev, EV_MSC, MSC_SCAN);
>
> -     for (i = 0; i < KBC_MAX_COL; i++) {
> -             if (!cols[i])
> -                     continue;
> -             for (j = 0; j < KBC_MAX_ROW; j++) {
> -                     int keycode;
> +     input_dev->keycode = kbc->keycode;
> +     input_dev->keycodesize = sizeof(kbc->keycode[0]);
> +     input_dev->keycodemax = ARRAY_SIZE(kbc->keycode);
>
> -                     if (!rows[j])
> -                             continue;
> +     keymap_data = pdata->keymap_data ?: &tegra_kbc_default_keymap_data;
> +     matrix_keypad_build_keymap(keymap_data, KBC_ROW_SHIFT,
> +                                input_dev->keycode, input_dev->keybit);
>
> -                     /* enable all the mapped keys. */
> -                     keycode = kbc->keycode[(j * KBC_MAX_COL) + i];
> -                     if (keycode != -1)
> -                             set_bit(keycode, kbc->idev->keybit);
> -
> -             }
> -     }
> -
> -     setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> -     /* Initialize the FIFO to invalid entries */
> -     for (i = 0; i < ARRAY_SIZE(kbc->fifo); i++)
> -             kbc->fifo[i] = -1;
> -
> -     /* keycode FIFO needs to be read atomically; leave local
> -      * interrupts disabled when handling KBC interrupt */
> -     err = request_irq(irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
> -             pdev->name, kbc);
> +     err = request_irq(kbc->irq, tegra_kbc_isr, IRQF_TRIGGER_HIGH,
> +                       pdev->name, kbc);
>       if (err) {
>               dev_err(&pdev->dev, "failed to request keyboard IRQ\n");
> -             goto fail_configurekeyboard;
> +             goto err_put_clk;
>       }
> -     kbc->irq = irq;
> +
> +     disable_irq(kbc->irq);
>
>       err = input_register_device(kbc->idev);
>       if (err) {
>               dev_err(&pdev->dev, "failed to register input device\n");
> -             goto fail_registerinput;
> +             goto err_free_irq;
>       }
>
> +     platform_set_drvdata(pdev, kbc);
>       device_init_wakeup(&pdev->dev, pdata->wakeup);
> +
>       return 0;
>
> -fail_registerinput:
> +err_free_irq:
>       free_irq(kbc->irq, pdev);
> -fail_configurekeyboard:
> +err_put_clk:
>       clk_put(kbc->clk);
> -fail_keyboardresource:
> +err_iounmap:
>       iounmap(kbc->mmio);
> -fail_memoryresource:
> +err_free_mem_region:
> +     release_mem_region(res->start, resource_size(res));
> +err_free_mem:
>       input_free_device(kbc->idev);
> -fail_allocateinput:
>       kfree(kbc);
> +
>       return err;
>  }
>
> +static int __devexit tegra_kbc_remove(struct platform_device *pdev)
> +{
> +     struct tegra_kbc *kbc = platform_get_drvdata(pdev);
> +     struct resource *res;
> +
> +     free_irq(kbc->irq, pdev);
> +     clk_put(kbc->clk);
> +
> +     input_unregister_device(kbc->idev);
> +     iounmap(kbc->mmio);
> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +     release_mem_region(res->start, resource_size(res));
> +
> +     kfree(kbc);
> +
> +     platform_set_drvdata(pdev, NULL);
> +
> +     return 0;
> +}
> +
>  #ifdef CONFIG_PM
>  static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
>  {
> @@ -577,7 +672,7 @@ static int tegra_kbc_suspend(struct platform_device *pdev,
> pm_message_t state)
>       } else {
>               mutex_lock(&kbc->idev->mutex);
>               if (kbc->idev->users)
> -                     tegra_kbc_close(kbc->idev);
> +                     tegra_kbc_stop(kbc);
>               mutex_unlock(&kbc->idev->mutex);
>       }
>
> @@ -595,7 +690,7 @@ static int tegra_kbc_resume(struct platform_device *pdev)
>       } else {
>               mutex_lock(&kbc->idev->mutex);
>               if (kbc->idev->users)
> -                     err = tegra_kbc_open(kbc->idev);
> +                     err = tegra_kbc_start(kbc);
>               mutex_unlock(&kbc->idev->mutex);
>       }
>
