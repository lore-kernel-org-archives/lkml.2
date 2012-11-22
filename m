Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2KVS1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:27:42 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:61958 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab2KVS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:27:38 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
From: Lars Poeschel <poeschel@lemonage.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] video console: add a driver for lcd2s character display
Date: Thu, 22 Nov 2012 10:33:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, FlorianSchandinat@gmx.de,
        mathieu.poirier@linaro.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353416206-3243-1-git-send-email-larsi@wh2.tu-dresden.de> <201211201521.33726.poeschel@lemonage.de> <201211201611.28646.arnd@arndb.de>
In-Reply-To: <201211201611.28646.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211221033.41987.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This driver allows to use a lcd2s 20x4 character display as
a linux console output device.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/video/console/Kconfig    |   10 ++
 drivers/video/console/Makefile   |    1 +
 drivers/video/console/lcd2scon.c |  360 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 371 insertions(+)
 create mode 100644 drivers/video/console/lcd2scon.c

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index e2c96d0..44fc3bf 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -129,6 +129,16 @@ config STI_CONSOLE
           machines.  Say Y here to build support for it into your kernel.
           The alternative is to use your primary serial port as a console.
 
+config LCD2S_CONSOLE
+        tristate "lcd2s 20x4 character display over I2C console"
+        depends on I2C
+        default n
+        help
+          This is a driver that lets you use the lcd2s 20x4 character display
+          from modtronix engineering as a console output device. The display
+          is a simple single color character display. You have to connect it
+          to an I2C bus.
+
 config FONTS
 	bool "Select compiled-in fonts"
 	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
index a862e91..74d5993 100644
--- a/drivers/video/console/Makefile
+++ b/drivers/video/console/Makefile
@@ -23,6 +23,7 @@ font-objs += $(font-objs-y)
 obj-$(CONFIG_DUMMY_CONSOLE)       += dummycon.o
 obj-$(CONFIG_SGI_NEWPORT_CONSOLE) += newport_con.o font.o
 obj-$(CONFIG_STI_CONSOLE)         += sticon.o sticore.o font.o
+obj-$(CONFIG_LCD2S_CONSOLE)       += lcd2scon.o
 obj-$(CONFIG_VGA_CONSOLE)         += vgacon.o
 obj-$(CONFIG_MDA_CONSOLE)         += mdacon.o
 obj-$(CONFIG_FRAMEBUFFER_CONSOLE) += fbcon.o bitblit.o font.o softcursor.o
