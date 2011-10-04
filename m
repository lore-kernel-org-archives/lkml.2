Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1JDQou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab1JDQob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:31 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 21/24] C6X: general SoC support
Date: Tue,  4 Oct 2011 12:43:58 -0400
Message-Id: <1317746641-26725-22-git-send-email-msalter@redhat.com>
In-Reply-To: <1317746641-26725-1-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a soc_ops struct which provides hooks for SoC functionality
which doesn't fit well into other places.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 arch/c6x/include/asm/soc.h |   35 +++++++++++++++++
 arch/c6x/kernel/soc.c      |   91 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/soc.h
 create mode 100644 arch/c6x/kernel/soc.c

diff --git a/arch/c6x/include/asm/soc.h b/arch/c6x/include/asm/soc.h
new file mode 100644
index 0000000..43f5015
--- /dev/null
+++ b/arch/c6x/include/asm/soc.h
@@ -0,0 +1,35 @@
+/*
+ * Miscellaneous SoC-specific hooks.
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+#ifndef _ASM_C6X_SOC_H
+#define _ASM_C6X_SOC_H
+
+struct soc_ops {
+	/* Return active exception event or -1 if none */
+	int		(*get_exception)(void);
+
+	/* Assert an event */
+	void		(*assert_event)(unsigned int evt);
+};
+
+extern struct soc_ops soc_ops;
+
+extern int soc_get_exception(void);
+extern void soc_assert_event(unsigned int event);
+extern int soc_mac_addr(unsigned int index, u8 *addr);
+
+/*
+ * for mmio on SoC devices. regs are always same byte order as cpu.
+ */
+#define soc_readl(addr)    __raw_readl(addr)
+#define soc_writel(b, addr) __raw_writel((b), (addr))
+
+#endif /* _ASM_C6X_SOC_H */
diff --git a/arch/c6x/kernel/soc.c b/arch/c6x/kernel/soc.c
new file mode 100644
index 0000000..dd45bc3
--- /dev/null
+++ b/arch/c6x/kernel/soc.c
@@ -0,0 +1,91 @@
+/*
+ *  Miscellaneous SoC-specific hooks.
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/etherdevice.h>
+#include <asm/system.h>
+#include <asm/setup.h>
+#include <asm/soc.h>
+
+struct soc_ops soc_ops;
+
+int soc_get_exception(void)
+{
+	if (!soc_ops.get_exception)
+		return -1;
+	return soc_ops.get_exception();
+}
+
+void soc_assert_event(unsigned int evt)
+{
+	if (soc_ops.assert_event)
+		soc_ops.assert_event(evt);
+}
+
+static u8 cmdline_mac[6];
+
+static int __init get_mac_addr_from_cmdline(char *str)
+{
+	int count, i, val;
+
+	for (count = 0; count < 6 && *str; count++, str += 3) {
+		if (!isxdigit(str[0]) || !isxdigit(str[1]))
+			return 0;
+		if (str[2] != ((count < 5) ? ':' : '\0'))
+			return 0;
+
+		for (i = 0, val = 0; i < 2; i++) {
+			val = val << 4;
+			val |= isdigit(str[i]) ?
+				str[i] - '0' : toupper(str[i]) - 'A' + 10;
+		}
+		cmdline_mac[count] = val;
+	}
+	return 1;
+}
+__setup("emac_addr=", get_mac_addr_from_cmdline);
+
+/*
+ * Setup the MAC address for SoC ethernet devices.
+ *
+ * Before calling this function, the ethernet driver will have
+ * initialized the addr with local-mac-address from the device
+ * tree (if found). Allow command line to override, but not
+ * the fused address.
+ */
+int soc_mac_addr(unsigned int index, u8 *addr)
+{
+	int i, have_dt_mac = 0, have_cmdline_mac = 0, have_fuse_mac = 0;
+
+	for (i = 0; i < 6; i++) {
+		if (cmdline_mac[i])
+			have_cmdline_mac = 1;
+		if (c6x_fuse_mac[i])
+			have_fuse_mac = 1;
+		if (addr[i])
+			have_dt_mac = 1;
+	}
+
+	/* cmdline overrides all */
+	if (have_cmdline_mac)
+		memcpy(addr, cmdline_mac, 6);
+	else if (!have_dt_mac) {
+		if (have_fuse_mac)
+			memcpy(addr, c6x_fuse_mac, 6);
+		else
+			random_ether_addr(addr);
+	}
+
+	/* adjust for specific EMAC device */
+	addr[5] += index * c6x_num_cores;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(soc_mac_addr);
-- 
1.7.6.2

