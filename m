Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1EKVKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:10:42 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914Ab1EKVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:43 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] add support for C64x+ debugger based console
Date: Wed, 11 May 2011 16:13:51 -0400
Message-Id: <1305144843-5058-5-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-4-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Texas Instruments debugger support for the C64X+ family of DSPs includes a
console for the unit under test. This patch adds write-only console support
to send kernel output to the debugger. It is safe to have this driver in
place even if the system is not being run under the debugger.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/tty/hvc/Makefile  |    1 +
 drivers/tty/hvc/hvc_c6x.c |  125 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/hvc/hvc_c6x.c

diff --git a/drivers/tty/hvc/Makefile b/drivers/tty/hvc/Makefile
index 40a25d9..02e08cb 100644
--- a/drivers/tty/hvc/Makefile
+++ b/drivers/tty/hvc/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_HVC_IUCV)		+= hvc_iucv.o
 obj-$(CONFIG_HVC_UDBG)		+= hvc_udbg.o
 obj-$(CONFIG_HVC_BFIN_JTAG)	+= hvc_bfin_jtag.o
 obj-$(CONFIG_HVCS)		+= hvcs.o
+obj-$(CONFIG_HVC_C6X)		+= hvc_c6x.o
diff --git a/drivers/tty/hvc/hvc_c6x.c b/drivers/tty/hvc/hvc_c6x.c
new file mode 100644
index 0000000..54ea20b
--- /dev/null
+++ b/drivers/tty/hvc/hvc_c6x.c
@@ -0,0 +1,125 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  Based on hvc_tile.c
+ *  Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+/*
+ * TI C6X Host Port hypervisor console
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
+#define PARAMSIZE	8
+#define MSGSIZE		256
+
+#define CIO_READ	0xF2
+#define CIO_WRITE	0xF3
+
+#define CIO_STDIN	0
+#define CIO_STDOUT	1
+#define CIO_STDERR	2
+
+struct c6x_msg {
+	unsigned int	length;
+	unsigned char	command;
+	unsigned char	params[PARAMSIZE];
+	unsigned char	msg[MSGSIZE];
+};
+
+union c6x_msgparam {
+	unsigned char	params[PARAMSIZE];
+	struct {
+		unsigned short fd;
+		unsigned short count;
+	} host_write;
+};
+
+/*
+ * __CIOBUF__ and C$$IO$$ are special symbols for debugger.
+ *
+ * If debugger is running kernel, it will set a breakpoint
+ * at C$$IO$$ which is hit when the kernel wants attention
+ * from the debugger. __CIOBUF__ is used to pass messages
+ * between debugger and kernel when the breakpoint is hit.
+ */
+struct c6x_msg _CIOBUF_;
+
+static noinline void notify_debugger(void)
+{
+	asm volatile (".global C$$IO$$\n"
+		      "nop\n"
+		      "C$$IO$$: nop\n");
+}
+
+static int hvc_c6x_put_chars(uint32_t vt, const char *buf, int count)
+{
+	union c6x_msgparam params;
+	int to_write, remaining;
+
+	remaining = count;
+	while (remaining > 0) {
+		to_write = (remaining > MSGSIZE) ? MSGSIZE : remaining;
+
+		_CIOBUF_.length = to_write;
+		_CIOBUF_.command = CIO_WRITE;
+
+		params.host_write.fd = cpu_to_le16(CIO_STDOUT);
+		params.host_write.count = cpu_to_le16(to_write);
+		memcpy(_CIOBUF_.params, &params, PARAMSIZE);
+
+		memcpy(_CIOBUF_.msg, buf, to_write);
+
+		notify_debugger();
+
+		remaining -= to_write;
+	}
+	return count;
+}
+
+#ifdef CONFIG_EARLY_PRINTK
+void hvc_c6x_early_puts(const char *buf, unsigned count)
+{
+	hvc_c6x_put_chars(0, buf, count);
+}
+#endif
+
+static int hvc_c6x_get_chars(uint32_t vt, char *buf, int count)
+{
+	return 0;
+}
+
+static const struct hv_ops hvc_c6x_get_put_ops = {
+	.get_chars = hvc_c6x_get_chars,
+	.put_chars = hvc_c6x_put_chars,
+};
+
+static int __init hvc_c6x_console_init(void)
+{
+	hvc_instantiate(0, 0, &hvc_c6x_get_put_ops);
+	add_preferred_console("hvc", 0, NULL);
+	return 0;
+}
+console_initcall(hvc_c6x_console_init);
+
+static int __init hvc_c6x_init(void)
+{
+	struct hvc_struct *s;
+	s = hvc_alloc(0, 0, &hvc_c6x_get_put_ops, 128);
+	return IS_ERR(s) ? PTR_ERR(s) : 0;
+}
+device_initcall(hvc_c6x_init);
-- 
1.6.2.5