diff --git a/drivers/video/console/lcd2scon.c b/drivers/video/console/lcd2scon.c
new file mode 100644
index 0000000..c139811
--- /dev/null
+++ b/drivers/video/console/lcd2scon.c
@@ -0,0 +1,360 @@
+/*
+ *  console driver for LCD2S 4x20 character displays connected through i2c.
+ *
+ *  This is a driver allowing you to use a LCD2S 4x20 from modtronix
+ *  engineering as console output device.
+ *
+ *  (C) 2012 by Lemonage Software GmbH
+ *  Author: Lars Poeschel <poeschel@lemonage.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kd.h>
+#include <linux/tty.h>
+#include <linux/console_struct.h>
+#include <linux/console.h>
+#include <linux/vt_kern.h>
+#include <linux/i2c.h>
+
+#define LCD2S_CMD_CUR_BLINK_OFF		0x10
+#define LCD2S_CMD_CUR_UL_OFF		0x11
+#define LCD2S_CMD_DISPLAY_OFF		0x12
+#define LCD2S_CMD_CUR_BLINK_ON		0x18
+#define LCD2S_CMD_CUR_UL_ON		0x19
+#define LCD2S_CMD_DISPLAY_ON		0x1a
+#define LCD2S_CMD_BACKLIGHT_OFF		0x20
+#define LCD2S_CMD_BACKLIGHT_ON		0x28
+#define LCD2S_CMD_WRITE			0x80
+#define LCD2S_CMD_SHIFT_UP		0x87
+#define LCD2S_CMD_SHIFT_DOWN		0x88
+#define LCD2S_CMD_CUR_ADDR		0x89
+#define LCD2S_CMD_CUR_POS		0x8a
+#define LCD2S_CMD_CUR_RESET		0x8b
+#define LCD2S_CMD_CLEAR			0x8c
+
+#define LCD2S_FIRST			8
+#define LCD2S_LAST			9
+
+#define LCD2S_ROWS			4
+#define LCD2S_COLS			20
+
+struct lcd2s_data {
+	struct i2c_client *i2c;
+	int row;
+	int col;
+	unsigned int cur_blink:1;
+	unsigned int cur_ul:1;
+};
+
+static struct lcd2s_data lcd2s;
+
+static void lcd2s_set_cursor(int row, int col)
+{
+	u8 buf[] = { LCD2S_CMD_CUR_POS, row + 1, col + 1};
+
+	if (row == lcd2s.row && col == lcd2s.col)
+		return;
+
+	i2c_master_send(lcd2s.i2c, buf, sizeof(buf));
+	lcd2s.row = row;
+	lcd2s.col = col;
+}
+
+static void lcd2s_reset_cursor(void)
+{
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CUR_RESET);
+	lcd2s.row = 0;
+	lcd2s.col = 0;
+}
+
+static void lcd2s_increase_cursor(struct vc_data *con, int inc)
+{
+	lcd2s.col += inc;
+	if ((lcd2s.col / con->vc_cols) >= 1) {
+		lcd2s.row += (lcd2s.col / con->vc_cols);
+		lcd2s.col %= con->vc_cols;
+	}
+}
+
+static void lcd2s_cursor_ul_on(void)
+{
+	if (!lcd2s.cur_ul) {
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CUR_UL_ON);
+		lcd2s.cur_ul = 1;
+	}
+}
+
+static void lcd2s_cursor_ul_off(void)
+{
+	if (lcd2s.cur_ul) {
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CUR_UL_OFF);
+		lcd2s.cur_ul = 0;
+	}
+}
+
+static void lcd2s_cursor_blink_on(void)
+{
+	if (!lcd2s.cur_blink) {
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CUR_BLINK_ON);
+		lcd2s.cur_blink = 1;
+	}
+}
+
+static void lcd2s_cursor_blink_off(void)
+{
+	if (lcd2s.cur_blink) {
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CUR_BLINK_OFF);
+		lcd2s.cur_blink = 0;
+	}
+}
+
+static const char *lcd2s_startup(void)
+{
+	return "lcd2s console";
+}
+
+
+/*
+ * init is set if console is currently allocated during init
+ */
+static void lcd2s_init(struct vc_data *con, int init)
+{
+	lcd2s.cur_blink = 0;
+	lcd2s.cur_ul = 0;
+
+	/* turn display on */
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_DISPLAY_ON);
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_BACKLIGHT_ON);
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CLEAR);
+	lcd2s_cursor_ul_on();
+	lcd2s_reset_cursor();
+
+	con->vc_can_do_color = 0;
+	con->vc_hi_font_mask = 0;
+
+	if (init) {
+		con->vc_rows = LCD2S_ROWS;
+		con->vc_cols = LCD2S_COLS;
+	} else
+		vc_resize(con, LCD2S_COLS, LCD2S_ROWS);
+}
+
+static void lcd2s_deinit(struct vc_data *con)
+{
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_DISPLAY_OFF);
+	i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_BACKLIGHT_OFF);
+	lcd2s_cursor_blink_off();
+	lcd2s_cursor_ul_off();
+}
+
+static void lcd2s_clear(struct vc_data *con, int s_row, int s_col,
+			int height, int width)
+{
+	u8 buf[width];
+	int i;
+
+	if (width <= 0 || height <= 0)
+		return;
+
+	/* if the whole display is to clear, we have a single command */
+	if (s_col == 0 && s_row == 0 &&
+		height >= con->vc_rows - 1 && width >= con->vc_cols - 1) {
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_CLEAR);
+		return;
+	}
+
+	for (i = 0; i <= width; i++)
+		buf[i] = ' ';
+
+	for (i = s_col; i <= height; i++) {
+		lcd2s_set_cursor(s_row, i);
+		i2c_master_send(lcd2s.i2c, buf, width);
+	}
+}
+
+static void lcd2s_putc(struct vc_data *con, int data, int row, int col)
+{
+	u8 buf[] = {LCD2S_CMD_WRITE, data};
+
+	lcd2s_set_cursor(row, col);
+
+	i2c_master_send(lcd2s.i2c, buf, sizeof(buf));
+	lcd2s_increase_cursor(con, 1);
+}
+
+static void lcd2s_putcs(struct vc_data *con, const unsigned short *buf,
+			int len, int row, int col)
+{
+	u8 *i2c_buf;
+	int i;
+
+	i2c_buf = kzalloc(len + 1, GFP_KERNEL);
+	if (!i2c_buf)
+		return;
+
+	lcd2s_set_cursor(row, col);
+
+	i2c_buf[0] = LCD2S_CMD_WRITE;
+	for (i = 0; i < len ; i++)
+		i2c_buf[i + 1] = buf[i];
+
+	i2c_master_send(lcd2s.i2c, i2c_buf, len + 1);
+	kfree(i2c_buf);
+	lcd2s_increase_cursor(con, len);
+}
+
+static void lcd2s_cursor(struct vc_data *con, int mode)
+{
+	switch (mode) {
+	case CM_ERASE:
+		lcd2s_cursor_blink_off();
+		lcd2s_cursor_ul_off();
+		break;
+	case CM_MOVE:
+	case CM_DRAW:
+		lcd2s_set_cursor(con->vc_y, con->vc_x);
+
+		switch (con->vc_cursor_type & CUR_HWMASK) {
+		case CUR_UNDERLINE:
+			lcd2s_cursor_ul_on();
+			lcd2s_cursor_blink_off();
+			break;
+		case CUR_NONE:
+			lcd2s_cursor_blink_off();
+			lcd2s_cursor_ul_off();
+			break;
+		default:
+			lcd2s_cursor_blink_on();
+			lcd2s_cursor_ul_off();
+			break;
+		}
+		break;
+	}
+}
+
+static int lcd2s_scroll(struct vc_data *con, int top, int bot,
+			int dir, int lines)
+{
+	/* we can only scroll the whole display */
+	if (top == 0 && bot == con->vc_rows) {
+		while (lines--) {
+			switch (dir) {
+			case SM_UP:
+				i2c_smbus_write_byte(lcd2s.i2c,
+					LCD2S_CMD_SHIFT_UP);
+				break;
+			case SM_DOWN:
+				i2c_smbus_write_byte(lcd2s.i2c,
+					LCD2S_CMD_SHIFT_DOWN);
+				break;
+			}
+		}
+		return 0;
+	}
+	return 1;
+}
+
+static void lcd2s_bmove(struct vc_data *conp, int s_row, int s_col,
+			int d_row, int d_col, int height, int width)
+{
+}
+
+static int lcd2s_switch(struct vc_data *con)
+{
+	return 1;
+}
+
+static int lcd2s_blank(struct vc_data *con, int blank, int mode_switch)
+{
+	switch (blank) {
+	case 0:		/* unblank */
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_DISPLAY_ON);
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_BACKLIGHT_ON);
+		break;
+	case 1:		/* normal blanking */
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_DISPLAY_OFF);
+		i2c_smbus_write_byte(lcd2s.i2c, LCD2S_CMD_BACKLIGHT_OFF);
+		break;
+	}
+	return 0;
+}
+
+static int lcd2s_set_palette(struct vc_data *con, unsigned char *table)
+{
+	return -EINVAL;
+}
+
+static int lcd2s_scrolldelta(struct vc_data *con, int lines)
+{
+	return 0;
+}
+
+static struct consw lcd2s_con = {
+	.owner			= THIS_MODULE,
+	.con_startup		= lcd2s_startup,
+	.con_init		= lcd2s_init,
+	.con_deinit		= lcd2s_deinit,
+	.con_clear		= lcd2s_clear,
+	.con_putc		= lcd2s_putc,
+	.con_putcs		= lcd2s_putcs,
+	.con_cursor		= lcd2s_cursor,
+	.con_scroll		= lcd2s_scroll,
+	.con_bmove		= lcd2s_bmove,
+	.con_switch		= lcd2s_switch,
+	.con_blank		= lcd2s_blank,
+	.con_set_palette	= lcd2s_set_palette,
+	.con_scrolldelta	= lcd2s_scrolldelta,
+};
+
+static int __devinit lcd2s_i2c_probe(struct i2c_client *i2c,
+				const struct i2c_device_id *id)
+{
+	if (!i2c_check_functionality(i2c->adapter,
+			I2C_FUNC_SMBUS_WRITE_BYTE_DATA |
+			I2C_FUNC_SMBUS_WRITE_BLOCK_DATA))
+		return -EIO;
+
+	lcd2s.i2c = i2c;
+
+	take_over_console(&lcd2s_con, LCD2S_FIRST, LCD2S_LAST, 1);
+
+	return 0;
+}
+
+static __devexit int lcd2s_i2c_remove(struct i2c_client *i2c)
+{
+	/* unregister from console subsystem */
+	unregister_con_driver(&lcd2s_con);
+	return 0;
+}
+
+static const struct i2c_device_id lcd2s_i2c_id[] = {
+	{ "lcd2s", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lcd2s_i2c_id);
+
+static struct i2c_driver lcd2s_i2c_driver = {
+	.driver = {
+		.name = "lcd2s",
+		.owner = THIS_MODULE,
+	},
+	.probe = lcd2s_i2c_probe,
+	.remove = __devexit_p(lcd2s_i2c_remove),
+	.id_table = lcd2s_i2c_id,
+};
+
+module_i2c_driver(lcd2s_i2c_driver)
+
+MODULE_DESCRIPTION("LCD2S character display console driver");
+MODULE_AUTHOR("Lars Poeschel");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

