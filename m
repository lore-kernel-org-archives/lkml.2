Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0IMGtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:49:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:40484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab0IMGtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,358,1280732400"; 
   d="scan'208";a="323825518"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@linux.intel.com, greg@kroah.com,
        Feng Tang <feng.tang@intel.com>, x86 maintainers <x86@kernel.org>
Subject: [PATCH v3 4/4] x86, earlyprintk: add hsu early console for Intel Medfield platform
Date: Mon, 13 Sep 2010 15:08:56 +0800
Message-Id: <1284361736-23011-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Medfield platform has a high speed UART device, which could act
as a early console. To enable early printk of HSU console, simply add
"earlyprintk=hsu" in kernel command line.

Currently we put the code in the early_printk_mrst.c as it is also for
Intel MID platforms like the mrst early console

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: x86 maintainers <x86@kernel.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h         |    3 +
 arch/x86/kernel/early_printk.c      |    6 ++
 arch/x86/kernel/early_printk_mrst.c |   89 ++++++++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index d0ea5bc..4a711a6 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -47,4 +47,7 @@ extern enum mrst_timer_options mrst_timer_options;
 
 extern struct console early_mrst_console;
 extern void mrst_early_console_init(void);
+
+extern struct console early_hsu_console;
+extern void hsu_early_console_init(void);
 #endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 6082463..4572f25 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -245,6 +245,12 @@ static int __init setup_early_printk(char *buf)
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
 		}
+
+		if (!strncmp(buf, "hsu", 3)) {
+			hsu_early_console_init();
+			early_console_register(&early_hsu_console, keep);
+		}
+
 #endif
 		buf++;
 	}
diff --git a/arch/x86/kernel/early_printk_mrst.c b/arch/x86/kernel/early_printk_mrst.c
index 05d27e1..65df603 100644
--- a/arch/x86/kernel/early_printk_mrst.c
+++ b/arch/x86/kernel/early_printk_mrst.c
@@ -1,5 +1,5 @@
 /*
- * early_printk_mrst.c - spi-uart early printk for Intel Moorestown platform
+ * early_printk_mrst.c - early consoles for Intel MID platforms
  *
  * Copyright (c) 2008-2010, Intel Corporation
  *
@@ -9,9 +9,19 @@
  * of the License.
  */
 
+/*
+ * This file implements two early consoles named mrst and hsu.
+ * mrst is based on Maxim3110 spi-uart device, it exists in both
+ * Moorestown and Medfield platforms, while hsu is based on a High
+ * Speed UART device which only exists in the Medfield platform
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/serial_mfd.h>
 #include <linux/kmsg_dump.h>
 #include <linux/console.h>
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/io.h>
 
@@ -230,3 +240,80 @@ struct console early_mrst_console = {
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
 };
+
+/*
+ * Following is the early console based on Medfield HSU (High
+ * Speed UART) device.
+ */
+#define HSU_PORT2_PADDR		0xffa28180
+
+static void __iomem *phsu;
+
+void hsu_early_console_init(void)
+{
+	u8 lcr;
+
+	phsu = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+							HSU_PORT2_PADDR);
+
+	/* Disable FIFO */
+	writeb(0x0, phsu + UART_FCR);
+
+	/* Set to default 115200 bps, 8n1 */
+	lcr = readb(phsu + UART_LCR);
+	writeb((0x80 | lcr), phsu + UART_LCR);
+	writeb(0x18, phsu + UART_DLL);
+	writeb(lcr,  phsu + UART_LCR);
+	writel(0x3600, phsu + UART_MUL*4);
+
+	writeb(0x8, phsu + UART_MCR);
+	writeb(0x7, phsu + UART_FCR);
+	writeb(0x3, phsu + UART_LCR);
+
+	/* Clear IRQ status */
+	readb(phsu + UART_LSR);
+	readb(phsu + UART_RX);
+	readb(phsu + UART_IIR);
+	readb(phsu + UART_MSR);
+
+	/* Enable FIFO */
+	writeb(0x7, phsu + UART_FCR);
+}
+
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+static void early_hsu_putc(char ch)
+{
+	unsigned int timeout = 10000; /* 10ms */
+	u8 status;
+
+	while (--timeout) {
+		status = readb(phsu + UART_LSR);
+		if (status & BOTH_EMPTY)
+			break;
+		udelay(1);
+	}
+
+	/* Only write the char when there was no timeout */
+	if (timeout)
+		writeb(ch, phsu + UART_TX);
+}
+
+static void early_hsu_write(struct console *con, const char *str, unsigned n)
+{
+	int i;
+
+	for (i = 0; i < n && *str; i++) {
+		if (*str == '\n')
+			early_hsu_putc('\r');
+		early_hsu_putc(*str);
+		str++;
+	}
+}
+
+struct console early_hsu_console = {
+	.name =		"earlyhsu",
+	.write =	early_hsu_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
-- 
1.7.0.4

