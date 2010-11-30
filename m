Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0K3T0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:26:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41586 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0K3T0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:26:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6183"; a="64904509"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
Date: Tue, 30 Nov 2010 11:25:39 -0800
Message-Id: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds a basic console that uses the arm JTAG
DCC to transfer data back and forth. It has support for
ARMv6 and ARMv7.

This console is created under the HVC driver, and should be named
/dev/hvcX (or /dev/hvc0 for example).

Cc: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/char/Kconfig   |    9 +++
 drivers/char/Makefile  |    1 +
 drivers/char/hvc_dcc.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hvc_dcc.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..d4a7776 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -682,6 +682,15 @@ config HVC_UDBG
        select HVC_DRIVER
        default n
 
+config HVC_DCC
+       bool "ARM JTAG DCC console"
+       depends on ARM
+       select HVC_DRIVER
+       help
+         This console uses the JTAG DCC on ARM to create a console under the HVC
+	 driver. This console is used through a JTAG only on ARM. If you don't have
+	 a JTAG then you probably don't want this option.
+
 config VIRTIO_CONSOLE
 	tristate "Virtio console"
 	depends on VIRTIO
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ba53ec9..fa0b824 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_HVC_CONSOLE)	+= hvc_vio.o hvsi.o
 obj-$(CONFIG_HVC_ISERIES)	+= hvc_iseries.o
 obj-$(CONFIG_HVC_RTAS)		+= hvc_rtas.o
 obj-$(CONFIG_HVC_TILE)		+= hvc_tile.o
+obj-$(CONFIG_HVC_DCC)		+= hvc_dcc.o
 obj-$(CONFIG_HVC_BEAT)		+= hvc_beat.o
 obj-$(CONFIG_HVC_DRIVER)	+= hvc_console.o
 obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
new file mode 100644
index 0000000..6470f63
--- /dev/null
+++ b/drivers/char/hvc_dcc.c
@@ -0,0 +1,133 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+
+#include <asm/processor.h>
+
+#include "hvc_console.h"
+
+/* DCC Status Bits */
+#define DCC_STATUS_RX		(1 << 30)
+#define DCC_STATUS_TX		(1 << 29)
+
+static inline u32 __dcc_getstatus(void)
+{
+	u32 __ret;
+
+	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
+		: "=r" (__ret) : : "cc");
+
+	return __ret;
+}
+
+
+#if defined(CONFIG_CPU_V7)
+static inline char __dcc_getchar(void)
+{
+	char __c;
+
+	asm("get_wait:	mrc p14, 0, pc, c0, c1, 0                          \n\
+			bne get_wait                                       \n\
+			mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
+		: "=r" (__c) : : "cc");
+
+	return __c;
+}
+#else
+static inline char __dcc_getchar(void)
+{
+	char __c;
+
+	asm("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
+		: "=r" (__c));
+
+	return __c;
+}
+#endif
+
+#if defined(CONFIG_CPU_V7)
+static inline void __dcc_putchar(char c)
+{
+	asm("put_wait:	mrc p14, 0, pc, c0, c1, 0                 \n\
+			bcs put_wait                              \n\
+			mcr p14, 0, %0, c0, c5, 0                   "
+	: : "r" (c) : "cc");
+}
+#else
+static inline void __dcc_putchar(char c)
+{
+	asm("mcr p14, 0, %0, c0, c5, 0	@ write a char"
+		: /* no output register */
+		: "r" (c));
+}
+#endif
+
+static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		while (__dcc_getstatus() & DCC_STATUS_TX)
+			cpu_relax();
+
+		__dcc_putchar((char)(buf[i] & 0xFF));
+	}
+
+	return count;
+}
+
+static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
+{
+	int i;
+
+	for (i = 0; i < count; ++i) {
+		int c = -1;
+
+		if (__dcc_getstatus() & DCC_STATUS_RX)
+			c = __dcc_getchar();
+		if (c < 0)
+			break;
+		buf[i] = c;
+	}
+
+	return i;
+}
+
+static const struct hv_ops hvc_dcc_get_put_ops = {
+	.get_chars = hvc_dcc_get_chars,
+	.put_chars = hvc_dcc_put_chars,
+};
+
+static int __init hvc_dcc_console_init(void)
+{
+	hvc_instantiate(0, 0, &hvc_dcc_get_put_ops);
+	return 0;
+}
+console_initcall(hvc_dcc_console_init);
+
+static int __init hvc_dcc_init(void)
+{
+	hvc_alloc(0, 0, &hvc_dcc_get_put_ops, 128);
+	return 0;
+}
+device_initcall(hvc_dcc_init);
-- 
1.7.1

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
