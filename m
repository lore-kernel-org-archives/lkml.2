Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1ALAxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:53:04 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47902 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab1ALAw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:52:58 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: device-drivers-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] drivers: char: hvc: add Blackfin JTAG console support
Date: Tue, 11 Jan 2011 20:00:49 -0500
Message-Id: <1294794049-17337-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.rc1
In-Reply-To: <1294794049-17337-1-git-send-email-vapier@gentoo.org>
References: <1294794049-17337-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the existing bfin_jtag_comm TTY driver to the HVC layer so
that the common HVC code can worry about all of the TTY/polling crap and
leave the Blackfin code to worry about the Blackfin bits.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/char/Kconfig         |    9 ++++
 drivers/char/Makefile        |    1 +
 drivers/char/hvc_bfin_jtag.c |  105 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/hvc_bfin_jtag.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4498e2a..9c7fed8 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -731,6 +731,15 @@ config HVC_UDBG
        select HVC_DRIVER
        default n
 
+config HVC_BFIN_JTAG
+	bool "Blackfin JTAG console"
+	depends on BLACKFIN
+	select HVC_DRIVER
+	help
+	 This console uses the Blackfin JTAG to create a console under the
+	 the HVC driver.  If you don't have JTAG, then you probably don't
+	 want this option.
+
 config VIRTIO_CONSOLE
 	tristate "Virtio console"
 	depends on VIRTIO
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ccd666f..ae0e062 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_HVC_IRQ)		+= hvc_irq.o
 obj-$(CONFIG_HVC_XEN)		+= hvc_xen.o
 obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
 obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
+obj-$(CONFIG_HVC_BFIN_JTAG)	+= hvc_bfin_jtag.o
 obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
diff --git a/drivers/char/hvc_bfin_jtag.c b/drivers/char/hvc_bfin_jtag.c
new file mode 100644
index 0000000..31d6cc6
--- /dev/null
+++ b/drivers/char/hvc_bfin_jtag.c
@@ -0,0 +1,105 @@
+/*
+ * Console via Blackfin JTAG Communication
+ *
+ * Copyright 2008-2011 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+
+#include "hvc_console.h"
+
+/* See the Debug/Emulation chapter in the HRM */
+#define EMUDOF   0x00000001	/* EMUDAT_OUT full & valid */
+#define EMUDIF   0x00000002	/* EMUDAT_IN full & valid */
+#define EMUDOOVF 0x00000004	/* EMUDAT_OUT overflow */
+#define EMUDIOVF 0x00000008	/* EMUDAT_IN overflow */
+
+/* Helper functions to glue the register API to simple C operations */
+static inline uint32_t bfin_write_emudat(uint32_t emudat)
+{
+	__asm__ __volatile__("emudat = %0;" : : "d"(emudat));
+	return emudat;
+}
+
+static inline uint32_t bfin_read_emudat(void)
+{
+	uint32_t emudat;
+	__asm__ __volatile__("%0 = emudat;" : "=d"(emudat));
+	return emudat;
+}
+
+/* Send data to the host */
+static int hvc_bfin_put_chars(uint32_t vt, const char *buf, int count)
+{
+	static uint32_t outbound_len;
+	uint32_t emudat;
+	int ret;
+
+	if (bfin_read_DBGSTAT() & EMUDOF)
+		return 0;
+
+	if (!outbound_len) {
+		outbound_len = count;
+		bfin_write_emudat(outbound_len);
+		return 0;
+	}
+
+	ret = min(outbound_len, (uint32_t)4);
+	memcpy(&emudat, buf, ret);
+	bfin_write_emudat(emudat);
+	outbound_len -= ret;
+
+	return ret;
+}
+
+/* Receive data from the host */
+static int hvc_bfin_get_chars(uint32_t vt, char *buf, int count)
+{
+	static uint32_t inbound_len;
+	uint32_t emudat;
+	int ret;
+
+	if (!(bfin_read_DBGSTAT() & EMUDIF))
+		return 0;
+	emudat = bfin_read_emudat();
+
+	if (!inbound_len) {
+		inbound_len = emudat;
+		return 0;
+	}
+
+	ret = min(inbound_len, (uint32_t)4);
+	memcpy(buf, &emudat, ret);
+	inbound_len -= ret;
+
+	return ret;
+}
+
+/* Glue the HVC layers to the Blackfin layers */
+static const struct hv_ops hvc_bfin_get_put_ops = {
+	.get_chars = hvc_bfin_get_chars,
+	.put_chars = hvc_bfin_put_chars,
+};
+
+static int __init hvc_bfin_console_init(void)
+{
+	hvc_instantiate(0, 0, &hvc_bfin_get_put_ops);
+	return 0;
+}
+console_initcall(hvc_bfin_console_init);
+
+static int __init hvc_bfin_init(void)
+{
+	hvc_alloc(0, 0, &hvc_bfin_get_put_ops, 128);
+	return 0;
+}
+device_initcall(hvc_bfin_init);
-- 
1.7.4.rc1

