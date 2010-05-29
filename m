Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0E2DgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:36:08 -0400
Received: from king.tilera.com ([72.1.168.226]:16063 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab0E2DfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:35:23 -0400
Message-Id: <201005290334.o4T3YR80029985@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:17:59 -0400
Subject: [PATCH 8/8] arch/tile: hypervisor console driver.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:34:28.0015 (UTC) FILETIME=[D78043F0:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/char/Makefile   |    1 +
 drivers/char/hvc_tile.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hvc_tile.c

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..f77099d 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
+obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
 obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
 obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
diff --git a/drivers/char/hvc_tile.c b/drivers/char/hvc_tile.c
new file mode 100644
index 0000000..75715b3
--- /dev/null
+++ b/drivers/char/hvc_tile.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Tilera TILE Processor hypervisor console
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+
+#include <hv/hypervisor.h>
+
+#include "hvc_console.h"
+
+static int hvc_tile_put_chars(uint32_t vt, const char *buf, int count)
+{
+	return hv_console_write((HV_VirtAddr)buf, count);
+}
+
+static int hvc_tile_get_chars(uint32_t vt, char *buf, int count)
+{
+	int i, c;
+
+	for (i = 0; i < count; ++i) {
+		c = hv_console_read_if_ready();
+		if (c < 0)
+			break;
+		buf[i] = c;
+	}
+
+	return i;
+}
+
+static const struct hv_ops hvc_tile_get_put_ops = {
+	.get_chars = hvc_tile_get_chars,
+	.put_chars = hvc_tile_put_chars,
+};
+
+static int __init hvc_tile_console_init(void)
+{
+	extern void disable_early_printk(void);
+	hvc_instantiate(0, 0, &hvc_tile_get_put_ops);
+	add_preferred_console("hvc", 0, NULL);
+	disable_early_printk();
+	return 0;
+}
+console_initcall(hvc_tile_console_init);
+
+static int __init hvc_tile_init(void)
+{
+	hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
+	return 0;
+}
+device_initcall(hvc_tile_init);
-- 
1.6.5.2

