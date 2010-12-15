Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0LOSW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:22:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0LOSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:22:54 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66956643"
From: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Brian Swetland <swetland@google.com>
Subject: [PATCH] msm: smd: Add smd_tty driver
Date: Wed, 15 Dec 2010 10:22:08 -0800
Message-Id: <1292437328-11432-1-git-send-email-nvishwan@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add smd_tty driver which provides tty device interface
to 'DS' and 'GPSNMEA' streaming SMD ports.

Cc: Brian Swetland <swetland@google.com>
Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
---
 drivers/char/Kconfig       |    8 ++
 drivers/char/Makefile      |    2 +
 drivers/char/msm_smd_tty.c |  226 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 236 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/msm_smd_tty.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..3d53383 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1144,5 +1144,13 @@ config RAMOOPS
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in RAM where it can be read back at some later point.
 
+config MSM_SMD_TTY
+	bool "Enable tty device interface for some SMD ports"
+	default n
+	depends on MSM_SMD
+	help
+	  Enables userspace clients to read and write to some streaming SMD
+	  ports via tty device interface for MSM chipset.
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ba53ec9..78e3c15 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -98,3 +98,5 @@ obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
+
+obj-$(CONFIG_MSM_SMD_TTY)	+= msm_smd_tty.o
diff --git a/drivers/char/msm_smd_tty.c b/drivers/char/msm_smd_tty.c
new file mode 100644
index 0000000..7e0b963
--- /dev/null
+++ b/drivers/char/msm_smd_tty.c
@@ -0,0 +1,226 @@
+/* arch/arm/mach-msm/smd_tty.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: Brian Swetland <swetland@google.com>
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
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+
+#include <mach/msm_smd.h>
+
+#define MAX_SMD_TTYS 32
+
+static DEFINE_MUTEX(smd_tty_lock);
+
+struct smd_tty_info {
+	smd_channel_t *ch;
+	struct tty_struct *tty;
+	int open_count;
+};
+
+struct smd_tty_channel_desc {
+	int id;
+	const char *name;
+};
+
+static struct smd_tty_info smd_tty[MAX_SMD_TTYS];
+
+static const struct smd_tty_channel_desc smd_default_tty_channels[] = {
+	{ .id = 0, .name = "SMD_DS" },
+	{ .id = 27, .name = "SMD_GPSNMEA" },
+};
+
+static const struct smd_tty_channel_desc *smd_tty_channels =
+		smd_default_tty_channels;
+static int smd_tty_channels_len = ARRAY_SIZE(smd_default_tty_channels);
+
+static void smd_tty_notify(void *priv, unsigned event)
+{
+	unsigned char *ptr;
+	int avail;
+	struct smd_tty_info *info = priv;
+	struct tty_struct *tty = info->tty;
+
+	if (!tty)
+		return;
+
+	if (event != SMD_EVENT_DATA)
+		return;
+
+	for (;;) {
+		if (test_bit(TTY_THROTTLED, &tty->flags))
+			break;
+		avail = smd_read_avail(info->ch);
+		if (avail == 0)
+			break;
+
+		avail = tty_prepare_flip_string(tty, &ptr, avail);
+
+		if (smd_read(info->ch, ptr, avail) != avail) {
+			/* shouldn't be possible since we're in interrupt
+			** context here and nobody else could 'steal' our
+			** characters.
+			*/
+			printk(KERN_ERR "OOPS - smd_tty_buffer mismatch?!");
+		}
+
+		tty_flip_buffer_push(tty);
+	}
+
+	/* XXX only when writable and necessary */
+	tty_wakeup(tty);
+}
+
+static int smd_tty_open(struct tty_struct *tty, struct file *f)
+{
+	int res = 0;
+	int n = tty->index;
+	struct smd_tty_info *info;
+	const char *name = NULL;
+	int i;
+
+	for (i = 0; i < smd_tty_channels_len; i++) {
+		if (smd_tty_channels[i].id == n) {
+			name = smd_tty_channels[i].name;
+			break;
+		}
+	}
+	if (!name)
+		return -ENODEV;
+
+	info = smd_tty + n;
+
+	mutex_lock(&smd_tty_lock);
+	tty->driver_data = info;
+
+	if (info->open_count++ == 0) {
+		info->tty = tty;
+		if (info->ch)
+			smd_kick(info->ch);
+		else
+			res = smd_open(name, &info->ch, info, smd_tty_notify);
+	}
+	mutex_unlock(&smd_tty_lock);
+
+	return res;
+}
+
+static void smd_tty_close(struct tty_struct *tty, struct file *f)
+{
+	struct smd_tty_info *info = tty->driver_data;
+
+	if (info == 0)
+		return;
+
+	mutex_lock(&smd_tty_lock);
+	if (--info->open_count == 0) {
+		info->tty = 0;
+		tty->driver_data = 0;
+		if (info->ch) {
+			smd_close(info->ch);
+			info->ch = 0;
+		}
+	}
+	mutex_unlock(&smd_tty_lock);
+}
+
+static int smd_tty_write(struct tty_struct *tty,
+			 const unsigned char *buf, int len)
+{
+	struct smd_tty_info *info = tty->driver_data;
+	int avail;
+
+	/* if we're writing to a packet channel we will
+	** never be able to write more data than there
+	** is currently space for
+	*/
+	avail = smd_write_avail(info->ch);
+	if (len > avail)
+		len = avail;
+
+	return smd_write(info->ch, buf, len);
+}
+
+static int smd_tty_write_room(struct tty_struct *tty)
+{
+	struct smd_tty_info *info = tty->driver_data;
+	return smd_write_avail(info->ch);
+}
+
+static int smd_tty_chars_in_buffer(struct tty_struct *tty)
+{
+	struct smd_tty_info *info = tty->driver_data;
+	return smd_read_avail(info->ch);
+}
+
+static void smd_tty_unthrottle(struct tty_struct *tty)
+{
+	struct smd_tty_info *info = tty->driver_data;
+	smd_kick(info->ch);
+}
+
+static const struct tty_operations smd_tty_ops = {
+	.open = smd_tty_open,
+	.close = smd_tty_close,
+	.write = smd_tty_write,
+	.write_room = smd_tty_write_room,
+	.chars_in_buffer = smd_tty_chars_in_buffer,
+	.unthrottle = smd_tty_unthrottle,
+};
+
+static struct tty_driver *smd_tty_driver;
+
+static int __init smd_tty_init(void)
+{
+	int ret, i;
+
+	smd_tty_driver = alloc_tty_driver(MAX_SMD_TTYS);
+	if (smd_tty_driver == 0)
+		return -ENOMEM;
+
+	smd_tty_driver->owner = THIS_MODULE;
+	smd_tty_driver->driver_name = "smd_tty_driver";
+	smd_tty_driver->name = "smd";
+	smd_tty_driver->major = 0;
+	smd_tty_driver->minor_start = 0;
+	smd_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	smd_tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	smd_tty_driver->init_termios = tty_std_termios;
+	smd_tty_driver->init_termios.c_iflag = 0;
+	smd_tty_driver->init_termios.c_oflag = 0;
+	smd_tty_driver->init_termios.c_cflag = B38400 | CS8 | CREAD;
+	smd_tty_driver->init_termios.c_lflag = 0;
+	smd_tty_driver->flags = TTY_DRIVER_RESET_TERMIOS |
+		TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(smd_tty_driver, &smd_tty_ops);
+
+	ret = tty_register_driver(smd_tty_driver);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < smd_tty_channels_len; i++)
+		tty_register_device(smd_tty_driver, smd_tty_channels[i].id, 0);
+
+	return 0;
+}
+
+module_init(smd_tty_init);
-- 
1.5.6.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
