Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1B0QEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:04:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:58529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab1B0QBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:39 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 04/17] unicore32 machine related files: ps2 driver
Date: Sun, 27 Feb 2011 15:59:32 +0000
Message-Id: <1cecab844aa5717d0b989e5a1417af0825f9ceca.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

This patch implements arch-specific ps2 driver.

By reviewed with Dmitry Torokhov:
     1. move i8042-ucio.h to drivers/input/serio/i8042-unicore32io.h
     2. move puv3_ps2_init() to arch/unicore32/kernel/puv3-core.c
     3. remove unused comments.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/i8042-unicore32io.h |   70 +++++++++++++++++++++++++++++++
 drivers/input/serio/i8042.h             |    2 +
 2 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/i8042-unicore32io.h

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
new file mode 100644
index 0000000..6a7e8b3
--- /dev/null
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -0,0 +1,70 @@
+/*
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2011 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _I8042_UNICORE32_H
+#define _I8042_UNICORE32_H
+
+#include <mach/hardware.h>
+
+/*
+ * Names.
+ */
+#define I8042_KBD_PHYS_DESC "isa0060/serio0"
+#define I8042_AUX_PHYS_DESC "isa0060/serio1"
+#define I8042_MUX_PHYS_DESC "isa0060/serio%d"
+
+/*
+ * IRQs.
+ */
+#define I8042_KBD_IRQ           IRQ_PS2_KBD
+#define I8042_AUX_IRQ           IRQ_PS2_AUX
+
+/*
+ * Register numbers.
+ */
+#define I8042_COMMAND_REG	((unsigned long)&PS2_COMMAND)
+#define I8042_STATUS_REG	((unsigned long)&PS2_STATUS)
+#define I8042_DATA_REG		((unsigned long)&PS2_DATA)
+
+static inline int i8042_read_data(void)
+{
+	return inb(I8042_DATA_REG);
+}
+
+static inline int i8042_read_status(void)
+{
+	return inb(I8042_STATUS_REG);
+}
+
+static inline void i8042_write_data(int val)
+{
+	outb(val, I8042_DATA_REG);
+}
+
+static inline void i8042_write_command(int val)
+{
+	outb(val, I8042_COMMAND_REG);
+}
+
+static inline int i8042_platform_init(void)
+{
+	if (!request_region(I8042_DATA_REG, 16, "i8042"))
+		return -EBUSY;
+
+	i8042_reset = 1;
+	return 0;
+}
+
+static inline void i8042_platform_exit(void)
+{
+	release_region(I8042_DATA_REG, 16);
+}
+
+#endif /* _I8042_UNICORE32_H */
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index ac1d759..3452708 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -26,6 +26,8 @@
 #include "i8042-sparcio.h"
 #elif defined(CONFIG_X86) || defined(CONFIG_IA64)
 #include "i8042-x86ia64io.h"
+#elif defined(CONFIG_UNICORE32)
+#include "i8042-unicore32io.h"
 #else
 #include "i8042-io.h"
 #endif
-- 
1.7.4.1

